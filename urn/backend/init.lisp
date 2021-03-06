(import urn/backend/writer writer)

(import urn/backend/lua back-lua)
(import urn/backend/lisp back-lisp)
(import urn/backend/markdown back-markdown)

(defun wrap-generate (func)
  (lambda (node &args)
    (with (writer (writer/create))
      (func node writer (unpack args 1 (# args)))
      (writer/->string writer))))

(defun wrap-normal (func)
  (lambda (&args)
    (with (writer (writer/create))
      (func writer (unpack args 1 (# args)))
      (writer/->string writer))))

(struct
  :lua (struct
         :expression (wrap-generate back-lua/compile-expression)
         :block (wrap-generate back-lua/compile-block)
         :prelude (wrap-normal back-lua/prelude)
         :backend back-lua/backend)
  :lisp (struct
          :expression (wrap-generate back-lisp/expression)
          :block (wrap-generate back-lisp/block)
          :backend back-lisp/backend)
  :markdown (struct
              :exported (wrap-normal back-markdown/exported)
              :backend back-markdown/backend))
