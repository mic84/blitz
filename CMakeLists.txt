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

option(ENABLE_THREADSAFE "Enable thread-safety features" OFF)
if (ENABLE_THREADSAFE)
   option(THREADSAFE_USE_TBB "Use Intel Threading Building Blocks atomic types" OFF)
   if (THREADSAFE_USE_TBB)
      message(FATAL_ERROR "Building Intel Threading Building Blocks is not yet supported in CMake builds")
   endif ()
endif ()

set(ENABLE_SIMD_WIDTH "0" CACHE STRING
   "SIMD_WIDTH=N facilitate compiler vectorization optimizations 
   for SIMD instruction width of N bytes." )

option(ENABLE_ARRAY_LENGHT_PADDING
   "Sets the default array padding policy to pad all 
   lowest-rank lengths to nearest larger SIMD width.
   Caution: This means that arrays will in general be non-contiguous."
   OFF)
if (ENABLE_ARRAY_LENGHT_PADDING AND (${ENABLE_SIMD_WIDTH} LESS_EQUAL 1))
   message(WARNING "ENABLE_ARRAY_LENGHT_PADDING option is useless without ENABLE_SIMD_WIDTH > 1")
endif ()

option(ENABLE_SERIALIZATION
   "Enable serialization support using Boost::Serialization"
   OFF )

option(ENABLE_TESTSUITE "Enable test suite" OFF)

#
# Setup library
# 
add_library(blitz "") 
target_include_directories(blitz PUBLIC
   $<INSTALL_INTERFACE:include>
   )

#
# Look for external libraries we may need
# Autotool serach for PAPI. At the moment we do not
#
if (ENABLE_THREADSAFE AND NOT THREADSAFE_USE_TBB )
   # Look first for P-threads and, if not found,
   # look for OpenMP
   set(THREADS_PREFER_PTHREAD_FLAG TRUE)
   find_package(Threads)
   if (Threads_FOUND)
      target_link_libraries(blitz PUBLIC Threads::Threads)
   else ()
      find_package(OpenMP REQUIRED)
      target_link_libraries(blitz PUBLIC OpenMP::OpenMP_CXX)
   endif ()
endif ()

if (ENABLE_SERIALIZATION)
   find_package(Boost 1.40 REQUIRED COMPONENTS serialization)
   if ( NOT TARGET Boost::serialization)
      add_library(Boost::serialization IMPORTED INTERFACE)
      set_property(TARGET Boost::serialization PROPERTY
         INTERFACE_INCLUDE_DIRECTORIES ${Boost_INCLUDE_DIR})
      set_property(TARGET Boost::serialization PROPERTY
         INTERFACE_LINK_LIBRARIES ${Boost_LIBRARIES})
   endif()
   target_link_libraries(blitz PUBLIC Boost::serialization)
endif ()

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


#
# Process subdirectories
# 
add_subdirectory(blitz)
add_subdirectory(blitz/array)
add_subdirectory(blitz/meta)
add_subdirectory(random)

#
# Test suite
#
if (ENABLE_TESTSUITE)
   enable_testing()
   add_subdirectory(testsuite EXCLUDE_FROM_ALL)
endif ()

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






