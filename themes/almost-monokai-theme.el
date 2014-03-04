;;; Almost Monokai: color-theme-almost-monokai.el
;;; A beautiful, fruity and calm emacs color theme.

;; Author: Prateek Saxena <prtksxna@gmail.com>
;; Author: Pratul Kalia   <pratul@pratul.in>
;;
;; Based on the Monokai TextMate theme
;; Author: Wimer Hazenberg <http://www.monokai.nl>

;; Depends: color-theme

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

; Color theme support is required.
(deftheme almost-monokai
  "Color theme based on the Almost-Monokai color scheme for Vim.")

(custom-theme-set-faces
       'almost-monokai

       '(default ((t (:foreground "#F8F8F2" :background "#1B1D1E"))))
       '(cursor ((t (:foreground nil :background "#DAD085"))))
       '(mode-line ((t (:foreground "#acbc90" :background "#1B1D1E"
                        :box (:line-width 1 :color "#000000" :style released-button)))))
       '(mode-line-buffer-id ((t (:foreground nil  :weight semi-bold))))
       '(mode-line-inactive ((t (:foreground "#88b090" :background "#1B1D1E"
                                 :box (:line-width 1 :color "#2A3233")))))
       '(font-lock-builtin-face ((t (:foreground "#A6E22A"))))
       '(font-lock-comment-face ((t (:foreground "#75715D" :slant italic))))
       ;; '(font-lock-comment-delimiter-face ((t (:foreground "#465457" :slant italic))))
       '(font-lock-comment-delimiter-face ((t (:foreground "#75715D" :slant italic))))
       '(font-lock-constant-face ((t (:foreground "#66D9EF"))))
       '(font-lock-doc-face ((t (:foreground "#65B042" :slant italic))))
       '(font-lock-function-name-face ((t (:foreground "#F1266F" :slant italic))))
       '(font-lock-keyword-face ((t (:foreground "#66D9EF"))))
       '(font-lock-negation-char-face ((t (:weight bold))))
       '(font-lock-preprocessor-face ((t (:foreground "#A6E22E"))))
       '(font-lock-regexp-grouping-backslash ((t (:weight bold))))
       '(font-lock-regexp-grouping-construct ((t (:weight bold))))
       '(font-lock-string-face ((t (:foreground "#DFD874"))))
       '(font-lock-type-face ((t (:foreground "#89BDFF" :underline t))))
       '(font-lock-variable-name-face ((t (:foreground "#A6E22A"))))
       '(diff-header ((t (:background "#1B1D1E" :foreground "cyan"))))
       '(diff-file-header ((t (:background "#1B1D1E" :foreground "cyan"))))
       '(diff-hunk-header ((t (:foreground "#DFD874"))))
       '(diff-function ((t (:foreground "#DFD874"))))
       '(diff-added ((t (:foreground "#A6E22A"))))
       '(diff-removed ((t (:foreground "#F1266F"))))
       '(hl-line ((t (:background "#1A1A1A" ))))
       '(region ((t (:background "#6DC5F1"))))
       '(ido-subdir ((t (:foreground "#F1266F"))))
       '(flymake-errline ((t (:background "red" :foreground "#F8F8F2"))))
       )
;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))
(provide-theme 'almost-monokai)
;---------------
; Code end.
