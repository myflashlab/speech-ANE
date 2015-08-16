# Speech API ANE V6.0 (Android+iOS)
The Speech API extension lets you convert Strings to voice files and vice versa without any annoying mic activities. the extension will work fully in the background. if you have downloaded language packages from Google, the extension will work with no internet connection required and if offline packages are not available, it will automatically load the voice file from internet.

**Google has stopped TTS service for iOS so, you won't be able to use TTS on iOS side anymore. unless we find a new alternative, this is how it goes.**

checkout here for the commercial version: http://myappsnippet.com/google-speech-api-air-native-extension/

![Speech ANE](http://myappsnippet.com/wp-content/uploads/2013/04/google-speech-api-adobe-air-extension_preview.jpg)

you may like to see the ANE in action? check this out: https://github.com/myflashlab/speech-ANE/tree/master/FD/dist

**NOTICE: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.**

# AS3 API:
```actionscript
import com.doitflash.air.extensions.speech.Speech;
import com.doitflash.air.extensions.speech.SpeechEvent;

var _ex:Speech = new Speech();
_ex.addEventListener(SpeechEvent.INITIALIZATION, onInitialization);
_ex.addEventListener(SpeechEvent.TTS_SUPPORTED_LANGS, onTTS_langs); // will never be called on the iOS side
_ex.addEventListener(SpeechEvent.STT_SUPPORTED_LANGS, onSTT_langs);
_ex.addEventListener(SpeechEvent.SPEECH_FILE_SAVED, onFileSaved);
_ex.addEventListener(SpeechEvent.ERROR, onError);
_ex.addEventListener(SpeechEvent.SPEECH_STATE, onSpeechState);
_ex.addEventListener(SpeechEvent.RECOGNITION_RESULTS, onSpeechResult);
    
// check if the extension is supported on this device
if (!_ex.isSupported)
{
    trace("Speech API is not supported! there must be something wrong in your .ane implimentation or your air manifest setup!")
    return;
}
else
{
    trace("SpeechAPI V"+Speech.VERSION+" is supported");
    trace("now, waiting for the extension initialization...");
}

function onInitialization(e:SpeechEvent):void
{
    trace("initialaztion was successful: " + e.param);
}

function onTTS_langs(e:SpeechEvent):void
{
    trace("number of supported langs for TTS = " + e.param.length);
}

function onSTT_langs(e:SpeechEvent):void
{
    trace("number of supported langs for STT = " + e.param.length);
}

function onError(e:SpeechEvent):void
{
	trace("ERROR: " + e.param.msg);
}

function onSpeechState(e:SpeechEvent):void
{
	trace("SpeechState= " + e.param.state + " (" + e.param.msg + ")");
}
		
function onSpeechResult(e:SpeechEvent):void
{
	var result:Array = e.param;
	trace("Speech to Text results are:");
	for each (var item:String in result) 
	{
		trace(item);
	}
	trace("-------------");
}

function onFileSaved(e:SpeechEvent):void
{
	var file:File = new File(e.param);
	trace(file.nativePath)
}

function onFileSaved(e:SpeechEvent):void
{
	var file:File = new File(e.param);
	trace(file.nativePath)
}

// the following will run TTS and you can hear the words. (TTS is not supported on iOS)
_ex.tts("hello world!", "en", 1, 1, Speech.QUEUE_ADD/*, "tts/"*/);

// this will run TTS but you won't hear anything. instead, .wav files will be saved in your chosen folder
_ex.tts("hello world!", "en", 1, 1, Speech.QUEUE_ADD, "tts/");

// call this to stop TTS playback if _ex.isSpeaking is true
_ex.stopTTS();

// call the folloiwng to run and stop STT
_ex.startListening("en-US");
_ex.stopListening();
```

Don't forget to include the necessary permissions and services in the air manifest file application.xml

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />

<application>
    <service android:name="com.doitflash.speech.speechToText.SpeechRecognitionService">
..
..
```

**NOTICE: if you are trying to run the extension on an iOS device, you will need a Google Browser API key enabled for the Speech API for the STT to work. if you are running on an Android device, you won’t need this set at all. do the following to obtain your key: http://myappsnippet.com/DOC/com/doitflash/air/extensions/speech/Speech.html#googleApiKey (TTS won't work on iOS anymore. Google has stopped the service!)**

# Changelog
- Apr 24, 2013	>> V1.0: 	
  - beginning of the journey!
- May 19, 2013	>> V2.0: 	
  - added language, pitch and speech rate support
- May 21, 2014	>> V3.0:
  - Built the .java and .as codes from scratch! now the extension works with no annoying mic image activity!
- Dec 18, 2014	>> V4.0:
  - re-organized the as library to better manage the initialization and listeners
  - you can see what languages are supported on your device for TTS and STT separately
  - added new methods to the API like stopTTS, shutdownTTS and new properties like isSpeaking, isSupportedTTS, isSupportedSTT
  - when you are offline, the extension will still return the offline available languages so you can still use the TTS
  - when using Speech to text, you can specify what language the engine should listen to: _ex.startListening("en_US");
  - adding support for Android x86
- Feb 15, 2015	>> V5.0:
  - added iOS 64-bit support
  - removed wav file save option as it was not possible on iOS part (if you need it, keep using V4.0)
  - call "startListening" and start speaking into your phone. but remember to call "stopListening" when you're done!
  - added volume control for TTS sounds
- May 17, 2015	>> V5.1:
  - removed android-support-v4.jar dependency
- Aug 26, 2015	>> V6.0:
  - Added back .wav save option for TTS to the Android version with a new approach and easy to use
  - fixed volume problem
  - fixed force close termination problem on Android (you still need to dispose the extension when leaving the app)
  - disabled TTS on iOS because Google stopped TTS service for iOS. STT is working fine on iOS though.