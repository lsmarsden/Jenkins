# arm64 for Mac M1, amd64 otherwise
ARG arch
FROM --platform=linux/${arch} jenkins/jenkins:latest-jdk11

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV CASC_JENKINS_CONFIG="/var/jenkins_home/jenkins-casc.yaml"
ENV MAVEN_VERSION="3.8.4"

COPY config/plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

COPY config/jenkins-casc.yaml /var/jenkins_home/jenkins-casc.yaml

EXPOSE 9000
EXPOSE 50000