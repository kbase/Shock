# creates statically compiled shock-server binary: /go/bin/shock-server

FROM bitnami/minideb:jessie
MAINTAINER Steve Chan sychan@lbl.gov

RUN apt-get -y update && \
    apt-get -y install wget ca-certificates git make gcc libc-dev libsasl2-dev && \
    update-ca-certificates

# This build of shock seems to malfunction if we go above Go 1.5
RUN cd /usr/local && \
    wget https://storage.googleapis.com/golang/go1.5.4.linux-amd64.tar.gz && \
    tar xzf go1.5.4.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go

ENV GOPATH /tmp/goroot
RUN mkdir -p /kb/deployment/bin
RUN mkdir -p $GOPATH/src/github.com/MG-RAST  && \
    go get github.com/pborman/uuid  && \
    go get github.com/MG-RAST/golib  ; \
    go get github.com/MG-RAST/go-dockerclient  && \
    cd $GOPATH/src/github.com/MG-RAST  && \
    git clone --recursive https://github.com/kbase/Shock -b auth2  && \
    cp Shock/Makefile $GOPATH && cd $GOPATH && make version && \
    cd $GOPATH/src/github.com/MG-RAST/Shock/shock-server  && \
    go build  && \
    cp shock-server /kb/deployment/bin/ && \
    echo Shock server binary copied to /kb/deployment/bin



