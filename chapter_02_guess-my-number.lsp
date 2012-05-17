; Newlisp implementation of guess-my-number function
; (Land of Lisp, Chapter 2)
; Barry Arthur, Feb 15 2012

; LoL Common Lisp version in comments

; (defun guess-my-number ()
;   (ash (+ *small* *big*) -1))

(define (guess-my-number)
  (>> (+ small big)))

; (defun smaller ()
;   (setf *big* (1- (guess-my-number)))
;   (guess-my-number))

(define (smaller)
  (setf big (dec (guess-my-number)))
  (guess-my-number))

; (defun bigger ()
;   (setf *small* (1+ (guess-my-number)))
;   (guess-my-number))

(define (bigger)
  (setf small (inc (guess-my-number)))
  (guess-my-number))

; (defun start-over ()
;   (defparameter *small* 1)
;   (defparameter *big* 100)
;   (guess-my-number))

(define (start-over)
  (setf small 1)
  (setf big 100)
  (guess-my-number))

