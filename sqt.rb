

# SquareTubeTangle, the SketchUp/Ruby side
# By Nathan Brei
# nathan.w.brei@gmail.com

# A SketchUp plugin which visualizes SQT strings and lets the user
# sketch a squaretubetangle using the arrow keys. 

# To use:
# In Ruby Console, load "~/SquareTubeTangle/sqt.rb"
# or save under /Library/Application Support/Google SketchUp/Plugins


class SquareTubeTangleTool

    def activate
    	@string = "s"
    	@x = start

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
    	case key
			when VK_LEFT
        if @string[-2..-1] != "ll"
          s = "r"
  				@string += s
	 			  @x = vis(s, *@x)
        end

  		when VK_RIGHT
        if @string[-2..-1] != "rr"
  				s = "l"
	 			  @string += s
				  @x = vis(s, *@x)
        end

  		when VK_UP
        if @string[-2..-1] != "uu"
  			  s = "u"
  				@string += s
	  			@x = vis(s, *@x)
        end

  		when VK_DOWN
        if @string[-2..-1] != "dd"
  				s = "d"
				  @string += s
				  @x = vis(s, *@x)
        end

			when VK_CONTROL
	      s = "f"
			  @string += s
				@x = vis(s, *@x)

			when 27
				@string.chop!
        Sketchup.active_model.entities.clear!
        @x = start
				@x = vis(@string, *@x)

		end
		puts @string
    end

  def onLButtonUp(flags, x, y, view)
    ph = Sketchup.active_model.active_view.pick_helper
    ph.do_pick x,y
    clicked = ph.best_picked
    puts clicked.inspect
    if clicked.class == Sketchup::Face
      if clicked == face(@x[0],@x[1])
        @x=vis("f",*@x)
      elsif clicked.edges.member?(edge(@x[0][0], @x[0][1]))
        puts "UP"
        @x = vis("u", *@x)
      elsif clicked.edges.member?(edge(@x[0][3], @x[0][0]))
        puts "down"
        @x = vis("d", *@x)
      elsif clicked.edges.member?(edge(@x[0][2], @x[0][3]))
        puts "right"
        @x = vis("r", *@x)
      elsif clicked.edges.member?(edge(@x[0][1], @x[0][2]))
        puts "left"
        @x = vis("l", *@x)
      end
    end
  end
end

#UI.menu("Tools").add_separator()
#UI.menu("Tools").add_item("SquareTubeTangle") {Sketchup.active_model.select_tool(SquareTubeTool.new())}
tool = SquareTubeTangleTool.new
tool.x = start
Sketchup.active_model.select_tool(tool)
load "~/SquareTubeTangle/vis.rb"
