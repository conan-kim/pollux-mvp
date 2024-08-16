import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:logger/logger.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  bool isRecording = false;
  String videoPath = "";

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.isNotEmpty) {
        controller = CameraController(cameras[0], ResolutionPreset.high);
        controller?.initialize().then((_) {
          if (!mounted) return;
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void toggleRecording() async {
    if (isRecording) {
      XFile videoFile = await controller!.stopVideoRecording();
      logger.d("----videoFile : ${videoFile.path}");
      saveVideo(videoFile);
    } else {
      await controller!.startVideoRecording();
    }
    setState(() {
      isRecording = !isRecording;
    });
  }

  Future<void> saveVideo(XFile videoFile) async {
    try {
      String newPath = videoFile.path;
      if (newPath.endsWith('.temp')) {
        newPath = newPath.replaceAll('.temp', '.mp4');
        await File(videoFile.path).rename(newPath);
      }
      final bool? isVideoSaved = await GallerySaver.saveVideo(newPath);
      videoPath = newPath;
      logger.d("isVideoSaved : ${videoPath}");
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(videoFile.path)));
      if (isVideoSaved != null && isVideoSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Video is saved successfully")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Column(
        children: [
          if (videoPath != "") Text("Video Path: $videoPath"), // 비디오 경로 표시
          CameraPreview(controller!),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleRecording,
        child: Icon(isRecording ? Icons.stop : Icons.videocam),
      ),
    );
  }
}
