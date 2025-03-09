import 'package:flutter/widgets.dart';

/// This mixin is for avoiding [setState] during build issue and improving performance.
mixin SetStateAsync<T extends StatefulWidget> on State<T> {
  final _fns = <VoidCallback>[];
  Future<void>? _future;

  void _runFns(int i) {
    try {
      while (i < _fns.length) {
        _fns[i++]();
      }
    } finally {
      if (i == _fns.length) {
        _fns.clear();
        _future = null;
      } else {
        _runFns(i);
      }
    }
  }

  /// Defers multiple [setState] operations into one within the same event loop.
  /// All [fn]s will be called by the same [setState] operation if supplied.
  /// The returned [Future] will complete after the [setState] operation is done.
  Future<void> setStateAsync({VoidCallback? fn}) {
    if (fn != null) {
      _fns.add(fn);
    }
    return _future ??= Future.microtask(() {
      if (mounted) {
        setState(() => _runFns(0));
      }
    });
  }
}
