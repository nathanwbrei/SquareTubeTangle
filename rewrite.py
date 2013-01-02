""" 
Generator-based reimplementation of lsys. Uses the stream paradigm.

"""

from random import random

def rewrite(seq, rules, depth=1):
    """
    One rewrite iteration of a context-free Lindenmayer System.
        seq:      The initial sequence, an iterable
        rules:    {'A' : 'AB', ...                          [deterministic]
                   'B' : [(0.5, 'AB'), (0.3, 'AAB')], ...}  [nondeterministic]
            Maps each symbol from seq to its replacement symbol(s). If not
            deterministic, maps each symbol to a list of tuples of the form 
            (probability, replacementstring). Rule types can be mixed.
    """

    def rand(l):
        """ Randomly choose a tuple (prob, val) from l; return val. """
        x = random(); total = 0
        for p,v in l:
            total += p
            if x<total:
                return v
        return v

    def isnondet(r):
        """ Reports if rule is nondeterministic """
        return isinstance(r, list)   # BAD

    def transform(a):
        """ Returns the correct replacement string for the given symbol. """
        if a not in rules:
            return a
        elif isnondet(rules[a]):            
            return rand(rules[a])
        else:
            return rules[a]

    """ Lazily iterate over sequence """
    result = (k for j in seq for k in transform(j))
    if depth <= 1:
        return result
    else:
        return rewrite(result, rules, depth-1)

def show(seq, alphabet):
        """ Draws the L-system to screen, using the callbacks associated
            with each symbol in alphabet.
        """
        for a in seq:
            if a in alphabet:
                alphabet[a]()