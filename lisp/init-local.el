(require 'autoinsert)
(require 'use-package)
(use-package autoinsert
  :init
  ;; Don't want to be prompted before insertion:
  (setq auto-insert-query nil)

  (setq auto-insert-directory (locate-user-emacs-file "templates"))
  (add-hook 'find-file-hook 'auto-insert)
  (auto-insert-mode 1)

  :config
  (define-auto-insert "\\.cpp?$" "default.cpp"))

(global-set-key (kbd "<f8>") 'smart-compile-and-run)
(global-set-key (kbd "<f9>") 'smart-compile)
(defun smart-compile-and-run()
  (interactive)
  ;; 查找 Makefile
  (let ((candidate-make-file-name '("makefile" "Makefile" "GNUmakefile"))
        (command nil))
    (if (not (null
              (find t candidate-make-file-name :key
                    '(lambda (f) (file-readable-p f)))))
        (setq command "make -k ")
      ;; 没有找到 Makefile ，查看当前 mode 是否是已知的可编译的模式
      (if (null (buffer-file-name (current-buffer)))
          (message "Buffer not attached to a file, won't compile!")
        (progn (if (eq system-type 'windows-nt)
                   (setq execute-prefix "")
                 (setq execute-prefix "./"))
               (if (eq major-mode 'c-mode)
                   (setq command
                         (concat "gcc -Wall -DQWERTIER -o "
                                 (file-name-sans-extension
                                  (file-name-nondirectory buffer-file-name))
                                 " "
                                 (file-name-nondirectory buffer-file-name)
                                 " -g -lm && "
                                 execute-prefix
                                 (file-name-sans-extension
                                  (file-name-nondirectory buffer-file-name))
                                 ))
                 (if (eq major-mode 'c++-mode)
                     (setq command
                           (concat "g++ -Wall -DQWERTIER -o "
                                   (file-name-sans-extension
                                    (file-name-nondirectory buffer-file-name))
                                   " "
                                   (file-name-nondirectory buffer-file-name)
                                   " -g -lm && "
                                   execute-prefix
                                   (file-name-sans-extension
                                    (file-name-nondirectory buffer-file-name))))
                   (message "Unknow mode, won't compile!"))))))
    (if (not (null command))
        (let ((command (read-from-minibuffer "Compile command: " command)))
          (compile command)))))
(defun smart-compile()
  (interactive)
  ;; 查找 Makefile
  (let ((candidate-make-file-name '("makefile" "Makefile" "GNUmakefile"))
        (command nil))
    (if (not (null
              (find t candidate-make-file-name :key
                    '(lambda (f) (file-readable-p f)))))
        (setq command "make -k ")
      ;; 没有找到 Makefile ，查看当前 mode 是否是已知的可编译的模式
      (if (null (buffer-file-name (current-buffer)))
          (message "Buffer not attached to a file, won't compile!")
        (if (eq major-mode 'c-mode)
            (setq command
                  (concat "gcc -Wall -DQWERTIER -o "
                          (file-name-sans-extension
                           (file-name-nondirectory buffer-file-name))
                          " "
                          (file-name-nondirectory buffer-file-name)
                          " -g -lm "))
          (if (eq major-mode 'c++-mode)
              (setq command
                    (concat "g++ -Wall -DQWERTIER -o "
                            (file-name-sans-extension
                             (file-name-nondirectory buffer-file-name))
                            " "
                            (file-name-nondirectory buffer-file-name)
                            " -g -lm "))
            (message "Unknow mode, won't compile!")))))
    (if (not (null command))
        (let ((command (read-from-minibuffer "Compile command: " command)))
          (compile command)))))
(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))

(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize) ;; You might already have this line

(provide 'init-local)
;;; init-local.el ends here
