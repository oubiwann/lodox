;;;===================================================================
;;; This file was generated by Org. Do not edit it directly.
;;; Instead, edit Lodox.org in Emacs and call org-babel-tangle.
;;;===================================================================

(defmodule lodox
  (doc "The Lodox [Rebar3][1] [provider][2].

[1]: http://www.rebar3.org/docs/plugins
[2]: https://github.com/tsloughter/providers")
  (behaviour provider)
  ;; N.B. Export all since LFE doesn't like us defining do/1.
  (export all))

(defun namespace ()
  "The namespace in which `lodox` is registered, `default`."
  'lfe)

(defun provider-name ()
  "The 'user friendly' name of the task, `lodox`."
  'lodox)

(defun short-desc ()
  "A one line, short description of the task, used in lists of providers."
  "Generate documentation from LFE source files.")

(defun deps ()
  "The list of dependencies, providers, that need to run before this one."
  '(#(default app_discovery)))

(defun desc ()
  "The description for the task, used by `rebar3 help`."
  (short-desc))


;;;===================================================================
;;; API
;;;===================================================================

(defun init (state)
  "Initiate the Lodox provider."
  (rebar_api:debug "Initializing {~p, ~p}" `[,(namespace) ,(provider-name)])
  (let* ((opts `(#(name       ,(provider-name))   ; The 'user friendly' name
                 #(module     ,(MODULE))          ; The module implementation
                 #(namespace  ,(namespace))       ; Plugin namespace
                 #(opts       [])                 ; List of plugin options
                 #(deps       ,(deps))            ; The list of dependencies
                 #(example    "rebar3 lfe lodox") ; How to use the plugin
                 #(short_desc ,(short-desc))      ; A one-line description
                 #(desc       ,(desc))            ; A longer description
                 #(bare       true)))             ; Task can be run by user
         (provider (providers:create opts)))
    (let ((state* (rebar_state:add_provider state provider)))
      (rebar_api:debug "Initialized lodox" '())
      `#(ok ,state*))))

(defun do (state)
  "Generate documentation for each application in the project.

See: [[lodox-html-writer:write-docs/2]]"
  (rebar_api:debug "Starting do/1 for lodox" '())
  (let ((apps (case (rebar_state:current_app state)
                ('undefined (rebar_state:project_apps state))
                (apps-info   `(,apps-info)))))
    (lists:foreach #'write-docs/1 apps))
  `#(ok ,state))

(defun format_error (reason)
  "When an exception is raised or a value returned as
`#(error #((MODULE) reason)`, `(format_error reason)` will be called
so a string can be formatted explaining the issue."
  (io_lib:format "~p" `(,reason)))


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun write-docs (app-info)
  "Given an [app_info_t], call [[lodox-html-writer:write-docs/2]] appropriately.

[app_info_t]: https://github.com/rebar/rebar3/blob/master/src/rebar_app_info.erl"
  (let* ((`(,opts ,app-dir ,name ,vsn ,out-dir)
          (lists:map (lambda (f) (call 'rebar_app_info f app-info))
                     '(opts dir name original_vsn out_dir)))
         (ebin-dir (filename:join out-dir "ebin"))
         (doc-dir  (filename:join app-dir "doc")))
    (rebar_api:debug "Adding ~p to the code path" `(,ebin-dir))
    (code:add_path ebin-dir)
    (let ((project (lodox-parse:docs name))
          (opts    `#m(output-path ,doc-dir app-dir ,app-dir)))
      (rebar_api:debug "Generating docs for ~p" `(,(mref project 'name)))
      (lodox-html-writer:write-docs project opts))
    (generated name vsn doc-dir)))

(defun generated
  "Print a string of the form:

> Generated {{app-name}} v{{version}} docs in {{output directory}}"
  ([name `#(cmd ,cmd) doc-dir]
   (generated name (os:cmd (++ cmd " | tr -d \"\\n\"")) doc-dir))
  ([name vsn doc-dir]
   (rebar_api:console "Generated ~s v~s docs in ~s" `(,name ,vsn ,doc-dir))))
