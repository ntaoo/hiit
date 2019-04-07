import 'dart:async';
import 'package:hiit/model/src/defaults.dart';
import 'package:rxdart/rxdart.dart';
import 'timer.dart' as timer;

export 'timer.dart' show Tick, Kind;

enum Phase { initial, ready, started, finished }

class HiitTimer {
  HiitTimer(
      {int readySeconds = Defaults.readySeconds,
      int goSeconds = Defaults.goSeconds,
      int breakSeconds = Defaults.breakSeconds,
      int sets = Defaults.sets})
      : _timer = timer.HiitTimer(
            goSeconds: goSeconds, breakSeconds: breakSeconds, sets: sets) {
    _phaseSubject.add(Phase.initial);

    _startTriggeredController.stream.listen((_) async {
      _phaseSubject.add(Phase.ready);
      await timer.CountDown(readySeconds)
          .start()
          .pipe(_readyCountDownController);

      _phaseSubject.add(Phase.started);
      await _timer.start().pipe(_countDownTickController);

      _phaseSubject.add(Phase.finished);
    });
    _closeTriggeredController.stream.listen((_) => _destroy());
  }

  final timer.HiitTimer _timer;

  final _phaseSubject = BehaviorSubject<Phase>.seeded(Phase.initial);
  final _startTriggeredController = StreamController<void>();
  final _readyCountDownController = StreamController<int>();
  final _countDownTickController = StreamController<timer.Tick>();
  final _closeTriggeredController = StreamController<void>();

  Sink<void> get startTriggered => _startTriggeredController.sink;
  Sink<void> get closeTriggered => _closeTriggeredController.sink;
  Stream<Phase> get phase => _phaseSubject.stream;
  Stream<int> get readyCountDown => _readyCountDownController.stream;
  Stream<timer.Tick> get countDownTick => _countDownTickController.stream;
  Stream get totalSets => Stream.fromIterable([_timer.totalSets]);

  void _destroy() {
    _phaseSubject.close();
    _startTriggeredController.close();
    _readyCountDownController.close();
    _readyCountDownController.close();
  }
}
