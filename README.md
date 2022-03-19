# Qscintilla library with modified build scripts

This is [Qscintilla](https://www.riverbankcomputing.com/software/qscintilla/intro) library with modifications in build scripts to support
[NextGIS Borsch](https://github.com/nextgis-borsch/borsch) building system. NextGIS Borsch helps to resolve
dependencies of building C/C++ libraries and applications. NextGIS Borsch is based on [CMake](https://cmake.org/).

[![Borsch compatible](https://img.shields.io/badge/Borsch-compatible-orange.svg?style=flat)](https://github.com/nextgis-borsch/borsch)

## Build

Example command to build:

```bash
cmake -DWITH_Qt5_EXTERNAL=ON -DWITH_BINDINGS=ON -DSUPPRESS_VERBOSE_OUTPUT=ON -DCMAKE_BUILD_TYPE=Release -DSKIP_DEFAULTS=ON -DOSX_FRAMEWORK=ON -DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk -DCMAKE_OSX_DEPLOYMENT_TARGET=10.14 ..
```

## Version

2.13.1-0
