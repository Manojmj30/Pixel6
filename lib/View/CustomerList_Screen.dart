import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Customer_Model.dart';
import 'CustomerForm_Screen.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final customersJson = prefs.getStringList('customers') ?? [];
    setState(() {
      _customers = customersJson
          .map((customerJson) => Customer.fromJson(json.decode(customerJson)))
          .toList();
    });
  }

  Future<void> _deleteCustomer(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final customersJson = prefs.getStringList('customers') ?? [];
    customersJson.removeAt(index);
    await prefs.setStringList('customers', customersJson);
    _loadCustomers();
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerForm(),));
            },
          ),
          backgroundColor: Colors.black,
          title: const Text('Customer List',style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10,20,10,0),
          child: ListView.builder(
            itemCount: _customers.length,
            itemBuilder: (context, index) {
              final customer = _customers[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Border color
                        width: 2.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                child: ListTile(
                  title: Row(
                    children: [
                      const Text("Name : ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      Text(customer.fullName.toString(),style: const TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      const Text("E-mail : ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      Text(customer.email.toString(),style: const TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit,color: Colors.green,),
                        onPressed: () {
                          Navigator.pushNamed(context, '/edit_customer', arguments: customer);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,color: Colors.red,),
                        onPressed: () => _deleteCustomer(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
