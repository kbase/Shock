# creates statically compiled shock-server binary: /go/bin/shock-server

FROM bitnami/minideb:jessie
MAINTAINER Steve Chan sychan@lbl.gov

ARG BUILD_DATE
ARG VCS_REF

RUN apt-get -y update && \
    apt-get -y install wget ca-certificates git make gcc libc-dev libsasl2-dev && \
    update-ca-certificates

# This build of shock seems to malfunction if we go above Go 1.5
RUN cd /usr/local && \
    wget https://storage.googleapis.com/golang/go1.5.4.linux-amd64.tar.gz && \
    tar xzf go1.5.4.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go

ENV GOPATH /tmp/goroot

RUN mkdir -p /kb/deployment/bin /kb/deployment/conf && \
    mkdir -p /mnt/shock/site /mnt/shock/data /mnt/shock/logs && \
    mkdir -p $GOPATH/src/github.com/MG-RAST  && \
    go get github.com/pborman/uuid  && \
    go get github.com/MG-RAST/golib  ; \
    go get github.com/MG-RAST/go-dockerclient  && \
    cd $GOPATH/src/github.com/MG-RAST  && \
    git clone --recursive https://github.com/kbase/Shock -b auth2 && \
    cp Shock/Makefile $GOPATH && cd $GOPATH && make version && \
    cd $GOPATH/src/github.com/MG-RAST/Shock/shock-server  && \
    go build  && \
    cp shock-server /kb/deployment/bin/ && \
    echo Shock server binary copied to /kb/deployment/bin

COPY shock-server.cfg /kb/deployment/conf/

# The BUILD_DATE value seem to bust the docker cache when the timestamp changes, move to
# the end
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/kbase/Shock.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

ENTRYPOINT [ "/kb/deployment/bin/shock-server", "--conf", "/kb/deployment/conf/shock-server.cfg" ]

