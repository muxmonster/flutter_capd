import 'dart:convert';

class UserModel {
  final String id;
  final String telephone;
  final String password;
  final String fullname;
  UserModel({
    required this.id,
    required this.telephone,
    required this.password,
    required this.fullname,
  });

  UserModel copyWith({
    String? id,
    String? telephone,
    String? password,
    String? fullname,
  }) {
    return UserModel(
      id: id ?? this.id,
      telephone: telephone ?? this.telephone,
      password: password ?? this.password,
      fullname: fullname ?? this.fullname,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'telephone': telephone,
      'password': password,
      'fullname': fullname,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      telephone: map['telephone'],
      password: map['password'],
      fullname: map['fullname'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, telephone: $telephone, password: $password, fullname: $fullname)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.telephone == telephone &&
        other.password == password &&
        other.fullname == fullname;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        telephone.hashCode ^
        password.hashCode ^
        fullname.hashCode;
  }
}
