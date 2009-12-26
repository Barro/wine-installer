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

WINE_INSTALL_PREFIX="$1"
WINE_INSTALLER_ROOT="$2"

function winever() {
    VERSION="$1"
    source "$WINE_INSTALLER_ROOT"/winever "$WINE_INSTALL_PREFIX" "$VERSION"
}

function wine-install() {
    VERSION="$1"
    shift
    "$WINE_INSTALLER_ROOT"/wine-installer "$VERSION" "$WINE_INSTALL_PREFIX"/wine-"$VERSION" "$@"
}

function winebottle() {
    "$WINE_INSTALLER_ROOT"/winebottle "$@"
}
