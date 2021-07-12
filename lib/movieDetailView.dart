import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_problem/playVideo.dart';
import 'package:test_problem/utils.dart';
import 'package:http/http.dart' as http;

class MovieDetailView extends StatefulWidget {
  final int movie_id;
  const MovieDetailView({Key? key, required this.movie_id}) : super(key: key);

  @override
  _MovieDetailViewState createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends State<MovieDetailView> {
  Map? moviesDetails;
  List<String>? _ids = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // moviesDetails!.clear();
    moviesDetailedData();
    moviesVideoData();
  }

  Future moviesDetailedData() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    var url = Uri.https(BASE_URL, '/3/movie/${widget.movie_id}', {
      'api_key': API_KEY,
      'language': 'en-US',
    });
// https://api.themoviedb.org/3/movie/19404?api_key=1ba3639e85db8da496c4eb5c51b3bb0f&language=en-US
    print(url);
    var response = await http.get(url, headers: headers);
    var data = json.decode(response.body);
    print(response.body);
    var temp = data;
    setState(() {
      moviesDetails = temp;
    });
    print("""$moviesDetails""");
  }

  Future moviesVideoData() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    var url = Uri.https(BASE_URL, '/3/movie/${widget.movie_id}/videos', {
      'api_key': API_KEY,
      'language': 'en-US',
    });
// https://api.themoviedb.org/3/movie/19404?api_key=1ba3639e85db8da496c4eb5c51b3bb0f&language=en-US
    print(url);
    var response = await http.get(url, headers: headers);
    var data = json.decode(response.body);
    print(response.body);
    List temp = data["results"];
    for (int i = 0; i < temp.length; i++) {
      Map m = temp[i];
      _ids!.add(m["key"].toString());
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueGrey.shade600,
        behavior: SnackBarBehavior.floating,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton.extended(
              onPressed: () {
                if (_ids!.length < 1) {
                  _showSnackBar("No videos to Play");
                } else {
                  print(_ids);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayTrailer(
                        idList: _ids,
                      ),
                    ),
                  );
                }
              },
              label: Text("Play Trailer")),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.amber.shade600,
        title: Text("Movie Detail View"),
      ),
      body: moviesDetails == null
          ? Center(
              child: Text("Loading......."),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shadowColor: Colors.amber.shade100,
                      child: Image.network(
                        "$IMAGE_URL_500${moviesDetails!["poster_path"]}",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  showCard("Title :", moviesDetails!["original_title"]),
                  showCard("Budget : ", "${moviesDetails!["budget"]}"),
                  showCard("OverView :", moviesDetails!["overview"]),
                  Text(
                    "Genres                                                             ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  showCardGenere(moviesDetails!["genres"]),
                  Text(
                    "Production Companies                                                             ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  showCardProductionCompanies(
                      moviesDetails!["production_companies"])
                ],
              ),
            ),
    );
  }

  Widget showCard(String head, value) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: Container(child: Text(head))),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          Expanded(
            child: Container(
                //  height: MediaQuery.of(context).size.height * 0.1,
                child: Text(value)),
          ),
        ],
      ),
    );
  }

  Widget showCardGenere(List genereList) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: genereList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        Map m = genereList[index];
        return Card(
          child: Center(
              child: Text(
            m["name"],
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        );
      },
    );
  }

  Widget showCardProductionCompanies(List prodCompList) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // scrollDirection: Axis.vertical,
      itemCount: prodCompList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        Map m = prodCompList[index];
        return Card(
          child: Center(
              child: Stack(alignment: Alignment.bottomCenter, children: [
            Image.network("$IMAGE_URL_500${m["logo_path"]}"),
            Text(
              m["name"],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ])),
        );
      },
    );
  }
}
