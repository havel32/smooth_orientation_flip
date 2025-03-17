import 'package:example_video_orientation/full_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  State<VideoApp> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  _VideoAppState();
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        ),
      )
      ..initialize().then((_) {
        setState(() {});
      });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  void _toggleFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideo(controller: _controller),
        // fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    double videplayerHeight = 200;
    double videplayerWidth = _controller.value.aspectRatio * videplayerHeight;
    // print(_controller.value.aspectRatio);
    return Scaffold(
      appBar: AppBar(title: const Text('Video Demo')),
      body: Column(
        children: [
          _controller.value.isInitialized
              ? SizedBox(
                height: videplayerHeight,
                width: videplayerWidth,
                child: Stack(
                  children: [
                    Hero(
                      tag: 'video',
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: SizedBox(
                          height: videplayerHeight,
                          width: videplayerWidth,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(Icons.fullscreen, color: Colors.black),
                        onPressed: _toggleFullScreen,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        icon: Icon(Icons.play_arrow, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
              : Container(),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
              ),
              itemCount: 18,
              itemBuilder: (context, index) {
                return ColoredBox(
                  color: Color.fromRGBO(
                    index * 5,
                    index * 4,
                    index * 3,
                    index * 0.2,
                  ),
                  child: ListTile(
                    title: Text(index.toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
