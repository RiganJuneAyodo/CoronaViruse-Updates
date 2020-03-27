import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

//void main() => runApp(new MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Flutter Api Filter list Demo',
//      theme: new ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: new ExamplePage(),
//    );
//  }
//}

class WorldMorInfo extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  List<List<Map<String, dynamic>>> countries;
  Map<String, dynamic> worldSummary;

  WorldMorInfo(List<List<Map<String, dynamic>>> countries, Map<String, dynamic> worldSummary) {
    this.countries = countries;
    this.worldSummary = worldSummary;

  }
  @override
  _WorldMorInfoState createState() => new _WorldMorInfoState(countries, worldSummary);
}

class _WorldMorInfoState extends State<WorldMorInfo> {

  List<List<Map<String, dynamic>>> countries;
  Map<String, dynamic> worldSummary;

  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Search Example' );

  double appTitleFontSize = 30;
  double countryFontSize = 20;
  double colName = 20;
  double titleFontSize = 18;
  double valueFontSize = 10;
  double paddingBetweenTitles = 5.0;

  int countryIndex = 0;
  int total_casesIndex = 1;
  int new_casesIndex = 2;
  int total_deathsIndex = 3;
  int new_deathsIndex = 4;
  int total_recoveredIndex = 5;
  int active_casesIndex = 6;
  int serious_casesIndex = 7;
  int tot_criticalIndex = 8;
  int deathPercentageIndex = 9;

  _WorldMorInfoState(List<List<Map<String, dynamic>>> countries, Map<String, dynamic> worldSummary) {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });

    this.countries = countries;
    this.worldSummary = worldSummary;

  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
//      leading: new IconButton(
//        icon: _searchIcon,
//        onPressed: _searchPressed,
//
//      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i][countryIndex]['country'].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {

        return Card(
          color: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      filteredNames[index][countryIndex]['country'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: countryFontSize),
                    ),
                  ),

                  Divider(),

                  SizedBox(
                    height: 5.0,
                  ),

                  Center(
                    child: Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    titleWidget('Total Cases', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget('New Cases', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget('Total Deaths', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget('New Deaths', titleFontSize),

                                  ],
                                ),
                              ],
                            ),


                            SizedBox(
                              width: 2.0,
                            ),

                            Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    titleWidget(':', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(':', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(':', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(':', titleFontSize),
                                  ],
                                ),
                              ],
                            ),


                            SizedBox(
                              width: 2.0,
                            ),

                            Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    titleWidget(filteredNames[index][total_casesIndex]['total_cases'], titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(filteredNames[index][new_casesIndex]['new_cases'], titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(filteredNames[index][total_deathsIndex]['total_deaths'], titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(filteredNames[index][new_deathsIndex]['new_deaths'], titleFontSize),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(
                          width: 25.0,
                        ),

                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    titleWidget('Total Recovered', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget('Active Cases', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget('Serious Critical', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget('Death (%)', titleFontSize),
                                  ],
                                ),
                              ],
                            ),


                            SizedBox(
                              width: 2.0,
                            ),

                            Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    titleWidget(':', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(':', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(':', titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(':', titleFontSize),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(
                              width: 2.0,
                            ),

                            Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    titleWidget(filteredNames[index][total_recoveredIndex]['total_recovered'], titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(filteredNames[index][active_casesIndex]['active_cases'], titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(filteredNames[index][serious_casesIndex]['serious_cases'], titleFontSize),
                                    Padding(padding: EdgeInsets.all(1)),
                                    titleWidget(filteredNames[index][deathPercentageIndex]['deathPercentage'], titleFontSize),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        );
      },
    );
  }

  Widget titleWidget(String title, size) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.normal, fontSize: size),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( 'Search Example' );
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames() async {

    List tempList = new List();

    for (var country in countries) {

      var deathPercentage = getPercentage(country[total_deathsIndex]['total_deaths'], country[total_casesIndex]['total_cases']);

      country.add({'deathPercentage':deathPercentage});

//      print(country);

      tempList.add(country );

    }

    setState(() {
      names = tempList;
      names.shuffle();
      filteredNames = names;
    });
  }


  String getPercentage(var total, var wholeTotal) {

    try{
      total = (('' + total)).trim().replaceAll(',','');
      total = int.parse(total);

      wholeTotal = (('' + wholeTotal)).trim().toString().replaceAll(',','');
      wholeTotal = int.parse(wholeTotal);

      print(total );
      print(wholeTotal);

      var p = ((total / wholeTotal) * 100).round();

      p = p.toString();

      p += '%';

      return p;
      
    }catch(e){
      print(e);
    }

    return ' ';

  }


}