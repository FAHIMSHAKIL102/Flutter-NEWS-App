import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/countries_news_model.dart';
import 'package:flutter_news_app/view/news_details_screen.dart';
import 'package:flutter_news_app/view_model/news_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CountriesScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  String countryName = 'ae';
  List<Map<String, String>> countryNews = [
    {"Name": "United Arab Emirates", "Code": "ae"},
    {"Name": "Argentina", "Code": "ar"},
    {"Name": "Austria", "Code": "at"},
    {"Name": "Australia", "Code": "au"},
    {"Name": "Belgium", "Code": "be"},
    {"Name": "Bulgaria", "Code": "bg"},
    {"Name": "Brazil", "Code": "br"},
    {"Name": "Canada", "Code": "ca"},
    {"Name": "Switzerland", "Code": "ch"},
    {"Name": "China", "Code": "cn"},
    {"Name": "Colombia", "Code": "co"},
    {"Name": "Cuba", "Code": "cu"},
    {"Name": "Czech Republic", "Code": "cz"},
    {"Name": "Germany", "Code": "de"},
    {"Name": "Egypt", "Code": "eg"},
    {"Name": "France", "Code": "fr"},
    {"Name": "United Kingdom", "Code": "gb"},
    {"Name": "Greece", "Code": "gr"},
    {"Name": "Hong Kong", "Code": "hk"},
    {"Name": "Hungary", "Code": "hu"},
    {"Name": "Indonesia", "Code": "id"},
    {"Name": "Ireland", "Code": "ie"},
    {"Name": "Israel", "Code": "il"},
    {"Name": "India", "Code": "in"},
    {"Name": "Italy", "Code": "it"},
    {"Name": "Japan", "Code": "jp"},
    {"Name": "South Korea", "Code": "kr"},
    {"Name": "Lithuania", "Code": "lt"},
    {"Name": "Latvia", "Code": "lv"},
    {"Name": "Morocco", "Code": "ma"},
    {"Name": "Mexico", "Code": "mx"},
    {"Name": "Malaysia", "Code": "my"},
    {"Name": "Nigeria", "Code": "ng"},
    {"Name": "Netherlands", "Code": "nl"},
    {"Name": "Norway", "Code": "no"},
    {"Name": "New Zealand", "Code": "nz"},
    {"Name": "Philippines", "Code": "ph"},
    {"Name": "Poland", "Code": "pl"},
    {"Name": "Portugal", "Code": "pt"},
    {"Name": "Romania", "Code": "ro"},
    {"Name": "Serbia", "Code": "rs"},
    {"Name": "Russia", "Code": "ru"},
    {"Name": "Saudi Arabia", "Code": "sa"},
    {"Name": "Sweden", "Code": "se"},
    {"Name": "Singapore", "Code": "sg"},
    {"Name": "Slovenia", "Code": "si"},
    {"Name": "Slovakia", "Code": "sk"},
    {"Name": "Thailand", "Code": "th"},
    {"Name": "Turkey", "Code": "tr"},
    {"Name": "Taiwan", "Code": "tw"},
    {"Name": "Ukraine", "Code": "ua"},
    {"Name": "United States", "Code": "us"},
    {"Name": "Venezuela", "Code": "ve"},
    {"Name": "South Africa", "Code": "za"},
  ];

  NewsViewModel newsViewModel = NewsViewModel();

  final format = DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.heightOf(context);
    final width = MediaQuery.widthOf(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrange.shade400),
        title: Text(
          'Country',
          style: GoogleFonts.poppins(
            color: Colors.deepOrange.shade400,
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
                itemCount: countryNews.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        countryName = countryNews[index]['Code']!;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: countryName == countryNews[index]['Code']
                              ? Colors.deepOrange.shade400
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              countryNews[index]['Name']!,
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
              child: FutureBuilder<CountriesNewsModel>(
                future: newsViewModel.fetchCountriesNewsApi(countryName),
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
