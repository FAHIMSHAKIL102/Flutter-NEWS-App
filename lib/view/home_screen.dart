import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/models/news_channel_headlines_model.dart';
import 'package:flutter_news_app/models/news_channels_model.dart';
import 'package:flutter_news_app/view/categories_screen.dart';
import 'package:flutter_news_app/view/countries_screen.dart';
import 'package:flutter_news_app/view/language_screen.dart';
import 'package:flutter_news_app/view/news_details_screen.dart';
import 'package:flutter_news_app/view_model/news_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String selectedSource = 'BBC News';
  //String name = 'bbc-news';
  // final Map<String, dynamic> newsSources = {
  //   'BBC News': 'bbc-news',
  //   'Ary News': 'ary-news',
  //   'AlJazeera News': 'al-jazeera',
  //   'Reuters': 'reuters',
  //   'CNN': 'cnn',
  // };

  // Api Source

  Map<String, String> newsApiSource = {};
  String selectedSource = 'BBC News';
  String name = 'bbc-news';
  List<String> news = ['Category', 'Country', 'Language'];
  NewsViewModel newsViewModel = NewsViewModel();

  final format = DateFormat('MMMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    fetchNewsApiSource();
  }

  Future<void> fetchNewsApiSource() async {
    final NewsChannelsModel data = await newsViewModel.fetchNewsChannelApi();

    setState(() {
      newsApiSource = {
        for (final source in data.sources ?? [])
          if (source.name != null && source.id != null)
            source.name!: source.id!,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.heightOf(context);
    final width = MediaQuery.widthOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<String>(
          icon: Image.asset('assets/images/category_icon.png'),
          onSelected: (String selectedItem) {
            if (selectedItem == 'Category') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesScreen()),
              );
            }
            if (selectedItem == 'Country') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CountriesScreen()),
              );
            }
            if (selectedItem == 'Language') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageScreen()),
              );
            }
          },
          itemBuilder: (context) {
            return news.map((String toElement) {
              return PopupMenuItem<String>(
                value: toElement,
                child: Text(toElement),
              );
            }).toList();
          },
        ),
        centerTitle: true,
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          // PopupMenuButton<String>(
          //   iconSize: 40,
          //   initialValue: selectedSource,
          //   onSelected: (String selectedName) {
          //     setState(() {
          //       // selectedName = Map key
          //       selectedSource = selectedName;

          //       // Get ID from Map value
          //       name = newsSources[selectedName];
          //     });
          //   },
          //   itemBuilder: (context) {
          //     return newsSources.keys.map((String sourceName) {
          //       return PopupMenuItem<String>(
          //         value: sourceName,
          //         child: Text(sourceName),
          //       );
          //     }).toList();
          //   },
          // ),

          // Api
          PopupMenuButton<String>(
            iconSize: 40,
            initialValue: selectedSource,
            onSelected: (String selectedName) {
              setState(() {
                // selectedName = Map key
                selectedSource = selectedName;
                //selectedSource = newsApiSource[name]!;

                // Get ID from Map value
                name = newsApiSource[selectedName]!;
                print('Name: $selectedName');
                print('ID: ${newsApiSource[selectedName]}');
              });
            },
            itemBuilder: (context) {
              return newsApiSource.keys.map((String sourceName) {
                return PopupMenuItem<String>(
                  value: sourceName,
                  child: Text(sourceName),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitCircle(size: 50, color: Colors.blue);
                } else if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 40),
                      Text("404 Not Found ", style: TextStyle(fontSize: 25)),
                    ],
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString(),
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
                                newsTitle: snapshot.data!.articles![index].title
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
                                content: snapshot.data!.articles![index].content
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
                          child: Stack(
                            alignment: .center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: height * .02,
                                ),
                                height: height * .5,
                                width: width * .9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!
                                        .articles![index]
                                        .urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        SpinKitFadingCircle(
                                          color: Colors.amber,
                                          size: 50,
                                        ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 30,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    height: height * .15,
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      mainAxisAlignment: .center,
                                      crossAxisAlignment: .center,
                                      children: [
                                        SizedBox(
                                          width: width * .7,
                                          child: Text(
                                            snapshot
                                                .data!
                                                .articles![index]
                                                .title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: width * .7,
                                          child: Row(
                                            mainAxisAlignment: .spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  snapshot
                                                      .data!
                                                      .articles![index]
                                                      .source!
                                                      .name
                                                      .toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  format.format(dateTime),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.end,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),

          // News Headlines
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('General'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitCircle(size: 50, color: Colors.blue);
                } else if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 40),
                      Text("404 Not Found ", style: TextStyle(fontSize: 25)),
                    ],
                  );
                } else {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.articles!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString(),
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
                                newsTitle: snapshot.data!.articles![index].title
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
                                content: snapshot.data!.articles![index].content
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
                                    errorWidget: (context, url, error) => Icon(
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
                                          snapshot.data!.articles![index].title
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
    );
  }
}
