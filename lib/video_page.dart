import 'package:example_video_orientation/full_screen_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    true
        ? context.pushTransition(
          type: PageTransitionType.fade,
          child: FullScreenVideo(controller: _controller),
        )
        // ? Navigator.of(context).push(
        //   PageRouteBuilder(
        //     transitionDuration: const Duration(milliseconds: 200),
        //     pageBuilder: (context, animation, secondaryAnimation) {
        //       return FullScreenVideo(controller: _controller);
        //     },
        //     transitionsBuilder: (
        //       context,
        //       animation,
        //       secondaryAnimation,
        //       child,
        //     ) {
        //       return FadeTransition(
        //         opacity: animation,
        //         child: CupertinoFullscreenDialogTransition(
        //           primaryRouteAnimation: animation,
        //           secondaryRouteAnimation: secondaryAnimation,
        //           linearTransition: false,
        //           child: child,
        //         ),
        //       );
        //     },
        //   ),
        // )
        // .then((_) {
        //   SystemChrome.setPreferredOrientations([
        //     DeviceOrientation.portraitUp,
        //   ]);
        //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        // })
        // Navigator.of(context).push(
        //   // PageRouteBuilder(
        //   //   transitionDuration: const Duration(milliseconds: 200),
        //   //   pageBuilder: (context, animation, secondaryAnimation) {
        //   //     return FullScreenVideo(controller: _controller);
        //   //   },
        //   //   // reverseTransitionDuration: Duration.zero,
        //   //   fullscreenDialog: false,
        //   //   transitionsBuilder: (
        //   //     context,
        //   //     animation,
        //   //     secondaryAnimation,
        //   //     child,
        //   //   ) {
        //   //     return ScaleTransition(scale: animation, child: child);
        //   //   },
        //   //   // builder: (context) => FullScreenVideo(controller: _controller),
        //   // ),
        //   PageRouteBuilder(
        //     transitionDuration: const Duration(milliseconds: 200),
        //     pageBuilder: (context, animation, secondaryAnimation) {
        //       return FullScreenVideo(controller: _controller);
        //     },
        //     transitionsBuilder: (
        //       context,
        //       animation,
        //       secondaryAnimation,
        //       child,
        //     ) {
        //       return FadeTransition(opacity: animation, child: child);
        //     },
        //   ),
        // )
        // .then((_) {
        //   SystemChrome.setPreferredOrientations([
        //     DeviceOrientation.portraitUp,
        //   ]);
        //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        // })
        : Navigator.of(context)
            .push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FullScreenVideo(controller: _controller);
                },
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            )
            .then((_) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 10;
    double videplayerHeight = 200;
    // double videplayerWidth = 1.666 * videplayerHeight;
    double videplayerWidth = _controller.value.aspectRatio * videplayerHeight;
    return Scaffold(
      appBar: AppBar(title: const Text('Video Demo')),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height, // Ограничиваем высоту
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _controller.value.isInitialized
                  // true
                  ? Stack(
                    children: [
                      // Hero(
                      //   tag: "video",
                      //   flightShuttleBuilder: (
                      //     flightContext,
                      //     animation,
                      //     flightDirection,
                      //     fromHeroContext,
                      //     toHeroContext,
                      //   ) {
                      //     //     // final slideAnimation = Tween<Offset>(
                      //     //     //   begin: const Offset(0.0, 1.0),
                      //     //     //   end: Offset.zero,
                      //     //     // ).animate(
                      //     //     //   CurvedAnimation(
                      //     //     //     parent: animation,
                      //     //     //     curve: Curves.easeInOut,
                      //     //     //   ),
                      //     //     // );
                      //     final scaleAnimetion = Tween<double>(
                      //       begin: 4,
                      //       end: 1,
                      //     ).animate(
                      //       CurvedAnimation(
                      //         parent: animation,
                      //         curve: Curves.easeInOut,
                      //       ),
                      //     );
                      //     if (flightDirection == HeroFlightDirection.push) {
                      //       return RotationTransition(
                      //         turns: animation,
                      //         child: FadeTransition(
                      //           opacity: animation,
                      //           child: toHeroContext.widget,
                      //         ),
                      //       );
                      //     } else {
                      //       return ScaleTransition(
                      //         scale: scaleAnimetion,
                      //         child: FadeTransition(
                      //           opacity: animation,
                      //           child: fromHeroContext.widget,
                      //         ),
                      //       );
                      //     }
                      //   },
                      //   child:
                      Align(
                        alignment: Alignment.center,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Hero(
                            tag: 'video',
                            child: SizedBox(
                              height: videplayerHeight,
                              width: videplayerWidth,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        ),
                      ),
                      // ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.fullscreen,
                            color: Colors.black,
                          ),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FullScreenDialog extends StatefulWidget {
  final VideoPlayerController controller;
  const FullScreenDialog({super.key, required this.controller});

  @override
  State<FullScreenDialog> createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog>
    with TickerProviderStateMixin {
  late AnimationController _primary, _secondary;
  late Animation<double> _animationPrimary, _animationSecondary;

  @override
  void initState() {
    //Primaty
    _primary = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationPrimary = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _primary, curve: Curves.easeOut));
    //Secondary
    _secondary = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animationSecondary = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _secondary, curve: Curves.easeOut));
    _primary.forward();
    super.initState();
  }

  @override
  void dispose() {
    _primary.dispose();
    _secondary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFullscreenDialogTransition(
      primaryRouteAnimation: _animationPrimary,
      secondaryRouteAnimation: _animationSecondary,
      linearTransition: false,
      child: FullScreenVideo(controller: widget.controller),
    );
  }
}
