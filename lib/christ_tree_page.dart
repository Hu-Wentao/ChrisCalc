import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ChrisTreePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Banner(
        location: BannerLocation.bottomEnd,
        message: '问题反馈',
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '圣诞快乐',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white))),
          home: MyTree(),
        ),
      );
}

class MyTree extends StatefulWidget {
  @override
  _MyTreeState createState() => _MyTreeState();
}

class _MyTreeState extends State<MyTree> {
  AudioPlayer audioPlayer;
  AudioCache audioCache = AudioCache();
  @override
  void initState() {
    super.initState();
    playMusic();
  }

  playMusic() async {
    audioPlayer = await audioCache.loop("jingle.mp3");
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
            Center(
              child: Icon(
                Icons.star,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            for (final x in _offsets)
              Light(
                x: x,
              ),
            SizedBox(
              height: 8,
            ),
            Center(
              child: Text("Happy Holidays"),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Stop"),
              onPressed: () {
                audioPlayer.stop();
              },
            ),
            Row(children: [
              Expanded(child: Container()),
              RaisedButton(
                child: Text("问题反馈"),
                onPressed: () {
                  showAboutDialog(context: context, children: [
                    Text('遇到问题请截图发送到邮箱 hu.wt@qq.com\n或联系QQ 1328518369')
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
