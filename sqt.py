""" 
Demo L-Systems!

"""

from rewrite import rewrite, show
from turtlegraphics_nodebox import TurtleGraphics

seq0 = 'f f f r f r f f f f r f f f f f l f f'
seq1 = 'BfBfB fr AfAfA rf BfBfBfB fr AfAfAfAfAfA fl BfBfB'
seq2 = 'BfBfB lf AfAfA fl BfBfB lf AfAfA fl'

hilbert = {'A' : 'lBfrAfArfBl',
           'B' : 'rAflBfBlfAr'}

koch =  {'f' : 'f+f--f+f'}

seq = rewrite(seq1, hilbert, 3)
seq = rewrite(seq, koch)

t = TurtleGraphics()

alphabet = {'A' : t.const,
            'B' : t.const,
            'f' : t.mk_forward(5),
            'g' : t.mk_forward(2),
            'l' : t.mk_left(90),
            'r' : t.mk_right(90),
            '+' : t.mk_right(60),
            '-' : t.mk_left(60)}

show(seq, alphabet)
#print ''.join(seq)