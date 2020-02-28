# Vaadin Gradle Skeleton Starter Spring Boot

This project demoes the possibility of having Vaadin 14 project in npm+webpack
mode using Gradle and Spring Boot. Please see the [Vaadin Gradle Plugin Page](https://github.com/vaadin/vaadin-gradle-plugin)
for documentation.

Prerequisites:
* Java 8 or higher
* node.js and npm. You can either use the Vaadin Gradle plugin to install it for
  you (the `vaadinPrepareNode` task, handy for the CI), or you can install it to your OS:
  * Windows: [node.js Download site](https://nodejs.org/en/download/) - use the .msi 64-bit installer
  * Linux: `sudo apt install npm`
* Git
* (Optionally): Intellij Community

## Running With Spring Boot via Gradle In Development Mode

Run the following command in this repo:

```bash
./gradlew clean bootRun
```

Now you can open the [http://localhost:8080](http://localhost:8080) with your browser.

> If you do not have node.js installed locally, please run `./gradlew vaadinPrepareNode` once.
> The task will download a local node.js distribution to your project folder, into the `node/` folder.

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
./gradlew -Pvaadin.productionMode
```

That will build this app in production mode as a runnable jar archive; please find the
jar file in `build/libs/base-starter-spring-gradle*.jar`. You can run the JAR file
with:

```bash
cd build/libs/
java -jar base-starter-spring-gradle*.jar
```

Now you can open the [http://localhost:8080](http://localhost:8080) with your browser.

### Building In Production On CI

Usually the CI images will not have node.js+npm available. However, Vaadin Gradle Plugin
can download it for you. To build your app for production in CI, just run:

```bash
./gradlew clean vaadinPrepareNode build -Pvaadin.productionMode
```
