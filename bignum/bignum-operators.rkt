#lang racket/base
(provide digit-add
         digit-sub
         digit-mult
         digit-quo
         digit-rem
         digit-=
         digit-zero?)
;; This file provides the built-in arithmetic procedures required
;; to implement limited precision arithmetic with bignums.

;; Input: two natural numbers between 0 and 99, a and b
;; Output: the sum of the a and b, or an error if
;;         a, b or their sum is outside the range [0,99]
(define digit-add (lambda (a b)
  (if (and (integer? a)
           (integer? b)
           (<= 0 a)
           (<= a 99)
           (<= 0 b)
           (<= b 99)
           (<= (+ a b) 99))
      (+ a b)
      (error 'digit-add "inputs or output out of range. tried (+ ~a ~a)" a b))))
;;
;; Input: two natural numbers between 0 and 99, a and b
;; Output: the result of subtractig b from a, or an error if
;;         a or b or their difference is outside the range [0,99]
(define digit-sub (lambda (a b)
  (if (and (integer? a)
           (integer? b)
           (<= 0 a)
           (<= a 99)
           (<= 0 b)
           (<= b 99)
           (>= (- a b) 0))
      (- a b)
      (error 'digit-sub
             "inputs or output out of range. tried (- ~a ~a)" a b))))

;; Input: two natural numbers between 0 and 99, a and b
;; Output: the product of the inputs, or an error if
;;         a or b or their product is outside the range [0,99]
(define digit-mult (lambda (a b)
  (if (and (integer? a)
           (integer? b)
           (<= 0 a)
           (<= a 99)
           (<= 0 b)
           (<= b 99)
           (<= (* a b) 99))
      (* a b)
      (error 'digit-mult "inputs or output out of range. tried (* ~a ~a)" a b))))

;; Input: two natural numbers between 0 and 99, a and b
;; Output: the quotient of dividend a and divisor b, or an error if
;;         a or b or their quotient is outside the range [0,99]
(define digit-quo (lambda (a b)
  (if (and (integer? a)
           (integer? b)
           (<= 0 a)
           (<= a 99)
           (<= 0 b)
           (<= b 99))
      (quotient a b)
      (error 'digit-quo
             "inputs or output out of range. tried (quotient ~a ~a)" a b))))

;; Input: two natural numbers between 0 and 99, a and b
;; Output: the remainder of dividend a and divisor b, or an error if
;;         a or b or the remainder is outside the range [0,99]
(define digit-rem (lambda (a b)
  (if (and (integer? a)
           (integer? b)
           (<= 0 a)
           (<= a 99)
           (<= 0 b)
           (<= b 99))
      (remainder a b)
      (error 'digit-rem
             "inputs or output out of range. tried (remainder ~a ~a)" a b))))


;; Input: two digits (i.e., natural numbers between 0 and 9), a and b
;; Output: true if a and b are equal; false if they differ,  or an error if
;;         a or b is not a digit. 
(define digit-= (lambda (a b)
  (if (and (integer? a)
           (integer? b)
           (<= 0 a)
           (<= a 9)
           (<= 0 b)
           (<= b 9))
      (= a b)
      (error 'digit-= "some input is not a digit tried (digit-= ~a ~a) " a b))))

;; Input: one digits (i.e., q natural numbers between 0 and 9), b
;; Output: true if b is 0; false if it's not,  or an error if
;;         b is not a digit. 
(define digit-zero? (lambda (b)
  (if (and (integer? b)
           (<= 0 b)
           (<= b 9))
      (zero? b)
      (error 'digit-zero? "the is not a digit tried (digit-= ~a) " b))))