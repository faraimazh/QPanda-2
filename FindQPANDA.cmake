#.rst:
# FindQPANDA
# --------
#
# Find qpanda
#
# Find the native qpanda headers and libraries.
#
# ::
#
#   QPANDA_INCLUDE_DIR    - QPanda-2 include  etc.
#   THIRD_INCLUDE_DIR     - ThirdParty include
#   QPANDA_LIBRARIES      - List of libraries when using QPanda.
#   QALG_LIBRARY          - QAlg library
#   COMPONENTS_LIBRARY           - Variational library
#   TINY_LIBRARY          - TinyXML library
#   ANTLR4_LIBRARY        - antlr4 library
#   QPANDA_LIBRARY        - QPanda-2 library
#   QPANDA_FOUND          - True if curl found.
#   


# Look for the header file.
find_path(QPANDA_INCLUDE_DIR NAMES qpanda2/Core/QPanda.h qpanda2/QPandaVersion.h 
          PATHS 
          ${QPANDA_INSTALL_DIR}/include)
set(QPANDA_INCLUDE_DIR "${QPANDA_INCLUDE_DIR}/qpanda2/")

find_path(THIRD_INCLUDE_DIR NAMES qpanda2/ThirdParty/TinyXML/tinyxml.h 
          PATHS 
          ${QPANDA_INSTALL_DIR}/include)
include_directories(${THIRD_INCLUDE_DIR}/qpanda2/ThirdParty)
mark_as_advanced(QPANDA_INCLUDE_DIR)

# Look for the library (sorted from most current/relevant entry to least).
find_library(QALG_LIBRARY NAMES QAlg 
             PATHS 
             ${QPANDA_INSTALL_DIR}/lib)
find_library(QPANDA_LIBRARY NAMES QPanda2 
             PATHS 
             ${QPANDA_INSTALL_DIR}/lib)
find_library(COMPONENTS_LIBRARY NAMES Components 
             PATHS 
             ${QPANDA_INSTALL_DIR}/lib)
find_library(TINY_LIBRARY NAMES TinyXML 
             PATHS 
             ${QPANDA_INSTALL_DIR}/lib)
find_library(ANTLR4_LIBRARY NAMES antlr4 
             PATHS 
             ${QPANDA_INSTALL_DIR}/lib)

mark_as_advanced(QPANDA_LIBRARY)
mark_as_advanced(QALG_LIBRARY)
mark_as_advanced(COMPONENTS_LIBRARY)
mark_as_advanced(TINY_LIBRARY)
mark_as_advanced(ANTLR4_LIBRARY)

if(QPANDA_INCLUDE_DIR AND QPANDA_LIBRARY)
    set(QPANDA_FOUND TRUE)
    set(QPANDA_LIBRARIES ${QPANDA_LIBRARY} ${QALG_LIBRARY} ${COMPONENTS_LIBRARY} ${TINY_LIBRARY} ${ANTLR4_LIBRARY})
    mark_as_advanced(QPANDA_LIBRARIES)
    if(QPANDA_INCLUDE_DIR AND NOT QPANDA_VERSION_STRING)
        foreach(_qpanda_version_header QPandaVersion.h)
            if(EXISTS "${QPANDA_INCLUDE_DIR}/${_qpanda_version_header}")
                file(READ "${QPANDA_INCLUDE_DIR}/${_qpanda_version_header}" QPANDA_VERSION_H_CONTENTS)

                string(REGEX MATCH "#define QPANDA_MAJOR_VERSION [0-9]+"
                QPANDA_MAJOR_VERSION ${QPANDA_VERSION_H_CONTENTS})
                string(REGEX REPLACE "[^0-9]" "" QPANDA_MAJOR_VERSION ${QPANDA_MAJOR_VERSION})

                string(REGEX MATCH "#define QPANDA_MINOR_VERSION [0-9]+"
                QPANDA_MINOR_VERSION ${QPANDA_VERSION_H_CONTENTS})
                string(REGEX REPLACE "[^0-9]" "" QPANDA_MINOR_VERSION ${QPANDA_MINOR_VERSION})

                string(REGEX MATCH "#define QPANDA_PATCH_VERSION [0-9]+"
                QPANDA_PATCH_VERSION ${QPANDA_VERSION_H_CONTENTS})
                string(REGEX REPLACE "[^0-9]" "" QPANDA_PATCH_VERSION ${QPANDA_PATCH_VERSION})
                set(QPANDA_VERSION_STR "${QPANDA_MAJOR_VERSION}.${QPANDA_MINOR_VERSION}.${QPANDA_PATCH_VERSION}")
                unset(qpanda_version_str)
                break()
            endif()
        endforeach()
    endif()
else(QPANDA_INCLUDE_DIR AND QPANDA_LIBRARY)
    message("QPANDA Not Find")
endif(QPANDA_INCLUDE_DIR AND QPANDA_LIBRARY)

include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args(QPANDA
                                  REQUIRED_VARS QPANDA_LIBRARY QPANDA_INCLUDE_DIR
                                  VERSION_VAR QPANDA_VERSION_STR
                                  HANDLE_COMPONENTS)
