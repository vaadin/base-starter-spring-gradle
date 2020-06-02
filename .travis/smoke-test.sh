#!/bin/bash
set -ev

echo Trying out development mode

./gradlew clean vaadinPrepareFrontend

if grep -q '"productionMode": false' build/vaadin-generated/META-INF/VAADIN/config/flow-build-info.json; then
    echo Development mode is properly on
else
	echo "Production mode is off although in development mode" >&2
	exit 1
fi

echo Building production war file

./gradlew clean build -Pvaadin.productionMode

if grep -q '"productionMode": true' build/vaadin-generated/META-INF/VAADIN/config/flow-build-info.json; then
  echo Production mode is on
else
	echo "Production mode is off although in development mode" >&2
	exit 1
fi

if test -f build/libs/base-starter-spring-gradle-0.0.1-SNAPSHOT.jar; then
	echo "JAR file exists"
else
	echo "JAR file not built!" >&2
	exit 1
fi

# TODO run web app and check that 200 is returned from root

echo "Smoke test passed"

### 
