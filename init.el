;;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)
   
    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

;; Now you can use leaf!
(leaf leaf-tree :ensure t)
(leaf leaf-convert :ensure t)
(leaf transient-dwim
  :ensure t
  :bind (("M-=" . transient-dwim-dispatch)))

(leaf evil
  :doc "https://fnwiya.hatenablog.com/entry/2016/01/12/213149"
  :ensure t
  :config   (setq evil-cross-lines t)           ;行の端でhlしたとき前/次の行に移動する
  (setq evil-want-C-i-jump nil)       ;C-iはTABとして使う
  (setq evil-search-module 'isearch)
  :config (evil-mode 1)
  :config (evil-set-initial-state 'org-mode 'emacs)
  ;; :config (setq evil-normal-state-cursor '(box "purple"))
  ;; :config (setq evil-emacs-state-cursor '(box "green"))
  :config   (setq evil-want-fine-undo t)     ;操作を元に戻す単位を細かくする
  (setq evil-move-cursor-back nil) ;改行文字の上に移動可能にする(C-x C-e用)
  (setq evil-esc-delay 0)
  :config
  (defalias 'evil-insert-state 'evil-emacs-state)
  (define-key evil-emacs-state-map (kbd "<escape>") 'evil-normal-state)

  )
(leaf evil-matchit
  :ensure t
  :config (global-evil-matchit-mode 1))
(leaf evil-leader
  :ensure t
  :config
  ;; evil leader
  (setq evil-leader/in-all-states 1)
  (global-evil-leader-mode)
  (evil-leader/set-leader "SPC")
  (evil-leader/set-key
    "SPC" 'execute-extended-command
    ":" 'shell-command
    ;; "a" 'avy-goto-word-0
    "b" 'counsel-ibuffer
    "B" 'byte-compile-file
    "C" (lambda() (interactive)(find-file "~/.emacs.d/init.el"))
    "d" 'kill-this-buffer
    ;; "f" 'projectile-find-file
    "f" 'counsel-find-file
    "g" 'magit-status
    "h" 'lsp-describe-thing-at-point
    "j" 'dired-jump
    "k" 'kill-buffer
    "m" 'magit-status
    "q" 'kill-buffer-and-window
    "r" 'helm-recentf
    "s" 'eshell
    "S" 'shell
    "t" 'neotree-toggle
    "T" 'treemacs
    "w" 'save-buffer
    ;; "q" 'save-buffer-kill-terminal
    "^" (lambda () (interactive)
          (show-org-buffer)
          (evil-normal-state))
    ";" 'comment-line
    "x" 'toggle-transparency
    "0" 'delete-window
    "1" 'delete-other-windows
    "2" 'split-window-below
    "3" 'split-window-right
    "9" 'create-scratch-buffer
    ))

(leaf magit
  :ensure t
  )
(leaf which-key
  :ensure t
  :config (which-key-mode)
  :config (setq which-key-idle-delay 1000)
  )
;; You can also configure builtin package via leaf!
(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :custom ((truncate-lines . t)
           (menu-bar-mode . nil)
           (tool-bar-mode . nil)
           (scroll-bar-mode . nil)
           (indent-tabs-mode . nil)
           )
  :config
  (defun create-scratch-buffer
      nil "create scratch buffer"
      (interactive)
      (switch-to-buffer (get-buffer-create "*scratch*"))
      (text-mode))  
  (add-to-list 'exec-path (expand-file-name "~/.cargo.bin"))
  (set-language-environment "UTF-8")
  (global-set-key (kbd "C-c t") 'display-line-numbers-mode)
  ;; emacs の起動画面を消す
  ;; https://pcvogel.sarakura.net/2013/06/17/31151
  (setq inhibit-startup-message t)
  (setq initial-scratch-message nil)
  ;;カーソルの点滅を消す
  (blink-cursor-mode 0)
  ;;括弧の自動補完
  (electric-pair-mode 1)

  (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'org-mode-hook 'display-line-numbers-mode)
  ;; *scratch* buffer をテキストモードで開く
  (setq initial-major-mode 'text-mode)
  ;; scratch buffer をorg-modeで作成するmy-scratch-buffer
  ;; https://emacs.stackexchange.com/questions/16492/is-it-possible-to-create-an-org-mode-scratch-buffer
  ;; lawlistさん作
  (defun my-scratch-buffer ()
    "Create a new scratch buffer -- \*hello-world\*"
    (interactive)
    (let ((n 0)
          bufname buffer)
      (catch 'done
        (while t
          (setq bufname (concat "*my-scratch-org-mode"
                                (if (= n 0) "" (int-to-string n))
                                "*"))
          (setq n (1+ n))
          (when (not (get-buffer bufname))
            (setq buffer (get-buffer-create bufname))
            (with-current-buffer buffer
              (org-mode))
            ;; When called non-interactively, the `t` targets the other window (if it exists).
            (throw 'done (display-buffer buffer t))) ))))
  ;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
  (setq ring-bell-function 'ignore)
  )
(leaf org-journal
  :ensure t
  :config
  (setq org-journal-dir "~/org/journal")
  (setq work-directory "~/org/")
  (setq memofile (concat work-directory "memo.org"))
  (setq todofile (concat work-directory "TODO.org"))
  (setq org-agenda-files `(,todofile ))
  (setq org-capture-templates
        '(
          ("m" "メモ" entry (file+headline memofile "memo")
           "** %?\n*** 参考\n\nEntered on %U\n %i\n %a\n")

	  ("p" "プログラミングノート" entry (file+headline  memofile "Programming note")
	   "** %? \n\n*** カテゴリ\n\n*** 内容\n\n\nEntered on %U\n %i\n %a\n")

	  ("c" "チェックボックス" checkitem (file+headline   todofile "checkbox")
	   "[ ] %? %U\n")
	  ("t" "TODO" entry (file+headline todofile "ToDo")
           "*** TODO [/] %?\n- [ ] \nCAPTURED_AT: %U\n %i\n")

	  ("r" "調査内容" entry (file+headline memofile "Reserch")
	   "** %?\nEntered on %U\n %i\n %a\n")

	  ("S" "学習内容" entry (file+headline memofile "Study")
	   "** %?\nEntered on %U\n %i\n %a\n")

	  ("w" "単語帳" item (file+headline memofile "words")
	   "- %?\nEntered on %U\n %i\n %a\n")

	  ("W" "単語帳（複数語）" entry (file+headline memofile "words")
	   "** %?\n - \nEntered on %U\n %i\n %a\n")


          ("l" "記録" entry (file+headline memofile "Log")
           "** %?\nEntered on %U\n %i\n %a\n")

          ("s" "文章" entry (file+headline memofile "文章")
           "** %?\nEntered on %U\n %i\n %a\n")

	  ("i" "アイデア" entry (file+headline memofile "アイデア")
           "* %?\nEntered on %U\n %i\n %a\n")


	  ("b" "経済" entry (file+headline memofile "Business")
           "** %?\nEntered on %U\n %i\n %a\n")

          ("P" "Project" entry (file+headline memofile "Project")
           "** %?\nEntered on %U\n %i\n")))
  
  (global-set-key (kbd "C-c C-j") 'org-journal-new-entry)
  ;; https://www.mhatta.org/wp/2018/08/16/org-mode-101-1/
  (defun show-org-buffer ()
    "Show an org-file FILE on the current buffer."
    (interactive)
    (let ((file "memo.org"))
      (if (get-buffer file)
          (let ((buffer (get-buffer file)))
            (switch-to-buffer buffer)
            (message "%s" file))
        (find-file (concat work-directory file)))
      )
    )
  )

;; org-capture
;; キーバインドの設定
(global-set-key (kbd "C-c c") 'org-capture)

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 0.1))
  :global-minor-mode global-auto-revert-mode)

;; Nest package configurations
(leaf flycheck
  :doc "On-the-fly syntax checking"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :custom ((flycheck-emacs-lisp-initialize-packages . t))
  :hook (emacs-lisp-mode-hook lisp-interaction-mode-hook)
  :config
  (leaf flycheck-package
    :doc "A Flycheck checker for elisp package authors"
    :ensure t
    :config
    (flycheck-package-setup))

  (leaf flycheck-elsa
    :doc "Flycheck for Elsa."
    :emacs>= 25
    :ensure t
    :config
    (flycheck-elsa-setup))

  ;; ...
  )
(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t))

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)
  
(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)
(leaf treemacs
  :ensure t
  :config
  (leaf treemacs-evil :after (treemacs evil) :ensure t)
  (leaf treemacs-magit :after (treemacs magit) :ensure t)
  ;; (setq treemacs-git-mode 'deferred)
  (setq treemacs-git-mode 'simple)
  )
(leaf neotree :ensure t)

;; (leaf avy
;;   :ensure t)

(leaf yasnippet
  :ensure t
  :config
  (leaf yasnippet-snippets :ensure t)
  (yas-reload-all)
  (add-hook 'prog-mode-hook #'yas-minor-mode))

(leaf rustic
  :ensure t)

;; (leaf rust-mode
;;   :ensure t
;;   )

;; (leaf cargo
;;   :ensure t
;;   :config (add-hook 'rust-mode-hook 'cargo-minor-mode)
;;   )
(leaf web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
  )

(leaf emmet-mode
  :ensure t
  :leaf-defer t
  :commands (emmet-mode)
  :hook
  (web-mode-hook . emmet-mode))


(leaf lsp-mode
  :ensure t
  :init (yas-global-mode)
  :config
  (add-hook 'web-mode-hook #'lsp)
  )

;; (leaf setup-straight
;;   :config
;;   (defvar bootstrap-version)
;;   (let ((bootstrap-file
;;          (expand-file-name
;;           "straight/repos/straight.el/bootstrap.el"
;;           (or (bound-and-true-p straight-base-dir)
;;               user-emacs-directory)))
;;         (bootstrap-version 7))
;;     (unless (file-exists-p bootstrap-file)
;;       (with-current-buffer
;;           (url-retrieve-synchronously
;;            "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
;;            'silent 'inhibit-cookies)
;;         (goto-char (point-max))
;;         (eval-print-last-sexp)))
;;     (load bootstrap-file nil 'nomessage)))

;; (leaf lsp-ui :ensure t)
;; (leaf copilot
;;   :doc "https://zenn.dev/lecto/articles/dad1d04c0605a1" "https://www.irfanhabib.com/2022-04-26-setting-up-github-copilot-in-emacs/"
;;   :el-get (copilot
;;            :type github
;;            :pkgname "zerolfx/copilot.el"
;;            )
;;   :config
;;   (leaf jsonrpc :ensure t)
;;   (leaf editorconfig
;;     :ensure t
;;     )
;;   (leaf s
;;     :ensure t
;;     )
;;   (leaf dash
;;     :ensure t
;;     )
;;   (customize-set-variable 'copilot-enable-predicates '(evil-insert-state-p))
;;   (add-hook 'prog-mode-hook 'copilot-mode)
;;   (defun my/copilot-tab ()
;;     (interactive)
;;     (or (copilot-accept-completion)
;;         (indent-for-tab-command)))

;;   (with-eval-after-load 'copilot
;;     (define-key copilot-mode-map (kbd "<tab>") #'my/copilot-tab))
;;   )

;; ;; ↑package setting end

(leaf my-utility
  :doc "https://emacs.stackexchange.com/questions/22663/how-can-transparency-be-toggled"
  :config
  (defun toggle-transparency ()
    (interactive)
    (let ((alpha (frame-parameter nil 'alpha)))
      (if (eq
           (if (numberp alpha)
               alpha
             (cdr alpha)) ; may also be nil
           100)
          (set-frame-parameter nil 'alpha '(85 . 50))
        (set-frame-parameter nil 'alpha '(100 . 100))))
    )
  (defun counter-other-window ()
    (interactive)
    (other-window -1))
  (global-set-key (kbd "C-;") 'other-window)
  (global-set-key (kbd "C-:") 'counter-other-window)
  (defface my-evil-state-emacs-face
    '((t (:background "Green" :foreground "Blue")))
    "Evil Mode Emacs State Face")

  (defface my-evil-state-insert-face
    '((t (:background "DodgerBlue1" :foreground "White")))
    "Evil Mode Insert State Face")

  (defface my-evil-state-normal-face
    '((t (:background "Purple" :foreground "White")))
    "Evil Mode Normal Stace Face")

  (defface my-evil-state-visual-face
    '((t (:background "Orange" :foreground "White")))
    "Evil Mode Normal Stace Face")

  ;; Override defun from evil-core.el
  (defun evil-generate-mode-line-tag (&optional state)
    "Generate the evil mode-line tag for STATE."
    (let ((tag (evil-state-property state :tag t)))
      ;; prepare mode-line: add tooltip
      (when (functionp tag)
        (setq tag (funcall tag)))
      (if (stringp tag)
          (propertize tag
	              'face (cond
		             ((string= "normal" state)
		              'my-evil-state-normal-face)
		             ((string= "insert" state)
		              'my-evil-state-insert-face)
		             ((string= "visual" state)
		              'my-evil-state-visual-face)
		             ((string= "emacs" state)
		              'my-evil-state-emacs-face))
	              'help-echo (evil-state-property state :name)
	              'mouse-face 'mode-line-highlight)
        tag)))
  )
;; ...
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-revert-interval 0.1)
 '(counsel-find-file-ignore-regexp "\\(?:\\.\\(?:\\.?/\\)\\)")
 '(counsel-yank-pop-separator "
----------
")
 '(custom-enabled-themes '(deeper-blue))
 '(flycheck-emacs-lisp-initialize-packages t)
 '(indent-tabs-mode nil)
 '(ivy-initial-inputs-alist nil)
 '(ivy-prescient-retain-classic-highlighting t)
 '(ivy-use-selectable-prompt t)
 '(menu-bar-mode nil)
 '(package-archives
   '(("org" . "https://orgmode.org/elpa/")
     ("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")))
 '(package-selected-packages
   '(lsp-mode flycheck-elsa flycheck-package flycheck transient-dwim leaf-convert leaf-tree blackout el-get hydra leaf-keywords leaf))
 '(prescient-aggressive-file-save t)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
