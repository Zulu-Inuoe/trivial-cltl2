#+sbcl
(eval-when (:compile-toplevel :load-toplevel :execute)
  (require "sb-cltl2"))

(defpackage #:trivial-cltl2
  (:nicknames #:cltl2)
  (:use #:cl
        #+sbcl #:sb-cltl2
        #+openmcl #:ccl
        #+cmu #:ext
        #+allegro #:sys
        #+ecl #:si
        #+abcl #:lisp
        #+lispworks #:hcl)
  #+allegro (:import-from #:excl #:compiler-let)
  #+lispworks (:import-from #:lw #:compiler-let)
  (:export #:compiler-let
           #:variable-information
           #:function-information
           #:declaration-information
           #:augment-environment
           #:define-declaration
           #:parse-macro
           #:enclose))

(in-package #:trivial-cltl2)

;;; This code is derived from 'clweb' by Alex Plotnick,
;;; https://github.com/plotnick/clweb/blob/4c736b4c8b4c0afbdd939eefbcb986c16c24c1e3/clweb.lisp#L1853
#+allegro
(defun parse-macro (name lambda-list body &optional env)
  (declare (ignorable name lambda-list body env))
  (excl::defmacro-expander `(,name ,lambda-list ,@body) env))

#+allegro
(defun enclose (lambda-expression &optional environment)
  (excl:compile-lambda-expr-in-env lambda-expression environment))
