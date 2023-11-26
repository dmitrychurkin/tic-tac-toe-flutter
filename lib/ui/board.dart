import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/core.dart';
import 'package:tic_tac_toe/ui/ui.dart';

final class Board extends StatelessWidget {
  const Board({super.key, required this.onTap, required this.gameplay});

  final void Function(int index) onTap;
  final Gameplay gameplay;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400
      ),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        padding: const EdgeInsets.all(5),
        children: List.generate(
            9,
            (int index) => Field(
                  player: gameplay.matrix[index],
                  onTap: onTap,
                  index: index,
                )),
      ),
    );
  }
}
