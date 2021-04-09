;; Provides elpy's settings

(elpy-enable)
;;(elpy-use-ipython)

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
;; (require 'py-autopep8)
;; (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
;; (setq py-autopep8-options '("--max-line-length=120"))

(require 'py-yapf)
(add-hook 'elpy-mode-hook 'py-yapf-enable-on-save)

(require 'flycheck-mypy)
(add-to-list 'flycheck-python-mypy-args "--ignore-missing-imports")
;; disable other flycheck-checkers for flycheck to select python-mypy checker
;; this makes flycheck mode to ignore the checkers on flycheck-checkers list
(setq-default flycheck-disabled-checkers '(python-pylint python-pycompile))
(flycheck-add-next-checker 'python-flake8 'python-mypy t)

(provide 'python-env)
