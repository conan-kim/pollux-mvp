import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

import 'dart:io';

class VADTestPage extends StatefulWidget {
  @override
  _VADTestPageState createState() => _VADTestPageState();
}

class _VADTestPageState extends State<VADTestPage> {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String _filePath = "hihihi";

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  void _initializeRecorder() async {
    await _recorder.openRecorder();
    _recorder.setSubscriptionDuration(Duration(milliseconds: 100));
  }

  void _startRecording() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String path = '${tempDir.path}/temp.wav';
      logger.d("path error $path");
      await _recorder.startRecorder(toFile: path);
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      logger.d("_startRecording error $e.toString()");
    }
  }

  void _stopRecording() async {
    try {
      logger.d("Recording stopped??");
      String? path = await _recorder.stopRecorder();
      logger.d("Recording stopped $path");
      setState(() {
        _isRecording = false;
        _filePath = path ?? "";
      });
    } catch (e) {
      logger.d("Recording stopped $e.toString()");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VAD Test")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_filePath != "")
            ElevatedButton(
              onPressed: () => _playRecording(),
              child: Text("Play Recording"),
            ),
          Text(_filePath),
          ElevatedButton(
            onPressed: _isRecording ? _stopRecording : _startRecording,
            child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
          ),
        ],
      ),
    );
  }

  void _playRecording() {
    // Code to play back the recording
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}
