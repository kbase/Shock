#!/bin/bash -x
# This script is intended to be run as a docker volume mount in
# /kb/deployment/bin
# Build the Shock executable and copy it into the /kb/deployment/bin directory
# This script expects that the environment variable COMMIT be a git commit hash
# that represents the commit within the Shock repo to build

export GOPATH=/tmp/goroot
DEST=`pwd`

mkdir -p $GOPATH/src/github.com/MG-RAST && \
go get github.com/pborman/uuid && \
go get github.com/MG-RAST/golib || \
go get github.com/MG-RAST/go-dockerclient && \
cd $GOPATH/src/github.com/MG-RAST && \
git clone --recursive https://github.com/kbase/Shock && \
pushd Shock && \
git checkout $COMMIT && \
popd && \
cp Shock/Makefile $GOPATH && \
cd $GOPATH && \
make version && \
cd $GOPATH/src/github.com/MG-RAST/Shock/shock-server && \
go build && \
cp shock-server /kb/deployment/bin/ && \
echo Shock server binary copied to /kb/deployment/bin
