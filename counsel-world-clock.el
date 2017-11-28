;;; counsel-world-clock.el --- Display world clock using Ivy.

;; Author: Kuang Chen <http://github.com/kchenphy>
;; URL: https://github.com/kchenphy/counsel-world-clock
;; Version: 0.1
;; Package-Requires: ((ivy "0.9.0"))

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Make it easy to check local time in various time zones.

;;; Code:
(require 'ivy)

(defvar counsel-world-clock-time-format "%B %d, %A, %H:%M (GMT%z)"
  "Time format for ‘counsel-world-clock’.")

(defun counsel-world-clock--all-time-zones ()
  "Generate the list of all time zones."
  (split-string
   (shell-command-to-string
    "grep -v \"^#\" /usr/share/zoneinfo/zone.tab | cut -f3")))

(defun counsel-world-clock--local-time (time-zone)
  "Get current local time in a given time zone.
Argument TIME-ZONE input time zone."
  (format-time-string
   counsel-world-clock-time-format
   (current-time)
   time-zone))

(defun counsel-world-clock--format-candidate (time-zone)
  "Decorate a time zone into an ivy candidate.
ARGUMENT TIME-ZONE input time zone."
  (format "%-40s%s" time-zone (counsel-world-clock--local-time time-zone)))

(defun counsel-world-clock--format-function (cands)
  "Customize ivy interface, by appending local time directly to the time zone.
Argument CANDS candidates."
  (ivy--format-function-generic
   (lambda (time-zone)
     (ivy--add-face
      (counsel-world-clock--format-candidate
       time-zone)
      'ivy-current-match))
   'counsel-world-clock--format-candidate
   cands
   "\n"))

(defun counsel-world-clock ()
  "Display time in different time zone in echo area."
  (interactive)
  (let ((ivy-format-function #'counsel-world-clock--format-function))
    (ivy-read
     "Time zone: "
     (counsel-world-clock--all-time-zones)
     :action (lambda (time-zone)
	       (message
		"Local time in %s is %s"
		time-zone
		(counsel-world-clock--local-time time-zone))))))

(provide 'counsel-world-clock)
;;; counsel-world-clock.el ends here
