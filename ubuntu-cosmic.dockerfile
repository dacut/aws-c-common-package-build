FROM ubuntu:cosmic
RUN apt update -y

# Install build dependencies
RUN apt install -y binutils build-essential cmake debhelper dh-make gcc make
RUN mkdir /build
COPY v0.4.3.tar.gz /build/aws-c-common_0.4.3.orig.tar.gz
WORKDIR /build
RUN tar xf aws-c-common_0.4.3.orig.tar.gz
RUN mv aws-c-common-0.4.3 aws-c-common_0.4.3-0
COPY debian /build/aws-c-common_0.4.3-0/debian/
WORKDIR /build/aws-c-common_0.4.3-0
RUN dpkg-checkbuilddeps
RUN dpkg-buildpackage
VOLUME /export
