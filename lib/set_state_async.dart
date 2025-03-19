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
    return _future ??= Future.microtask(() {
      if (mounted) {
        setState(() {
          for (var i = 0; i < _fns.length; i++) {
            try {
              _fns[i]();
            } finally {
              continue; // ignore: control_flow_in_finally
            }
          }
          _fns.clear();
          _future = null;
        });
      }
    });
  }
}
