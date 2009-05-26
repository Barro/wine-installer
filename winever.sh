#!/bin/bash
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

WINE_PREFIX="$1"
VERSION="$2"
CURRDIR="`pwd`"
RETURN="return"

if test -z "$WINE_PREFIX"; then
    echo Usage: "$0" WINE_PREFIX [VERSION]
    $RETURN 1
fi

if test ! -d "$WINE_PREFIX"; then
    echo Directory '"$WINE_PREFIX"' does not exist!
    $RETURN 1
fi

# List available wine versions.
if test -z "$VERSION"; then
    if test -n "$WINEVER"; then
        echo "= $WINEVER"
    fi
    ls -d "$WINE_PREFIX"/wine-* | sort -V | perl -pe 's/(.+)wine-(.+)$/$2/gm'
    SYSTEM_WINE="`which wine`"
    if test -x "$SYSTEM_WINE"; then
        SYSTEM_WINE_VERSION="`"$SYSTEM_WINE" --version`"
        echo "system $SYSTEM_WINE_VERSION"
    fi
    $RETURN
fi

if test "`echo "$VERSION" | cut -f 1 -d " "`" = "system"; then
    if test -z "$WINEVER"; then
        # No wine version changed, return immediately
        $RETURN
    fi
    PROGRAMPATH="$WINE_PREFIX"/wine-"$WINEVER"/bin
    export WINEVER=""
    cd "$PROGRAMPATH"
    for PROG in *; do
        unalias "$PROG"
    done
    if test -n "`env | grep MANPATH_PREWINE`"; then
        export MANPATH="$MANPATH_PREWINE"
    fi
    unset MANPATH_PREWINE
    cd "$CURRDIR"
    $RETURN
fi

WVROOT="$WINE_PREFIX"/wine-"$VERSION"
PROGRAMPATH="$WVROOT"/bin
if (! test -d "$PROGRAMPATH" ); then
    echo "No wine version '$VERSION' exists. Tried '$PROGRAMPATH'"
else
    export WINEVER="$VERSION"
    cd "$PROGRAMPATH"
    for PROG in *; do
        alias "$PROG"="$PROGRAMPATH"/"$PROG"
    done
    # Needed for winetricks to work.
    export WINE="$PROGRAMPATH"/wine
    if test -n "`env | grep MANPATH_PREWINE`"; then
        export MANPATH="$MANPATH_PREWINE"
    fi
    export MANPATH_PREWINE="$MANPATH"
    # ":" is needed even when MANPATH is empty. Otherwise other man pages
    # don't work.
    export MANPATH="$WVROOT"/share/man:"$MANPATH"
    cd "$CURRDIR"
fi
