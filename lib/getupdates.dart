import 'dart:convert'; // Contains the JSON encoder

import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'; 



Future initiate() async {
  var client = Client();
  Response response = await client.get(
    'https://news.ycombinator.com'
  );

  print(response.body);
}