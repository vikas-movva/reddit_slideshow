import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:reddit_slideshow/providers/reddit_auth_provider.dart';
import 'package:reddit_slideshow/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Viewer extends StatefulWidget {
  const Viewer({Key? key, required this.endpoint}) : super(key: key);

  final String endpoint;

  @override
  State<Viewer> createState() => ViewerState();
}

class ViewerState extends State<Viewer> {
  bool showBars = false;
  bool isPaused = false;
  int index = 0;
  RedditLinks? redditLinks;
  List<dynamic>? data;
  @override
  Widget build(BuildContext context) {
    redditLinks = RedditLinks(context.read<RedditAuthProvider>().getHeaders(),
        widget.endpoint, context.read<UserSettingsProvider>().defaultSort);
    data = redditLinks!.data;
    return GestureDetector(
      child: Scaffold(
        appBar: showBars
            ? AppBar(
                title: Text(widget.endpoint),
              )
            : null,
        bottomNavigationBar: showBars
            ? BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_previous_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: isPaused
                          ? const Icon(Icons.play_arrow_outlined)
                          : const Icon(Icons.pause_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_previous,
                      ),
                    )
                  ],
                ),
              )
            : null,
        body: PageView.builder(
          itemBuilder: (context, index) {
            return Text('picture');
          },
        ),
      ),
      onTap: () {
        setState(
          () {
            showBars = !showBars;
          },
        );
      },
    );
  }
}

class RedditLinks {
  String? after;
  List<dynamic>? data;

  RedditLinks(headers, endpoint, defaultSort) {
    var json = _getInitialRedditData(headers, endpoint, defaultSort);
    //updates the after value with the full name of the last element
    after = json['data']['after'];

    // updates the data attribute with a refined list of map objects
    data = json['data']['children'].map((item) {
      return {
        'fullname': item['data']['name'],
        'subreddit': item['data']['subreddit_name_prefixed'],
        'title': item['data']['title'],
        'is_gallery': item['data']['is_gallery'] == true ? true : false,
        'gallery_items': item['data']['gallery_data'] != null
            ? item['data']['gallery_data']['items']
                .map((item) => item['media_id'])
                .toList()
            : null,
        'url': item['data']['url_overridden_by_dest']
      };
    }).toList();
  }

  _getInitialRedditData(headers, endpoint, defaultSort) async {
    Response? response;
    try {
      response = await get(
          Uri.parse(
              'https://oauth.reddit.com/$endpoint/${defaultSort[0]}?t=${defaultSort[1]}&limit=50'),
          headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  updateRedditData(headers) {}
}
