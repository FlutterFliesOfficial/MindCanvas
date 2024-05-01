import 'package:august_plus/src/screen/pages/bottom_nav/home/components/home_third_container/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmoticonCard extends StatelessWidget {
  const EmoticonCard(
      {super.key,
      required this.emoticonFace,
      required this.mood,
      required Null Function() onPressed,
      required bool isSelected});

  final String emoticonFace;
  final String mood;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<HomeBloc>().add(
              MoodChangedEvent(mood: emoticonFace),
            );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 10,
              left: 17,
              right: 17,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                10.0,
              ),
              color: Colors.blue[600],
            ),
            child: Text(
              emoticonFace,
              style: const TextStyle(
                fontSize: 50.0,
              ),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            mood,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class MoodChangedEvent extends HomeEvent {
  final String mood;

  MoodChangedEvent({required this.mood});
}

class IndexChangedEvent extends HomeEvent {
  final int selectedIndex;

  IndexChangedEvent({required this.selectedIndex});
}

@immutable
abstract class HomeEvent {}
