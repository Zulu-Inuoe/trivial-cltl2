(in-package #:trivial-cltl2)

(defun allegro-information-alist-kludge (alist &optional environment) ; XXX
  "Allegro 10.1 returns a type specifier IN A LIST, like '((ARRAY (INTEGER 0 1) (*))))'.
So I unwrap it.."
  (flet ((valid-type-specifier-p (spec)
           (ignore-errors (subtypep spec spec environment))))
    (let* ((type-spec (cdr (assoc 'type alist))))
      (unless (valid-type-specifier-p type-spec)
        (assert (and (consp type-spec)
                     (= (length type-spec) 1)
                     (valid-type-specifier-p (first type-spec)))
                ()
                "Unexpected format type-specifier: ~A" type-spec)
        (push (cons 'type (first type-spec))
              alist)))
    alist))

(defun variable-information (symbol &optional environment all-declarations)
  "Compatibility layer for Allegro's `system:variable-information',
which takes extra parameters and returns different values from the CLtL2's function."
  ;; See https://franz.com/support/documentation/current/doc/operators/system/variable-information.htm
  (multiple-value-bind (type locative-cons alist local-p)
      (system:variable-information symbol environment all-declarations)
    (values type
            local-p
            (allegro-information-alist-kludge alist)
            locative-cons)))

(defun function-information (fspec &optional environment all-declarations special-operators)
  "Compatibility layer for Allegro's `system:function-information',
which returns different values from the CLtL2's function."
  ;; See https://franz.com/support/documentation/current/doc/operators/system/function-information.htm
  (multiple-value-bind (type locative-cons alist local-p)
      (system:function-information fspec environment all-declarations special-operators)
    (values (case type
              (:special-operator :special-form)
              (otherwise type))
            local-p
            (allegro-information-alist-kludge alist)
            locative-cons)))

(defmacro define-declaration (decl-name lambda-list &body body)
  "Compatibility layer for Allegro's `system:function-information',
which has very different arguments and return values."
  `(system:define-declaration ,decl-name ,lambda-list
     ,decl-name                         ; 'prop' argument.
     :both                              ; 'kind' argument. TODO: guess
     (lambda (decl-name env) ,@body)))  ; 'def' argument.

;;; This code is derived from 'clweb' by Alex Plotnick,
;;; https://github.com/plotnick/clweb/blob/4c736b4c8b4c0afbdd939eefbcb986c16c24c1e3/clweb.lisp#L1853
(defun parse-macro (name lambda-list body &optional env)
  (declare (ignorable name lambda-list body env))
  (excl::defmacro-expander `(,name ,lambda-list ,@body) env))

(defun enclose (lambda-expression &optional environment)
  (excl:compile-lambda-expr-in-env lambda-expression environment))
