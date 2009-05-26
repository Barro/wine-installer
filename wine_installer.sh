#!/bin/sh
# Copyright 2009 Jussi Judin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
shift
shift

if test -z "$VERSION"; then
    echo "Usage wine_installer.sh version prefix"
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

PROCESSORS="`cat /proc/cpuinfo | grep processor | wc -l`"
CONCURRENCY="$PROCESSORS"

./configure --prefix="$PREFIX" "$@" && make depend && make -j "$CONCURRENCY" && mkdir -p "$PREFIX" && make install

finishProgram "$COMPILEDIR"
