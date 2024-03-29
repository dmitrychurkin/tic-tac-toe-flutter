import 'package:collection/collection.dart';
import 'package:tic_tac_toe/core/exceptions/business_invariant.dart';
import 'package:tic_tac_toe/core/gameplay.dart';
import 'package:tic_tac_toe/core/player.dart';

final class GameplayController implements Gameplay {
  static List<(int, int, int)> get winCombinations => [
        (0, 1, 2), // 1st row
        (3, 4, 5), // 2nd row
        (6, 7, 8), // 3rd row
        (0, 3, 6), // 1st column
        (1, 4, 7), // 2nd column
        (2, 5, 8), // 3rd column
        (0, 4, 8), // 1st diagonal
        (2, 4, 6), // 2nd diagonal
      ];

  final Map<int, Player?> _matrix = {
    0: null,
    1: null,
    2: null,
    3: null,
    4: null,
    5: null,
    6: null,
    7: null,
    8: null
  };

  @override
  Map<int, Player?> get matrix => _matrix;

  @override
  Player? makePlayerPace(int index) {
    try {
      _makePace(index: index, player: Player.X);
      _handleBotPace();
      return _checkWinner();
    } on BusinessInvariantException {
      return null;
    }
  }

  @override
  void restart() {
    _matrix.forEach((key, value) {
      _matrix[key] = null;
    });
  }

  Player? _checkWinner() {
    for (final record in winCombinations) {
      switch (record) {
        case (int a, int b, int c)
            when _checkRow(record: (a, b, c), player: Player.X):
          return Player.X;

        case (int a, int b, int c)
            when _checkRow(record: (a, b, c), player: Player.O):
          return Player.O;
      }
    }

    return null;
  }

  void _makePace({required int index, required Player player}) {
    if (_matrix[index] is Player) {
      throw BusinessInvariantException('This cell is already occupied');
    }

    _matrix[index] = player;
  }

  void _handleBotPace() {
    for (final strategy in [
      () => _getComputedCriticalPathIndex(player: Player.O),
      () => _getComputedCriticalPathIndex(player: Player.X),
      () => _getComputedCriticalPathIndex(player: Player.O, threshold: 1),
      _getRandomIndex,
    ]) {
      final index = strategy();

      if (index == null) {
        continue;
      }

      return _makePace(index: index, player: Player.O);
    }
  }

  bool _checkRow({required (int, int, int) record, required Player player}) {
    final (int a, int b, int c) = record;

    return [_matrix[a], _matrix[b], _matrix[c]]
        .every((element) => element == player);
  }

  int? _getComputedCriticalPathIndex(
      {required Player player, int threshold = 2}) {
    for (final record in winCombinations) {
      if (record case (int a, int b, int c)
          when [_matrix[a], _matrix[b], _matrix[c]]
                  .fold(0, (count, p) => (p == player) ? count + 1 : count) ==
              threshold) {
        return [a, b, c]
            .firstWhereOrNull((element) => _matrix[element] == null);
      }
    }

    return null;
  }

  int? _getRandomIndex() {
    final List<int> result = _matrix.entries.fold(
        [],
        (list, element) =>
            (element.value == null) ? [...list, element.key] : list)
      ..shuffle();

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }
}
