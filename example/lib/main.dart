import 'dart:math';
import 'package:flutter/material.dart';
import 'package:set_state_async/set_state_async.dart';

void main() => runApp(const MaterialApp(home: AnimatedBuilderExample()));

class AnimatedBuilderExample extends StatefulWidget {
  const AnimatedBuilderExample({super.key});

  @override
  State<AnimatedBuilderExample> createState() => _AnimatedBuilderExampleState();
}

class _AnimatedBuilderExampleState extends State<AnimatedBuilderExample>
    with TickerProviderStateMixin, SetStateAsync {
  var _frames = 0;
  final _frameTimes = <int>[];
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  void _statistic() {
    _frames++;
    final now = DateTime.now().millisecondsSinceEpoch;
    while (_frameTimes.isNotEmpty && now - _frameTimes.first > 1000) {
      _frameTimes.removeAt(0);
    }
    _frameTimes.add(now);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.passthrough,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              child: Container(
                width: 200.0,
                height: 200.0,
                color: Colors.green,
                child: Center(child: Text('Whee!')),
              ),
              builder: (BuildContext context, Widget? child) {
                // setState will cause error if called here.
                // setState(_statistic);

                // But you can use setStateAsync instead. _statistic will be called just before rendering.
                setStateAsync(fn: _statistic);

                // Or you can perform changes immediately and call setStateAsync without parameter.
                // _statistic();
                // setStateAsync();

                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: child,
                );
              },
            ),
          ),
          Positioned(
            top: 20.0,
            left: 20.0,
            child: Text(
              'frames: $_frames\nfps: ${_frameTimes.length}\nangle: ${(_controller.value * 360).round()}°',
              style: const TextStyle(
                decoration: TextDecoration.none,
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      );
}
