#!/bin/sh

function finishProgram()
{
    TMPDIR="$1"
    ERROR="$2"
    if text -z "$TMPDIR"; then
        echo "Temporary directory string was empty"
        exit 1
    fi

    if test -n "$ERROR"; then
        echo "$ERROR"
    fi

    echo "Finishing..."
    echo "Removing temporary directory $TMPDIR"

    if test ! -d "$TMPDIR"; then
        echo "Temporary directory does not exist"
        exit 1
    fi

    rm -rf "$TMPDIR"

    if test -n "$ERROR"; then
        exit 1
    fi
    exit 0
}

VERSION="$1"
PREFIX="$2"

if test -z "$VERSION"; then
    echo "Version information is needed"
    exit 1
fi

if test -z "$PREFIX"; then
    echo "Installation prefix is needed"
    exit 1
fi

echo "Making temporary compilation directory"
COMPILEDIR="`mktemp -d -t wine_install.XXXXXXXXXX`"
test -d "$COMPILEDIR" || exit 1
echo "Created directory $COMPILEDIR"

WINESTRING="wine-$VERSION"

echo "Downloading wine $VERSION"

wget --directory-prefix="$COMPILEDIR" http://prdownloads.sourceforge.net/wine/"$WINESTRING".tar.bz2 || finishProgram "$COMPILEDIR" "Could not download wine $VERSION"

finishProgram "$COMPILEDIR"
