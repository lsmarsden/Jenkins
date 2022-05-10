#!/usr/bin/env bash

# Export creds from secrets file atm, will look to load from some secrets manager in JEN-5
source secrets/jenkins-secrets
if [ -z "$JENKINS_ADMIN_ID" ] || [ -z "$JENKINS_ADMIN_PASSWORD" ]
then
  echo "No jenkins credentials found in secrets/jenkins-secrets. Exiting container start process."
  exit 0
fi

if [ -z "$1" ]
then
  echo "No Jenkins job repo provided. Defaulting to 'jenkins-jobs'"
  JENKINS_JOBS_REPO=jenkins-jobs
else
  echo "Starting Jenkins with seed job repo: $1"
  JENKINS_JOBS_REPO=$1
fi

docker run --rm -p 9000:8080 -v /var/jenkins_home --name jenkins \
  --env JENKINS_ADMIN_ID="${JENKINS_ADMIN_ID}" --env JENKINS_ADMIN_PASSWORD="${JENKINS_ADMIN_PASSWORD}" \
  --env JENKINS_USER_ID="${JENKINS_USER_ID}" --env JENKINS_USER_PASSWORD="${JENKINS_USER_PASSWORD}" \
  --env JENKINS_JOBS_REPO="${JENKINS_JOBS_REPO}" \
  jenkins:jenkins-local