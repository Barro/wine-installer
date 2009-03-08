#!/bin/bash

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
    ls -d "$WINE_PREFIX"/wine-* | perl -pe 's/(.+)wine-(.+)$/$2/gm'
    test -x "`which wine`" && echo "system"
    $RETURN
fi

if test "$VERSION" == "system"; then
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
    cd "$CURRDIR"
    $RETURN
fi

PROGRAMPATH="$WINE_PREFIX"/wine-"$VERSION"/bin
if (! test -d "$PROGRAMPATH" ); then
    echo "No wine version '$VERSION' exists. Tried '$PROGRAMPATH'"
else
    export WINEVER="$VERSION"
    cd "$PROGRAMPATH"
    for PROG in *; do
        alias "$PROG"="$PROGRAMPATH"/"$PROG"
    done
    cd "$CURRDIR"
fi
