(define (odd sequence)
  (cond 
  	(
  	  (null? sequence) '()
  	)
  	(
  	  (= 0 (modulo (car sequence) 2)) (odd (cdr sequence))
  	)
  	(else 
  		(cons (car sequence) (odd (cdr sequence)))
  	)
   
  )
)