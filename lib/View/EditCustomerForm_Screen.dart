import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validatorless/validatorless.dart';


import '../Model/Customer_Model.dart';
import '../Services/api_services.dart';
import 'CustomerList_Screen.dart';

class EditCustomerPage extends StatefulWidget {
  final Customer customer;
  const EditCustomerPage({super.key, required this.customer});

  @override
  _EditCustomerPageState createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _panController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _postcodeController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;

  String _state = '';
  String _city = '';

  @override
  void initState() {
    super.initState();
    _panController = TextEditingController(text: widget.customer.pan);
    _fullNameController = TextEditingController(text: widget.customer.fullName);
    _emailController = TextEditingController(text: widget.customer.email);
    _mobileNumberController = TextEditingController(text: widget.customer.mobileNumber!.substring(3));
    _postcodeController = TextEditingController(text: widget.customer.addresses!.first.postcode);
    _addressLine1Controller = TextEditingController(text: widget.customer.addresses!.first.addressLine1);
    _addressLine2Controller = TextEditingController(text: widget.customer.addresses!.first.addressLine2);
    _state = widget.customer.addresses!.first.state.toString();
    _city = widget.customer.addresses!.first.city.toString();
  }

  Future<void> _getPostcodeDetails() async {
    try {
      final postcodeModel = await getPostcodeDetails(_postcodeController.text);
      if (postcodeModel.status == 'Success') {
        setState(() {
          _state = postcodeModel.state?.first.name ?? '';
          _city = postcodeModel.city?.first.name ?? '';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting postcode details: $e');
      }
    }
  }
  void _saveCustomer() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedCustomer = Customer(
        pan: _panController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
        mobileNumber: '+91 ${_mobileNumberController.text}',
        addresses: [
          Address(
            addressLine1: _addressLine1Controller.text,
            addressLine2: _addressLine2Controller.text,
            postcode: _postcodeController.text,
            state: _state,
            city: _city,
          ),
        ],
      );
      saveCustomerToLocalStorage(updatedCustomer);
      Navigator.pushNamed(context, '/customer_list');
    }
  }

  Future<void> saveCustomerToLocalStorage(Customer customer) async {
    final prefs = await SharedPreferences.getInstance();
    final customersJson = prefs.getStringList('customers') ?? [];
    final index = customersJson.indexWhere((json) => json.contains(widget.customer.pan.toString()));
    if (index != -1) {
      customersJson[index] = json.encode(customer.toJson());
    }
    await prefs.setStringList('customers', customersJson);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerListPage(),));
              },
            ),
            backgroundColor: Colors.black,
            title: const Text('Edit Customer',style: TextStyle(color: Colors.white),),
        ),
         body: SingleChildScrollView(
           child: Padding(
            padding: const EdgeInsets.fromLTRB(10,20,10,0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _panController,
                    decoration: const InputDecoration(
                        labelText: 'PAN',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                        labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: Validatorless.required('Email is required'),
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _mobileNumberController,
                    decoration: const InputDecoration(
                      prefixText: '+91 ',
                        labelText: 'Mobile Number',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: Validatorless.required('Mobile Number is required'),
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _addressLine1Controller,
                    decoration: const InputDecoration(
                        labelText: 'Address Line 1',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: Validatorless.required('Address Line 1 is required'),
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _addressLine2Controller,
                    decoration: const InputDecoration(
                        labelText: 'Address Line 2',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _postcodeController,
                    decoration: const InputDecoration(
                        labelText: 'Postcode',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),),
                    keyboardType: TextInputType.number,
                    validator: Validatorless.required('Postcode is required'),
                    onChanged: (value) async {
                      if (value.length == 6) {
                        await _getPostcodeDetails();
                      }
                    },
                  ),
                  const SizedBox(height:20),
                  DropdownButtonFormField<String>(
                    value: _state,
                    decoration: const InputDecoration(labelText: 'State',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    items: <String>[_state].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _state = newValue ?? '';
                      });
                    },
                  ),
                  const SizedBox(height:20),
                  DropdownButtonFormField<String>(
                    value: _city,
                    decoration: const InputDecoration(labelText: 'City',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    items: <String>[_city].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _city = newValue ?? '';
                      });
                    },
                  ),
                  const SizedBox(height:20),
                  InkWell(
                    onTap: _saveCustomer,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: const Center(child: Text('Save Customer',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),)),
                    ),
                  ),

                ],
              ),
            ),
                   ),
         ),
      ),
    );
  }
}
