;; Provides custom set-up ley binds

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

;; mapping keybinds of goto-line to goto-line-with-feedback
(global-set-key [remap goto-line] 'goto-line-with-feedback)

;; key bind C-t to (other-window)
(global-set-key (kbd "C-t") 'other-window)

;; key bind C-x C-g to magit
(global-set-key (kbd "C-x C-g") 'magit-status)

;; key bind C-Shift-SPC
(global-set-key (kbd "C-S-SPC") nil)
(global-set-key (kbd "C-S-SPC") 'set-mark-command)
(global-set-key (kbd "C-SPC") nil)
(global-set-key (kbd "C-SPC") 'toggle-input-method)

(provide 'custom-keys)
