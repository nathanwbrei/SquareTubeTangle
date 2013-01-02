

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
		attr_accessor :x, :y, :z
		def initialize(x, y, z, d)
			@x = x
			@y = y
			@z = z
			@d = d
			show
		end
		def show
			# Adds block geometry (a cube) to the current sketch, saving references so that hide() can delete it later if necessary
			p0=[@x,@y,@z]
 			p1=[@x+@d,@y,@z]
 			p2=[@x+@d,@y+@d,@z]
 			p3=[@x,@y+@d,@z] 		
 			p4=[@x,@y,@z+@d]
 			p5=[@x+@d,@y,@z+@d]
 			p6=[@x+@d,@y+@d,@z+@d]
 			p7=[@x,@y+@d,@z+@d]

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
    	@d = 100
    	@blocks = [Block.new(0,0,0, @d)]

    	welcome = "Welcome to my SquareTubeTangle creator. Keys are up/down/right/left/ctrl/alt/esc/return. "
    	print welcome
    	UI.messagebox(welcome)
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
    	case key
			when VK_LEFT
				@blocks.push(Block.new(@blocks.last.x-@d, @blocks.last.y, @blocks.last.z, @d))

  			when VK_RIGHT
  				@blocks.push(Block.new(@blocks.last.x+@d, @blocks.last.y, @blocks.last.z, @d))

  			when VK_UP
  				@blocks.push(Block.new(@blocks.last.x, @blocks.last.y+@d, @blocks.last.z, @d))

  			when VK_DOWN
  				@blocks.push(Block.new(@blocks.last.x, @blocks.last.y-@d, @blocks.last.z, @d))

			when VK_CONTROL
				@blocks.push(Block.new(@blocks.last.x, @blocks.last.y, @blocks.last.z+@d, @d))

			when VK_ALT
				@blocks.push(Block.new(@blocks.last.x, @blocks.last.y, @blocks.last.z-@d, @d))

			when 27
				# User hits ESC
				block = @blocks.pop().hide() if @blocks.length > 1
		end
    end
end

#UI.menu("Tools").add_separator()
#UI.menu("Tools").add_item("SquareTubeTangle") {Sketchup.active_model.select_tool(SquareTubeTool.new())}
Sketchup.active_model.select_tool(SquareTubeTangleTool.new())


