#!/bin/bash
cd /home/container
DISTRO_URL="https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04.5-base-amd64.tar.gz"
if [ ! -d "./rootfs" ] || [ -z "$(ls -A ./rootfs)" ]; then
    mkdir -p ./rootfs
    echo "--- Đang tải Distro về cho Pterodactyl... ---"
    curl -sSL "$DISTRO_URL" | tar -xzC ./rootfs || { echo "LỖI: Tải hoặc giải nén thất bại!"; exit 1; }
fi
if [ -d "./rootfs/etc" ]; then
    echo "nameserver 8.8.8.8" > ./rootfs/etc/resolv.conf
else
    echo "LỖI: Thư mục /etc không tồn tại trong rootfs!"
    exit 1
fi
echo "--- Khởi động môi trường PRoot ---"
exec proot -r ./rootfs -0 -w / \
    -b /dev -b /proc -b /sys \
    /usr/bin/env -i \
    HOME=/root TERM=$TERM PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    /bin/bash
