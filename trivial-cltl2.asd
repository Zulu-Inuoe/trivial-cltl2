(in-package :cl-user)

(defpackage :trivial-cltl2-asd
  (:use :cl :asdf))
(in-package :trivial-cltl2-asd)

(defsystem :trivial-cltl2
  :version "0.1"
  :author "Tomohiro Matsuyama"
  :license "LLGPL"
  :components ((:file "cltl2")))
