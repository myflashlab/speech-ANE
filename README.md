# Speech API ANE (Android+iOS)
The Speech API extension lets you convert Strings to voice files and vice versa without any annoying mic activities. the extension will work fully in the background. if you have downloaded language packages from Google, the extension will work with no internet connection required and if offline packages are not available, it will automatically load the voice file from internet.

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
_ex.addEventListener(SpeechEvent.TTS_SUPPORTED_LANGS, onTTS_langs);
_ex.addEventListener(SpeechEvent.STT_SUPPORTED_LANGS, onSTT_langs);
    
// check if the extension is supported on this device
if (!_ex.isSupported)
{
    trace("Speech API is not supported! there must be something wrong in your .ane implimentation or your air manifest setup!")
    return;
}
else
{
    trace("SpeechAPI V"+Speech.VERSION+" is successfully initialized.");
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

**NOTICE: if you are trying to run the extension on an iOS device, you will need a Google Browser API key enabled for the Speech API. if you are running on an Android device, you won’t need this set at all. do the following to obtain your key: http://myappsnippet.com/DOC/com/doitflash/air/extensions/speech/Speech.html#googleApiKey

and again, on the iOS part, you need to copy a pre-written php file to your server and let the extension connect to there. read here: #proxyPath**