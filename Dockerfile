FROM debian:stretch as builder

LABEL \
      com.github.lnlsdig.docker.dockerfile="Dockerfile" \
      com.github.lnlsdig.vcs-type="Git" \
      com.github.lnlsdig.vcs-url="https://github.com/lnls-dig/docker-debian-base-image.git"

ARG DEBIAN_FRONTEND=noninteractive

RUN echo "nameserver 10.0.0.71" > /etc/resolv.conf && \
    apt-get -y update && \
    apt-get install -y \
        initramfs-tools \
        linux-image-amd64 \
        linux-headers-amd64 && \
    rm -rf /var/lib/apt/lists/*

RUN sed 's/MODULES=.*$/MODULES=netboot/' -i /etc/initramfs-tools/initramfs.conf && \
    echo "BOOT=nfs" >> etc/initramfs-tools/initramfs.conf && \
    mkdir -p /tftpboot/init && \
    update-initramfs -c -k `uname -r`

FROM debian:stretch

RUN mkdir -p /tftpboot/init

COPY --from=builder /boot/initrd.img-*-amd64 /tftpboot/init
COPY --from=builder /boot/vmlinuz-*-amd64 /tftpboot/init

VOLUME /tftpboot/init
