import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaccineapp/Login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

String email, password, name, phone;
User user;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
addData() {
  Map<String, dynamic> data = {
    "email": email.trim(),
    "name": name.trim(),
    "phoneno": phone.trim()
  };
  _fireStoreDataBase.collection('users').doc(auth.currentUser.uid).set(data);
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> key = GlobalKey();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool succeslogin = false;
  Map data;
  fetchData() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    collectionReference.snapshots().listen((event) {
      setState(() {
        data = event.docs[0].data();
      });
    });
    print(data);
  }

  Future<bool> signup(String email, String password) async {
    try {
      auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      setState(() {
        succeslogin = true;
      });
    } catch (e) {
      setState(() {
        succeslogin = false;
      });
      switch (e.code) {
        case 'email-already-in-use':
          return showDialog(
              context: context,
              child: AlertDialog(
                title: Text('Try Again!!!'),
                content: Text('Please login email id already registerd!!'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok'))
                ],
              ));
          break;
        case 'invalid-email':
          return showDialog(
              context: context,
              child: AlertDialog(
                title: Text('Try Again!!!'),
                content: Text('Invalid Email!!'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok'))
                ],
              ));
          break;
        case 'weak-password':
          return showDialog(
              context: context,
              child: AlertDialog(
                title: Text('Weak Password!!!'),
                content: Text(
                    'Please select strong password to ensure best security!!'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok'))
                ],
              ));
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/img5.png'),
            ),
          ),
          Text(
            'Please enter all correct detail',
            style: TextStyle(fontSize: ScreenUtil().setSp(13.0)),
          ),
          Form(
              key: key,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      validator: (name) {
                        if (name.isEmpty) {
                          return 'Please enter name!!!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Name', border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      onChanged: (val) {
                        setState(() {
                          phone = val;
                        });
                      },
                      validator: (phone) {
                        if (phone.isEmpty) {
                          return 'Please enter contact number!!!';
                        }
                        if (phone.length > 10 || phone.length < 10) {
                          return 'Please enter correct contact number!!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Contact Number',
                          border: OutlineInputBorder()),
                    ),
                  ),
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
                          fetchData();
                          auth.createUserWithEmailAndPassword(
                              email: email.trim(), password: password.trim());
                          addData();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        }
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
