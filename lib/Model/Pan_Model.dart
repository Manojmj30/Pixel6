

import 'dart:convert';

PanModel panModelFromJson(String str) => PanModel.fromJson(json.decode(str));

String panModelToJson(PanModel data) => json.encode(data.toJson());

class PanModel {
  String? status;
  int? statusCode;
  bool? isValid;
  String? fullName;

  PanModel({
    this.status,
    this.statusCode,
    this.isValid,
    this.fullName,
  });

  factory PanModel.fromJson(Map<String, dynamic> json) => PanModel(
    status: json["status"],
    statusCode: json["statusCode"],
    isValid: json["isValid"],
    fullName: json["fullName"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "isValid": isValid,
    "fullName": fullName,
  };
}
