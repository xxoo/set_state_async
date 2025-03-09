import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:set_state_async/set_state_async.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SetStateAsync {
  int? _current;
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Current Section: $_current')),
          body: InViewNotifierList(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 200,
            ),
            isInViewPortCondition: (double deltaTop, double deltaBottom,
                    double viewPortDimension) =>
                deltaTop < (0.5 * viewPortDimension) &&
                deltaBottom > (0.5 * viewPortDimension),
            builder: (context, index) => InViewNotifierWidget(
              id: '$index',
              child: Container(
                margin: index == 9 ? null : const EdgeInsets.only(bottom: 16),
                color:
                    index % 2 == 0 ? Colors.grey.shade300 : Colors.transparent,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Center(
                    child: Text(
                      'Section $index',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: _current == index ? FontWeight.bold : null,
                        color: _current == index ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              builder: (context, isInView, child) {
                if (isInView) {
                  final mod = index % 3;
                  if (mod == 0) {
                    // we may change _current just before the next frame
                    setStateAsync(fn: () => _current = index);
                  } else if (mod == 1) {
                    // we may also change _current immediately
                    _current = index;
                    setStateAsync();
                  } else {
                    try {
                      // but setState() will cause error in this case
                      setState(() => _current = index);
                    } catch (e) {
                      _current = index;
                      debugPrint('$e');
                    }
                  }
                }
                return child!;
              },
            ),
            itemCount: 10,
          ),
        ),
      );
}
