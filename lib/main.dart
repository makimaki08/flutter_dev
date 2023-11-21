import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generated App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xff2196f3),
        canvasColor: const Color(0xfffafafa),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => MyHomePage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  @override
  void initState() {
    super.initState();
  }

  final _mail = TextEditingController();
  final _passWord = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              'INTERNET ACCESS.',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: ui.FontWeight.w500
              ),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            Text(
              'Email',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: ui.FontWeight.w500,
              ),
            ),
            TextField(
              controller: _mail,
              style: TextStyle(fontSize: 24.0),
              minLines: 1,
            ),
            Text(
              'Password',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: ui.FontWeight.w500
              ),
            ),
            TextField(
              controller: _passWord,
              style: TextStyle(fontSize: 24),
              minLines: 1,
            ),
            ElevatedButton(
              onPressed: signInWithMail,
              child: Text("Sign In"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.open_in_new),
        onPressed: () {
          var _userCredential = signInWithMail();
        },
      ),
    );
  }




  void signedAlert(String _userId) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Alert"),
          content: Text("ログイン成功！\nUserID：${_userId}"),
          // content: Text("サインイン成功"),
        )
    );
  }

  Future<Object> signInWithMail() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _mail.text,
        password: _passWord.text,
      );
      // signedAlert(userCredential.user!.uid);
      Navigator.pushNamed(
        context,
        '/home',
        arguments: userCredential.user!.uid
      );
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      rethrow;
    }
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _userId = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              "ログイン成功\nUser ID : ${_userId}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: ui.FontWeight.w500
              ),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.pop<String>(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

