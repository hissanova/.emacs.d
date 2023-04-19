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
     company-auctex
     haskell-mode
     sclang-extensions
     slime
     cider
     nhexl-mode
     zenburn-theme
     material-theme
     flycheck
     flycheck-mypy
     py-autopep8
     py-yapf
     rope-read-mode
     pipenv
     elpy
     ein
     auctex
     cdlatex
     helm
     org
     dockerfile-mode
     markdown-mode
     json
     fish-mode
     paredit
     expand-region
     smartparens
     buffer-expose
     yaml-mode
     use-package
     web-mode
     ))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      myPackages)

(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (require 'use-package))

;; Set path to dependencies
(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))

;; Set up load path
(add-to-list 'load-path settings-dir)

(buffer-expose-mode 1)

;; Setup appearance including theme .emacs.d/settings/appearance.el
(require 'appearance)

;; Load settings for org-mode from .emacs.d/settings/setup-org-mode.el
(require 'setup-org-mode)

;; Load settings for custom key binds from .emacs.d/settings/custom-keys.el
(require 'custom-keys)

;; Load settings for python dev environment from .emacs.d/settings/python-env.el
(require 'python-env)

;; Loads settings for Haskell mode
(require 'haskell-settings)

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

(use-package paredit
  :config (add-hook
	   'paredit-mode-hook
	   (lambda ()
	     (smartparens-mode -1)))
  :bind (("M-(" . paredit-wrap-round)
	 ("C-<right>" . paredit-forward-slurp-sexp)
	 ("C-<left>" . paredit-forward-barf-sexp)))
;; These setting must run outside use-package for unknown reason
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(add-hook 'cider-repl-mode-hook 'enable-paredit-mode)

(use-package smartparens
  :config
  (smartparens-global-mode t))

(use-package diminish
  :config
  (diminish 'wrap-region-mode)
  (diminish 'yas/minor-mode)
  (diminish 'smartparens-mode))

(use-package dired
  :bind (:map dired-mode-map
	      ("i" . dired-subtree-insert)
	      ( ";" . dired-subtree-remove))
  :config
  ;; Make dired less verbose
  (add-hook 'dired-mode-hook
	    (lambda ()
	      (dired-hide-details-mode))))

(use-package helm
  :bind (("M-x" . helm-M-x)
         ("M-<f5>" . helm-find-files)
         ([f10] . helm-buffers-list)
         ([S-f10] . helm-recentf)))


(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))

(use-package yasnippet
  :config
  (yas-global-mode 1))

;; (use-package mozc
;;   :config
;;   (setq default-input-method "japanese-mozc"))

;; activate company mode for all buffers
(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0.1)

;;hide passwords automatically
(add-hook 'comint-output-filter-functions
	  'comint-watch-for-password-prompt)

;; Turns show-paren-mode on
(show-paren-mode 1)

;; expand-region
(require 'expand-region)
(global-set-key (kbd "C-]") 'er/expand-region)

;; activate upcase-region
(put 'upcase-region 'disabled nil)

;; Set sbcl as default coommon lisp implementation
(setq inferior-lisp-program "/usr/local/bin/sbcl")

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/slime-20180111.429"))

(slime-setup '(slime-repl slime-fancy slime-banner))



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

;; I'm trying to make an interactive function to replace "," with ",\n" in the selected region.


(defun get-selected-text (start end)
  (interactive "r")
  (if (use-region-p)
      (let ((regionp (buffer-substring start end)))
	(message regionp))))

;; init.el ends here
(put 'downcase-region 'disabled nil)

