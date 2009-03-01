#!/bin/bash

WINE_INSTALL_PREFIX="$1"
WINEVER_ROOT="$2"

function winever() {
    VERSION="$1"
    "$WINEVER_ROOT"/winever.sh "$WINE_INSTALL_PREFIX" "$VERSION"
}

function wine-install() {
    VERSION="$1"
    shift
    "$WINEVER_ROOT"/wine_installer.sh "$VERSION" "$WINE_INSTALL_PREFIX"/wine-"$VERSION" "$@"
}
