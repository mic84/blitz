include(CheckCXXSourceCompiles)


macro (cxx_align_directive)
   message(STATUS "Checking whether the compiler supports structure alignment hints" )
   check_cxx_source_compiles(
      "int main(){__declspec(align(16))
                  int var; var=0; return 0;}"
      ALIGN_INTEL_TEST
      )

   if (ALIGN_INTEL_TEST)
      set(ALIGN_VARIABLE "(vartype,varname,alignment) __declspec(align(alignment)) vartype varname")
   else ()
      check_cxx_source_compiles(
         "int main(){int __attribute__ ((aligned (16))) var; var=0;return 0;}"
         ALIGN_GNU_TEST
         )
      if (ALIGN_GNU_TEST)
         set(ALIGN_VARIABLE "(vartype,varname,alignment) vartype __attribute__ ((aligned (alignment))) varname")
      endif ()
   endif ()
endmacro ()


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

macro (cxx_have_default_template_params)
   message(STATUS "Checking whether the compiler supports default template parameters")
   check_cxx_source_compiles(
      "template<class T = double, int N = 10> class A {public: int f() {return 0;}};
       int main() {A<float> a; return a.f();}"
      HAVE_DEFAULT_TEMPLATE_PARAMETERS
      )
endmacro ()


macro (cxx_have_dynamic_cast)
   message(STATUS "Checking whether the compiler supports dynamic cast")
   check_cxx_source_compiles(
      "#include <typeinfo>
       class Base { public : Base () {} virtual void f () = 0;};
       class Derived : public Base { public : Derived () {} virtual void f () {} };
       int main() {Derived d; Base& b=d; return dynamic_cast<Derived*>(&b) ? 0 : 1;}"
      HAVE_DYNAMIC_CAST
      )
endmacro ()

macro (cxx_have_enum_computations)
   message(STATUS "Checking whether the compiler handle computations inside an enum")
   check_cxx_source_compiles(
      "struct A { enum { a = 5, b = 7, c = 2 }; };
       struct B { enum { a = 1, b = 6, c = 9 }; };
       template<class T1, class T2> struct Z
       { enum { a = (T1::a > T2::a) ? T1::a : T2::b,
                b = T1::b + T2::b,
                c = (T1::c * T2::c + T2::a + T1::a)
              };};
       int main () {return (((int)Z<A,B>::a == 5) && ((int)Z<A,B>::b == 13) &&
       ((int)Z<A,B>::c == 24)) ? 0 : 1;}
      "
      HAVE_ENUM_COMPUTATIONS
      )
endmacro ()


macro (cxx_have_enum_comp_with_cast)
   message(STATUS "Checking whether the compiler handle (int) casts in enum computations")
   check_cxx_source_compiles(
      "struct A { enum { a = 5, b = 7, c = 2 }; };
       struct B { enum { a = 1, b = 6, c = 9 }; };
       template<class T1, class T2> struct Z
       { enum { a = ((int)T1::a > (int)T2::a) ? (int)T1::a : (int)T2::b,
                b = (int)T1::b + (int)T2::b,
                c = ((int)T1::c * (int)T2::c + (int)T2::a + (int)T1::a)
               };
       };
       int main () { return (((int)Z<A,B>::a == 5)
                         && ((int)Z<A,B>::b == 13)
                         && ((int)Z<A,B>::c == 24)) ? 0 : 1;}
      "
      HAVE_ENUM_COMPUTATIONS_WITH_CAST)
endmacro ()


macro (cxx_have_exceptions)
   message(STATUS "Checking whether the compiler supports exceptions")
   check_cxx_source_compiles(
      "int main () {try { throw 1; } catch (int i) { return i;};}"
      HAVE_EXCEPTIONS)
endmacro ()

macro (cxx_have_explicit)
   message(STATUS "Checking whether the compiler supports the explicit keyword")
   check_cxx_source_compiles(
      "class A{public:explicit A(double){}};
      int main () {double c = 5.0;A x(c);return 0;}"
      HAVE_EXPLICIT)
endmacro ()


macro (cxx_have_explicit_template_func_qual)
   message(STATUS "Checking whether the compiler supports explicit template function qualification")
   check_cxx_source_compiles(
      "template<class Z> class A { public : A() {} };
       template<class X, class Y> A<X> to (const A<Y>&) { return A<X>(); }
       int main () {A<float> x; A<double> y = to<double>(x); return 0;}"
      HAVE_EXPLICIT_TEMPLATE_FUNCTION_QUALIFICATION)
endmacro ()

macro (cxx_have_full_specialization_syntax)
   message(STATUS "Checking whether the compiler recognizes the full specialization syntax")
   check_cxx_source_compiles(
      "template<class T> class A        { public: int f () const { return 1; } };
       template<>        class A<float> { public: int f () const { return 0; } };
       int main () {A<float> a; return a.f();};
      "
      HAVE_FULL_SPECIALIZATION_SYNTAX
      )
endmacro()

macro (cxx_have_function_nontype_parameters)
   message(STATUS "Checking whether the compiler supports function templates with non-type parameters")
   check_cxx_source_compiles(
      "template<class T, int N> class A {};
       template<class T, int N> int f(const A<T,N>& x) { return 0; }
       int main () {A<double, 17> z; return f(z);}
      "
      HAVE_FUNCTION_NONTYPE_PARAMETERS
      )
endmacro ()

macro (cxx_have_ieee_math)
   message(STATUS "Checking whether the compiler supports IEEE math library")
   check_cxx_source_compiles(
      "#ifndef _ALL_SOURCE
       #define _ALL_SOURCE
       #endif
       #ifndef _XOPEN_SOURCE
       #define _XOPEN_SOURCE
       #endif
       #ifndef _XOPEN_SOURCE_EXTENDED
       #define _XOPEN_SOURCE_EXTENDED 1
       #endif
       #include <math.h>
       int main () {
          double x = 1.0; double y = 1.0; int i = 1;
          acosh(x); asinh(x); atanh(x); cbrt(x); expm1(x); erf(x); erfc(x); isnan(x);
          j0(x); j1(x); jn(i,x); ilogb(x); logb(x); log1p(x); rint(x);
          y0(x); y1(x); yn(i,x);
       #ifdef _THREAD_SAFE
          gamma_r(x,&i); 
          lgamma_r(x,&i); 
       #else
          gamma(x); 
          lgamma(x); 
       #endif
          hypot(x,y); nextafter(x,y); remainder(x,y); scalb(x,y);
          return 0;
       }"
      HAVE_IEEE_MATH
      )
endmacro ()

macro (cxx_have_member_constants)
   message(STATUS "Checking whether the compiler supports member constants")
   check_cxx_source_compiles(
      "class C {public: static const int i = 0;}; const int C::i;
       int main () {return C::i;}
      "
      HAVE_MEMBER_CONSTANTS
      )
endmacro ()

macro (cxx_have_member_templates)
   message(STATUS "Checking whether the compiler supports member templates")
   check_cxx_source_compiles(
      "template<class T, int N> class A
       { public:
         template<int N2> A<T,N> operator=(const A<T,N2>& z) { return A<T,N>(); }
       };
       int main () {A<double,4> x; A<double,7> y; x = y; return 0;} 
      "
      HAVE_MEMBER_TEMPLATES
      )
endmacro ()

macro (cxx_have_member_templates_outside_class)
   message(STATUS "Checking whether the compiler supports member templates outside the class declaration")
   check_cxx_source_compiles(
      "template<class T, int N> class A
       { public:
         template<int N2> A<T,N> operator=(const A<T,N2>& z);
       };
       template<class T, int N> template<int N2>
       A<T,N> A<T,N>::operator=(const A<T,N2>& z){ return A<T,N>(); }
       int main () {A<double,4> x; A<double,7> y; x = y; return 0;} 
  
      "
      HAVE_MEMBER_TEMPLATES_OUTSIDE_CLASS
      )
endmacro ()
      
macro (cxx_have_mutable)
   message(STATUS "Checking whether the compiler supports the mutable keyword")
   check_cxx_source_compiles(
      "class A { mutable int i;
                 public:
                 int f (int n) const { i = n; return i; }
               };
       int main () {A a; return a.f (1);}
      "
      HAVE_MUTABLE
      )
endmacro ()

macro (cxx_have_nceg_restrict)
   message(STATUS "Checking whether the compiler supports the Numerical C Extensions Group restrict keyword")
   check_cxx_source_compiles(
      "void add(int length, double * restrict a,const double * restrict b, const double * restrict c)
       { for (int i=0; i < length; ++i) a[i] = b[i] + c[i]; }
       int main () {double a[10], b[10], c[10];
                    for (int i=0; i < 10; ++i) { a[i] = 0.0; b[i] = 0.0; c[i] = 0.0; }  
                    add(10,a,b,c);
                    return 0;
                   }       
      "
      HAVE_NCEG_RESTRICT  
      )
endmacro ()

macro (cxx_have_nceg_restrict_egcs)
   message(STATUS "Checking whether the compiler recognizes the '__restrict__' keyword")
   check_cxx_source_compiles(
      "void add(int length, double * __restrict__ a,const double * __restrict__ b, 
                 const double * __restrict__ c)
       { for (int i=0; i < length; ++i) a[i] = b[i] + c[i]; }
       int main () {double a[10], b[10], c[10];
                    for (int i=0; i < 10; ++i) { a[i] = 0.0; b[i] = 0.0; c[i] = 0.0; }  
                    add(10,a,b,c);
                    return 0;
                   } 
       "
      HAVE_NCEG_RESTRICT_EGCS
      )
endmacro ()

macro (cxx_have_numeric_limits)
   if (HAVE_NAMESPACES)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   endif ()
   message(STATUS "Checking whether the compiler has numeric_limits<T>")
   check_cxx_source_compiles(   
      "#include <limits>
       #ifdef HAVE_NAMESPACES
       using namespace std;
       #endif
       int main () {double e = numeric_limits<double>::epsilon(); return 0;}
      "
      HAVE_NUMERIC_LIMITS
      )
endmacro()

macro (cxx_have_old_for_scoping)
   message(STATUS "Checking whether the compiler accepts the old for scoping rules")
   check_cxx_source_compiles(
      "int main () {int z;for (int i=0; i < 10; ++i)z=z+i;z=i;return z;}"
      HAVE_OLD_FOR_SCOPING
      )
endmacro()

macro (cxx_have_partial_ordering)
   message(STATUS "Checking whether the compiler supports partial ordering")
   check_cxx_source_compiles( 
      "template<int N> struct I {};
       template<class T> struct A
       {  int r;
          template<class T1, class T2> int operator() (T1, T2)       { r = 0; return r; }
          template<int N1, int N2>     int operator() (I<N1>, I<N2>) { r = 1; return r; }
       };
       int main () {A<float> x, y; I<0> a; I<1> b; return x (a,b) + y (float(), double());}
      "
      HAVE_PARTIAL_ORDERING
      )
endmacro ()

macro (cxx_have_partial_ordering_specialization)
   message(STATUS "Checking whether the compiler supports partial specialization")   
   check_cxx_source_compiles(
      "template<class T, int N> class A            { public : enum e { z = 0 }; };
       template<int N>          class A<double, N> { public : enum e { z = 1 }; };
       template<class T>        class A<T, 2>      { public : enum e { z = 2 }; };
       int main () {return (A<int,3>::z == 0) && (A<double,3>::z == 1) && (A<float,2>::z == 2);}
      "
      HAVE_PARTIAL_SPECIALIZATION
      )
endmacro ()

macro (cxx_have_reinterpret_cast)
   message(STATUS "Checking whether the compiler supports reinterpret_cast<>")
   check_cxx_source_compiles(
      "class Base { public : Base () {} virtual void f () = 0;};
       class Derived : public Base { public : Derived () {} virtual void f () {} };
       class Unrelated { public : Unrelated () {} };
       int g (Unrelated&) { return 0; }
       int main () { Derived d;Base& b=d;Unrelated& e=reinterpret_cast<Unrelated&>(b);return g(e);}
      "
      HAVE_REINTERPRET_CAST
      )
endmacro ()

macro (cxx_have_rtti)
   message(STATUS "Checking whether the compiler supports Run-Time Type Identification")
   check_cxx_source_compiles(
      "#include <typeinfo>
       class Base { public :
                    Base () {}
                    virtual int f () { return 0; }
                  };
       class Derived : public Base { public :
                                     Derived () {}
                                     virtual int f () { return 1; }
                                   };
       int main () {Derived d; Base *ptr = &d; return typeid (*ptr) == typeid (Derived);}
      "
      HAVE_RTTI
      )
endmacro ()

macro (cxx_have_rusage)
   message(STATUS "Checking whether the compiler has getrusage() function")  
   check_cxx_source_compiles(
      "#include <sys/resource.h>
       int main () {struct rusage resUsage; getrusage(RUSAGE_SELF, &resUsage); return 0;}
      "
      HAVE_RUSAGE
      )
endmacro ()

macro (cxx_have_static_cast)
   message(STATUS "Checking whether the compiler supports static_cast<>")
   check_cxx_source_compiles(
      "#include <typeinfo>
       class Base { public : Base () {} virtual void f () = 0; };
       class Derived : public Base { public : Derived () {} virtual void f () {} };
       int g (Derived&) { return 0; }
       int main () { Derived d; Base& b = d; Derived& s = static_cast<Derived&> (b); return g (s);}
      "
      HAVE_STATIC_CAST
      )
endmacro()


macro (cxx_have_std)
   if (HAVE_NAMESPACES)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   endif ()
   message(STATUS "Checking whether the compiler supports ISO C++ standard library")
   check_cxx_source_compiles(
      "#include <iostream>
       #include <map>
       #include <iomanip>
       #include <cmath>
       #ifdef HAVE_NAMESPACES
       using namespace std; 
       #endif
       int main () {return 0;}
      "
      HAVE_STD
      )
endmacro ()

macro (cxx_have_stl)
   if (HAVE_NAMESPACES)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   endif ()
   message(STATUS "Checking whether the compiler supports Standard Template Library")
   check_cxx_source_compiles(
      "#include <list>
       #include <deque>
       #ifdef HAVE_NAMESPACES
       using namespace std;
       #endif
       int main () {list<int> x; x.push_back(5);
                    list<int>::iterator iter = x.begin(); 
                    if (iter != x.end()) ++iter; return 0;
                   }
      "
      HAVE_STL
      )
endmacro ()


macro (cxx_have_system_v_math)
   message(STATUS "Checking whether the compiler supports System V math library")
   check_cxx_source_compiles(
      "#ifndef _ALL_SOURCE
       #define _ALL_SOURCE
       #endif
       #ifndef _XOPEN_SOURCE
       #define _XOPEN_SOURCE
       #endif
       #ifndef _XOPEN_SOURCE_EXTENDED
       #define _XOPEN_SOURCE_EXTENDED 1
       #endif
       #include <math.h>
       int main () {
          double x = 1.0; double y = 1.0;
          _class(x); trunc(x); finite(x); itrunc(x); 
          nearest(x); rsqrt(x); uitrunc(x);
          copysign(x,y); drem(x,y); unordered(x,y);
          return 0;
       }
      "
      HAVE_SYSTEM_V_MATH
      )
endmacro ()

macro (cxx_have_templates)
   message(STATUS "Checking whether the compiler supports basic templates")
   check_cxx_source_compiles(
      "template<class T> class A {public:A(){}};
       template<class T> void f(const A<T>& ){}
       int main () { A<double> d; A<int> i; f(d); f(i); return 0;}
      "
      HAVE_TEMPLATES
      )
endmacro ()


macro (cxx_have_templates_as_templates_args)
   message(STATUS "Checking whether the compiler supports templates  as template arguments")
   check_cxx_source_compiles(
      "template<class T> class allocator { public : allocator() {}; };
       template<class X, template<class Y> class T_alloc>
       class A { public : A() {} private : T_alloc<X> alloc_; };
       int main () {A<double, allocator> x; return 0;}
      "
      HAVE_TEMPLATES_AS_TEMPLATE_ARGUMENTS
      )
endmacro ()

macro (cxx_have_template_keyword_qualifier)
   message(STATUS "Checking whether the compiler supports use of the template keyword as a qualifier")
   check_cxx_source_compiles(
      "class X
       {
          public:
          template<int> void member() {}
          template<int> static void static_member() {}
       };
       template<class T> void f(T* p)
       {
          p->template member<200>(); // OK: < starts template argument
          T::template static_member<100>(); // OK: < starts explicit qualification
       }
       int main () {X x; f(&x); return 0;}
      "
      HAVE_TEMPLATE_KEYWORD_QUALIFIER
      )
endmacro ()

macro (cxx_have_template_qualified_base_class)
   message(STATUS "Checking whether the compiler supports template-qualified base class specifiers")
   if (HAVE_TYPENAME)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_TYPENAME)
   endif ()
   if (HAVE_FULL_SPECIALIZATION_SYNTAX)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_FULL_SPECIALIZATION_SYNTAX ${CMAKE_REQUIRED_DEFINITIONS})
   endif ()
   check_cxx_source_compiles(
      "#ifndef HAVE_TYPENAME
       #define typename
       #endif
       class Base1 { public : int f () const { return 1; } };
       class Base2 { public : int f () const { return 0; } };
       template<class X> struct base_trait        { typedef Base1 base; };
       #ifdef HAVE_FULL_SPECIALIZATION_SYNTAX
        template<>        struct base_trait<float> { typedef Base2 base; };
       #else
        struct base_trait<float> { typedef Base2 base; };
       #endif
       template<class T> class Weird : public base_trait<T>::base
       { public :
         typedef typename base_trait<T>::base base;
         int g () const { return base::f (); }
       };
       int main () {Weird<float> z; return z.g ();}
      "
      HAVE_TEMPLATE_QUALIFIED_BASE_CLASS
      )
endmacro ()


macro (cxx_have_template_qualified_return_type)
   message(STATUS "Checking whether the compiler supports template-qualified return types")
   if (HAVE_TYPENAME)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_TYPENAME)
   endif ()
   check_cxx_source_compiles(
      "#ifndef HAVE_TYPENAME
       #define typename
       #endif
       template<class X, class Y> struct promote_trait             { typedef X T; };
       template<>                 struct promote_trait<int, float> { typedef float T; };
       template<class T> class A { public : A () {} };
       template<class X, class Y>
       A<typename promote_trait<X,Y>::T> operator+ (const A<X>&, const A<Y>&)
       { return A<typename promote_trait<X,Y>::T>(); }
       int main () {A<int> x; A<float> y; A<float> z = x + y; return 0;}
      "
      HAVE_TEMPLATE_QUALIFIED_RETURN_TYPE
      )
endmacro ()


macro (cxx_have_template_scoped_arg_matching)
   message(STATUS "Checking whether the compiler supports function matching "
      "with argument types which are template scope-qualified" )
   if (HAVE_TYPENAME)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_TYPENAME)
   endif ()
   check_cxx_source_compiles(
      "#ifndef HAVE_TYPENAME
       #define typename
       #endif
       template<class X> class A { public : typedef X W; };
       template<class Y> class B {};
       template<class Y> void operator+(B<Y> d1, typename Y::W d2) {}
       int main () {B<A<float> > z; z + 0.5f; return 0;}
      "
      HAVE_TEMPLATE_SCOPED_ARGUMENT_MATCHING
      )
endmacro ()


macro (cxx_have_typename)
   message(STATUS "Checking whether the compiler recognizes typename")
   check_cxx_source_compiles(
      "template<typename T>class X {public:X(){}};
       int main () {X<float> z; return 0;}
      "
      HAVE_TYPENAME
      )
endmacro ()   


macro (cxx_have_type_promotion)
   message(STATUS "Checking weather the compiler supports the vector type promotion mechanism")
   if (HAVE_TYPENAME)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_TYPENAME)
   endif ()
   check_cxx_source_compiles(
      "#ifndef HAVE_TYPENAME
       #define typename
       #endif
       template <class T> struct vec3 { T data_[3]; };
       template <class T1, class T2> struct promote_trait { typedef T1 T_promote; };
       template <> struct promote_trait<int,double> { typedef double T_promote; };
       template <class T1, class T2> vec3<typename promote_trait<T1,T2>::T_promote>
       operator+(const vec3<T1>& a, const vec3<T2>& b) 
       { vec3<typename promote_trait<T1,T2>::T_promote> c;
         c.data_[0] = a.data_[0] + b.data_[0];
         c.data_[1] = a.data_[1] + b.data_[1];
         c.data_[2] = a.data_[2] + b.data_[2]; return c; }
       int main () {vec3<int> a,b; vec3<double> c,d,e; b=a+a; d=c+c; e=b+d; return 0;}
      "
      HAVE_TYPE_PROMOTION
      )
endmacro ()


macro (cxx_have_numtrait)
   message(STATUS "Checking weather the compiler supports numeric traits promotions")
   if (HAVE_TYPENAME)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_TYPENAME)
   endif () 
   check_cxx_source_compiles(
      "#ifndef HAVE_TYPENAME
       #define typename
       #endif
       template<class T_numtype> class SumType       { public : typedef T_numtype T_sumtype;   };
       template<>                class SumType<char> { public : typedef int T_sumtype; };
       template<class T> class A {};
       template<class T> A<typename SumType<T>::T_sumtype> sum(A<T>)
       { return A<typename SumType<T>::T_sumtype>(); }
       int main () {A<float> x; sum(x); return 0;}
      "
      HAVE_USE_NUMTRAIT
      )       
endmacro ()

macro (cxx_have_valarray)
   message(STATUS "Checking weather the compiler has valarray<T>")
   if (HAVE_NAMESPACES)
      set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_NAMESPACES)
   endif ()
   check_cxx_source_compiles(
      "#include <valarray>
       #ifdef HAVE_NAMESPACES
       using namespace std;
       #endif
       int main () {valarray<float> x(100); return 0;}
      "
      HAVE_VALARRAY
      )
endmacro ()

macro (cxx_have_isnan_in_std)
   message(STATUS "Checking weather the compiler has isnan function in namespace std")
   check_cxx_source_compiles(
      "#include <cmath>
       namespace blitz { int isnan(float x){ return std::isnan(x); } };
       int main () {using namespace blitz; float x = 1.0; blitz::isnan(x); return 0;}
      "
      ISNAN_IN_NAMESPACE_STD
      )
endmacro ()

macro (cxx_have_absint_in_std)
   message(STATUS "Checking weather the compiler has C math abs(integer type) in namespace std")
   check_cxx_source_compiles(
      "#include <cstdlib>
       int main () {int i = std::abs(1); long j = std::labs(1L); long k = std::abs(1L); return 0;}
      "
      MATH_ABSINT_IN_NAMESPACE_STD
      )
endmacro ()

macro (cxx_have_math_fn_in_std)
   message(STATUS "Checking weather the  compiler has C math functions in namespace std")
   check_cxx_source_compiles(
      "#include <cmath>
       namespace blitz { double pow(double x, double y){ return std::pow(x,y); } };
       int main () {using namespace blitz; double x = 1.0, y = 1.0; blitz::pow(x,y); return 0;}
      "
      MATH_FN_IN_NAMESPACE_STD
      )
endmacro ()

