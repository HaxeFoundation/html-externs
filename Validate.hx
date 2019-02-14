class Validate {
	
	static function main() {
		js.Browser;
		js.Lib;
		js.Boot;
		js.Date;

		// ensure listerner callback argument is typed
		js.Browser.window.addEventListener('mousedown', function(e) {
			$type(e.someRandomField); // allow arbitrary field access - should be Dynamic
			// event should auto-cast to any other event subclass
			// onMouseDown(e);
		});

		// should allow functions with Event subtypes
		js.Browser.window.addEventListener('mousedown', Validate.onMouseDown);

		// listener function without arguments should be allowed
		js.Browser.window.addEventListener('resize', function() {});

		// listener interface should be allowed
		js.Browser.window.addEventListener('mousedown', {
			handleEvent: (e) -> {
				$type(e); // should be js.html.DynamicEvent
				e.preventDefault();
			}
		});

		// ensure array buffer views can be unified (error from lime)
		var buffer = switch Math.round(Math.random()) {
			case 0: new js.html.Float32Array([0]);
			default: new js.html.Uint16Array([0]);
		}
		
		$type(buffer); // should be ArrayBufferView

		// check console methods can be called from Browser.console (error from heaps)
		js.Browser.console.log("Could not initialize PBR Driver: WebGL2 required");

		// check webgl extension typing
		var canvas = js.Browser.document.createCanvasElement();
		var gl = canvas.getContextWebGL();

		var extTyped = gl.getExtension(ANGLE_instanced_arrays);
		$type(extTyped.drawArraysInstancedANGLE); // should be "mode : Int -> first : Int -> count : Int -> primcount : Int -> Void"

		var extUntyped = gl.getExtension('ANGLE_instanced_arrays');
		$type(extUntyped.drawArraysInstancedANGLE); // should be Unknown

		// ensure overloads are properly matched
		// see https://github.com/HaxeFoundation/haxe/issues/7794
		var current : js.html.audio.AudioBufferSourceNode = null;
		var ctx : js.html.audio.AudioContext = null;
		current.connect(ctx.destination); // overload resolution failed
	}

	static function onMouseDown(e: js.html.MouseEvent) {
		trace(e.buttons);
	}

}