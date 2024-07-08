#!/bin/bash

# Maintainer: Jeremy Gust <jeremy AT plasticsoup DOT net>
# Contributor: Jules Sam Randolph <jules.sam.randolph@gmail.com>

set -e

# Package details
PKGNAME=ttf-meslo-nerd-font-powerlevel10k
COMMIT='145eb9fbc2f42ee408dacd9b22d8e6e0e553f83d'
PKGVER=2.3.3
PKGDESC='Meslo Nerd Font patched for Powerlevel10k'
URL='https://github.com/romkatv/powerlevel10k-media'
LICENSE='Apache-2.0'

# Source URLs
SOURCE=(
    "MesloLGS-NF-Bold-$PKGVER.ttf::https://github.com/romkatv/powerlevel10k-media/raw/${COMMIT}/MesloLGS%20NF%20Bold.ttf"
    "MesloLGS-NF-Bold-Italic-$PKGVER.ttf::https://github.com/romkatv/powerlevel10k-media/raw/${COMMIT}/MesloLGS%20NF%20Bold%20Italic.ttf"
    "MesloLGS-NF-Italic-$PKGVER.ttf::https://github.com/romkatv/powerlevel10k-media/raw/${COMMIT}/MesloLGS%20NF%20Italic.ttf"
    "MesloLGS-NF-Regular-$PKGVER.ttf::https://github.com/romkatv/powerlevel10k-media/raw/${COMMIT}/MesloLGS%20NF%20Regular.ttf"
)

# SHA256 checksums
SHA256SUMS=(
    'b6c0199cf7c7483c8343ea020658925e6de0aeb318b89908152fcb4d19226003'
    '56b4131adecec052c4b324efb818dd326d586dbc316fc68f98f1cae2eb8d1220'
    '6f357bcbe2597704e157a915625928bca38364a89c22a4ac36e7a116dcd392ef'
    'd97946186e97f8d7c0139e8983abf40a1d2d086924f2c5dbf1c29bd8f2c6e57d'
)

# Download sources
echo "Downloading sources..."
for i in "${!SOURCE[@]}"; do
    url="${SOURCE[$i]##*::}"
    file="${SOURCE[$i]%%::*}"
    wget -O "$file" "$url"
    echo "${SHA256SUMS[$i]}  $file" | sha256sum -c -
done

# Install fonts
echo "Installing fonts..."
sudo install -Dm644 "MesloLGS-NF-Bold-Italic-$PKGVER.ttf" "/usr/share/fonts/truetype/meslo/MesloLGS-NF-Bold-Italic.ttf"
sudo install -Dm644 "MesloLGS-NF-Italic-$PKGVER.ttf" "/usr/share/fonts/truetype/meslo/MesloLGS-NF-Italic.ttf"
sudo install -Dm644 "MesloLGS-NF-Bold-$PKGVER.ttf" "/usr/share/fonts/truetype/meslo/MesloLGS-NF-Bold.ttf"
sudo install -Dm644 "MesloLGS-NF-Regular-$PKGVER.ttf" "/usr/share/fonts/truetype/meslo/MesloLGS-NF-Regular.ttf"

# Update font cache
echo "Updating font cache..."
sudo fc-cache -f -v

echo "Installation complete."
