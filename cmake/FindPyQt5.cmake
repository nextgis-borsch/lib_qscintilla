# Find PyQt5
# ~~~~~~~~~~
# Copyright (c) 2007-2008, Simon Edwards <simon@simonzone.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# PyQt5 website: http://www.riverbankcomputing.co.uk/pyqt/index.php
#
# Find the installed version of PyQt5. FindPyQt5 should only be called after
# Python has been found.
#
# This file defines the following variables:
#
# PYQT5_VERSION - The version of PyQt5 found expressed as a 6 digit hex number
#     suitable for comparision as a string
#
# PYQT5_VERSION_STR - The version of PyQt5 as a human readable string.
#
# PYQT5_VERSION_TAG - The PyQt version tag using by PyQt's sip files.
#
# PYQT5_SIP_DIR - The directory holding the PyQt5 .sip files.
#
# PYQT5_SIP_FLAGS - The SIP flags used to build PyQt.
#
# PYQT5_PYUIC_PROGRAM - The pyuic5 program path.
#
# PYQT5_PYRCC_PROGRAM - The pyrcc5 program path.

IF(EXISTS PYQT5_VERSION)
  # Already in cache, be silent
  SET(PYQT5_FOUND TRUE)
ELSE()

  FIND_FILE(_find_pyqt5_py FindPyQt5.py PATHS ${CMAKE_MODULE_PATH})

  EXECUTE_PROCESS(COMMAND ${PYTHON_EXECUTABLE} ${_find_pyqt5_py} OUTPUT_VARIABLE pyqt_config)
  IF(pyqt_config)
    STRING(REGEX REPLACE "^pyqt_version:([^\n]+).*$" "\\1" PYQT5_VERSION ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_version_str:([^\n]+).*$" "\\1" PYQT5_VERSION_STR ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_version_tag:([^\n]+).*$" "\\1" PYQT5_VERSION_TAG ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_version_num:([^\n]+).*$" "\\1" PYQT5_VERSION_NUM ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_mod_dir:([^\n]+).*$" "\\1" PYQT5_MOD_DIR ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_sip_dir:([^\n]+).*$" "\\1" PYQT5_SIP_DIR ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_sip_flags:([^\n]+).*$" "\\1" PYQT5_SIP_FLAGS ${pyqt_config})
    STRING(REGEX REPLACE ".*\npyqt_bin_dir:([^\n]+).*$" "\\1" PYQT5_BIN_DIR ${pyqt_config})

    SET(PYUIC_PROG_NAME pyuic5)
    SET(PYUIC_PROG_NAMES python2-pyuic5 pyuic5)
    SET(PYRCC_PROG_NAME pyrcc5

    SET(PYQT5_SIP_FLAGS ${PYQT5_SIP_FLAGS} CACHE INTERNAL "PyQt5 sip flags")
    SET(PYQT5_SIP_DIR ${PYQT5_SIP_DIR} CACHE INTERNAL "PyQt5 sip dir")

    IF (MSVC)
        FIND_PROGRAM(PYUIC_PROGRAM
            NAMES ${PYUIC_PROG_NAME}.bat
            PATHS $ENV{LIB_DIR}/bin
        )

        FIND_PROGRAM(PYRCC_PROGRAM
          NAMES ${PYRCC_PROG_NAME}.exe
          PATHS $ENV{LIB_DIR}/bin
        )
    ELSE()
        FIND_PROGRAM(PYUIC_PROGRAM NAMES ${PYUIC_PROG_NAMES})
        FIND_PROGRAM(PYRCC_PROGRAM ${PYRCC_PROG_NAME})
    ENDIF()

    IF (PYUIC_PROGRAM AND PYRCC_PROGRAM)
        set(PYQT5_PYUIC_PROGRAM ${PYUIC_PROGRAM} CACHE INTERNAL "pyqt5 pyuick program")
        set(PYQT5_PYRCC_PROGRAM ${PYRCC_PROGRAM} CACHE INTERNAL "pyqt5 pyrcc program")
        set(PYQT5_FOUND TRUE)
    ENDIF()

  ENDIF()

    IF(PYQT5_FOUND)
        IF(NOT PYQT5_FIND_QUIETLY)
            MESSAGE(STATUS "Found PyQt5 version: ${PYQT5_VERSION_STR}")
        ENDIF(NOT PYQT5_FIND_QUIETLY)
    ELSE(PYQT5_FOUND)
        IF(PYQT5_FIND_REQUIRED)
            MESSAGE(FATAL_ERROR "Could not find Python")
        ENDIF(PYQT5_FIND_REQUIRED)
    ENDIF(PYQT5_FOUND)

ENDIF()
