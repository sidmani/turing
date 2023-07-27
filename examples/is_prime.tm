alphabet [A, B, 1, X, 0, NOT_PRIME, PRIME]
blank 0
halt H
init Q0

# write "2" in unary on the right side of B and move back to B
state Q0 {
    A: Q0 A R
    1: Q0 1 R
    B: Q1 B R
}

state Q1 {
    0: Q2 1 R
}

state Q2 {
    0: Q3 1 -
}

state Q3 {
    1: Q3 1 L
    B: Q14 B L
}

# move right until we get to the first 1 right of B
# when 0 is reached, the test number has been exhausted
state Q5 {
    B: Q5 B R
    X: Q5 X R
    1: Q6 X L
    0: Q7 0 L
}

# mark off the first 1 from the target number and repeat
# if A is reached, then the target number is exhausted
# and we need to reset and increment the test number
state Q6 {
    B: Q6 B L
    X: Q6 X L
    1: Q5 X R
    A: Q11 A R
}

# check if there are any 1s remaining; if not, the number divides perfectly
state Q7 {
    X: Q7 X L
    B: Q7 B L
    A: H NOT_PRIME -
    1: Q8 1 R
}

# go right to B
state Q8 {
    X: Q8 X R
    B: Q9 B R
}

# reset the test number
state Q9 {
    X: Q9 1 R
    0: Q10 0 L
}

# loop back to marking off the test number
state Q10 {
    1: Q10 1 L
    B: Q5 B R
}

# reset everything and increment the test number
state Q11 {
    X: Q11 1 R
    B: Q11 B R
    1: Q11 1 R
    0: Q12 1 -
}

# return to B and check if the numbers are equal
# move left to B
state Q12 {
    1: Q12 1 L
    B: Q14 B L
}

# if we reach 0, reset everything and go back to Q5
state Q13 {
    1: Q14 X L
    X: Q13 X R
    B: Q13 B R
    0: Q15 0 L
}

state Q14 {
    X: Q14 X L
    B: Q14 B L
    1: Q13 X R
    A: H PRIME -
}

# starting from all the way on the right, reset all Xs to 1s
state Q15 {
    X: Q15 1 L
    B: Q15 B L
    1: Q16 1 R
    A: Q16 A R
}

state Q16 {
    1: Q16 1 R
    B: Q5 B R
}



