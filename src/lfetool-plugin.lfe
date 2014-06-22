(defmodule lfetool-plugin
  (export all))

(defun get-plugin-module (name)
  (lfe-utils:atom-cat
    (list_to_atom (lfetool-const:plugin-module-prefix))
    name))

(defun get-plugins-src ()
  (lists:merge
    (filelib:wildcard
      (lfetool-const:plugin-src))
    (filelib:wildcard
      (lfe-utils:expand-home-dir
        (lfetool-const:plugin-usr-src)))))

(defun compile-plugins ()
  (compile-plugins
    (lfe-utils:expand-home-dir
      (lfetool-const:plugin-ebin))))

(defun compile-plugins
  (('show-output)
    (lfe_io:format "~p~n" (list (compile-plugins))))
  ((out-dir)
    (lfe-utils:compile
      (get-plugins-src)
      (lfe-utils:get-deps)
      out-dir)))

(defun get-plugin-beams ()
  "Get the compile .beam files, but without the .beam extension. The list of
  files generated by this function are meant to be consumed by (code:load_abs)."
  (lists:map
    #'filename:rootname/1
    (filelib:wildcard
      (lfe-utils:expand-home-dir
        (lfetool-const:plugin-beams)))))

(defun load-plugins ()
  (lists:map
    #'code:load_abs/1
    (get-plugin-beams)))

(defun get-loaded-plugins ()
  (lfetool-util:filtered-loaded-modules
    (lfetool-const:plugin-module-prefix)))

(defun get-loaded-plugin-modules ()
  (lists:map
    (lambda (x) (element 1 x))
    (get-loaded-plugins)))
