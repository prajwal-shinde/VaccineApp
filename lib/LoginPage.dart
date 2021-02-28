import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vaccineapp/HomePage.dart';
import 'package:vaccineapp/Register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();

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
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user');

    return '$user';
  }

  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Signed Out");
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/img4.png'),
            Text(
              "You can simply sign in with your Google Account ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: ScreenUtil().setSp(18)),
            ),
            FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                minWidth: ScreenUtil().setWidth(190.0),
                color: Color(0xff00B0FF),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(15.0)),
                  ),
                )),
            Text(
              'OR',
              style: TextStyle(fontSize: ScreenUtil().setSp(20.0)),
            ),
            SignInButton(Buttons.Google, onPressed: () {
              signInWithGoogle().then((result) {
                if (result != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      },
                    ),
                  );
                }
              });
            }),
          ],
        ));
  }
}
