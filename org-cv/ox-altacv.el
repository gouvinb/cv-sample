;;; ox-altacv.el --- LaTeX altacv Back-End for Org Export Engine -*- lexical-binding: t; -*-

;; Copyright (C) 2018 Free Software Foundation, Inc.

;; Author: Oscar Najera <hi AT oscarnajera.com DOT com>
;; Maintener: gouvinb <brunogouvinhas@gmail.com>
;; Keywords: org, wp, tex

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; This library implements a LaTeX altacv back-end, derived from the
;; LaTeX one.

;;; Code:
(require 'cl-lib)
(require 'ox-latex)

;; Install a default set-up for altacv export.
(unless (assoc "altacv" org-latex-classes)
  (add-to-list 'org-latex-classes
	           '("altacv"
		         "\\documentclass{altacv}"
		         ("\\section{%s}" . "\\cvsection{%s}")
		         ("\\subsection{%s}" . "\\cvsubsection{%s}")
		         ("\\subsubsection{%s}" . "\\cvsubsubsection{%s}"))))

(defun org-cv-utils-org-timestamp-to-shortdate (date_str)
  "Format orgmode timestamp DATE_STR  into a short form date.
Other strings are just returned unmodified
e.g. <2002-08-12 Mon> => Aug 2012
today => today"
  (if (string-match (org-re-timestamp 'active) date_str)
      (let* ((abbreviate 't)
             (dte (org-parse-time-string date_str))
             (month (nth 4 dte))
             (year (nth 5 dte))) ;;'(02 07 2015)))
        (concat
         (calendar-month-name month abbreviate) " " (number-to-string year)))
    date_str))

(defun org-cv-utils--format-time-window (from-date to-date)
  "Join date strings in a time window.
FROM-DATE -- TO-DATE
in case TO-DATE is nil return Present"
  (concat
   (org-cv-utils-org-timestamp-to-shortdate from-date)
   " -- "
   (if (not to-date) "Present"
     (org-cv-utils-org-timestamp-to-shortdate to-date))))

(defun org-cv-utils--parse-cventry (headline info)
  "Return alist describing the entry.
INFO is a plist used
as a communication channel."
  (let ((title (org-export-data (org-element-property :title headline) info)))
    `((title . ,title)
      (from-date . ,(or (org-element-property :FROM headline)
                        (error "No FROM property provided for cventry %s" title)))
      (to-date . ,(org-element-property :TO headline))
      (employer . ,(org-element-property :EMPLOYER headline))
      (location . ,(or (org-element-property :LOCATION headline) "")))))

;;; User-Configurable Variables

(defgroup org-export-cv nil
  "Options specific for using the altacv class in LaTeX export."
  :tag "Org altacv"
  :group 'org-export
  :version "25.3")

;;; Define Back-End
(org-export-define-derived-backend
 'altacv 'latex
 :options-alist
 '((:latex-class "LATEX_CLASS" nil "altacv" t)
   (:cvstyle "CVSTYLE" nil "classic" t)
   (:cvcolor "CVCOLOR" nil "blue" t)
   (:mobile "MOBILE" nil nil parse)
   (:homepage "HOMEPAGE" nil nil parse)
   (:address "ADDRESS" nil nil newline)
   (:photo "PHOTO" nil nil parse)
   (:gitlab "GITLAB" nil nil parse)
   (:github "GITHUB" nil nil parse)
   (:linkedin "LINKEDIN" nil nil parse)
   (:with-email nil "email" t t)
   (:latex-title-command nil nil "\\begin{fullwidth}\n\\makecvheader\n\\end{fullwidth}")
   )
 :translate-alist
 '((template . org-altacv-template)
   (headline . org-altacv-headline)))

;;;; Template
;;
;; Template used is similar to the one used in `latex' back-end,
;; excepted for the table of contents and altacv themes.

(defun org-altacv-template (contents info)
  "Return complete document string after LaTeX conversion.
CONTENTS is the transcoded contents string.  INFO is a plist
holding export options."
  (let ((title (org-export-data (plist-get info :title) info))
        (spec (org-latex--format-spec info)))
    (concat
     ;; Time-stamp.
     (and (plist-get info :time-stamp-file)
          (format-time-string "%% Created %Y-%m-%d %a %H:%M\n"))
     ;; LaTeX compiler.
     (org-latex--insert-compiler info)
     ;; Document class and packages.
     (org-latex-make-preamble info)
     ;; Possibly limit depth for headline numbering.
     (let ((sec-num (plist-get info :section-numbers)))
       (when (integerp sec-num)
         (format "\\setcounter{secnumdepth}{%d}\n" sec-num)))

     ;; Title and subtitle.
     (let* ((subtitle (plist-get info :subtitle))
            (formatted-subtitle
             (when subtitle
               (format (plist-get info :latex-subtitle-format)
                       (org-export-data subtitle info))))
            (separate (plist-get info :latex-subtitle-separate)))
       (concat
        (format "\\tagline{%s%s}\n" title
                (if separate "" (or formatted-subtitle "")))
        (when (and separate subtitle)
          (concat formatted-subtitle "\n"))))
     ;; Hyperref options.
     (let ((template (plist-get info :latex-hyperref-template)))
       (and (stringp template)
            (format-spec template spec)))
     ;; Document start.
     "\\begin{document}\n\n"
     ;; Author.
     (let ((author (and (plist-get info :with-author)
                        (let ((auth (plist-get info :author)))
                          (and auth (org-export-data auth info))))))
       (format "\\name{%s}\n" author))
     ;; photo
     (let ((photo (org-export-data (plist-get info :photo) info)))
       (when (org-string-nw-p photo) (format "\\photo{2.8cm}{%s}\n" photo)))

     "\\personalinfo{\n"
     ;; address
     (let ((address (org-export-data (plist-get info :address) info)))
       (when (org-string-nw-p address)
         (format "\\mailaddress{%s}\n" (mapconcat (lambda (line)
                                                    (format "%s" line))
                                                  (split-string address "\n") " -- "))))
     ;; email
     (let ((email (and (plist-get info :with-email)
                       (org-export-data (plist-get info :email) info))))
       (when (org-string-nw-p email)
         (format "\\email{%s}\n" email)))
     ;; phone
     (let ((mobile (org-export-data (plist-get info :mobile) info)))
       (when (org-string-nw-p mobile)
         (format "\\phone{%s}\n" mobile)))
     ;; homepage
     (let ((homepage (org-export-data (plist-get info :homepage) info)))
       (when (org-string-nw-p homepage)
         (format "\\homepage{%s}\n" homepage)))
     (mapconcat (lambda (social-network)
                  (let ((command (org-export-data (plist-get info
                                                             (car social-network))
                                                  info)))
                    (and command (format "\\%s{%s}\n"
                                         (nth 1 social-network)
                                         command))))
                '((:github "github")
                  (:gitlab "gitlab")
                  (:linkedin "linkedin"))
                "")
     "}\n"
     ;; Title command.
     (let* ((title-command (plist-get info :latex-title-command))
            (command (and (stringp title-command)
                          (format-spec title-command spec))))
       (org-element-normalize-string
        (cond ((not (plist-get info :with-title)) nil)
              ((string= "" title) nil)
              ((not (stringp command)) nil)
              ((string-match "\\(?:[^%]\\|^\\)%s" command)
               (format command title))
              (t command))))
     ;; Document's body.
     contents
     ;; Creator.
     (and (plist-get info :with-creator)
          (concat (plist-get info :creator) "\n"))
     ;; Document end.
     "\\end{document}")))


(defun org-altacv--format-cventry (headline contents info)
  "Format HEADLINE as as cventry.
CONTENTS holds the contents of the headline.  INFO is a plist used
as a communication channel."
  (let* ((entry (org-cv-utils--parse-cventry headline info))
         (divider (if (org-export-last-sibling-p headline info) "\n" "\\divider")))
    (format "\n\\cvevent{%s}{%s}{%s}{%s}%s\n%s"
            (alist-get 'title entry)
            (alist-get 'employer entry)
            (org-cv-utils--format-time-window (alist-get 'from-date entry)
                                              (alist-get 'to-date entry))
            (alist-get 'location entry) contents divider)))

;;;; Headline
(defun org-altacv-headline (headline contents info)
  "Transcode HEADLINE element into altacv code.
CONTENTS is the contents of the headline.  INFO is a plist used
as a communication channel."
  (unless (org-element-property :footnote-section-p headline)
    (let ((environment (let ((env (org-element-property :CV_ENV headline)))
                         (or (org-string-nw-p env) "block"))))
      (cond
       ;; is a cv entry
       ((equal environment "cventry")
        (org-altacv--format-cventry headline contents info))
       ((org-export-with-backend 'latex headline contents info))))))

(provide 'ox-altacv)
;;; ox-altacv ends here
