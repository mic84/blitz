include(CheckCXXSourceCompiles)

macro (cxx_namespaces)
   message(STATUS "Checking whether the compiler implements namespaces" )
   check_cxx_source_compiles(
      "namespace Outer { namespace Inner { int i = 0; }}
       int main(){using namespace Outer::Inner; return i;}"
      HAVE_NAMESPACES
      )
endmacro ()

macro (cxx_have_bool)
   message(STATUS "Checking whether the compiler recognizes "
      "bool as a built-in type")
   check_cxx_source_compiles(
      "int f(int  x){return 1;}
       int f(char x){return 1;}
       int f(bool x){return 1;}     
       int main() {return 0;}"
      HAVE_BOOL
      )
endmacro ()


macro (cxx_have_complex)
   if (HAVE_NAMESPACES)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   endif ()
   message(STATUS "Checking whether the compiler has complex<T>")
   check_cxx_source_compiles(
      "#include <complex>
       #ifdef HAVE_NAMESPACES
       using namespace std;
       #endif     
       int main() {complex<float> a; complex<double> b; return 0;}"
      HAVE_COMPLEX
      )
endmacro ()


macro (cxx_have_complex_fcns)
   if (HAVE_NAMESPACES)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   endif ()
   message(STATUS "Checking whether the compiler has standard complex<T> functions")
   check_cxx_source_compiles(
      "#include <complex>
       #ifdef HAVE_NAMESPACES
       using namespace std;
       #endif     
       int main() { complex<double> x(1.0, 1.0); real(x); imag(x); 
       abs(x); arg(x); norm(x); conj(x); polar(1.0,1.0); return 0;}"
      HAVE_COMPLEX_FCNS
      )
endmacro ()

macro (cxx_have_complex_math1)
   if (HAVE_NAMESPACES)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   endif ()
   message(STATUS "Checking whether the compiler has complex math functions")
   check_cxx_source_compiles(
      "#include <complex>
       #ifdef HAVE_NAMESPACES
       using namespace std;
       #endif     
       int main() {complex<double> x(1.0, 1.0), y(1.0, 1.0);
       cos(x); cosh(x); exp(x); log(x); pow(x,1); pow(x,double(2.0));
       pow(x, y); pow(double(2.0), x); sin(x); sinh(x); sqrt(x); tan(x);
       tanh(x); return 0;}"
      HAVE_COMPLEX_MATH1
      )
endmacro ()

macro (cxx_have_complex_math2)
   if (HAVE_NAMESPACES)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   endif ()
   message(STATUS "Checking whether the compiler has more complex math functions")

   check_cxx_source_compiles(
      "#include <complex>
       #ifdef HAVE_NAMESPACES
       using namespace std;
       #endif     
       int main() {complex<double> x(1.0, 1.0), y(1.0, 1.0);
       cos(x); asin(x); atan(x); atan2(x,y); atan2(x, double(3.0));
       atan2(double(3.0), x); log10(x); return 0;}"
      HAVE_COMPLEX_MATH2
      )
endmacro ()

macro (cxx_have_complex_math_in_namespace_std)
   if (HAVE_NAMESPACES)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   endif ()
   message(STATUS "Checking whether the compiler has more complex math functions")
   check_cxx_source_compiles(
      "#include <complex>
       namespace S { using namespace std;
       complex<float> pow(complex<float> x, complex<float> y){ return std::pow(x,y); }};
       int main () {using namespace S; complex<float> x = 1.0, y = 1.0; S::pow(x,y); return 0;}"
      HAVE_COMPLEX_MATH_IN_NAMESPACE_STD
      )
endmacro()

macro (cxx_have_const_cast)
   message(STATUS "Checking whether the compiler supports const_cast<>")
   check_cxx_source_compiles(
      "int main() {int x = 0;const int& y = x;int& z = const_cast<int&>(y);return z;}"
      HAVE_CONST_CAST
      )
endmacro()
