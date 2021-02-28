import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vaccineapp/AppointmentBook.dart';
import 'package:vaccineapp/LoginPage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:vaccineapp/Register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

String name;
String email;
String phone, date;
Position _currentPosition;
String _currentAddress;
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
final GoogleSignIn googleSignIn = GoogleSignIn();
String imageUrl;
GoogleMapController myController;
FirebaseAuth _auth = FirebaseAuth.instance;
Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }
    return '$user';
  }
  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
  await _auth.signOut();
  print("User Signed Out");
}

class _HomePageState extends State<HomePage> {
  static const apikey = 'AIzaSyBlWOGAiNdUuSmpTxJzb2r1pCRqJshFlXY';
  double Lng;
  double Lat;
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.name},${place.subLocality},${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      setState(() {
        Lat = _currentPosition.latitude;
      });
      setState(() {
        Lng = _currentPosition.longitude;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  User user;
  int _selectedIndex = 0;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  List<String> numbers = [];
  final tabs = [Body1()];
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xff00B0FF),
                boxShadow: [
                  BoxShadow(blurRadius: 10.0, color: Colors.blueGrey)
                ],
                borderRadius: BorderRadius.circular(15.0)),
            height: ScreenUtil().setHeight(180.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CircleAvatar(
                    child: Icon(Icons.account_circle) ??
                        Image.network(_googleSignIn.currentUser.photoUrl),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 38.0),
                      child: Text(
                        _googleSignIn.currentUser.displayName ?? '',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(18)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _googleSignIn.currentUser.email ??
                            _auth.currentUser.email,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(18)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 170.0),
                      child: FlatButton.icon(
                          color: Color(0xff00B0FF),
                          onPressed: () {
                            signOutGoogle();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.logout, color: Colors.white),
                          label: Text(
                            'Logout',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(18)),
                          )),
                    ),
                    if (_currentPosition != null && _currentAddress != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          Text(
                            _currentAddress,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(17.0)),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('centers')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshots) {
                  if (!snapshots.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: snapshots.data.docs.map((e) {
                      return ListTile(
                        title: Text(e['Health Facility Name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(e['Address'])],
                        ),
                        trailing: FlatButton(
                            color: Color(0xff00B0FF),
                            onPressed: () {
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Select Date and Time'),
                                      content: Column(
                                        children: [
                                          Text(
                                              'Book your appointment by selecting date and time'),
                                          DateTimePicker(
                                            type: DateTimePickerType
                                                .dateTimeSeparate,
                                            dateMask: 'd MMM, yyyy',
                                            initialValue:
                                                DateTime.now().toString(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                            icon: Icon(Icons.event),
                                            dateLabelText: 'Date',
                                            timeLabelText: "Hour",
                                            onChanged: (val) =>
                                                {date = val, print(val)},
                                            validator: (val) {
                                              setState(() {
                                                date = val;
                                              });
                                              print(val);
                                              return null;
                                            },
                                            onSaved: (val) =>
                                                {date = val, print(val)},
                                          ),
                                          Form(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.phone,
                                                onChanged: (val) {
                                                  setState(() {
                                                    phone = val;
                                                  });
                                                },
                                                validator: (phone) {
                                                  if (phone.isEmpty) {
                                                    return 'Please enter contact number!!!';
                                                  }
                                                  if (phone.length > 10 ||
                                                      phone.length < 10) {
                                                    return 'Please enter correct contact number!!';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    hintText: 'Contact Number',
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                            ),
                                          ),
                                          FlatButton.icon(
                                              onPressed: () {
                                                numbers.add(phone);
                                                _sendSMS(
                                                    "Welcome to Vaccinator Center App your appointment at ${e['Health Facility Name']} on {$date}.Please be present on time.",
                                                    numbers);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AppointmentBook()));
                                              },
                                              color: Color(0xff00B0FF),
                                              icon: Icon(Icons.check,
                                                  color: Colors.white),
                                              label: Text('Book Appointment'))
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Text(
                              'Book Appointment',
                              style: TextStyle(color: Colors.white),
                            )),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Body1 extends StatefulWidget {
  @override
  _Body1State createState() => _Body1State();
}

class _Body1State extends State<Body1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
