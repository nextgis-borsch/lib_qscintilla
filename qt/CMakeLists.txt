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
if(QT4_BUILD)
    add_definitions(-DQT_NO_ACCESSIBILITY)
endif()

set(QSCI_HHEADERS
	Qsci/qsciglobal.h
	Qsci/qsciscintilla.h
	Qsci/qsciscintillabase.h
	Qsci/qsciabstractapis.h
	Qsci/qsciapis.h
	Qsci/qscicommand.h
	Qsci/qscicommandset.h
	Qsci/qscidocument.h
	Qsci/qscilexer.h
	Qsci/qscilexeravs.h
	Qsci/qscilexerbash.h
	Qsci/qscilexerbatch.h
	Qsci/qscilexercmake.h
	Qsci/qscilexercoffeescript.h
	Qsci/qscilexercpp.h
	Qsci/qscilexercsharp.h
	Qsci/qscilexercss.h
	Qsci/qscilexercustom.h
	Qsci/qscilexerd.h
	Qsci/qscilexerdiff.h
	Qsci/qscilexerfortran.h
	Qsci/qscilexerfortran77.h
	Qsci/qscilexerhtml.h
	Qsci/qscilexeridl.h
	Qsci/qscilexerjava.h
	Qsci/qscilexerjavascript.h
	Qsci/qscilexerjson.h
	Qsci/qscilexerlua.h
	Qsci/qscilexermakefile.h
	Qsci/qscilexermarkdown.h
	Qsci/qscilexermatlab.h
	Qsci/qscilexeroctave.h
	Qsci/qscilexerpascal.h
	Qsci/qscilexerperl.h
	Qsci/qscilexerpostscript.h
	Qsci/qscilexerpo.h
	Qsci/qscilexerpov.h
	Qsci/qscilexerproperties.h
	Qsci/qscilexerpython.h
	Qsci/qscilexerruby.h
	Qsci/qscilexerspice.h
	Qsci/qscilexersql.h
	Qsci/qscilexertcl.h
	Qsci/qscilexertex.h
	Qsci/qscilexerverilog.h
	Qsci/qscilexervhdl.h
	Qsci/qscilexerxml.h
	Qsci/qscilexeryaml.h
	Qsci/qscimacro.h
	Qsci/qsciprinter.h
	Qsci/qscistyle.h
	Qsci/qscistyledtext.h
)

set(HHEADERS
	ListBoxQt.h
	SciClasses.h
	SciNamespace.h
	ScintillaQt.h
	${CMAKE_SOURCE_DIR}/include/ILexer.h
	${CMAKE_SOURCE_DIR}/include/Platform.h
	${CMAKE_SOURCE_DIR}/include/SciLexer.h
	${CMAKE_SOURCE_DIR}/include/Scintilla.h
	${CMAKE_SOURCE_DIR}/include/ScintillaWidget.h
	${CMAKE_SOURCE_DIR}/lexlib/Accessor.h
	${CMAKE_SOURCE_DIR}/lexlib/CharacterCategory.h
	${CMAKE_SOURCE_DIR}/lexlib/CharacterSet.h
	${CMAKE_SOURCE_DIR}/lexlib/LexAccessor.h
	${CMAKE_SOURCE_DIR}/lexlib/LexerBase.h
	${CMAKE_SOURCE_DIR}/lexlib/LexerModule.h
	${CMAKE_SOURCE_DIR}/lexlib/LexerNoExceptions.h
	${CMAKE_SOURCE_DIR}/lexlib/LexerSimple.h
	${CMAKE_SOURCE_DIR}/lexlib/OptionSet.h
	${CMAKE_SOURCE_DIR}/lexlib/PropSetSimple.h
	${CMAKE_SOURCE_DIR}/lexlib/StringCopy.h
	${CMAKE_SOURCE_DIR}/lexlib/StyleContext.h
	${CMAKE_SOURCE_DIR}/lexlib/SubStyles.h
	${CMAKE_SOURCE_DIR}/lexlib/WordList.h
	${CMAKE_SOURCE_DIR}/src/AutoComplete.h
	${CMAKE_SOURCE_DIR}/src/CallTip.h
	${CMAKE_SOURCE_DIR}/src/CaseConvert.h
	${CMAKE_SOURCE_DIR}/src/CaseFolder.h
	${CMAKE_SOURCE_DIR}/src/Catalogue.h
	${CMAKE_SOURCE_DIR}/src/CellBuffer.h
	${CMAKE_SOURCE_DIR}/src/CharClassify.h
	${CMAKE_SOURCE_DIR}/src/ContractionState.h
	${CMAKE_SOURCE_DIR}/src/Decoration.h
	${CMAKE_SOURCE_DIR}/src/Document.h
	${CMAKE_SOURCE_DIR}/src/EditModel.h
	${CMAKE_SOURCE_DIR}/src/Editor.h
	${CMAKE_SOURCE_DIR}/src/EditView.h
	${CMAKE_SOURCE_DIR}/src/ExternalLexer.h
	${CMAKE_SOURCE_DIR}/src/FontQuality.h
	${CMAKE_SOURCE_DIR}/src/Indicator.h
	${CMAKE_SOURCE_DIR}/src/KeyMap.h
	${CMAKE_SOURCE_DIR}/src/LineMarker.h
	${CMAKE_SOURCE_DIR}/src/MarginView.h
	${CMAKE_SOURCE_DIR}/src/Partitioning.h
	${CMAKE_SOURCE_DIR}/src/PerLine.h
	${CMAKE_SOURCE_DIR}/src/PositionCache.h
	${CMAKE_SOURCE_DIR}/src/RESearch.h
	${CMAKE_SOURCE_DIR}/src/RunStyles.h
	${CMAKE_SOURCE_DIR}/src/ScintillaBase.h
	${CMAKE_SOURCE_DIR}/src/Selection.h
	${CMAKE_SOURCE_DIR}/src/SplitVector.h
	${CMAKE_SOURCE_DIR}/src/Style.h
	${CMAKE_SOURCE_DIR}/src/UnicodeFromUTF8.h
	${CMAKE_SOURCE_DIR}/src/UniConversion.h
	${CMAKE_SOURCE_DIR}/src/ViewStyle.h
	${CMAKE_SOURCE_DIR}/src/XPM.h
)

set(CSOURCES
	qsciscintilla.cpp
	qsciscintillabase.cpp
	qsciabstractapis.cpp
	qsciapis.cpp
	qscicommand.cpp
	qscicommandset.cpp
	qscidocument.cpp
	qscilexer.cpp
	qscilexeravs.cpp
	qscilexerbash.cpp
	qscilexerbatch.cpp
	qscilexercmake.cpp
	qscilexercoffeescript.cpp
	qscilexercpp.cpp
	qscilexercsharp.cpp
	qscilexercss.cpp
	qscilexercustom.cpp
	qscilexerd.cpp
	qscilexerdiff.cpp
	qscilexerfortran.cpp
	qscilexerfortran77.cpp
	qscilexerhtml.cpp
	qscilexeridl.cpp
	qscilexerjava.cpp
	qscilexerjavascript.cpp
    qscilexerjson.cpp
	qscilexerlua.cpp
	qscilexermakefile.cpp
	qscilexermatlab.cpp
	qscilexeroctave.cpp
	qscilexerpascal.cpp
	qscilexerperl.cpp
	qscilexerpostscript.cpp
	qscilexerpo.cpp
	qscilexerpov.cpp
	qscilexerproperties.cpp
	qscilexerpython.cpp
	qscilexerruby.cpp
	qscilexerspice.cpp
	qscilexersql.cpp
	qscilexertcl.cpp
	qscilexertex.cpp
	qscilexerverilog.cpp
	qscilexervhdl.cpp
	qscilexerxml.cpp
	qscilexeryaml.cpp
	qscimacro.cpp
    qscilexermarkdown.cpp
	qsciprinter.cpp
	qscistyle.cpp
	qscistyledtext.cpp
    MacPasteboardMime.cpp
    InputMethod.cpp
	SciClasses.cpp
	ListBoxQt.cpp
	PlatQt.cpp
	ScintillaQt.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexA68k.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexAbaqus.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexAda.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexAPDL.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexAsm.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexAsn1.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexASY.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexAU3.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexAVE.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexAVS.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexBaan.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexBash.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexBasic.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexBibTex.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexBullant.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexCaml.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexCLW.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexCmake.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexCOBOL.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexCoffeeScript.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexConf.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexCPP.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexCrontab.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexCsound.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexCSS.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexD.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexDMAP.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexDMIS.cpp
    ${CMAKE_SOURCE_DIR}/lexers/LexEDIFACT.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexECL.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexEiffel.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexErlang.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexEScript.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexFlagship.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexForth.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexFortran.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexGAP.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexGui4Cli.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexHaskell.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexHex.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexHTML.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexInno.cpp
    ${CMAKE_SOURCE_DIR}/lexers/LexJSON.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexKix.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexKVIrc.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexLaTex.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexLisp.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexLout.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexLua.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexMagik.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexMarkdown.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexMatlab.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexMetapost.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexMMIXAL.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexModula.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexMPT.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexMSSQL.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexMySQL.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexNimrod.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexNsis.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexOpal.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexOScript.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexOthers.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexPascal.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexPB.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexPerl.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexPLM.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexPO.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexPOV.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexPowerPro.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexPowerShell.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexProgress.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexPS.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexPython.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexR.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexRebol.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexRegistry.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexRuby.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexRust.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexScriptol.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexSmalltalk.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexSML.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexSorcus.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexSpecman.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexSpice.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexSQL.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexSTTXT.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexTACL.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexTADS3.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexTAL.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexTCL.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexTCMD.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexTeX.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexTxt2tags.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexVB.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexVerilog.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexVHDL.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexVisualProlog.cpp
	${CMAKE_SOURCE_DIR}/lexers/LexYAML.cpp
	${CMAKE_SOURCE_DIR}/lexlib/Accessor.cpp
	${CMAKE_SOURCE_DIR}/lexlib/CharacterCategory.cpp
	${CMAKE_SOURCE_DIR}/lexlib/CharacterSet.cpp
	${CMAKE_SOURCE_DIR}/lexlib/LexerBase.cpp
	${CMAKE_SOURCE_DIR}/lexlib/LexerModule.cpp
	${CMAKE_SOURCE_DIR}/lexlib/LexerNoExceptions.cpp
	${CMAKE_SOURCE_DIR}/lexlib/LexerSimple.cpp
	${CMAKE_SOURCE_DIR}/lexlib/PropSetSimple.cpp
	${CMAKE_SOURCE_DIR}/lexlib/StyleContext.cpp
	${CMAKE_SOURCE_DIR}/lexlib/WordList.cpp
	${CMAKE_SOURCE_DIR}/src/AutoComplete.cpp
	${CMAKE_SOURCE_DIR}/src/CallTip.cpp
	${CMAKE_SOURCE_DIR}/src/CaseConvert.cpp
	${CMAKE_SOURCE_DIR}/src/CaseFolder.cpp
	${CMAKE_SOURCE_DIR}/src/Catalogue.cpp
	${CMAKE_SOURCE_DIR}/src/CellBuffer.cpp
	${CMAKE_SOURCE_DIR}/src/CharClassify.cpp
	${CMAKE_SOURCE_DIR}/src/ContractionState.cpp
	${CMAKE_SOURCE_DIR}/src/Decoration.cpp
	${CMAKE_SOURCE_DIR}/src/Document.cpp
	${CMAKE_SOURCE_DIR}/src/EditModel.cpp
	${CMAKE_SOURCE_DIR}/src/Editor.cpp
	${CMAKE_SOURCE_DIR}/src/EditView.cpp
	${CMAKE_SOURCE_DIR}/src/ExternalLexer.cpp
	${CMAKE_SOURCE_DIR}/src/Indicator.cpp
    ${CMAKE_SOURCE_DIR}/src/KeyMap.cpp
	${CMAKE_SOURCE_DIR}/src/LineMarker.cpp
	${CMAKE_SOURCE_DIR}/src/MarginView.cpp
	${CMAKE_SOURCE_DIR}/src/PerLine.cpp
	${CMAKE_SOURCE_DIR}/src/PositionCache.cpp
    ${CMAKE_SOURCE_DIR}/src/RESearch.cpp
	${CMAKE_SOURCE_DIR}/src/RunStyles.cpp
    ${CMAKE_SOURCE_DIR}/src/ScintillaBase.cpp
    ${CMAKE_SOURCE_DIR}/src/Selection.cpp
	${CMAKE_SOURCE_DIR}/src/Style.cpp
	${CMAKE_SOURCE_DIR}/src/UniConversion.cpp
	${CMAKE_SOURCE_DIR}/src/ViewStyle.cpp
	${CMAKE_SOURCE_DIR}/src/XPM.cpp
)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/lexlib
    ${CMAKE_SOURCE_DIR}/src
)

set(ALL_HHEADERS ${QSCI_HHEADERS} ${HHEADERS})

QT4_WRAP_CPP(QSCI_MOC_SOURCES ${ALL_HHEADERS})

if(BUILD_SHARED_LIBS)
    add_library(${LIB_NAME} SHARED ${CSOURCES} ${QSCI_MOC_SOURCES} ${ALL_HHEADERS})
    set_target_properties (${LIB_NAME} PROPERTIES
        VERSION ${VERSION}
        SOVERSION ${QSCI_MAJOR_VERSION}
        DEFINE_SYMBOL QSCINTILLA_MAKE_DLL)
elseif(OSX_FRAMEWORK)
    add_library(${LIB_NAME} SHARED ${CSOURCES} ${QSCI_MOC_SOURCES} ${ALL_HHEADERS})
    set_property(SOURCE ${QSCI_HHEADERS} PROPERTY MACOSX_PACKAGE_LOCATION "Headers/Qsci")
    set_target_properties(${LIB_NAME} PROPERTIES
      FRAMEWORK TRUE
      FRAMEWORK_VERSION ${FRAMEWORK_VERSION}
      MACOSX_FRAMEWORK_SHORT_VERSION_STRING ${VERSION}
      MACOSX_FRAMEWORK_BUNDLE_VERSION ${VERSION}
      MACOSX_FRAMEWORK_IDENTIFIER org.qscintilla.qscintilla2
      XCODE_ATTRIBUTE_INSTALL_PATH "@rpath"
      PUBLIC_HEADER "${HHEADERS}"
      VERSION ${VERSION}
      SOVERSION ${QSCI_MAJOR_VERSION}
      )
else()
    add_library(${LIB_NAME} STATIC ${CSOURCES} ${QSCI_MOC_SOURCES} ${ALL_HHEADERS})
endif()

target_link_extlibraries(${LIB_NAME})
set(TARGET_LINK_LIB ${TARGET_LINK_LIB} ${LIB_NAME} PARENT_SCOPE)

# Add path to includes to build-tree export
target_include_directories(${LIB_NAME} INTERFACE
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)

# Add all targets to the build-tree export set
export(TARGETS ${LIB_NAME}
    FILE ${PROJECT_BINARY_DIR}/${PACKAGE_UPPER_NAME}Targets.cmake)

###############################################################################
# Targets installation

if(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL)
    install(TARGETS ${LIB_NAME}
        EXPORT ${PACKAGE_UPPER_NAME}Targets
        RUNTIME DESTINATION ${INSTALL_BIN_DIR}
        LIBRARY DESTINATION ${INSTALL_LIB_DIR}
        ARCHIVE DESTINATION ${INSTALL_LIB_DIR}
        INCLUDES DESTINATION ${INSTALL_INC_DIR}
        FRAMEWORK DESTINATION ${INSTALL_LIB_DIR}
    )
endif()

if(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL)
    install(FILES ${HHEADERS} DESTINATION "${INSTALL_INC_DIR}/${PROJECT_NAME}")
    install(FILES ${QSCI_HHEADERS} DESTINATION "${INSTALL_INC_DIR}/${PROJECT_NAME}/Qsci")
endif()

if(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL)
    # Install the <Package>Config.cmake
    install(FILES
      ${PROJECT_BINARY_DIR}/${PACKAGE_UPPER_NAME}Config.cmake
      DESTINATION ${INSTALL_CMAKECONF_DIR} COMPONENT dev)

    # Install the export set for use with the install-tree
    install(EXPORT ${PACKAGE_UPPER_NAME}Targets DESTINATION ${INSTALL_CMAKECONF_DIR} COMPONENT dev)
endif()
