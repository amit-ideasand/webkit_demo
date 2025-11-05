import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webkit/helpers/services/json_decoder.dart';
import 'package:webkit/models/identifier_model.dart';

class LeadReportModel extends IdentifierModel {
  final String firstName, email, phoneNumber, companyName, status, location;
  final DateTime date;
  final int amount;

  LeadReportModel(super.id, this.firstName, this.email, this.phoneNumber, this.companyName, this.status, this.location, this.date, this.amount);

  static LeadReportModel fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String firstName = decoder.getString('first_name');
    String email = decoder.getString('email');
    String phoneNumber = decoder.getString('phone_number');
    String companyName = decoder.getString('company_name');
    String status = decoder.getString('status');
    String location = decoder.getString('location');
    DateTime date = decoder.getDateTime('date');
    int amount = decoder.getInt('amount');

    return LeadReportModel(decoder.getId, firstName, email, phoneNumber, companyName, status, location, date, amount);
  }

  static List<LeadReportModel> listFromJSON(List<dynamic> list) {
    return list.map((e) => LeadReportModel.fromJSON(e)).toList();
  }

  static List<LeadReportModel>? _dummyList;

  static Future<List<LeadReportModel>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }

    return _dummyList!;
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/datas/leads_report_data.json');
  }
}
