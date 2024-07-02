import 'package:flutter/material.dart';
import 'package:nofa/calendar/calendar.dart';
import 'package:nofa/widgets/dataEntryCard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map> dates = [];
  List<DateTime> streakList = [];
  DuoCalendar calendar =
      DuoCalendar(dayNameLetters: 2); //Initializing a DuoCalendar object

  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    //Building Home widget
    dates = dates.isNotEmpty
        ? dates
        : ModalRoute.of(context)?.settings.arguments
            as List<Map>; //Fetching dates from arguments

    // print(dates);

    //dates = [{id: 2, date: 2024-06-17T14:59:51.807329, isPassed: 0}, .....]

    //Making StreakList from fetched dates
    List<String> dateStrings = [];
    // dates.map((e) => (e['date'].toString().substring(0, 10))).toList();
    if (dates.isNotEmpty) {
      for (int i = 0; i < dates.length; i++) {
        if (dates[i]['isPassed'] == 1) {
          dateStrings.add(dates[i]['date'].toString().substring(0, 10));
        }
      }
      // print(dateStrings);
      for (int i = 0; i < dateStrings.length; i++) {
        int year = int.parse(dateStrings[i].substring(0, 4));
        int month = int.parse(dateStrings[i].substring(5, 7));
        int day = int.parse(dateStrings[i].substring(8, 10));

        streakList.add(DateTime(year, month, day));
      }
    }

    calendar.streakList = streakList;
    calendar.setStreakData();

    //SUPPLYING THE BACK AND FORWARD BUTTON FUNCTIONS___________________________
    calendar.backButtonFunction = () {
      setState(() {
        calendar.streakList = streakList;
        calendar.supplyDate = calendar.supplyDateForPreviousMonth;
        calendar.calendarBuild(context);
      });
    };
    calendar.forwardButtonFunction = () {
      setState(() {
        calendar.streakList = streakList;
        calendar.supplyDate = calendar.supplyDateForNextMonth;
        calendar.calendarBuild(context);
      });
    };
    //__________________________________________________________________________

    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: calendar.StreakDataDashboard(context),
            ),
            SizedBox(
              height: 25,
            ),
            Container(child: calendar.calendarBuild(context)),
            SizedBox(
              height: 18,
            ),
            Container(
              child: DataEntryCard(context),
            ),
          ],
        ),
      ),
    ));
  }
}
