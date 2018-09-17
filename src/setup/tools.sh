#!/usr/bin/env bash

set -xe

echo "Install tools"

apk update
# apk add apt-utils
apk upgrade
# apk dist-upgrade
apk add wget
