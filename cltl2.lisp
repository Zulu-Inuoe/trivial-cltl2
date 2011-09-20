(in-package :cl-user)

(defpackage :trivial-cltl2
  (:nicknames :cltl2)
  (:use :cl
        #+sbcl :sb-cltl2
        #+openmcl :ccl
        #+cmu :ext
        #+allegro :sys
        #+ecl :si
        #+abcl :lisp)
  (:export #:compiler-let
           #:variable-information
           #:function-information
           #:declaration-information
           #:augment-environment
           #:define-declaration
           #:parse-macro
           #:enclose))
