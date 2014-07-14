(setq scroll-step            1
      scroll-conservatively  10000)

;; "yes or no"を"y or n"に
(fset 'yes-or-no-p 'y-or-n-p)

;; Turn of alarms
(setq ring-bell-function 'ignore)

;; buffer-nameをuniqueで識別しやすくなるよう設定する
;; http://d.hatena.ne.jp/sugyan/20100515/1273909863
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; enable visual feedback on selections
(setq transient-mark-mode nil)

;; 読み込み専用のテキストをキルしてもエラーを出さないようにする
(setq kill-read-only-ok t)

;; kill-ringとgnomeのクリップボードを同期する
(cond (window-system
       (setq x-select-enable-clipboard t)))

;; Mac のクリップボードと同期
(defun copy-from-osx ()
  (shell-command-to-string "reattach-to-user-namespace -l sh -c pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "reattach-to-user-namespace" "-l" "sh" "-c" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(when (eq 'darwin system-type)
  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx))

;; kill-ring内部をUniqueにする
(defadvice kill-new (before ys:no-kill-new-duplicates activate)
  (setq kill-ring (delete (ad-get-arg 0) kill-ring)))

;; スクリプト保存時、自動的にchmod +x
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; スクリプト保存時、自動的に行末の空白を削除する。
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; 括弧をハイライト
(show-paren-mode t)

;; タブを使わずに空白で
(setq-default indent-tabs-mode nil)

;; auto-revert
(global-auto-revert-mode t)

;; highlight line
(global-hl-line-mode 0)

;; make text-mode default
(setq default-major-mode 'text-mode)

;; create parent directory before save if it doesn't exist.
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                  (make-directory dir t))))))

;; backup file を作成しない
(setq backup-inhibited t)
;;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)
;;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)

(set-default-coding-systems 'utf-8)

(require 'whitespace)
;; see whitespace.el for more details
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
        (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
(setq whitespace-space-regexp "\\(\u3000+\\)")
(set-face-foreground 'whitespace-tab "#adff2f")
(set-face-background 'whitespace-tab 'nil)
(set-face-underline  'whitespace-tab t)
(set-face-foreground 'whitespace-space "#7cfc00")
(set-face-background 'whitespace-space 'nil)
(set-face-bold-p 'whitespace-space t)
(global-whitespace-mode 1)

;; Add /usr/local/bin to exec-path
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;; the current day and date are displayed as well.
;; %Y: year
;; %m: month
;; %d: day
;; %a: weekday
;; %T: time
(setq display-time-format "[%T]")
(setq display-time-day-and-date t)
(display-time)

;; occur
(defun occur-current-word ()
  (interactive)
  (occur (current-word)))

;; grep
;; https://twitter.com/#!/higepon/status/201804128425480193
(require 'grep)
(grep-apply-setting 'grep-find-command "~/bin/ack --nocolor --nogroup ")

;;;;;;;;;;;
;; dired ;;
;;;;;;;;;;;
(require 'wdired)
(add-hook 'dired-mode-hook
          '(lambda ()
             (define-key dired-mode-map [tab] 'dired-hide-subdir)
             (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
             (define-key dired-mode-map "q" 'kill-buffer)
             (define-key dired-mode-map "p" 'dired-up-directory)
             (define-key dired-mode-map "n" 'dired-advertised-find-file)
             (define-key dired-mode-map "o" 'dired-open-file)))

(defun dired-open-command ()
  (cond ((eq system-type 'darwin) "open")
        ((eq system-type 'gnu/linux) "xdg-open")))

(defun dired-open-file ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (message "Opening %s..." file)
    (call-process (dired-open-command) nil 0 nil file)
    (message "Opening %s done" file)))

;;;;;;;;;;;;;
;; keybind ;;
;;;;;;;;;;;;;
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key (kbd "M-h") 'help)
(defalias 'o 'occur)
(defalias 'fg 'find-grep)

(add-hook 'html-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode t)
            (add-to-list 'auto-mode-alist '("\\.tpl$" . html-mode))))

(require 'php-mode nil t)

(require 'coffee-mode nil t)

;;;;;;;;;;;;;;;;;;;;;
;; auto-mode-alist ;;
;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.tpl$" . html-mode))

;;;;;;;;;;;;;;;;
;; package.el ;;
;;;;;;;;;;;;;;;;
(when (require 'package nil t)
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
  (package-initialize))
