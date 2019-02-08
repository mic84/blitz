macro (generate_blitz_config_file)

   # Modules we need
   include(CheckIncludeFileCXX)
   include(CheckIncludeFiles)
   include(BlitzCompilerChecks)
   

   unset(HAVE_BOOST_MPI_HPP)


   set(SEMICOLUMN "-SC-") #This will indicate actual ";" and not item separator in lists
   if (${ENABLE_SIMD_WIDTH} EQUAL "1")
      set(ALIGN_VARIABLE "(vartype,varname,alignment) vartype varname${SEMICOLUMN}")
   endif ()
   execute_process(COMMAND date OUTPUT_VARIABLE _config_date
      OUTPUT_STRIP_TRAILING_WHITESPACE)
   execute_process(COMMAND uname -a OUTPUT_VARIABLE _os_name
      OUTPUT_STRIP_TRAILING_WHITESPACE)
   set(_platform ${CMAKE_HOST_SYSTEM_PROCESSOR})
   get_filename_component(_compiler_name "${CMAKE_CXX_COMPILER}" NAME)

   #
   # Setup preprocessor directives based on compiler features
   #
   cxx_namespaces()
   cxx_have_bool()
   check_include_file_cxx("climits" HAVE_CLIMITS)
   cxx_have_complex()
   cxx_have_complex_fcns()
   cxx_have_complex_math1()
   cxx_have_complex_math2()
   cxx_have_complex_math_in_namespace_std()
   cxx_have_const_cast()
   cxx_have_default_template_params()
   check_include_file_cxx("dlfcn.h"      HAVE_DLFCN_H)
   cxx_have_dynamic_cast()
   check_include_file_cxx("cstring"      HAVE_CSTRING)
   cxx_have_enum_computations()
   cxx_have_enum_comp_with_cast()
   cxx_have_exceptions()
   cxx_have_explicit()
   cxx_have_explicit_template_func_qual()
   cxx_have_full_specialization_syntax()
   cxx_have_function_nontype_parameters()
   cxx_have_ieee_math()
   check_include_file_cxx("inttypes.h"   HAVE_INTTYPES_H)
   cxx_have_member_constants()
   cxx_have_member_templates()
   cxx_have_member_templates_outside_class()
   check_include_file_cxx("memory.h"     HAVE_MEMORY_H)
   cxx_have_mutable()
   cxx_have_nceg_restrict()
   cxx_have_nceg_restrict_egcs()
   cxx_have_numeric_limits()
   cxx_have_old_for_scoping()
   cxx_have_partial_ordering()
   cxx_have_partial_ordering_specialization()
   cxx_have_reinterpret_cast()
   cxx_have_rtti()
   cxx_have_rusage()
   cxx_have_static_cast()
   cxx_have_std()
   check_include_file_cxx("stdint.h"     HAVE_STDINT_H)
   check_include_file_cxx("stdlib.h"     HAVE_STDLIB_H)
   cxx_have_stl()
   check_include_file_cxx("string.h"     HAVE_STRING_H)
   check_include_file_cxx("strings.h"    HAVE_STRINGS_H)
   cxx_have_system_v_math()
   check_include_file_cxx("sys/stat.h"   HAVE_SYS_STAT_H)
   check_include_file_cxx("sys/types.h"  HAVE_SYS_TYPES_H)
   check_include_file_cxx("tbb/atomic.h" HAVE_TBB_ATOMIC_H)
   cxx_have_typename()
   cxx_have_templates()
   cxx_have_templates_as_templates_args()
   cxx_have_template_keyword_qualifier()
   cxx_have_template_qualified_base_class()
   cxx_have_template_qualified_return_type()
   cxx_have_template_scoped_arg_matching()
   cxx_have_type_promotion()
   check_include_file_cxx("unistd.h" HAVE_UNISTD_H)
   cxx_have_numtrait()
   cxx_have_valarray()
   cxx_have_isnan_in_std()
   cxx_have_absint_in_std()
   cxx_have_math_fn_in_std()
   set(SIMD_WIDTH ${ENABLE_SIMD_WIDTH})

   # Let's assume that the standard headers exists
   set(STDC_HEADERS 1)


   #
   # Generate compiler specific header (bzconfig.h)
   #
   configure_file(cmake/config.h.in ${CMAKE_BINARY_DIR}/config.h)
   file(STRINGS  "${CMAKE_BINARY_DIR}/config.h" config_h)
   # The following commented-out two lines could, in principle, replace the above two
   # lines and handle everything "internally" without creating a futher config.h file.
   # However using CONFIGURE feature of STRING makes every define True
   # file(STRINGS "${PROJECT_SOURCE_DIR}/cmake/config.h.in" config_h_in )
   # string(CONFIGURE "${config_h_in}" config_h)
   # print_list(config_h)
   string(TOLOWER "${CMAKE_CXX_COMPILER_ID}" comp_lower)
   string(TOUPPER "${CMAKE_CXX_COMPILER_ID}" comp_upper)
   set(comp_header "${comp_lower}/bzconfig.h")
   string(REPLACE "#define " "#define BZ_" config_h "${config_h}")
   set(bzconfig_content "#ifndef _BLITZ_${comp_upper}_BZCONFIG_H")
   list(APPEND bzconfig_content "#define _BLITZ_${comp_upper}_BZCONFIG_H 1;;")
   foreach(item IN LISTS config_h)
      string(FIND "${item}" "#define" idx)
      if (${idx} GREATER -1)
         string(REPLACE " " ";" item_list "${item}")
         string(REPLACE "(" ";" item_list "${item_list}")
         list(GET item_list 1 var_name)
         list(APPEND bzconfig_content "#ifndef ${var_name}")
         list(APPEND bzconfig_content "${item}")
         list(APPEND bzconfig_content "#endif")      
      else ()
         list(APPEND bzconfig_content "${item}")
      endif ()
   endforeach ()
   list(APPEND bzconfig_content "#endif")
   string(REPLACE ";" "\n" bzconfig_content "${bzconfig_content}")
   string(REPLACE "${SEMICOLUMN}" ";" bzconfig_content "${bzconfig_content}")
   file(WRITE "${CMAKE_BINARY_DIR}/blitz/${comp_lower}/bzconfig.h" "${bzconfig_content}")

   target_include_directories(blitz PUBLIC $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}>)

   install(FILES "${CMAKE_BINARY_DIR}/blitz/${comp_lower}/bzconfig.h"
      DESTINATION "include/blitz/${comp_lower}/")

endmacro ()
