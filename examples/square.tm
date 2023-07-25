alphabet [A, B, 1, 0, X, Y, Z]
blank 0
halting_state H
init Q0

state Q0 {
    A: Q0 A R
    X: Q0 X R
    Z: Q0 Z R
    1: Q1 X -
    Y: Q1 Z -
    B: Q3 B L
}

state Q1 {
    X: Q1 X L
    A: Q1 A L
    1: Q1 1 L
    Z: Q1 Z L
    0: Q2 1 R
}

state Q2 {
    1: Q2 1 R
    A: Q0 A -
}

state Q3 {
    Z: Q3 Y L
    X: Q5 Y L
}

state Q5 {
    X: Q4 X -
    A: H A -
}

state Q4 {
    X: Q4 1 L
    A: Q0 A -
}