FROM ubuntu:disco
ARG VERSION
ARG REL
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y

# Install build dependencies
RUN apt install -y binutils build-essential cmake debhelper dh-make gcc make
RUN mkdir /build
COPY v${VERSION}.tar.gz /build/aws-c-common_${VERSION}.orig.tar.gz
WORKDIR /build
RUN tar xf aws-c-common_${VERSION}.orig.tar.gz
RUN mv aws-c-common-${VERSION} aws-c-common_${VERSION}-${REL}
COPY debian /build/aws-c-common_${VERSION}-${REL}/debian/
RUN sed -e "s/@VERSION@/${VERSION}/g" \
    /build/aws-c-common_${VERSION}-${REL}/debian/substvars.in \
    > /build/aws-c-common_${VERSION}-${REL}/debian/substvars
WORKDIR /build/aws-c-common_${VERSION}-${REL}
RUN dpkg-checkbuilddeps
RUN dpkg-buildpackage
VOLUME /export
