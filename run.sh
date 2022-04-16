#!/usr/bin/env bash

# Export creds from secrets file atm, will look to load from some secrets manager in JEN-5
source secrets/jenkins-secrets
if [ -z "$JENKINS_ADMIN_ID" ] || [ -z "$JENKINS_ADMIN_PASSWORD" ]
then
  echo "No jenkins credentials found in secrets/jenkins-secrets. Exiting container start process."
  exit 0
fi

docker run --rm -p 8080:8080 -v jenkins_home:/var/jenkins_home --name jenkins \
  --env JENKINS_ADMIN_ID="${JENKINS_ADMIN_ID}" --env JENKINS_ADMIN_PASSWORD="${JENKINS_ADMIN_PASSWORD}" \
  jenkins:jenkins-local