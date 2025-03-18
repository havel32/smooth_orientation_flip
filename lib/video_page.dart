import 'package:example_video_orientation/full_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  State<VideoApp> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
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
  }

  void _toggleFullScreen() {

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FullScreenVideo(controller: _controller),
    //   ),
    // );
    context.pushTransition(
      type: PageTransitionType.fade,
      childBuilder: (context) => FullScreenVideo(controller: _controller),
    );

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    // Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //     transitionDuration: const Duration(milliseconds: 200),
    //     pageBuilder: (context, animation, secondaryAnimation) {
    //       return FullScreenVideo(controller: _controller);
    //     },
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       // final slideAnimation = Tween<Offset>(
    //       //   begin: const Offset(0.0, 1.0),
    //       //   end: Offset.zero,
    //       // ).animate(
    //       //   CurvedAnimation(parent: animation, curve: Curves.easeInOut),
    //       // );
    //       return
    //       //  SlideTransition(
    //       //   position: slideAnimation,
    //       //   child:
    //       FadeTransition(
    //         opacity: animation,
    //         child: child,
    //         // )
    //       );
    //     },
    //   ),
    // )
    // .then((_) {
    //   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // })
    ;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 8;
    double videplayerHeight = 200;
    double videplayerWidth = 1.666 * videplayerHeight;
    // double videplayerWidth = _controller.value.aspectRatio * videplayerHeight;
    return Scaffold(
      appBar: AppBar(title: const Text('Video Demo')),
      body: Column(
        children: [
          _controller.value.isInitialized
              // true
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
                      // Container(color: Colors.green),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(Icons.fullscreen, color: Colors.black),
                        onPressed: _toggleFullScreen,
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: IconButton(
                    //     onPressed: () {
                    //       setState(() {
                    //         _controller.value.isPlaying
                    //             ? _controller.pause()
                    //             : _controller.play();
                    //       });
                    //     },
                    //     icon: Icon(Icons.play_arrow, color: Colors.white),
                    //   ),
                    // ),
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
                return Container(
                  color: Colors.red,
                  child: Stack(
                    children: [
                      Image.network(
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                        "https://img.freepik.com/free-photo/street-with-trees-sides_1194-1228.jpg?semt=ais_hybrid",
                      ),
                      Text("dwadawdawdawdawd"),
                    ],
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
