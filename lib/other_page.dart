import 'package:example_video_orientation/video_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnotherPage extends StatelessWidget {
  const AnotherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('awdawdawdawdawdawdwadd'),
            Text('awdawdawdawdawdawdwadd'),
            Text('awdawdawdawdawdawdwadd'),
            Text('awdawdawdawdawdawdwadd'),
            Text('awdawdawdawdawdawdwadd'),
            Text('awdawdawdawdawdawdwadd'),
            Text('awdawdawdawdawdawdwadd'),
            Text('awdawdawdawdawdawdwadd'),
            Text('awdawdawdawdawdawdwadd'),
            Text('awdawdawdawdawdawdwadd'),
            Text('awdawdawdawdawdawdwadd'),
            Text('awdawdawdawdawdawdwadd'),
            IconButton.filled(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoApp(),
                    fullscreenDialog: true,
                  ),
                );
              },
              icon: Icon(Icons.video_collection_rounded),
            ),
            // InkWell(
            //   onTap: () {
            //     showDialog(context: context, builder: CupertinoFullscreenDialogTransition(primaryRouteAnimation: primaryRouteAnimation, secondaryRouteAnimation: secondaryRouteAnimation, child: child, linearTransition: linearTransition));
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
