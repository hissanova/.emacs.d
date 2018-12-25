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
   '(highlight-indentation
     elisp-slime-nav
     diminish
     better-defaults
     dired-subtree
     magit
     yasnippet
     intero
     company-auctex
     haskell-mode
     sclang-extensions
     slime
     nhexl-mode
     zenburn-theme
     material-theme
     flycheck
     flycheck-mypy
     py-autopep8
     rope-read-mode
     pipenv
     elpy
     ein
     auctex
     helm
     org
     dockerfile-mode
     markdown-mode
     json
     fish-mode
     paredit
     expand-region
     ))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      myPackages)

;; Set path to dependencies
(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))

;; Set up load path
(add-to-list 'load-path settings-dir)

;; Setup appearance including theme
(require 'appearance)

;; Load settings for org-mode
(require 'setup-org-mode)

;; Load settings for custom key binds
(require 'custom-keys)

;; Load settings for python dev environment
(require 'python-env)

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;;keep cursor at same position when scrolling
(setq scroll-preserve-screen-position 1)

;;scroll window up/down by one line
(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))

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

;; Let dired to show subtrees
(require 'dired-subtree)
(define-key dired-mode-map "i" 'dired-subtree-insert)
(define-key dired-mode-map ";" 'dired-subtree-remove)
;; Make dired less verbose
(add-hook 'dired-mode-hook
	  (lambda ()
	    (dired-hide-details-mode)))

;; activate company mode for all buffers
(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0.1)

;;hide passwords automatically
(add-hook 'comint-output-filter-functions
	  'comint-watch-for-password-prompt)

;; paredit
(require 'paredit)
(add-hook 'lisp-mode-hook 'paredit-mode)

;; (require 'show-paren)
(add-hook 'lisp-mode-hook 'show-paren-mode)

;; expand-region
(require 'expand-region)
(global-set-key (kbd "C-]") 'er/expand-region)
		     


(require 'flycheck-mypy)
(add-to-list 'flycheck-python-mypy-args "--ignore-missing-imports")
;; disable other flycheck-checkers for flycheck to select python-mypy checker
;; this makes flycheck mode to ignore the checkers on flycheck-checkers list
(setq-default flycheck-disabled-checkers '(python-pylint python-pycompile))
(flycheck-add-next-checker 'python-flake8 'python-mypy t)

;; activate upcase-region
(put 'upcase-region 'disabled nil)

;; --- below this part is taken from macbook 

;; Set sbcl as default coommon lisp implementation
(setq inferior-lisp-program "/usr/local/bin/sbcl")

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/slime-20180111.429"))

(slime-setup '(slime-repl slime-fancy slime-banner))

;; Set ghc as Haskell inferior programme

(setq inferior-haskell-program "/usr/local/bin/ghci")

;; Install Intero
(package-install 'intero)
(add-hook 'haskell-mode-hook 'intero-mode)

;; ;; LaTex configurations
;; (load "auctex.el" nil t t)
;; ;; (load "preview-latex.el" nil t t)
;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)
;; (setq-default TeX-master nil)
;; (add-hook 'LaTeX-mode-hook 'visual-line-mode)
;; (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;; (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; (setq reftex-plug-into-AUCTeX t)
;; (setq TeX-PDF-mode t)

;; init.el ends here
