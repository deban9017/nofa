import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nofa/data.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void fillDates() async {
    // print('fillDates');
    List<Map> dates = await DatabaseService.instance.getDates();
    // print('got dates');
    if (dates.isEmpty) {
      dates = [];
      // print('dates is empty');
    }
    Navigator.pushReplacementNamed(context, '/home', arguments: dates);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fillDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color.fromARGB(255, 22, 31, 83),
            child: Center(
                child: SpinKitFadingCircle(
              color: Color.fromARGB(255, 167, 223, 255),
              size: 65.0,
            ))));
  }
}
