(define (fibo x)
  (cond
  [(= x 0 )  1]
  [(= x 1)  1]
  [else (+
          (fibo (- x 1))
          (fibo (- x 2))
          )]
)
)
