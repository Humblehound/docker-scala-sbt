# Docker, Scala and sbt Dockerfile

This repository contains **Dockerfile** with
[Docker](https://www.docker.com/),
[Java 8](https://openjdk.java.net/install/),
,[Scala](http://www.scala-lang.org) and [sbt](http://www.scala-sbt.org).

## Base Docker Image ##

This image is based on the official [docker](https://hub.docker.com/_/docker) image and is heavily influenced by [hseeberger/scala-sbt](https://github.com/hseeberger/scala-sbt) image. 

## Overview

There are multiple `sbt` plugins that allow you to build and publish docker images, but that requires a docker dependency.
I have not found a docker image that would have all of `java`, `scala`, `sbt` and `docker`, so I created my own.

So far I just published an image for my current needs with the tag `8u232_1.3.6_2.12.10`, that indicates `java`, `sbt` and `scala` versions respectfully. 
Please publish an MR or open an issue if you'd like a different configuration.  

##Example usage with Gitlab

sbt project configuration:

`plugins.sbt`:
```aidl
lazy val sbtDocker: ModuleID = "se.marcuslonnberg" % "sbt-docker" % "1.5.0"
lazy val sbtAssembly = "com.eed3si9n" % "sbt-assembly" % "0.14.5"

addSbtPlugin(sbtAssembly)
addSbtPlugin(sbtDocker)
```

`build.sbt`
```aidl
enablePlugins(DockerPlugin)
lazy val dockerSettings = Seq(
  dockerfile in docker := {
    // The assembly task generates a fat JAR file
    val artifact: File = assembly.value
    val artifactTargetPath = s"/app/${artifact.name}"

    new Dockerfile {
      from("adoptopenjdk/openjdk11-openj9:jdk-11.0.1.13-alpine-slim")
      add(artifact, artifactTargetPath)
      expose(8080)
      entryPoint("java", "-jar", artifactTargetPath)
    }
  }
```



**Gitlab CI**: `.gitlab.yml`
```aidl
image: "humblehound/docker-scala-sbt:8u232_1.3.6_2.12.10"

variables:
  DOCKER_HOST: tcp://docker:2375
  DOCKER_DRIVER: overlay2

stages:
  - docker

Docker:
  stage: docker
  services:
    - docker:dind
  variables:
    DOCKER_DRIVER: overlay
  script:
    - docker login -u _json_key -p "$GCLOUD_SERVICE_ACCOUNT_KEY" https://eu.gcr.io
    - sbt dockerBuildAndPush
```



## Contribution policy ##

Contributions via GitHub pull requests are gladly accepted from their original author. Along with any pull requests, please state that the contribution is your original work and that you license the work to the project under the project's open source license. Whether or not you state this explicitly, by submitting any copyrighted material via pull request, email, or other means you agree to license the material under the project's open source license and warrant that you have the legal authority to do so.

## License ##

This code is open source software licensed under the [Apache 2.0 License]("http://www.apache.org/licenses/LICENSE-2.0.html").
