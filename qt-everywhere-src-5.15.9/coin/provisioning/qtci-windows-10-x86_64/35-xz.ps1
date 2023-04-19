############################################################################
##
## Copyright (C) 2021 The Qt Company Ltd.
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
############################################################################

. "$PSScriptRoot\..\common\windows\helpers.ps1"

# This script will install prebuilt XZ for IFW

# Prebuilt instructions:
# Download http://ci-files01-hki.intra.qt.io/input/windows/xz-5.2.5.zip or from original donwload page https://tukaani.org/xz/
# Extract to C:\Utils
# mkdir C:\Utils\xz-5.2.5\windows\vs2015
# cd C:\Utils\xz-$version
# copy "C:\Utils\xz-$version\windows\vs2017\*" "C:\Utils\xz-$version\windows\vs2015\"
# Run in powershell: (Get-Content C:\Utils\xz-$version\windows\vs2015\liblzma.vcxproj) | ForEach-Object { $_ -replace "<PlatformToolset>v141</PlatformToolset>", "<PlatformToolset>v140</PlatformToolset>" } | Set-Content C:\Utils\xz-$version\windows\vs2015\liblzma.vcxproj
# "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
# msbuild /property:Configuration=ReleaseMT windows/vs2015/liblzma.vcxproj

$version = "5.2.5"
$sha1 = "75570c1826428cfd86efd9835e342334f1493f7b"
Download http://ci-files01-hki.intra.qt.io/input/windows/xz-$version-prebuilt.zip http://ci-files01-hki.intra.qt.io/input/windows/xz-$version-prebuilt.zip C:\Windows\Temp\xz-$version.zip
Verify-Checksum "C:\Windows\Temp\xz-$version.zip" "$sha1"
Extract-7Zip "C:\Windows\Temp\xz-$version.zip" C:\Utils
Remove-Item -Path "C:\Windows\Temp\xz-$version.zip"

Write-Output "XZ = $version" >> ~\versions.txt

