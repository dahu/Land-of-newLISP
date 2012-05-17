; Newlisp implementation of nodes->dot function
; (Land of Lisp, Chapter 7)
; Barry Arthur, Feb 17 2012

; LoL Common Lisp version in comments

(setf nodes '((living-room (You are in the living room.
                            A wizard is snoring loudly on the couch.))
              (garden (You are in a beautiful garden.
                       There is a well in front of you.))
              (attic (You are in the attic.
                      There is a giant welding torch in the corner.))))

(setf edges '((living-room (garden west door)
                           (attic upstairs ladder))
              (garden (living-room east door))
              (attic (living-room downstairs ladder))))

; (defun dot-name (exp)
;   (substitute-if #\_ (complement #'alphanumericp) (prin1-to-string exp)))

# use built-in case-insensitive PCRE replacement
(define (dot-name thing) (replace {[^a-z0-9]} (string thing) {_} 1))

; (defparameter *max-label-length* 30)
;
; (defun dot-label (exp)
;   (if exp
;     (let ((s (write-to-string exp :pretty nil)))
;       (if (> (length s) *max-label-length*)
;         (concatenate 'string (subseq s 0 (- *max-label-length* 3)) "...")
;         s))
;     ""))

(setf max-label-length 30)

(define (dot-label thing)
  (if thing
    (let (s (string thing))
      (if (> (length s) max-label-length)
        (string (slice s 0 (- max-label-length 3)) "...")
        s))
    ""))

; (defun nodes->dot (nodes)
;   (mapc (lambda (node)
;           (fresh-line)
;           (princ (dot-name (car node)))
;           (princ "[label=\"")
;           (princ (dot-label node))
;           (princ "\"];"))
;         nodes))

(define (nodes->dot nodes)
  (map (fn (node)
           (println)
           (print (dot-name (first node)))
           (print "[label=\"")
           (print (dot-label node))
           (print "\"];"))
       nodes))
