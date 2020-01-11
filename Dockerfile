FROM docker:latest

ARG sbt_version=1.3.6
ARG sbt_home=/usr/local/sbt

RUN apk add --no-cache --update bash openjdk8-jre wget

RUN mkdir -pv "$sbt_home"
RUN wget -qO - "https://github.com/sbt/sbt/releases/download/v$sbt_version/sbt-$sbt_version.tgz" >/tmp/sbt.tgz
RUN tar xzf /tmp/sbt.tgz -C "$sbt_home" --strip-components=1
RUN ln -sv "$sbt_home"/bin/sbt /usr/bin/

RUN sbt sbtVersion