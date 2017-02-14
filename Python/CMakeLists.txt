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
include(SIPMacros)
find_anyproject(SIP REQUIRED)
find_package(PythonInterp REQUIRED)
find_package(PythonLibs REQUIRED)

# setup SIP variables
set(PYQT_SIP_FLAGS ${PYQT4_SIP_FLAGS})
set(PYQT_SIP_DIR ${PYQT4_SIP_DIR})

set(SIP_INCLUDES ${PYQT_SIP_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_SOURCE_DIR}/qt)
set(SIP_CONCAT_PARTS 4)
separate_arguments(PYQT_SIP_FLAGS)

if(OSX_FRAMEWORK)
    set(INSTALL_PYTHON_DIR "${CMAKE_INSTALL_PREFIX}/Library/Python/${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}/site-packages/")
else()
    set(INSTALL_PYTHON_DIR "${INSTALL_LIB_DIR}/Python${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}/site-packages/")
endif()

set(QSCI_SIP_DIR ${CMAKE_INSTALL_PREFIX}/share/sip)

include_directories(
    ${CMAKE_SOURCE_DIR}/qt
    ${CMAKE_SOURCE_DIR}/include
    ${PYTHON_INCLUDE_PATH}
)

file(GLOB_RECURSE sip_files_qsci sip/*.sip)
set(SIP_EXTRA_FILES_DEPEND ${sip_files_qsci})
set(SIP_EXTRA_OPTIONS ${PYQT_SIP_FLAGS} -o -a ${CMAKE_CURRENT_BINARY_DIR}/QScintilla2.api)

if(QT4_BUILD)
    set(SIP_DISABLE_FEATURES ${SIP_DISABLE_FEATURES} Qsci_Qt4)
    ADD_SIP_PYTHON_MODULE(PyQt4.Qsci sip/qscimod4.sip ${LIB_NAME})
else()
    ADD_SIP_PYTHON_MODULE(PyQt5.Qsci sip/qscimod5.sip ${LIB_NAME})
endif()

install(FILES ${sip_files_qsci} DESTINATION ${QSCI_SIP_DIR}/Qsci)

if (REGISTER_PACKAGE)
    set(EXPORT_PACKAGE_NAME Qsci)
    set(MOD_VERSION_STR "4.12")

    string(TOUPPER ${EXPORT_PACKAGE_NAME} EXPORT_PACKAGE_NAME_UPPER)
    set(EXPORT_PACKAGE_LIB_NAME qsci)

    export(PACKAGE ${EXPORT_PACKAGE_NAME})

    include(CMakePackageConfigHelpers)
    configure_package_config_file(
        ${CMAKE_SOURCE_DIR}/cmake/QsciPackageConfig.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/${EXPORT_PACKAGE_NAME}Config.cmake
        INSTALL_DESTINATION ${CMAKE_CURRENT_BINARY_DIR} )
    write_basic_package_version_file(
        ${CMAKE_CURRENT_BINARY_DIR}/${EXPORT_PACKAGE_NAME}ConfigVersion.cmake
        VERSION ${VERSION}
        COMPATIBILITY AnyNewerVersion )
endif()
