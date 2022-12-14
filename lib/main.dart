import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parkezy/parking.dart';
import 'package:parkezy/spots.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parkezy',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/parking': (context) => const Parking(),
        '/spots': (context) => const Spots(),
      },
      theme: ThemeData(
        cardTheme: CardTheme(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var db = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? lots;
  
  @override
  void initState() {
    super.initState();
    lots = db.collection('lots').snapshots();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xffEBEFF2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "SHIV NADAR IOE",
                    style: TextStyle(
                      color: Colors.blue[300],
                    ),
                  ),
                  const Text(
                    "X",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "PARKEZY",
                    style: TextStyle(
                      color: Colors.purple[400],
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(10),
            //   child: const Text(
            //     "Parking Lots",
            //     style: TextStyle(
            //       fontSize: 20,
            //     ),
            //   ),
            // ),
            
            StreamBuilder<QuerySnapshot>(
              stream: lots,
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        "No data",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context, 
                            '/parking', 
                            arguments: {
                              'parking': 'Parking ${index + 1}',
                              'capacity': snapshot.data!.docs[index]['capacity'],
                            }
                          );
                        },
                        child: Card(
                          child: SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Center(
                              child: Text(
                                snapshot.data!.docs[index].id,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            ),
            
            // StreamBuilder<QuerySnapshot>(
            //   stream: lots,
            //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            //     } else {
            //       return const CircularProgressIndicator();
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
