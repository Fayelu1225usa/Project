import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportPage extends StatefulWidget {
  final Function onUploadComplete;
  const ReportPage({
    Key key,
    @required this.onUploadComplete,
  }) : super(key: key);
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool _isPlaying;
  bool _isUploading;
  bool _isRecorded;
  bool _isRecording;

  AudioPlayer _audioPlayer;
  String _filePath;

  FlutterAudioRecorder _audioRecorder;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isRecorded
          ? _isUploading
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator()),
          Text('Uplaoding to Firebase'),
        ],
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: _onRecordAgainButtonPressed,
          ),
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _onPlayButtonPressed,
          ),
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: _onFileUploadButtonPressed,
          ),
        ],
      )
          : IconButton(
        icon: _isRecording
            ? Icon(Icons.pause)
            : Icon(Icons.fiber_manual_record),

        onPressed: _onRecordButtonPressed,

      ),
    );
  }

  Future<void> _onFileUploadButtonPressed() async {
    // FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    // setState(() {
    //   _isUploading = true;
    // });
    // try {
    //   await firebaseStorage
    //       .ref('upload-voice-firebase')
    //       .child(
    //       _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
    //       .putFile(File(_filePath));
    //   widget.onUploadComplete();
    // } catch (error) {
    //   print('Error occured while uplaoding to Firebase ${error.toString()}');
    //   Scaffold.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Error occured while uplaoding'),
    //     ),
    //   );
    // } finally {
    //   setState(() {
    //     _isUploading = false;
    //   });
    // }
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      print(_audioRecorder.current().asStream());

      _audioRecorder.stop();

      _isRecording = false;
      _isRecorded = true;

    } else {
      await _startRecording();
    }
    setState(() {});
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      _audioPlayer.play(_filePath, isLocal: true);
      _audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          _isPlaying = false;
        });
      });
    } else {
      _audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      //hrow RecordingPermissionException('Microphone permission not granted');
    }
    else{
      print("start");
      Directory directory = await getApplicationDocumentsDirectory();

      String filepath =  directory.path + '/temp.wav';
      createFile(File(filepath));
    }

  }

  Future<void> createFile(File file) async {
    try {
      if (await file.exists()) {
        file.delete();
        _audioRecorder =
            FlutterAudioRecorder(file.path, audioFormat: AudioFormat.WAV);
        await _audioRecorder.initialized;
        _audioRecorder.start();
        print(_audioRecorder.recording);
        _filePath = file.path;
        _isRecorded = false;
        _isRecording = true;
        setState(() {});
      }
      else {
        _audioRecorder =
            FlutterAudioRecorder(file.path, audioFormat: AudioFormat.WAV);
        await _audioRecorder.initialized;
        _audioRecorder.start();
        print(_audioRecorder.recording);
        _filePath = file.path;
        _isRecorded = false;
        _isRecording = true;
        setState(() {});
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }
}