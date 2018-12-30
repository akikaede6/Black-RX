;;; private/my-cc/config.el -*- lexical-binding: t; -*-

(after! cc-mode

  (setq c-default-style "bsd")
  (add-to-list 'auto-mode-alist '("\\.inc\\'" . +cc-c-c++-objc-mode))
  )


(def-package! ccls
  :load-path "~/Dev/Emacs/emacs-ccls"
  :defer t
  :init
  (add-hook! (c-mode c++-mode cuda-mode objc-mode) #'+ccls//enable)
  (setq ccls-executable "~/dev/ccls/Release/ccls")
  :config
  (setq lsp-prefer-flymake nil)
  (setq ccls-initialization-options `(:cacheDirectory "~/tmp/cclscache"))

  ;; overlay is slow
  ;; Use https://github.com/emacs-mirror/emacs/commits/feature/noverlay
  ;; (setq ccls-sem-highlight-method 'font-lock)
  (add-hook 'lsp-after-open-hook #'ccls-code-lens-mode)
  (ccls-use-default-rainbow-sem-highlight)
  ;; https://github.com/maskray/ccls/blob/master/src/config.h
  (setq
   ccls-initialization-options
   `(:clang
     (:excludeArgs
      ;; Linux's gcc options. See ccls/wiki
      ["-falign-jumps=1" "-falign-loops=1" "-fconserve-stack" "-fmerge-constants" "-fno-code-hoisting" "-fno-schedule-insns" "-fno-var-tracking-assignments" "-fsched-pressure"
       "-mhard-float" "-mindirect-branch-register" "-mindirect-branch=thunk-inline" "-mpreferred-stack-boundary=2" "-mpreferred-stack-boundary=3" "-mpreferred-stack-boundary=4" "-mrecord-mcount" "-mindirect-branch=thunk-extern" "-mno-fp-ret-in-387" "-mskip-rax-setup"
       "--param=allow-store-data-races=0" "-Wa arch/x86/kernel/macros.s" "-Wa -"]
      :extraArgs ["--gcc-toolchain=/usr"]
      :pathMappings ,+ccls-path-mappings)
     :completion
     (:include
      (:blacklist
       ["^/usr/(local/)?include/c\\+\\+/[0-9\\.]+/(bits|tr1|tr2|profile|ext|debug)/"
        "^/usr/(local/)?include/c\\+\\+/v1/"
        ]))
     :index (:initialBlacklist ,+ccls-initial-blacklist :trackDependency 1)))

  (add-to-list 'projectile-globally-ignored-directories ".ccls-cache")

  (evil-set-initial-state 'ccls-tree-mode 'emacs)
  (set-company-backend! '(c-mode c++-mode cuda-mode objc-mode) 'company-lsp)
  )


(def-package! cpp-auto-include
  :load-path "/home/firstlove/dev/emacs-cpp-auto-include")
