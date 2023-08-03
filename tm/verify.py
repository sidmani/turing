def verify_fwd_det(tm):
    all_states = set(tm.halting_states)
    for state in tm.states:
        if state.name in all_states:
            raise Exception(
                f"TM is nondeterministic; state {state.name} appears multiple times"
            )
        all_states.add(state.name)

        init_chars = set()
        for rule in state.rules:
            if rule.init_char in init_chars:
                raise Exception(
                    f"TM is nondeterministic at rule {rule} in state {state.name}"
                )
            init_chars.add(rule.init_char)


def verify_alphabet(tm):
    for state in tm.states:
        for rule in state.rules:
            if rule.init_char not in tm.alphabet:
                raise Exception(
                    f"Token '{rule.init_char}' not in alphabet at rule {rule}"
                )
            if rule.final_char not in tm.alphabet:
                raise Exception(
                    f"Token '{rule.final_char}' not in alphabet at rule {rule}"
                )
    
    if tm.blank not in tm.alphabet:
        raise Exception(
            f"Token '{tm.blank}' (blank) not in alphabet"
        )


def verify_states(tm):
    all_states = set(map(lambda s: s.name, tm.states)) | set(tm.halting_states)
    for state in tm.states:
        for rule in state.rules:
            if rule.final_state not in all_states:
                raise Exception(f"Unknown state '{rule.final_state}' at rule {rule}")
    
    if tm.init not in all_states:
        raise Exception(f"Unknown initial state '{tm.init}'")


def verify_reversible(tm):
    all_states = set(map(lambda s: s.name, tm.states)) | set(tm.halting_states)
    for state_name in all_states:
        # find all rules that lead to this state
        previous_rules = []
        for previous_state in tm.states:
            for rule in previous_state.rules:
                if rule.final_state == state_name:
                    previous_rules.append(rule)
        
        direction = None
        terminal_syms = set()
        for rule in previous_rules:
            if rule.final_char in terminal_syms:
                raise Exception(f"Repeated final symbol {rule.final_char} in rule {rule} when entering state {state_name}")
            
            terminal_syms.add(rule.final_char)

            if direction is None:
                direction = rule.dir
                continue

            if direction != rule.dir:
                raise Exception(f"Incoming rule {rule} to state {state_name} has non-matching direction")
        
