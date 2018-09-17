# Introduction

This project is based upon the official https://github.com/katalon-studio/docker-images and adds an Alpine Linux based Docker container image without ANY browsers to be used on CI/CD tools (such as Jenkins) and Selenium Grid based tools.

At this moment, image contains:

* Xvfb, Java SE Runtime Environment (OpenJDK);
* [Katalon Studio](https://hub.docker.com/r/katalonstudio/katalon/).

Versions of important packages is written in `/katalon/version` (or `$KATALON_VERSION_FILE`).

    cat $KATALON_VERSION_FILE
    Google Chrome 69.0.3497.81
    Mozilla Firefox 62.0
    Katalon Studio 5.7.0

# Katalon Studio image

The container started from this image will expect following environment variables:
* `KATALON_OPTS`: all Katalon Studio console mode arguments except `-runMode`, `-reportFolder`, and `-projectPath`. For more details as well as an easy way to generate all arguments please refer to [the documentation](https://docs.katalon.com/display/KD/Console+Mode+Execution).

The following bind mounts should be used:

| Container's directory     | Host's directory  | Writable? |
| ------------------------- | ----------------- | --------- |
| /katalon/katalon/source | project directory | No - the source code will be copied to a temporary directory inside the container, therefore no write access is needed. |
| /katalon/katalon/report | report directory  | Yes - Katalon Studio will write execution report to this directory. |

# Example

The following script will execute a project at current directory `$(pwd)` and write reports to `$(pwd)/report` (this directory must exist before execution). 

`Test Suites/Basic Tests with Chrome and Firefox` is a collection of tests which run in Selenium Grid.

    #!/usr/bin/env bash

    katalon_opts='-retry=0 -statusDelay=15 -testSuiteCollectionPath="Test Suites/Basic Test with Chrome e Firefox"'
    docker run --rm -v $(pwd):/katalon/katalon/source:ro -v $(pwd)/report:/katalon/katalon/report -e KATALON_OPTS="$katalon_opts" katalon-katalon