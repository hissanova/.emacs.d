;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    zenburn-theme
    elpy
    highlight-indentation
    flycheck
    flycheck-mypy
    py-autopep8))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------
;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(setq inhibit-startup-message t) ;; hide the startup message
;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)
(global-linum-mode t) ;; enable line numbers globally
 ;; load zenburn theme
(load-theme 'zenburn t)
;; activate company mode for all buffers
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'comint-output-filter-functions
	  'comint-watch-for-password-prompt);;hide passwords automatically
;; (bindings--define-key dired-mode-map
;;     ("i", dired-subtree-insert)
;;   (";", dired-subtree-remove))
(elpy-enable)
(elpy-use-ipython)

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
(require 'flycheck-mypy)
(add-hook 'elpy-mode-hook 'flycheck-mode)
;; disable other flycheck-checkers for flycheck to select python-mypy checker
;; this makes flycheck mode to ignore the checkers on flycheck-checkers list
;;(setq-default flycheck-disabled-checkers '(python-flake8))
(flycheck-add-next-checker 'python-flake8 'python-mypy t)
;; (setq-default flycheck-disabled-checkers '(python-flake8
;; 					   python-pylint))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("444238426b59b360fb74f46b521933f126778777c68c67841c31e0a68b0cc920" default)))
 '(package-selected-packages
   (quote
    (pipenv tao-theme nhexl-mode dired-subtree rope-read-mode magit zenburn-theme py-autopep8 material-theme flycheck elpy ein better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(put 'upcase-region 'disabled nil)

;; init.el ends here
