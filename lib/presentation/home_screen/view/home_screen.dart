import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player_app/core/constant/colour.dart';
import 'package:music_player_app/presentation/music_screen/view/music_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(uri!)),
      );
      _audioPlayer.play();
    } on Exception {
      log("Error parsing song" as num);
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 23, 102, 240),
                Color.fromARGB(255, 248, 44, 248),
                Color.fromARGB(255, 23, 173, 242)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 29, 28, 28),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorconstant.whitecolour,
                      ),
                      hintText: "SEARCH SONG",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 242, 129, 23),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20),
                  child: Text(
                    "HOME",
                    style: TextStyle(
                        color: colorconstant.whitecolour, fontSize: 20),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<SongModel>>(
                  future: _audioQuery.querySongs(
                      sortType: null,
                      orderType: OrderType.ASC_OR_SMALLER,
                      uriType: UriType.EXTERNAL,
                      ignoreCase: true),
                  builder: (context, item) {
                    if (item.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (item.data!.isEmpty) {
                      return Center(child: Text("NO SONGS FOUND"));
                    }
                    return Expanded(
                      child: Container(
                        child: ListView.builder(
                          itemCount: item.data!.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MusicScreen(
                                    songModel: item.data![index],
                                    audioPlayer: _audioPlayer,
                                  ),
                                ),
                              ),
                              child: Container(
                                // color: colorconstant.blackcolour,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 242, 129, 23),
                                        Color.fromARGB(255, 61, 6, 241),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                ),
                                child: ListTile(
                                  leading: QueryArtworkWidget(
                                    id: item.data![index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        "assets/images/music.jpeg",
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    overflow: TextOverflow.ellipsis,
                                    item.data![index].displayNameWOExt,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colorconstant.whitecolour),
                                  ),
                                  subtitle: Text(
                                    "${item.data![index].artist}" == "<unknown>"
                                        ? "Unknown Artist"
                                        : "${item.data![index].artist}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: colorconstant.whitecolour),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.favorite_border,
                                      size: 25,
                                      color: colorconstant.whitecolour,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
