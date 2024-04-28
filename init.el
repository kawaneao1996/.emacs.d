;;;; <leaf-install-code>
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
    (leaf beacon
      :ensure t
      :config (beacon-mode 1) (setq beacon-color "green"))

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)

    (leaf evil
      :doc "https://fnwiya.hatenablog.com/entry/2016/01/12/213149"
      :ensure t
      :config   (setq evil-cross-lines t)           ;行の端でhlしたとき前/次の行に移動する
      (setq evil-want-C-i-jump nil)       ;C-iはTABとして使う
      (setq evil-search-module 'isearch)
      (evil-mode 1)
      (evil-set-initial-state 'prog-mode 'normal)
      (setq evil-default-state 'insert)
      (evil-set-initial-state 'text-mode 'insert)
      (evil-set-initial-state 'org-mode 'insert)
      ;; (setq evil-normal-state-cursor '(box "purple"))
      ;; (setq evil-emacs-state-cursor '(bar "green"))
      ;; (setq evil-insert-state-cursor '(bar "green"))
      (setq evil-want-fine-undo t)     ;操作を元に戻す単位を細かくする
      (setq evil-move-cursor-back nil) ;改行文字の上に移動可能にする(C-x C-e用)
      (setq evil-esc-delay 0)
      (defalias 'evil-insert-state 'evil-emacs-state)
      (define-key evil-emacs-state-map (kbd "<escape>") 'evil-normal-state)
      ;; evil-collection
      (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
      (setq evil-want-keybinding nil)
      )
    (leaf evil-collection
      :after evil
      :ensure t
      ;; :config
      ;; (evil-collection-init '(calendar dired eshell treemacs))
      )
    ;; (leaf skk
    ;;   :ensure ddskk
    ;;   :custom ((default-input-method . "japanese-skk"))
    ;;   :config
    ;;   (leaf ddskk-posframe
    ;;     :ensure t
    ;;     :global-minor-mode t))
    ;; (leaf skk-config
    ;; (add-hook 'evil-emacs-state-entry-hook 'skk-mode)
    ;; (add-hook 'evil-emacs-state-exit-hook 'skk-mode)
    ;; (add-hook 'magit-mode-hook (lambda () (skk-mode)))
    ;; )
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
        "TAB" (lambda() (interactive)(other-window 1))
        ;; "a" 'avy-goto-word-0
        "b" 'counsel-ibuffer
        "B" 'byte-compile-file
        "c c" #'svg-clock
        "c C" 'calendar
        "C" (lambda() (interactive)(find-file "~/.emacs.d/init.el"))
        "d" 'dired-jump
        ;; "f" 'projectile-find-file
        "f" 'counsel-find-file
        "g" 'magit-status
        "h" 'lsp-describe-thing-at-point
        "i" 'imenu-list
        ;; "j" 'skk-mode
        "k" 'kill-buffer
        ;; "l" '(lambda() (interactive)
        ;;        (set-face-foreground 'highlight-indent-guides-top-character-face "DarkOliveGreen")
        ;;        (set-face-foreground 'highlight-indent-guides-character-face "DarkSlateGray")
        ;;        )
        "L" 'toggle-truncate-lines
        "m" 'magit-status
        "q" 'kill-buffer-and-window
        "Q" (lambda () (interactive) (save-buffers-kill-emacs))
        "r" 'helm-recentf
        "s" 'eshell
        "S" 'shell
        "t" 'neotree-toggle
        "T" 'treemacs
        "w" 'save-buffer
        "W" 'resize-frame
        "y" 'yas-insert-snippet
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
      :config
      )
    (leaf which-key
      :ensure t
      :config (which-key-mode)
      :config (setq which-key-idle-delay 1000)
      )

    (leaf tree-sitter
      :ensure t
      :config
      ;; activate tree-sitter on any buffer containing code for which it has a parser available
      (global-tree-sitter-mode)
      ;; you can easily see the difference tree-sitter-hl-mode makes for python, ts or tsx
      ;; by switching on and off
      (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
    (leaf tree-sitter-langs
      :ensure t
      :after tree-sitter)
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
      )
    (leaf doom-themes :ensure t)
    (leaf zenburn-theme :ensure t)
    (leaf modus-themes :ensure t)
    (leaf highlight-indent-guides :ensure t
      :config
      (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
      (setq highlight-indent-guides-method 'character)
      ;; (setq highlight-indent-guides-responsive "stack")
      ;; (set-face-foreground 'highlight-indent-guides-top-character-face "DarkOliveGreen")
      ;; (set-face-foreground 'highlight-indent-guides-character-face "DarkSlateGray")
      )
    (leaf svg-clock :ensure t)
    (leaf markdown-mode :ensure t
      :mode ("\\.md\\'" . gfm-mode)
      :config
      (setopt markdown-command '("pandoc" "--from=markdown" "--to=html5"))
      (setopt markdown-fontify-code-blocks-natively t)
      (setopt markdown-header-scaling t)
      (setopt markdown-indent-on-enter 'indent-and-new-item)
      (leaf-key "<S-tab>" #'markdown-shifttab 'markdown-mode-map))
    (leaf resize-frame
      :config
      ;;; resize-frame.el --- A minor mode to resize frames easily.  -*- lexical-binding: t; -*-

      ;; Copyright (C) 2014  kuanyui

      ;; Author: kuanyui <azazabc123@gmail.com>
      ;; Keywords: frames, tools, convenience
      ;; License: WTFPL 1.0

        ;;; Commentary:

      ;; Press "ESC `" and use arrow-keys to adjust frames. press any key to done.

        ;;; Code:

      (defvar resize-frame-map
        (let ((map (make-keymap)))
          (define-key map (kbd "<up>") 'enlarge-window)
          (define-key map (kbd "<down>") 'shrink-window)
          (define-key map (kbd "<right>") 'enlarge-window-horizontally)
          (define-key map (kbd "<left>") 'shrink-window-horizontally)
          (set-char-table-range (nth 1 map) t 'resize-frame-done)
          (define-key map (kbd "C-p") 'enlarge-window)
          (define-key map (kbd "C-n") 'shrink-window)
          (define-key map (kbd "C-f") 'enlarge-window-horizontally)
          (define-key map (kbd "C-b") 'shrink-window-horizontally)
          map))

      (define-minor-mode resize-frame
        "A simple minor mode to resize-frame.
        C-c C-c to apply."
        ;; The initial value.
        :init-value nil
        ;; The indicator for the mode line.
        :lighter " ResizeFrame"
        ;; The minor mode bindings.
        :keymap resize-frame-map
        :global t
        (if (<= (length (window-list)) 1)
            (progn (setq resize-frame nil)
                   (message "Only root frame exists, abort."))
          (progn (evil-emacs-state 1)
                 (message "Use arrow-keys to adjust frames."))
          )
        )

      (defun resize-frame-done ()
        (interactive)
        (evil-emacs-state -1)
        (setq resize-frame nil)
        (message "Done."))

      ;; (global-set-key (kbd "ESC `") 'resize-frame)

      (provide 'resize-frame)
        ;;; resize-frame.el ends here
      )
    (leaf windresize :ensure t)
    (leaf sly :ensure t
      :config
      (when (eq system-type 'windows-nt)
        (setq sly-lisp-implementations
              '((sbcl ("C:\\Program Files\\Steel Bank Common Lisp\\sbcl.exe") :coding-system utf-8-unix))))
      (add-hook 'lisp-mode-hook #'sly))
    (leaf company
      :ensure t
      :init (add-hook 'prog-mode-hook 'company-mode)
      (add-hook 'sly-mrepl-mode-hook 'company-mode))
    ;; </leaf-install-code>
    )

  ;; Now you can use leaf!
  (leaf leaf-tree :ensure t)
  (leaf leaf-convert :ensure t)
  (leaf transient-dwim
    :ensure t
    :bind (("M-=" . transient-dwim-dispatch)))

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
    ;; shut up, emacs!
    ;; (setq default-input-method "japanese-skk")
    (setq display-warning-minimum-level :error)
    ;; カーソルを当てたときのtooltipの背景色を変更
    (set-face-background 'tooltip "black")
    ;; カーソルを当てたときのtooltipの前景色（文字色）を変更
    (set-face-foreground 'tooltip "white")
    )
  (defun create-scratch-buffer
      nil "create scratch buffer"
      (interactive)
      (switch-to-buffer (get-buffer-create "*scratch*"))
      (text-mode))
  (add-to-list 'exec-path (expand-file-name "~/.cargo.bin"))
  (set-language-environment "UTF-8")
  ;; (set-language-environment "Japanese")
  ;; (when (member system-type '(ms-dos windows-nt))
  ;; (setq-default default-process-coding-system '(utf-8-unix . japanese-cp932-dos)))
  ;; (global-set-key (kbd "C-c t") 'display-line-numbers-mode)
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
(leaf neotree
  :ensure t
  :config (setq neo-smart-open t))

;; (leaf avy
;;   :ensure t)

(leaf yasnippet
  :ensure t
  :config
  (leaf yasnippet-snippets :ensure t)
  (yas-global-mode)
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
  (add-hook 'web-mode-hook 'emmet-mode)
  )

(leaf emmet-mode
  :ensure t
  :leaf-defer t
  :commands (emmet-mode)
  )


(leaf lsp-mode
  :ensure t
  :init (yas-global-mode)
  :config
  (add-hook 'web-mode-hook #'lsp)
  )


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
 '(blink-cursor-mode nil)
 '(counsel-find-file-ignore-regexp "\\(?:\\.\\(?:\\.?/\\)\\)")
 '(counsel-yank-pop-separator "\12----------\12")
 '(custom-enabled-themes '(doom-xcode))
 '(custom-safe-themes
   '("6a5584ee8de384f2d8b1a1c30ed5b8af1d00adcbdcd70ba1967898c265878acf" "9f297216c88ca3f47e5f10f8bd884ab24ac5bc9d884f0f23589b0a46a608fe14" "c5878086e65614424a84ad5c758b07e9edcf4c513e08a1c5b1533f313d1b17f1" "a6920ee8b55c441ada9a19a44e9048be3bfb1338d06fc41bce3819ac22e4b5a1" "8d8207a39e18e2cc95ebddf62f841442d36fcba01a2a9451773d4ed30b632443" "a9abd706a4183711ffcca0d6da3808ec0f59be0e8336868669dc3b10381afb6f" "38c0c668d8ac3841cb9608522ca116067177c92feeabc6f002a27249976d7434" "4990532659bb6a285fee01ede3dfa1b1bdf302c5c3c8de9fad9b6bc63a9252f7" "02d422e5b99f54bd4516d4157060b874d14552fe613ea7047c4a5cfa1288cf4f" "4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d" "6e33d3dd48bc8ed38fd501e84067d3c74dfabbfc6d345a92e24f39473096da3f" "ffafb0e9f63935183713b204c11d22225008559fa62133a69848835f4f4a758c" "77fff78cc13a2ff41ad0a8ba2f09e8efd3c7e16be20725606c095f9a19c24d3d" "9013233028d9798f901e5e8efb31841c24c12444d3b6e92580080505d56fd392" "3fe1ebb870cc8a28e69763dde7b08c0f6b7e71cc310ffc3394622e5df6e4f0da" "f5f80dd6588e59cfc3ce2f11568ff8296717a938edd448a947f9823a4e282b66" "9d29a302302cce971d988eb51bd17c1d2be6cd68305710446f658958c0640f68" "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "c0fe7e641d584b8d38e4d1b91c916530022d51e80f301c4d2387da67cfe7cef8" "6b374f3c5f7bd457399af65bae738671205f4dbc54299817b8a94599dab386f6" "6e584e8baa6fce967dcaf6ca6b3b19c924b30d634c384e599956c8c73582a0d9" "56044c5a9cc45b6ec45c0eb28df100d3f0a576f18eef33ff8ff5d32bac2d9700" "4b6cc3b60871e2f4f9a026a5c86df27905fb1b0e96277ff18a76a39ca53b82e1" "e4a702e262c3e3501dfe25091621fe12cd63c7845221687e36a79e17cf3a67e0" "00cec71d41047ebabeb310a325c365d5bc4b7fab0a681a2a108d32fb161b4006" "34cf3305b35e3a8132a0b1bdf2c67623bc2cb05b125f8d7d26bd51fd16d547ec" "be84a2e5c70f991051d4aaf0f049fa11c172e5d784727e0b525565bb1533ec78" "8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "d6b934330450d9de1112cbb7617eaf929244d192c4ffb1b9e6b63ad574784aad" "ee29cabce91f27eb1f9540ceb2bb69b4c509cd5d3bb3e6d8ad3a4ab799ebf8f7" "2628939b8881388a9251b1bb71bc9dd7c6cffd5252104f9ef236ddfd8dbbf74a" "8746b94181ba961ebd07c7397339d6a7160ee29c75ca1734aa3744274cbe0370" "e2d32717818adc2d29062fc147bd263b6cd65fa6d02a0400045aec75acf20657" "a5ee4566c9ff5eed763681b0845fa3a164bc54561d216dc3a762f41f559c181f" "5bafdfa3e21f921abf9b9fd77e1e0ce032e62e3a6f8f13ec8ce7945727c654e9" "b5c3c59e2fff6877030996eadaa085a5645cc7597f8876e982eadc923f597aca" "faf956fa69deb44a905446d6f2df4ea123ce99fcfabb261338e7c73a1c3b2c27" "da75eceab6bea9298e04ce5b4b07349f8c02da305734f7c0c8c6af7b5eaa9738" "c1d5759fcb18b20fd95357dcd63ff90780283b14023422765d531330a3d3cec2" "4ade6b630ba8cbab10703b27fd05bb43aaf8a3e5ba8c2dc1ea4a2de5f8d45882" "8b148cf8154d34917dfc794b5d0fe65f21e9155977a36a5985f89c09a9669aa0" "f4d1b183465f2d29b7a2e9dbe87ccc20598e79738e5d29fc52ec8fb8c576fcfd" "691d671429fa6c6d73098fc6ff05d4a14a323ea0a18787daeb93fde0e48ab18b" "2b501400e19b1dd09d8b3708cefcb5227fda580754051a24e8abf3aff0601f87" "88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e" "9d5124bef86c2348d7d4774ca384ae7b6027ff7f6eb3c401378e298ce605f83a" "32f22d075269daabc5e661299ca9a08716aa8cda7e85310b9625c434041916af" "dccf4a8f1aaf5f24d2ab63af1aa75fd9d535c83377f8e26380162e888be0c6a9" "014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69" "18cf5d20a45ea1dff2e2ffd6fbcd15082f9aa9705011a3929e77129a971d1cb3" "81f53ee9ddd3f8559f94c127c9327d578e264c574cda7c6d9daddaec226f87bb" "a8354a5bb676d49a45ddf1289a53034cb34fda9193f412f314bdb91c82326ee9" "8d3ef5ff6273f2a552152c7febc40eabca26bae05bd12bc85062e2dc224cde9a" "2721b06afaf1769ef63f942bf3e977f208f517b187f2526f0e57c1bd4a000350" "7ec8fd456c0c117c99e3a3b16aaf09ed3fb91879f6601b1ea0eeaee9c6def5d9" "dfb1c8b5bfa040b042b4ef660d0aab48ef2e89ee719a1f24a4629a0c5ed769e8" "e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" default))
 '(flycheck-emacs-lisp-initialize-packages t)
 '(indent-tabs-mode nil)
 '(ivy-initial-inputs-alist nil)
 '(ivy-prescient-retain-classic-highlighting t)
 '(ivy-use-selectable-prompt t)
 '(package-archives
   '(("org" . "https://orgmode.org/elpa/")
     ("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")))
 '(package-selected-packages
   '(nano-theme quelpa-leaf lsp-mode flycheck-elsa flycheck-package flycheck transient-dwim leaf-convert leaf-tree blackout el-get hydra leaf-keywords leaf))
 '(prescient-aggressive-file-save t)
 '(scroll-bar-mode nil nil nil "Customized with leaf in `cus-start' block")
 '(tool-bar-mode nil nil nil "Customized with leaf in `cus-start' block")
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Cica" :foundry "outline" :slant normal :weight regular :height 120 :width normal)))))
