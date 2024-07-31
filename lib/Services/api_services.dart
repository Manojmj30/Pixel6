import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/Pan_Model.dart';
import '../Model/PostCode_Model.dart';

Future<PanModel> verifyPan(String panNumber) async {
  final response = await http.post(
    Uri.parse('https://lab.pixel6.co/api/verify-pan.php'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'panNumber': panNumber}),
  );

  if (response.statusCode == 200) {
    return panModelFromJson(response.body);
  } else {
    throw Exception('Failed to verify PAN');
  }
}
Future<PostcodeModel> getPostcodeDetails(String postcode) async {
  final response = await http.post(
    Uri.parse('https://lab.pixel6.co/api/get-postcode-details.php'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'postcode': postcode}),
  );

  if (response.statusCode == 200) {
    return postcodeModelFromJson(response.body);
  } else {
    throw Exception('Failed to get postcode details');
  }
}
