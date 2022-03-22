import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reddit_slideshow/providers/reddit_auth_provider.dart';
import 'package:reddit_slideshow/providers/user_settings_provider.dart';
import 'package:reddit_slideshow/screens/viewer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: TypeAheadField(
              textFieldConfiguration: const TextFieldConfiguration(
                autofocus: false,
                cursorColor: Colors.white,
                keyboardAppearance: Brightness.dark,
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  icon: FaIcon(
                    FontAwesomeIcons.redditSquare,
                    size: 40,
                    color: Colors.white,
                  ),
                  hintText: '/r/',
                  hintStyle: TextStyle(color: Colors.white),
                  border: UnderlineInputBorder(),
                  filled: false,
                  fillColor: Colors.white,
                  suffixIcon: IconTheme(
                      data: IconThemeData(color: Colors.white),
                      child: Icon(Icons.search)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                autocorrect: false,
              ),
              suggestionsCallback: (String pattern) async {
                var subreddits = await getAutocompleteData(
                    pattern,
                    context.read<RedditAuthProvider>().getHeaders(),
                    context.read<UserSettingsProvider>().getIncludeNsfw());
                return subreddits;
              },
              itemBuilder: (BuildContext context, dynamic suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                if (suggestion != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Viewer(endpoint: suggestion.toString()),
                      ));
                }
              }),
        ),
      ),
    );
  }
}

FutureOr<List<dynamic>> getAutocompleteData(
    String query, Map<String, String> headers, bool includeNsfw) async {
  List subreddits = [];
  try {
    var response = await http.get(
        Uri.parse(
            'https://oauth.reddit.com/api/subreddit_autocomplete_v2?query=$query&include_over_18=$includeNsfw&typeahead_active=false&include_profiles=false'),
        headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      for (var child in responseData['data']['children']) {
        subreddits.add(child['data']['url'].replaceAll(RegExp(r'^/|/$'), ''));
      }
    }
  } catch (error) {
    print(error);
  }
  return subreddits;
}
