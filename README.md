# QT repo

This is a copy of the qt opensource code that was obtained
from [Qt Downloads][1]

Because some CVEs were not addressed in the tarball, we apply publicly
available patches that address the vulnerabilities in this repo and branch.

## Patches Applied

Run `git log` to view changes in this repository from the original sources.

## Updating QT

1. Make a new branch `qt-X.Y.Z`
2. Remove old sources E.g. `git rm -r qt-everywhere-src-Xold.Yold.Zold`
3. Download sources from [the official Qt Downloads page][2]. Only download the
   opensource and "single" repo version. E.g. `https://download.qt.io/official_releases/qt/X.Y/X.Y.Z/single/`.
   You should also verify the sources you download with the 
   `https://download.qt.io/official_releases/qt/X.Y/X.Y.Z/single/md5sums.txt`
   file provided by QT.
4. Extract to repository E.g. `tar -xf qt-everywhere-opensource-src-X.Y.Z.tar.xz`
5. Add extracted sources `git add qt-everywhere-src-X.Y.Z/` & Commit & Push (make sure ALL the files are added)
6. Apply patches as needed. Cite where you got the patch (either from
   [GitHub][3] or [Qt Downloads][2]. This lets a user use `git log` to verify
   if they changes they require are there.
7. Update this [README.md][README.md]

[1]: https://download.qt.io/official_releases/qt/5.15/5.15.6/single/)
[2]: https://download.qt.io/official_releases/qt/
[3]: https://github.com/qt/qtbase
