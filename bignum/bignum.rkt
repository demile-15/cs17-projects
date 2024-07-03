;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname bignum) (read-case-sensitive #t) (teachpacks ((lib "cs17.ss" "installed-teachpacks"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "cs17.ss" "installed-teachpacks")) #f)))
(require "bignum-operators.rkt")
;; BIGNUM+
;; Data Definitions:
;;    digit
;;    a num that's one of 0, 1, 2, ..., 9
;;
;;    bignum
;;    a digit list representation of a natural number, which is either
;;         empty
;;         (cons d bn)
;;    where d is a digit and bn is a bignum,
;;    and in which, if the digit list is not empty, the last digit is NOT a zero
;;
;; Example Data:
;;    digit: 9, 0, 4
;;    bignum: (cons 1 (cons 2 empty)), (cons 2 empty), empty

;; bignum+: bignum * bignum -> bignum
;; helper: bignum * bignum * digit -> bignum

;; I/O for bignum+ procedure
;; input: bn1, a bignum
;;        bn2, another bignum
;; output: a bignum that is the sum of bn1 and bn2

;; I/O for helper procedure
;; input: bn1, a bignum
;;        bn2, another bignum
;;        carry, a digit
;; output: a bignum that is the sum of bn1 and bn2

;; RECURSION DIAGRAMS for helper procedure
;; OI: (list 6 7) empty 0
;;   RI: (list 7) empty 0
;;   RO: (list 7)
;;     Ideation: cons 6 to RO?
;; OO: (list 6 7)

;; OI: empty empty 0
;;   RI: n/a
;;   RO: n/a
;;     Ideation: n/a
;; OO: empty

;; OI: (list 6 7) (list 7 4) 0
;;   RI: (list 7) (list 4) 1 ; carry is the tens-place of
;;                             the sum of (first bn1) (first bn2) 
;;   RO: (list 2 1)
;;     Ideation: cons the ones-place of the sum of (first bn1) (first bn2) to RO
;; OO: (list 3 2 1)

;; OI: (list 1 2) (list 6 4) 0
;;   RI: (list 2) (list 4) 0
;;   RO: (list 6)
;;     Ideation: cons the ones-place of the sum of (first bn1) (first bn2) to RO
;; OO: (list 7 6)

(define (helper bn1 bn2 carry)
  (cond
    [(and (empty? bn1) (empty? bn2))
     (if (> carry 0) (cons carry empty) empty)]
    [(and (empty? bn1) (cons? bn2)) 
     (cons (if (> (digit-add (first bn2) carry) 9)
               (digit-sub (digit-add (first bn2) carry) 10)
               (digit-add (first bn2) carry))
           (helper empty (rest bn2)
                   (if (> (digit-add (first bn2) carry) 9) 1 0)))]
    [(and (cons? bn1) (empty? bn2)) (helper bn2 bn1 carry)]
    [(and (cons? bn1) (cons? bn2))
     (cons (if (> (digit-add (digit-add (first bn1) (first bn2)) carry) 9)
               (digit-sub (digit-add (digit-add (first bn1)
                                                (first bn2)) carry) 10)
               (digit-add (digit-add (first bn1) (first bn2)) carry))
           (helper (rest bn1) (rest bn2) (if (> (digit-add
                           (digit-add (first bn1)
                                      (first bn2)) carry) 9) 1 0)))]))


(define (bignum+ bn1 bn2)
  (helper bn1 bn2 0))

;; Test cases for helper
(check-expect (helper (list 6 7) empty 0) (list 6 7))
(check-expect (helper empty empty 0) empty)
(check-expect (helper empty (list 9) 0) (list 9))
(check-expect (helper (list 6 7) (list 8 9 1) 0) (list 4 7 2))
(check-expect (helper (list 6 2) (list 1 4 3) 0) (list 7 6 3))


;; Test cases for bignum+
(check-expect (bignum+ empty empty) empty)
(check-expect (bignum+ (list 0 7 1) (list 3 9)) (list 3 6 2))
(check-expect (bignum+ (list 9 8) empty) (list 9 8))
(check-expect (bignum+ (list 9) (list 7)) (list 6 1))
(check-expect (bignum+ (list 9 5 2) (list 7 5)) (list 6 1 3))
(check-expect (bignum+ (list 1 2) (list 3 5)) (list 4 7))
(check-expect (bignum+ (list 9 9 9 9) (list 1)) (list 0 0 0 0 1))
(check-expect (bignum+ (list 9 9) (list 1)) (list 0 0 1))
(check-expect (bignum+ (list 9) (list 1)) (list 0 1))
(check-expect (bignum+ (list 9 9 9 9 9) (list 1)) (list 0 0 0 0 0 1))

;; BIGNUM*
;; Data Definitions:
;;    digit
;;    a num that's one of 0, 1, 2, ..., 9
;;
;;    bignum
;;    a digit list representation of a natural number, which is either
;;         empty
;;         (cons d bn)
;;    where d is a digit and bn is a bignum,
;;    and in which, if the digit list is not empty, the last digit is NOT a zero
;;
;; Example Data:
;;    digit: 9, 0, 4
;;    bignum: (cons 1 (cons 2 empty)), (cons 2 empty), empty
;;
;; bignum*: bignum * bignum -> bignum
;; mul-ten: bignum -> bignum
;; s-mult: bignum * num * num -> bignum

;; I/O for bignum*
;; Input: bn1, a bignum
;;        bn2, another bignum
;; Output: a bignum that is the product of bn1 and bn2

;; I/O for mul-ten
;; Input: bn, a bignum representing some natural number N
;; Output: a bignum that represent 10n

;; I/O for s-mult
;; Input: bn, a bignum
;;        num, a number
;;        carry2, a number
;; Output: a bignum that is the product of bn and num, in which
;;         carry2 is the carry-over

;; RECURSION DIAGRAMS for s-mult
;; OI: (list 3 2) 2 0
;;   RI: (list 2) 2 0
;;   RO: (list 4)
;;     Ideation: cons the ones-place of the product of
;;              (first bn1) (first bn2) to RO
;; OO: (list 6 4)

;; OI: (list 6 7) 7 0
;;   RI: (list 7) 7 4 ; carry is the tens-place of
;;                             the product of (first bn1) num 
;;   RO: (list 5 3) ; add carry to the product of (first bn1) num
;;     Ideation: cons the ones-place of the product of
;;              (first bn1) num to RO
;; OO: (list 2 5 3)

;; OI: empty 7 0
;;   RI: n/a
;;   RO: n/a
;;     Ideation: n/a
;; OO: empty

(define (mul-ten bn)
  (cond
    [(empty? bn) empty]
    [(cons? bn) (cons 0 bn)]))

(define (s-mult bn num carry2)
  (cond
    [(empty? bn) (if (digit-zero? carry2) empty (cons carry2 empty))]
    [(cons? bn)
     (if (digit-zero? num)
         empty
         (cons
          (digit-rem (digit-add (digit-mult (first bn) num) carry2) 10)
          (s-mult
           (rest bn)
           num
           (digit-quo (digit-add (digit-mult (first bn) num) carry2) 10))))]))

(define (bignum* bn1 bn2)
  (cond
    [(or (empty? bn1) (empty? bn2)) empty]
    [(and (cons? bn1) (cons? bn2))
     (bignum+ (s-mult bn1 (first bn2) 0)
              (mul-ten (bignum* bn1 (rest bn2))))]))

;; Test cases for mul-ten
(check-expect (mul-ten (cons 7 (cons 1 empty))) ; represents N = 17
              (cons 0 (cons 7 (cons 1 empty)))) ; represents 10N = 170
(check-expect (mul-ten (cons 2 (cons 3 (cons 9 empty)))) ; represents N = 932
              (cons 0 (cons 2 (cons 3 (cons 9 empty))))) ; represents 10N = 9320
(check-expect (mul-ten empty) ; represents N = 0 
              empty) ; represents 10N = 0

;; Test cases for s-mult      
(check-expect (s-mult (list 3 2) 2 0) (list 6 4))
(check-expect (s-mult (list 9 8) 2 0) (list 8 7 1))
(check-expect (s-mult (list 3 2 5) 3 0) (list 9 6 5 1))
(check-expect (s-mult (list 6 7 9 2) 9 0) (list 4 8 7 6 2))
(check-expect (s-mult (list 9 0 1) 9 0) (list 1 8 9))
(check-expect (s-mult empty 3 0) empty) ; base case 1
(check-expect (s-mult empty 3 5) (list 5)) ; base case 2


;; Test cases for bignum*
(check-expect (bignum* (list 8) (list 6)) (list 8 4))
(check-expect (bignum* (list 2) (list 3)) (list 6))
(check-expect (bignum* (list 7 8) (list 9 3)) (list 3 9 3 3))
(check-expect (bignum* (list 9 0 1) (list 9 2)) (list 1 6 1 3))
(check-expect (bignum* (list 5 7 8) (list 9 6)) (list 5 7 3 0 6))
(check-expect (bignum* (list 9 9) (list 9)) (list 1 9 8))
(check-expect (bignum* (list 9) (list 9 9 9)) (list 1 9 9 8))
(check-expect (bignum* (list 9 9) (list 9 9 9)) (list 1 0 9 8 9))
(check-expect (bignum* (list 9 9 9 9) (list 9 9 9)) (list 1 0 0 9 8 9 9))
(check-expect (bignum* (list 9 9 9) empty) empty)
(check-expect (bignum* empty (list 9 9 9)) empty)
(check-expect (bignum* empty empty) empty)