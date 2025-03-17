import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideo({super.key, required this.controller});

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => buildCompleteActions());
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   setState(() {
    //     rotation = 1;
    //   });
    // });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void changeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> buildCompleteActions() async {
    await Future.delayed(Durations.long3);

    changeOrientation();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: "video",
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
          ),
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
              onPressed: () async {
                await Future.microtask(() async {
                  await SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                  await SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.edgeToEdge,
                  );
                });

                await Future.delayed(const Duration(milliseconds: 200));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      // ),
    );
  }
}
