import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:vaccineapp/HomePage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

String email, password;

class _LoginState extends State<Login> {
  final GlobalKey<FormState> key = GlobalKey();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Image.asset('assets/img6.png')),
          Text('Please enter your registered credentials'),
          Form(
              key: key,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      validator: (email) {
                        if (email.isEmpty) {
                          return 'Please enter email!!!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Email', border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      validator: (password) {
                        if (password.length < 6) {
                          return 'Password should be 6 letters';
                        } else if (password.isEmpty) {
                          return 'Please enter password!!!';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password', border: OutlineInputBorder()),
                    ),
                  ),
                  FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: ScreenUtil().setHeight(45.0),
                      color: Color(0xff00B0FF),
                      onPressed: () async {
                        if (key.currentState.validate()) {
                          try {
                            await auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          } catch (e) {
                            if (e.code == "email-already-in-use") {
                              return showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'Please login email id already exists!!!'),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.pop(
                                              context,
                                            );
                                          },
                                          child: Text('Ok'))
                                    ],
                                  ));
                            } else if (e.code == "wrong-password") {
                              return showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text('Wrong Password'),
                                    content: Text('Wrong password!!!'),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Ok'))
                                    ],
                                  ));
                            }
                          }
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
