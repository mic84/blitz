#
# Blitz test suite
# 
set( TESTS 
   64bit Adnene-Ben-Abdallah-1 Adnene-Ben-Abdallah-2     
   alignment arrayresize arrayinitialize bitwise chris-jeffery-1 chris-jeffery-2  
   chris-jeffery-3 complex-test constarray contiguous copy ctors	       
   derrick-bass-1 derrick-bass-3 exprctor expression-slicing extract free 
   gary-huber-1 indexexpr-base initialize int-math-func interlace iter    
   Josef-Wagenhuber levicivita loop1 matthias-troyer-1 matthias-troyer-2  
   mattias-lindstroem-1 member_function minmax minsumpow module	       
   multicomponent multicomponent-2 newet Olaf-Ronneberger-1	       
   patrik-jonsson-1 peter-bienstman-1 peter-bienstman-2 peter-bienstman-3 
   peter-bienstman-4 peter-bienstman-5 peter-nordlund-1 peter-nordlund-2  
   peter-nordlund-3 preexisting promote pthread qcd reduce reindex	       
   reverse safeToReturn shapecheck shape slice-iterators stencil-et       
   stencil-extent storage stub theodore-papadopoulo-1 tinymat tinyvec     
   transpose troyer-genilloud tvinitialize Ulisses-Mello-1 weakref	       
   wei-ku-1 where zeek-1 cast serialize update declfunc
   )



foreach (test_name IN LISTS TESTS)

   set(exe_name ${test_name})
   if (${test_name} STREQUAL module)
      add_executable(${exe_name} module1.cpp module2.cpp)
   else ()
      add_executable(${exe_name} ${test_name}.cpp)
   endif ()
   target_include_directories(${exe_name} PRIVATE ${CMAKE_CURRENT_LIST_DIR}) 
   target_link_libraries(${exe_name} PRIVATE blitz)

   # if test is 64bit, we always use optimization flags because otherwise it is too slow to run
   if (${test_name} STREQUAL 64bit)
      target_compile_options(${exe_name} PRIVATE -O3)
   endif ()

   add_test(build_${test_name}
      "${CMAKE_COMMAND}" --build ${CMAKE_BINARY_DIR} --target ${exe_name} --config $<CONFIG>)
   add_test(${test_name} ${exe_name})
   set_tests_properties(${test_name} PROPERTIES DEPENDS build_${test_name})

endforeach ()
