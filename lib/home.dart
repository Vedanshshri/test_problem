import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_problem/movieDetailView.dart';
import 'package:test_problem/utils.dart';

import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List? movies;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    moviesData();
  }

  Future moviesData() async {
    var url = Uri.https(BASE_URL, '/3/movie/top_rated', {
      'api_key': API_KEY,
      'language': 'en-US',
      "sort_by": "popularity.desc"
    });

    var response = await http.get(url);
    var data = json.decode(response.body);
    print(response.body);
    var temp = data["results"];
    setState(() {
      movies = temp;
    });
    print(movies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber.shade600,
          title: Text("Test App"),
        ),
        body: movies != null
            ? ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  Map m = movies![index];
                  return MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailView(
                            movie_id: int.parse(m["id"].toString()),
                          ),
                        ),
                      );
                    },
                    child: showCard(
                        backImg: "$IMAGE_URL_500${m["poster_path"]}",
                        title: "${m["original_title"]}  ${m["id"]} "),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: 10
                /////// movies!.length
                )
            : Center(
                child: Text("Loading........"),
              ));
  }

  Widget showCard({required String backImg, required String title}) {
    return Card(
      shadowColor: Colors.amber.shade300,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: Card(
                shadowColor: Colors.amber.shade100,
                child: Image.network(
                  '$backImg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
// "$IMAGE_URL_500${movie.poster_path}"
