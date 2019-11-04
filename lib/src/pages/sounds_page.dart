import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:app_components/src/utils/sound_manager.dart';

class SoundsPage extends StatefulWidget {
  _SoundsPageState createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {

  SoundManager _soundManager = new SoundManager();
  Duration _valorSlider = Duration(seconds: 200);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soundspage"),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              ///no.of items in the horizontal axis
              crossAxisCount: 4,
            ),

            ///Lazy building of list
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                /// To convert this infinite list to a list with "n" no of items,
                /// uncomment the following line:
                /// if (index > n) return null;
                return listItem(Colors.blue, index,context);
              },

              /// Set childCount to limit no.of items
              /// childCount: 100,
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {
          modalListener(context)
        });
  }

  Future _playAudio(int table,context) async {
    await _soundManager.playLocal("$table.mp3",context);
  }

  Widget listItem(Color color, int title,BuildContext context) => FlatButton(
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
        onPressed: () => _playAudio(title,context),
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
            height: MediaQuery.of(context).size.height / 5,
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
                        new RaisedButton(
                          child: new Icon(Icons.pause),
                          onPressed: null,
                        ),
                        new RaisedButton(
                          child: new Icon(Icons.stop),
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
    return Slider(
      activeColor: Colors.indigoAccent,
      label: "Tamaño de la imagen =",
      value: 50.5,
      min: 30.0,
      max: 400.0,
    );
  }

  void modalListener(BuildContext context) {
    _soundManager.audioPlayer.onAudioPositionChanged.listen((Duration d) => {
      setState(() => print(d))
    });
    _soundManager.audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) => {
      _modalController(context,state)
    });
    
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
