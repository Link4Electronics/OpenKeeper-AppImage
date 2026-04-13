#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm jre-openjdk

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
REPO="https://github.com/tonihele/OpenKeeper"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
wget https://github.com/tonihele/OpenKeeper/releases/download/latest/OpenKeeper.zip
bsdtar -xvf OpenKeeper.zip --strip-components=1
rm -rf *.zip bin lib/*window*.jar lib/*arm32.jar lib/*maco*.jar
mv -v lib ./AppDir/bin
