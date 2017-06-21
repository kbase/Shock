#!/bin/bash -x

export BRANCH=${TRAVIS_BRANCH:-`git symbolic-ref --short HEAD`}
export DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
export COMMIT=${TRAVIS_COMMIT:-`git rev-parse --short HEAD`}
docker run -v `pwd`/deployment:/kb/deployment \
		   -v `pwd`/build_shock_binary.sh:/tmp/build_shock_binary.sh \
	       -e COMMIT=$COMMIT kbase/kb_go /tmp/build_shock_binary.sh && \
docker build --build-arg BUILD_DATE=$DATE \
     		 --build-arg VCS_REF=$COMMIT \
			 --build-arg BRANCH=$BRANCH \
             -t kbase/kb_shock:$COMMIT .
