#!/bin/bash
#
# Reproducer for https://github.com/vaadin/flow/issues/15458
#
# "vaadinBuildFrontend irregularly failing with ZipException:
#  ZipFile invalid LOC header (bad signature)"
#
# Root cause: FrontendDependencies.visitClass() resolves class resources
# through a URLClassLoader. For classes inside jars (e.g. sibling module
# jars in a multi-module project), url.openStream() goes through
# JarURLConnection → JarFileFactory, which has a JVM-global static cache.
#
# In the Gradle daemon, the JVM persists across builds. The URLClassLoader
# created by ReflectionsClassFinder is never explicitly closed. Its cached
# JarFile handles linger in JarFileFactory. When Gradle recompiles a
# sibling module and rewrites its jar in-place, the stale cached JarFile
# has a central directory pointing to offsets in the OLD file content.
# Reading at those offsets from the REWRITTEN file yields garbage
# → ZipException: ZipFile invalid LOC header (bad signature).
#
# This is intermittent because if GC collects the old URLClassLoader
# between runs, the stale JarFile is closed and evicted from the cache.
#
# Prerequisites:
#   - Multi-module project (so user classes end up in jars on the classpath)
#   - Gradle daemon enabled (JVM-level static cache must persist)
#   - Source changes in sibling module between runs (triggers jar rewrite)
#
# This script runs builds in rapid succession to minimize GC opportunity
# between runs, maximizing the chance of hitting the stale cache.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

LIB_SOURCE="lib/src/main/java/com/example/lib/SharedComponent.java"
MAX_ATTEMPTS=50
FOUND=0

echo "=== Stopping any existing Gradle daemon ==="
./gradlew --stop 2>/dev/null || true

echo ""
echo "=== Initial clean build (warm up daemon, populate JarFile cache) ==="
./gradlew clean vaadinBuildFrontend -Pvaadin.productionMode --no-build-cache -q 2>&1
echo "Initial build succeeded."

echo ""
echo "=== Starting rapid rebuild loop (up to $MAX_ATTEMPTS attempts) ==="
echo "Each iteration modifies the lib module source, forcing jar rewrite."
echo ""

for i in $(seq 1 $MAX_ATTEMPTS); do
    # Modify the lib source to force recompilation and jar rewrite.
    # The change must be meaningful enough that the compiler produces
    # a different .class file, causing the jar content to differ.
    sed -i "s/super(\"From lib v[0-9]*\")/super(\"From lib v$i\")/" "$LIB_SOURCE"

    # Run the build. Gradle will:
    #   1. Recompile lib → rewrite lib/build/libs/lib.jar in-place
    #   2. Run vaadinBuildFrontend → scan classpath including lib.jar
    #
    # If the JarFileFactory still has a stale JarFile from the previous
    # iteration (old URLClassLoader not yet GC'd), url.openStream() on
    # a class inside lib.jar returns data at stale offsets → ZipException
    OUTPUT=$(./gradlew vaadinBuildFrontend -Pvaadin.productionMode --no-build-cache 2>&1) && BUILD_RC=0 || BUILD_RC=$?

    if echo "$OUTPUT" | grep -qi "invalid LOC header\|bad signature\|broken class"; then
        echo ">>> BUG REPRODUCED on attempt $i <<<"
        echo ""
        echo "$OUTPUT" | grep -i "invalid LOC header\|bad signature\|broken class\|ZipException\|Visiting class"
        FOUND=1
        break
    fi

    if [ $BUILD_RC -ne 0 ]; then
        echo "Attempt $i: build failed with exit code $BUILD_RC (but not the expected ZipException)"
        echo "$OUTPUT" | tail -5
        # Don't break — other failures might be transient
    else
        echo "Attempt $i: build succeeded (stale cache was likely evicted by GC)"
    fi
done

if [ $FOUND -eq 0 ]; then
    echo ""
    echo "Could not reproduce in $MAX_ATTEMPTS attempts."
    echo "The bug is intermittent — it depends on GC not collecting the old"
    echo "URLClassLoader between builds. Try:"
    echo "  - Increasing heap: org.gradle.jvmargs=-Xmx4g in gradle.properties"
    echo "  - Running reproduce-concurrent.sh instead (simulates IDE + CLI)"
fi

# Restore the lib source
sed -i "s/super(\"From lib v[0-9]*\")/super(\"From lib v1\")/" "$LIB_SOURCE"
