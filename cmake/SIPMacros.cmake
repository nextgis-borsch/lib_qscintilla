# Macros for SIP
# ~~~~~~~~~~~~~~
# Copyright (c) 2007, Simon Edwards <simon@simonzone.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# SIP website: http://www.riverbankcomputing.co.uk/sip/index.php
#
# This file defines the following macros:
#
# ADD_SIP_PYTHON_MODULE (MODULE_NAME MODULE_SIP [library1, libaray2, ...])
#     Specifies a SIP file to be built into a Python module and installed.
#     MODULE_NAME is the name of Python module including any path name. (e.g.
#     os.sys, Foo.bar etc). MODULE_SIP the path and filename of the .sip file
#     to process and compile. libraryN are libraries that the Python module,
#     which is typically a shared library, should be linked to. The built
#     module will also be install into Python's site-packages directory.
#
# The behaviour of the ADD_SIP_PYTHON_MODULE macro can be controlled by a
# number of variables:
#
# SIP_INCLUDES - List of directories which SIP will scan through when looking
#     for included .sip files. (Corresponds to the -I option for SIP.)
#
# SIP_TAGS - List of tags to define when running SIP. (Corresponds to the -t
#     option for SIP.)
#
# SIP_CONCAT_PARTS - An integer which defines the number of parts the C++ code
#     of each module should be split into. Defaults to 8. (Corresponds to the
#     -j option for SIP.)
#
# SIP_DISABLE_FEATURES - List of feature names which should be disabled
#     running SIP. (Corresponds to the -x option for SIP.)
#
# SIP_EXTRA_OPTIONS - Extra command line options which should be passed on to
#     SIP.

SET(SIP_INCLUDES)
SET(SIP_TAGS)
SET(SIP_CONCAT_PARTS 8)
SET(SIP_DISABLE_FEATURES)
SET(SIP_EXTRA_OPTIONS)

MACRO(ADD_SIP_PYTHON_MODULE MODULE_NAME MODULE_SIP)

    SET(EXTRA_LINK_LIBRARIES ${ARGN})

    STRING(REPLACE "." "/" _x ${MODULE_NAME})
    GET_FILENAME_COMPONENT(_parent_module_path ${_x} PATH)
    GET_FILENAME_COMPONENT(_child_module_name ${_x} NAME)

    GET_FILENAME_COMPONENT(_module_path ${MODULE_SIP} PATH)
    GET_FILENAME_COMPONENT(_abs_module_sip ${MODULE_SIP} ABSOLUTE)

    # We give this target a long logical target name.
    # (This is to avoid having the library name clash with any already
    # install library names. If that happens then cmake dependency
    # tracking get confused.)
    STRING(REPLACE "." "_" _logical_name ${MODULE_NAME})
    SET(_logical_name "python_module_${_logical_name}")

    FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${_module_path})    # Output goes in this dir.

    SET(_sip_includes)
    FOREACH (_inc ${SIP_INCLUDES})
        GET_FILENAME_COMPONENT(_abs_inc ${_inc} ABSOLUTE)
        LIST(APPEND _sip_includes -I ${_abs_inc})
    ENDFOREACH (_inc )

    SET(_sip_tags)
    FOREACH (_tag ${SIP_TAGS})
        LIST(APPEND _sip_tags -t ${_tag})
    ENDFOREACH (_tag)

    SET(_sip_x)
    FOREACH (_x ${SIP_DISABLE_FEATURES})
        LIST(APPEND _sip_x -x ${_x})
    ENDFOREACH (_x ${SIP_DISABLE_FEATURES})

    SET(_message "-DMESSAGE=Generating CPP code for module ${MODULE_NAME}")
    SET(_sip_output_files)
    FOREACH(CONCAT_NUM RANGE 0 ${SIP_CONCAT_PARTS} )
        IF( ${CONCAT_NUM} LESS ${SIP_CONCAT_PARTS} )
            SET(_sip_output_files ${_sip_output_files} ${CMAKE_CURRENT_BINARY_DIR}/${_module_path}/sip${_child_module_name}part${CONCAT_NUM}.cpp )
        ENDIF( ${CONCAT_NUM} LESS ${SIP_CONCAT_PARTS} )
    ENDFOREACH(CONCAT_NUM RANGE 0 ${SIP_CONCAT_PARTS} )

    # Suppress warnings
    IF(PEDANTIC)
      IF(MSVC)
        # 4996 deprecation warnings (bindings re-export deprecated methods)
        # 4701 potentially uninitialized variable used (sip generated code)
        # 4702 unreachable code (sip generated code)
        ADD_DEFINITIONS( /wd4996 /wd4701 /wd4702 -DQSCINTILLA_MAKE_DLL )
      ELSE(MSVC)
        # disable all warnings
        ADD_DEFINITIONS( -w -Wno-deprecated-declarations )
        IF(NOT APPLE)
          ADD_DEFINITIONS( -fpermissive )
        ENDIF(NOT APPLE)
      ENDIF(MSVC)
    ENDIF(PEDANTIC)


    SET(SIPCMD ${SIP_BINARY_PATH} ${_sip_tags} -w -e ${_sip_x} ${SIP_EXTRA_OPTIONS} -j ${SIP_CONCAT_PARTS} -c ${CMAKE_CURRENT_BINARY_DIR}/${_module_path} ${_sip_includes} ${_abs_module_sip})
    SET(SUPPRESS_SIP_WARNINGS FALSE CACHE BOOL "Hide SIP warnings")
    MARK_AS_ADVANCED(SUPPRESS_SIP_WARNINGS)
    IF(SUPPRESS_SIP_WARNINGS)
      SET(SIPCMD ${SIPCMD} 2> /dev/null || true)
    ENDIF(SUPPRESS_SIP_WARNINGS)

    ADD_CUSTOM_COMMAND(
        OUTPUT ${_sip_output_files}
        COMMAND ${CMAKE_COMMAND} -E echo ${message}
        COMMAND ${CMAKE_COMMAND} -E touch ${_sip_output_files}
        COMMAND ${SIPCMD}
        DEPENDS ${_abs_module_sip} ${SIP_EXTRA_FILES_DEPEND}
        VERBATIM
    )
    
    set(T_QSCI_HHEADERS
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qsciglobal.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qsciscintilla.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qsciscintillabase.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qsciabstractapis.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qsciapis.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscicommand.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscicommandset.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscidocument.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexer.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexeravs.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerbash.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerbatch.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexercmake.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexercoffeescript.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexercpp.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexercsharp.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexercss.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexercustom.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerd.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerdiff.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexeredifact.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerfortran.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerfortran77.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerhtml.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexeridl.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerjava.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerjavascript.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerjson.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerlua.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexermakefile.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexermarkdown.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexermatlab.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexeroctave.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerpascal.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerperl.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerpostscript.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerpo.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerpov.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerproperties.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerpython.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerruby.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerspice.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexersql.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexertcl.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexertex.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerverilog.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexervhdl.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexerxml.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscilexeryaml.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscimacro.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qsciprinter.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscistyle.h
        ${CMAKE_SOURCE_DIR}/qt/Qsci/qscistyledtext.h

        ${CMAKE_SOURCE_DIR}/qt/ListBoxQt.h
        ${CMAKE_SOURCE_DIR}/qt/SciClasses.h
        ${CMAKE_SOURCE_DIR}/qt/ScintillaQt.h
        ${CMAKE_SOURCE_DIR}/include/ILexer.h
        ${CMAKE_SOURCE_DIR}/include/Platform.h
        ${CMAKE_SOURCE_DIR}/include/SciLexer.h
        ${CMAKE_SOURCE_DIR}/include/Scintilla.h
        ${CMAKE_SOURCE_DIR}/include/ScintillaWidget.h
        ${CMAKE_SOURCE_DIR}/lexlib/Accessor.h
        ${CMAKE_SOURCE_DIR}/lexlib/CharacterCategory.h
        ${CMAKE_SOURCE_DIR}/lexlib/CharacterSet.h
        ${CMAKE_SOURCE_DIR}/lexlib/DefaultLexer.h
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
        ${CMAKE_SOURCE_DIR}/src/UniConversion.h
        ${CMAKE_SOURCE_DIR}/src/ViewStyle.h
        ${CMAKE_SOURCE_DIR}/src/XPM.h


        ${CMAKE_SOURCE_DIR}/qt/qsciscintilla.cpp
        ${CMAKE_SOURCE_DIR}/qt/qsciscintillabase.cpp
        ${CMAKE_SOURCE_DIR}/qt/qsciabstractapis.cpp
        ${CMAKE_SOURCE_DIR}/qt/qsciapis.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscicommand.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscicommandset.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscidocument.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexer.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexeravs.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerbash.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerbatch.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexercmake.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexercoffeescript.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexercpp.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexercsharp.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexercss.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexercustom.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerd.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerdiff.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexeredifact.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerfortran.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerfortran77.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerhtml.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexeridl.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerjava.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerjavascript.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerjson.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerlua.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexermakefile.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexermatlab.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexeroctave.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerpascal.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerperl.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerpostscript.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerpo.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerpov.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerproperties.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerpython.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerruby.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerspice.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexersql.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexertcl.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexertex.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerverilog.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexervhdl.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexerxml.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexeryaml.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscimacro.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscilexermarkdown.cpp
        ${CMAKE_SOURCE_DIR}/qt/qsciprinter.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscistyle.cpp
        ${CMAKE_SOURCE_DIR}/qt/qscistyledtext.cpp
        ${CMAKE_SOURCE_DIR}/qt/MacPasteboardMime.cpp
        ${CMAKE_SOURCE_DIR}/qt/InputMethod.cpp
        ${CMAKE_SOURCE_DIR}/qt/SciClasses.cpp
        ${CMAKE_SOURCE_DIR}/qt/ListBoxQt.cpp
        ${CMAKE_SOURCE_DIR}/qt/PlatQt.cpp
        ${CMAKE_SOURCE_DIR}/qt/ScintillaQt.cpp
        ${CMAKE_SOURCE_DIR}/qt/SciAccessibility.cpp
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
        ${CMAKE_SOURCE_DIR}/lexers/LexBatch.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexBibTeX.cpp
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
        ${CMAKE_SOURCE_DIR}/lexers/LexDiff.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexDMAP.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexDMIS.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexEDIFACT.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexECL.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexEiffel.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexErlang.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexErrorList.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexEScript.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexFlagship.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexForth.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexFortran.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexGAP.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexGui4Cli.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexHaskell.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexHex.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexHTML.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexIndent.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexInno.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexJSON.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexKix.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexKVIrc.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexLaTeX.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexLisp.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexLout.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexLPeg.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexLua.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexMagik.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexMake.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexMarkdown.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexMatlab.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexMaxima.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexMetapost.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexMMIXAL.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexModula.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexMPT.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexMSSQL.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexMySQL.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexNimrod.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexNsis.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexNull.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexOpal.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexOScript.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexPascal.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexPB.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexPerl.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexPLM.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexPO.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexPOV.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexPowerPro.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexPowerShell.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexProgress.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexProps.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexPS.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexPython.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexR.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexRebol.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexRegistry.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexRuby.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexRust.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexSAS.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexScriptol.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexSmalltalk.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexSML.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexSorcus.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexSpecman.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexSpice.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexSQL.cpp
        ${CMAKE_SOURCE_DIR}/lexers/LexStata.cpp
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
        ${CMAKE_SOURCE_DIR}/lexlib/DefaultLexer.cpp
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
        ${CMAKE_SOURCE_DIR}/src/DBCS.cpp
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
    
    # not sure if type MODULE could be uses anywhere, limit to cygwin for now
    IF (CYGWIN OR APPLE)
        ADD_LIBRARY(${_logical_name} MODULE ${_sip_output_files} )
    ELSE (CYGWIN OR APPLE)
        ADD_LIBRARY(${_logical_name} SHARED ${_sip_output_files} ${T_QSCI_HHEADERS})
    ENDIF (CYGWIN OR APPLE)
    IF (NOT APPLE)
        TARGET_LINK_LIBRARIES(${_logical_name} ${PYTHON_LIBRARY})
    ENDIF (NOT APPLE)
    TARGET_LINK_LIBRARIES(${_logical_name} ${EXTRA_LINK_LIBRARIES})
    IF (APPLE)
        SET_TARGET_PROPERTIES(${_logical_name} PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
    ENDIF (APPLE)
    SET_TARGET_PROPERTIES(${_logical_name} PROPERTIES PREFIX "" OUTPUT_NAME ${_child_module_name})
    if(OSX_FRAMEWORK)
        set_target_properties(${_logical_name} PROPERTIES
            INSTALL_RPATH "@loader_path/../../../../Frameworks/"
        )
    endif()

    IF (WIN32)
      SET_TARGET_PROPERTIES(${_logical_name} PROPERTIES SUFFIX ".pyd"
        DEFINE_SYMBOL QSCINTILLA_MAKE_DLL
      )
    ENDIF (WIN32)

    IF(WIN32)
      GET_TARGET_PROPERTY(_runtime_output ${_logical_name} RUNTIME_OUTPUT_DIRECTORY)
      ADD_CUSTOM_COMMAND(TARGET ${_logical_name} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E echo "Copying extension ${_child_module_name}"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "$<TARGET_FILE:${_logical_name}>" "${_runtime_output}/${_child_module_name}.pyd"
        DEPENDS ${_logical_name}
      )
    ENDIF(WIN32)

    INSTALL(TARGETS ${_logical_name} DESTINATION "${INSTALL_PYTHON_DIR}/${_parent_module_path}")

ENDMACRO(ADD_SIP_PYTHON_MODULE)
