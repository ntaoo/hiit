import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:rxdart/rxdart.dart';

class SoundPlayer {
  SoundPlayer() {
    _prepare();
  }

  final _isReadySubject = BehaviorSubject<bool>.seeded(false);
  AudioPlayer _player;
  String _path;

  Future play() async {
    await _player.play(_path, isLocal: true);
  }

  _prepare() async {
    final file = new File('${(await getTemporaryDirectory()).path}/music.mp3');
    await file.writeAsBytes((await _loadAsset()).buffer.asUint8List());
    _player = AudioPlayer();
    _path = file.path;
    _isReadySubject.add(true);
  }

  Future<ByteData> _loadAsset() async {
    return await rootBundle.load('sounds/Countdown01-2.mp3');
  }
}
