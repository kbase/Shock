#!/bin/bash
#
# This entrypoint script defaults to using environment variables to populate
# a jinja2 config template and writing out the config before starting the service
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
/usr/local/bin/j2 $DIR/../conf/.templates/shock-server.cfg.j2 > $DIR/../conf/shock-server.cfg && \
echo $DIR/shock-server --conf $DIR/../conf/shock-server.cfg