#!/bin/bash

# Requirements for Debian/Ubuntu
sudo apt install -y git bc build-essential flex bison libssl-dev libelf-dev dwarves
sudo apt install -y curl jq wget

# Requirements for openSUSE
#sudo zypper in -y -t pattern devel_basis
#sudo zypper in -y bc openssl openssl-devel dwarves rpm-build libelf-devel
#sudo zypper in -y curl jq wget

# Fail on errors.
set -e

mkdir -p linux
pushd linux
rm -rf *linux-* v*

file_ext=".tar.gz"

if [[ -z $1 ]]; then
	linux_json="$(curl -s https://api.github.com/repos/torvalds/linux/tags | jq -r '.[0]')"
	linux_name="$(echo $linux_json | jq -r '.name')"
	# echo $linux_name | sed 's/$/.tar.gz/' | sed 's#^#https://github.com/torvalds/linux/archive/refs/tags/#' | wget -c -i -
	linux_url="$(echo $linux_json | jq -r '.tarball_url')"
else
	linux_tag=$1
	linux_name=linux-$linux_tag
	linux_url="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/snapshot/${linux_name}${file_ext}"
fi

file_name="${linux_name}${file_ext}"

curl -L -C - -o ${file_name} $linux_url

echo -n "Untar ${file_name}..."
tar -xf "$file_name"
echo ""

# find -maxdepth 1 -type d -name '*linux-*'
cd "$(find -maxdepth 1 -type d -regex '\.\/.*linux-.*')"

echo -n "Download Microsoft wsl config"
curl "https://github.com/microsoft/WSL2-Linux-Kernel/raw/linux-msft-wsl-5.15.y/Microsoft/config-wsl" -o .config
echo ""

#SECONDS=0
_start=$SECONDS

make olddefconfig
#make silentoldconfig
make -j$(nproc)

_elapsedseconds=$(( SECONDS - _start ))
TZ=UTC0 printf 'Kernel builded: %(%H:%M:%S)T\n' "$_elapsedseconds"
echo "Kernel build finished: $(date -u '+%H:%M:%S')"

popd

