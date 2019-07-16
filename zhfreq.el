;;; zhfreq.el --- handle chinese text by word frequency

;; Copyright (C) 2019 Chen Bin
;;
;; Version: 0.0.1
;; Keywords: convenience
;; Author: Chen Bin <Chen DOT Bin AT milestonegroup DOT com DOT au>
;; URL: http://github.com/usrname/zhfreq
;; Package-Requires: ((emacs "25.3"))

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; `zhfreq-format-pyim-dictionary' to format pyim dictionary.
;; `zhfreq-get-word-freq' get frequency of a  word.
;;; Code:

(require 'cl-lib)
(require 'zhfreq-words)

(defun zhfreq-read-file (file)
  "Read FILE content."
  (when file
    (with-temp-buffer
      (insert-file-contents (file-truename file))
      (buffer-string))))

(defun zhfreq-get-word-freq ()
  "Get frequency of a word."
  (interactive)
  (let* ((word (read-string "Input a word: "))
         freq)
    (when word
      (setq freq (gethash word zhfreq-word-lookup))
      (message "word=%s freq=%s" word freq))))

(defun zhfreq-compare-word-by-freq (a b)
  "Compare word A and B by freq."
  (> (or (gethash a zhfreq-word-lookup) 0)
     (or (gethash b zhfreq-word-lookup) 0)))

(defun zhfreq-format-pyim-dictionary ()
  "Format pyim dictionary."
  (interactive)
  (let* ((dict-file (read-file-name "Input pyim dictionary file: ")))
    (when dict-file
      (let* ((newfile (concat dict-file ".new")))
        (with-temp-buffer
          (dolist (l (split-string (zhfreq-read-file dict-file) "\n"))
            (cond
             ;; 只处理单字,2字词,3字词
             ((string-match "^\\([a-z]+ \\|[a-z]+-[a-z]+ \\|[a-z]+-[a-z]+-[a-z]+ \\)\\(.*\\)" l)
              (let* ((pinyin (match-string 1 l))
                     (words (cl-stable-sort (split-string (match-string 2 l) " ") #'zhfreq-compare-word-by-freq)))
                (insert (format "%s\n" (concat pinyin (mapconcat 'identity words " "))))))
             ;; 其他词
             ((string= l "")
              ;; skip empty line
              )
             (t
              (insert (format "%s\n" l)))))
          (write-file newfile))
        (message "%s created." newfile)))))

(provide 'zhfreq)
;;; zhfreq.el ends here