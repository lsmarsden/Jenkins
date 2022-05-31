#!/usr/bin/env bash

if [ -z "$1" ]
then
  echo "No architecture platform provided. Defaulting to arm64 (Apple Silicon)"
  arch=arm64
else
  arch=$1
fi

echo "Buiding image using architecture platform $arch"
# Assuming JAVA_HOME will be set to JDK 17 at the moment
docker build -t jenkins:jenkins-local --build-arg arch="$arch" .