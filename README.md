debian-base-image in a container
===============================

Overview
--------

This image may serve as a volume to other docker
images.

The vmlinuz and initrd files were created by:

    sudo apt-get install debootstrap initramfs-tools && \
        mkdir -p ~/tftpboot ~/tftpimages && \
        debootstrap stable ~/tftpboot http://ftp.us.debian.org/debian && \
        sed 's/MODULES=.*$/MODULES=netboot/' -i ~/tftpboot/etc/initramfs-tools/initramfs.conf && \
        echo "BOOT=nfs" >> ~/tftpboot/etc/initramfs-tools/initramfs.conf && \
        chroot ~/tftpboot update-initramfs -u && \
        cp /tftpboot/boot/initrd.img-*-amd64 ~/tftpimages && \
        cp /tftpboot/boot/vmlinuz-*-amd64 ~/tftpimages

### Build image with docker < 17.05

    docker build -f Dockerfile.singlestage -t lnls/debian-base-image .

### Build image with docker >= 17.05

    docker build -t lnls/debian-base-image .
