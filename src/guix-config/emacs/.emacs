(menu-bar-mode 0)
(tool-bar-mode 0)
(pixel-scroll-precision-mode 1)

(load-theme 'wheatgrass)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-safe-remote-resources
   '("\\`https://fniessen\\.github\\.io/org-html-themes/org/theme-readtheorg\\.setup\\'"))
 '(package-selected-packages
   '(lsp-mode nix-mode magit org-auto-tangle org-superstar haskell-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:slant normal :weight normal :height 120 :width normal :foundry "PfEd" :family "DejaVu Sans Mono"))))
 '(Info-quoted ((t (:inherit default :slant italic :height 0.9)))))

;; Make Elisp files in that directory available to the user.
(add-to-list 'load-path "~/.emacs.d/manual-packages/agitate")

(require 'org-superstar)
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))

(require 'org)
(setq org-todo-keywords
      '((sequence "TODO" "FEEDBACK" "VERIFY" "NOTE" "|" "DONE" "DELEGATED")))

;; (require 'parinfer)
;; (add-hook 'emacs-lisp-mode-hook (lambda () (parinfer-mode 1)))
;; (add-hook 'scheme-mode-hook (lambda () (parinfer-mode 1)))

(require 'info)
(add-hook 'Info-mode-hook (lambda () (hl-line-mode 1)))

;; These are all OPTIONAL.  You should just use whatever key bindings
;; or setup you prefer.

;; Agitate is still a WORK-IN-PROGRESS.

(require 'agitate)

(add-hook 'diff-mode-hook #'agitate-diff-enable-outline-minor-mode)

(advice-add #'vc-git-push :override #'agitate-vc-git-push-prompt-for-remote)

;; Also check: `agitate-log-edit-informative-show-files',
;; `agitate-log-edit-informative-show-root-log'.
(agitate-log-edit-informative-mode 1)

(let ((map global-map))
  (define-key map (kbd "C-x v =") #'agitate-diff-buffer-or-file) ; replace `vc-diff'
  (define-key map (kbd "C-x v g") #'agitate-vc-git-grep) ; replace `vc-annotate'
  (define-key map (kbd "C-x v f") #'agitate-vc-git-find-revision)
  (define-key map (kbd "C-x v s") #'agitate-vc-git-show)
  (define-key map (kbd "C-x v p p") #'agitate-vc-git-format-patch-single)
  (define-key map (kbd "C-x v p n") #'agitate-vc-git-format-patch-n-from-head))
(let ((map diff-mode-map))
  (define-key map (kbd "C-c C-b") #'agitate-diff-refine-cycle) ; replace `diff-refine-hunk'
  (define-key map (kbd "C-c C-n") #'agitate-diff-narrow-dwim))
(let ((map log-view-mode-map))
  (define-key map (kbd "w") #'agitate-log-view-kill-revision)
  (define-key map (kbd "W") #'agitate-log-view-kill-revision-expanded))
(let ((map vc-git-log-view-mode-map))
  (define-key map (kbd "c") #'agitate-vc-git-format-patch-single))
(let ((map log-edit-mode-map))
  (define-key map (kbd "C-c C-i C-n") (lambda () "Agitate insert file name with extension."
					(interactive) (agitate-log-edit-insert-file-name t)))
  ;; See user options `agitate-log-edit-emoji-collection' and
  ;; `agitate-log-edit-conventional-commits-collection'.
  (define-key map (kbd "C-c C-i C-e") #'agitate-log-edit-emoji-commit)
  (define-key map (kbd "C-c C-i C-c") #'agitate-log-edit-conventional-commit))
