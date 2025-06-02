import 'dart:async';
import 'package:flutter/widgets.dart';

class _Task {
  final completer = Completer<int>();
  final VoidCallback fn;
  _Task(this.fn);
}

/// This mixin is to avoid **[setState] while widget is building or locked** issue and improve performance.
mixin SetStateAsync<T extends StatefulWidget> on State<T> {
  final _tasks = <_Task>[];
  Completer<int>? _completer;

  /// Batches multiple [setState] calls into a single operation within the current event loop.
  ///
  /// This improves performance by executing multiple state updates in one [setState] call.
  /// Returns a [Future] with status code: 0 if [State] is disapoed, 1 if completed successfully.
  /// When providing [fn], the status code could also be -1 if error occurs.
  Future<int> setStateAsync({VoidCallback? fn}) {
    if (_completer == null) {
      _completer = Completer();
      // Future.microtask() is not suitable here cause it has own error handling logic.
      scheduleMicrotask(() {
        if (mounted) {
          setState(() {
            _completer!.complete(1);
            for (final task in _tasks) {
              var status = -1;
              // Allow execution to proceed to subsequent tasks if an error occurs
              // while preserving uncaught exception behavior for debugging
              try {
                task.fn();
                status = 1;
              } finally {
                task.completer.complete(status);
                continue; // ignore: control_flow_in_finally
              }
            }
          });
        } else {
          _completer!.complete(0);
          for (final task in _tasks) {
            task.completer.complete(0);
          }
        }
        _tasks.clear();
        _completer = null;
      });
    }
    if (fn == null) {
      return _completer!.future;
    } else {
      final task = _Task(fn);
      _tasks.add(task);
      return task.completer.future;
    }
  }
}
