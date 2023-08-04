import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds :3),(){
      Navigator.pushReplacementNamed(context, '/out_boarding_screen');
  } );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'UI APP',
          style: GoogleFonts.tajawal(
          fontWeight: FontWeight.bold,
          fontSize: 30,
            color: Colors.black,
        ),
        ),
      ),
    );
  }
}
