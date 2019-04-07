// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:async/async.dart';
import 'package:hiit/model/src/timer.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  test(HiitTimer, () async {
    final goSeconds = 3;
    final breakSeconds = 2;
    final sets = 2;
    final hiit =
        HiitTimer(goSeconds: goSeconds, breakSeconds: breakSeconds, sets: sets);

    final ticks = StreamQueue<Tick>(hiit.start());
    expectTick(await ticks.next, Tick(3, 1, Kind.goTime));
    expectTick(await ticks.next, Tick(2, 1, Kind.goTime));
    expectTick(await ticks.next, Tick(1, 1, Kind.goTime));
    expectTick(await ticks.next, Tick(2, 1, Kind.breakTime));
    expectTick(await ticks.next, Tick(1, 1, Kind.breakTime));
    expectTick(await ticks.next, Tick(3, 2, Kind.goTime));
    expectTick(await ticks.next, Tick(2, 2, Kind.goTime));
    expectTick(await ticks.next, Tick(1, 2, Kind.goTime));
    expectTick(await ticks.next, Tick(2, 2, Kind.breakTime));
    expectTick(await ticks.next, Tick(1, 2, Kind.breakTime));
    expect(await ticks.hasNext, isFalse);
  });

  test(WorkoutCountdown, () async {
    int count = 5;
    final set = 1;

    final countDown = WorkoutCountdown(count, set, Kind.goTime);

    await for (var tick in countDown.start()) {
      expectTick(tick, Tick(count, set, Kind.goTime));
      count--;
    }
    expect(count, 0);
  });

  test(CountDown, () async {
    expect(CountDown.duration, Duration(seconds: 1));

    int count = 5;
    await CountDown(count).start().forEach((c) {
      expect(c, count);
      count--;
    });
    expect(count, 0);
  });
}
