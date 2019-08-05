#!/bin/bash -ex
ARCH=$(uname -m)
PACKAGE=aws-c-common
VERSION=0.4.3
REL=0
DOWNLOAD_URL="https://github.com/awslabs/aws-c-common/archive/v$VERSION.tar.gz"
EXPORT=$(realpath $(dirname $0))/export

if [[ ! -f v$VERSION.tar.gz ]]; then
    curl -s -o v$VERSION.tar.gz "$DOWNLOAD_URL"
fi

for TARGET in amzn1 el7; do
	docker build -t build-${PACKAGE}:$TARGET -f $TARGET.dockerfile .
	rm -rf $EXPORT/$TARGET
	mkdir -p $EXPORT/$TARGET/SRPMS $EXPORT/$TARGET/RPMS/$ARCH
	docker run --rm --volume $EXPORT/${TARGET}:/export build-${PACKAGE}:$TARGET \
	  /bin/sh -c "cp /usr/src/rpm/SRPMS/* /export/SRPMS && cp /usr/src/rpm/RPMS/$ARCH/* /export/RPMS/$ARCH/"
done;
