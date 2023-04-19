#!/usr/bin/env bash

#############################################################################
##
## Copyright (C) 2020 The Qt Company Ltd.
## Contact: http://www.qt.io/licensing/
##
## This file is part of the provisioning scripts of the Qt Toolkit.
##
## $QT_BEGIN_LICENSE:LGPL21$
## Commercial License Usage
## Licensees holding valid commercial Qt licenses may use this file in
## accordance with the commercial license agreement provided with the
## Software or, alternatively, in accordance with the terms contained in
## a written agreement between you and The Qt Company. For licensing terms
## and conditions see http://www.qt.io/terms-conditions. For further
## information use the contact form at http://www.qt.io/contact-us.
##
## GNU Lesser General Public License Usage
## Alternatively, this file may be used under the terms of the GNU Lesser
## General Public License version 2.1 or version 3 as published by the Free
## Software Foundation and appearing in the file LICENSE.LGPLv21 and
## LICENSE.LGPLv3 included in the packaging of this file. Please review the
## following information to ensure the GNU Lesser General Public License
## requirements will be met: https://www.gnu.org/licenses/lgpl.html and
## http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
##
## As a special exception, The Qt Company gives you certain additional
## rights. These rights are described in The Qt Company LGPL Exception
## version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
##
## $QT_END_LICENSE$
##
#############################################################################

# shellcheck source=./DownloadURL.sh
source "${BASH_SOURCE%/*}/DownloadURL.sh"

set -ex

# This script will fetch and extract pre-buildt squish package for Linux and Mac.
# Squish is need by Release Test Automation (RTA)

version="6.7.2"
qtBranch="515x"
installFolder="/opt"
squishFolder="$installFolder/squish"
preBuildCacheUrl="ci-files01-hki.intra.qt.io:/hdd/www/input/squish/jenkins_build/stable"
licenseUrl="http://ci-files01-hki.intra.qt.io/input/squish/coin/.squish-license"
licenseSHA="bda9c3bce2b9a74cb10ead9e87a4ebacd9eef4c2"

if uname -a |grep -q Darwin; then
     compressedFolder="prebuild-squish-$version-$qtBranch-macx86_64.tar.gz"
     sha1="d15b487ba75f3e0ffe18373ce8eba7f9a5e1dcd1"
else
     compressedFolder="prebuild-squish-$version-$qtBranch-linux64.tar.gz"
     sha1="29f3719b6e1c94b1744447cac84748cdb6eb0d44"
fi

mountFolder="/tmp/squish"
sudo mkdir "$mountFolder"

# Check which platform
if uname -a |grep -q Darwin; then
    usersGroup="staff"
    squishLicenseDir="/Users/qt"
elif uname -a |grep -q "el7"; then
    usersGroup="qt"
    squishLicenseDir="/root"
elif uname -a |grep -q "Ubuntu"; then
    usersGroup="users"
    squishLicenseDir="/home/qt"
else
    usersGroup="users"
    squishLicenseDir="/root"
fi

targetFileMount="$mountFolder"/"$compressedFolder"

echo "Mounting $preBuildCacheUrl to $mountFolder"
if uname -a |grep -q Darwin; then
   sudo mount -o locallocks "$preBuildCacheUrl" "$mountFolder"
else
   sudo mount "$preBuildCacheUrl" "$mountFolder"
fi
echo "Create $installFolder if needed"
if [ !  -d "$installFolder" ]; then
    sudo mkdir "$installFolder"
fi

VerifyHash "$targetFileMount" "$sha1"

echo "Uncompress $compressedFolder"
sudo tar -xzf "$targetFileMount" --directory "$installFolder"

echo "Unmounting $mountFolder"
sudo diskutil unmount force "$mountFolder" || sudo umount -f "$mountFolder"

sudo mv "$installFolder/rta_squish_$version" "$squishFolder"

if uname -a |grep -q "Ubuntu"; then
    if [ ! -e "/usr/lib/tcl8.6" ]; then
        sudo mkdir /usr/lib/tcl8.6
        sudo cp "$squishFolder/squish_for_qt5/tcl/lib/tcl8.6/init.tcl" /usr/lib/tcl8.6/
    fi
fi

DownloadURL "$licenseUrl" "$licenseUrl" "$licenseSHA" "$HOME/.squish-license"

echo "Changing ownerships"
sudo chown -R qt:$usersGroup "$squishFolder"
sudo chown qt:$usersGroup "$HOME/.squish-license"

echo "Set commands for environment variables in .bashrc"
if uname -a |grep -q "Ubuntu"; then
    echo "export SQUISH_PATH=$squishFolder/squish_for_qt5" >> ~/.profile
    echo "export PATH=\$PATH:$squishFolder/squish_for_qt5/bin" >> ~/.profile
else
    echo "export SQUISH_PATH=$squishFolder/squish_for_qt5" >> ~/.bashrc
    echo "export PATH=\$PATH:$squishFolder/squish_for_qt5/bin" >> ~/.bashrc
fi

echo "Verifying Squish, available installations:"
ls -la $squishFolder

if "$squishFolder/squish_for_qt5/bin/squishrunner" --testsuite "$squishFolder/suite_test_squish" | grep "Squish test run successfully" ; then
  echo "Squish for Qt5 installation tested successfully"
else
  echo "Squish for Qt5 test failed! Package wasn't installed correctly."
  exit 1
fi

if uname -a |grep -q "rhel-7.6"; then
    echo "GLIBC too old on RHEL 7.6. Cannot install Qt6 based Squish."
    exit 0
fi

if "$squishFolder/squish_for_qt6/bin/squishrunner" --testsuite "$squishFolder/suite_test_squish" | grep "Squish test run successfully" ; then
  echo "Squish for Qt6 installation tested successfully"
else
  echo "Squish for Qt6 test failed! Package wasn't installed correctly."
  exit 1
fi
