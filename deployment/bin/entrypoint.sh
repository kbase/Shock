#!/bin/bash
#
# This entrypoint script defaults to using environment variables to populate
# a jinja2 config template and writing out the config before starting the service
#

/usr/local/bin/j2 /kb/deployment/conf/.tenplates/shock-server.cfg.j2 > /kb/deployment/conf/shock-server.cfg && \
echo /kb/deployment/bin/shock-server --conf /kb/deployment/conf/shock-server.cfg