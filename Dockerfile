# arm64 for Mac M1, amd64 otherwise
ARG arch

# Install JDK 17 for linux
FROM oraclelinux:8 AS builder

RUN set -eux; \
	dnf install -y tar;

# Default to UTF-8 file.encoding
ENV LANG en_US.UTF-8

ENV JAVA_URL=https://download.oracle.com/java/17/latest \
	JAVA_HOME=/usr/java/jdk-17

RUN set -eux; \
	ARCH=$(uname -m) && \
	# Java uses just x64 in the name of the tarball
    if [ "$ARCH" == "x86_64" ]; \
        then ARCH="x64"; \
    fi && \
    JAVA_PKG="$JAVA_URL/jdk-17_linux-${ARCH}_bin.tar.gz" ; \
	JAVA_SHA256=$(curl "$JAVA_PKG".sha256) ; \
	curl --output /tmp/jdk.tgz "$JAVA_PKG" && \
	echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1


# Create the Jenkins image in this stage, and copy across JDK 17 from the previous stage
FROM --platform=linux/${arch} jenkins/jenkins:latest-jdk11

ENV JAVA_HOME=/usr/java/jdk-17
COPY --from=builder $JAVA_HOME $JAVA_HOME
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV CASC_JENKINS_CONFIG="/var/jenkins_home/jenkins-casc.yaml"
ENV MAVEN_VERSION="3.8.4"

COPY config/plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

COPY config/jenkins-casc.yaml /var/jenkins_home/jenkins-casc.yaml

EXPOSE 9000
EXPOSE 50000