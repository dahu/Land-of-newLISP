; Newlisp implementation of my-length function
; (Land of Lisp, Chapter 4)
; Barry Arthur, Feb 15 2012

; LoL Common Lisp version in comments

; (defun my-length (list)
;   (if list
;     (1+ (my-length (cdr list)))
;     0))

(define (my-length lst)
  (if lst (inc (my-length (rest lst))) 0))

(my-length '(list with four symbols))
