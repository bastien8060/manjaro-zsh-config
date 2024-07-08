#!/bin/bash

# Maintainer: David Runge <dvzrv@archlinux.org>

set -e

# Package details
PKGNAME=zsh-history-substring-search
PKGVER=1.1.0
PKGDESC="ZSH port of Fish history search (up arrow)"
URL="https://github.com/zsh-users/zsh-history-substring-search"
LICENSE="BSD"
SOURCE="${URL}/archive/v${PKGVER}/${PKGNAME}-v${PKGVER}.tar.gz"
SHA512SUM='267efc0960f6403b748e78734b43b8d997f05a2a2542520508e6ef028ef2e0a2c0805d24ae5ad4c30454742a08a7abf2e3baa591e60a660a0ca54aca0ad7175a'

# Dependencies
DEPENDENCIES=(
  zsh
)

# Install dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y "${DEPENDENCIES[@]}"

# Download source
echo "Downloading source..."
wget -O "${PKGNAME}-v${PKGVER}.tar.gz" "${SOURCE}"

# Verify checksum
echo "Verifying checksum..."
echo "${SHA512SUM}  ${PKGNAME}-v${PKGVER}.tar.gz" | sha512sum -c -

# Extract source
echo "Extracting source..."
tar -xzf "${PKGNAME}-v${PKGVER}.tar.gz"

# Prepare license
echo "Preparing license..."
sed -e 's/^# //g; s/^#//g' -ne 4,38p "${PKGNAME}-${PKGVER}/${PKGNAME}.zsh" > LICENSE

# Install files
echo "Installing files..."
sudo install -vDm 644 "${PKGNAME}-${PKGVER}/${PKGNAME}.zsh" /usr/share/zsh/plugins/${PKGNAME}/${PKGNAME}.zsh
sudo install -vDm 644 "${PKGNAME}-${PKGVER}/README.md" /usr/share/doc/${PKGNAME}/README.md
sudo install -vDm 644 LICENSE /usr/share/licenses/${PKGNAME}/LICENSE

echo "Installation complete."
