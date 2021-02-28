import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vaccineapp/SlideScreen.dart';
import 'package:vaccineapp/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        allowFontScaling: true,
        builder: () => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Muli-Light',
                primaryColor: Color(0xff00B0FF),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: SplashScreen(),
            ));
  }
}
