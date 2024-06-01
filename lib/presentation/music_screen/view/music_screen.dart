//import 'dart:ui';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player_app/core/constant/colour.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({
    super.key,
    required this.audioPlayer,
    required this.songModel,
  });
  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    playSong();
  }

  void playSong() {
    try {
      widget.audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.songModel.uri!),
        ),
      );
      widget.audioPlayer.play();
      _isPlaying = true;
    } on Exception {
      log("Cannot Parse Song" as num);
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 23, 173, 242),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 23, 102, 240),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorconstant.whitecolour,
          ),
        ),
        centerTitle: true,
        title: Text(
          "NOW PLAYING",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: colorconstant.whitecolour),
        ),
        actions: [
          Icon(
            Icons.more_vert_rounded,
            color: colorconstant.whitecolour,
            size: 35,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 23, 102, 240),
              Color.fromARGB(255, 248, 44, 248),
              Color.fromARGB(255, 23, 173, 242)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/music.jpeg"),

                    // AssetImage(widget.songModel.id.toString()) == null
                    //     ? AssetImage("assets/images/music.jpeg")
                    //     : AssetImage(widget.songModel.id.toString()),
                    radius: 140,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 40),
                child: Text(
                  overflow: TextOverflow.fade,
                  widget.songModel.displayNameWOExt,
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: colorconstant.whitecolour),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20),
                  //   child: IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(
                  //       Icons.favorite_border_outlined,
                  //       size: 25,
                  //       color: colorconstant.whitecolour,
                  //     ),
                  //   ),
                  // ),
                  Text(
                    widget.songModel.artist.toString() == "<unknown>"
                        ? "Unknown Artist"
                        : widget.songModel.artist.toString(),
                    style: TextStyle(
                        fontSize: 20, color: colorconstant.whitecolour),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 20),
                  //   child: Icon(
                  //     Icons.abc,
                  //     color: colorconstant.whitecolour,
                  //   ),
                  // ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Slider(
                    min: const Duration(microseconds: 0).inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        changeToSeconds(value.toInt());
                        value = value;
                      });
                    },
                  )
                  // LinearProgressIndicator(
                  //   backgroundColor: Colors.blueGrey[800],
                  //   color: colorconstant.whitecolour,
                  //   value: .7,
                  // ),
                  ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      _position.toString().split(".")[0],
                      style: TextStyle(
                          color: colorconstant.whitecolour, fontSize: 15),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text(
                      _duration.toString().split(".")[0],
                      style: TextStyle(
                          color: colorconstant.whitecolour, fontSize: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.audioPlayer.hasPrevious) {
                        widget.audioPlayer.seekToPrevious();
                      }
                    },
                    icon: Icon(
                      Icons.skip_previous_outlined,
                      color: colorconstant.whitecolour,
                      size: 40,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_isPlaying) {
                          widget.audioPlayer.pause();
                        } else {
                          widget.audioPlayer.play();
                        }
                        _isPlaying = !_isPlaying;
                      });
                    },
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: colorconstant.whitecolour,
                      size: 40,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_next_outlined,
                      color: colorconstant.whitecolour,
                      size: 40,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      widget.audioPlayer.seek(Duration.zero);
                    },
                    icon: Icon(
                      Icons.replay,
                      color: colorconstant.whitecolour,
                      size: 30,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
