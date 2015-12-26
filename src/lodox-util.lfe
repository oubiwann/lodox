;;;===================================================================
;;; This file was generated by Org. Do not edit it directly.
;;; Instead, edit Lodox.org in Emacs and call org-babel-tangle.
;;;===================================================================

(defmodule lodox-util
  (doc "Utility functions to inspect the current version of lodox and its dependencies.")
  (export (search-funcs 2) (search-funcs 3)))

(defun search-funcs (modules partial-func)
  "TODO: write docstring"
  (search-funcs modules partial-func 'undefined))

(defun search-funcs (modules partial-func starting-mod)
  "TODO: write docstring"
  (let* ((suffix  (if (lists:member #\/ partial-func)
                    partial-func
                    `(#\/ . ,partial-func)))
         (matches (lists:filter
                    (lambda (func-name) (lists:suffix suffix func-name))
                    (exported-funcs modules))))
    (case (lists:dropwhile
           (lambda (func-name)
             (=/= (atom_to_list starting-mod) (module func-name)))
           matches)
      (`(,func . ,_) func)
      ('()           (case matches
                       (`(,func . ,_) func)
                       ('()           'undefined))))))


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun exported-funcs (modules)
  "TODO: write docstring"
  (lc ((<- mod modules)
       (<- func (mref mod 'exports)))
    (func-name mod func)))

(defun func-name (mod func)
  "TODO: write docstring"
  (++ (atom_to_list (mref mod 'name))
      ":" (atom_to_list (mref func 'name))
      "/" (integer_to_list (mref func 'arity))))

(defun module (func-name)
  (lists:takewhile (lambda (c) (=/= c #\:)) func-name))
