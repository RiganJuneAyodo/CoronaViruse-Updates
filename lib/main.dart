//import 'dart:html';

import 'dart:convert';

import 'package:coronavirusupdates/GlobalCountries.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double appTitleFontSize = 30;
  double categotyFontSize = 25;
  double colName = 20;
  double titleFontSize = 15;
  double valueFontSize = 15;
  double paddingBetweenTitles = 5.0;
  List<List<Map<String, dynamic>>> countries;
  Map<String, dynamic> worldSummary = new Map();
  var myCountry;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: new Center(child: titleWidget('Corona Virus Updates', appTitleFontSize)),
          ),
          body: getUpdates()
      ),
    );
  }


  Widget titleWidget(String title, size) {

    return Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
      );
  }



  Widget getUpdates() {
    return new FutureBuilder<String>(
      future: getResponse(), // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none: return new Text('');
          case ConnectionState.waiting: return Center(child: CircularProgressIndicator());  //CIRCULAR INDICATOR
          default:
            if (snapshot.hasError)
              return titleWidget('Not Found', valueFontSize);

            else

              return ListView(
                  padding: EdgeInsets.all(15),
                  children: <Widget>[

                    Center(
                        child: titleWidget((myCountry + ' Cases'), categotyFontSize)
                    ),

                    displayCountryData( snapshot.data ),

                    SizedBox(
                      width: 10.0,
                      height: 10,
                    ),

                    Center(
                      child:Builder(
                        builder: (context) => GestureDetector(
                          onTap: () {
  //                        Navigator.push(
  //                          context,
  //                          MaterialPageRoute(builder: (context) => ExamplePage(this.countries)),
  //                        );
                          },
                          child: Text(
                            "View Map",
                            style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontSize: 18),
                          ),
                        ),
                      ),

                    ),


                    SizedBox(
                      width: 10.0,
                      height: 20,
                    ),

                    Center(
                        child: titleWidget('World Cases', categotyFontSize)
                    ),


                    getGenUpdates(snapshot.data),

                    Center(
                      child:Builder(
                        builder: (context) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WorldMorInfo(this.countries, worldSummary)),
                            );
                          },
                          child: Text(
                            "More Info",
                            style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ]
              );
          }
      },
    );
  }


  Widget displayCountryData(htmlPassed) {

     this.countries = getCountriesata(htmlPassed);

     if (this.countries.length <= 0 ) {

       return titleWidget('Not Found', valueFontSize);

     }

    List<Map<String, dynamic>> cases;

    for (var country in countries) {

      if (country[0]['country'].toString().contains(this.myCountry)) {

        cases = country;

        break;

      }

    }


    if (cases.length <= 0) {

      return titleWidget('Not Found', valueFontSize);

    }

    print(cases);

    String country = '0',
        total_cases = '0',
        new_cases = '0',
        total_deaths = '0',
        new_deaths = '0',
        total_recovered = '0',
        active_cases = '0',
        serious_cases = '0',
        tot_critical = '0';

    int x = -1;
    try {country = cases[x+=1]['country'];}catch(e){}
    try {total_cases = cases[x+=1]['total_cases'];}catch(e){}
    try {new_cases = cases[x+=1]['new_cases'];}catch(e){}
    try {total_deaths = cases[x+=1]['total_deaths'];}catch(e){}
    try {new_deaths = cases[x+=1]['new_deaths'];}catch(e){}
    try {total_recovered = cases[x+=1]['total_recovered'];}catch(e){}
    try {active_cases = cases[x+=1]['active_cases'];}catch(e){}
    try {serious_cases = cases[x+=1]['serious_cases'];}catch(e){}
    try {tot_critical = cases[x+=1]['tot_critical'];}catch(e){}

    if(country == null || country == ''){country = '0';}
    if(total_cases == null || total_cases == ''){total_cases = '0';}
    if(new_cases == null || new_cases == ''){new_cases = '0';}
    if(total_deaths == null || total_deaths == ''){total_deaths = '0';}
    if(new_deaths == null || new_deaths == ''){new_deaths = '0';}
    if(total_recovered == null || total_recovered == ''){total_recovered = '0';}
    if(active_cases == null || active_cases == ''){active_cases = '0';}
    if(serious_cases == null || serious_cases == ''){serious_cases = '0';}


    return DataTable(

      columns: [
        DataColumn(label: titleWidget('Cases', colName)),
        DataColumn(label: titleWidget('Count', colName)),
        //                DataColumn(label: Text('Class')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(titleWidget('Total Cases', titleFontSize)),
          DataCell(titleWidget(total_cases, valueFontSize)),
          //                  DataCell(Text('6')),
        ]),
        DataRow(cells: [
          DataCell(titleWidget('Cases Today', titleFontSize)),
          DataCell(titleWidget(new_cases, valueFontSize)),
          //                  DataCell(Text('9')),
        ]),
        DataRow(cells: [
          DataCell(titleWidget('Total Deaths', titleFontSize)),
          DataCell(titleWidget(total_deaths, valueFontSize)),

        ]),
        DataRow(cells: [
          DataCell(titleWidget('Deaths Today', titleFontSize)),
          DataCell(titleWidget(new_deaths, valueFontSize)),

        ]),
        DataRow(cells: [
          DataCell(titleWidget('Total Recovered', titleFontSize)),
          DataCell(titleWidget(total_recovered, valueFontSize)),

        ]),
        DataRow(cells: [
          DataCell(titleWidget('Active Cases', titleFontSize)),
          DataCell(titleWidget(active_cases, valueFontSize)),

        ]),
        DataRow(cells: [
          DataCell(titleWidget('Serious Cases', titleFontSize)),
          DataCell(titleWidget(serious_cases, valueFontSize)),

        ]),
      ],
    );

  }

  String checkNull(String s) {

    if (s == null) {
      return '0';
    }

    return s;

  }

   getCountryName () async {
    var client = http.Client();

    http.Response res = await client.get('https://nordvpn.com/wp-admin/admin-ajax.php?action=get_user_info_data');

    myCountry = json.decode(res.body);

    myCountry = ('' + myCountry['location']);

    if (myCountry.contains(',')) {
      myCountry = ('' + myCountry).split(',')[0];
    }
    return myCountry;
  }

  Future<String> getResponse () async {

    await getCountryName();

    var client = http.Client();

    http.Response res = await client.get('https://www.worldometers.info/coronavirus/');

    return res.body;

  }

  Widget getGenUpdates (htmlPassed) {

    var document = html_parser.parse(htmlPassed);

    List<html_dom.Element> updateElems =  document.querySelectorAll('div#maincounter-wrap');
    Map<String, dynamic> updates = new Map();

    for(var updateElem in updateElems){

      var title = (updateElem.querySelector('h1')).text;
      var value = (updateElem.querySelector('div.maincounter-number')).text;
      title = (title.trim()).replaceAll(':', '');
      value = (value.trim()).replaceAll(':', '');

      updates.addAll({title : value});

    }

    print(updates);

    worldSummary = updates;

    return DataTable(
//
      columns: [
        DataColumn(label: titleWidget('Cases', colName)),
        DataColumn(label: titleWidget('Count', colName)),
        //                DataColumn(label: Text('Class')),
      ],
      rows: [
        DataRow(cells: [
        DataCell(titleWidget('Total Cases', titleFontSize)),
        DataCell(titleWidget(worldSummary['Coronavirus Cases'], valueFontSize)),
        //                  DataCell(Text('6')),
        ]),


        DataRow(cells: [
        DataCell(titleWidget('Total Deaths', titleFontSize)),
        DataCell(titleWidget(worldSummary['Deaths'], valueFontSize)),
        //                  DataCell(Text('6')),
        ]),

        DataRow(cells: [
        DataCell(titleWidget('Total Recovered', titleFontSize)),
        DataCell(titleWidget(worldSummary['Recovered'], valueFontSize)),
        //                  DataCell(Text('6')),
        ]),

      ],
    );

  }





  List<List<Map<String, dynamic>>> getCountriesata (htmlPassed) {

    var document = html_parser.parse(htmlPassed);

    List<List<Map<String, dynamic>>> countryData = [];

    //Get table data
      var table = document.querySelector('table#main_table_countries_today');

      List<html_dom.Element> tableRows =  table.querySelectorAll('tr');

      for(var tableRow in tableRows){

        List<html_dom.Element> tableColumns =  tableRow.querySelectorAll('td');

        int colIndex = 0;

        String country, total_cases, new_cases, total_deaths, new_deaths, total_recovered, active_cases, serious_cases, tot_critical;

        for(var tableColumn in tableColumns){

          try {

            colIndex+=1;

            var columnValue  = tableColumn.text;

            columnValue = columnValue.trim();

            switch(colIndex) {

              case 1:

                country = columnValue;

                break;

              case 2:

                total_cases = columnValue;

                break;

              case 3:

                new_cases = columnValue;

                break;

              case 4:

                total_deaths = columnValue;

                break;

              case 5:

                new_deaths = columnValue;

                break;

              case 6:

                total_recovered = columnValue;

                break;

              case 7:

                active_cases = columnValue;

                break;

              case 8:

                serious_cases = columnValue;

                break;

              case 9:

                tot_critical = columnValue;

                break;

              default:
                break;
            }

          } catch(e) {

          }
        }
        if (colIndex == 4) {
          break;
        }
        

        if (country != null && country != 'Total:') {

          if(total_cases == null || total_cases == ''){total_cases = '0';}
          if(new_cases == null || new_cases == ''){new_cases = '0';}
          if(total_deaths == null || total_deaths == ''){total_deaths = '0';}
          if(new_deaths == null || new_deaths == ''){new_deaths = '0';}
          if(total_recovered == null || total_recovered == ''){total_recovered = '0';}
          if(active_cases == null || active_cases == ''){active_cases = '0';}
          if(serious_cases == null || serious_cases == ''){serious_cases = '0';}

          List<Map<String, dynamic>> aCountryData = [
            {'country': country},
            {'total_cases': total_cases},
            {'new_cases': new_cases},
            {'total_deaths': total_deaths},
            {'new_deaths': new_deaths},
            {'total_recovered': total_recovered},
            {'active_cases': active_cases},
            {'serious_cases': serious_cases},
            {'tot_critical': tot_critical}

          ];

            countryData.add(aCountryData);

        }
      }

    return countryData;

  }

}




class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}



