;;; package -- my init.el
;;; Commentary:
;;; Code:

;;;;;;;;;;;;;;;;; BASIC UI ;;;;;;;;;;;;;;;;;;;;;;;;;


;; disable gui bars
(menu-bar-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)


;; full screnn 
;; (toggle-frame-fullscreen)               


;; initial frame parameters
;; (setq initial-frame-alist
;;       '((menu-bar-lines . 0)
;;         (tool-bar-lines . 0)))


;; dibable startup screen
(setq inhibit-startup-screen t)


;; short answers for prompts
(fset 'yes-or-no-p 'y-or-n-p)


;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))


;; font size
(if (string= (system-name) "pluton")
    (set-frame-font "DroidSansMonoForPowerline Nerd Font 15")
  (set-frame-font "Inconsolata 15"))




;; thin line cursor type
(setq-default cursor-type 'bar)
;;(setq transient-mark-mode)  ;; show marked text
;;(setq font-lack-maximum-decoration 1)


;; cursorline highlight
(global-hl-line-mode 1)


;; disable cursor blinking
(blink-cursor-mode 1)

;; remove scratch initial msg
;;(setq initial-scratch-message nil)


;; col num in status-line
(column-number-mode t)


;; line number in mode-line (status-line)
(setq line-number-mode t)


;; nice scrolling
;; num of lines at the top/bottom
;;(secq scroll-preserve-screen-position 't) ;; need more info
;; recenter line while scrolling (need more info)
(setq scroll-margin 7
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)


;; disable the annoying bell ring
(setq ring-bell-function 'ignore)


;; minor-mode for hiding mode-line
;; See http://bzg.fr/emacs-hide-mode-line.html
;; If you want to hide the mode-line in all new buffers
;; (add-hook 'after-change-major-mode-hook 'hidden-mode-line-mode)
(defvar-local hidden-mode-line-mode nil)
(defvar-local hide-mode-line nil)

(define-minor-mode hidden-mode-line-mode
  "Minor mode to hide the mode-line in the current buffer."
  :init-value nil
  :global nil
  :variable hidden-mode-line-mode
  :group 'editing-basics
  (if hidden-mode-line-mode
      (setq hide-mode-line mode-line-format
            mode-line-format nil)
    (setq mode-line-format hide-mode-line
          hide-mode-line nil))
  (force-mode-line-update)
  ;; Apparently force-mode-line-update is not always enough to
  ;; redisplay the mode-line
  (redraw-display)
  (when (and (called-interactively-p 'interactive)
             hidden-mode-line-mode)
    (run-with-idle-timer
     0 nil 'message
     (concat "Hidden Mode Line Mode enabled.  "
             "Use M-x hidden-mode-line-mode to make the mode-line appear."))))


;; A small minor mode to use a big fringe (centered text with horizontal paddings)
(defvar bzg-big-fringe-mode nil)
(define-minor-mode bzg-big-fringe-mode
  "Minor mode to use big fringe in the current buffer."
  :init-value nil
  :global t
  :variable bzg-big-fringe-mode
  :group 'editing-basics
  (if (not bzg-big-fringe-mode)
      (set-fringe-style nil)
    (set-fringe-mode
     (/ (- (frame-pixel-width)
           (* 100 (frame-char-width)))
        2))))

;;(bzg-big-fringe-mode 1)

;; To activate the fringe by default and deactivate it when windows
;; are split vertically, uncomment this:
;; (add-hook 'window-configuration-change-hook
;;           (lambda ()
;;             (if (delq nil
;;                       (let ((fw (frame-width)))
;;                         (mapcar (lambda(w) (< (window-width w) (/ fw 2)))
;;                                 (window-list))))
;;                 (bzg-big-fringe-mode 0)
;;               (bzg-big-fringe-mode 1))))

;; Use a minimal cursor
;; (setq default-cursor-type 'hbar)

;; Get rid of the indicators in the fringe
;; (mapcar (lambda(fb) (set-fringe-bitmap-face fb 'org-hide))
;;         fringe-bitmaps)

;; Set the color of the fringe
;; (custom-set-faces
;;  '(fringe ((t (:background "white")))))


;; Let’s turn off the light…
;; (custom-set-faces
;;  '(default ((t (:background "black" :foreground "grey"))))
;;  '(fringe ((t (:background "black")))))



;;;;;;;;;;;;;;;;; BASIC EDITOR CONFIG ;;;;;;;;;;;;;;;;;;;;;;;;;


;; indent only with whitespaces
(setq-default indent-tabs-mode nil)


;; tab viewed width, not the real identation
(setq tab-width 4)


(setq tab-always-indent 'complete)


;; autopairs (Emacs > 24.4)
(electric-pair-mode 1)


;; match paired parenthethis
(show-paren-mode t)


;; Newline at end of file
(setq require-final-newline t)


;; autoindent while changing code (now i have replacement -> aggressive indent mode)
;; (electric-indent-mode 1


;; delete trailing-space while saving-file
;;freezes emacs on large files (above 200k lines)
;;(add-hook 'before-save-hook 'delete-trailing-lines)


;; windows configuration undo (<-) redo (->) func
;;(winner-mode t)


;; Emacs Development Environment
(global-ede-mode)


;;;;;;;;;;;;;;;;; END OF BASIC EDITOR CONFIG ;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;; BASIC SYSTEM ;;;;;;;;;;;;;;;;;;;;;;;;;;

;; setup alternative input method
(setq default-input-method 'russian-computer)


;; Always load newest byte code
(setq load-prefer-newer t)


;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)   VRFY  needless
(setq gc-cons-threshold 50000000)


;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)


;;;;;;;;;;;;;;;;;;;;;;;; END OF BASIC SYSTEM ;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;; NETWORK ;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; if work-pc -> setup proxy
;; (when (string= (system-name) "mm-sky-011")
;;   (setq url-proxy-services '(("no_proxy" . "\\(localhost\\)")
;;                            ("http" . "localhost:3128")
;;                            ("https" . "localhost:3128"))))


;;;;;;;;;;;;;;;;;;;;;;;; PACKAGE SYSTEM ;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; FIXME does not work on work-machine
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

(package-initialize)

;; update the package metadata is the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))


;; install USE-PACKAGE
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; global "ensure" for all "use-package" declarations
(setq use-package-always-ensure t)


;;;;;;;;;;;;;;;;;;;;;;;; END OF PACKAGE SYSTEM ;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;; SYSTEM ;;;;;;;;;;;;;;;;;;;;;;;;;;


;; for async package  compilation
(use-package async
  :config (async-bytecomp-package-mode 1)
  (setq async-bytecomp-allowed-packages '(all)))


;; multy-language runner
(use-package quickrun)


;; fix paths for quickrepl on mac-gui version of emaccs
;(use-package exec-path-from-shell
;  :config (when (memq window-system '(mac ns))
;            (exec-path-from-shell-initialize)))


;; fix paths for quickrepl on mac-gui version of emaccs
(when (memq window-system '(mac ns))
      (use-package exec-path-from-shell
          :config (exec-path-from-shell-initialize)))


;; nerd-tree clone 4 emacs
(use-package neotree
  :bind ("C-x \\"  . neotree-toggle))


;;;;;;;;;;;;;;;;;;;;;;;; END OF SYSTEM ;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;; UI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (use-package monokai-theme
;;   :config
;;   (load-theme 'monokai t))

(use-package atom-one-dark-theme
  :config
  (load-theme 'atom-one-dark t))

;; solarized theme
;; (use-package solarized-theme
;;   :init
;;   ;; make the fringe stand out from the background
;;   (setq solarized-distinct-fringe-background t)

;;   ;; Don't change the font for some headings and titles
;;   (setq solarized-use-variable-pitch nil)

;;   ;; make the modeline high contrast
;;   (setq solarized-high-contrast-mode-line t)

;;   ;; Use less bolding
;;   (setq solarized-use-less-bold t)

;;   ;; Use more italics
;;   (setq solarized-use-more-italic t)

;;   ;; Use less colors for indicators such as git:gutter, flycheck and similar
;;   (setq solarized-emphasize-indicators nil)

;;   ;; Don't change size of org-mode headlines (but keep other size-changes)
;;   (setq solarized-scale-org-headlines nil)

;;   ;; Avoid all font-size changes
;;   (setq solarized-height-minus-1 1)
;;   (setq solarized-height-plus-1 1)
;;   (setq solarized-height-plus-2 1)
;;   (setq solarized-height-plus-3 1)
;;   (setq solarized-height-plus-4 1)
;;   :config (load-theme 'solarized-light))


;; cursor color (it need be after themes ,co they can override it)
(set-cursor-color "red")

;; pretty icons istead of global-mode text
(use-package mode-icons
  :config (mode-icons-mode))


(use-package powerline
  :config (powerline-default-theme))


;; line numbers in left gutter (switched off, cos does not work with git-gutter)
;; (use-package nlinum
;;   :config
;;   (global-nlinum-mode))
(linum-mode 1)

;; pretty and nice scroll
(use-package yascroll
  :init (scroll-bar-mode -1)
  :config (global-yascroll-bar-mode 1))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF UI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; UNKNOWN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;replaces stock emacs completion with ido completion
;; (use-package ido-ubiquitous
;;   :init
;;   (ido-mode 1)
;;   (ido-everywhere 1)
;;   :config
;;   (ido-ubiquitous 1)
;;   (setq magit-completing-read-function 'magit-ido-completing-read))


;; ;; fuzzy search for ido (like sublime-text ctrl-p)
;; (use-package flx-ido
;;   :init (ido-mode 1)
;;   (ido-everywhere 1)
;;   :config (flx-ido-mode 1)
;;   (setq ido-use-faces nil))


;; ;; ido for M-x
;; (use-package smex
;;   :bind (
;;          ("M-x" . smex)
;;          ("M-X" . smex-major-mode-commands)
;;          ("C-c C-c M-x" . execute-extended-command)))


;; ;; ido in vertical orientation
;; (use-package ido-vertical-mode
;;   :config
;;   (ido-mode 1)
;;   (setq ido-use-faces t)
;;   (set-face-attribute 'ido-vertical-first-match-face nil
;;                       :background nil
;;                       :foreground "orange")
;;   (set-face-attribute 'ido-vertical-only-match-face nil
;;                       :background nil
;;                       :foreground nil)
;;   (set-face-attribute 'ido-vertical-match-face nil
;;                       :foreground nil)
;;   (setq ido-vertical-show-count t)
;;   (ido-vertical-mode 1)
;;   (setq ido-vertical-define-keys 'C-n-and-C-p-only))


;; key-describer for setted hot-keys
;; (use-package guide-key
;;   :config (guide-key-mode 1)
;;   (setq guide-key/guide-key-sequence
;;         '("C-x r" "C-x 4" "C-c p" "C-c !" "C-c j" "C-c j o"))
;;   ;; delay bettwen key-press and popup
;;   ;;(setq guide-key/idle-delay 0.1)
;;   )


;; search framework
(use-package helm
  :init (require 'helm-config)
  (global-unset-key (kbd "C-M-i"))
  :bind ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("C-x b" . helm-buffers-list)
  ("M-i" . helm-imenu-in-all-buffers)
  ("M-y" . helm-show-kill-ring)
  ("M-m" . helm-bookmarks)
  :config (helm-mode 1))

;; integration with projectile
(use-package helm-projectile
:config (helm-projectile-on))


;; setup local-loading docsets
(defun setup-docset-for-dash ()
  (setq-local helm-dash-docsets
              (case major-mode
                (js2-mode '("JavaScript" "AngularJS" "NodeJS" "jQuery" "UnderscoreJS"))
                (web-mode '("HTML" "Emmet" "AngularJS"))
                (css-mode '("CSS"))
                (scss-mode '("CSS" "Compass")))))


;; dash docsets integration
(use-package helm-dash
  ;; adding common docsets
  :config (dolist (hook (list
               'js2-mode-hook
               'web-mode-hook
               'css-mode-hook
               'scss-mode-hook
               ))
  (add-hook hook 'setup-docsets-for-dash)))

;; func for god-mode cursor changing
(defun q-update-cursor ()
  (setq cursor-type
        (if (or god-local-mode buffer-read-only)
            'box
          'bar)))


;; modal mode
(use-package god-mode
  :bind ("<escape>" . god-local-mode)
:config (add-hook 'god-mode-enabled-hook 'q-update-cursor)
(add-hook 'god-mode-disabled-hook 'q-update-cursor))


;; amazing key-chording package
(use-package key-chord
  :config
  (key-chord-mode t)
  (setq key-chord-two-keys-delay 0.1
        key-chord-one-key-delay 0.15)
  (key-chord-define-global "cc" 'ace-jump-char-mode)
  (key-chord-define-global "ff" 'iy-go-to-char)
  (key-chord-define-global "bb" 'iy-go-to-char-backward)
  (key-chord-define-global "zz" 'god-local-mode)
  (key-chord-define-global "gm" 'god-local-mode)
  )



;; vim emulation
;; (use-package evil
;;   :config (evil-mode -1)
;;   ;; remove all keybindings from insert-state keymap
;;   (setcdr evil-insert-state-map nil)
;;   ;; but [escape] should switch back to normal state
;;   (define-key evil-insert-state-map [escape] 'evil-normal-state)
;;   (define-key evil-insert-state-map (kbd "jk") 'evil-normal-state))


;; sublime-like minimap, smooth-scrolling, distraction-free mode
;; lags on big files (200000 lines 3,4mb) scroll unreal
;;(use-package sublimity
;;:config (sublimity-mode 1)
;;(setq sublimity-scroll-wight 5)
;;(setq sublimity-scroll-drift-length 20))

;; auto complete
;; (use-package auto-complete
;;   :init (use-package fuzzy)
;;   :config
;;   (ac-config-default)
;;   (setq ac-quick-help-delay 0.5
;;         ac-fuzzy-cursor-color "green")
;;   (add-to-list 'ac-sources 'ac-source-filename)
;;   ;; fix for work with yasnippet
;;   ;; (ac-set-trigger-key "TAB")
;;   ;; (ac-set-trigger-key "<tab>")
;;   )


;; setup auto-complete behavior to company 
(defun setup-company-mode ()
  (eval-after-load 'company
    '(progn

       (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
       (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
       (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
       (define-key company-active-map (kbd "<backtab>") 'company-select-previous)
       (setq company-require-match 'never))))


;; another auto-complete engine
(use-package company
  :config (add-hook 'after-init-hook 'global-company-mode)
  (setq company-minimum-prefix-length 2
        company-show-numbers t)
  (setup-company-mode)
  ;; fixed lowercased candidates on web-mode
  (add-to-list 'company-dabbrev-code-modes 'web-mode))


(use-package company-web
  :config (require 'company-web-html))


;; In-cursor position quickhelp
(use-package company-quickhelp
  :init (use-package pos-tip)
  :config (company-quickhelp-mode 1)
  (eval-after-load
      'company '(define-key company-active-map (kbd "M-h") #'company-quickhelp-manual-begin)))




(use-package artist)
;;;;;;;;;;;;;;;;;;;;;;;; ACE NAVIGATION ;;;;;;;;;;;;;;;;;;;;;;;;


;; fast window navigation
(use-package ace-window
  :bind ("M-p" . ace-window)
  ("C-x o" . ace-window)
  ;;  ("C-x 1" . ace-maximize-window)
  ;;  ("C-x 0" . ace-delete-window)
  ("C-x 9" . ace-swap-window))

;; popup-menu  ;; VRFY Define where does in work
(use-package ace-popup-menu
  :config (ace-popup-menu-mode 1))

;; fast char navigation
;; VRFY that ace-jump is obsolete
(use-package ace-jump-mode
  :bind ("C-c c" . ace-jump-mode)
  ("C-c l" . ace-jump-line-mode))

;; fast buffer navigation
(use-package ace-jump-buffer
  :bind ("C-c b" . ace-jump-buffer)
  ("C-c o b" . ace-jump-buffer-other-window)
  ("C-c p b" . ace-jump-projectile-buffers)
  :config (global-unset-key (kbd "M-<down-mouse-1>"))
  (global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click))


;;;;;;;;;;;;;;;;;;;;;;; END OF ACE NAVIGATION ;;;;;;;;;;;;;;;;;;;;;;;;

;; visible bookmarks ()
;;(use-package bm)

;; multi cursor, like sublime-text
(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-S-c C-S-c" . mc/edit-lines)
         ("C-c C-<" . mc/mark-all-like-this)))


;; search/replace engine compatible with multiple cursors
;; also have great preview of replacing
(use-package phi-search
  :bind("C-s" . phi-search)
  ("C-r" . phi-search-backward)
  ("M-%" . phi-replace-query))


;; Similar to "f" command from vim
(use-package iy-go-to-char
  :bind ;;("M-m" . iy-go-to-char)
   ;;  ("C-M-m" . iy-go-to-char-backward)
  :config (add-to-list 'mc/cursor-specific-vars 'iy-go-to-char-start-pos))


;;;;;;;;;;;;;;;;;;;;;;;;;; HYDRA ;;;;;;;;;;;;;;;;;;;;;;;;;

;; package for custom menus (like modal modes but with hints)
(use-package hydra)

;; font zooming
(global-set-key (kbd "C-+")
                (defhydra hydra-zoom (:hint nil)
                  "zoom"
                  ("g" text-scale-increase "in")
                  ("l" text-scale-decrease "out")
                  ("q" nil "quit" :color blue)))


;; windows management
(global-set-key (kbd "C-x w")
                (defhydra hydra-window (:hint nil)
                  "
^Splitting^         ^Sizing^                   ^Navigation^
^^^^-----------------------------------------------------------
_1_: close other    _\^_: enlarge vertical     _j_: jump 
_2_: horizontal     _\__: shrink vertical        _s_: swap 
_3_: vertical       _]_: enlarge horizontal    ^^
_0_: delete         _[_: shrink horizontal     ^^
^^                  _b_: balance windows      ^^
"
                  ("1" delete-other-windows)
                  ("2" split-window-below)
                  ("3" split-window-right)
                  ("0" delete-window)
                  ("^" enlarge-window )
                  ("]" enlarge-window-horizontally)
                  ("_" shrink-window)
                  ("[" shrink-window-horizontally)
                  ("b" balance-windows)
                  ("s" ace-swap-window)
                  ("j" ace-window)
                  ("q" nil "quit" :color blue)))


;; error navigation
(global-set-key (kbd "C-x e")
                (defhydra hydra-error ()
                  "goto-error"
                  ("a" first-error "first")
                  ("n" next-error "next")
                  ("p" previous-error "prev")
                  ("v" recenter-top-bottom "recenter")
                  ("q" nil "quit" :color blue)))

;; git hunks navigation
(global-set-key (kbd "C-x g")
                (defhydra hydra-git-gutter ()
                  "goto-git-hunk"
                  ("t" git-gutter:toggle "toggle")
                  ("d" git-gutter:popup-hunk "popup diff hunk")
                  ("p" git-gutter:previous-hunk "prev hunk")
                  ("n" git-gutter:next-hunk "next hunk")
                  ("s" git-gutter:state-hunk "state hunk")
                  ("r" git-gutter:revert-hunk "revert hunk")
                  ("q" nil "quit" :color blue)))


;;;;;;;;;;;;;;;;;;;;;;; END OF HYDRA ;;;;;;;;;;;;;;;;;;;;;


;; git intergration
(use-package magit
  :bind ("C-c g" . magit-status))

;; git gutter; (expertimental functionality with linum) !!! doesn't work with nlinum !!!
(use-package git-gutter
  :config
  (git-gutter:linum-setup)
  (global-git-gutter-mode +1))
;; :bind("C-c g t" . git-gutter:toggle)
;; ("C-c g p" . git-gutter:previous-hunk)
;; ("C-c g n" . git-gutter:next-hunk)
;; ("C-c g s" . git-gutter:state-hunk)
;; ("C-c g r" . git-gutter:revert-hunk)
;; ("C-c g m" . git-gutter:revert-hunk))

;; expand marked text
(use-package expand-region
  :bind
  ("C--" . er/contract-region)
  ("C-=" . er/expand-region))

;; auto-indent on the fly
(use-package aggressive-indent
  :config (global-aggressive-indent-mode -1))


;; common setup for web-mode
;; set indent to 2
;; highlight current element
(defun setup-web-mode ()
  (setq web-mode-script-padding 2
        web-mode-style-padding 2
        web-mode-block-padding 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-markup-indent-offset 2
        web-mode-enable-current-element-highlight t))


;; setup react-js edition.
(defun setup-reactjs-in-web-mode ()
   (setq web-mode-content-types-alist
                '(("jsx" . "\\.js[x]?\\'")
                  ("jsx" . "\\.es\\'")))
  ;; for better jsx syntax-highlighting in web-mode
  ;; - courtesy of Patrick @halbtuerke
  (defadvice web-mode-highlight-part (around tweak-jsx activate)
    (if (equal web-mode-content-type "jsx")
        (let ((web-mode-enable-part-face nil))
          ad-do-it)
      ad-do-it)))


;; web mode to use with ReactJS working
;; cos we have mixed content of JS/XML
(use-package web-mode
  :mode (("\\.jsx?\\'" . web-mode)
         ("\\.es\\'" . web-mode))
  :interpreter ("node" . web-mode)
  :config (setup-web-mode)
  (setup-reactjs-in-web-mode))


;;;;;;;;;;;;;;;; JS mode ;;;;;;;;;;;;;;;;;;;;;;;;;;


;; npm install -g tern
;; intelligent js autocomplete engine
;; (use-package tern)

;; auto-complete tern adaptor
;; (use-package tern-auto-complete)


;; usefull only for pure js/jsx files (without <script> tag or templates)
(use-package js2-mode
  :init (setq js2-basic-offset 2)
  ;; :mode ("\\.js\\'" . js2-mode)
  :interpreter ("node" . js2-mode)
  ;; :config        
  ;;(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
  ;; (eval-after-load 'tern
  ;;   '(progn
  ;;      (require 'tern-auto-complete)
  ;;      (tern-ac-setup)))
  )


;; refactore package for js
(use-package js2-refactor
  :config (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (js2r-add-keybindings-with-prefix "C-c C-m"))


;;;;;;;;;;;;;;;; END OF JS mode ;;;;;;;;;;;;;;;;;;;;;;;;;;


;; saas mode
(use-package sass-mode)


;; indent for css
(setq css-indent-offset 2)

;; markdown mode
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


;; json better highlighting and displaying path of json-object (C-c C-p)
(use-package json-mode)
  ;; disable checking json
  ;; :config
  ;; FIX flycheck-disabled-checkers as varible is void
  ;; (setq-default flycheck-disabled-checkers
  ;;                         (append flycheck-disabled-checkers '(json-jsonlint)
;; )))



;;;;;;;;;;;;;;; DEVELOPMENT HELPERS ;;;;;;;;;;;;;;;;;

(defun setup-reactjs-dev-workflow ()
  "Setup react-js dev workflow by setiing eslint as an linter and bind it to web-mode."
  "ESLINT must be configured (by .eslintrc file)"
  ;; disable jshint for js files
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers '(javascript-jshint)))
  ;; use eslint with web-mode
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  ;; customize flycheck temp file prefix
  (setq-default flycheck-temp-prefix ".flycheck")
  ;; disable json-jsonlint checking 4 json
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers '(json-jsonlint))))


;; tooltip with error at the point
(use-package flycheck-pos-tip
  :config (setq flycheck-pos-tip-timeout 10))

;; emoji replacement of flycheck status
(use-package flycheck-status-emoji
  :config (flycheck-status-emoji-mode)
  (set-fontset-font t nil "Symbola"))


;; check syntax on the fly
(use-package flycheck
  :init (global-flycheck-mode)
  ;; enable position tooltip
  (flycheck-pos-tip-mode)
  :config (setup-reactjs-dev-workflow))

;; C-c ! n and C-c ! p you can now jump back and forth between erroneous places


;; project features like find file/grep in file/replace in project
;; (increasing eficency by scoping files in project)
(use-package projectile
  :bind ("C-c p p" . projectile-switch-project)
  :config
  ;; (projectile-global-mode)
  (add-hook 'js2-mode-hook 'projectile-mode)
  (add-hook 'web-mode-hook 'projectile-mode))

;; emacs code browser  ERROR
(use-package ecb
  ;;  :config (ecb-activate)
  )

;; snippets engine
(use-package yasnippet
  :config (yas-global-mode 1)
  ;; fix to work with auto-complete
  ;; (define-key yas-minor-mode-map (kbd "<tab>") nil)
  ;; (define-key yas-minor-mode-map (kbd "TAB") nil)
  ;;  (define-key yas-minor-mode (kbd "<backtab>") 'yas-expand)
  )

;; snipeets 4 react (es5)
(use-package react-snippets)

;; menu with all tags from buffers with the same mode
(use-package imenu-anywhere
  :bind ("C-c i" . imenu-anywhere))

(use-package emmet-mode
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
  (add-hook 'web-mode-hook 'emmet-mode)
  )

;;;;;;;;;;;;;;; END OF DEVELOPMENT HELPERS ;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;; FUNCS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun q-copy-range-and-comment ()
  "This function copy range, comment it and then yank afret commented."
  (interactive)
  (kill-ring-save (mark) (point))
  (comment-region (mark) (point))
  (newline)
  (yank))


(defun q-edit-init-file ()
  "Edit my init file, that located in ~/.emacs.d."
  (interactive)
  (find-file "~/.emacs.d/init.el"))


;; start async process with output in buffer
(defun q-start-process (command directory buffer-name)
  "Start async COMMAND in DIRECTORY with output in BUFFER-NAME."
  (let ((buffer (get-buffer buffer-name))
        (default-directory directory))
    (when buffer
      (kill-buffer buffer)
      (message buffer-name)
      (async-shell-command command buffer-name)
      (switch-to-buffer-other-window buffer-name))))


;; TODO: define usage of above function
;; (global-set-key (kbd "C-c r")
;;                 (lambda ()
;;                   (interactive)
;;                   (q-start-process  "/home/vitaly/.linuxbrew/bin/npm start" "/home/vitaly/Developer/Scratch/frontend/autodelivery-ui/" "*ad-ui*")))


;;;;;;;;;;;;;;;;;;;;;;; END OF FUNCS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; KEYS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; regexp search by default
;; (global-set-key (kbd "C-s") 'isearch-forward-regexp)
;; (global-set-key (kbd "C-r") 'isearch-backward-regexp)

(global-set-key (kbd "<C-tab>") 'ace-jump-buffer)

;;(global-set-key (kbd "<ESC>") 'keyboard-quit)
(global-set-key (kbd "C-1") 'delete-other-windows)
(global-set-key (kbd "C-2") 'split-window-below)
(global-set-key (kbd "C-3") 'split-window-right)
;;(global-set-key (kbd "M-4") )
(global-set-key (kbd "C-0") 'delete-window)

(global-set-key (kbd "C-x /") 'q-edit-init-file)
(global-set-key (kbd "C-M-;") 'q-copy-range-and-comment)

(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z") 'undo)

;;;;;;;;;;;;;;;;;;;;;;;; END OF KEYS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'init)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; init.el ends here ;;;;;;;;;;;;;;;;;;;


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("54ece5659cc7acdcd529dddd78675c2972a5ac69260af4a6aec517dcea16208b" "557c283f4f9d461f897b8cac5329f1f39fac785aa684b78949ff329c33f947ec" "9cb6358979981949d1ae9da907a5d38fb6cde1776e8956a1db150925f2dad6c1" "737d9d0e0f6c4279e80f7479ec5138af6e4908a2d052126f254e1e6d1a0d0188" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(ecb-options-version "2.40")
 '(ede-project-directories
   (quote
    ("/home/vitaly/Developer/Scratch/frontend/autodelivery-ui/application"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
