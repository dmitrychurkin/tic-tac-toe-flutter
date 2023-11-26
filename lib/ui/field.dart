import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/core.dart';

final class Field extends StatelessWidget {
  const Field({
    super.key,
    required this.onTap,
    required this.index,
    this.player,
  });

  final Player? player;
  final void Function(int index) onTap;
  final int index;

  IconData? get _icon => switch (player) {
        Player.O => Icons.circle_outlined,
        Player.X => Icons.close,
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(index),
      child: Ink(
        color: Colors.black,
        child: Icon(
          _icon,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
