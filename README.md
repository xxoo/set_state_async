## About

`SetStateAsync` is a mixin that defers multiple `setState` calls into one within the same event loop.

This approach helps reduce overhead when calling `setState` multiple times in quick succession, preventing *setState() or markNeedsBuild() called [during build](https://www.google.com/search?q=setState()+or+markNeedsBuild()+called+during+build)* or *[when widget tree was locked](https://www.google.com/search?q=setState()+or+markNeedsBuild()+called+when+widget+tree+was+locked)* issue and improving performance.

## Installation

1. Run the following command in your project directory:
```shell
flutter pub add set_state_async
```
2. Add the following code to your dart file:
```dart
import 'package:set_state_async/set_state_async.dart';
```
3. Add `SetStateAsync` mixin to your `State` class:
```dart
class _MyWidgetState extends State<MyWidget> with SetStateAsync {
	// ...
}
```

## Usage

Just call `setStateAsync` instead of `setState`. An optional callback can be passed if you need to perform changes just before rebuilding the widget.

For more information, please check [example](https://pub.dev/packages/set_state_async/example) or [API reference](https://pub.dev/documentation/set_state_async/latest/set_state_async/SetStateAsync/setStateAsync.html).