//USER FUNCTIONs are:  CalculateStreaks() and CalculateStreakData()
//|___EXPLANATION OF VARIABLES____________________________________________________
//|___longestStreak, lastStreak, currentStreakIsLastStreak trivial to understand
//|___streakListFilter is the streakList for the current month
//|___streakListFilterGroup is the streakListFilter with the streaks grouped, see RULE1
//______________________________________________________________________________
//Only use the value of variables(except supply variables,
// to be supplied before calling the USER FUNCTIONs) after calling
// the USER FUNCTION CalculateStreaks() or CalculateStreakData()
//______________________________________________________________________________
//only USER FUNCTIONs are to be called from outside user
//REDUNDANT for redundant lines
//SUPPLY are to be supplied from outside user, otherwise has default values
//RULE: ... defines rule for the function below it
//HELPER FUNCTION are just abstractions for little tasks
//ACTIONS listed at the bottom if one has to use the class explicitly
//______________________________________________________________________________

class StreakService {
  int longestStreak = 0; //USER VARIABLE
  int lastStreak = 0; //USER VARIABLE
  bool currentStreakIsLastStreak = false; //USER VARIABLE
  List<DateTime> streakListFilter = []; //USER VARIABLE, probably not needed
  List<Map<DateTime, int>> streakListFilterGroup = []; //USER VARIABLE

//______________________________________________________________________________

  //SUPPLY
  List<DateTime> streakList = []; //Whole streakList
  //supplyDate
  DateTime supplyDate = DateTime.now(); //will be supplied from DuoCalendar

  //sort the streakList
  void SortStreakList() {
    streakList.sort((a, b) => a.compareTo(b));
  }

  //Now we filtre the streakList for the current month
  void StreakListFilterFunction() {
    streakListFilter = streakList.where((element) {
      return element.month == supplyDate.month &&
          element.year == supplyDate.year;
    }).toList();

    //Now we sort the streakListFilter
    streakListFilter.sort((a, b) => a.compareTo(b));
  }

  //RULE1:
  //Now we group the streakListFilter so that we can get the streaks
  //we create a map for each element of the streakListFilter, then make a list of the maps
  //{DateTime: int}
  //0 for stand alone day
  //1 for streak start day
  //2 for streak end day
  //3 for streak middle day
  void StreakListFilterGroupFunction() {
    int len = streakListFilter.length;
    bool previousDayIsStreak = false;
    bool nextDayIsStreak = false;

    //for 1st element of the streakListFilter
    if (len == 1) {
      streakListFilterGroup.add({streakListFilter[0]: 0});
    } else {
      if (streakListFilter[0].day + 1 == streakListFilter[1].day) {
        streakListFilterGroup.add({streakListFilter[0]: 1}); //streak start day
        previousDayIsStreak = true;
      } else {
        streakListFilterGroup.add({streakListFilter[0]: 0}); //stand alone day
      }
    }

    //for the middle elements of the streakListFilter
    for (int i = 1; i < len - 1; i++) {
      if (streakListFilter[i].day - 1 == streakListFilter[i - 1].day) {
        previousDayIsStreak = true;
      } else {
        previousDayIsStreak = false;
      }

      if (streakListFilter[i].day + 1 == streakListFilter[i + 1].day) {
        nextDayIsStreak = true;
      } else {
        nextDayIsStreak = false;
      }

      if (previousDayIsStreak && nextDayIsStreak) {
        streakListFilterGroup.add({streakListFilter[i]: 3});
      } else if (previousDayIsStreak && !nextDayIsStreak) {
        streakListFilterGroup.add({streakListFilter[i]: 2});
      } else if (!previousDayIsStreak && nextDayIsStreak) {
        streakListFilterGroup.add({streakListFilter[i]: 1});
      } else {
        streakListFilterGroup.add({streakListFilter[i]: 0});
      }
    }

    //for the last element of the streakListFilter
    if (len > 1) {
      if (streakListFilter[len - 1].day - 1 == streakListFilter[len - 2].day) {
        streakListFilterGroup.add({streakListFilter[len - 1]: 2});
      } else {
        streakListFilterGroup.add({streakListFilter[len - 1]: 0});
      }
    }

    //1st element
  }

  //Calculate longest streak
  void CalculateLongestStreak() {
    SortStreakList(); //REDUNDANT, since in USER FUNCTION CalculateStreaks() we already call SortStreakList()

    //we calculate for whole streakList
    int len = streakList.length;
    int _currentStreak = 1;
    int _longestStreak = 0;
    if (streakList.length > 1) {
      for (int i = 0; i < len - 1; i++) {
        if (streakList[i].day + 1 == streakList[i + 1].day) {
          _currentStreak++;
          if (_currentStreak > _longestStreak) {
            _longestStreak = _currentStreak;
          }
        } else {
          _currentStreak = 0;
        }
      }
    } else {
      _longestStreak = 1;
    }
    longestStreak = _longestStreak;
  }

  //Calculate current streak
  void CalculateLastStreak() {
    SortStreakList(); //REDUNDANT, since in USER FUNCTION CalculateStreaks() we already call SortStreakList()
    //we calculate for whole streakList
    int len = streakList.length;
    int _currentStreak = 1;
    for (int i = len - 1; i > 0; i--) {
      if (streakList[i].day - 1 == streakList[i - 1].day) {
        _currentStreak++;
      } else {
        break;
      }
    }
    lastStreak = _currentStreak;
  }

  //Calculate lastDayIsStreak
  void CalculateCurrentStreakIsLastStreak() {
    //we calculate for whole streakList
    currentStreakIsLastStreak = false;
    int len = streakList.length;
    List<int> cmplist1 = [
      DateTime.now().day,
      DateTime.now().month,
      DateTime.now().year
    ];
    List<int> cmplist2 = [
      streakList[len - 1].day,
      streakList[len - 1].month,
      streakList[len - 1].year
    ];
    List<int> cmplist3 = [
      DateTime.now().day - 1,
      DateTime.now().month,
      DateTime.now().year
    ];

    if (listCompare(cmplist2, cmplist1) || listCompare(cmplist2, cmplist3)) {
      currentStreakIsLastStreak = true;
    }
  }

  //HELPER FUNCTION
  bool listCompare(List<int> l1, List<int> l2) {
    int len1 = l1.length;
    int len2 = l2.length;

    if (len1 != len2) {
      return false;
    }

    for (int i = 0; i < len1; i++) {
      if (l1[i] != l2[i]) {
        return false;
      }
    }
    return true;
  }

  void clearDuplicates() {
    streakListFilter = streakListFilter.toSet().toList();
  }

  //USER FUNCTION_______________________________________________________________
  void CalculateStreaks() {
    //See if streakList is empty
    if (streakList.isEmpty) {
      return;
    }
    clearDuplicates();
    SortStreakList(); //MANDATORY STEP 1

    StreakListFilterFunction();
    //Now check if the streakListFilter is empty

    if (streakListFilter.isEmpty) {
      return;
    }
    StreakListFilterGroupFunction();
  }

  void CalculateStreakData() {
    //See if streakList is empty
    if (streakList.isEmpty) {
      return;
    }
    SortStreakList(); //MANDATORY STEP 1
    CalculateLongestStreak(); //DEPENDS ON MANDATORY STEP 1
    CalculateLastStreak(); //DEPENDS ON MANDATORY STEP 1
    CalculateCurrentStreakIsLastStreak();

    //if longest streak < current streak, then longest streak = current streak
    if (longestStreak < lastStreak) {
      longestStreak = lastStreak;
    }
  }
}



//ACTIONS:
//take streakList SUPPLY
//take supplyDate SUPPLY
//run StreakListFilterFunction, takes streakList and supplyDate, stores the result in streakListFilter[]
//run StreakListFilterGroupFunction, takes streakListFilter[], stores the result in streakListFilterGroup[]
//use streakListFilterGroup[] to display the streaks in the calendar


