alphabet [A, B, C, 1, 0, X]
blank X
halt H
init Q0

# go to the least-significant digit of N1 and copy it over
state Q0 {
    A: Q0 A R
    0: Q0 0 R
    1: Q0 1 R
    B: Q1 B L
    X: Q1 X L
}

state Q1 {
    A: L0 A L
    0: L0 X L
    1: Q2 X L
}

state L0 {
    0: L0 0 L
    1: L0 1 L
    A: L0 A L
    X: Q3 0 R
}

state Q2 {
    0: Q2 0 L
    1: Q2 1 L
    A: Q2 A L
    X: Q3 1 R
}

# go to LSD of N2
state Q3 {
    0: Q3 0 R
    1: Q3 1 R
    X: Q3 X R
    A: Q3 A R
    B: Q5 B R
}

state Q5 {
    0: Q5 0 R
    1: Q5 1 R
    C: Q6 C L
    X: Q6 X L
}

state Q6 {
    0: Q11 X -
    B: Q11 B -
    1: Q8 X L
}

state Q8 {
    0: Q8 0 L
    1: Q8 1 L
    X: Q8 X L
    B: Q8 B L
    A: Q9 A L
}

state Q9 {
    0: Q9 0 L
    1: Q9 1 L
    X: Q10 X R
}

state Q10 {
    0: Q11 1 R
    1: Q12 0 R
}

# deal with the carry
state Q11 {
    0: Q11 0 R
    1: Q11 1 R
    X: Q11 X R
    A: Q11 A R
    B: Q11 B R
    C: Q14 C R
}

state Q14 {
    X: Q15 0 L
    0: Q15 0 L
    1: Q16 0 L
}

state Q12 {
    0: Q12 0 R
    1: Q12 1 R
    X: Q12 X R
    A: Q12 A R
    B: Q12 B R
    C: Q13 C R
}

state Q13 {
    X: Q15 1 L
    0: Q15 1 L
    1: Q16 1 L
}

# check that there are still available digits
state Q15 {
    X: Q15 X L
    B: Q15 B L
    C: Q15 C L
    0: Q20 0 -
    1: Q20 1 -
    A: L2 A R
}

# go to C
state L2 {
    X: L2 X R
    B: L2 B R
    C: Q21 C R
}

# need to carry 1
state Q16 {
    C: Q16 C L
    0: Q16 0 L
    1: Q16 1 L
    B: Q16 B L
    X: Q16 X L
    A: L1 A L
}

state L1 {
    0: L1 0 L
    1: L1 1 L
    X: Q17 X R
}

# initiate the carry sequence again if necessary
# guaranteed not to loop, because this digit in the result is 1
# iff the carried digit is 0
state Q17 {
    0: Q18 1 R
    1: Q12 0 R
}

# check that there are remaining digits in at least one number
state Q18 {
    0: Q18 0 R
    1: Q18 1 R
    A: Q19 A R
}

state Q19 {
    X: Q19 X R
    B: Q19 B R
    0: Q20 0 -
    1: Q20 1 -
    C: Q21 C R
}

# carry the final digit if necessary
state Q21 {
    0: H X -
    1: Q22 X L
}

state Q22 {
    X: Q22 X L
    B: Q22 B L
    C: Q22 C L
    A: Q23 A L
}

state Q23 {
    0: Q23 0 L
    1: Q23 1 L
    X: H 1 -
}

# go back to A and loop
state Q20 {
    X: Q20 X L
    0: Q20 0 L
    1: Q20 1 L
    B: Q20 B L
    A: Q0 A -
}