#
# We gotta generate stencil-classes.cc first during build
# 
execute_process(
   COMMAND ${Python2_EXECUTABLE} genstencils.py ${CMAKE_CURRENT_BINARY_DIR}/stencil-classes.cc
   WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/blitz/generate
   OUTPUT_VARIABLE stencil_classes_out )

# For the build only, we include CMAKE_BINARY_DIRECTORY
# where ${CMAKE_CURRENT_BINARY_DIR}/stencil-classes.cc
# is created
target_include_directories(blitz PUBLIC
   $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}>
   )

# Install stencil-classes.cc we generated above
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/stencil-classes.cc
   DESTINATION include/blitz/array)

install_public_headers( asexpr.h asexpr.cc cartesian.h cgsolve.h complex.cc	
   convolve.cc convolve.h cycle.cc domain.h et.h expr.h expr.cc		
   fastiter.h funcs.h functorExpr.h geometry.h indirect.h interlace.cc	
   io.cc iter.h map.h methods.cc misc.cc multi.h newet-macros.h newet.h	
   ops.cc ops.h reduce.cc reduce.h resize.cc shape.h slice.h slicing.cc	
   stencil-et.h stencil-et-macros.h stencilops.h stencils.cc stencils.h	
   storage.h where.h zip.h)

