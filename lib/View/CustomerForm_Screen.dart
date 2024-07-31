import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validatorless/validatorless.dart';

import '../Model/Customer_Model.dart';
import '../Services/api_services.dart';
import 'CustomerList_Screen.dart';

class CustomerForm extends StatefulWidget {
  const CustomerForm({super.key});

  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final _panController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  String _state = '';
  String _city = '';
  bool _isPanValid = false;

  Future<void> _verifyPan() async {
    try {
      final panModel = await verifyPan(_panController.text);
      if (panModel.isValid == true) {
        setState(() {
          _isPanValid = true;
          _fullNameController.text = panModel.fullName ?? '';
        });
      } else {
        setState(() {
          _isPanValid = false;
        });
      }
    } catch (e) {
      // Handle error
      print('Error verifying PAN: $e');
    }
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
      // Save to local storage and navigate to list page
      final customer = Customer(
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
      saveCustomerToLocalStorage(customer);
      Navigator.pushNamed(context, '/customer_list');
    }
  }

  Future<void> saveCustomerToLocalStorage(Customer customer) async {
    final prefs = await SharedPreferences.getInstance();
    final customersJson = prefs.getStringList('customers') ?? [];
    customersJson.add(json.encode(customer.toJson()));
    await prefs.setStringList('customers', customersJson);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Add Customer',style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              color:Colors.white,
              icon:const Icon(Icons.list),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerListPage(),));
              },
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerListPage(),));
              },
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0,0,5,0),
                  child: Text('Lists',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ))
          ],
          centerTitle: true,
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
                    validator: Validatorless.multiple([
                      Validatorless.required('PAN is required'),
                     // Validatorless.maxLength(10, 'PAN cannot exceed 10 characters'),
                    ]),
                    onChanged: (value) async {
                      if (value.length == 10) {
                        await _verifyPan();
                      }
                    },
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: 'Full Name',labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),),
                    validator: Validatorless.required('Full Name is required'),
                    enabled: false,
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email',labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),),
                    validator: Validatorless.multiple([
                      Validatorless.required('Email is required'),
                      Validatorless.email('Enter a valid email'),
                     // Validatorless.maxLength(255, 'Email cannot exceed 255 characters'),
                    ]),
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _mobileNumberController,
                    decoration: const InputDecoration(
                      prefixText: '+91 ',
                      labelText: 'Mobile Number',labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),),
                    keyboardType: TextInputType.phone,
                    validator: Validatorless.multiple([
                      Validatorless.required('Mobile Number is required'),
                      //Validatorless.maxLength(10, 'Mobile Number cannot exceed 10 characters'),
                    ]),
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _addressLine1Controller,
                    decoration: const InputDecoration(labelText: 'Address Line 1',labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),),
                    validator: Validatorless.required('Address Line 1 is required'),
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _addressLine2Controller,
                    decoration: const InputDecoration(labelText: 'Address Line 2',labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),),
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: _postcodeController,
                    decoration: const InputDecoration(labelText: 'Postcode',labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),),
                    keyboardType: TextInputType.number,
                    validator: Validatorless.multiple([
                      Validatorless.required('Postcode is required'),
                     // Validatorless.maxLength(6, 'Postcode cannot exceed 6 characters'),
                    ]),
                    onChanged: (value) async {
                      if (value.length == 6) {
                        await _getPostcodeDetails();
                      }
                    },
                  ),
                  const SizedBox(height:20),
                  DropdownButtonFormField<String>(
                    value: _state,
                    decoration: const InputDecoration(labelText: 'State',labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),),
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
                    decoration: const InputDecoration(labelText: 'City',labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),),
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
