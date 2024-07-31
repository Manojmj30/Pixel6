class Customer {
  String? pan;
  String? fullName;
  String? email;
  String? mobileNumber;
  List<Address>? addresses;

  Customer({
    this.pan,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.addresses,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    pan: json["pan"],
    fullName: json["fullName"],
    email: json["email"],
    mobileNumber: json["mobileNumber"],
    addresses: List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pan": pan,
    "fullName": fullName,
    "email": email,
    "mobileNumber": mobileNumber,
    "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
  };
}

class Address {
  String? addressLine1;
  String? addressLine2;
  String? postcode;
  String? state;
  String? city;

  Address({
    this.addressLine1,
    this.addressLine2,
    this.postcode,
    this.state,
    this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"],
    postcode: json["postcode"],
    state: json["state"],
    city: json["city"],
  );

  Map<String, dynamic> toJson() => {
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "postcode": postcode,
    "state": state,
    "city": city,
  };
}
