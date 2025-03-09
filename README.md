## About

`SetStateAsync` is a mixin that defers multiple `setState` calls into one within the same event loop.

This approach helps reduce overhead when calling `setState` multiple times in quick succession, preventing *[setState() or markNeedsBuild() called during build](https://www.google.com/search?q=setState()+or+markNeedsBuild()+called+during+build)* or *[setState() or markNeedsBuild() called when widget tree was locked](https://www.google.com/search?q=setState()+or+markNeedsBuild()+called+when+widget+tree+was+locked)* issue and improving performance.

## Installation

1. Run `flutter pub add set_state_async` to add this package to your project.
2. Add `import 'package:set_state_async/set_state_async.dart';` to your dart file.
3. Add `with SetStateAsync` to your `State` class.

## Usage

Just call `setStateAsync` instead of `setState`. An optional callback can be passed if you need to perform changes just before rebuilding the widget.

For more information, please check [example](https://pub.dev/packages/set_state_async/example) or [API reference](https://pub.dev/documentation/set_state_async/latest/set_state_async/SetStateAsync/setStateAsync.html).