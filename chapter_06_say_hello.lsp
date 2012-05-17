; Newlisp implementation of say-hello function
; (Land of Lisp, Chapter 6)
; Barry Arthur, Feb 17 2012

; LoL Common Lisp version in comments

;(defun say-hello ()
;  (print "Please type your name:")
;  (let ((name (read)))
;    (print "Nice to meet you, ")
;    (print name)))

(define (say-hello)
  (print "Please type your name: ")
  (let (name (read-line))
    (print "Nice to meet you, ")
    (println name)))

; no need to put your name in "quotes" as LoL suggests CL needs

(say-hello)
