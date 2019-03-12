import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_app/blocs/favorite_bloc.dart';
import 'package:youtube_app/blocs/videos_bloc.dart';
import 'package:youtube_app/delegates/data_search.dart';
import 'package:youtube_app/models/video.dart';
import 'package:youtube_app/screens/favorites.dart';
import 'package:youtube_app/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/youtube_logo.png"),
        ),
        elevation: 0.0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
                stream: BlocProvider.of<FavoriteBloc>(context).outFav,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text("${snapshot.data.length}");
                  else
                    return Container();
                }),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Favorites()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null) {
                BlocProvider.of<VideosBloc>(context).inSearch.add(result);
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder(
          stream: BlocProvider.of<VideosBloc>(context).outVideos,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (snapshot.data.length > index) {
                    return VideoTile(snapshot.data[index]);
                  } else if (index > 1) {
                    BlocProvider.of<VideosBloc>(context).inSearch.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: snapshot.data.length + 1,
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
