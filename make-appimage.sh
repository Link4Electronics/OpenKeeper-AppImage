#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/tonihele/OpenKeeper/refs/heads/master/assets/Icons/openkeeper256.png
export DESKTOP=DUMMY
export MAIN_BIN=OpenKeeper
export STARTUPWMCLASS=java
export DEPLOY_OPENGL=1
export DEPLOY_GLIBC=1
export PATH_MAPPING='
${SHARUN_DIR}/bin/assets:${HOME}/.OpenKeeper/assets
${SHARUN_DIR}/bin/highscores.dat:${HOME}/.OpenKeeper/highscores.dat
${SHARUN_DIR}/bin/openkeeper.properties:${HOME}/.OpenKeeper/launcher.properties
'

# Deploy dependencies
quick-sharun ./AppDir/bin/OpenKeeper \
    ./AppDir/bin/lib \
    /usr/lib/jvm/java*/bin \
    /usr/lib/jvm/java*/conf \
    /usr/lib/jvm/java*/legal \
    /usr/lib/jvm/java*/lib
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
