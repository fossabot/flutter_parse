part of flutter_parse;

final parseConfig = ParseConfig._internal();

class ParseConfig implements ParseBaseObject {
  bool _isComplete;
  final Map<String, dynamic> _data;

  ParseConfig._internal()
      : _isComplete = false,
        _data = {};

  // region GETTER
  bool get isComplete => _isComplete;

  /// Access a value. In most cases it is more convenient to use a helper function such as
  /// [getString] or [getInteger].
  ///
  /// Returns `null` if there is no such key.
  dynamic get(String key) {
    assert(key != null);
    assert(isComplete, 'call `fetch` first to get data');

    if (!_data.containsKey(key)) {
      return null;
    }

    return _data[key];
  }

  /// Access a [bool] value.
  ///
  /// Returns `false` if there is no such key or if it is not a [bool].
  bool getBoolean(String key) {
    if (get(key) is! bool) {
      return false;
    }

    return get(key);
  }

  /// Access an [int] value.
  ///
  /// Returns `0` if there is no such key or if it is not a [int].
  int getInteger(String key) {
    if (get(key) is! int) {
      return 0;
    }

    return get(key);
  }

  /// Access a [double] value.
  ///
  /// Returns `double.nan` if there is no such key or if it is not a [double].
  double getDouble(String key) {
    if (get(key) is! double) {
      return double.nan;
    }

    return get(key);
  }

  /// Access a [num] value.
  ///
  /// Returns `null` if there is no such key or if it is not a [num].
  num getNumber(String key) {
    if (get(key) is! num) {
      return null;
    }

    return get(key);
  }

  /// Access a [String] value.
  ///
  /// Returns `null` if there is no such key or if it is not a [String].
  String getString(String key) {
    if (get(key) is! String) {
      return null;
    }

    return get(key);
  }

  /// Access a [DateTime] value.
  ///
  /// Returns `null` if there is no such key or if it is not a [DateTime].
  DateTime getDateTime(String key) {
    if (get(key) is! DateTime) {
      return null;
    }

    return get(key);
  }

  /// Access a [Map] value.
  ///
  /// Returns `null` if there is no such key or if it is not a [Map].
  Map<String, dynamic> getMap(String key) {
    if (get(key) is! Map) {
      return null;
    }

    return Map<String, dynamic>.from(get(key));
  }

  /// Access a [List] value.
  ///
  /// Returns `null` if there is no such key or if it is not a [List].
  List<T> getList<T>(String key) {
    if (get(key) is! List) {
      return null;
    }

    return List<T>.from(get(key));
  }

  /// Access a [ParseGeoPoint] value.
  ///
  /// Returns `null` if there is no such key or if it is not a [ParseGeoPoint].
  ParseGeoPoint getParseGeoPoint(String key) {
    if (get(key) is! ParseGeoPoint) {
      return null;
    }

    return get(key);
  }

  /// Access a [ParseFile] value.
  ///
  /// Returns `null` if there is no such key or if it is not a [ParseFile].
  ParseFile getParseFile(String key) {
    if (get(key) is! ParseFile) {
      return null;
    }

    return get(key);
  }

  /// Access a [ParseObject] value.
  ///
  /// Returns `null` if there is no such key or if it is not a [ParseObject].
  ParseObject getParseObject(String key) {
    if (get(key) is! ParseObject) {
      return null;
    }

    return get(key);
  }

  /// Access a [ParseUser] value.
  ///
  /// Returns `null` if there is no such key or if it is not a [ParseUser].
  ParseUser getParseUser(String key) {
    if (get(key) is! ParseUser) {
      return null;
    }

    return get(key);
  }
  // endregion

  // region SETTER
  void _mergeJson(dynamic json, {bool fromFetch = false}) {
    final result = json['result'];
    if (result == true) {
      return;
    }

    if (fromFetch) {
      _data.clear();
    }

    json = json['params'];
    if (json != null) {
      json.forEach((key, value) {
        _data[key] = _parseDecoder.decode(value);
      });

      _isComplete = true;
    }
  }
  // endregion

  // region HELPERS
  @override
  String get _path {
    String path = '${_parse._configuration.uri.path}/config';

    return path;
  }

  @override
  get _toJson {
    final map = <String, dynamic>{};

    _data.forEach((key, value) {
      map[key] = _parseEncoder.encode(value);
    });

    return map;
  }

  @override
  String toString() {
    return json.encode(_toJson);
  }
  // endregion

  // region EXECUTORS
  Future<ParseConfig> fetch() async {
    final result = await _parseHTTPClient.get(_path);
    _mergeJson(result);
    return Future.value(this);
  }
// endregion
}
