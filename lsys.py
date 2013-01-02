from random import random

class LSystem(object):
    """ Implements a Lindenmeyer System. """


    def __init__(self, alphabet, axiom, rules, depth):
        """
        alphabet: {'A' : func_a, 'B' : func_b, ...}
            A dictionary mapping each symbol to a callback, e.g. for graphics.

        axiom:    'AB...'   
            The initial string

        rules:    {'A' : 'AB', ...                          [deterministic]
                   'B' : [(0.5, 'AB'), (0.3, 'AAB')], ...}  [nondeterministic]
            Maps each symbol character to its replacement string. If not
            deterministic, maps each symbol to a list of tuples of the form 
            (probability, replacementstring). Rule types can be mixed.

        depth:  
            The initial number of iterations to be computed
                    
        """
        self.alphabet = alphabet
        self.state = axiom
        self.rules = rules

        for i in range(depth):
            self.generate()

    def generate(self):
        """ Apply one iteration of production rules to the current state. """

        def rand(l):
            """ Randomly choose a tuple (prob, val) from l; return val. """
            x = random(); total = 0
            for p,v in l:
                total += p
                if x<total:
                    return v
            return v

        def transform(a):
            """ Returns the correct replacement string for the given symbol. """
            if a not in self.rules:
                return a
            elif isinstance(self.rules[a], list):   # BAD
                return rand(self.rules[a])
            else:
                return self.rules[a]


        self.state = ''.join([transform(a) for a in self.state])


    def show(self):
        """ Draws the L-system to screen, using the callbacks associated
            with each symbol in alphabet.

        """
        for a in self.state:
            if a in self.alphabet:
                self.alphabet[a]()

