################################################################################
# Project:  Lib QScintilla
# Purpose:  CMake build scripts
# Author:   Dmitry Baryshnikov, dmitry.baryshnikov@nexgis.com
################################################################################
# Copyright (C) 2017, NextGIS <info@nextgis.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
################################################################################
file(GLOB TS_FILES "${CMAKE_CURRENT_SOURCE_DIR}/*.ts")

if(WIN32)
    # Copy zlib1.dll to qt5 bin path
    find_anyproject(ZLIB DEFAULT ON)

    if(ZLIB_FOUND)
        get_target_property(ZLIB_DLL ${ZLIB_LIBRARIES} IMPORTED_LOCATION_RELEASE)
        get_target_property(QT5_BIN_PATH Qt5::Core IMPORTED_LOCATION_RELEASE)
        get_filename_component(QT5_BIN_PATH ${QT5_BIN_PATH} DIRECTORY)

        warning_message("Copy ${ZLIB_DLL} to ${QT5_BIN_PATH}")

        execute_process(
            COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ZLIB_DLL} ${QT5_BIN_PATH}
        )
    endif()
endif()

qt5_add_translation(QM_FILES ${TS_FILES})

if(OSX_FRAMEWORK)
    set(INSTALL_QM_DIR "${INSTALL_QM_DIR}/Qt5")
endif()

add_custom_target (translations_target ALL DEPENDS ${QM_FILES})

if(NOT SKIP_INSTALL_TRANSLATIONS AND NOT SKIP_INSTALL_ALL)
    install(FILES ${QM_FILES} DESTINATION ${INSTALL_QM_DIR})
endif()
