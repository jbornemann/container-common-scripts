#!/bin/bash -e
# This script is used to test the OpenShift Docker images.
#
# TEST_MODE - If set, run regular test suite
# TEST_OPENSHIFT_MODE - If set, run OpenShift tests (if present)
# VERSIONS - Must be set to a list with possible versions (subdirectories)

for dir in ${VERSIONS}; do
  pushd ${dir} > /dev/null
  IMAGE_ID=$(cat .image-id)
  name=$(docker inspect -f "{{.Config.Labels.name}}" $IMAGE_ID)
  IMAGE_NAME=$name"-candidate"

  if [[ -v TEST_MODE ]]; then
    VERSION=$dir IMAGE_NAME=${IMAGE_NAME} test/run
  fi

  if [[ -v TEST_OPENSHIFT_MODE ]]; then
    if [[ -x test/run-openshift ]]; then
      VERSION=$dir IMAGE_NAME=${IMAGE_NAME} test/run-openshift
    else
      echo "-> OpenShift tests are not present, skipping"
    fi
  fi

  popd > /dev/null
done
