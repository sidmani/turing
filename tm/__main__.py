from collections import namedtuple
import re
from lark import Lark
from lark import Transformer
import argparse

State = namedtuple("State", ["name", "rules"])
Rule = namedtuple("Rule", ["init_char", "final_state", "final_char", "dir"])
TM = namedtuple("TM", ["alphabet", "init", "blank", "states", "halting_states"])


class TMTransformer(Transformer):
    def start(self, data):
        states = []
        halting_states = []
        for d in data:
            if isinstance(d, State):
                states.append(d)
            elif d.data == "alphabet":
                alphabet = set(map(lambda x: x.value, d.children))
            elif d.data == "init":
                init = d.children[0].value
            elif d.data == "blank_symbol":
                blank = d.children[0].value
            elif d.data == "halt":
                halting_states.append(d.children[0].value)

        return TM(alphabet=alphabet, init=init, blank=blank, states=states, halting_states=halting_states)

    def state(self, data):
        return State(data[0].value, data[1:])

    def rule(self, data):
        return Rule(data[0].value, data[1].value, data[2].value, data[3].data)


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

def step(tm, state, tape, pos):
    if state in tm.halting_states:
        return None

    state = [x for x in tm.states if x.name == state][0]
    rules = state.rules
    char = tape[pos]
    try:
        rule = [x for x in rules if x.init_char == char][0]
    except Exception:
        raise Exception(f"Unhandled symbol {char} in state {state.name}")

    tape[pos] = rule.final_char
    new_state = rule.final_state
    if rule.dir == "l":
        new_pos = pos - 1
        if new_pos < 0:
            tape = [tm.blank] + tape
            new_pos = 0
    elif rule.dir == "r":
        new_pos = pos + 1
        if new_pos >= len(tape):
            tape = tape + [tm.blank]
    else:
        new_pos = pos
    
    return new_state, tape, new_pos

def print_machine(state, tape, pos, window=0):
    string = ""
    for idx, c in enumerate(tape):
        if window > 0 and (idx < pos - window or idx > pos + window):
            continue
        if idx == pos:
            string += f" \033[91m\033[1m{c}\033[0m"
        else:
            string += f" {c}"
    
    string += f" \033[92m[{state}]\033[0m"
    print(string)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Read the content of a file.")
    parser.add_argument(
        "filename", help="Name of the file containing the TM description."
    )
    parser.add_argument("tape", help="Name of the file containing the tape.")
    parser.add_argument(
        "position", help="the location of the head on the tape", type=int
    )
    parser.add_argument(
        "--suppress", help="suppress states from the log", type=str, nargs="+", default=[], required=False
    )
    args = parser.parse_args()

    with open("grammar.ebnf", "r") as grammar:
        parser = Lark(grammar)

    with open(args.filename, "r") as file:
        defn_tree = parser.parse(file.read())
    tm = TMTransformer().transform(defn_tree)
    verify_fwd_det(tm)
    verify_alphabet(tm)
    verify_states(tm)

    with open(args.tape) as file:
        tape = file.read()
        tape = tape.replace("\n", " ")
        tape = re.sub(r' +', " ", tape)
        tape = tape.strip()
        tape = tape.split(" ")
        tape_alpha = set(tape)
        tape_diff = tape_alpha - tm.alphabet
        if len(tape_diff) > 0:
            raise Exception(f"Illegal characters in tape: {tape_diff}")

    if args.position < 0 or args.position >= len(tape):
        raise Exception("Illegal position")
    
    machine = (tm.init, tape, args.position)
    printed_suppress = False
    while machine is not None:
        if machine[0] in args.suppress:
            if not printed_suppress:
                print(f"\033[92m[{machine[0]}]\033[0m")
                printed_suppress = True
        else:
            print_machine(*machine, window=40)
            printed_suppress = False


        old_machine = machine
        try:
            machine = step(tm, *machine)
        except Exception as e:
            print_machine(*old_machine)
            raise e
            
        if machine is not None and machine[0] != old_machine[0]:
            printed_suppress = False

        if machine is None:
            print_machine(*old_machine)