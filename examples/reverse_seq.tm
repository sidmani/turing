# reverse a sequence in place

alphabet [A, B, C, D, 0]
blank 0
halt H
init Q0

# read the leftmost untouched symbol
state Q0 {
    A: Q1_A A R
    B: Q1_B B R
    C: Q5 C -
    D: Q5 D -
}

# move right to the last untouched symbol
state Q1_A {
    A: Q1_A A R
    B: Q1_A B R
    C: Q2_A C L
    D: Q2_A D L
    0: Q2_A 0 L
}

state Q1_B {
    A: Q1_B A R
    B: Q1_B B R
    C: Q2_B C L
    D: Q2_B D L
    0: Q2_B 0 L
}

# replace the rightmost symbol with the secondary symbol
# for the leftmost symbol we read earlier
state Q2_A {
    A: Q3_A C L 
    B: Q3_B C L
    C: Q5 C -
    D: Q5 D - 
}

state Q2_B {
    A: Q3_A D L
    B: Q3_B D L
    C: H C -
    D: H D - 
}

# move leftwards to the last untouched symbol
state Q3_A {
    A: Q3_A A L
    B: Q3_A B L
    C: Q4_A C R
    D: Q4_A D R
    0: Q4_A 0 R
}

state Q3_B {
    A: Q3_B A L
    B: Q3_B B L
    C: Q4_B C R
    D: Q4_B D R
    0: Q4_B 0 R
}

# replace that symbol and loop
state Q4_A {
    A: Q0 C R
    B: Q0 C R
    C: Q5 C -
    D: Q5 D - 
}

state Q4_B {
    A: Q0 D R
    B: Q0 D R
    C: Q5 C -
    D: Q5 D - 
}

# done reversing; go to leftmost index
state Q5 {
    C: Q5 C L
    D: Q5 D L
    0: Q6 0 R
}

# revert to A and B
state Q6 {
    C: Q6 A R
    D: Q6 B R
    0: H 0 L
}