FROM amazonlinux:1
RUN yum update -y

# Install build dependencies
RUN yum install -y binutils cmake3 gcc make rpm-build system-rpm-config

RUN mkdir -p /usr/src/rpm/SOURCES /usr/src/rpm/SPECS
COPY v0.4.3.tar.gz /usr/src/rpm/SOURCES/
COPY SPECS/aws-c-common.spec /usr/src/rpm/SPECS/aws-c-common.spec
WORKDIR /usr/src/rpm/SPECS
RUN rpmbuild --define '_topdir /usr/src/rpm' -bb aws-c-common.spec
RUN rpmbuild --define '_topdir /usr/src/rpm' -bs aws-c-common.spec
VOLUME /export
