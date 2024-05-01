import 'package:august_plus/src/screen/pages/bottom_nav/home/components/home_third_container/emotion_card.dart';
import 'package:flutter/material.dart';

import 'package:weather/weather.dart';

class HomeUpperThirdContainer extends StatefulWidget {
  final Weather wdata;

  const HomeUpperThirdContainer({
    Key? key,
    required this.wdata,
  }) : super(key: key);

  @override
  State<HomeUpperThirdContainer> createState() =>
      _HomeUpperThirdContainerState();
}

class _HomeUpperThirdContainerState extends State<HomeUpperThirdContainer> {
  String? selectedEmoji;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "How's Your Mood Today?",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Your onPressed logic here
              },
              child: const Text('See More'),
            ),
          ],
        ),
        const SizedBox(height: 10), // Add space between the text and emoji row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              EmoticonCard(
                emoticonFace: '😔',
                mood: 'Badly',
                onPressed: () {
                  setState(() {
                    selectedEmoji = '😔';
                  });
                },
                isSelected: selectedEmoji == '😔',
              ),
              SizedBox(width: 10), // Add space between emojis
              EmoticonCard(
                emoticonFace: '😊',
                mood: 'Fine',
                onPressed: () {
                  setState(() {
                    selectedEmoji = '😊';
                  });
                },
                isSelected: selectedEmoji == '😊',
              ),
              SizedBox(width: 10), // Add space between emojis
              EmoticonCard(
                emoticonFace: '😁',
                mood: 'Well',
                onPressed: () {
                  setState(() {
                    selectedEmoji = '😁';
                  });
                },
                isSelected: selectedEmoji == '😁',
              ),
              SizedBox(width: 10), // Add space between emojis
              EmoticonCard(
                emoticonFace: '😃',
                mood: 'Excellent',
                onPressed: () {
                  setState(() {
                    selectedEmoji = '😃';
                  });
                },
                isSelected: selectedEmoji == '😃',
              ),
            ],
          ),
        ),
        SizedBox(height: 10), // Add space between emojis row and selected emoji
        selectedEmoji != null
            ? Text(
                'Selected Emoji: $selectedEmoji',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            : SizedBox(), // Show selected emoji if not null, otherwise show nothing
      ],
    );
  }
}
