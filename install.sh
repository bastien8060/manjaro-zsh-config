#!/bin/bash

# Maintainer: Chrysostomus <forum.manjaro.org>
# Contributor: pheiduck <forum.manjaro.org>
# Contributor: Roman Perepelitsa <roman.perepelitsa@gmail.com>

set -e

# Package details
PKGNAME=manjaro-zsh-config
PKGVER=0.26
PKGREL=1
PKGDESC="Zsh configuration for Manjaro"
URL="https://github.com/Chrysostomus/manjaro-zsh-config"
LICENSE="MIT"
COMMIT=1f9d0da2c8408de895156cb65d324636d656df1c

# Dependencies
DEPENDENCIES=(
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  git
)

# Directory containing custom dependency installers
DEPENDENCY_DIR="/tmp/dependencies"
# Create the dependencies directory
mkdir -p "${DEPENDENCY_DIR}"
cp dependencies/* ${DEPENDENCY_DIR}

# Install dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y "${DEPENDENCIES[@]}"

# Install custom dependencies
echo "Installing custom dependencies..."
wget -O "${DEPENDENCY_DIR}/zsh-completions.deb" https://download.opensuse.org/repositories/shells:/zsh-users:/zsh-completions/xUbuntu_22.04/amd64/zsh-completions_0.34.0-1+2.1_amd64.deb
sudo dpkg -i "${DEPENDENCY_DIR}/zsh-completions.deb"
sudo bash "${DEPENDENCY_DIR}/ttf-meslo-nerd-font-powerlevel10k.sh"
sudo bash "${DEPENDENCY_DIR}/zsh-history-substring-search.sh"
sudo bash "${DEPENDENCY_DIR}/zsh-theme-powerlevel10k.sh"

# Clone the repository into /tmp
echo "Cloning repository..."
rm -rf /tmp/${PKGNAME}
git clone "${URL}.git" /tmp/${PKGNAME}
cd /tmp/${PKGNAME}
git checkout "${COMMIT}"

# Install files
echo "Installing files..."
sudo install -D -m644 .zshrc /etc/skel/.zshrc
sudo install -D -m644 "${PKGNAME}" /usr/share/zsh/${PKGNAME}
sudo install -D -m644 manjaro-zsh-prompt /usr/share/zsh/manjaro-zsh-prompt
sudo install -D -m644 zsh-maia-prompt /usr/share/zsh/zsh-maia-prompt
sudo install -D -m644 p10k.zsh /usr/share/zsh/p10k.zsh
sudo install -D -m644 p10k-portable.zsh /usr/share/zsh/p10k-portable.zsh
sudo install -D -m640 .zshrc /root/.zshrc
sudo chmod 750 /root
sudo install -d /usr/share/zsh/scripts
sudo cp -r base16-shell /usr/share/zsh/scripts/
sudo chmod a+x /usr/share/zsh/scripts/base16-shell/*

# Post Install
sudo mkdir -p /usr/share/zsh/plugins/
sudo cp /usr/share/zsh-* /usr/share/zsh/plugins/ -r

# Install license
echo "Installing license..."
sudo install -D -m644 LICENSE /usr/share/licenses/${PKGNAME}/LICENSE

echo "Installation complete."
