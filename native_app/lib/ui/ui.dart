import 'package:flutter/material.dart';
import 'package:hiit_timer/hiit_timer.dart';

final blackTextColor = Colors.indigo.shade700;
final whiteTextColor = Colors.grey.shade300;

class MyApp extends StatelessWidget {
  MyApp({@required this.soundPlayer});

  final SoundPlayer soundPlayer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Let's HIIT!!",
      home: HomePage(title: "Let's HIIT!!", soundPlayer: soundPlayer),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, @required this.title, @required this.soundPlayer})
      : super(key: key);
  final String title;
  final SoundPlayer soundPlayer;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.title, style: TextStyle(color: Colors.grey.shade100)),
        backgroundColor: Colors.deepOrange.shade900,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Colors.deepOrange.shade100,
              Colors.deepOrange.shade50
            ])),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text('Start HIIT workout!',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: blackTextColor)),
            ),
            RaisedButton.icon(
                color: Colors.white,
                shape: CircleBorder(
                    side: BorderSide(width: 6, color: blackTextColor)),
                icon: Icon(Icons.play_arrow, size: 192, color: blackTextColor),
                label: Text(''),
                elevation: 16,
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HiitTimerPage(soundPlayer: widget.soundPlayer)),
                    )),
          ],
        )),
      ),
    );
  }
}

class HiitTimerPage extends StatefulWidget {
  HiitTimerPage({Key key, @required this.soundPlayer}) : super(key: key);

  final SoundPlayer soundPlayer;
  final HiitTimer hiitTimer = HiitTimer();
  @override
  _HiitTimerPageState createState() => _HiitTimerPageState();
}

class _HiitTimerPageState extends State<HiitTimerPage> {
  Future _play() async {
    await widget.soundPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    widget.hiitTimer.startTriggered.add(null);

    final readyCountDownScaffold = _buildReadyCountDownScaffold(context);
    final workoutCountDownScaffold = _buildWorkoutCountDownScaffold(context);

    return StreamBuilder<Phase>(
        stream: widget.hiitTimer.phase,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case Phase.initial:
                return _buildEmpty();
              case Phase.ready:
                return readyCountDownScaffold;
              case Phase.started:
                return workoutCountDownScaffold;
              case Phase.finished:
                return _buildFinishedScaffold(context);
            }
          } else {
            return _buildEmpty();
          }
        });
  }

  Container _buildEmpty() {
    return Container(color: Colors.transparent);
  }

  StreamBuilder<int> _buildReadyCountDownScaffold(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.hiitTimer.readyCountDown,
        builder: (context, snapshot) {
          var backgroundColor;
          var textColor = blackTextColor;
          switch (snapshot.data) {
            case 3:
              _play();
              backgroundColor = Colors.deepOrange.shade200;
              break;
            case 2:
              backgroundColor = Colors.deepOrange.shade300;
              break;
            case 1:
              backgroundColor = Colors.deepOrange.shade400;
              break;
            default:
              backgroundColor = Colors.deepOrange.shade100;
          }
//          SystemSound.play(SystemSoundType.click);
          return Scaffold(
              body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [backgroundColor, Colors.deepOrange.shade50])),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Ready',
                  style: TextStyle(
                      fontSize: 96,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  snapshot.data.toString(),
                  style: TextStyle(
                      fontSize: 200,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  ' ',
                  style: TextStyle(
                      color: Colors.transparent,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ));
        });
  }

  StreamBuilder<Tick> _buildWorkoutCountDownScaffold(BuildContext context) {
    return StreamBuilder<Tick>(
        stream: widget.hiitTimer.countDownTick,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Tick tick = snapshot.data;
            var backgroundColor;
            var gradientTargetColor;
            var textColor;

            if (tick.kind == Kind.goTime) {
              gradientTargetColor = Colors.deepOrange.shade200;
              switch (snapshot.data.count) {
                case 3:
                  _play();
                  backgroundColor = Colors.deepOrange.shade600;
                  textColor = blackTextColor;
                  break;
                case 2:
                  backgroundColor = Colors.deepOrange.shade700;
                  textColor = blackTextColor;
                  break;
                case 1:
                  backgroundColor = Colors.deepOrange.shade800;
                  textColor = blackTextColor;
                  break;
                default:
                  backgroundColor = Colors.deepOrange.shade500;
                  textColor = blackTextColor;
              }
            } else {
              gradientTargetColor = Colors.indigo.shade200;
              switch (snapshot.data.count) {
                case 5:
                  backgroundColor = Colors.indigo.shade700;
                  textColor = whiteTextColor;
                  break;
                case 4:
                  backgroundColor = Colors.indigo.shade600;
                  textColor = whiteTextColor;
                  break;
                case 3:
                  _play();
                  backgroundColor = Colors.indigo.shade500;
                  textColor = whiteTextColor;
                  break;
                case 2:
                  backgroundColor = Colors.indigo.shade400;
                  textColor = whiteTextColor;
                  break;
                case 1:
                  backgroundColor = Colors.indigo.shade300;
                  textColor = whiteTextColor;
                  break;
                default:
                  backgroundColor = Colors.indigo.shade800;
                  textColor = whiteTextColor;
              }
            }

            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                        colors: [gradientTargetColor, backgroundColor])),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      tick.kind == Kind.goTime ? 'Go!!' : 'Break.',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 96,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${tick.count}',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 200,
                          fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder(
                        stream: widget.hiitTimer.totalSets,
                        builder: (context, snapshot) {
                          return Text(
                            '${tick.set} / ${snapshot.data} sets',
                            style: TextStyle(
                                color: textColor,
                                fontSize: 48,
                                fontWeight: FontWeight.bold),
                          );
                        }),
                  ],
                )),
              ),
            );
          } else {
            return Container(decoration: BoxDecoration(color: Colors.orange));
          }
        });
  }

  Scaffold _buildFinishedScaffold(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.indigo.shade200, Colors.indigo.shade50])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Finish!',
                  style: TextStyle(
                      fontSize: 72,
                      color: blackTextColor,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Good for you!',
                    style: TextStyle(
                        fontSize: 24,
                        color: blackTextColor,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: RaisedButton.icon(
                    icon: Icon(Icons.close, color: blackTextColor),
                    label: Text('CLOSE',
                        style: TextStyle(
                            fontSize: 24,
                            color: blackTextColor,
                            fontWeight: FontWeight.bold)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    onPressed: () {
                      widget.hiitTimer.closeTriggered.add(null);
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
