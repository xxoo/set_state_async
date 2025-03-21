import 'dart:async';
import 'dart:developer';
import 'package:flutter/widgets.dart';

/// This mixin is to avoid "[setState] while building or locked" issue and improve performance.
mixin SetStateAsync<T extends StatefulWidget> on State<T> {
  final _fns = <VoidCallback>[];
  Future<void>? _future;

  /// Defers multiple [setState] operations into one within the same event loop.
  /// All [fn]s will be called by the same [setState] operation if supplied.
  /// The returned [Future] will complete after the [setState] operation is done.
  Future<void> setStateAsync({VoidCallback? fn}) {
    if (fn != null) {
      _fns.add(fn);
    }
    if (_future == null) {
      final completer = Completer<void>();
      _future = completer.future;
      // Future.microtask() is not suitable here cause it has own error handling logic.
      scheduleMicrotask(() {
        if (mounted) {
          setState(() {
            var errs = 0;
            for (var i = 0; i < _fns.length; i++) {
              var err = true;
              try {
                _fns[i]();
                err = false;
              } finally {
                if (err) {
                  errs++;
                  continue; // ignore: control_flow_in_finally
                }
              }
            }
            if (errs > 0) {
              log(
                '$errs callback(s) failed. You may find them out with a debugger.',
                name: 'setStateAsync',
                level: 900, // WARNING
              );
            }
          });
        }
        _fns.clear();
        _future = null;
        completer.complete();
      });
    }
    return _future!;
  }
}
