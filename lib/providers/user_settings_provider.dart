import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserSettingsProvider with ChangeNotifier {
  List<String>? favorites;
  String? uuid;
  bool? includeNsfw;
  List<String>? defaultSort;
  //getters
  getFavorites() {
    return favorites;
  }

  getUuid() {
    return uuid;
  }

  getIncludeNsfw() {
    return includeNsfw;
  }

  Future getUserSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // get favorites
    favorites = prefs.getStringList('favorites');
    if (favorites == null) {
      List<String> favorites = [];
      await prefs.setStringList('favorites', favorites);
    }
    //get uuid
    uuid = prefs.getString('uuid');
    if (uuid == null) {
      var uuidGenerator = const Uuid();
      String uuid = uuidGenerator.v1();
      await prefs.setString('uuid', uuid);
    }
    //get includeNsfw
    includeNsfw = prefs.getBool('includeNsfw');
    if (includeNsfw == null) {
      bool includeNsfw = false;
      await prefs.setBool('includeNsfw', includeNsfw);
    }

    defaultSort = prefs.getStringList('sort');
    if (defaultSort == null) {
      List<String> sort = ['hot', 'none'];
      await prefs.setStringList('sort', sort);
    }
    notifyListeners();
  }
}
