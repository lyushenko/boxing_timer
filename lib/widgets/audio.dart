import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Audio {
  static bool mute = false;

  AudioCache _audioCache;
  AudioPlayer _audioPlayer;

  Audio() {
    AudioPlayer.logEnabled = false;
    _audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    _audioCache =
        AudioCache(prefix: 'assets/sounds/', fixedPlayer: _audioPlayer);
    _fixCallbackLookupFailedIssue();
  }

  // https://github.com/luanpotter/audioplayers/issues/344
  void _fixCallbackLookupFailedIssue() {
    if (Platform.isIOS) {
      _audioPlayer
          .monitorNotificationStateChanges(_audioPlayerStateChangeHandler);
    }
  }

  void start(String filename) {
    if (!mute) _audioCache.play(filename);
  }

  void loop(String filename) {
    if (!mute) _audioCache.loop(filename);
  }

  void stop() => _audioPlayer.stop();

  Future<void> dispose() async {
    await _audioPlayer.pause();
    await _audioPlayer.dispose();
  }
}

void _audioPlayerStateChangeHandler(AudioPlayerState state) => null;
