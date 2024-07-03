- The sort of expression a user would type is a procedure-application-expression. For each procedure, the user should input two bignums. A bignum is a digit list representation of a natural number, which is either empty or (cons d bn), where d is a digit and bn is a bignum, and in which, if the digit list is not empty, the last digit is NOT a zero. Bignum+ then outputs a bignum that represents the sum of the two input bignums, while bignum* outputs a bignum that represents the product of the two input bignums. This is representative of a procedure-application-expression because the procedure would be applied to the two bignums that the user inputs, which outputs a procedure value that is a new bignum.

- Overview of procedures in the program

In bignum+, when the user provides the input, the helper function called "helper" is invoked to evaluate a value that is the representation of the sum of the two input bignums. That value is the value of the wrapper bignum+ function, and also the output needed.

In bignum*, when the user provides the input, the helper function "bignum+" is invoked to evaluate the sum of the partial product, which would be calculated by the helper function "s-mult", and the value that is evaluated by applying helper function "mul-ten" to the recursive input. The helper function "s-mult" evaluates to a value that is the representation of the product of the first bignum and the first digit of the second bignum. After that, "mul-ten" adds a "0" to the recursive input, and then "bignum+" adds them together. 

- A problem with our program is that it's not concise which makes it difficult to debug. We wrote unnecessary clauses for the cond expression.The runtime of the program is linear, but it still takes more time than it should to run.

- List of people in the project: Demi Le (B01904594) and Jasmine Kamara (B01903857).