; Newlisp implementation of add-five function
; (Land of Lisp, Chapter 6)
; Barry Arthur, Feb 17 2012

; LoL Common Lisp version in comments

; (defun add-five ()
;   (print "please enter a number:")
;   (let ((num (read)))
;     (print "When I add five I get")
;     (print (+ num 5))))

(define (add-five)
  (print "please enter a number: ")
  (let (num (read-line))
    (print "When I add five I get: ")
    (println (+ (int num) 5))))

(add-five)
