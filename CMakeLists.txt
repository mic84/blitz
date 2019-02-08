cmake_minimum_required(VERSION 3.13)

#
# Custom module path
#
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

#
# Some variables 
#
set(PACKAGE "blitz")
set(VERSION "0.10" )
set(PACKAGE_VERSION "${VERSION}")
set(PACKAGE_BUGREPORT "blitz-support@lists.sourceforge.net")
set(PACKAGE_NAME "${PACKAGE}")
set(PACKAGE_STRING "${PACKAGE} ${VERSION}")
set(PACKAGE_TARNAME "blitz")
set(PACKAGE_URL "\"\"")

#
# Python 2 is required to generate some files
#
find_package(Python2 COMPONENTS Interpreter) 

#
# Project starts here
# 
project(blitz VERSION ${VERSION} LANGUAGES CXX)

#
# Optional features
# 
option(ENABLE_FORTRAN "Enable Fortran compilation" OFF )
if (ENABLE_FORTRAN)
   enable_language(Fortran)
endif ()

option(BUILD_SHARED_LIBS "Build shared libraries" OFF)

option(ENABLE_THREADSAFE OFF)

set(ENABLE_SIMD_WIDTH "1" CACHE STRING
   "ENABLE_SIMD_WIDTH=N Facilitate compiler vectorization optimizations 
   for SIMD instruction width of N bytes. " )

option(ENABLE_ARRAY_LENGHT_PADDING
   "Sets the default array padding policy to pad all 
   lowest-rank lengths to nearest larger SIMD width.
   Caution: This means that arrays will in general be non-contiguous."
   OFF)

option(ENABLE_SERIALIZATION
   "Enable serialization support using Boost::Serialization"
   OFF )

#
# Setup library
# 
add_library(blitz "") 
target_include_directories(blitz PUBLIC
   $<INSTALL_INTERFACE:include>
   )

#
# Generate config files
#
include(BlitzConfigFile)
generate_blitz_config_file()

#
# Load default compiler flags
#
include(BlitzCompilerFlags)


#
# Only source -- Requires only one include directory
#
target_sources(blitz PRIVATE src/globals.cpp)
target_include_directories(blitz PUBLIC
   $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
   )

#
# Add headers to library -- Files "*.cc" are headers only 
#
function (install_public_headers)
   foreach ( file IN LISTS ARGN )
      set(file_with_fullpath "${CMAKE_CURRENT_LIST_DIR}/${file}")
      if (NOT EXISTS "${file_with_fullpath}")
         message(FATAL_ERROR "install_public_headers(): file ${file_with_fullpath} cannot be found")
      endif ()
      file(RELATIVE_PATH relpath ${PROJECT_SOURCE_DIR} ${file_with_fullpath})
      get_filename_component(dest ${relpath} DIRECTORY)
      install(FILES "${file_with_fullpath}" DESTINATION "include/${dest}")
   endforeach()
endfunction ()

add_subdirectory(blitz)
add_subdirectory(blitz/array)
add_subdirectory(blitz/meta)
add_subdirectory(random)

#
# Test suite
#
enable_testing()
add_subdirectory(testsuite EXCLUDE_FROM_ALL)

#
# Install
#
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
   "${PROJECT_BINARY_DIR}/blitzConfigVersion.cmake"
   VERSION ${VERSION}
   COMPATIBILITY AnyNewerVersion
   )

install(TARGETS blitz
   EXPORT blitzTargets
   LIBRARY DESTINATION lib COMPONENT Runtime
   ARCHIVE DESTINATION lib COMPONENT Development
   RUNTIME DESTINATION bin COMPONENT Runtime
   PUBLIC_HEADER DESTINATION include/blitz COMPONENT Development
   BUNDLE DESTINATION bin COMPONENT Runtime
   )

include(CMakePackageConfigHelpers)
configure_package_config_file(
   "${PROJECT_SOURCE_DIR}/cmake/blitzConfig.cmake.in"
   "${PROJECT_BINARY_DIR}/blitzConfig.cmake"
   INSTALL_DESTINATION lib/cmake/blitz
   )

install(EXPORT blitzTargets DESTINATION lib/cmake/blitz)
install(FILES "${PROJECT_BINARY_DIR}/blitzConfigVersion.cmake"
   "${PROJECT_BINARY_DIR}/blitzConfig.cmake"
   DESTINATION lib/cmake/blitz)






