#!/bin/bash
# Copyright 2009, 2010 Jussi Judin
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

export WINE_INSTALL_PREFIX="$1"
export WINE_INSTALLER_ROOT="$2"

export PATH="$PATH":"$WINE_INSTALLER_ROOT"

winever() {
    source "$WINE_INSTALLER_ROOT"/winever "$@"
}
