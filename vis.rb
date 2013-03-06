
# SquareTubeTangle visualizer
# By Nathan Brei
# nathan.w.brei@gmail.com

# A SketchUp plugin which visualizes a square-sectioned path described
# by a string of 3D turtle graphics commands

# To see what this is all about:
# http://boardwalk-labyrinth.posterous.com/project-squaretubetangle

# To use:
# In Ruby Console, load "~/SquareTubeTangle/vis.rb"
# or save under /Library/Application Support/Google SketchUp/Plugins 

# Create new file
D=100

# Create a new face
def start
	f = [[0,D,0],[D,D,0],[D,0,0],[0,0,0]]
	t = [0,0,1]
	n = [0,1,0]
	[f,t,n]
end

def dot(v1, v2)
	# 3D vector dot product
	v1[0]*v2[0] + v1[1]*v2[1] + v1[2]*v2[2]
end

def plus(v1,v2)
	[v1[0]+v2[0], v1[1]+v2[1], v1[2]+v2[2]]
end

def minus(v)
	[-v[0],-v[1],-v[2]]
end

def times(v,d)
	[d*v[0], d*v[1], d*v[2]]
end

def cross(a,b)
	# Vector cross-product
	[a[1]*b[2]-a[2]*b[1], -a[0]*b[2]+a[2]*b[0], a[0]*b[1]-a[1]*b[0]]
end

def face(f,t)
	# Convert a list of vertices into a SketchUp face.
	# Luckily, Sketchup automatically accounts for duplicates
	# However, the normal sometimes changes direction after a pushpull

	face = Sketchup.active_model.entities.add_face(f)
	if dot(face.normal, t) < 0
		face.reverse!
	end
	face
end

def vis(s, f, t, n)
	# s: the string to visualize
	# (f,t,n): the current state. Consists of face=[v1,v2,v3,v4], tan, norm 
	# Faces won't necessarily persist, so we re-generate the face each 
	# time from its vertices

	

	# Iterate over each char in the string 
	s.split('').each do |c|
		# Unpack face vertices. Remember: They are ordered 0u1r2d3l0
		v0, v1, v2, v3 = f

		# Turning right requires a forward motion first. This goes against
		# Turtle Graphics conventions but makes much more sense given
		# the origami discipline.


		face(f,t).pushpull(D)
		f=[plus(v0,times(t,D)), plus(v1,times(t,D)), plus(v2,times(t,D)), plus(v3,times(t,D))]
		v0, v1, v2, v3 = f
		
		case c
		when 'u'
			f=[plus(v0,times(t,-D)), plus(v1,times(t,-D)), v1,v0]
			t,n = n,minus(t)
		when 'd'
			f=[v3, v2, plus(v2,times(t,-D)), plus(v3,times(t,-D))]
			t,n = minus(n),t
		when 'l'
			f=[v1, plus(v1,times(t,-D)), plus(v2,times(t,-D)), v2]
			t = cross(n,t)
		when 'r'
			f = [plus(v0, times(t,-D)), v0, v3, plus(v3,times(t,-D))]
			t = cross(t,n)
		end
		
		puts "Just ran " + c + ". face is now "+f.inspect
		Sketchup.active_model.selection.clear
		Sketchup.active_model.selection.add(face(f,t))
	end
	[f,t,n]
end


def fresh
	Sketchup.active_model.entities.clear!
	load "~/SquareTubeTangle/vis.rb"
	x=start
	x=vis("fff",*x)
	x
end
