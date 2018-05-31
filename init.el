;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("gnu" .  "http://elpa.gnu.org/packages/") t)

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

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Diminish modeline clutter
(require 'diminish)
(diminish 'wrap-region-mode)
(diminish 'yas/minor-mode)

;; Elisp go-to-definition with M-. and back again with M-,
(autoload 'elisp-slime-nav-mode "elisp-slime-nav")
(add-hook 'emacs-lisp-mode-hook (lambda () (elisp-slime-nav-mode t)))
(eval-after-load 'elisp-slime-nav '(diminish 'elisp-slime-nav-mode))

;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; hide the startup message
(setq inhibit-startup-message t) 

;; mapping keybinds of goto-line to goto-line-with-feedback
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

;; Make dired less verbose
(add-hook 'dired-mode-hook
      (lambda ()
        (dired-hide-details-mode)
        (dired-sort-toggle-or-edit)))

;; load zenburn theme
(load-theme 'zenburn t)

;; activate company mode for all buffers
(add-hook 'after-init-hook 'global-company-mode)

;;hide passwords automatically
(add-hook 'comint-output-filter-functions
	  'comint-watch-for-password-prompt)
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

(put 'upcase-region 'disabled nil)

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
    (company-auctex haskell-mode sclang-extensions slime auctex pipenv tao-theme nhexl-mode dired-subtree rope-read-mode magit zenburn-theme py-autopep8 material-theme flycheck elpy ein better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; snorlax original customs
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(custom-safe-themes
;;    (quote
;;     ("444238426b59b360fb74f46b521933f126778777c68c67841c31e0a68b0cc920" default)))
;;  '(package-selected-packages
;;    (quote
;;     (pipenv tao-theme nhexl-mode dired-subtree rope-read-mode magit zenburn-theme py-autopep8 material-theme flycheck elpy ein better-defaults))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )



;; --- below this part is taken from macbook 
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(package-selected-packages
;;    (quote
;;     (company-auctex haskell-mode sclang-extensions slime ## auctex material-theme better-defaults))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )

;; Set sbcl as default coommon lisp implementation
(setq inferior-lisp-program "/usr/local/bin/sbcl")

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/slime-20180111.429"))

(slime-setup '(slime-repl slime-fancy slime-banner))

;; Set ghc as Haskell inferior programme

(setq inferior-haskell-program "/usr/local/bin/ghci")

;; Install Intero
(package-install 'intero)
(add-hook 'haskell-mode-hook 'intero-mode)

;; LaTex configurations
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq TeX-PDF-mode t)

;; init.el ends here
