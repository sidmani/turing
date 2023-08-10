alphabet [A, B, 1, 0, X, C, D]
blank 0
halt H
halt H2
init Q0

# NOTE: this Turing machine is reversible! you can prove this using the --check-rev flag
# it reverses a sequence, but replaces A -> C and B -> D

state Q0 {
    A: Q1_A X R
    B: Q1_B X R
    C: H C -
    D: H D -
}

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

state Q2_A {
    A: Q3_A C L
    B: Q3_B C L
    X: H2 C -
}

state Q2_B {
    A: Q3_A D L
    B: Q3_B D L
    X: H2 D -
}

state Q3_A {
    A: Q3_A A L
    B: Q3_A B L
    X: Q0 C R
}

state Q3_B {
    A: Q3_B A L
    B: Q3_B B L
    X: Q0 D R
}