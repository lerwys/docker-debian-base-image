FROM ubuntu:xenial

LABEL \
      com.github.lnlsdig.docker.dockerfile="Dockerfile" \
      com.github.lnlsdig.vcs-type="Git" \
      com.github.lnlsdig.vcs-url="https://github.com/lnls-dig/docker-debian-base-image.git"

ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /tftpboot
COPY data/initrd.img-4.9.0-4-amd64 /tftpboot
COPY data/vmlinuz-4.9.0-4-amd64 /tftpboot
