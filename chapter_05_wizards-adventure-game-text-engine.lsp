; Newlisp implementation of Wizard's Adventure (text engine)
; (Land of Lisp, Chapter 5)
; Barry Arthur, Feb 15 2012

; LoL Common Lisp version in comments

; (defparameter *nodes* '((living-room (you are in the living-room.
;                                       a wizard is snoring loudly on the couch.))
;                         (garden (you are in a beautiful garden.
;                                  there is a well in front of you.))
;                         (attic (you are in the attic.
;                                 there is a giant welding torch in the corner.))))

(setf nodes '((living-room (You are in the living room.
                            A wizard is snoring loudly on the couch.))
              (garden (You are in a beautiful garden.
                       There is a well in front of you.))
              (attic (You are in the attic.
                      There is a giant welding torch in the corner.))))

; (defun describe-location (location nodes)
;   (cadr (assoc location nodes)))

(define (describe-location location nodes)
  ((assoc location nodes) 1))

; (defparameter *edges* '((living-room (garden west door)
                                      ;(attic upstairs ladder))
                         ;(garden (living-room east door))
                         ;(attic (living-room downstairs ladder))))

(setf edges '((living-room (garden west door)
                           (attic upstairs ladder))
              (garden (living-room east door))
              (attic (living-room downstairs ladder))))

; (defun describe-path (edge)
;   `(there is a ,(caddr edge) going ,(cadr edge) from here.))

(define (describe-path edge)
  (flat (list '(There is a ) (edge 2) '(going) (edge 1) '(from here.))))

; (defun describe-paths (location edges)
;   (apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))

(define (describe-paths location edges)
  (apply append (map describe-path (rest (assoc location edges)))))

; (defparameter *objects* '(whiskey bucket frog chain))

(setf objects '(whiskey bucket frog chain))

; (defparameter *object-locations* '((whiskey living-room)
;                                    (bucket living-room)
;                                    (chain garden)
;                                    (frog garden)))

(setf object-locations '((whiskey living-room)
                         (bucket living-room)
                         (chain garden)
                         (frog garden)))

; (defun objects-at (loc objs obj-locs)
;   (labels ((at-loc-p (obj)
;                      (eq (cadr (assoc obj obj-locs)) loc)))
;     (remove-if-not #'at-loc-p objs)))

# originally experimented with separate function before learning that newLISP
# supported local function declarations

;(define (at-location? object)
  ;(= ((assoc object object-locations) 1) location))

# using   let   works:
  ;(let (at-location? (fn (object)
                         ;(= ((assoc object object-locations) 1) location)))

# as does   setf

(define (objects-at location objects object-locations)
  (setf at-location? (fn (object)
                         (= ((assoc object object-locations) 1) location)))
    (filter at-location? objects))

; (defun describe-objects (loc objs obj-loc)
;   (labels ((describe-obj (obj)
;                `(you see a ,obj on the floor.)))
;     (apply #'append (mapcar #'describe-obj (objects-at loc objs obj-loc)))))

;(define (describe-object object)
  ;(flat (list '(You see a) object '(on the floor.))))

(define (describe-objects location objects object-locations)
  (setf describe-object (fn (object)
                            (flat (list '(You see a) object '(on the floor.)))))
  (apply append (map describe-object (objects-at location objects object-locations))))

; (defparameter *location* 'living-room)

(setf location 'living-room)

; (defun look ()
;   (append (describe-location location nodes)
;           (describe-paths location edges)
;           (describe-objects location objects object-locations)))

(define (look)
  (append (describe-location location nodes)
          (describe-paths location edges)
          (describe-objects location objects object-locations)))

; (defun walk (direction)
;   (let ((next (find direction
;                     (cdr (assoc *location* *edges*))
;                     :key #'cadr)))
;     (if next
;       (progn (setf *location* (car next))
;              (look))
;       '(you cannot go that way.))))

(define (walk direction)
  (println "Walking " direction)
  (if (find (list '? direction '?) (rest (assoc location edges)) match)
    (begin
        (setf location ($0 0))
        (look))
    '(You cannot go that way.)))

; (defun pickup (object)
;   (cond ((member object
;                  (objects-at *location* *objects* *object-locations*))
;          (push (list object 'body) *object-locations*)
;          `(you are now carrying the ,object))
;         (t '(you cannot get that.))))

(define (pickup object)
  (if (member object (objects-at location objects object-locations))
    (begin
      (push (list object 'body) object-locations)
      (flat (list '(you are now carrying the) object)))
    '(you cannot get that.)))

; (defun inventory ()
;   (cons 'items- (objects-at 'body *objects* *object-locations*)))

(define (inventory)
  (flat (list 'items- (objects-at 'body objects object-locations))))

