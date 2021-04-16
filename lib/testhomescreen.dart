import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_classify_app/Gallery.dart';
import 'package:image_classify_app/splashscreen.dart';
import 'package:lottie/lottie.dart';

import 'Camera.dart';
import 'Custom_Card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  // PersistentTabController _controller;
  //PageController _pageController;
  // MyTheme currentTheme = MyTheme();
  @override
  void initState() {
    super.initState();
    //_controller = PersistentTabController(initialIndex: 0);
    //_pageController = PageController();
  }

  List<String> imagenames = [
    "assets/images/Hamburger.svg",
    "assets/images/package1.svg",
  ];
  List<String> imagetags = [
    'Gallery',
    "Camera",
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // _controller = PersistentTabController(initialIndex: 0);

    int columnCount = 2;
    //int currentIndex = 0;
    return

        /* MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: currentTheme.currentTheme(),
      home:*/
        Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 40.0, left: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 30,
                            )
                          ]),
                    ),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        child: Lottie.asset('assets/image classify.json',
                            repeat: true, reverse: true, animate: true),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Row(
                        children: [
                          Text('Image Classification',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0)),
                          SizedBox(width: 10.0),
                          Text('App',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 500.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0)),
                        ),
                        child: AnimationLimiter(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 100.0,
                              left: 20,
                              right: 20,
                            ),
                            child: GridView.count(
                              crossAxisCount: columnCount,
                              childAspectRatio: .85,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 20,
                              children: List.generate(
                                2,
                                (int index) {
                                  return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    columnCount: columnCount,
                                    child: ScaleAnimation(
                                      child: FadeInAnimation(
                                        child: CategoryCard(
                                          title: imagetags[index],
                                          svgSrc: imagenames[index],
                                          press: () {
                                            if (imagetags[index] == "Gallery") {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MyGallery()));
                                            } else if (imagetags[index] ==
                                                "Camera") {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MyCamera()));
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
