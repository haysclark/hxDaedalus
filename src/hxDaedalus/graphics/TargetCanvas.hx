package hxDaedalus.graphics;

#if (flash || openfl || nme) 
typedef TargetCanvas = flash.display.Graphics;
#elseif js
typedef TargetCanvas = hxDaedalus.canvas.BasicCanvas;
#elseif java
typedef TargetCanvas = hxDaedalus.swing.BasicSwing;
#end