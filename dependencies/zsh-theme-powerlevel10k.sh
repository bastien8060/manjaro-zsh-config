#!/bin/bash

# Maintainer: Mark Wagie <mark at manjaro dot org>
# Contributor: Christian Rebischke <chris.rebischke@archlinux.org>
# Contributor: Jeff Henson <jeff@henson.io>
# Contributor: Ron Asimi <ron dot asimi at gmail dot com>
# Contributor: Roman Perepelitsa <roman.perepelitsa@gmail.com>

set -e

# Package details
PKGNAME=zsh-theme-powerlevel10k
PKGVER=1.20.0
LIBGIT2VER="tag-2ecf33948a4df9ef45a66c68b8ef24a5e60eaac6"
PKGREL=2
PKGDESC="Powerlevel10k is a theme for Zsh. It emphasizes speed, flexibility and out-of-the-box experience."
URL='https://github.com/romkatv/powerlevel10k'
LICENSE='MIT'
COMMIT=35833ea15f14b71dbcebc7e54c104d8d56ca5268

# Source URLs
SOURCE=(
    "https://github.com/romkatv/powerlevel10k.git#commit=${COMMIT}"
    "https://github.com/romkatv/libgit2/archive/${LIBGIT2VER}.tar.gz"
)

# SHA256 checksums
SHA256SUMS=(
    'SKIP'
    '4ce11d71ee576dbbc410b9fa33a9642809cc1fa687b315f7c23eeb825b251e93'
)

# Dependencies
DEPENDENCIES=(
    zsh
    git
    cmake
)

# Install dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y "${DEPENDENCIES[@]}"

# Clone and checkout the repository
echo "Cloning and checking out repository..."
rm -rf "${SOURCE[0]%.git*}.git"
git clone "${SOURCE[0]%.git*}.git"
cd powerlevel10k
git checkout "${COMMIT}"
cd ..

# Download and extract libgit2
echo "Downloading and extracting libgit2..."
wget -O "libgit2-${LIBGIT2VER}.tar.gz" "${SOURCE[1]}"
echo "${SHA256SUMS[1]}  libgit2-${LIBGIT2VER}.tar.gz" | sha256sum -c -
tar -xzf "libgit2-${LIBGIT2VER}.tar.gz"

# Build libgit2
echo "Building libgit2..."
cd "libgit2-${LIBGIT2VER}"
cmake -DCMAKE_BUILD_TYPE=None -DZERO_NSEC=ON -DTHREADSAFE=ON -DUSE_BUNDLED_ZLIB=ON -DREGEX_BACKEND=builtin -DUSE_HTTP_PARSER=builtin -DUSE_SSH=OFF -DUSE_HTTPS=OFF -DBUILD_CLAR=OFF -DUSE_GSSAPI=OFF -DUSE_NTLMCLIENT=OFF -DBUILD_SHARED_LIBS=OFF -DENABLE_REPRODUCIBLE_BUILDS=ON -Wno-dev .
make
cd ..

# Build gitstatus
echo "Building gitstatus..."
cd powerlevel10k/gitstatus
export CXXFLAGS+=" -I$(pwd)/../../libgit2-${LIBGIT2VER}/include -DGITSTATUS_ZERO_NSEC -D_GNU_SOURCE"
export LDFLAGS+=" -L$(pwd)/../../libgit2-${LIBGIT2VER}"
make
cd ../..

# Install files
echo "Installing files..."
sudo install -d /usr/share/${PKGNAME}
cd powerlevel10k
sudo find . -type f -exec install -D '{}' "/usr/share/${PKGNAME}/{}" ';'
sudo install -d /usr/share/licenses/${PKGNAME}
rm /usr/share/licenses/${PKGNAME}/LICENSE
sudo ln -s "/usr/share/${PKGNAME}/LICENSE" "/usr/share/licenses/${PKGNAME}/LICENSE"

# Delete unnecessary files
echo "Deleting unnecessary files..."
cd /usr/share/${PKGNAME}
sudo rm -rf gitstatus/obj gitstatus/.gitignore gitstatus/.gitattributes gitstatus/src gitstatus/build gitstatus/deps gitstatus/Makefile gitstatus/mbuild .gitattributes .gitignore gitstatus/usrbin/.gitkeep gitstatus/.clang-format gitstatus/.vscode/

# Compile zsh scripts
echo "Compiling zsh scripts..."
for file in *.zsh-theme internal/*.zsh gitstatus/*.zsh gitstatus/install; do
    sudo zsh -fc "emulate zsh -o no_aliases && zcompile -R -- $file.zwc $file"
done

echo "Installation complete."
