# Sqtnb
# Fold roll commands into udlr commands.

import sys
put = sys.stdout.write

def rollfold(str):
	# u,d,r,l commands under roll form a cyclic group 
	group = "^>_<"
	rolls = 0

	for c in str:
		if c=='/':
			rolls = rolls - 1
		elif c=='\\':
			rolls = rolls + 1
		elif group.find(c) != -1:
			put(group[(group.index(c)+rolls) %4])
		else:
			put(c)

	print('\\' * (rolls %4))


# So we can pipe our lstrings around the unix shell if we want
if __name__ == '__main__':
	str = raw_input()
	rollfold(str)
