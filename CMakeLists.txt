cmake_minimum_required(VERSION 3.13)
project(blitz CXX)

#
# Custom module path
# 
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/modules")

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
# Optional packages
# 



#
# Generate config files
# 
if (${ENABLE_SIMD_WIDTH} STREQUAL "1")
endif ()
execute_process(COMMAND date OUTPUT_VARIABLE _config_date
   OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND uname -a OUTPUT_VARIABLE _os_name
   OUTPUT_STRIP_TRAILING_WHITESPACE)
set(_platform ${CMAKE_HOST_SYSTEM_PROCESSOR})
get_filename_component(_compiler_name "${CMAKE_CXX_COMPILER}" NAME)

include(CheckIncludeFileCXX)
include(Blitz_CompilerChecks)
cxx_namespaces(HAVE_NAMESPACES)
cxx_have_bool(HAVE_BOOL)
check_include_file_cxx("climits"      HAVE_CLIMITS)
cxx_have_complex(HAVE_COMPLEX)
cxx_have_complex_fcns(HAVE_COMPLEX_FCNS)
cxx_have_complex_math1(HAVE_COMPLEX_MATH1)
cxx_have_complex_math2(HAVE_COMPLEX_MATH2)
cxx_have_complex_math_in_std(HAVE_COMPLEX_MATH_IN_NAMESPACE_STD)
cxx_have_const_cast(HAVE_CONST_CAST)
check_include_file_cxx("cstring"      HAVE_CSTRING)
check_include_file_cxx("dlfcn.h"      HAVE_DLFCN_H)
check_include_file_cxx("inttypes.h"   HAVE_INTTYPES_H)
check_include_file_cxx("memory.h"     HAVE_MEMORY_H)
check_include_file_cxx("stdint.h"     HAVE_STDINT_H)
check_include_file_cxx("stdlib.h"     HAVE_STDLIB_H)
check_include_file_cxx("string.h"     HAVE_STRING_H)
check_include_file_cxx("strings.h"    HAVE_STRINGS_H)
check_include_file_cxx("sys/stat.h"   HAVE_SYS_STAT_H)
check_include_file_cxx("sys/types.h"  HAVE_SYS_TYPES_H)
check_include_file_cxx("tbb/atomic.h" HAVE_TBB_ATOMIC_H)

configure_file(cmake/config.h.in config/config.h)

#
# Setup library
# 
add_library(blitz "")
# target_include_directories(blitz PRIVATE ${CMAKE_CURRENT_LIST_DIR})


# add_subdirectory(blitz/array)







