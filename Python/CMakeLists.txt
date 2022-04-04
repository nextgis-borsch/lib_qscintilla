################################################################################
# Project:  Lib QScintilla
# Purpose:  CMake build scripts
# Author:   Dmitry Baryshnikov, dmitry.baryshnikov@nexgis.com
################################################################################
# Copyright (C) 2017-2022, NextGIS <info@nextgis.com>
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
find_package(Python3 COMPONENTS Interpreter Development)

if(${Python3_FOUND})
    set(PYTHON_EXECUTABLE ${Python3_EXECUTABLE})
    set(PYTHON_LIBRARY ${Python3_LIBRARIES})
    set(PYTHON_VERSION_MAJOR ${Python3_VERSION_MAJOR})
    set(PYTHON_VERSION_MINOR ${Python3_VERSION_MINOR})
    set(PYTHON_INCLUDE_PATH ${Python3_INCLUDE_DIRS})

    link_directories(${Python3_LIBRARY_DIRS})
endif()


set(TMP_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/inst")

set(CONFIGURE_ARGS --verbose --build-dir ${CMAKE_CURRENT_BINARY_DIR}/bld_tmp --target-dir ${TMP_INSTALL_PREFIX} --scripts-dir ${CMAKE_CURRENT_BINARY_DIR}/s_tmp --no-docstrings) # --confirm-license  --qt-shared

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --debug)
endif()

get_property(QT_QMAKE_EXECUTABLE TARGET Qt5::qmake PROPERTY IMPORTED_LOCATION)
get_filename_component(QT_BIN_DIR "${QT_QMAKE_EXECUTABLE}" PATH)
get_filename_component(QT_ROOT_DIR "${QT_BIN_DIR}" PATH)
set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --qmake=${QT_QMAKE_EXECUTABLE})
set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --qmake-setting "QMAKE_RPATHDIR+=${QT_ROOT_DIR}/lib")

include(ProcessorCount)
ProcessorCount(N)
if(NOT N EQUAL 0)
    set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --jobs ${N})
endif()

# Find sip-install
execute_process(
    COMMAND ${PYTHON_EXECUTABLE} -m site --user-base
    RESULT_VARIABLE _process_status
    OUTPUT_VARIABLE _process_output
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

if(${_process_status} EQUAL 0)
    string(STRIP ${_process_output} BASE_PATH)
endif()

find_program(SIP_INSTALL_EXECUTABLE sip-install PATHS ${BASE_PATH}/bin)

get_property(Qt5Core_INCLUDE_DIRS TARGET Qt5::Core PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
foreach(_INC_DIR ${Qt5Core_INCLUDE_DIRS})
    set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --qmake-setting INCLUDEPATH+=${_INC_DIR})
endforeach()
get_property(Qt5Widgets_INCLUDE_DIRS TARGET Qt5::Widgets PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
foreach(_INC_DIR ${Qt5Widgets_INCLUDE_DIRS})
    set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --qmake-setting INCLUDEPATH+=${_INC_DIR})
endforeach()
get_property(Qt5PrintSupport_INCLUDE_DIRS TARGET Qt5::PrintSupport PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
foreach(_INC_DIR ${Qt5PrintSupport_INCLUDE_DIRS})
    set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --qmake-setting INCLUDEPATH+=${_INC_DIR})
endforeach()
set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --qmake-setting INCLUDEPATH+=${PROJECT_SOURCE_DIR}/qt)
set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --qmake-setting INCLUDEPATH+=${PROJECT_SOURCE_DIR}/src)

if(WIN32)
    if(BUILD_SHARED_LIBS)
        set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --qmake-setting "DEFINES+=QSCINTILLA_DLL")
    endif()

    string(TOUPPER ${CMAKE_BUILD_TYPE} BUILD_TYPE)

    get_target_property(QT_WIDGETS_LIB Qt5::Widgets IMPORTED_IMPLIB_${BUILD_TYPE})
    set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --qmake-setting "LIBS+=${QT_WIDGETS_LIB}")

    get_target_property(QT_PRINTSUPPORT_LIB Qt5::PrintSupport IMPORTED_IMPLIB_${BUILD_TYPE})
    set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --qmake-setting "LIBS+=${QT_PRINTSUPPORT_LIB}")

    set(CONFIGURE_ARGS ${CONFIGURE_ARGS} --qmake-setting "LIBS+=${CMAKE_BINARY_DIR}/qt/${CMAKE_BUILD_TYPE}/${LIB_NAME}.lib")
endif()

find_anyproject(PyQt5 REQUIRED)

set(SIP_DIR ${PYQT5_PYTHON_DIR}PyQt5/bindings)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/pyproject-qt5.toml.cmakein ${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml @ONLY)

message(STATUS "SIP: ${SIP_INSTALL_EXECUTABLE}\nConfigure args: ${CONFIGURE_ARGS}")

# Copy dependencies to bin dir
set(RUN_DEPENDENCIES
    lib_png
    lib_tiff
    lib_jpeg
    lib_jbig
    lib_lzma
    lib_webp
    lib_openssl
    lib_curl
    lib_jsonc
    lib_bzip2
    lib_qhull
    lib_proj
    lib_pq
    lib_oci
    lib_geotiff
    lib_gif
    lib_hdf4
    lib_openjpeg
    lib_kml
    lib_opencad
    lib_xml2
    lib_spatialite
    lib_szip
    lib_uriparser
    lib_z
)

if(OSX_FRAMEWORK)
    set(DST_PATH ${QT_ROOT_DIR}/lib)
else()
    set(DST_PATH ${QT_ROOT_DIR}/bin)
endif()

get_compiler_version(COMPILER)
foreach(RUN_DEPENDENCY ${RUN_DEPENDENCIES})
    execute_process(
        COMMAND ${CMAKE_COMMAND} -DDST_PATH=${DST_PATH} -DSRC_PATH=${PROJECT_BINARY_DIR} -DREPKA_PACKAGE=${RUN_DEPENDENCY} -DCOMPILER=${COMPILER} -DOSX_FRAMEWORK=${OSX_FRAMEWORK} -P ${PROJECT_SOURCE_DIR}/cmake/get_dependency.cmake
    )
endforeach()

if(OSX_FRAMEWORK)
    set(INSTALL_PYTHON_DIR "Library/Python/${PYTHON_VERSION_MAJOR}/site-packages/")
elseif(WIN32)
    set(INSTALL_PYTHON_DIR "${INSTALL_LIB_DIR}/Python${PYTHON_VERSION_MAJOR}/site-packages/")
else()
    set(INSTALL_PYTHON_DIR "lib/python${PYTHON_VERSION_MAJOR}/dist-packages/")
endif()

add_custom_target(build_py${ver} ALL
    COMMAND ${SIP_INSTALL_EXECUTABLE} ${CONFIGURE_ARGS}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS ${LIB_NAME}
    VERBATIM
)

if(OSX_FRAMEWORK)
    add_custom_target(fix_py${ver} ALL
        COMMAND ${CONFIGURE_CMD}
        ${PYTHON${ver}_EXECUTABLE} ${CMAKE_SOURCE_DIR}/cmake/mac_rpath_fix.py ${QT_ROOT_DIR}/lib
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS build_py${ver}
        VERBATIM
    )
endif()

# install(FILES ${sip_files_qsci} DESTINATION ${QSCI_SIP_DIR}/Qsci)

# Export package ===============================================================
set(EXPORT_PACKAGE_NAME Qsci)
string(TOUPPER ${EXPORT_PACKAGE_NAME} EXPORT_PACKAGE_NAME_UPPER)

if(REGISTER_PACKAGE)
    # Export the package for use from the build-tree
    # (this registers the build-tree with a global CMake-registry)
    export(PACKAGE ${EXPORT_PACKAGE_NAME})
endif()

# Create the <Package>Config.cmake file
configure_file(${PROJECT_SOURCE_DIR}/cmake/QsciPackageConfig.cmake.in
    ${PROJECT_BINARY_DIR}/${EXPORT_PACKAGE_NAME_UPPER}Config.cmake @ONLY)



if(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL )
    install(DIRECTORY ${TMP_INSTALL_PREFIX}/ 
        DESTINATION "${INSTALL_PYTHON_DIR}" USE_SOURCE_PERMISSIONS)
    
    install(FILES
        ${PROJECT_BINARY_DIR}/${EXPORT_PACKAGE_NAME_UPPER}Config.cmake
        DESTINATION ${INSTALL_CMAKECONF_DIR} COMPONENT dev)
endif()
