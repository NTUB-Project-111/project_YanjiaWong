import 'package:flutter/material.dart';
import './pages/tabs.dart';
import './pages/remindpage.dart';
import './pages/registerpage.dart';
import './feature/database.dart';
import './pages/oktime.dart';

// class MyHttpOverrides extends HttpOverrides {
//   // @override
//   // HttpClient createHttpClient(SecurityContext? context) {
//   //   return super.createHttpClient(context)
//   //     ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   // }
// }
void main() {
  // HttpOverrides.global = MyHttpOverrides(); // 忽略 SSL 憑證
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void printUserId() async {
    String? userId = await DatabaseHelper.getUserId();
    
    print('User ID: $userId');
  }

  @override
  Widget build(BuildContext context) {
    printUserId();
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: oktimePage(),
      home: Tabs(),
      // home : RemindPage()
      // home: RegistrationPage(),
    );
  }
}
