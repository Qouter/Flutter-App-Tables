import 'package:flutter/material.dart';
import 'dart:math';

import 'package:app_components/src/utils/sound_manager.dart';

class SoundsPage extends StatefulWidget {
  _SoundsPageState createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {
  SoundManager _soundManager = new SoundManager();

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
                return listItem(Colors.blue, index);
              },

              /// Set childCount to limit no.of items
              /// childCount: 100,
            ),
          )
        ],
      ),
    );
  }

  void _playAudio(int table) async {
    _showModalSheet();
    _soundManager.playLocal("$table.mp3").then((onValue) {});

  }

  Widget listItem(Color color, int title) => FlatButton(
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
        onPressed: () => _playAudio(title),
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

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: MediaQuery.of(context).size.height / 5,
            child: Center(
                child: ButtonBar(
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
            )),
          );
        });
  }
}
