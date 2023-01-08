import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Spots extends StatefulWidget {
  const Spots({Key? key}) : super(key: key);

  @override
  State<Spots> createState() => _SpotsState();
}

class _SpotsState extends State<Spots> {
  
  var db = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? stream;
  bool isHistory = false;
  String parking = "";
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      parking = args["parking"] ?? "";
      isHistory = args["history"] ?? false;
      setState(() {
        stream = db.collection('lots')
          .doc(parking)
          .collection(isHistory ? 'history' : 'spots')
          .orderBy('time', descending: true)
          .snapshots();
      });
    });
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
              children: [
                const SizedBox(height: 40,),
                Text(
                  parking,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[400],
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  isHistory ? "History" : "Spots",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue[300],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: stream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
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
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          return Card(
                            child: ListTile(
                              title: Text(doc['reg']),
                              subtitle: Text(doc['model']),
                              trailing: isHistory 
                                ? Text(DateFormat('d MMM yy, h:mm a').format(DateTime.parse(doc['time']))) 
                                : IconButton(
                                  onPressed: () {
                                    db.collection('lots')
                                      .doc(parking)
                                      .collection('spots')
                                      .doc(doc.id)
                                      .delete();
                                      
                                    db.collection('lots')
                                      .doc(parking)
                                      .collection('history')
                                      .add({
                                        'reg': doc['reg'],
                                        'model': doc['model'],
                                        'time': DateTime.now().toString(),
                                    });
                                  },
                                  icon: const Icon(Icons.exit_to_app),
                                ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}