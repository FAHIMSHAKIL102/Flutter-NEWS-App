import 'package:flutter/foundation.dart';
import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/models/countries_news_model.dart';
import 'package:flutter_news_app/models/news_channel_headlines_model.dart';
import 'package:flutter_news_app/models/news_channels_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(
    String channelName,
  ) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=8a5ec37e26f845dcb4c2b78463734448';

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

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=$category&apiKey=8a5ec37e26f845dcb4c2b78463734448';

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print('Success');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<NewsChannelsModel> fetchNewsChannelApi() async {
    String url =
        'https://newsapi.org/v2/top-headlines/sources?apiKey=8a5ec37e26f845dcb4c2b78463734448';
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print('Success');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return NewsChannelsModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<CountriesNewsModel> fetchCountriesNewsApi() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=8a5ec37e26f845dcb4c2b78463734448';
    final reponse = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print('Success');
    }

    if (reponse.statusCode == 200) {
      final data = jsonDecode(reponse.body);
      return CountriesNewsModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }
}
