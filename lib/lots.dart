import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Lots extends StatefulWidget {
  const Lots({super.key});

  @override
  State<Lots> createState() => _LotsState();
}

class _LotsState extends State<Lots> {
  
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
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        color: const Color(0xffEBEFF2),
        alignment: Alignment.center,
        child: SizedBox(
          height: double.infinity,
          width: MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "Parking Lots",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[400],
                  ),
                ),
                // const SizedBox(height: 20,),
                StreamBuilder<QuerySnapshot>(
                  stream: lots,
                    builder: (context, snapshot) {
                      if(!snapshot.hasData) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: const Center(
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
                            padding: const EdgeInsets.only(bottom: 20),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}