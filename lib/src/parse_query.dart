part of flutter_parse;

class ParseQuery<T extends ParseObject> {
  final String className;
  final List<String> _includes = List();
  final List<String> _order = List();
  final Map<String, dynamic> _where = Map();
  List<String> _selectedKeys;
  int _limit = -1;
  int _skip = 0;
  bool _countEnabled = false;

  ParseQuery({@required this.className});

  void _addCondition(String key, String condition, dynamic value) {
    Map<String, dynamic> whereValue;

    // Check if we already have some of a condition
    if (_where.containsKey(key)) {
      dynamic existingValue = _where[key];
      if (existingValue is Map) {
        whereValue = existingValue;
      }
    }

    whereValue ??= Map();

    whereValue.putIfAbsent(condition, () => value);

    _where.putIfAbsent(key, () => whereValue);
  }

  void whereEqualTo(String key, dynamic value) {
    _where.putIfAbsent(key, () => _parseEncoder.encode(value));
  }

  void whereLessThan(String key, dynamic value) {
    _addCondition(key, "\$lt", value);
  }

  void whereNotEqualTo(String key, dynamic value) {
    _addCondition(key, "\$ne", _parseEncoder.encode(value));
  }

  void whereGreaterThan(String key, dynamic value) {
    _addCondition(key, "\$gt", value);
  }

  void whereLessThanOrEqualTo(String key, dynamic value) {
    _addCondition(key, "\$lte", value);
  }

  void whereGreaterThanOrEqualTo(String key, dynamic value) {
    _addCondition(key, "\$gte", value);
  }

  void whereContainedIn(String key, List<dynamic> values) {
    _addCondition(key, "\$in", values);
  }

  void whereContainsAll(String key, List<dynamic> values) {
    _addCondition(key, "\$all", values);
  }

  void whereNotContainedIn(String key, List<dynamic> values) {
    _addCondition(key, "\$nin", values);
  }

  void whereMatches(String key, String regex) {
    _addCondition(key, "\$regex", regex);
  }

  void whereMatches2(String key, String regex, String modifiers) {
    _addCondition(key, "\$regex", regex);
    if (modifiers.isNotEmpty) {
      _addCondition(key, "\$options", modifiers);
    }
  }

  void whereContains(String key, String substring,
      {bool caseInsensitive = false}) {
    String regex = RegExp.escape(substring);
    if (caseInsensitive) {
      regex = "${caseInsensitive ? "(?i)" : ""}$regex";
    }
    whereMatches(key, regex);
  }

  void whereStartsWith(String key, String prefix,
      {bool caseInsensitive = false}) {
    String regex = RegExp.escape(prefix);
    regex = "${caseInsensitive ? "(?i)" : ""}^$regex";
    whereMatches(key, regex);
  }

  void whereEndsWith(String key, String suffix,
      {bool caseInsensitive = false}) {
    String regex = RegExp.escape(suffix);
    regex = "${caseInsensitive ? "(?i)" : ""}$regex\$";
    whereMatches(key, regex);
  }

  void whereExists(String key) {
    _addCondition(key, "\$exists", true);
  }

  void whereDoesNotExist(String key) {
    _addCondition(key, "\$exists", false);
  }

  void whereDoesNotMatchKeyInQuery(
      String key, String keyInQuery, ParseQuery query) {
    Map<String, dynamic> condition = Map();
    condition.putIfAbsent("key", () => keyInQuery);
    condition.putIfAbsent("query", () => query);
    _addCondition(key, "\$dontSelect", condition);
  }

  void whereMatchesKeyInQuery(String key, String keyInQuery, ParseQuery query) {
    Map<String, dynamic> condition = Map();
    condition.putIfAbsent("key", () => keyInQuery);
    condition.putIfAbsent("query", () => query);
    _addCondition(key, "\$select", condition);
  }

  void whereDoesNotMatchQuery(String key, ParseQuery query) {
    _addCondition(key, "\$notInQuery", query);
  }

  void whereMatchesQuery(String key, ParseQuery query) {
    _addCondition(key, "\$inQuery", query);
  }

  void whereNear(String key, ParseGeoPoint point) {
    _addCondition(key, "\$nearSphere", point);
  }

  void maxDistance(String key, double maxDistance) {
    _addCondition(key, "\$maxDistance", maxDistance);
  }

  void whereWithin(
      String key, ParseGeoPoint southwest, ParseGeoPoint northeast) {
    List<dynamic> array = List();
    array.add(southwest);
    array.add(northeast);
    Map<String, List<dynamic>> dictionary = Map();
    dictionary.putIfAbsent("\$box", () => array);
    _addCondition(key, "\$within", dictionary);
  }

  void whereGeoWithin(String key, List<ParseGeoPoint> points) {
    Map<String, List<ParseGeoPoint>> dictionary = Map();
    dictionary.putIfAbsent("\$polygon", () => points);
    _addCondition(key, "\$geoWithin", dictionary);
  }

  void whereGeoIntersects(String key, ParseGeoPoint point) {
    Map<String, ParseGeoPoint> dictionary = Map();
    dictionary.putIfAbsent("\$point", () => point);
    _addCondition(key, "\$geoIntersects", dictionary);
  }

  void setOrder(String key) {
    _order.clear();
    _order.add(key);
  }

  List<String> get order => _order;

  void addOrder(String key) {
    _order.add(key);
  }

  void orderByAscending(String key) {
    setOrder(key);
  }

  void addAscendingOrder(String key) {
    addOrder(key);
  }

  void orderByDescending(String key) {
    setOrder("-$key");
  }

  void addDescendingOrder(String key) {
    addOrder("-$key");
  }

  void include(String key) {
    _includes.add(key);
  }

  List<String> get includes => _includes;

  void selectKeys(List<String> keys) {
    if (_selectedKeys == null) {
      _selectedKeys = List();
    }

    _selectedKeys.addAll(keys);
  }

  List<String> get selectedKeys => _selectedKeys;

  void setLimit(int limit) {
    _limit = limit;
  }

  int get limit => _limit;

  void setSkip(int skip) {
    _skip = skip;
  }

  int get skip => _skip;

  Map<String, dynamic> toJson() {
    var params = toJsonParams();
    assert(!params.containsKey("count"));
    params.putIfAbsent("className", () => className);

    return params;
  }

  Map<String, dynamic> toJsonParams() {
    Map<String, dynamic> params = Map();

    if (_where.isNotEmpty) {
      params.putIfAbsent("where", () => _parseEncoder.encode(_where));
    }
    if (_limit >= 0) {
      params.putIfAbsent("limit", () => _limit);
    }
    if (_countEnabled) {
      params.putIfAbsent("count", () => 1);
    } else {
      if (_skip > 0) {
        params.putIfAbsent("skip", () => _skip);
      }
    }
    if (_order.isNotEmpty) {
      params.putIfAbsent("order", () => _order.join(','));
    }
    if (_includes.isNotEmpty) {
      params.putIfAbsent("include", () => _includes.join(','));
    }
    if (_selectedKeys != null) {
      params.putIfAbsent("fields", () => _selectedKeys.join(','));
    }

    return params;
  }

  static ParseQuery or(List<ParseQuery> queries) {
    final className = queries[0].className;
    final clauseOr = queries.map((q) {
      if (q.className != className) {
        throw ParseException(
            code: ParseException.invalidClassName,
            message: 'different className');
      }
      return q._where;
    }).toList();
    return ParseQuery(className: className)..whereEqualTo("\$or", clauseOr);
  }

  Future<List<dynamic>> findAsync() async {
    dynamic result = await _find();
    if (result.containsKey("results")) {
      List<dynamic> results = result["results"];
      List<dynamic> objects = List();
      results.forEach((json) {
        String objectId = json["objectId"];
        if (className == '_User') {
          ParseUser user = ParseUser.fromJson(json: json);
          objects.add(user);
        } else {
          ParseObject object = ParseObject.fromJson(
            className: className,
            objectId: objectId,
            json: json,
          );
          objects.add(object);
        }
      });
      return objects;
    }

    return [];
  }

  Future<dynamic> _find() {
    _countEnabled = false;
    return _query();
  }

  Future<int> countAsync() async {
    final result = await _count();
    if (result.containsKey("count")) {
      return result["count"];
    }

    return 0;
  }

  Future<dynamic> _count() {
    _countEnabled = true;
    return _query();
  }

  Future<dynamic> _query() {
    Map<String, dynamic> params = toJsonParams();
    params.putIfAbsent("_method", () => "GET");

    dynamic body = json.encode(params);
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };

    return _parseHTTPClient.post(
      '${_parse._configuration.uri.path}/classes/$className',
      body: body,
      headers: headers,
    );
  }
}
