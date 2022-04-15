# arm64 for Mac M1, amd64 otherwise
ARG arch
FROM --platform=linux/${arch} jenkins/jenkins:latest-jdk11

EXPOSE 8080
EXPOSE 50000