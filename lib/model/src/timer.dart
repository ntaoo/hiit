import 'dart:async';
import 'package:async/async.dart';
import 'package:meta/meta.dart';

enum Kind { goTime, breakTime }

class Tick {
  const Tick(this.count, this.set, this.kind);
  final int count;
  final int set;
  final Kind kind;
}

class HiitTimer {
  factory HiitTimer(
      {@required int goSeconds,
      @required int breakSeconds,
      @required int sets}) {
    assert(goSeconds >= 1);
    assert(breakSeconds >= 1);
    assert(sets >= 1);

    return HiitTimer._(
        Stream.fromIterable(List.generate(
            sets,
            (index) => [
                  WorkoutCountdown(goSeconds, index + 1, Kind.goTime),
                  WorkoutCountdown(breakSeconds, index + 1, Kind.breakTime)
                ]).expand((pair) => pair).toList()),
        sets);
  }

  HiitTimer._(this._workoutCountDowns, this.totalSets);

  final Stream<WorkoutCountdown> _workoutCountDowns;

  final int totalSets;

  Stream<Tick> start() async* {
    await for (final countDown in _workoutCountDowns) {
      await for (final tick in countDown.start()) {
        yield tick;
      }
    }
  }
}

class WorkoutCountdown {
  WorkoutCountdown(this._count, this._set, this._kind);

  final int _count;
  final int _set;
  final Kind _kind;

  Stream<Tick> start() =>
      CountDown(_count).start().map((c) => Tick(c, _set, _kind));
}

class CountDown {
  CountDown(int count)
      : _initial = count,
        _rest = count - 1;

  @visibleForTesting
  static const Duration duration = Duration(seconds: 1);
  final int _initial;
  final int _rest;

  /// Counts from [_initial] to 0.
  Stream<int> start() {
    return StreamGroup.merge([
      // Sends initial count immediately.
      Stream.fromIterable([_initial]),
      // The rest counts.
      Stream.periodic(duration, (count) => _rest - count)
    ]).takeWhile((count) => count >= 1);
  }
}
