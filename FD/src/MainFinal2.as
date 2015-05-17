package 
{
	import com.doitflash.air.extensions.speech.Speech;
	import com.doitflash.air.extensions.speech.SpeechEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import com.doitflash.starling.utils.list.List;
	import com.doitflash.text.modules.MySprite;
	import com.luaye.console.C;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 2/14/2015 1:42 PM
	 */
	public class MainFinal2 extends Sprite 
	{
		private var _ex:Speech;
		
		private const BTN_WIDTH:Number = 150;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		private var _channel:SoundChannel = new SoundChannel();
		
		public function MainFinal2():void 
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.x = 100;
			C.width = 500;
			C.height = 250;
			C.strongRef = true;
			C.visible = true;
			C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
			
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = false;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>Speech API V" + Speech.VERSION + " Extension for adobe air</b></font>";
			_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			this.addChild(_txt);
			
			_body = new Sprite();
			this.addChild(_body);
			
			_list = new List();
			_list.holder = _body;
			_list.itemsHolder = new Sprite();
			_list.orientation = Orientation.VERTICAL;
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.space = BTN_SPACE;
			
			init();
			onResize();
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		private function handleActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
            {
				e.preventDefault();
				
				if (_ex) _ex.dispose();
				
				NativeApplication.nativeApplication.exit();
            }
		}
		
		private function onResize(e:*=null):void
		{
			if (_txt)
			{
				_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				
				C.x = 0;
				C.y = _txt.y + _txt.height + 0;
				C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				C.height = 250 * (1 / DeviceInfo.dpiScaleMultiplier);
			}
			
			if (_list)
			{
				_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
				_list.row = _numRows;
				_list.itemArrange();
			}
			
			if (_body)
			{
				_body.y = stage.stageHeight - _body.height;
			}
		}
		
		private function init():void
		{
			// initialize the extension
			_ex = new Speech();
			_ex.googleApiKey = "*****"; // used for the iOS part only
			_ex.proxyPath = "http://yoursite.com/proxy_TTS_API.php"; // used for the iOS part only
			_ex.addEventListener(SpeechEvent.INITIALIZATION, onInitialization);
			_ex.addEventListener(SpeechEvent.TTS_SUPPORTED_LANGS, onTTS_langs); // supported TTS langs will be dispatched immifietly after a successfull SpeechEvent.INITIALIZATION
			_ex.addEventListener(SpeechEvent.STT_SUPPORTED_LANGS, onSTT_langs); // supported STT langs will take a few seconds to be dispatched. (we really can't know what is happening inside android core, but it takes a few seconds!)
			_ex.addEventListener(SpeechEvent.ERROR, onError);
			_ex.addEventListener(SpeechEvent.SPEECH_STATE, onSpeechState);
			_ex.addEventListener(SpeechEvent.RECOGNITION_RESULTS, onSpeechResult);
			
			var btn0:MySprite = createBtn("Text to Speech: \"hello World\"");
			btn0.alpha = 0.5;
			_list.add(btn0);
			
			var btn1:MySprite = createBtn("Text to Speech (play silence test)");
			btn1.alpha = 0.5;
			_list.add(btn1);
			
			var btn2:MySprite = createBtn("Stop Text to Speech");
			btn2.alpha = 0.5;
			_list.add(btn2);
			
			var btn5:MySprite = createBtn("start listening to you... talk English", 0xCCCCCC);
			btn5.alpha = 0.5;
			_list.add(btn5);
			
			var btn6:MySprite = createBtn("Stop listening", 0xCCCCCC);
			btn6.alpha = 0.5;
			_list.add(btn6);
			
			// check if the extension is supported on this device
			if (!_ex.isSupported)
			{
				C.log("Speech API is not supported! there must be something wrong in your .ane implimentation OR maybe you are not connected to internet?!");
			}
			else
			{
				C.log("SpeechAPI V" + Speech.VERSION + " is supported");
				C.log("now, waiting for the extension initialization...");
			}
			
			function onInitialization(e:SpeechEvent):void
			{
				C.log("initialaztion was successful: " + e.param);
				if (e.param == true)
				{
					C.log("you should wait for the list of supported languages for TTS and STT");
					C.log("if you are offline, TTS may work depending on what languages are available on your device. there may be no langs availble on your device if you are offline!");
					C.log("if you are offline STT can't work at all (there are some undocumented evidence that Google is supporting offline STT for new Android versions but nothing to be sure yet. when it is availble to developers, we will be updating this extension accordingly)")
					C.log("as soon as you have the list of supported languages for each method of TTS or STT, you will be able to start working with them.")
				}
			}
			
			function onTTS_langs(e:SpeechEvent):void
			{
				if (!_ex.isSupportedTTS)
				{
					C.log("no language is available for TTS! even if you are offline, there should be atleast one offline lang availble, usually en_US");
					C.log("if you are seeing this message, there must be something wrong with your device, please test google TTS on other apps and if they work, please contact us for support: tahadaf@gmail.com");
					return;
				}
				
				C.log("number of supported langs for TTS = " + e.param.length);
				
				trace("------- availble TTS languages ---------");
				for each (var item:String in e.param) 
				{
					trace(item);
				}
				trace("-----------------------------");
				
				// enable buttons to demo test how TTS works!
				btn0.addEventListener(MouseEvent.CLICK, tts);
				btn0.alpha = 1;
				
				btn1.addEventListener(MouseEvent.CLICK, ttsPlaySilence);
				btn1.alpha = 1;
				
				btn2.addEventListener(MouseEvent.CLICK, ttsStop);
				btn2.alpha = 1;
			}
			
			function onSTT_langs(e:SpeechEvent):void
			{
				if (!_ex.isSupportedSTT)
				{
					C.log("if you are seeing this message, maybe that's because you are running the extension while you are offline?");
					C.log("as we know, Google is not supporting offline Speech to Text! (there are some undocumented evidence that Google is supporting offline STT for new Android versions but nothing to be sure yet. when it is availble to developers, we will be updating this extension accordingly)")
					C.log("http://stackoverflow.com/questions/17616994/offline-speech-recognition-in-android-jellybean");
					return;
				}
				
				C.log("number of supported langs for STT = " + e.param.length);
				
				trace("------- availble STT languages ---------");
				for each (var item:String in e.param) 
				{
					trace(item);
				}
				trace("-----------------------------");
				
				// enable buttons to demo test how STT works!
				btn5.addEventListener(MouseEvent.CLICK, startListening);
				btn5.alpha = 1;
				
				btn6.addEventListener(MouseEvent.CLICK, stopListening);
				btn6.alpha = 1;
			}
			
			// -----------------------------------
			
			function tts(e:MouseEvent):void
			{
				C.log("wait for the engine to start talking...");
				
				_ex.volume = 100;
				_ex.tts("hello world!", "en", 1, 1, Speech.QUEUE_ADD);
				_ex.tts("You may call this method as many time as you wish.", "en", 1, 1, Speech.QUEUE_ADD);
				_ex.tts("and as long as the QUEUE option is set to true, it will play the voice just fine.", "en", 1, 1, Speech.QUEUE_ADD);
				_ex.tts("Just remember that you are limited to 4000 characters per call", "en", 1, 1, Speech.QUEUE_ADD);
			}
			
			function ttsPlaySilence(e:MouseEvent):void
			{
				C.log("wait for the engine to start talking...");
				
				_ex.volume = 100;
				_ex.tts("This is a play silence test and I am going to pause now!", "en", 1, 1, Speech.QUEUE_ADD);
				_ex.ttsPause(1000, Speech.QUEUE_ADD);
				_ex.tts("now, pause a little longer.", "en", 1, 1, Speech.QUEUE_ADD);
				_ex.ttsPause(2000, Speech.QUEUE_ADD);
				_ex.tts("and even longer", "en", 1, 1, Speech.QUEUE_ADD);
				_ex.ttsPause(3000, Speech.QUEUE_ADD);
				_ex.tts("I think you got the idea now!", "en", 1, 1, Speech.QUEUE_ADD);
			}
			
			function ttsStop(e:MouseEvent):void
			{
				_ex.stopTTS();
			}
			
			function startListening(e:MouseEvent):void
			{
				trace("startListening");
				_ex.startListening("en-US");
			}
			
			function stopListening(e:MouseEvent):void
			{
				C.log("wait for the engine to return your text SpeechEvent.RECOGNITION_RESULTS ...");
				_ex.stopListening();
			}
		}
		
		private function onError(e:SpeechEvent):void
		{
			C.log("ERROR: " + e.param.msg);
		}
		
		private function onSpeechState(e:SpeechEvent):void
		{
			C.log("SpeechState= " + e.param.state + " (" + e.param.msg + ")");
		}
		
		private function onSpeechResult(e:SpeechEvent):void
		{
			var result:Array = e.param;
			C.log("Speech to Text results are:");
			for each (var item:String in result) 
			{
				C.log(item);
			}
			C.log("-------------");
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function createBtn($str:String, $bgColor:uint=0xDFE4FF):MySprite
		{
			var sp:MySprite = new MySprite();
			sp.addEventListener(MouseEvent.MOUSE_OVER,  onOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,  onOut);
			//sp.addEventListener(MouseEvent.CLICK,  onOut);
			sp.bgAlpha = 1;
			sp.bgColor = $bgColor;
			sp.drawBg();
			sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
			sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
			
			function onOver(e:MouseEvent):void
			{
				if (!sp.hasEventListener(MouseEvent.CLICK)) return;
				
				sp.bgAlpha = 1;
				sp.bgColor = 0x000000;
				sp.drawBg();
			}
			
			function onOut(e:MouseEvent):void
			{
				if (!sp.hasEventListener(MouseEvent.CLICK)) return;
				
				sp.bgAlpha = 1;
				sp.bgColor = $bgColor;
				sp.drawBg();
			}
			
			var format:TextFormat = new TextFormat("Arimo", 16, 0x888888, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.mouseEnabled = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
			txt.defaultTextFormat = format;
			txt.text = $str;
			
			txt.y = sp.height - txt.height >> 1;
			sp.addChild(txt);
			
			return sp;
		}
	}
	
}