import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/GItem.dart';
import 'package:flutter_application_1/Pages/AddIPage.dart';
import 'package:flutter_application_1/Pages/ItemPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Appdata {
  static List name = ['item 1', 'item 2', 'item 3', 'item 4'];
  static List UrlImage = [
    'https://m.media-amazon.com/images/I/61BOODXLroL._AC_SL1080_.jpg',
    'https://m.media-amazon.com/images/I/71-ADga7FEL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/81Z35wQ6zpL._AC_SL1500_.jpg',
    'https://cloudinary.images-iherb.com/image/upload/f_auto,q_auto:eco/images/bra/bra00116/l/31.jpg'
  ];
  static List<GItem> glist = [
    GItem(id: 'id', name: 'item 1', imageUrl: 'https://m.media-amazon.com/images/I/61BOODXLroL._AC_SL1080_.jpg'),
    GItem(id: 'id', name: 'item 2', imageUrl: 'https://m.media-amazon.com/images/I/71-ADga7FEL._AC_SL1500_.jpg'),
    GItem(id: 'id', name: 'item 3', imageUrl: 'https://m.media-amazon.com/images/I/81Z35wQ6zpL._AC_SL1500_.jpg'),
    GItem(
        id: 'id',
        name: 'item 4',
        imageUrl: 'https://cloudinary.images-iherb.com/image/upload/f_auto,q_auto:eco/images/bra/bra00116/l/31.jpg'),
  ];
}

class _MyHomePageState extends State<MyHomePage> {
  List<GItem> GList = [];
  //late Future<List<GItem>> GList;

  @override
  void initState() {
    listenToGItem();
    //GList = getGList();
    super.initState();
  }

  listenToGItem() {
    FirebaseFirestore.instance.collection('GItem').snapshots().listen((event) {
      List<GItem> newList = [];
      for (final doc in event.docs) {
        final itemList = GItem.fromMap(doc.data());
        newList.add(itemList);
      }
      GList = newList;
      setState(() {});
    });
  }

  Future<List<GItem>> getGList() async {
    final collection = await FirebaseFirestore.instance.collection('GItem').get();
    List<GItem> newList = [];
    for (final doc in collection.docs) {
      final restaurant = GItem.fromMap(doc.data());
      newList.add(restaurant);
    }
    //print(newList);
    //GList = newList;
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    border: Border.all(color: const Color.fromARGB(190, 200, 200, 200)),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddIPage(
                                    i: 'New Item',
                                  )));
                    },
                    child: const Text(
                      'Add new to the list',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('List Count: ${GList.length}', style: const TextStyle(color: Colors.black)),
              const SizedBox(
                height: 10,
              ),
              for (var item in GList)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ItemPage(
                                              i: item,
                                            )));
                              },
                              child: SizedBox(
                                width: 100,
                                child: Text(
                                  item.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              )),
                          InkWell(
                            onTap: () {
                              showAlertDialog(context, item);
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, GItem i) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Delete"),
      onPressed: () {
        // Appdata.glist.remove(i);
        final GItemCollection = FirebaseFirestore.instance.collection('GItem');
        final GItemDoc = GItemCollection.doc(i.id);
        GItemDoc.delete();
        setState(() {});
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete"),
      content: Text("Would you like to delete ${i.name}?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
