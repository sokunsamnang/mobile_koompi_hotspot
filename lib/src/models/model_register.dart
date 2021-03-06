// To parse this JSON data, do
//
//     final registerModel = registerModelFromMap(jsonString);

import 'package:koompi_hotspot/all_export.dart';

RegisterModel registerModelFromMap(String str) => RegisterModel.fromMap(json.decode(str));

String registerModelToMap(RegisterModel data) => json.encode(data.toMap());

class RegisterModel {
    RegisterModel({
        this.name,
        this.gender,
        this.email,
        this.birthdate,
        this.address,
    });

    String name;
    String gender;
    String email;
    String password;
    String birthdate;
    String address;

    factory RegisterModel.fromMap(Map<String, dynamic> json) => RegisterModel(
        name: json["name"],
        gender: json["gender"],
        email: json["email"],
        birthdate: json["birthdate"],
        address: json["address"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "gender": gender,
        "email": email,
        "birthdate": birthdate,
        "address": address,
    };
}
