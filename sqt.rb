

# SquareTubeTangle, the SketchUp/Ruby side
# By Nathan Brei
# nathan.w.brei@gmail.com

# A SketchUp plugin which visualizes SQT strings and lets the user
# sketch a squaretubetangle using the arrow keys. 

# To use:
# In Ruby Console, load "~/SquareTubeTangle/sqt.rb"
# or save under /Library/Application Support/Google SketchUp/Plugins


class SquareTubeTangleTool

    attr_writer :x
    attr_writer :string

    def activate
        k = UI.inputbox ["Lstring:"], [@string], "SquareTubeTangle"
        if k
            @string = k[0]
            @x = start
            Sketchup.active_model.entities.clear!
            @x = vis(@string, *@x)
        end
    end

    def onReturn(view)
        # User can access/modify string by pressing ENTER. 
        activate
    end

    def onKeyDown(key, repeat, flags, view)
        case key
        
        when VK_LEFT
        if @string[-2..-1] != "<<"
            s = "<"
            @string += s
            @x = vis(s, *@x)
        end

        when VK_RIGHT
        if @string[-2..-1] != ">>"
            s = ">"
            @string += s
            @x = vis(s, *@x)
        end

        when VK_UP
        if @string[-2..-1] != "^^"
            s = "^"
            @string += s
            @x = vis(s, *@x)
        end

        when VK_DOWN
        if @string[-2..-1] != "__"
            s = "_"
            @string += s
            @x = vis(s, *@x)
        end

        when VK_CONTROL
            s = "-"
            @string += s
            @x = vis(s, *@x)

        when ","[0]
            s = "\\"
            @string+=s
            @x = vis(s, *@x)

        when "."[0]
            s = "/"
            @string+=s
            @x = vis(s, *@x)

        when 27
            @string = @string[0..-5 ]
            Sketchup.active_model.entities.clear!
            @x = start
            @x = vis(@string, *@x)

        end
        puts @string
    end

    def onLButtonUp(flags, x, y, view)
        # Extrude faces by clicking them

        ph = Sketchup.active_model.active_view.pick_helper
        ph.do_pick x,y
        clicked = ph.best_picked

        if clicked.class == Sketchup::Face

            if clicked == face(@x[0],@x[1])
                @x=vis("-",*@x)
            elsif clicked.edges.member?(edge(@x[0][0], @x[0][1]))
                @x = vis("^", *@x)
            elsif clicked.edges.member?(edge(@x[0][3], @x[0][0]))
                @x = vis("_", *@x)
            elsif clicked.edges.member?(edge(@x[0][2], @x[0][3]))
                @x = vis(">", *@x)
            elsif clicked.edges.member?(edge(@x[0][1], @x[0][2]))
                @x = vis("<", *@x)
            end
            
        end
    end
end

# We can have different visualization functions
load("~/SquareTubeTangle/vis.rb")

# Set up tool with persistent state
tool = SquareTubeTangleTool.new
tool.string = "s"
tool.x = start

# Add UI hooks
UI.menu("Tools").add_separator()
UI.menu("Tools").add_item("SquareTubeTangle") {Sketchup.active_model.select_tool(tool)}
UI.menu("Tools").add_separator()

