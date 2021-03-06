
import hxDaedalus.ai.EntityAI;
import hxDaedalus.ai.PathFinder;
import hxDaedalus.ai.trajectory.LinearPathSampler;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.data.math.Point2D;
import hxDaedalus.data.math.RandGenerator;
import hxDaedalus.factories.RectMesh;
import hxDaedalus.canvas.BasicCanvas;
import hxDaedalus.view.SimpleView;
import js.Browser;
import js.html.Event;
import js.html.MouseEvent;

class GridMazeDemoJS
{
    
    var mesh : Mesh;
    var view : SimpleView;
	//var entityView:graphics.SimpleView;
	//var meshView:graphics.SimpleView;
    
    var entityAI : EntityAI;
    var pathfinder : PathFinder;
    var path : Array<Float>;
    var pathSampler : LinearPathSampler;
    
    var newPath:Bool = false;
	
	var rows:Int = 15;
	var cols:Int = 15;
	
    var x: Float;
    var y: Float;
	
	var basicCanvas:BasicCanvas;

    public static function main():Void {
        new GridMazeDemoJS();
    }
    
    public function new() {
        
        // build a rectangular 2 polygons mesh of 600x600
        mesh = RectMesh.buildRectangle(600, 600);
        
        basicCanvas = new BasicCanvas();
		
        // create a viewport
        view = new SimpleView(basicCanvas);
        
		GridMaze.generate(600, 600, cols, rows);
		mesh.insertObject(GridMaze.object);
		
		view.constraintsWidth = 4;
		view.edgesWidth = .5;
        view.drawMesh(mesh);
		
        // we need an entity
        entityAI = new EntityAI();
        // set radius as size for your entity
        entityAI.radius = 10;
        // set a position
        entityAI.x = GridMaze.tileWidth / 2;
        entityAI.y = GridMaze.tileHeight / 2;
        
        // show entity on screen
        view.drawEntity(entityAI);
        
        // now configure the pathfinder
        pathfinder = new PathFinder();
        pathfinder.entity = entityAI;  // set the entity  
        pathfinder.mesh = mesh;  // set the mesh  
        
        // we need a vector to store the path
        path = new Array<Float>();
        
        // then configure the path sampler
        pathSampler = new LinearPathSampler();
        pathSampler.entity = entityAI;
        pathSampler.samplingDistance = 12;
        pathSampler.path = path;
        
        // click/drag
        basicCanvas.canvas.onmousedown = onMouseDown;
        basicCanvas.canvas.onmouseup = onMouseUp;
        basicCanvas.canvas.onmousemove = onMouseMove;
		
        // animate
        basicCanvas.onEnterFrame = onEnterFrame;
		
		// keypress
		js.Browser.document.onkeydown = onKeyDown;
    }
    
    function onMouseMove( e: Event ): Void {
        var p: MouseEvent = cast e;
        x = p.clientX;
        y = p.clientY;
    }
    
    function onMouseUp( event: Event ): Void {
        newPath = false;
    }
    
    function onMouseDown( event: Event ): Void {
        newPath = true;
		event.preventDefault();
    }
    
    function onEnterFrame(): Void {
		if (newPath) view.drawMesh(mesh, true);

        if ( newPath ) {
            // find path !
            pathfinder.findPath( x, y, path );
            
            // show path on screen
            view.drawPath( path );
            
            // reset the path sampler to manage new generated path
            pathSampler.reset();
        }
        
        // animate !
        if ( pathSampler.hasNext ) {
            // move entity
            pathSampler.next();            
        }
		
		// show entity position on screen
		view.drawEntity(entityAI);
    }

    function onKeyDown( event:js.html.KeyboardEvent ): Void {
		if (event.keyCode == 32) { // SPACE
			reset(true);
			event.preventDefault();
		} else if (event.keyCode == 13) { // ENTER
			reset(false);
			event.preventDefault();
		}
    }

	function reset(newMaze:Bool = false):Void {
		var seed = Std.int(Math.random() * 10000 + 1000);
		if (newMaze) {
			mesh = RectMesh.buildRectangle(600, 600);
			GridMaze.generate(600, 600, 30, 30, seed);
			GridMaze.object.scaleX = .92;
			GridMaze.object.scaleY = .92;
			GridMaze.object.x = 23;
			GridMaze.object.y = 23;
			mesh.insertObject(GridMaze.object);
		}
        entityAI.radius = GridMaze.tileWidth * .27;
		view.drawMesh(mesh, true);
		pathfinder.mesh = mesh;
		entityAI.x = GridMaze.tileWidth / 2;
		entityAI.y = GridMaze.tileHeight / 2;
		path = [];
		pathSampler.path = path;
	}
}
