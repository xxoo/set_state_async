## About

`SetStateAsync` is a mixin that defers multiple `setState` calls into one within the same event loop.

This approach helps reduce overhead when calling `setState` multiple times in quick succession, preventing the *[setState() or markNeedsBuild() called during build](https://www.google.com/search?q=setState%28%29+or+markNeedsBuild%28%29+called+during+build)* issue and improving performance.

## Installation

Run `flutter pub add set_state_async` to add this package to your project.

## Usage

Just add this mixin to your `State` class and call `setStateAsync` instead of `setState`. An optional callback can be passed if you need to perform changes just before rebuilding the widget.

For more information, please check [example](https://pub.dev/xxoo/set_state_async/example) or [API reference](https://pub.dev/documentation/set_state_async/latest/index/SetStateAsync/setStateAsync.html).