#!/bin/bash
#
# Concurrent reproducer for https://github.com/vaadin/flow/issues/15458
#
# This simulates the scenario where an IDE (IntelliJ) triggers Gradle
# compilation in the background while the CLI runs vaadinBuildFrontend.
#
# Terminal 1 (this script): repeatedly recompiles the lib module,
# rewriting lib.jar while the frontend build is scanning it.
#
# This creates a genuine race condition: the lib.jar is being written
# while FrontendDependencies.visitClass() reads from it via
# JarURLConnection. Even without the JarFileFactory caching issue,
# reading a partially written jar produces ZipException.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

LIB_SOURCE="lib/src/main/java/com/example/lib/SharedComponent.java"
MAX_ATTEMPTS=30
FOUND=0

echo "=== Stopping any existing Gradle daemon ==="
./gradlew --stop 2>/dev/null || true

echo ""
echo "=== Initial clean build ==="
./gradlew clean vaadinBuildFrontend -Pvaadin.productionMode --no-build-cache -q 2>&1
echo "Initial build succeeded."

echo ""
echo "=== Starting concurrent reproduction ==="
echo "A background loop recompiles the lib module every 0.5s."
echo "The foreground runs vaadinBuildFrontend repeatedly."
echo ""

# Background: continuously recompile lib module to rewrite lib.jar
(
    COUNTER=0
    while true; do
        COUNTER=$((COUNTER + 1))
        sed -i "s/super(\"From lib v[0-9]*\")/super(\"From lib v$COUNTER\")/" "$LIB_SOURCE"
        ./gradlew :lib:jar --no-build-cache -q 2>/dev/null || true
        sleep 0.5
    done
) &
BG_PID=$!

cleanup() {
    kill "$BG_PID" 2>/dev/null || true
    wait "$BG_PID" 2>/dev/null || true
    # Restore the lib source
    sed -i "s/super(\"From lib v[0-9]*\")/super(\"From lib v1\")/" "$LIB_SOURCE"
}
trap cleanup EXIT

# Give the background loop a moment to start
sleep 2

for i in $(seq 1 $MAX_ATTEMPTS); do
    # Modify something in the main module too, to ensure vaadinBuildFrontend re-runs
    sed -i "s/super(\"From lib v[0-9]*\")/super(\"From lib v$((i * 1000))\")/" "$LIB_SOURCE"

    OUTPUT=$(./gradlew vaadinBuildFrontend -Pvaadin.productionMode --no-build-cache 2>&1) && BUILD_RC=0 || BUILD_RC=$?

    if echo "$OUTPUT" | grep -qi "invalid LOC header\|bad signature\|broken class"; then
        echo ">>> BUG REPRODUCED on attempt $i <<<"
        echo ""
        echo "$OUTPUT" | grep -i "invalid LOC header\|bad signature\|broken class\|ZipException\|Visiting class"
        FOUND=1
        break
    fi

    if [ $BUILD_RC -ne 0 ]; then
        echo "Attempt $i: build failed (rc=$BUILD_RC), but not the expected ZipException"
        echo "$OUTPUT" | tail -3
    else
        echo "Attempt $i: build succeeded"
    fi
done

if [ $FOUND -eq 0 ]; then
    echo ""
    echo "Could not reproduce in $MAX_ATTEMPTS attempts."
fi
