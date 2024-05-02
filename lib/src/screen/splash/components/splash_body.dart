import 'package:august_plus/service/DS/decision_screen.dart';
import 'package:flutter/material.dart';

import '../../../package/custom_splash_screen.dart';
import '../design/splash_content.dart';

List<Map<String, String>> splashData = [
  {
    'image': 'assets/images/t.jpeg',
    'text': "Autism is my superpower, what's yours?",
  },
  {
    'image': 'assets/images/pp.jpeg',
    'text': "Communication is not just talking, it's also listening.",
  },
  {
    'image': 'assets/images/m.jpeg',
    'text':
        "Ready to begin? Let's explore how we can assist You  and provide support .",
  },
];

List<Color> color = [
  Colors.white,
  Colors.white,
  Colors.white,
  const Color(0xFFEFE0F3),
];

class SplashBody extends StatelessWidget {
  const SplashBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CurvedSplashScreen(
        backText: "Back",
        backgroundColor: Colors.white,
        screensLength: splashData.length,
        screenBuilder: (index) {
          return SplashContent(
            image: splashData[index]["image"],
            text: splashData[index]["text"],
            color: color[index],
          );
        },
        onSkipButton: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DecisionScreen()));
        },
      ),
    );
  }
}
