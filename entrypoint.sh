#!/bin/sh

ROOTFS_DIR=/home/container/rootfs
PROOT_VERSION="5.3.0"

ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
  ARCH_ALT="x86_64"
elif [ "$ARCH" = "aarch64" ]; then
  ARCH_ALT="aarch64"
else
  echo "Unsupported architecture"
  exit 1
fi

mkdir -p $ROOTFS_DIR

# Download Ubuntu rootfs nếu chưa có
if [ ! -f "$ROOTFS_DIR/.installed" ]; then
  echo "Downloading Ubuntu Base..."
  curl -L https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04.5-base-amd64.tar.gz \
  | tar -xz -C $ROOTFS_DIR

  echo "nameserver 1.1.1.1" > $ROOTFS_DIR/etc/resolv.conf

  touch $ROOTFS_DIR/.installed
fi

# Download proot static nếu chưa có
if [ ! -f "./proot" ]; then
  curl -Lo ./proot \
  https://github.com/proot-me/proot/releases/download/v${PROOT_VERSION}/proot-v${PROOT_VERSION}-${ARCH}-static
  chmod +x ./proot
fi

echo "Starting Ubuntu PRoot..."

exec ./proot \
--rootfs="$ROOTFS_DIR" \
--link2symlink \
--kill-on-exit \
--root-id \
--cwd=/root \
--bind=/proc \
--bind=/dev \
--bind=/sys \
--bind=/tmp \
/bin/bash
