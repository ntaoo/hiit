import 'package:hiit/model/src/timer.dart';
import 'package:test/test.dart';

void expectTick(Tick actual, Tick expected) {
  expect(actual.count, expected.count);
  expect(actual.set, expected.set);
  expect(actual.kind, expected.kind);
}
