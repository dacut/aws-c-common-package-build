FROM amazonlinux:1
ARG VERSION
ARG REL
ARG REGION=us-west-2
ARG TIMEOUT=30

# Reconfigure yum settings.
RUN sed -e "s/timeout=.*/timeout=$TIMEOUT/" /etc/yum.conf > /etc/yum.conf.new
RUN mv /etc/yum.conf.new /etc/yum.conf
RUN echo $REGION > /etc/yum/vars/awsregion

# Update system libraries
RUN yum update -y

# Install build dependencies
RUN yum install -y binutils cmake3 gcc make rpm-build system-rpm-config

# The actual build
RUN mkdir -p /usr/src/rpm/SOURCES /usr/src/rpm/SPECS
COPY v${VERSION}.tar.gz /usr/src/rpm/SOURCES/
COPY SPECS/aws-c-common.spec /usr/src/rpm/SPECS/aws-c-common.spec
WORKDIR /usr/src/rpm/SPECS
RUN rpmbuild --define '_topdir /usr/src/rpm' --define "version $VERSION" \
    --define "rel $REL" -bb aws-c-common.spec
RUN rpmbuild --define '_topdir /usr/src/rpm' --define "version $VERSION" \
    --define "rel $REL" -bs aws-c-common.spec
VOLUME /export
