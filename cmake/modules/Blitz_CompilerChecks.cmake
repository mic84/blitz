include(CheckCXXSourceCompiles)

function (cxx_namespaces result)
   message(STATUS "Checking whether the compiler implements namespaces" )
   check_cxx_source_compiles(
      "namespace Outer { namespace Inner { int i = 0; }}
       int main(){using namespace Outer::Inner; return i;}"
      support_namespaces
      )
   if (support_namespaces)
      set(${result} 1 PARENT_SCOPE)
   endif ()
endfunction ()

function (cxx_have_bool result)
   message(STATUS "Checking whether the compiler recognizes "
      "bool as a built-in type")
   check_cxx_source_compiles(
      "int f(int  x){return 1;}
       int f(char x){return 1;}
       int f(bool x){return 1;}     
       int main() {return 0;}"
      support_bool
      )
   if (support_bool)
      set(${result} 1 PARENT_SCOPE) 
   endif ()
endfunction ()


function (cxx_have_complex result)
   if(NOT HAVE_NAMESPACES)
      return()
   endif ()
   message(STATUS "Checking whether the compiler has complex<T>")
   set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   check_cxx_source_compiles(
      "#include <complex>
       #ifdef HAVE_NAMESPACES
       using namespace std;
       #endif     
       int main() {complex<float> a; complex<double> b; return 0;}"
      support_complex
      )
   if (support_complex)
      set(${result} 1 PARENT_SCOPE)  
   endif ()
endfunction ()


function (cxx_have_complex_fcns result)
   if(NOT HAVE_NAMESPACES)
      return()
   endif ()
   message(STATUS "Checking whether the compiler has standard complex<T> functions")
   set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   check_cxx_source_compiles(
      "#include <complex>
       #ifdef HAVE_NAMESPACES
       using namespace std;
       #endif     
       int main() { complex<double> x(1.0, 1.0); real(x); imag(x); 
       abs(x); arg(x); norm(x); conj(x); polar(1.0,1.0); return 0;}"
      support_complex_fcns
      )
   if (support_complex_fcns)
      set(${result} 1 PARENT_SCOPE)  
   endif ()
endfunction ()

function (cxx_have_complex_math1 result)
   if(NOT HAVE_NAMESPACES)
      return()
   endif ()
   message("HERE")
   message(STATUS "Checking whether the compiler has complex math functions")
   set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   check_cxx_source_compiles(
      "#include <complex>
       #ifdef HAVE_NAMESPACES
       using namespace std;
       #endif     
       int main() {complex<double> x(1.0, 1.0), y(1.0, 1.0);
       cos(x); cosh(x); exp(x); log(x); pow(x,1); pow(x,double(2.0));
       pow(x, y); pow(double(2.0), x); sin(x); sinh(x); sqrt(x); tan(x);
       tanh(x); return 0;}"
      support_complex_math1
      )
   if (support_complex_math1)
      set(${result} 1 PARENT_SCOPE)
   endif ()
endfunction ()

function (cxx_have_complex_math2 result)
   if(NOT HAVE_NAMESPACES)
      return()
   endif ()
   message(STATUS "Checking whether the compiler has more complex math functions")
   set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   check_cxx_source_compiles(
      "#include <complex>
       #ifdef HAVE_NAMESPACES
       using namespace std;
       #endif     
       int main() {complex<double> x(1.0, 1.0), y(1.0, 1.0);
       cos(x); asin(x); atan(x); atan2(x,y); atan2(x, double(3.0));
       atan2(double(3.0), x); log10(x); return 0;}"
      support_complex_math2
      )
   if (support_complex_math2)
      set(${result} 1 PARENT_SCOPE)
   endif ()
endfunction ()

function (cxx_have_complex_math_in_namespace_std result)
   if(NOT HAVE_NAMESPACES)
      return()
   endif ()
   message(STATUS "Checking whether the compiler has more complex math functions")
   set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   check_cxx_source_compiles(
      "#include <complex>
       namespace S { using namespace std;
       complex<float> pow(complex<float> x, complex<float> y)
       { return std::pow(x,y); }};
       int main {using namespace S; complex<float> x = 1.0, y = 1.0; S::pow(x,y); return 0;}"
      support_complex_math_in_std
      )
   if (support_complex_math_in_std)
      set(${result} 1 PARENT_SCOPE)
   endif ()
endfunction()

function (cxx_have_const_cast result)
   message(STATUS "Checking whether the compiler supports const_cast<>")
   check_cxx_source_compiles(
      "int main() {int x = 0;const int& y = x;int& z = const_cast<int&>(y);return z;}"
      support_const_cast
      )
   if (support_const_cast)
      set(${result} 1 PARENT_SCOPE)
   endif ()
endfunction()
