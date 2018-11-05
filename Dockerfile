FROM debian:9.4 as builder

LABEL \
      com.github.lnlssirius.docker.dockerfile="Dockerfile" \
      com.github.lnlssirius.vcs-type="Git" \
      com.github.lnlssirius.vcs-url="https://github.com/lnls-sirius/docker-debian-base-image.git"

ARG DEBIAN_FRONTEND=noninteractive

RUN echo "nameserver 10.0.0.71" >> /etc/resolv.conf && \
    apt-get -y update && \
    apt-get install -y \
        initramfs-tools \
        linux-image-4.9.0-7-amd64 \
        linux-headers-4.9.0-7-amd64 && \
    rm -rf /var/lib/apt/lists/*

RUN sed 's/MODULES=.*$/MODULES=netboot/' -i /etc/initramfs-tools/initramfs.conf && \
    echo "BOOT=nfs" >> etc/initramfs-tools/initramfs.conf && \
    mkdir -p /tftpboot/init && \
    update-initramfs -c -u -k 4.9.0-7-amd64

FROM debian:9.4

RUN mkdir -p /tftpboot/init

COPY --from=builder /boot/initrd.img-*-amd64 /tftpboot/init
COPY --from=builder /boot/vmlinuz-*-amd64 /tftpboot/init

VOLUME /tftpboot/init
