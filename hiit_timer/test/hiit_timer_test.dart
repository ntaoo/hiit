import 'package:async/async.dart';
import 'package:test/test.dart';

import 'package:hiit_timer/src/hiit_timer.dart';

import 'helpers.dart';

void main() {
  test(HiitTimer, () async {
    final timer =
        HiitTimer(readySeconds: 3, goSeconds: 3, breakSeconds: 2, sets: 2);

    final sg = StreamGroup();
    await sg.add(timer.phase);
    await sg.add(timer.readyCountDown);
    await sg.add(timer.countDownTick);
    final q = StreamQueue(sg.stream);

    timer.startTriggered.add(null);

    expect(await q.next, Phase.initial);
    expect(await q.next, Phase.ready);
    expect(await q.next, 3);
    expect(await q.next, 2);
    expect(await q.next, 1);
    expect(await q.next, Phase.started);
    expectTick(await q.next, Tick(3, 1, Kind.goTime));
    expectTick(await q.next, Tick(2, 1, Kind.goTime));
    expectTick(await q.next, Tick(1, 1, Kind.goTime));
    expectTick(await q.next, Tick(2, 1, Kind.breakTime));
    expectTick(await q.next, Tick(1, 1, Kind.breakTime));
    expectTick(await q.next, Tick(3, 2, Kind.goTime));
    expectTick(await q.next, Tick(2, 2, Kind.goTime));
    expectTick(await q.next, Tick(1, 2, Kind.goTime));
    expectTick(await q.next, Tick(2, 2, Kind.breakTime));
    expectTick(await q.next, Tick(1, 2, Kind.breakTime));
    expect(await q.next, Phase.finished);
  });
}
