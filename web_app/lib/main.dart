// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_web/material.dart';
import 'package:web_app/src/sound_player.dart';
import 'package:web_app/ui/ui.dart';

void main() {
  runApp(MyApp(soundPlayer: SoundPlayerImpl()));
}
