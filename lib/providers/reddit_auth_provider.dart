import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class RedditAuthProvider with ChangeNotifier {
  Map<String, String>? _headers;

  getHeaders() => _headers;

  Future redditAuth(uuid) async {
    final username = dotenv.env['CLIENT_ID'];
    const password = '';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    var response = await post(
      Uri.parse('https://www.reddit.com/api/v1/access_token'),
      headers: <String, String>{'Authorization': basicAuth},
      body: {
        "grant_type": "https://oauth.reddit.com/grants/installed_client",
        'device_id': '$uuid'
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      _headers = {
        'Authorization':
            '${responseBody['token_type']} ${responseBody['access_token']}',
        'User-Agent': 'flutter:reddit_slideshow:v0.0.0 (by /u/vikasm112)'
      };
    }
    notifyListeners();
  }
}
