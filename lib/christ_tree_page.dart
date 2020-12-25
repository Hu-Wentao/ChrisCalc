import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ChrisTreePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '圣诞快乐',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white))),
        home: MyTree(),
      );
}

class MyTree extends StatefulWidget {
  @override
  _MyTreeState createState() => _MyTreeState();
}

class _MyTreeState extends State<MyTree> {
  AudioPlayer audioPlayer;
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    playMusic();
  }

  playMusic() async {
    if (isPlaying) return;
    audioPlayer ??= AudioPlayer();
    if (kIsWeb) {
      var url =
          'https://calc-shuttleclod-1259152223.cos.ap-nanjing.myqcloud.com/jingle.mp3';
      audioPlayer.setUrl(url);
    } else {
      audioPlayer.setAsset('assets/jingle.mp3');
    }

    isPlaying = true;
    audioPlayer.play();
  }

  stopMusic() {
    if (!isPlaying) return;

    isPlaying = false;
    audioPlayer.stop();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  static final _offsets = _generateOffsets(100, 0.05).toList(growable: false);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Container(
        constraints: BoxConstraints(maxWidth: 700),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
        child: ListView(
          children: <Widget>[
            Center(child: Icon(Icons.star, color: Colors.white)),
            SizedBox(height: 8),
            for (final x in _offsets) Light(x: x),
            SizedBox(height: 8),
            Center(child: Text("Happy Holidays")),
            SizedBox(height: 20),
            RaisedButton(
              child: Text(isPlaying ? "Pause" : "Continue"),
              onPressed: () =>
                  setState(() => isPlaying ? stopMusic() : playMusic()),
            ),
            Row(children: [
              Expanded(child: Container()),
              RaisedButton(
                child: Text("问题反馈"),
                onPressed: () {
                  showAboutDialog(context: context, children: [
                    Text('如遇问题, \n请截图发送到 hu.wt@qq.com\n或联系QQ 1328518369')
                  ]);
                },
              )
            ])
          ],
        ),
      ),
    );
  }

  static Iterable<double> _generateOffsets(
      int count, double acceleration) sync* {
    double x = 0;
    yield x;

    double ax = acceleration;
    for (int i = 0; i < count; i++) {
      x += ax;
      ax *= 1.5;

      final maxLateral = min(1, i / count);
      if (x.abs() > maxLateral) {
        x = maxLateral * x.sign;
        ax = x >= 0 ? -acceleration : acceleration;
      }
      yield x;
    }
  }
}

class Light extends StatefulWidget {
  static final festiveColors = [
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.yellow
  ];

  final double x;

  final int period;

  final Color color;

  Light({
    Key key,
    this.x,
  })  : period = 500 + (x.abs() * 4000).floor(),
        color = festiveColors[Random().nextInt(4)],
        super(key: key);

  @override
  _LightState createState() => _LightState();
}

class _LightState extends State<Light> {
  Color _newColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Align(
        alignment: Alignment(widget.x, 0.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: widget.period),
            tween: ColorTween(begin: widget.color, end: _newColor),
            onEnd: () {
              setState(() {
                _newColor =
                    _newColor == Colors.white ? widget.color : Colors.white;
              });
            },
            builder: (_, color, __) {
              return Container(
                color: color,
              );
            },
          ),
        ),
      ),
    );
  }
}
