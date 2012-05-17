; Newlisp implementation of game-repl function
; (Land of Lisp, Chapter 6)
; Barry Arthur, Feb 17 2012

; LoL Common Lisp version in comments

; (defun game-repl ()
;   (let ((cmd (game-read)))
;     (unless (eq (car cmd) 'quit)
;       (game-print (game-eval cmd))
;       (game-repl))))

(define (game-repl)
  (let (cmd (game-read))
    (unless (= (first cmd) 'quit)
      (game-print (game-eval cmd))
      (game-repl))))

; (defun game-read ()
;   (let ((cmd (read-from-string
;                (concatenate 'string "(" (read-line) ")"))))
;     (flet ((quote-it (x)
;                      (list 'quote x)))
;       (cons (car cmd) (mapcar #'quote-it (cdr cmd))))))

(define (game-read)
  (let (cmd (map sym (parse (read-line) {\s+} 0)))
    (flat (list (first cmd) (map quote (rest cmd))))))

; (defparameter *allowed-commands* '(look walk pickup inventory))
;
; (defun game-eval (sexp)
;   (if (member (car sexp) *allowed-commands*)
;     (eval sexp)
;     '(i do not know that command.)))

(setf allowed-commands '(look walk pickup inventory))

(define (game-eval sexp)
  (if (member (first sexp) allowed-commands)
    (eval sexp)
    '(I do not know that command.)))

;(defun tweak-text (lst caps lit)
;  (when lst
;    (let ((item (car lst))
;          (rest (cdr lst)))
;      (cond ((eq item #\space) (cons item (tweak-text rest caps lit)))
;            ((member item '(#\! #\? #\.)) (cons item (tweak-text rest t lit)))

;            ((eq item #\") (tweak-text rest caps (not lit)))
;            (lit (cons item (tweak-text rest nil lit)))
;            ((or caps lit) (cons (char-upcase item) (tweak-text rest nil lit)))
;            (t (cons (char-downcase item) (tweak-text rest nil nil)))))))

;(defun game-print (lst)
;  (princ (coerce (tweak-text (coerce (string-trim "() "
;                                                  (prin1-to-string lst))
;                                     'list)
;                             t
;                             nil)
;                 'string))
;  (fresh-line))

(define (game-print lst)
  (println (join (map string lst) " ")))

