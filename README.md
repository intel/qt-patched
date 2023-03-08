# QT repo

This is a copy of the qt opensource code that was obtained
from [Qt Downloads](https://download.qt.io/official_releases/qt/)

Because some CVEs were not addressed in the tarball, we apply publicly
available patches that address the vulnerabilities in this repo and branch.

## Patches Applied

Run `git log` to view changes in this repository from the original sources.

## Updating QT

1. Make a new branch `qt-X.Y.Z`
2. Remove old sources E.g. `git rm -r qt-everywhere-src-Xold.Yold.Zold`
3. Download sources from [the official Qt Downloads page](https://download.qt.io/official_releases/qt/). Only download the
   opensource and "single" repo version. E.g. `https://download.qt.io/official_releases/qt/X.Y/X.Y.Z/single/qt-everywhere-opensource-src-X.Y.Z.tar.xz`.
   You should also verify the sources you download with the 
   `https://download.qt.io/official_releases/qt/X.Y/X.Y.Z/single/md5sums.txt`
   file provided by QT.
4. Extract to repository E.g. `tar -xf qt-everywhere-opensource-src-X.Y.Z.tar.xz`
5. Add extracted sources `git add qt-everywhere-src-X.Y.Z/` & Commit & Push (make sure ALL the files are added)
6. Apply patches as needed. Cite where you got the patch (either from
   [GitHub](https://github.com/qt/qt5) or [Qt Downloads](https://download.qt.io/official_releases/qt/). This lets a user use `git log` to verify
   if they changes they require are there.
7. Update this README.md if this process changes (new links, etc)
