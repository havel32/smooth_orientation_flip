import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController _controller;

  const FullScreenVideo({super.key, required VideoPlayerController controller})
    : _controller = controller;
  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  bool isVideoRotated = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => buildCompleteActions());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> changeOrientation() async {
    await Future.microtask(() async {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });
  }

  Future<void> buildCompleteActions() async {
    await Future.delayed(Durations.short2);
    await changeOrientation();
    isVideoRotated = true;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Hero(
        tag: 'video',
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: widget._controller.value.aspectRatio,
                child: SizedBox(child: VideoPlayer(widget._controller)),
              ),
            ),
            // ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 80),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.fullscreen_exit,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await Future.microtask(() async {
                        await SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                        ]);
                        await SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.edgeToEdge,
                        );
                      });
                      await Future.delayed(Durations.medium2);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(150),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      widget._controller.value.isPlaying
                          ? widget._controller.pause()
                          : widget._controller.play();
                    });
                  },
                  icon: Icon(Icons.play_arrow, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
