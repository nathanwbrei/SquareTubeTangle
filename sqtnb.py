

def cutstroke():
    stroke(1,0,0); strokewidth(2)

def scorestroke():
    stroke(0); strokewidth(0.5)

def foldstroke():
    stroke(0,0,1); strokewidth(0.5)

def counter():
    x = [0]
    def c():
        x[0] += 1
        return x[0]
    return c

def main_cut_path():
    cutstroke()
    c = counter()
    for x,y in next_strip_position():
        beginpath(x,y)
        lineto(x+p*d, y)
        fill(0); text(str(c()), x+p*d+d*1/3, y+d-d*1/3); nofill()
        for x1,y1 in next_tab_position(x+p*d,y):
            lineto(x1,y1)
            lineto(x1+d,y1)
            lineto(x1+d,y1+d)
            lineto(x1,y1+d)
        lineto(x+p*d, y+l*d)
        lineto(x, y+l*d)
        lineto(x,y)
        endpath()
    
def backup_cut_path():    
    def tab(x,y):
        beginpath(x,y)
        lineto(x+d,y)
        lineto(x+d,y+d)
        lineto(x,y+d)
        endpath()

    stroke(1,0,0)
    strokewidth(2)
    y=(l+1)*d
    for i in range(n):
        x=d*(6*i+1)
        line(x, d, x, (l+1)*d)
        line(x, d, x+4*d, d)
        line(x, y, x+4*d, y)
        for j in range(t):  
            tab(d*(6*i+5),(l/t*j+1)*d)
            line(d*(6*i+5), (l/t*(j)+2)*d, d*(6*i+5), (l/t*(j+1)+1)*d)
        line(d*(6*i+5), (l/t*(j+1)+1)*d, d*(6*i+5), y)
            
    
def main_score_path():
    scorestroke()
    beginpath()
    for x,y in next_strip_position():
        for i in range(p+1):
            moveto(x+i*d, y)
            lineto(x+i*d, y+l*d)
    endpath()        
        
    
def next_symbol_position():
    for x,y in next_strip_position():
        for i in range(l):
            yield x, y+i*d
        
def next_strip_position():
    x = -(p+1)*d; y = d;
    for i in range(n):
        x += (p+2)*d
        yield (x,y)

def next_tab_position(x, y):
    c = l/t
    for i in range(t):
        yield x, y+c*d*i
            
        
def forward(position):   
    x,y=position.next()
    fill(0); text('F',x-d*2/3,y+d*2/3); nofill()


def up(position):   # Assume n=4 for now

    position.next()    # Extra unit of length used up in turn
    x,y = position.next()
    scorestroke()
    
    beginpath()
    moveto(x,y)
    lineto(x+d,y)
    lineto(x+2*d,y+d)
    lineto(x+3*d,y+d)
    lineto(x+4*d,y)
    endpath()

    foldstroke()
    beginpath(x+d,y)
    lineto(x+4*d,y)
    endpath()
    fill(0); text('U',x-d*2/3,y+d*2/3)
    nofill()


def right(position):   # Assume n=4 for now

    position.next()    # Extra unit of length used up in turn
    x,y = position.next()
    scorestroke()
    
    beginpath()
    moveto(x,y)
    lineto(x+d,y+d)
    lineto(x+2*d,y+d)
    lineto(x+3*d,y)
    lineto(x+4*d,y)
    endpath()

    foldstroke()
    beginpath(x,y)
    lineto(x+3*d,y)
    endpath()
    fill(0); text('R',x-d*2/3,y+d*2/3)
    nofill()


def left(position):   # Assume n=4 for now

    position.next()    # Extra unit of length used up in turn
    x,y = position.next()
    scorestroke()
    
    beginpath()
    moveto(x,y+d)
    lineto(x+d,y)
    lineto(x+2*d,y)
    lineto(x+3*d,y+d)
    lineto(x+4*d,y+d)
    endpath()

    foldstroke()
    beginpath(x,y)
    lineto(x+d,y)
    moveto(x+2*d,y)
    lineto(x+4*d,y)
    endpath()
    fill(0); text('L',x-d*2/3,y+d*2/3)
    nofill()



def down(position):   # Assume n=4 for now

    position.next()    # Extra unit of length used up in turn
    x,y = position.next()
    scorestroke()
    
    beginpath()
    moveto(x,y+d)
    lineto(x+d,y+d)
    lineto(x+2*d,y)
    lineto(x+3*d,y)
    lineto(x+4*d,y+d)
    endpath()

    foldstroke()
    beginpath(x,y)
    lineto(x+2*d,y)
    moveto(x+3*d,y)
    lineto(x+4*d,y)
    endpath()
    fill(0); text('D',x-d*2/3,y+d*2/3)
    nofill()




#d = 20; n=4; l=35; t=5; p=4    #8.5x11
d=20; n=4; l=35; t=5; p=4

size(d*(n*(p+2)+1), d*(l+2))
nofill()
autoclosepath(False)
font('Monaco', d*2/3)

main_cut_path()
main_score_path()

position = next_symbol_position()
alphabet = {'F': lambda : forward(position),
            'R': lambda : right(position),
            'U': lambda : up(position),
            'L': lambda : left(position),
            'D': lambda : down(position)}
for a in "UDRLFUDRLFFFDFFLFFFRFFFFUFFFRFFFFFFFRFFFFFFF":
    if a in alphabet:
        alphabet[a]()
    
