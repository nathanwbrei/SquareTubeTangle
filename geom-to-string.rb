

# SquareTubeTangle generator
# By Nathan Brei
# nathan.w.brei@gmail.com

# A SketchUp plugin which lets the user sketch a squaretubetangle using the arrow keys. 
# The script outputs a string describing the geometry turtle-graphics style, which can be fed into the other
# L-system and fabrication scripts.

# To see what this is all about:
# http://boardwalk-labyrinth.posterous.com/project-squaretubetangle

# To use:
# In Ruby Console, load "~/SquareTubeTangle/creator.rb"
# or save under /Library/Application Support/Google SketchUp/Plugins 


class SquareTubeTangleTool

	class Block
		attr_accessor :x, :t, :n
		def initialize(last_x,t,n) 
			d = 100
			x,y,z = last_x
			t1,t2,t3 = t
			@x = [x+d*t1, y+d*t2, z+d*t3]
			@t = t
			@n = n
			show
		end

		def show
			# Adds block geometry (a cube) to the current sketch, saving references so that hide() can delete it later if necessary
			x,y,z=@x
			d=100
			puts "t: (#{t[0]}, #{t[1]}, #{t[2]})"
			puts "n: (#{n[0]}, #{n[1]}, #{n[2]})"
			
			p0=[x,y,z]
 			p1=[x+d,y,z]
 			p2=[x+d,y+d,z]
 			p3=[x,y+d,z] 		
 			p4=[x,y,z+d]
 			p5=[x+d,y,z+d]
 			p6=[x+d,y+d,z+d]
 			p7=[x,y+d,z+d]

 			# We are adding six faces for simplicity, but later, if we keep closer track of orientation, we'll only add four.
 			new_faces = [[p0, p1, p2, p3], [p0, p1, p5, p4], [p1, p2, p6, p5], [p2, p3, p7, p6], [p3, p0, p4, p7], [p4, p5, p6, p7]]

 			ent = Sketchup.active_model.active_entities

 			# References to the new geometry are saved in @faces
	 		@faces = Array.new

	 		# We want to remember which faces we added when we 'showed' this block.
	 		# Sketchup avoids creating duplicate faces wherever it can. We don't want to remove faces that are used by other geometry, 
	 		# so we only track (aka push to @faces) faces that we know for certain we just added. 
	 		# Entities.add_face ought to return (result, reference), to inform us when it has actually created a face, but it doesn't, 
	 		# so we have this ugliness to compensate.

	 		new_faces.each do |face_points|
	 			len = ent.length()
	 			face = ent.add_face(face_points)
	 			@faces.push(face) if ent.length() > len
	 		end
 		end

		def hide
			# We want to be able to backtrack, one block at a time, if the user makes a mistake. 
			# This deletes the geometry created by Block.show().
			@faces.each do |face|
				if not face.deleted?
					edges = face.edges
					face.erase!
					edges.each do |edge|
						if edge.faces.empty?
							edge.erase!
						end
					end
				end
			end
		end
	end

    def activate
    	@blocks = [Block.new([-100,0,0], [1,0,0], [0,0,1])]
    	@string = "s"

    	puts "Welcome to my SquareTubeTangle creator. Keys are up/down/right/left/ctrl/alt/esc/return. "
    end

    def reset(view)
    	@blocks.each do |block|
    		block.hide()
    	end
    end

    def onReturn(view)
    	# User finishes construction by pressing ENTER. The string is displayed. 
    	puts "Thank you! Your string has been saved to ~/Desktop/square_tube_tangle.txt."
    	exec('open ~/Desktop/square_tube_tangle.txt')
    end

    def onKeyDown(key, repeat, flags, view)

		x,t,n = @blocks.last.x, @blocks.last.t, @blocks.last.n
    	case key

			when VK_LEFT
				@string += "l"

  			when VK_RIGHT
  				@string += "r"

  			when VK_UP
  				@string += "u"

  			when VK_DOWN
  				@string += "d"

			when VK_CONTROL
	    		@string += "f"

			when 27
				block = @blocks.pop().hide() if @blocks.length > 1

		end
		puts @string
		parse @string.split('').last
    end


    def parse(l)
		puts "l is: #{l}"
		puts "@blocks is #{@blocks}"
		puts "@blocks.length is #{@blocks.length}"
		l.split('').each do |c| 
			puts "dealing with c=#{c}"
			x,t,n = @blocks.last.x, @blocks.last.t, @blocks.last.n
	    	case c
				when 'l'
					puts "Found an L"
					tp,np = cross(n,t),n
		    		@blocks.push(Block.new(x,tp,np))

	  			when 'r'
	  				tp,np = cross(t,n),n
		    		@blocks.push(Block.new(x,tp,np))

	  			when 'u'
	  				tp,np = n,minus(t)
		    		@blocks.push(Block.new(x,tp,np))

	  			when 'd'
	  				tp,np = minus(n),t
		    		@blocks.push(Block.new(x,tp,np))

				when 'f'
		    		@blocks.push(Block.new(x,t,n))

			end
	    end
	end
end

def minus(a)
	x,y,z = a
	[-x,-y,-z]
end


def cross(a,b)
	# Vector cross-product
    [a[1]*b[2]-a[2]*b[1], -a[0]*b[2]+a[2]*b[0], a[0]*b[1]-a[1]*b[0]]
end


#UI.menu("Tools").add_separator()
#UI.menu("Tools").add_item("SquareTubeTangle") {Sketchup.active_model.select_tool(SquareTubeTool.new())}
Sketchup.active_model.select_tool(SquareTubeTangleTool.new())


