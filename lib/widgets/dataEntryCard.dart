import 'package:flutter/material.dart';
import 'package:nofa/data.dart';
import 'package:chiclet/chiclet.dart';

Widget DataEntryCard(BuildContext context) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: ChicletOutlinedAnimatedButton(
                height: 60,
                backgroundColor: Color.fromARGB(255, 24, 164, 31),
                borderColor: Color.fromARGB(255, 18, 114, 23),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => DataEntryDialog());
                },
                child: Text(
                  'Did you Pass Today?👀',
                  style: TextStyle(
                    fontFamily: 'Acme',
                    letterSpacing: 2,
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ));
}

class DataEntryDialog extends StatefulWidget {
  const DataEntryDialog({super.key});

  @override
  State<DataEntryDialog> createState() => _DataEntryDialogState();
}

class _DataEntryDialogState extends State<DataEntryDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Did you pass today?',
              style: TextStyle(
                fontFamily: 'Acme',
                letterSpacing: 2,
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChicletOutlinedAnimatedButton(
                  width: 80,
                  height: 60,
                  backgroundColor: Color.fromARGB(255, 24, 164, 31),
                  borderColor: Color.fromARGB(255, 18, 114, 23),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  onPressed: () async {
                    List<Map> dates = [];
                    dates = await DatabaseService.instance.getDates();
                    bool flag = false;
                    int id = 0;

                    for (int i = 0; i < dates.length; i++) {
                      if (dates[i]['date'].toString().substring(0, 10) ==
                          DateTime.now().toString().substring(0, 10)) {
                        id = dates[i]['id'];
                        flag = true;
                        break;
                      }
                    }
                    if (flag == true) {
                      await DatabaseService.instance
                          .updateIsPassed(id.toString(), 1);
                    } else {
                      await DatabaseService.instance.addDate(DateTime.now(), 1);
                    }
                    Navigator.pop(context);

                    setState(() async {
                      List<Map> dates =
                          await DatabaseService.instance.getDates();
                      Navigator.pushReplacementNamed(context, '/home',
                          arguments: dates);
                    });
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontFamily: 'Acme',
                      letterSpacing: 2,
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                ChicletOutlinedAnimatedButton(
                  width: 80,
                  height: 60,
                  backgroundColor: Color.fromARGB(255, 182, 43, 11),
                  borderColor: Color.fromARGB(255, 130, 28, 5),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  onPressed: () async {
                    Navigator.pop(context);
                    //if the user didn't pass today, we first check if there is any date entry for today
                    //if not, we add a date entry with isPassed = 0
                    //if there is, we update the isPassed value to 0
                    //then we navigate to the home page
                    List<Map> dates = [];
                    dates = await DatabaseService.instance.getDates();
                    bool flag = false;
                    int id = 0;

                    for (int i = 0; i < dates.length; i++) {
                      if (dates[i]['date'].toString().substring(0, 10) ==
                          DateTime.now().toString().substring(0, 10)) {
                        id = dates[i]['id'];
                        flag = true;
                        break;
                      }
                    }
                    if (flag == true) {
                      await DatabaseService.instance
                          .updateIsPassed(id.toString(), 0);
                    } else {
                      await DatabaseService.instance.addDate(DateTime.now(), 0);
                    }

                    //  DatabaseService.instance.addDate(DateTime.now(), 0);

                    setState(() async {
                      List<Map> dates =
                          await DatabaseService.instance.getDates();
                      Navigator.pushReplacementNamed(context, '/home',
                          arguments: dates);
                    });
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontFamily: 'Acme',
                      letterSpacing: 2,
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
