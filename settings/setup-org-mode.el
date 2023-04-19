;; define key bindings for org-mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(eval-after-load "org"
  '(require 'ox-md nil t))

;; set maximum indentation for description lists
(setq org-list-description-max-indent 5)

;; prevent demoting heading also shifting text inside sections
(setq org-adapt-indentation nil)

;;syntax highlight code blocks
(setq org-src-fontify-natively t)

;; highlight latex related texts
(setq org-highlight-latex-and-related '(latex script entities))

;; Some initial languages we want org-babel to support
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (shell . t)
   (python . t)
   ))

;; Turn on CDlatex
(add-hook 'org-mode-hook 'org-cdlatex-mode)

(require 'ox-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")))

(add-to-list 'org-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("bjmarticle"
               "\\documentclass{article}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{graphicx}
\\usepackage{longtable}
\\usepackage{hyperref}
\\usepackage{natbib}
\\usepackage{amssymb}
\\usepackage{amsmath}
\\usepackage{geometry}
\\geometry{a4paper,left=2.5cm,top=2cm,right=2.5cm,bottom=2cm,marginparsep=7pt, marginparwidth=.6in}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Replace \( and \) to $ and \[ and \] to $$ in org mode.
(require 's)
(require 'dash)

(defun my/org-replace-latex-wrap (text backend _info)
  "Replaces \( and \) with $, \[ and \] with $$ when the backend is ox/md (org-exporter for markdown)."
  (when (org-export-derived-backend-p backend 'md)
    (cond
     ((s-starts-with? "\\(" text)
      (--> text
	   (s-replace-all '(("\\(" . "$") ("\\)" . "$")) it)))
     ((s-starts-with? "\\[" text)
      (--> text
	   (s-replace-all '(("\\[" . "$$") ("\\]" . "$$")) it))))))

;; (defun my/org-replace-latex-wrap (text backend _info)
;;   (when (org-export-derived-backend-p backend 'md)
;;     (cond
;;      ((s-starts-with? "\\(" text)
;;       (--> text
;;            (s-chop-prefix "\\(" it)
;;            (s-chop-suffix "\\)" it)
;;            (s-wrap it "$")))
;;      ((s-starts-with? "\\[" text)
;;       (--> text
;;            (s-chop-prefix "\\[" it)
;;            (s-chop-suffix "\\]" it)
;;            (s-wrap it "$$"))))))

(add-to-list 'org-export-filter-latex-fragment-functions 'my/org-replace-latex-wrap)


(defun my/org-wrap-latex-macros (text backend _info)
  "Wraps latex macro-environment region by $$."
  (when (org-export-derived-backend-p backend 'md)
    (cond
     ((s-starts-with? "\\begin" text)
      (--> text
	   (s-concat "$$\n" it)
	   ;; (message (format "%s" (s-matches-p "^.*\\end{.*}.*" it)))
	   (s-chop-suffix "\n" it)
	   (s-concat it "$$\n")
	   ;; (message (format "%s" (s-matched-positions-all "\n" it)))
	   ;; (message (format "%s" (cdr (last (s-matched-positions-all "\n" it)))))
	   )))))

(add-to-list 'org-export-filter-plain-text-functions 'my/org-wrap-latex-macros)

(provide 'setup-org-mode)
