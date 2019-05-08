import 'package:flutter/material.dart';
import 'src/sound_player.dart';
import 'ui/ui.dart';

void main() {
  runApp(MyApp(soundPlayer: SoundPlayerImpl()));
}
