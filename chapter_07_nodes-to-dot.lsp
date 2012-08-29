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


; (defun edges->dot (edges)
;   (mapc (lambda (node)
;          (mapc (lambda (edge)
;                 (fresh-line)
;                 (princ (dot-name (car node)))
;                 (princ "->")
;                 (princ (dot-name (car edge)))
;                 (princ "[label=\"")
;                 (princ (dot-label (cdr edge)))
;                 (princ "\"];"))
;           (cdr node)))
;    edges))

(define (edges->dot edges)
  (map (fn (node)
        (map (fn (edge)
              (println)
              (print (dot-name (first node)))
              (print " -> ")
              (print (dot-name (first edge)))
              (print "[label=\"")
              (print (dot-label (rest edge)))
              (print "\"];"))
         (rest node)))
   edges)
   (println))

; (defun graph->dot (nodes edges)
;  (princ "digraph{")
;  (nodes->dot nodes)
;  (edges->dot edges)
;  (princ "}"))

(define (graph->dot nodes edges)
  (print "digraph{")
  (nodes->dot nodes)
  (edges->dot edges)
  (print "}"))


; (defun dot->png (fname thunk)
;  (with-open-file (*standard-output*
;                   fname
;                   :direction :output
;                   :if-exists :supersede)
;   (funcall thunk))
;  (ext:shell (concatenate 'string "dot -Tpng -O " fname)))

(define (dot->png fname thunk)
  (device (open fname "write"))
  (thunk)
  (close (device))
  (! (string "dot -Tpng -O " fname)))


; (defun graph->png (fname nodes edges)
;  (dot->png fname
;   (lambda ()
;    (graph->dot nodes edges))))

(define (graph->png fname nodes edges)
  (dot->png fname (fn () (graph->dot nodes edges))))


; (defun uedges->dot (edges)
;   (maplist (lambda (lst)
;             (mapc (lambda (edge)
;                    (unless (assoc (car edge) (cdr lst))
;                     (fresh-line)
;                     (princ (dot-name (caar lst)))
;                     (princ "--")
;                     (princ (dot-name (car edge)))
;                     (princ "[label=\"")
;                     (princ (dot-label (cdr edge)))
;                     (princ "\"];")))
;              (cdar lst)))
;    edges))

(define (uedges->dot edges , seen node e)
 (dolist (lst edges)
  (setf node (first lst))
  (map (fn (edge)
        (setf e (first edge))
        (unless (find (list e node) seen)
         (println)
         (print (dot-name node))
         (print " -- ")
         (print (dot-name e))
         (print "[label=\"")
         (print (dot-label (rest edge)))
         (print "\"];"))
        (push (list node e) seen))
   (rest lst))))


; (defun ugraph->dot (nodes edges)
;   (princ "graph{")
;   (nodes->dot nodes)
;   (uedges->dot edges)
;   (princ "}"))

(define (ugraph->dot nodes edges)
  (println "graph{")
  (nodes->dot nodes)
  (uedges->dot edges)
  (println "}"))


; (defun ugraph->png (fname nodes edges)
;   (dot->png fname
;    (lambda ()
;     (ugraph->dot nodes edges))))

(define (ugraph->png fname nodes edges)
  (dot->png fname (fn () (ugraph->dot nodes edges))))


