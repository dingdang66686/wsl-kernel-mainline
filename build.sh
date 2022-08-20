#!/bin/bash

# Requirements for Debian/Ubuntu
sudo apt install -y git bc build-essential flex bison libssl-dev libelf-dev dwarves
sudo apt install -y curl wget

# Requirements for openSUSE
#sudo zypper in -y -t pattern devel_basis
#sudo zypper in -y bc openssl openssl-devel dwarves rpm-build libelf-devel
#sudo zypper in -y curl jq wget

# Fail on errors.
set -e

git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git --depth=1
git clone https://github.com/microsoft/WSL2-Linux-Kernel/ --depth=1
cp WSL2-Linux-Kernel/Microsoft/config-wsl linux/.config

cd linux

cat ../append.config >> .config

#SECONDS=0
_start=$SECONDS

make olddefconfig
#make silentoldconfig
make -j$(nproc)

_elapsedseconds=$(( SECONDS - _start ))
TZ=UTC0 printf 'Kernel builded: %(%H:%M:%S)T\n' "$_elapsedseconds"
echo "Kernel build finished: $(date -u '+%H:%M:%S')"


