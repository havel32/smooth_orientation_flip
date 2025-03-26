import 'dart:async';

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
  bool isOrientationSwitched = false;
  late final Stream _stream;
  int inactivityDuration = 0;
  late final StreamSubscription subscription;

  bool _isTapped = true;

  _VideoAppState();
  @override
  void initState() {
    // super.initState();
    // _controller = VideoPlayerController.asset(
    //     "/Users/ian/projects/example_video_orientation/assets/buffered/stream.m3u8",
    // )
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        ),
      )
      ..initialize().then((_) {
        setState(() {});
      });
    startCheckInactivity();
  }

  void startCheckInactivity() {
    _stream = Stream.periodic(const Duration(seconds: 1), (i) => i);
    subscription = _stream.listen((_) {
      if (_controller.value.isPlaying && (_isTapped)) {
        inactivityDuration++;
        if (inactivityDuration == 3) {
          _toggleOverlay();
        }
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    context.pushTransition(
      type: PageTransitionType.fade,
      // duration: Durations.medium2,
      child: FullScreenVideo(controller: _controller),
    );
  }

  void _toggleOverlay() {
    inactivityDuration = 0;
    if (_controller.value.isPlaying || _controller.value.isBuffering) {
      _isTapped = !_isTapped;
    } else {
      _isTapped = !_isTapped;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    final isVisible = ((_isTapped));
    double videoPlayerHeight = 200;
    double videoPlayerWidth = _controller.value.aspectRatio * videoPlayerHeight;
    var tag = 'video';
    return Scaffold(
      appBar: AppBar(title: const Text('Video Demo')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: videoPlayerHeight,
                  width: videoPlayerWidth,
                  child:
                      _controller.value.isInitialized
                          ? Hero(
                            tag: tag,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: SizedBox(
                                      height: videoPlayerHeight,
                                      width: videoPlayerWidth,
                                      child: VideoPlayer(_controller),
                                    ),
                                  ),
                                ),
                                // ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: _VideoDurationWidget(
                                    controller: _controller,
                                    heroTag: tag,
                                    isVisible: isVisible,
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
                                          _controller.value.isPlaying
                                              ? _controller.pause()
                                              : _controller.play();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          : SizedBox.shrink(),
                ),
                const SizedBox(height: 8),
                InputDecorator(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  child: Text("Camera 1"),
                ),
                const SizedBox(height: 8),
                RecordsGridList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecordsGridList extends StatelessWidget {
  const RecordsGridList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}

class _VideoDurationWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final String heroTag;
  final bool isVisible;

  const _VideoDurationWidget({
    required this.controller,
    required this.heroTag,
    required this.isVisible,
  });

  @override
  _VideoDurationWidgetState createState() => _VideoDurationWidgetState();
}

class _VideoDurationWidgetState extends State<_VideoDurationWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentDuration = _formatDuration(_controller.value.position);
    var maxDuration = _formatDuration(_controller.value.duration);

    return Container(
      height: 45,
      decoration: BoxDecoration(color: Colors.black38),
      child: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      (_controller.value.isInitialized)
                          ? "$currentDuration / $maxDuration"
                          : "",
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final double videoProgressHeight = 15.0;
                        final double circleRadius = 12;
                        var left =
                            _controller.value.position.inMilliseconds /
                            _controller.value.duration.inMilliseconds *
                            width;
                        print(left);
                        return Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  // bottom: 4,
                                  // right: 12,
                                  // left: 12,
                                  // horizontal: circleRadius,
                                ),
                                child: VideoProgressIndicator(
                                  _controller,
                                  allowScrubbing: true,
                                  colors: VideoProgressColors(
                                    playedColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(
                                _controller.value.position.inMilliseconds ==
                                        _controller
                                            .value
                                            .duration
                                            .inMilliseconds
                                    ? width - circleRadius / 2
                                    : left - circleRadius / 2,
                                // _controller
                                //         .value
                                //         .position
                                //         .inMilliseconds ==
                                //     0.0
                                // ? left - circleRadius / 2
                                // : left - circleRadius / 2
                                (videoProgressHeight - circleRadius) / 3,
                              ), // Adjust position
                              child: Container(
                                width: circleRadius,
                                height: circleRadius,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
                onTap: () {
                  context.pushTransition(
                    type: PageTransitionType.fade,
                    duration: Durations.medium1,
                    child: FullScreenVideo(
                      controller: _controller,
                      // heroTag: widget.heroTag,
                    ),
                  );
                },
                child: Center(
                  child: Icon(Icons.fullscreen_rounded, color: Colors.white),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 8),
            //   child: Container(
            //     color: Colors.cyan,
            //     child:
            // IconButton(
            //       icon: const Icon(Icons.fullscreen, color: Colors.white),
            //       onPressed: () {},
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
