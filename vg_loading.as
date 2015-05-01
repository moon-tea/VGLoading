package  {
	import fl.motion.Color;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	public class vg_loading extends Sprite {

		//color CONSTS
		var RED:uint = 0xed1459;
		var BLUE:uint = 0x1484b4;
		var VIOLET:uint = 0x6458a6;
		var WHITE:uint = 0xFFFFFF;
		var LIGHT_GREY:uint = 0x4b4b4b;
		var GREY:uint = 0x3b3b3b;
		
		//alliases
		var DANGER:uint = RED;
		var SUCCESS:uint = BLUE;
		var GRAY:uint = GREY;

		//Arrays
		var faceParts:Array = new Array();
		var loadingStrings:Array = new Array();
		
		//Objects
		var faceHolder:Sprite = new Sprite();
		var faceLeft:LeftFace;
		var faceTop:TopFace;
		var faceRight:RightFace;
		var loadingText:TextField;
		var titleText:TextField;
		var myTween:Tween;
		
		//Variables
		var frameCounter:int = 0;
		var facePointer:int = 0;
		var faceCounter:int = 0;
		var endAnimFrame:int = 30;

		public function vg_loading() {
			
			faceLeft = new LeftFace();
			faceLeft.x = 0;
			faceLeft.y = 93;
			
			faceTop = new TopFace();
			faceTop.x = 6;
			faceTop.y = 0;
						
		 	faceRight = new RightFace();
			faceRight.x = 150;
			faceRight.y = 93;

			faceHolder.addChild(faceLeft);
			faceHolder.addChild(faceTop);
			faceHolder.addChild(faceRight);
			
			titleText = new TextField();
			var myFormat:TextFormat = new TextFormat();
			var font:Font = new Museo();
			myFormat.size = 72;
			myFormat.font = font.fontName;//"Museo Sans";
						
			titleText.border = false;
			titleText.multiline = false;
			titleText.wordWrap = false;
			titleText.selectable = false;
			//get it to be auto sized
			titleText.autoSize = TextFieldAutoSize.CENTER;
							
			//apply the format
			titleText.defaultTextFormat = myFormat;
			//set the color
			titleText.textColor = LIGHT_GREY;
			//set the text
			titleText.text = "VIRTUAL GEMINI";
			titleText.x = -faceHolder.width/2;			
			titleText.y = 370;			
			
			faceHolder.scaleX *=1.0;
			faceHolder.scaleY *=1.0;
			addChild(faceHolder);
			faceHolder.x = stage.stageWidth/2 - faceHolder.width/2; 
			faceHolder.addChild(titleText);			
			faceHolder.y = stage.stageHeight/2 - faceHolder.height/2; 
			
			faceParts.push(faceLeft);
			faceParts.push(faceTop);
			faceParts.push(faceRight);

			loadingStrings.push("Loading.");
			loadingStrings.push("Loading..");
			loadingStrings.push("Loading...");
			
			loadingText = new TextField();
			changeLoadingText(0);
			loadingText.x = stage.stageWidth/2 - loadingText.width/2;
			loadingText.y = stage.stageHeight/2 - loadingText.height/2 + 500;
			addChild(loadingText);
			
			addEventListener(Event.ENTER_FRAME, onLoop);
			//myTween = new Tween(new MovieClip(), "", Regular.easeOut, 0, 1, 0.35, true); 
			//myTween.addEventListener(TweenEvent.MOTION_FINISH, onFinish);
			//myTween.addEventListener(TweenEvent.MOTION_CHANGE, onChange);
			
		}

		public function onChange(e:TweenEvent):void {
			var glow:GlowFilter = new GlowFilter();
			glow.color = BLUE;
			
			var fromColor:uint = BLUE;
			var toColor:uint = WHITE;
			var shiftAmount:Number = 0.0;
			var shiftDamper:Number = .25;
			var colorTransform = new ColorTransform();
			
			colorTransform.color = BLUE;
			faceParts[facePointer].transform.colorTransform = colorTransform;
			
			shiftAmount = myTween.position;
			if(frameCounter < (endAnimFrame/2)) {
				colorTransform.color = Color.interpolateColor(fromColor, toColor, shiftAmount*shiftDamper);
			} else {
				//shiftAmount = 1-((frameCounter-endAnimFrame/2)/(endAnimFrame/2));
				colorTransform.color = Color.interpolateColor(toColor, fromColor, 1-shiftAmount*shiftDamper);
			}
			faceParts[facePointer].transform.colorTransform = colorTransform;
			//trace(shiftAmount);
			glow.alpha = shiftAmount;
			glow.blurX = 5; 
			glow.blurY = 5; 
			glow.quality = BitmapFilterQuality.MEDIUM; 

			faceParts[facePointer].filters = [glow];	      
		}

		public function onFinish(e:TweenEvent):void {
			e.target.yoyo();
			faceCounter++;
			if(faceCounter == faceParts.length*2) {
				faceCounter = 0;
			}
			facePointer = Math.floor(faceCounter/2);		
			trace(faceCounter);
			trace(facePointer);
			changeLoadingText(facePointer);			
		}

		public function onLoop(e:Event):void {
			frameCounter++;
			if (frameCounter == endAnimFrame) {
				frameCounter = 0;
				facePointer++;
				if(facePointer == faceParts.length) {
					facePointer = 0;
				}		
				changeLoadingText(facePointer);
			}

			var glow:GlowFilter = new GlowFilter();
			glow.color = BLUE;
			
			var fromColor:uint = BLUE;
			var toColor:uint = WHITE;
			var shiftAmount:Number = 0.0;
			var shiftDamper:Number = .25;
			var colorTransform = new ColorTransform();
			
			colorTransform.color = BLUE;
			faceParts[facePointer].transform.colorTransform = colorTransform;
			
			if(frameCounter < (endAnimFrame/2)) {
				shiftAmount = frameCounter/(endAnimFrame/2);
				colorTransform.color = Color.interpolateColor(fromColor, toColor, shiftAmount*shiftDamper);
			} else {
				shiftAmount = 1-((frameCounter-endAnimFrame/2)/(endAnimFrame/2));
				colorTransform.color = Color.interpolateColor(toColor, fromColor, 1-shiftAmount*shiftDamper);
			}
			faceParts[facePointer].transform.colorTransform = colorTransform;
			//trace(shiftAmount);
			glow.alpha = shiftAmount;
			glow.blurX = 5; 
			glow.blurY = 5; 
			glow.quality = BitmapFilterQuality.MEDIUM; 

			faceParts[facePointer].filters = [glow];	        
		}

		public function changeLoadingText(i:int):void {
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 48;
			var font:Font = new Museo();
			myFormat.font = font.fontName;//"Museo Sans";
						
			loadingText.border = false;
			loadingText.multiline = false;
			loadingText.wordWrap = false;
			loadingText.selectable = false;
			//get it to be auto size
			loadingText.autoSize = TextFieldAutoSize.LEFT;
							
			//apply the format
			loadingText.defaultTextFormat = myFormat;
			//set the color
			loadingText.textColor = GREY;
			//set the text
			loadingText.text = loadingStrings[i];
			//trace(loadingText.width);
		}
	}
}