import 'package:flutter/material.dart';

import 'Model/Customer_Model.dart';
import 'View/CustomerForm_Screen.dart';
import 'View/CustomerList_Screen.dart';
import 'View/EditCustomerForm_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/customer_form',
      routes: {
        '/customer_form': (context) => const CustomerForm(),
        '/customer_list': (context) => const CustomerListPage(),
        '/edit_customer': (context) => EditCustomerPage(
          customer: ModalRoute.of(context)!.settings.arguments as Customer,
        ),
      },
    );
  }
}



