;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Install all my default packages

(defconst IS_ETSY_ENV (getenv "ETSY_ENVIRONMENT"))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(when IS_ETSY_ENV
    (add-to-list 'package-archives '("etsy" . "http://localhost:8005/packages/") t))
(package-initialize)

(unless (file-exists-p "~/.emacs.d/elpa/archives/melpa")
  (package-refresh-contents))

(mapc
 (lambda (package)
   (if (not (package-installed-p package))
       (package-install package)))
 '(;; major and minor modes
   clojure-mode markdown-mode php-mode sass-mode yaml-mode
   ;; language specific flymakes
   flymake-cursor flymake-jshint flymake-css
   ;; utilities
   dired+ magit ein ag ido-better-flex ido-ubiquitous
   ;; themes
   molokai-theme zenburn-theme
   ;; packages that make editing text easier
   yasnippet hungry-delete rainbow-mode whole-line-or-region))

(if IS_ETSY_ENV
  (if (not (package-installed-p 'etsy-starter-kit))
      (package-install 'etsy-starter-kit)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Set a couple bare minimums

(menu-bar-mode -1)
(ido-mode t)
(setq inhibit-startup-message t)
(setq indent-tabs-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(column-number-mode t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'almost-monokai t)
(yas-global-mode 1)
(whole-line-or-region-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Manage my non-default auto modes: alist modes,

(when IS_ETSY_ENV
    (require 'etsy-starter-kit))
(add-to-list 'auto-mode-alist (cons "\\.tpl\\'" 'html-mode))
(setq whitespace-line-column 120)
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file  "~/.emacs.d/saveplace")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Custom Functions

;; taken from emacs wiki
;; Original idea from http://www.opensubscriber.com/message/emacs-devel@gnu.org/10971693.html
(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (region-active-p)
      (let ((start (region-beginning))
            (end (region-end)))
        (goto-char start)
        (let ((real-start (line-beginning-position)))
          (goto-char end)
          (comment-or-uncomment-region real-start (line-end-position))))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

;; indent/unindent region
(defun indent-rigid-by-4 (start end)
  "Indents the region 4 spaces to the right"
  (interactive "r")
  (indent-code-rigidly start end 4))
(defun unindent-rigid-by-4 (start end)
  "Indents the region 4 spaces to the right"
  (interactive "r")
  (indent-code-rigidly start end -4))

;; Taken from Steve Yegge's .emacs
;; someday might want to rotate windows if more than 2 of them
(defun swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((not (= (count-windows) 2)) (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1)))))

(defun beginning-of-line-dwim ()
  (interactive)
  (if (eq (current-column) 0)
      (back-to-indentation)
    (beginning-of-line)))

(defun end-of-line-dwim ()
  (interactive)
  (if (not (eq (point) (line-end-position)))
      (end-of-line)
    (progn
      (search-backward-regexp "[^\t ]")
      (forward-char))))

(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

(defun scroll-up-one ()
  (interactive)
  (scroll-up 1))

(defun scroll-down-one ()
  (interactive)
  (scroll-up -1))

;; ag settings
(require 'ag)
(setq ag-reuse-buffers t)
(setq ag-reuse-window t)
(setq my-ag-default-path (if IS_ETSY_ENV "/home/ryoung/development/Etsyweb" nil))
(defun my-ag (string directory)
  (interactive (list (read-from-minibuffer "Search string: " (ag/dwim-at-point))
		     (if my-ag-default-path my-ag-default-path (read-directory-name "Directory: "))))
  (window-configuration-to-register ?9)
  (ag/search string directory)
  (jump-to-register ?9)
  (switch-to-buffer "*ag search*"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Custom key bindings

(global-set-key "\M-;" 'comment-dwim-line)
(global-set-key (kbd "C-o") 'swap-windows)
(global-set-key (kbd "C-a") 'beginning-of-line-dwim)
(global-set-key (kbd "C-e") 'end-of-line-dwim)
(global-set-key (kbd "<up>") 'scroll-down-one)
(global-set-key (kbd "<down>") 'scroll-up-one)
(global-set-key (kbd "C-]") 'hungry-delete-backward)
(global-set-key (kbd "C-\\") 'hungry-delete-forward)
(global-set-key (kbd "C-x i") 'previous-multiframe-window)
(global-set-key (kbd "C-c C-p") 'flymake-goto-prev-error)
(global-set-key (kbd "C-c C-n") 'flymake-goto-next-error)
(global-set-key [f13] 'whitespace-mode)
(global-set-key [f14] 'longlines-mode)
(global-set-key [f15] 'delete-trailing-whitespace)
(global-set-key (kbd "ESC <right>") 'indent-rigid-by-4)
(global-set-key (kbd "ESC <left>") 'unindent-rigid-by-4)
(global-set-key (kbd "M-.") 'my-ag)

(add-hook 'php-mode-hook (lambda ()
  (local-set-key (kbd "C-c C-p") 'flymake-goto-prev-error)
  (local-set-key (kbd "C-c C-n") 'flymake-goto-next-error)))

;; This doesn't work for emacs --daemon / emacsclient restarts :(
(set-terminal-coding-system 'utf-8)
(put 'upcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("9eaf703f1f8282dad69bb6cb34077a6789cd8df0e17f42fcfe3d5a5132639239" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Basic setup from etsy-startup-kit if I'm not on an etsy box

(unless IS_ETSY_ENV
  (require 'flymake-jshint)
  (add-hook 'js-mode-hook (lambda () (setq indent-tabs-mode nil)))
  (add-hook 'js-mode-hook 'flymake-jshint-load)

  (require 'flymake-css)
  (add-hook 'css-mode-hook (lambda () (setq indent-tabs-mode nil)))
  (add-hook 'css-mode-hook 'rainbow-mode)

  (setq php-mode-force-pear 1) ;; gives us 4 spaces/tab and no tabs
  (add-hook 'php-mode-hook 'flymake-mode)

  (add-hook 'html-mode-hook (lambda () (setq indent-tabs-mode nil)))
  (add-hook 'html-mode-hook (lambda () (setq sgml-basic-offset 4))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Clojure config
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(add-hook 'cider-repl-mode-hook 'subword-mode)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'smartparens-strict-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
(setq nrepl-hide-special-buffers t)
(setq cider-repl-pop-to-buffer-on-connect nil)
(setq cider-popup-stacktraces nil)
(setq cider-repl-popup-stacktraces t)
(setq cider-auto-select-error-buffer t)
(setq nrepl-buffer-name-show-port t)
(setq cider-repl-display-in-current-window t)
(global-rainbow-delimiters-mode)
