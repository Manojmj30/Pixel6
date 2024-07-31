

import 'dart:convert';

PostcodeModel postcodeModelFromJson(String str) => PostcodeModel.fromJson(json.decode(str));

String postcodeModelToJson(PostcodeModel data) => json.encode(data.toJson());

class PostcodeModel {
  String? status;
  int? statusCode;
  int? postcode;
  List<City>? city;
  List<City>? state;

  PostcodeModel({
    this.status,
    this.statusCode,
    this.postcode,
    this.city,
    this.state,
  });

  factory PostcodeModel.fromJson(Map<String, dynamic> json) => PostcodeModel(
    status: json["status"],
    statusCode: json["statusCode"],
    postcode: json["postcode"],
    city: List<City>.from(json["city"].map((x) => City.fromJson(x))),
    state: List<City>.from(json["state"].map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "postcode": postcode,
    "city": List<dynamic>.from(city!.map((x) => x.toJson())),
    "state": List<dynamic>.from(state!.map((x) => x.toJson())),
  };
}

class City {
  int? id;
  String? name;

  City({
    this.id,
    this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
