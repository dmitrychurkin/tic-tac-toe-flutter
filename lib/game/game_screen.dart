import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/core.dart';
import 'package:tic_tac_toe/ui/ui.dart';

final class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.title});

  final String title;

  @override
  State<GameScreen> createState() => _GameState();
}

class _GameState extends State<GameScreen> {
  late Gameplay _gameplay;

  @override
  void initState() {
    super.initState();
    _gameplay = GameplayController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Board(
        onTap: _onTap,
        gameplay: _gameplay,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _restart,
        tooltip: 'Restart',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      _checkWinner(_gameplay.makePlayerPace(index));
    });
  }

  void _checkWinner(Player? winner) {
    if (winner == null) {
      return;
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Winner is ${winner.name}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _restart();
                    },
                    child: const Text('Restart'))
              ],
            ));
  }

  void _restart() {
    setState(() {
      _gameplay.restart();
    });
  }
}
