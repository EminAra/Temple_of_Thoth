(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
      (accumulate op initial (cdr sequence))
    )
  )
)

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

(define empty-board '())

(define (enumerate-interval low high)
  (if (> low high) '()
      (cons low (enumerate-interval (+ low 1) high))
  )
)

(define (adjoin-position new-row k rest-of-queens)
  (append rest-of-queens (list (cons new-row k)))
)

(define (safe? k positions)
  (let ((kth (filter
              (lambda (position) (= k (cdr position))) positions)
  )) kth)

  (define (equate kth position)
    (cond 
      (
        (or 
          (> kth (car position))  ; the rows
          (< 0 (car position))
          (> kth (cdr position))  ; the column
        )

        #t
      )

      (
        (and
        (not (= (car position) (car kth)))
        (not (= (cdr position) (cdr kth)))
        )

        (equate kth (cons (+ 1 (car position)) (cdr position)))
        (equate kth (cons (- 1 (car position)) (cdr position)))
      )

      (
        else #f
      )
    )
  )

  (filter (lambda (position)
    (and
      (not (eq? (car position) (car kth)))
      (equate kth position)
    )))
  )

(define (queens board-size)
  (define (queen-cols k)  ; returns a sequence of all possible solutions on the first k cols
    (if (= k 0)
      (list empty-board)
      (filter
        (lambda (positions) (safe? k positions)) ;predicate to filter
        (flatmap                                 ;sequence to to filter 
            (lambda (rest-of-queens)  ; procedure to flatmap
              (map (lambda (new-row)
                    (adjoin-position new-row k rest-of-queens))
                  (enumerate-interval 1 board-size) ; the rows
              )
            )
            (queen-cols (- k 1))  ; sequence to flatmap
          )
      )
    ))
  (queen-cols board-size)
)

(queens 3)


