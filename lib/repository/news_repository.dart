import 'package:flutter/foundation.dart';
import 'package:flutter_news_app/models/news_channel_headlines_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi() async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=8a5ec37e26f845dcb4c2b78463734448';

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print('Success');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }
}
