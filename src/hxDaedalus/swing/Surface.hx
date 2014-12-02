package hxDaedalus.swing;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import javax.swing.JPanel;

class Surface extends JPanel
{
    public var g: Graphics2D;
    public var paintFunction: Graphics2D -> Void;
    public function new(){ super( true ); }
    @:overload public function paintComponent( g: Graphics ){
        super.paintComponent( g );
        var g2D: Graphics2D = cast g;
        var rHint = RenderingHints;
        g2D.setRenderingHint( rHint.KEY_ANTIALIASING, rHint.VALUE_ANTIALIAS_ON );
        g2D.setRenderingHint( rHint.KEY_RENDERING, rHint.VALUE_RENDER_QUALITY );
        paintFunction( g2D );
        g2D.dispose();
    }
}