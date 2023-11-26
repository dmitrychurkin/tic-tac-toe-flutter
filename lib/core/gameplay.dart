import 'package:tic_tac_toe/core/player.dart';

abstract interface class Gameplay {
  Player? makePlayerPace(int index);

  Map<int, Player?> get matrix;

  void restart();
}
