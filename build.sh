#!/bin/bash

VERSION=1.3.4
BUILD_DIR=jsvc
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
if [ ! -d commons-daemon-${VERSION}-src ] ; then
	curl -LO https://dlcdn.apache.org//commons/daemon/source/commons-daemon-${VERSION}-src.tar.gz
	tar zxvf commons-daemon-${VERSION}-src.tar.gz
fi
pushd commons-daemon-${VERSION}-src/src/native/unix/
sh support/buildconf.sh
./configure
make
popd
if [ -d ${BUILD_DIR} ] ; then
	rm -rf ${BUILD_DIR}
fi

mkdir -p ${BUILD_DIR}/usr/bin
mkdir -p ${BUILD_DIR}/usr/share/doc/jsvc
cp ./commons-daemon-${VERSION}-src/src/native/unix/jsvc ${BUILD_DIR}/usr/bin
cp ./commons-daemon-${VERSION}-src/*.txt ${BUILD_DIR}/usr/share/doc/jsvc 
mkdir -p ${BUILD_DIR}/DEBIAN
cat <<EOF > ${BUILD_DIR}/DEBIAN/control
Package: jsvc
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: arm64
Maintainer: geoff@declarativesystems.com
Description: jsvc binary for arm64 (unofficial)
Homepage: https://github.com/GeoffWilliams/jsvc-arm
EOF
dpkg-deb --root-owner-group --build jsvc
mv jsvc.deb jsvc-${VERSION}_arm64.deb
