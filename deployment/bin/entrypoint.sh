#!/bin/bash -x
#
# This entrypoint script defaults to using environment variables to populate
# a jinja2 config template and writing out the config before starting the service
#
# First parameter is either a file path to 

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Default config template
TEMPLATE=$DIR/../conf/.templates/shock-server.cfg.j2

# Default data source is empty, resulting in env variables being used
DATA_SRC=""

# If we have a first argument see if it is a file else treat a URL
if [ "$1" ] ; then
    if [ -r $1 ] ; then
        DATA_SRC=$1
    else
        TMPDIR=/tmp/data$$
        mkdir $TMPDIR
        pushd $TMPDIR
        http --verify=no --download $1 || exit 1
        popd
        DATA_SRC=$TMPDIR/*
    fi
fi

# If we are given a second parameter treat it as a template file path or
# a URL
if [ "$2" ] ; then
    if [ -r $2 ]; then
        TEMPLATE=$2
    else
        TMPDIR2=/tmp/template$$
        mkdir $TMPDIR2
        pushd $TMPDIR2
        http --verify=no --download $2 || exit 1
        popd
        TEMPLATE=$TMPDIR/*
    fi
fi

/usr/local/bin/j2 $TEMPLATE $DATA_SRC > $DIR/../conf/shock-server.cfg && \
$DIR/shock-server --conf $DIR/../conf/shock-server.cfg
