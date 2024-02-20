#!/bin/bash

#you can put this into a Dockerfile-build and copy files from it in Dockerfile if you'd prefer

set -e #exit on failure

mkdir --parents packages

BUILD_IMAGE=ubuntu:24.04
export PACKAGES='openjdk-17-jre-headless openjdk-17-jdk-headless'
export FILTER='^(libc[0-9-]*|zlib.*|libstdc\+\+[0-9]*|libgcc-.*|java-common.*)$'

docker run \
	--rm \
	--interactive \
	--tty \
	--volume=./packages:/packages \
	--env=PACKAGES \
	--env=FILTER \
	$BUILD_IMAGE \
	bash -c '
		set -e #exit on failure
		set -x #print command running
		apt update
		apt dist-upgrade --yes
		apt install --yes busybox-static
		cp --preserve $(which busybox) /packages
		
		cd /packages
		apt-get download $PACKAGES
		
		apt-cache depends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances $PACKAGES |
			awk "{print \$2}" |
			egrep "$FILTER" |
			sort |
			uniq |
			while read package; do
				apt-get download $package
			done
		
		#UGH busybox does not support zstd
		for file in /packages/*.deb; do
			mkdir /package-rebuild
			dpkg-deb --raw-extract $file /package-rebuild
			rm -f $file
			dpkg-deb -Zxz --build /package-rebuild $file
			rm -rf /package-rebuild
		done
'

docker build -t busybox .


