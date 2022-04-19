;; Define the init file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
    (load custom-file))
  
;; Silence compiler warnings as they can be pretty disruptive
(setq comp-async-report-warnings-errors nil)

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
  (lambda ()
    (message "*** Emacs loaded in %s with %d garbage collections."
      (format "%.2f seconds"
        (float-time
          (time-subtract after-init-time before-init-time)))
      gcs-done)))

;; Define and initialise package repositories
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; use-package to simplify the config file
(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)

;; Show line numbers everywhere
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(global-display-line-numbers-mode)

;; Keyboard-centric user interface
(tool-bar-mode -1)

;; Keybinding Panel
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; (menu-bar-mode -1)
(scroll-bar-mode -1)
(defalias 'yes-or-no-p 'y-or-n-p)
(set-default 'cursor-type 'hbar)
(set-default-coding-systems 'utf-8)

;; Set tab to 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; Set default font
(set-face-attribute 'default nil
                    :family "CartographCF Nerd Font"
                    :height 100
                    :weight 'normal
                    :width 'normal)

;; Theme
(use-package ujelly-theme
    :config (load-theme 'ujelly t))

;; Startup screen
(setq fancy-splash-image (expand-file-name "assets/icon.png" user-emacs-directory))

;; Smooth scrolling
(setq redisplay-dont-pause t
  scroll-margin 1
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

;; Neo Tree
(use-package neotree)
(global-set-key [f8] 'neotree-toggle)

;; lsp
(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)
(add-hook 'bash-mode-hook 'lsp)
(add-hook 'cmake-mode-hook 'lsp)
(add-hook 'crystal-mode-hook 'lsp)
(add-hook 'css-mode-hook 'lsp)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'elexir-mode-hook 'lsp)
(add-hook 'go-mode-hook 'lsp)
(add-hook 'html-mode-hook 'lsp)
(add-hook 'javascript-mode-hook 'lsp)
(add-hook 'json-mode-hook 'lsp)
(add-hook 'lua-mode-hook 'lsp)
(add-hook 'markdown-mode-hook 'lsp)
(add-hook 'rust-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))

;; C mode
(defun my-c-mode-hook ()
  (setq c-basic-offset 4
        c-indent-level 0
        indent-tabs-mode nil
        c-default-style "linux")
  )
(add-hook 'c-mode-common-hook 'my-c-mode-hook)

;; Syntax Highlighting
(use-package tree-sitter)
(use-package tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'c-mode-hook #'tree-sitter-hl-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)