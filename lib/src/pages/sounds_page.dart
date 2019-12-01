import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:app_components/src/utils/sound_manager.dart';

class SoundsPage extends StatefulWidget {
  _SoundsPageState createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  SoundManager _soundManager = new SoundManager();
  Duration _valorSlider = Duration(seconds: 200);
  Duration _maxTimeinSound = Duration(seconds: 1);
  Duration _currentTimeinSound = Duration(seconds: 0);
  int _currentTable = 0;

  @override
  void initState() {
    _modalListener(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soundspage"),
      ),
      endDrawer: Drawer(
        elevation: 20.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text("Uno"),
            ),
            ListTile(
              title: Text("Dos"),
            )
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              ///no.of items in the horizontal axis
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),

            ///Lazy building of list
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              /// To convert this infinite list to a list with "n" no of items,
              /// uncomment the following line:
              index += 1;
              return listItem(Colors.blue, index, context);
            }, childCount: 99

                    /// Set childCount to limit no.of items
                    /// childCount: 100,
                    ),
          )
        ],
      ),
    );
  }

  Future _playAudio(int table, context) async {
    _currentTable = table;
    await _soundManager.playLocal("$table.mp3", context);
  }

  void _pauseAudio() {
    _soundManager.pauseLocal("$_currentTable.mp3");
  }

  Widget listItem(Color color, int title, BuildContext context) => FlatButton(
    color: getRandomColor(),
    child: Center(
      child: Text(
        "$title",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold),
      ),
    ),
    onPressed: () => _playAudio(title, context),
  );

  Color getRandomColor() {
    final random = Random();
    List<Color> listColors = [
      Colors.blue[300],
      Colors.blue[400],
      Colors.blue,
      Colors.blue[600],
      Colors.blue[700]
    ];

    return listColors[random.nextInt(listColors.length)];
  }

  void _modalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Center(
                child: Column(
              children: <Widget>[
                _crearSlider(),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new RaisedButton(
                      child: new Icon(Icons.play_arrow),
                      onPressed: null,
                    ),
                  ],
                ),
              ],
            )),
          );
        });
  }

  Widget _crearSlider() {
    return AnimatedContainer(
      duration: _maxTimeinSound,
      width: (double.parse(_currentTimeinSound.inMilliseconds.toString()) /
              double.parse(_maxTimeinSound.inMilliseconds.toString())) *
          600,
      height: 10.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), color: Colors.lightBlue),
    );
  }

  void _modalListener(BuildContext context) {
    _soundManager.audioPlayer.onDurationChanged.listen((Duration d) {
      _maxTimeinSound = d;
    });
    _soundManager.audioPlayer.onAudioPositionChanged
        .listen((Duration d) => {_currentTimeinSound = d});
    _soundManager.audioPlayer.onPlayerStateChanged
        .listen((AudioPlayerState state) => {_modalController(context, state)});
  }

  void setCorrectPosition(Duration d) {
    print(double.parse(d.toString()));
  }

  void _modalController(BuildContext context, AudioPlayerState state) {
    print("Estate $state");
    switch (state) {
      case AudioPlayerState.PLAYING:
        print("playing");
        _modalSheet();
        print(_valorSlider);
        break;
      case AudioPlayerState.COMPLETED:
        print("completed");
        Navigator.of(context).pop();
        break;
      default:
    }
  }
}
