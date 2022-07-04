class Scanner {
  Scanner({
    required this.id,
    required this.type,
    required this.result,
  });
  late final int id;
  late final String type;
  late final String result;
  
  Scanner.fromJson(Map<String, dynamic> json){
    id = json['id'];
    type = json['type'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['type'] = type;
    _data['result'] = result;
    return _data;
  }
}