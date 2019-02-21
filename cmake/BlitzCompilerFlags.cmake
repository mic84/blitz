set(cxx_lang  "$<COMPILE_LANGUAGE:CXX>")
set(opt_build "$<CONFIG:Release>")
set(dbg_build "$<CONFIG:Debug>")
set(gnu       "$<CXX_COMPILER_ID:GNU>")
set(intel     "$<CXX_COMPILER_ID:Intel>")
set(pgi       "$<CXX_COMPILER_ID:PGI>")
set(clang     "$<CXX_COMPILER_ID:Clang>")
set(cray      "$<CXX_COMPILER_ID:Cray>")


set(cxx_gnu_dbg   "$<AND:${cxx_lang},${dbg_build},${gnu}>")
set(cxx_gnu_opt   "$<AND:${cxx_lang},${opt_build},${gnu}>")
set(cxx_intel_dbg "$<AND:${cxx_lang},${dbg_build},${intel}>")
set(cxx_intel_opt "$<AND:${cxx_lang},${opt_build},${intel}>")
set(cxx_pgi_dbg   "$<AND:${cxx_lang},${dbg_build},${pgi}>")
set(cxx_pgi_opt   "$<AND:${cxx_lang},${opt_build},${pgi}>")
set(cxx_clang_dbg "$<AND:${cxx_lang},${dbg_build},${clang}>")
set(cxx_clang_opt "$<AND:${cxx_lang},${opt_build},${clang}>")
set(cxx_cray_dbg  "$<AND:${cxx_lang},${dbg_build},${cray}>")
set(cxx_cray_opt  "$<AND:${cxx_lang},${opt_build},${cray}>")

#
# Set compiler flags if user did not define any
#
if (NOT CMAKE_CXX_FLAGS)
   target_compile_options(blitz PUBLIC
      $<BUILD_INTERFACE:
      $<${cxx_clang_dbg}:-ansi -O0>
      $<${cxx_clang_opt}:-ansi>
      $<${cxx_intel_dbg}:-ansi -O0 -C>
      $<${cxx_intel_opt}:-ansi -Zp16 -ip -ansi_alias>
      $<${cxx_gnu_dbg}:>
      $<${cxx_gnu_opt}:-funroll-loops -fstrict-aliasing -fomit-frame-pointer -ffast-math>
      $<${cxx_pgi_dbg}:-O0>
      $<${cxx_pgi_opt}:-Mnoframe -Mnodepchk -Minline=levels:25>
      >)

endif ()

#
# Compile definitions
#
target_compile_definitions(blitz PRIVATE $<BUILD_INTERFACE:HAVE_CONFIG_H $<${dbg_build}:BZ_DEBUG>> )
