################################################################################
# Project:  Lib QScintilla
# Purpose:  CMake build scripts
# Author:   Dmitry Baryshnikov, dmitry.baryshnikov@nexgis.com
################################################################################
# Copyright (C) 2017-2018, NextGIS <info@nextgis.com>
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

cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)

project(qscintilla)

# Some init settings
set(CMAKE_COLOR_MAKEFILE ON)
# Set path to additional CMake modules
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

if(OSX_FRAMEWORK AND (BUILD_SHARED_LIBS OR BUILD_STATIC_LIBS))
  message(FATAL_ERROR "Only OSX_FRAMEWORK key or any or both BUILD_SHARED_LIBS
                       and BUILD_STATIC_LIBS keys are permitted")
endif()

if(OSX_FRAMEWORK)
    set(INSTALL_BIN_DIR "bin" CACHE INTERNAL "Installation directory for executables" FORCE)
    set(INSTALL_LIB_DIR "Library/Frameworks" CACHE INTERNAL "Installation directory for libraries" FORCE)
    set(INSTALL_INC_DIR "${INSTALL_LIB_DIR}/${PROJECT_NAME}.framework/Headers" CACHE INTERNAL "Installation directory for headers" FORCE)
    set(INSTALL_QM_DIR "Library/Translations" CACHE INTERNAL "Installation directory for translations" FORCE)
    set(INSTALL_CMAKECONF_DIR ${INSTALL_LIB_DIR}/${PROJECT_NAME}.framework/Resources/CMake CACHE INTERNAL "Installation directory for cmake config files" FORCE)
    set(SKIP_INSTALL_HEADERS ON)
    set(SKIP_INSTALL_EXECUTABLES ON)
    set(SKIP_INSTALL_FILES ON)
    set(SKIP_INSTALL_EXPORT ON)
    set(CMAKE_MACOSX_RPATH ON)
else()
    include(GNUInstallDirs)

    set(INSTALL_BIN_DIR ${CMAKE_INSTALL_BINDIR} CACHE INTERNAL "Installation directory for executables" FORCE)
    set(INSTALL_LIB_DIR ${CMAKE_INSTALL_LIBDIR} CACHE INTERNAL "Installation directory for libraries" FORCE)
    set(INSTALL_INC_DIR ${CMAKE_INSTALL_INCLUDEDIR} CACHE INTERNAL "Installation directory for headers" FORCE)
    set(INSTALL_DOC_DIR ${CMAKE_INSTALL_DOCDIR} CACHE INTERNAL "Share directory for data" FORCE)
    set(INSTALL_QM_DIR "${CMAKE_INSTALL_DATADIR}/translations" CACHE INTERNAL "Installation directory for translations" FORCE)
    set(INSTALL_CMAKECONF_DIR ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}/CMake CACHE INTERNAL "Installation directory for cmake config files" FORCE)
endif()

set(QSCI_SIP_DIR share/sip)
set(MOD_VERSION_STR "4.12") # TODO: What mean this variable?

include(util)
check_version(QSCI_MAJOR_VERSION QSCI_MINOR_VERSION QSCI_REV_VERSION)
set(VERSION ${QSCI_MAJOR_VERSION}.${QSCI_MINOR_VERSION}.${QSCI_REV_VERSION})

if(OSX_FRAMEWORK)
    set(FRAMEWORK_VERSION "${QSCI_MAJOR_VERSION}")
endif()
report_version(${PROJECT_NAME} ${VERSION})

configure_file(${CMAKE_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake IMMEDIATE @ONLY)

add_definitions(-DSCINTILLA_QT -DSCI_LEXER)
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
if(COMPILER_SUPPORTS_CXX11)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
endif()

option(QT4_BUILD "Build with qt4" ON)

include(FindAnyProject)

set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
if(QT4_BUILD)
    find_anyproject(Qt4 REQUIRED COMPONENTS QtCore QtGui)
    set_property(DIRECTORY APPEND PROPERTY COMPILE_DEFINITIONS $<$<NOT:$<CONFIG:Debug>>:QT_NO_DEBUG>)
    if(WIN32)
        add_definitions(-DQT_DLL) # Only for shared libraries on win32
    endif()  
else()
    find_anyproject(Qt5 REQUIRED COMPONENTS Qt5Widgets Qt5PrintSupport)
    if(APPLE)
        find_anyproject(Qt5 REQUIRED COMPONENTS Qt5MacExtras)
    endif()
endif()

set(LIB_NAME ${PROJECT_NAME})
set(PACKAGE_NAME ${PROJECT_NAME})
string(TOUPPER ${PACKAGE_NAME} PACKAGE_UPPER_NAME)

add_subdirectory(qt)
add_subdirectory(translate)
if(WITH_BINDINGS)
    add_subdirectory(Python)
endif()

# uninstall
add_custom_target(uninstall COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)

# Export package ===============================================================

if(REGISTER_PACKAGE)
    # Export the package for use from the build-tree
    # (this registers the build-tree with a global CMake-registry)
    export(PACKAGE ${PACKAGE_UPPER_NAME})
endif()

# Create the <Package>Config.cmake file
configure_file(cmake/PackageConfig.cmake.in
    ${PROJECT_BINARY_DIR}/${PACKAGE_UPPER_NAME}Config.cmake @ONLY)

# Archiving ====================================================================

set(CPACK_PACKAGE_NAME "${PACKAGE_NAME}")
set(CPACK_PACKAGE_VENDOR "${PACKAGE_VENDOR}")
set(CPACK_PACKAGE_VERSION "${VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PACKAGE_NAME} Installation")
set(CPACK_PACKAGE_RELOCATABLE TRUE)
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)
set(CPACK_GENERATOR "ZIP")
set(CPACK_MONOLITHIC_INSTALL ON)
set(CPACK_STRIP_FILES TRUE)

# Get cpack zip archive name
get_cpack_filename(${VERSION} PROJECT_CPACK_FILENAME)
set(CPACK_PACKAGE_FILE_NAME ${PROJECT_CPACK_FILENAME})

include(CPack)
