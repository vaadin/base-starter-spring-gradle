# Vaadin Gradle Skeleton Starter Spring Boot

This project demoes the possibility of having Vaadin 14 project in npm+webpack
mode using Gradle and Spring Boot.

Prerequisites:
* Java 8 or higher
* node.js and npm installed locally. To install:
  * Windows/Mac: [node.js Download site](https://nodejs.org/en/download/)
  * Linux: Use package manager e.g. `sudo apt install npm` 
* Git
* (Optionally): Intellij Community

> *Note*: this is an early preview which requires some extra steps to get the Vaadin
> Gradle Plugin. Soon the plugin will be deployed in the Gradle plugin repo which will
> simplify this tutorial radically.

## Installing Vaadin Gradle Plugin

Currently the Vaadin Gradle Plugin is still in early phases. This project uses a pre-release repository with the latest pre-release build, but you might want to customise the plugin your self. With following steps you'll get a local version of it built and to be used by this project:

```bash
git clone https://github.com/vaadin/vaadin-gradle-plugin
cd vaadin-gradle-plugin
```

Now run:

```bash
./gradlew clean publishToMavenLocal -x test -PBUILD_VERSION=0.0.1
```

The command will fail, BUT there will be a jar file installed in your local Maven repository:

```
$HOME/.m2/repository/com/vaadin/vaadin-gradle-plugin/0.0.1/vaadin-gradle-plugin-0.0.1.jar
```

Edit the build.gradle file in this project and adjust the plugin version to be 0.0.1.

Your custom build of Vaadin Gradle Plugin is now ready to be used.

## Running With Spring Boot via Gradle In Development Mode

Run the following command in this repo:

```bash
./gradlew clean vaadinPrepareFrontend bootRun
```

Now you can open the [http://localhost:8080](http://localhost:8080) with your browser.

## Running With Spring Boot from your IDE In Development Mode

Run the following command in this repo, to create necessary Vaadin config files:

```bash
./gradlew clean vaadinPrepareFrontend
```

The `build/vaadin-generated/` folder will now contain proper configuration files.

Open the `DemoApplication` class, and Run/Debug its main method from your IDE.

Now you can open the [http://localhost:8080](http://localhost:8080) with your browser.

## Building In Production Mode

Run the following command in this repo:

```bash
./gradlew
```

That will build this app in production mode as a runnable jar archive; please find the
jar file in `build/libs/base-starter-spring-gradle*.jar`. You can run the JAR file
with:

```bash
cd build/libs/
java -jar base-starter-spring-gradle*.jar
```

Now you can open the [http://localhost:8080](http://localhost:8080) with your browser.
