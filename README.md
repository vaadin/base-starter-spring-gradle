# Vaadin Gradle Skeleton Starter Spring Boot

This project demoes the possibility of having Vaadin 14 project in npm+webpack
mode using Gradle and Spring Boot.

Prerequisites:
* Java 8 or higher
* node.js and npm installed locally. You can simply install those:
  * Windows: [node.js Download site](https://nodejs.org/en/download/) - use the .msi 64-bit installer
  * Linux: `sudo apt install npm`
  * TODO what to do in the CI environment
* Git
* (Optionally): Intellij Community

> *Note*: this is an early preview which requires some extra steps to get the Vaadin
> Gradle Plugin. Soon the plugin will be deployed in the Gradle plugin repo which will
> simplify this tutorial radically.

## Installing Vaadin Gradle Plugin

Currently the Vaadin Gradle Plugin needs to be installed from sources. Please follow the
steps below to get it installed:

```bash
git clone https://github.com/vaadin/vaadin-gradle-plugin
cd vaadin-gradle-plugin
git checkout feature/18
```

Edit the `/build.gradle` file: at line 43 change the line from

```
version = project.hasProperty('BUILD_VERSION') //... yadda yadda
```

to

```
version = '0.0.1'
```

Now run:

```bash
./gradlew clean publishToMavenLocal -x test
```

The command will fail, BUT there will be a jar file installed in your local Maven repository:

```
$HOME/.m2/repository/com/vaadin/vaadin-gradle-plugin/0.0.1/vaadin-gradle-plugin-0.0.1.jar
```

The Vaadin Gradle Plugin is now ready to be used.

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

Simply run the following command in this repo:

```bash
./gradlew
```

That will build this app in production mode as a runnable jar archive; please find the
jar file in `build/libs/skeleton-starter-spring-boot-gradle*.jar`. You can run the JAR file
simply by using java:

```bash
cd build/libs/
java -jar skeleton-starter-spring-boot-gradle*.jar
```

Now you can open the [http://localhost:8080](http://localhost:8080) with your browser.
