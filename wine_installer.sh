#!/bin/sh

function finishProgram()
{
    TMPDIR="$1"
    ERROR="$2"
    if test -z "$TMPDIR"; then
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

TARGETFILE="$COMPILEDIR"/"$WINESTRING".tar.bz2

echo "Downloading wine $VERSION"

wget --directory-prefix="$COMPILEDIR" http://prdownloads.sourceforge.net/wine/"$WINESTRING".tar.bz2 -O "$TARGETFILE" || finishProgram "$COMPILEDIR" "Could not download wine $VERSION"

tar xvjf "$TARGETFILE" -C "$COMPILEDIR" || finishProgram "$COMPILEDIR" "Could not extract file $TARGETFILE"

cd "$COMPILEDIR"/"$WINESTRING" || finishProgram "$COMPILEDIR" "Wine did to extract to $COMPILEDIR/$WINESTRING"

./configure --prefix="$PREFIX" && make depend && make -j 6 && mkdir -p "$PREFIX" && make install

finishProgram "$COMPILEDIR"
