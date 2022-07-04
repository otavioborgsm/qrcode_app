class Scanner {
  Scanner({
    this.id,
    required this.type,
    required this.result,
  });
  late final int? id;
  late final String type;
  late final String result;
  
  Scanner.fromJson(Map<String, dynamic> json){
    id = json['id'];
    type = json['type'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['result'] = result;
    return data;
  }
}