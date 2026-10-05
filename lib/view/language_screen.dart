import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/language_news_model.dart';
import 'package:flutter_news_app/view/news_details_screen.dart';
import 'package:flutter_news_app/view_model/news_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class LanguageScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String languageName = 'en';

  List<Map<String, String>> languageNews = [
    {"Name": "English", "Code": "en"},
    {"Name": "Arabic", "Code": "ar"},
    {"Name": "German", "Code": "de"},
    {"Name": "Spanish", "Code": "es"},
    {"Name": "French", "Code": "fr"},
    {"Name": "Hebrew", "Code": "he"},
    {"Name": "Italian", "Code": "it"},
    {"Name": "Dutch", "Code": "nl"},
    {"Name": "Norwegian", "Code": "no"},
    {"Name": "Portuguese", "Code": "pt"},
    {"Name": "Russian", "Code": "ru"},
    {"Name": "Swedish", "Code": "sv"},
    {"Name": "Urdu", "Code": "ud"},
    {"Name": "Chinese", "Code": "zh"},
  ];

  NewsViewModel newsViewModel = NewsViewModel();

  final format = DateFormat('MMMM dd, yyyy');
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.heightOf(context);
    final width = MediaQuery.widthOf(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green.shade400),
        title: Text(
          'Language',
          style: GoogleFonts.poppins(
            color: Colors.green.shade400,
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: languageNews.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        languageName = languageNews[index]['Code']!;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: languageName == languageNews[index]['Code']
                              ? Colors.green.shade400
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              languageNews[index]['Name']!,
                              style: GoogleFonts.poppins(
                                color: Colors.white.withValues(alpha: 1.5),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<LanguageNewsModel>(
                future: newsViewModel.fetchLanguageNewsApi(languageName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SpinKitCircle(size: 50, color: Colors.blue);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'No Data',
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(
                          snapshot.data!.articles![index].publishedAt
                              .toString(),
                        );
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailsScreen(
                                  newImage: snapshot
                                      .data!
                                      .articles![index]
                                      .urlToImage
                                      .toString(),
                                  newsTitle: snapshot
                                      .data!
                                      .articles![index]
                                      .title
                                      .toString(),
                                  newsDate: snapshot
                                      .data!
                                      .articles![index]
                                      .publishedAt
                                      .toString(),
                                  author: snapshot.data!.articles![index].author
                                      .toString(),
                                  description: snapshot
                                      .data!
                                      .articles![index]
                                      .description
                                      .toString(),
                                  content: snapshot
                                      .data!
                                      .articles![index]
                                      .content
                                      .toString(),
                                  source: snapshot
                                      .data!
                                      .articles![index]
                                      .source!
                                      .name
                                      .toString(),
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      height: height * .18,
                                      width: width * .3,
                                      imageUrl: snapshot
                                          .data!
                                          .articles![index]
                                          .urlToImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: SpinKitFadingCircle(
                                          color: Colors.amber,
                                          size: 50,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      height: height * .18,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          Text(
                                            snapshot
                                                .data!
                                                .articles![index]
                                                .title
                                                .toString(),
                                            maxLines: 3,
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            snapshot
                                                .data!
                                                .articles![index]
                                                .source!
                                                .name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
