Simulate a Turing machine. To try it out:
```
pip install -r requirements.txt
python -m tm examples/square.tm examples/square.tape 0
```
(the arguments, in order: the machine definition, the initial tape, and the initial head position)

This example squares a unary number (problem 6.1-2. (1) in _Finite and Infinite Machines_ by Minsky)