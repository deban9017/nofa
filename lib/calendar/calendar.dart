import 'dart:ui';
import 'dart:core';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nofa/calendar/streakservice.dart';

class DuoCalendar {
  late int numberOfDaysInMonth;

//StreakData Calculation as part of the calendar class__________________________
  int longest_Streak = 0;
  int last_Streak = 0;
  bool current_StreakIsLastStreak = false;

//Supply [start]________________________________________________________________
  //Supply back and forward button functions
  Function() backButtonFunction = () {};
  Function() forwardButtonFunction = () {};

  DateTime supplyDate = DateTime.now(); //Date to be supplied
  DateTime supplyDateForPreviousMonth = DateTime.now();
  DateTime supplyDateForNextMonth = DateTime.now();

//Supply [end]__________________________________________________________________

//Constructor___________________________________________________________________
  DuoCalendar({this.dayNameLetters = 3});

//USER_PROPERTY [start]_________________________________________________________
  List<DateTime> streakList =
      []; //USER_PROPERTY //List of dates to be highlighted
  List<int> colorList = [];
  List<Color> colorPaletteList = [];
  int dayNameLetters;

  //Colors___________________________________>>>>>>>

  //Miscellaneous
  Color calendarColor = Color.fromARGB(0, 255, 255, 255); //USER_PROPERTY
  Color calendarBorderColor =
      Color.fromARGB(255, 148, 148, 148); //USER_PROPERTY

  //Control Colors
  Color controlcolor = const Color.fromARGB(255, 255, 255, 255); //USER_PROPERTY
  Color controlBorderColor = const Color.fromARGB(255, 0, 0, 0); //USER_PROPERTY
  Color controlFontColor = const Color.fromARGB(255, 0, 0, 0); //USER_PROPERTY

  //Header Colors
  Color headercolor = Color.fromARGB(255, 202, 202, 202); //USER_PROPERTY
  Color headerElemcolor = Color.fromARGB(255, 202, 202, 202); //USER_PROPERTY
  Color headerBorderColor = Color.fromARGB(255, 202, 202, 202); //USER_PROPERTY
  Color headerElemBorderColor =
      Color.fromARGB(255, 202, 202, 202); //USER_PROPERTY
  Color headerFontColor = Color.fromARGB(255, 0, 0, 0); //USER_PROPERTY

  //Body Colors
  Color bodycolor = Color.fromARGB(255, 255, 255, 255); //USER_PROPERTY
  Color bodyBorderColor = Color.fromARGB(255, 128, 128, 128); //USER_PROPERTY
  Color bodyFontColor = const Color.fromARGB(255, 0, 0, 0); //USER_PROPERTY
  Color bodyRowcolor = Color.fromARGB(255, 255, 238, 219); //USER_PROPERTY
  Color bodyRowBorderColor = Color.fromARGB(0, 0, 0, 0); //USER_PROPERTY
  Color rowElementCircleColor =
      Color.fromARGB(255, 133, 133, 133); //USER_PROPERTY

  //Leading Days Colors
  Color leadingElementColor =
      Color.fromARGB(255, 255, 238, 219); //USER_PROPERTY
  Color leadingDaysFontColor =
      Color.fromARGB(255, 255, 238, 219); //USER_PROPERTY
  Color leadingElemBorderColor =
      Color.fromARGB(255, 255, 238, 219); //USER_PROPERTY

//Trailing Days Colors
  Color trailingElementColor =
      Color.fromARGB(255, 255, 238, 219); //USER_PROPERTY
  Color trailingDaysFontColor =
      Color.fromARGB(255, 255, 238, 219); //USER_PROPERTY
  Color trailingElemBorderColor =
      Color.fromARGB(255, 255, 238, 219); //USER_PROPERTY

//Streak Colors
  Color streakColorCurrentMonth =
      Color.fromARGB(255, 255, 190, 116); //USER_PROPERTY
  Color streakColorPreviousMonth =
      Color.fromARGB(255, 255, 238, 219); //USER_PROPERTY
  Color streakStartColor = Color.fromARGB(255, 255, 190, 116); //USER_PROPERTY
  Color streakEndColor = Color.fromARGB(255, 255, 190, 116); //USER_PROPERTY
  Color streakSingleDayColor =
      Color.fromARGB(255, 255, 190, 116); //USER_PROPERTY

  //Streak Dashboard____________________________________________________________
  Color streakDashboardColor =
      Color.fromARGB(255, 224, 224, 224); //USER_PROPERTY
  Color streakDashboardBorderColor =
      Color.fromARGB(255, 59, 59, 59); //USER_PROPERTY
  Color streakDashboardFontColor = Color.fromARGB(255, 0, 0, 0); //USER_PROPERTY
  Color streakDashboardDigitFontColor =
      Color.fromARGB(255, 228, 122, 0); //USER_PROPERTY
  String streakDashboardFontFamily = 'Nunito'; //USER_PROPERTY
  double streakDashboardFontSize = 25; //USER_PROPERTY
  double streakDashboardDigitFontSize = 47; //USER_PROPERTY
  double streakDashboardLineSpace = 0; //USER_PROPERTY
  FontWeight streakDashboardFontWeight = FontWeight.w900; //USER_PROPERTY
  FontWeight streakDashboardDigitFontWeight = FontWeight.w900; //USER_PROPERTY
  double streakDashboardDividerHeight = 80; //USER_PROPERTY
  Color streakDashboardDividerColor =
      Color.fromARGB(255, 108, 108, 108); //USER_PROPERTY
  double streakDashboardDividerThickness = 4; //USER_PROPERTY
  double streakDashboardDividerWidth = 7; //USER_PROPERTY

  //Colors [end]__________________________>>>>>>>>

  //Border Width
  double headerBorderWidth = 0; //USER_PROPERTY
  double bodyBorderWidth = 2; //USER_PROPERTY
  double controlBorderWidth = 1; //USER_PROPERTY
  double bodyRowBorderWidth = 3; //USER_PROPERTY
  double bodyElemBorderWidth = 0; //USER_PROPERTY
  double headerElemBorderWidth = 0; //USER_PROPERTY
  double calendarBorderWidth = 3; //USER_PROPERTY
  double streakDashboardBorderWidth = 3; //USER_PROPERTY

  //Width
  double allElemWidth = 54; //USER_PROPERTY
  double headerBodyGap = 15; //USER_PROPERTY
  double controlHeaderGap = 15; //USER_PROPERTY

  //Padding
  double calendarBodyPad = 10; //NOT USER PROPERTY //KEEP 0
  double headerSidePad = 0; //NOT USER PROPERTY //KEEP 0
  double headerUpDownPad = 5; //USER_PROPERTY // Padding of header row container
  double bodyRowSidePad =
      5; //USER_PROPERTY //MARKED //B/w calendar total body and row body //1 //DONE_DOCUMENTATION
  double bodyRowUpDownPad = 10; //USER_PROPERTY //2 //DONE_DOCUMENTATION

  double bodyRowSpaceing = 3; //USER_PROPERTY  //3 //DONE_DOCUMENTATION

  double headerHorizontalPad =
      0; //USER_PROPERTY //NOT_REQUIRED //KEEP 0 //4 //DONE_DOCUMENTATION
  double headerVerticalPad =
      5; //USER_PROPERTY //Header elem container padding //5 //DONE_DOCUMENTATION

  double rowHorizontalPad =
      0; //USER_PROPERTY //NOT_REQUIRED , since Expanded used //KEEP 0
  double rowElemVerticalPad = 0; //USER_PROPERTY //Row elem container padding

  double bodyRowHorizontalPad =
      2; //USER_PROPERTY //MARKED //b/w 1st and last elem with start and end sides of row
  double bodyRowVerticalPad =
      0; //USER_PROPERTY //Row elem container and row container vertical gap, padding of row container

  //Border Radius
  BorderRadius headerBorderRadius = BorderRadius.circular(100); //USER_PROPERTY
  BorderRadius bodyBorderRadius = BorderRadius.circular(20); //USER_PROPERTY
  BorderRadius controlBorderRadius = BorderRadius.circular(100); //USER_PROPERTY
  BorderRadius bodyRowBorderRadius = BorderRadius.circular(100); //USER_PROPERTY
  double bodyRowElemBorderRadius = 40; //USER_PROPERTY
  BorderRadius calendarBorderRadius = BorderRadius.circular(20); //USER_PROPERTY

  BorderRadius headerElemBorderRadius =
      BorderRadius.circular(0); //USER_PROPERTY
  //Fonts
  //Control_Font
  String controlFontFamily = 'Nunito'; //USER_PROPERTY
  double controlFontSize = 20; //USER_PROPERTY
  FontWeight controlFontWeight = FontWeight.bold; //USER_PROPERTY

  //Header_Font
  String headerFontFamily = 'Nunito'; //USER_PROPERTY
  double headerFontSize = 18; //USER_PROPERTY
  FontWeight headerFontWeight = FontWeight.w800; //USER_PROPERTY

  //Body_Font
  String bodyFontFamily = 'Nunito'; //USER_PROPERTY
  double bodyFontSize = 20; //USER_PROPERTY
  FontWeight bodyFontWeight = FontWeight.w700; //USER_PROPERTY

  //Leading_Days_Font
  String leadingDaysFontFamily = 'Nunito'; //USER_PROPERTY
  double leadingDaysFontSize = 20; //USER_PROPERTY
  FontWeight leadingDaysFontWeight = FontWeight.w700; //USER_PROPERTY

  //Trailing_Days_Font
  String trailingDaysFontFamily = 'Nunito'; //USER_PROPERTY
  double trailingDaysFontSize = 20; //USER_PROPERTY
  FontWeight trailingDaysFontWeight = FontWeight.bold; //USER_PROPERTY

//USER_PROPERTY [end]___________________________________________________________

  List<int> currentMonthColorList = [];

  //Day Names, choose any list according to choice //Contains USER_PROPERTY
  List<String> dayNames = []; //Determined by user while building the widget

  //Day Names, 3 letters
  List<String> dayNames3letters = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  //Day Names, 2 letters
  List<String> dayNames2letters = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  int selectedMonth =
      DateTime.now().month; //TODO: Set to currently selected month
  int selectedYear = DateTime.now().year; //TODO: Set to currently selected year

  List<int> dayList = []; //TODO
  List<int> leadingDayList = []; //TODO
  List<int> trailingDayList = []; //TODO
  int numberOfRows = 0; //Number of rows in the calendar
  List<int> monthList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  //initializing variable values //INITIALIZER
  List<List<int>> setValues() {
    streakList = streakList.toSet().toList();
    //sort the streakList
    streakList.sort();

    dayList = [];
    leadingDayList = [];
    trailingDayList = [];
    selectedMonth = supplyDate.month;
    selectedYear = supplyDate.year;
    numberOfDaysInMonth = setNumberofdaysInMonth(selectedMonth);
    supplyDateForPreviousMonth = DateTime(selectedYear, selectedMonth - 1, 1);
    supplyDateForNextMonth = DateTime(selectedYear, selectedMonth + 1, 1);

    generateDayList();

    List<List<int>> dayListMap_pre = buildDayListMap();

    //Now we fill the dayListMap Such that it has 42 elements
    //the list within the main list looks like [day, streakdata, month], all dates in the dayList are taken
    //But now, the streak data has one more value 4, day is not in streak

    List<List<int>> dayListMap = buildFinalDayListMap(dayListMap_pre);

    return dayListMap;
  }

  List<List<int>> buildFinalDayListMap(List<List<int>> dayListMap_pre) {
    List<List<int>> dayListMap_final = [];
    bool monthflag = true;

    // print(dayListMap_pre);

    if (dayListMap_pre.length == 0) {
      for (int i = 0; i < dayList.length; i++) {
        dayListMap_final.add([dayList[i], 4, 0, 4]);
      }
    } else {
      for (int i = 0, j = 0;
          i < dayList.length && j < dayListMap_pre.length;
          i++) {
        int monthdata = 0;
        if (i < 7) {
          //previous month dates will be within 1st 7 elements
          if (dayList[i] == 1) {
            monthflag = false;
          } else if (i > 0 && dayList[i - 1] > dayList[i]) {
            monthflag = false;
          }
          if (monthflag) {
            monthdata = -1;
          }
        }

        if (dayList[i] == dayListMap_pre[j][0] &&
            monthdata == dayListMap_pre[j][2]) {
          dayListMap_final.add(dayListMap_pre[j]);
          j++;
        } else {
          dayListMap_final.add([dayList[i], 4, monthdata, 4]);
        }
      }
    }

    // print(dayListMap_final);

    //make the dayListMap_final upto 42 days, add trailing [0,4,1]s
    //but we don't update numberOfRows here
    //later we hide the rows with all 0s
    while (dayListMap_final.length < 42) {
      dayListMap_final.add([0, 4, 1, 4]);
    }
    //For rounding the corners of the 1st row-1st element and last row last elem,
    // if those have streakdata 2 or 3
    //if 3, we change to 1
    //if 2, we change to 0

    List<List<int>> dayListMap_final_round = roundCorners(dayListMap_final);

    List<List<int>> dayListMapColorSet =
        Confirm5elem(dayListMapColorSetter(dayListMap_final_round));

    return dayListMapColorSet;
  }

  List<List<int>> Confirm5elem(List<List<int>> dayListMapList) {
    List<List<int>> dayListMapListFinal = [];
    for (int i = 0; i < dayListMapList.length; i++) {
      if (dayListMapList[i].length == 4) {
        dayListMapListFinal.add([
          dayListMapList[i][0],
          dayListMapList[i][1],
          dayListMapList[i][2],
          dayListMapList[i][3],
          dayListMapList[i][1]
        ]);
      } else {
        dayListMapListFinal.add(dayListMapList[i]);
      }
    }
    return dayListMapListFinal;
  }

  List<List<int>> roundCorners(List<List<int>> dayListMap_final_round) {
    if (dayListMap_final_round[0][1] == 3) {
      dayListMap_final_round[0][1] = 1;
    } else if (dayListMap_final_round[0][1] == 2) {
      dayListMap_final_round[0][1] = 0;
    }
    if (dayListMap_final_round[6][1] == 3) {
      dayListMap_final_round[6][1] = 2;
    } else if (dayListMap_final_round[6][1] == 1) {
      dayListMap_final_round[6][1] = 0;
    }

    if (dayListMap_final_round[7][1] == 3) {
      dayListMap_final_round[7][1] = 1;
    } else if (dayListMap_final_round[7][1] == 2) {
      dayListMap_final_round[7][1] = 0;
    }

    if (dayListMap_final_round[13][1] == 3) {
      dayListMap_final_round[13][1] = 2;
    } else if (dayListMap_final_round[13][1] == 1) {
      dayListMap_final_round[13][1] = 0;
    }
    if (dayListMap_final_round[14][1] == 3) {
      dayListMap_final_round[14][1] = 1;
    } else if (dayListMap_final_round[14][1] == 2) {
      dayListMap_final_round[14][1] = 0;
    }
    if (dayListMap_final_round[20][1] == 3) {
      dayListMap_final_round[20][1] = 2;
    } else if (dayListMap_final_round[20][1] == 1) {
      dayListMap_final_round[20][1] = 0;
    }
    if (dayListMap_final_round[21][1] == 3) {
      dayListMap_final_round[21][1] = 1;
    } else if (dayListMap_final_round[21][1] == 2) {
      dayListMap_final_round[21][1] = 0;
    }
    if (dayListMap_final_round[27][1] == 3) {
      dayListMap_final_round[27][1] = 2;
    } else if (dayListMap_final_round[27][1] == 1) {
      dayListMap_final_round[27][1] = 0;
    }
    if (dayListMap_final_round[28][1] == 3) {
      dayListMap_final_round[28][1] = 1;
    } else if (dayListMap_final_round[28][1] == 2) {
      dayListMap_final_round[28][1] = 0;
    }
    if (dayListMap_final_round[34][1] == 3) {
      dayListMap_final_round[34][1] = 2;
    } else if (dayListMap_final_round[34][1] == 1) {
      dayListMap_final_round[34][1] = 0;
    }
    if (dayListMap_final_round[35][1] == 3) {
      dayListMap_final_round[35][1] = 1;
    } else if (dayListMap_final_round[35][1] == 2) {
      dayListMap_final_round[35][1] = 0;
    }
    if (dayListMap_final_round[41][1] == 3) {
      dayListMap_final_round[41][1] = 2;
    } else if (dayListMap_final_round[41][1] == 1) {
      dayListMap_final_round[41][1] = 0;
    }

    return dayListMap_final_round;
  }

  //generating list of days
  void generateDayList() {
    //Value settings of global variables in this function:
    //numberOfRows, dayList
    dayList = [];
    int prevMonthDays = setNumberofdaysInMonth(selectedMonth - 1);
    // int nextMonthDays = setNumberofdaysInMonth(selectedMonth + 1); //Not used

    int firstDayWeekDay = DateTime(selectedYear, selectedMonth, 1).weekday;
    int lastDayWeekDay =
        DateTime(selectedYear, selectedMonth, numberOfDaysInMonth)
            .weekday; //Last day of the month

    //Number of rows in the calendar
    numberOfRows = determineNumberOfRows(
        firstDayWeekDay, lastDayWeekDay, numberOfDaysInMonth);

    //Adding days of previous month
    int startDay = prevMonthDays - firstDayWeekDay + 2;
    for (int i = 0; i < firstDayWeekDay - 1; i++) {
      dayList.add(startDay + i);
      leadingDayList.add(startDay + i);
    }
    //Adding days of current month
    for (int i = 1; i <= numberOfDaysInMonth; i++) {
      dayList.add(i);
    }
    //Adding days of next month
    for (int i = 1; i <= 7 - lastDayWeekDay; i++) {
      dayList.add(0);
      trailingDayList.add(i);
    }

    //make the dayList upto 42 days, add trailing 0s
    //but we don't update numberOfRows here
    //later we hide the rows with all 0s
    while (dayList.length < 42) {
      dayList.add(0);
    }
  }

  //Determining number of rows in the calendar
  int determineNumberOfRows(int firstDay, int lastDay, int numberOfDays) {
    //no global variables are used in this function //LOCAL FUNCTION

    int no_rows = 0;
    int startOffset = 8 - firstDay;
    int endOffset = lastDay;

    //Now, one row for each startOffset and endOffset
    //rest of the days are divided by 7
    no_rows = (2 + (numberOfDays - startOffset - endOffset) ~/ 7);

    return no_rows;
  }

  //Set number of days in a month

  int setNumberofdaysInMonth(choiceMonth) {
    //no global variables are used in this function //LOCAL FUNCTION

    int entryMonthDays;
    List days31months = [1, 3, 5, 7, 8, 10, 12];
    List days30months = [4, 6, 9, 11];
    //function used inside the Widget build function
    if (days31months.contains(choiceMonth)) {
      entryMonthDays = 31;
    } else if (days30months.contains(choiceMonth)) {
      entryMonthDays = 30;
    } else {
      if (selectedYear % 4 == 0) {
        if (selectedYear % 100 == 0) {
          if (selectedYear % 400 == 0) {
            entryMonthDays = 29;
          } else {
            entryMonthDays = 28;
          }
        } else {
          entryMonthDays = 29;
        }
      } else {
        entryMonthDays = 28;
      }
    }
    return entryMonthDays;
  }

  //Building dayListMapList for total view, for Streaks

  //[[daylistelem0, 0], [daylistelem1,2],....]
  List<List<int>> buildDayListMap() {
    circleColorSetter(); //prepares for Circle Color code addition at 4th index
    List<List<int>> dayListMapList = [];
    List<List<int>> dayListMapListPrevMonth = [];
    List<List<int>> dayListMapListNextMonth = [];

    //RULE:
    //the lists inside the list looks like [27,2,-1]
    //1st element is the day, 2nd element is the streak status, 3rd element is the month status
    //month status: -1 for previous month, 0 for current month, 1 for next month
    //for the leading days
    StreakService _leadingStreak = StreakService();
    _leadingStreak.streakList = streakList;
    _leadingStreak.supplyDate = DateTime(
        supplyDate.year, supplyDate.month - 1, 1); //supplyDateForPreviousMonth
    _leadingStreak.CalculateStreaks();
    if (_leadingStreak.streakListFilter.length > 0) {
      for (DateTime dateTime in _leadingStreak.streakListFilter) {
        // Check if the key (dateTime) exists in streakListFilterGroup
        for (Map<DateTime, int> dateTimeMap
            in _leadingStreak.streakListFilterGroup) {
          if (dateTimeMap.containsKey(dateTime)) {
            dayListMapListPrevMonth.add([
              dateTime.day,
              dateTimeMap[dateTime]!,
              -1,
              dateTimeMap[dateTime]!
            ]);
          }
        }
      }
      //Now, we have the dayListMapListPrevMonth
      //We check against the leadingDayList, and fill the dayListMapList

      for (int i = 0; i < leadingDayList.length; i++) {
        for (int j = 0; j < dayListMapListPrevMonth.length; j++) {
          if (leadingDayList[i] == dayListMapListPrevMonth[j][0]) {
            dayListMapList.add(dayListMapListPrevMonth[j]);
          }
        }
      }
    }

    //for the current month
    StreakService _currentMonthStreak = StreakService();
    _currentMonthStreak.streakList = streakList;
    _currentMonthStreak.supplyDate = supplyDate;
    _currentMonthStreak.CalculateStreaks();
    for (DateTime dateTime in _currentMonthStreak.streakListFilter) {
      // Check if the key (dateTime) exists in streakListFilterGroup
      for (Map<DateTime, int> dateTimeMap
          in _currentMonthStreak.streakListFilterGroup) {
        if (dateTimeMap.containsKey(dateTime)) {
          dayListMapList.add([
            dateTime.day,
            dateTimeMap[dateTime]!,
            0,
            dateTimeMap[dateTime]!
          ]);
        }
      }
    }

    //for the trailing days
    StreakService _trailingStreak = StreakService();
    _trailingStreak.streakList = streakList;
    _trailingStreak.supplyDate = supplyDateForNextMonth;
    _trailingStreak.CalculateStreaks();
    if (_trailingStreak.streakListFilter.length > 0) {
      for (DateTime dateTime in _trailingStreak.streakListFilter) {
        // Check if the key (dateTime) exists in streakListFilterGroup
        for (Map<DateTime, int> dateTimeMap
            in _trailingStreak.streakListFilterGroup) {
          if (dateTimeMap.containsKey(dateTime)) {
            dayListMapListNextMonth.add([
              dateTime.day,
              dateTimeMap[dateTime]!,
              1,
              dateTimeMap[dateTime]!
            ]);
          }
        }
      }

      //Now, we have the dayListMapListNextMonth
      //We check against the trailingDayList, and fill the dayListMapList
      for (int i = 0; i < trailingDayList.length; i++) {
        for (int j = 0; j < dayListMapListNextMonth.length; j++) {
          if (trailingDayList[i] == dayListMapListNextMonth[j][0]) {
            dayListMapList.add(dayListMapListNextMonth[j]);
          }
        }
      }
    }
    return (dayListMapList);
  }

  void setStreakData() {
    StreakService _streakService = StreakService();

    _streakService.streakList = streakList;

    _streakService.supplyDate = supplyDate;

    _streakService.CalculateStreaks();

    _streakService.CalculateStreakData();

    longest_Streak = _streakService.longestStreak;

    last_Streak = _streakService.lastStreak;

    current_StreakIsLastStreak = _streakService.currentStreakIsLastStreak;
  }

  BorderRadius getBorderRadius(int x, double r) {
    switch (x) {
      case 0:
        return BorderRadius.all(Radius.circular(r));
      case 1:
        return BorderRadius.only(
          topLeft: Radius.circular(r),
          bottomLeft: Radius.circular(r),
        );
      case 2:
        return BorderRadius.only(
          topRight: Radius.circular(r),
          bottomRight: Radius.circular(r),
        );
      default:
        return BorderRadius.zero; // All corners with 0 radius
    }
  }

  Color getRowElementColor(int streakData, int monthData) {
    if (streakData != 4) {
      switch (monthData) {
        case -1:
          return streakColorPreviousMonth;
        case 0:
          return streakColorCurrentMonth;
        default:
          return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }

  Color getElemBorderColor(int streakData, int monthData) {
    if (streakData != 4) {
      switch (monthData) {
        case -1:
          return streakColorPreviousMonth;
        case 0:
          return streakColorCurrentMonth;
        default:
          return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }

  Color getCircleColor(int streakData, int monthData) {
    if (streakData == 4) {
      return Colors.transparent;
    }
    if (streakData >= 0 && monthData == 0) {
      if (streakData == 1) {
        return streakStartColor;
      } else if (streakData == 2) {
        return streakEndColor;
      } else if (streakData == 0) {
        return streakSingleDayColor;
      } else {
        return streakColorCurrentMonth;
      }
    }
    if (streakData < 0 && monthData == 0) {
      return colorPaletteList[(-streakData) - 1];
    }
    return Colors.transparent;
  }

  void circleColorSetter() {
    currentMonthColorList = [];
    if (streakList.length != colorList.length) {
      //fill colorList with 4s
      for (int i = 0; i < streakList.length; i++) {
        colorList.add(0);
      }
      return;
    } else {
      //we prepare currentMonthColorList
      for (int i = 0; i < streakList.length; i++) {
        if (streakList[i].month == supplyDate.month &&
            streakList[i].year == supplyDate.year) {
          currentMonthColorList.add(colorList[i]);
        }
      }
    }
    //NOTE: We would use the streakData field in the Lists for storing Circle Color Data
    //since 0,1,2,3,4 are already used for streakData, So we make
    //the colorList elements negative, then -1, -2, -3, -4 and so on colors can be used
    //Also no restriction on the number of colors, can be any number of colors
    //We define getCircleColor() such that, if streakData is negative then it is a color,
    //Now we take that negative numeber, make it positive, subtract 1,
    //and use that as index for the Color Pallette List

    //making the colorList elements negative
    for (int i = 0; i < colorList.length; i++) {
      colorList[i] = -colorList[i];
    }
    for (int i = 0; i < currentMonthColorList.length; i++) {
      currentMonthColorList[i] = -currentMonthColorList[i];
    }

    //Rest Setup in buildDayListMap(),
    // we add the colorList elems to the dayListMapList accordingly
  }

  List<List<int>> dayListMapColorSetter(List<List<int>> dayListMapList) {
    //modify the DayListMapList with circle colors
    bool colorFlag = false;
    List<List<int>> DayListMapList = [];
    for (int i = 0; i < dayListMapList.length; i++) {
      DayListMapList.add(dayListMapList[i]);
    }

    for (int i = 0; i < currentMonthColorList.length; i++) {
      if (currentMonthColorList[i] < 0) {
        colorFlag = true;
        break;
      }
    }
    //Now, this ensures that there are colors in the currentMonthColorList
    if (colorFlag == false) {
      //we add a 4th element to the dayListMapList, which is the color

      for (int i = 0; i < DayListMapList.length; i++) {
        int temp = DayListMapList[i][1];
        DayListMapList[i].add(temp);
      }
      return DayListMapList;
    } //No colors, return the original list, with added 4th element as original streakData

    //If function reaches here, then colorFlag is true,
    // so we change the colors in streakData, with negative values
    for (int i = 0, j = 0;
        i < DayListMapList.length && j < currentMonthColorList.length;
        i++) {
      //we first check month data, if 0, then we change streakData
      if (DayListMapList[i][2] == 0) {
        if (DayListMapList[i][1] != 4) {
          DayListMapList[i].add(currentMonthColorList[j]);
          j++;
        }
      }
    }

    return DayListMapList;
  }

  Widget calendarBuild(BuildContext context) {
    setStreakData();

    List<List<int>> dayListMapListFinal;
    //TODO: take supplyDate as input
    dayListMapListFinal = setValues();

    //test
    // print(dayListMapListFinal);

    return Container(
        padding: EdgeInsets.all(calendarBodyPad),
        decoration: BoxDecoration(
          border: Border.all(
            color: calendarBorderColor,
            width: calendarBorderWidth,
          ),
          color: calendarColor,
          borderRadius: calendarBorderRadius,
        ),
        child: Column(
          children: [
            Control(context),
            SizedBox(height: controlHeaderGap),
            DayNames(context),
            SizedBox(height: headerBodyGap),
            Calendar(context, dayListMapListFinal),
          ],
        ));
  }

  Widget StreakDataDashboard(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: streakDashboardBorderColor,
            width: streakDashboardBorderWidth,
          ),
          color: streakDashboardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Center(
                    child: Container(
                        margin:
                            EdgeInsets.only(bottom: streakDashboardLineSpace),
                        child: Text(
                          'Longest',
                          style: TextStyle(
                            height: 1.1,
                            fontFamily: streakDashboardFontFamily,
                            fontSize: streakDashboardFontSize,
                            fontWeight: streakDashboardFontWeight,
                            color: streakDashboardFontColor,
                          ),
                        )),
                  ),
                  Center(
                    child: Container(
                        margin:
                            EdgeInsets.only(bottom: streakDashboardLineSpace),
                        child: Text(
                          'Streak',
                          style: TextStyle(
                            height: 1,
                            fontFamily: streakDashboardFontFamily,
                            fontSize: streakDashboardFontSize,
                            fontWeight: streakDashboardFontWeight,
                            color: streakDashboardFontColor,
                          ),
                        )),
                  ),
                  Center(
                      child: Text(
                    '$longest_Streak',
                    style: TextStyle(
                      height: 1.06,
                      fontFamily: streakDashboardFontFamily,
                      fontSize: streakDashboardDigitFontSize,
                      fontWeight: streakDashboardDigitFontWeight,
                      color: streakDashboardDigitFontColor,
                    ),
                  )),
                ],
              ),
            ),
            Container(
              //vertical divider
              height: streakDashboardDividerHeight,
              child: Container(
                  width: streakDashboardDividerThickness,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: streakDashboardDividerColor,
                        width: 0,
                      ),
                      color: streakDashboardDividerColor,
                      borderRadius: BorderRadius.circular(100))),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Center(
                    child: Text(current_StreakIsLastStreak ? 'Current' : 'Last',
                        style: TextStyle(
                          height: 1.1,
                          fontFamily: streakDashboardFontFamily,
                          fontSize: streakDashboardFontSize,
                          fontWeight: streakDashboardFontWeight,
                          color: streakDashboardFontColor,
                        )),
                  ),
                  Center(
                    child: Text('Streak',
                        style: TextStyle(
                          height: 1,
                          fontFamily: streakDashboardFontFamily,
                          fontSize: streakDashboardFontSize,
                          fontWeight: streakDashboardFontWeight,
                          color: streakDashboardFontColor,
                        )),
                  ),
                  Center(
                      child: Text(
                    '$last_Streak',
                    style: TextStyle(
                      height: 1.06,
                      fontFamily: streakDashboardFontFamily,
                      fontSize: streakDashboardDigitFontSize,
                      fontWeight: streakDashboardDigitFontWeight,
                      color: streakDashboardDigitFontColor,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Control(BuildContext context) {
    Map monthNameMap = {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December'
    };

    return Container(
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                setValues();
                backButtonFunction();
              }),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: controlBorderColor,
                  width: controlBorderWidth,
                ),
                color: controlcolor,
                borderRadius: controlBorderRadius,
              ),
              child: Center(
                child: Text(
                  '${monthNameMap[selectedMonth]}  $selectedYear',
                  style: TextStyle(
                    fontFamily: controlFontFamily,
                    fontSize: controlFontSize,
                    fontWeight: controlFontWeight,
                    color: controlFontColor,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setValues();
                forwardButtonFunction();
              }),
        ],
      ),
    );
  }

  Widget DayNames(BuildContext context) {
    //Setting day names
    if (dayNameLetters == 3) {
      dayNames = dayNames3letters;
    } else if (dayNameLetters == 2) {
      dayNames = dayNames2letters;
    } else {
      dayNames = dayNames3letters; //Default //Other options can be added later
    }

    BoxDecoration headerElemDecor = BoxDecoration(
      border: Border.all(
        color: headerElemBorderColor,
        width: headerElemBorderWidth,
      ),
      color: headerElemcolor,
      borderRadius: headerElemBorderRadius,
    );

    headerSidePad = bodyRowHorizontalPad + bodyRowSidePad;

    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: headerSidePad, vertical: headerUpDownPad),
        decoration: BoxDecoration(
          border: Border.all(
            color: headerBorderColor,
            width: headerBorderWidth,
          ),
          color: headercolor,
          borderRadius: headerBorderRadius,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                dayNames[0].toString(),
                style: TextStyle(
                  fontFamily: headerFontFamily,
                  fontSize: headerFontSize,
                  fontWeight: headerFontWeight,
                  color: headerFontColor,
                ),
              ),
              Text(
                dayNames[1].toString(),
                style: TextStyle(
                  fontFamily: headerFontFamily,
                  fontSize: headerFontSize,
                  fontWeight: headerFontWeight,
                  color: headerFontColor,
                ),
              ),
              Text(
                dayNames[2].toString(),
                style: TextStyle(
                  fontFamily: headerFontFamily,
                  fontSize: headerFontSize,
                  fontWeight: headerFontWeight,
                  color: headerFontColor,
                ),
              ),
              Text(
                dayNames[3].toString(),
                style: TextStyle(
                  fontFamily: headerFontFamily,
                  fontSize: headerFontSize,
                  fontWeight: headerFontWeight,
                  color: headerFontColor,
                ),
              ),
              Text(
                dayNames[4].toString(),
                style: TextStyle(
                  fontFamily: headerFontFamily,
                  fontSize: headerFontSize,
                  fontWeight: headerFontWeight,
                  color: headerFontColor,
                ),
              ),
              Text(
                dayNames[5].toString(),
                style: TextStyle(
                  fontFamily: headerFontFamily,
                  fontSize: headerFontSize,
                  fontWeight: headerFontWeight,
                  color: headerFontColor,
                ),
              ),
              Text(
                dayNames[6].toString(),
                style: TextStyle(
                  fontFamily: headerFontFamily,
                  fontSize: headerFontSize,
                  fontWeight: headerFontWeight,
                  color: headerFontColor,
                ),
              ),
            ],
          ),
        ));
  }

  Widget Calendar(BuildContext context, List<List<int>> dayListMapListFinal) {
    int i = 0; //item tracker for dayList
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: bodyRowSidePad, vertical: bodyRowUpDownPad),
        decoration: BoxDecoration(
          border: Border.all(
            color: bodyBorderColor,
            width: bodyBorderWidth,
          ),
          color: bodycolor,
          borderRadius: bodyBorderRadius,
        ),
        child: Column(
          children: [
            Container(
              //1st row of the calendar
              margin: EdgeInsets.only(
                  top: bodyRowSpaceing,
                  bottom: bodyRowSpaceing), //only for top row
              decoration: BoxDecoration(
                border: Border.all(
                  color: bodyRowBorderColor,
                  width: bodyRowBorderWidth,
                ),
                color: bodyRowcolor,
                borderRadius: bodyRowBorderRadius,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: bodyRowHorizontalPad,
                  vertical: bodyRowVerticalPad),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //generating 1st row of the calendar, 7 days from dayList
                  for (; i < leadingDayList.length; i++)
                    Expanded(
                      flex: 1,
                      child: Container(
                        //current month elements
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: getElemBorderColor(
                                dayListMapListFinal[i][1],
                                dayListMapListFinal[i]
                                    [2]), //leadingElemBorderColor,
                            width: bodyElemBorderWidth,
                          ),
                          color: getRowElementColor(
                              dayListMapListFinal[i][1],
                              dayListMapListFinal[i]
                                  [2]), //leadingElemBorderColor,
                          borderRadius: getBorderRadius(
                              dayListMapListFinal[i][1],
                              bodyRowElemBorderRadius),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: rowHorizontalPad,
                            vertical: rowElemVerticalPad),
                        child: Center(
                          child: CircleAvatar(
                            child: Text(
                              leadingDayList[i].toString(),
                              style: TextStyle(
                                fontFamily: leadingDaysFontFamily,
                                fontSize: leadingDaysFontSize,
                                fontWeight: leadingDaysFontWeight,
                                color: leadingDaysFontColor,
                              ),
                            ),
                            backgroundColor: getCircleColor(
                                dayListMapListFinal[i][4],
                                dayListMapListFinal[i][2]),
                          ),
                        ),
                      ),
                    ),
                  for (; i < 7; i++)
                    Expanded(
                      flex: 1,
                      child: Container(
                        //current month elements
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: getElemBorderColor(dayListMapListFinal[i][1],
                                dayListMapListFinal[i][2]),
                            width: bodyElemBorderWidth,
                          ),
                          // borderRadius: bodyRowElemBorderRadius,

                          color: getRowElementColor(
                              dayListMapListFinal[i][1],
                              dayListMapListFinal[i]
                                  [2]), //leadingElemBorderColor,
                          borderRadius: getBorderRadius(
                              dayListMapListFinal[i][1],
                              bodyRowElemBorderRadius),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: rowHorizontalPad,
                            vertical: rowElemVerticalPad),
                        child: Center(
                          child: CircleAvatar(
                            child: Text(
                              dayList[i].toString(),
                              style: TextStyle(
                                fontFamily: bodyFontFamily,
                                fontSize: bodyFontSize,
                                fontWeight: bodyFontWeight,
                                color: bodyFontColor,
                              ),
                            ),
                            backgroundColor: getCircleColor(
                                dayListMapListFinal[i][4],
                                dayListMapListFinal[i][2]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              //2nd row of the calendar
              margin: EdgeInsets.only(
                  top: bodyRowSpaceing,
                  bottom: bodyRowSpaceing), //only for top row
              decoration: BoxDecoration(
                border: Border.all(
                  color: bodyRowBorderColor,
                  width: bodyRowBorderWidth,
                ),
                color: bodyRowcolor,
                borderRadius: bodyRowBorderRadius,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: bodyRowHorizontalPad,
                  vertical: bodyRowVerticalPad),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (; i < 14; i++)
                    Expanded(
                      flex: 1,
                      child: Container(
                        //current month elements
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: getElemBorderColor(dayListMapListFinal[i][1],
                                dayListMapListFinal[i][2]),
                            width: bodyElemBorderWidth,
                          ),
                          // borderRadius: bodyRowElemBorderRadius,

                          color: getRowElementColor(
                              dayListMapListFinal[i][1],
                              dayListMapListFinal[i]
                                  [2]), //leadingElemBorderColor,
                          borderRadius: getBorderRadius(
                              dayListMapListFinal[i][1],
                              bodyRowElemBorderRadius),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: rowHorizontalPad,
                            vertical: rowElemVerticalPad),
                        child: Center(
                          child: CircleAvatar(
                            child: Text(
                              dayList[i].toString(),
                              style: TextStyle(
                                fontFamily: headerFontFamily,
                                fontSize: bodyFontSize,
                                fontWeight: bodyFontWeight,
                                color: bodyFontColor,
                              ),
                            ),
                            backgroundColor: getCircleColor(
                                dayListMapListFinal[i][4],
                                dayListMapListFinal[i][2]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              //3rd row of the calendar
              margin: EdgeInsets.only(
                  top: bodyRowSpaceing,
                  bottom: bodyRowSpaceing), //only for top row
              decoration: BoxDecoration(
                border: Border.all(
                  color: bodyRowBorderColor,
                  width: bodyRowBorderWidth,
                ),
                color: bodyRowcolor,
                borderRadius: bodyRowBorderRadius,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: bodyRowHorizontalPad,
                  vertical: bodyRowVerticalPad),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (; i < 21; i++)
                    Expanded(
                      flex: 1,
                      child: Container(
                        //current month elements
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: getElemBorderColor(dayListMapListFinal[i][1],
                                dayListMapListFinal[i][2]),
                            width: bodyElemBorderWidth,
                          ),
                          // borderRadius: bodyRowElemBorderRadius,

                          color: getRowElementColor(
                              dayListMapListFinal[i][1],
                              dayListMapListFinal[i]
                                  [2]), //leadingElemBorderColor,
                          borderRadius: getBorderRadius(
                              dayListMapListFinal[i][1],
                              bodyRowElemBorderRadius),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: rowHorizontalPad,
                            vertical: rowElemVerticalPad),
                        child: Center(
                          child: CircleAvatar(
                            child: Text(
                              dayList[i].toString(),
                              style: TextStyle(
                                fontFamily: headerFontFamily,
                                fontSize: bodyFontSize,
                                fontWeight: bodyFontWeight,
                                color: bodyFontColor,
                              ),
                            ),
                            backgroundColor: getCircleColor(
                                dayListMapListFinal[i][4],
                                dayListMapListFinal[i][2]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Visibility(
              visible: dayList[21] != 0,
              child: Container(
                //4th row of the calendar
                margin: EdgeInsets.only(
                    top: bodyRowSpaceing,
                    bottom: bodyRowSpaceing), //only for top row
                decoration: BoxDecoration(
                  border: Border.all(
                    color: bodyRowBorderColor,
                    width: bodyRowBorderWidth,
                  ),
                  color: bodyRowcolor,
                  borderRadius: bodyRowBorderRadius,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: bodyRowHorizontalPad,
                    vertical: bodyRowVerticalPad),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (; i < 28; i++)
                      Expanded(
                        flex: 1,
                        child: Container(
                          //current month elements
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: getElemBorderColor(
                                  dayListMapListFinal[i][1],
                                  dayListMapListFinal[i][2]),
                              width: bodyElemBorderWidth,
                            ),
                            // borderRadius: bodyRowElemBorderRadius,

                            color: getRowElementColor(
                                dayListMapListFinal[i][1],
                                dayListMapListFinal[i]
                                    [2]), //leadingElemBorderColor,
                            borderRadius: getBorderRadius(
                                dayListMapListFinal[i][1],
                                bodyRowElemBorderRadius),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: rowHorizontalPad,
                              vertical: rowElemVerticalPad),
                          child: Center(
                            child: CircleAvatar(
                              child: Text(
                                dayList[i].toString(),
                                style: TextStyle(
                                  fontFamily: headerFontFamily,
                                  fontSize: bodyFontSize,
                                  fontWeight: bodyFontWeight,
                                  color: bodyFontColor,
                                ),
                              ),
                              backgroundColor: getCircleColor(
                                  dayListMapListFinal[i][4],
                                  dayListMapListFinal[i][2]),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: dayList[28] != 0,
              child: Container(
                //5th row of the calendar
                margin: EdgeInsets.only(
                    top: bodyRowSpaceing,
                    bottom: bodyRowSpaceing), //only for top row
                decoration: BoxDecoration(
                  border: Border.all(
                    color: bodyRowBorderColor,
                    width: bodyRowBorderWidth,
                  ),
                  color: bodyRowcolor,
                  borderRadius: bodyRowBorderRadius,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: bodyRowHorizontalPad,
                    vertical: bodyRowVerticalPad),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (; i < 35; i++)
                      Expanded(
                        flex: 1,
                        child: Container(
                          //current month elements
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: getElemBorderColor(
                                  dayListMapListFinal[i][1],
                                  dayListMapListFinal[i][2]),
                              width: bodyElemBorderWidth,
                            ),
                            // borderRadius: bodyRowElemBorderRadius,

                            color: getRowElementColor(
                                dayListMapListFinal[i][1],
                                dayListMapListFinal[i]
                                    [2]), //leadingElemBorderColor,
                            borderRadius: getBorderRadius(
                                dayListMapListFinal[i][1],
                                bodyRowElemBorderRadius),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: rowHorizontalPad,
                              vertical: rowElemVerticalPad),
                          child: Center(
                            child: CircleAvatar(
                              child: Text(
                                dayList[i] == 0 ? '' : dayList[i].toString(),
                                style: TextStyle(
                                  fontFamily: headerFontFamily,
                                  fontSize: bodyFontSize,
                                  fontWeight: bodyFontWeight,
                                  color: bodyFontColor,
                                ),
                              ),
                              backgroundColor: getCircleColor(
                                  dayListMapListFinal[i][4],
                                  dayListMapListFinal[i][2]),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: dayList[35] != 0,
              child: Container(
                //6th row of the calendar
                margin: EdgeInsets.only(
                    top: bodyRowSpaceing,
                    bottom: bodyRowSpaceing), //only for top row
                decoration: BoxDecoration(
                  border: Border.all(
                    color: bodyRowBorderColor,
                    width: bodyRowBorderWidth,
                  ),
                  color: bodyRowcolor,
                  borderRadius: bodyRowBorderRadius,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: bodyRowHorizontalPad,
                    vertical: bodyRowVerticalPad),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (; i < 42; i++)
                      Expanded(
                        flex: 1,
                        child: Container(
                          //current month elements
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: getElemBorderColor(
                                  dayListMapListFinal[i][1],
                                  dayListMapListFinal[i][2]),
                              width: bodyElemBorderWidth,
                            ),
                            // borderRadius: bodyRowElemBorderRadius,

                            color: getRowElementColor(
                                dayListMapListFinal[i][1],
                                dayListMapListFinal[i]
                                    [2]), //leadingElemBorderColor,
                            borderRadius: getBorderRadius(
                                dayListMapListFinal[i][1],
                                bodyRowElemBorderRadius),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: rowHorizontalPad,
                              vertical: rowElemVerticalPad),
                          child: Center(
                            child: CircleAvatar(
                              child: Text(
                                dayList[i] == 0 ? '' : dayList[i].toString(),
                                style: TextStyle(
                                  fontFamily: headerFontFamily,
                                  fontSize: bodyFontSize,
                                  fontWeight: bodyFontWeight,
                                  color: bodyFontColor,
                                ),
                              ),
                              backgroundColor: getCircleColor(
                                  dayListMapListFinal[i][4],
                                  dayListMapListFinal[i][2]),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
