alphabet [1, A0, A1, B0, B1, C0, C1, D0, D1, 1X, 0]
blank 0
init Q0
halt H

# A0 <machine definition> A0 <tape>
# <machine definition> = <state>+
# <state> = B0 <rule>+
# <rule> = C0 left-symbol D0 right-symbol D0 new-state D0 direction
# <tape> = B0 <symbol>

# go to the active state
state Q0 {
    1: Q0 1 R
    A0: Q0 A0 R
    B0: Q0 B0 R
    B1: Q1 B1 R
    C0: Q0 C0 R
    D0: Q0 D0 R
}

# try matching the current symbol against the next rule
# mark the next rule as active
state Q1 {
    B0: H B0 -
    A0: H A0 -
    C0: Q2 C1 R
}

    # D0: (check that the marked symbol is done)
state Q2 {
    1: Q3 1X R
    1X: Q2 1X R
    D0: Q8 D0 R
}

state Q3 {
    1: Q3 1 R
    C0: Q3 C0 R
    D0: Q3 D0 R
    B0: Q3 B0 R
    A0: Q4 A0 R
}

state Q4 {
    B0: Q4 B0 R
    1: Q4 1 R
    B1: Q5 B1 R
}

# B0 -> symbol is wrong; try next rule
state Q5 {
    1X: Q5 1X R
    1: Q6 1X L
    B0: Q10 B0 L
    0: Q10 0 L
}

state Q6 {
    1X: Q6 1X L
    B1: Q6 B1 L
    B0: Q6 B0 L
    1: Q6 1 L
    A0: Q7 A0 L
}

state Q7 {
    B0: Q7 B0 L
    C0: Q7 C0 L
    D0: Q7 D0 L
    1: Q7 1 L
    1X: Q2 1X R
}


# the rule lhs symbol is done, so check that the marked symbol is done
state Q8 {
    1: Q8 1 R
    D0: Q8 D0 R
    C0: Q8 C0 R
    B0: Q8 B0 R
    B1: Q9 B1 R
    A0: Q8 A0 R
}

# 1 -> symbol is wrong; try next rule
# B0 -> symbol is correct; start rule execution
state Q9 {
    1X: Q9 1X R
    1: Q10 1 L
    B0: Q13 B0 L
    0: Q13 0 L
}

# symbol was wrong; try next rule
state Q10 {
    1: Q10 1 L
    1X: Q10 1 L
    B1: Q10 B1 L
    B0: Q10 B0 L
    A0: Q11 A0 L
}

state Q11 {
    1: Q11 1 L
    D0: Q11 D0 L
    C0: Q11 C0 L
    B0: Q11 B0 L
    1X: Q11 1 L
    C1: Q12 C0 R
}

state Q12 {
    1: Q12 1 R
    D0: Q12 D0 R
    C0: Q2 C1 R
}

# start rule execution
# reset the digits and go back to C1
state Q13 {
    1X: Q13 1 L
    B1: Q13 B1 L
    B0: Q13 B0 L
    1: Q13 1 L
    C0: Q13 C0 L
    D0: Q13 D0 L
    A0: Q13 A0 L
    C1: Q14 C1 R
}

# copy the new symbol over
state Q14 {
    1: Q14 1 R
    D0: Q15 D1 R
}

# D0 -> finished copying
state Q15 {
    1X: Q15 1X R
    1: Q16 1X R
    D0: Q19 D0 R
}

state Q16 {
    C0: Q16 C0 R
    B0: Q16 B0 R
    D0: Q16 D0 R
    A0: Q16 A0 R
    1: Q16 1 R
    B1: Q17 B1 R
}

# B0 -> need to make space on the tape
state Q17 {
    1X: Q17 1X R
    1: Q18 1X L
    B0: Q57 B0 -
}

# make space on the tape by shifting right

state Q56 {
    1: Q57 B0 R
}

state Q57 {
    1: Q57 1 R
    B0: Q56 1 R
    0: Q58 1 L
}

state Q58 {
    1: Q58 1 L
    B0: Q58 B0 L
    1X: Q17 1X R
}


state Q18 {
    B1: Q18 B1 L
    1: Q18 1 L
    B0: Q18 B0 L
    A0: Q54 A0 L
    1X: Q18 1X L
}

state Q54 {
    B0: Q54 B0 L
    D0: Q54 D0 L
    C0: Q54 C0 L
    1: Q54 1 L
    1X: Q15 1X R
}

# finished copying
# check if the tape needs to be left-shifted
state Q19 {
    1: Q19 1 R
    D0: Q19 D0 R
    C0: Q19 C0 R
    B0: Q19 B0 R
    A0: Q19 A0 R
    B1: Q20 B1 R
}

# 1 -> tape needs to be shifted left
state Q20 {
    1X: Q20 1X R
    1: Q22 1 R
    B0: Q21 B0 L
    0: Q21 0 L
}

# move the B0s left one step
state Q22 {
    1: Q22 1 R
    B0: Q23 1 L
    0: Q63 0 L
}

state Q23 {
    1: Q22 B0 R
}

# zero out the left-most 1
state Q63 {
    1: Q24 0 L
}

state Q24 {
    1: Q24 1 L
    1X: Q20 1X R
    B0: Q24 B0 L
}


# go back and reset the new symbol
state Q21 {
    B0: Q21 B0 L
    B1: Q21 B1 L
    1: Q21 1 L
    A0: Q21 A0 L
    C0: Q21 C0 L
    D0: Q21 D0 L
    1X: Q21 1 L
    D1: Q25 D0 R
}

# move the head to the new position
state Q25 {
    1: Q25 1 R
    D0: Q26 D0 R
}

state Q26 {
    1: Q26 1 R
    D0: Q27 D1 R
}

state Q27 {
    1: Q28 1 R
}

# wants left shift
state Q28 {
    1: Q29 1 R
    C0: Q30 C0 R
    B0: Q30 B0 R
}

state Q29 {
    1: Q36 1 L
    C0: Q31 C0 R
    B0: Q31 B0 R
}

# execute left shift
# go to the end
state Q30 {
    D0: Q30 D0 R
    C0: Q30 C0 R
    B0: Q30 B0 R
    A0: Q30 A0 R
    B1: Q34 B0 L
    1: Q30 1 R
}

# A0 -> need to insert a new cell
state Q34 {
    1: Q34 1 L
    B0: Q36 B1 L
    A0: Q37 A0 R
}

# insert a new cell
state Q37 {
    B0: Q37 B0 R
    1: Q37 1 R
    0: Q38 1 R
}

state Q38 {
    0: Q39 1 L
}

state Q39 {
    1: Q39 1 L
    B0: Q40 1 R
    A0: Q42 A0 R
}

state Q40 {
    1: Q41 1 R
}

state Q41 {
    1: Q39 B0 L
}

state Q42 {
    1: Q36 B1 L
}

# execute right shift
state Q31 {
    D0: Q31 D0 R
    C0: Q31 C0 R
    B0: Q31 B0 R
    A0: Q31 A0 R
    1: Q31 1 R
    B1: Q33 B0 R
}

state Q33 {
    B0: Q36 B1 L
    1: Q33 1 R
    0: Q35 B1 R
}

state Q35 {
    0: Q36 1 L
}

# shift complete; go back to D1
state Q36 {
    1: Q36 1 L
    B1: Q36 B1 L
    B0: Q36 B0 L
    A0: Q36 A0 L
    D0: Q36 D0 L
    C0: Q36 C0 L
    D1: Q43 D0 L
}

# update the state
state Q43 {
    1: Q43 1 L
    D0: Q51 D1 L
}

# find the current state and reset it, then go back to D1
state Q51 {
    1: Q51 1 L
    C0: Q51 C0 L
    C1: Q51 C0 L
    D0: Q51 D0 L
    B1: Q44 B0 R
}

state Q44 {
    1: Q44 1 R
    C0: Q44 C0 R
    D0: Q44 D0 R
    D1: Q55 D1 L
}

# mark the leftmost state so we know where to count from
state Q55 {
    C0: Q55 C0 L
    B0: Q55 B0 L
    D0: Q55 D0 L
    1: Q55 1 L
    A0: Q59 A0 R
}

state Q59 {
    B0: Q60 B1 R
}

state Q60 {
    B0: Q60 B0 R
    C0: Q60 C0 R
    D0: Q60 D0 R
    1: Q60 1 R
    D1: Q61 D1 R
}

state Q61 {
    1: Q45 1X R
}

# mark off 1s and B0s to count up to the new state
state Q45 {
    1: Q46 1X L
    1X: Q45 1X R
    D0: Q52 D0 L
}


# search for B1 on the left
state Q46 {
    1X: Q46 1X L
    1: Q46 1 L
    C0: Q46 C0 L
    B0: Q46 B0 L
    D0: Q46 D0 L
    D1: Q46 D1 L
    B1: Q47 B0 R
    A0: Q48 A0 R
}

state Q47 {
    1X: Q47 1X R
    1: Q47 1 R
    B0: Q49 B1 L
    D0: Q47 D0 R
    D1: Q47 D1 R
    C0: Q47 C0 R
}

# B1 not found on left; try right
state Q48 {
    1: Q48 1 R
    1X: Q48 1X R
    B0: Q48 B0 R
    D0: Q48 D0 R
    D1: Q48 D1 R
    C0: Q48 C0 R
    B1: Q62 B0 R
}

state Q62 {
    C0: Q62 C0 R
    D0: Q62 D0 R
    1: Q62 1 R
    B0: Q49 B1 L
}

# find D1 again
state Q49 {
    1X: Q49 1X L
    1: Q49 1 L
    C0: Q49 C0 L
    B0: Q49 B0 L
    D0: Q49 D0 L
    A0: Q50 A0 R   
    D1: Q45 D1 R
}

# D1 was not on the left; go right
state Q50 {
    C0: Q50 C0 R
    B0: Q50 B0 R
    D0: Q50 D0 R
    B1: Q50 B1 R
    1: Q50 1 R
    D1: Q45 D1 R
}

# state has been updated; reset the 1Xs and D1, then find B1 and loop all the way way back
state Q52 {
    1X: Q52 1 L
    D1: Q52 D0 L
    C0: Q52 C0 L
    B0: Q52 B0 L
    D0: Q52 D0 L
    1: Q52 1 L
    B1: Q1 B1 R
    A0: Q53 A0 R
}

state Q53 {
    1: Q53 1 R
    D0: Q53 D0 R
    C0: Q53 C0 R
    B0: Q53 B0 R
    B1: Q1 B1 R
}