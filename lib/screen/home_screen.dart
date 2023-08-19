import 'package:flutter/material.dart';
import 'package:hisab/screen/add_hisab_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'alert_dialogue_screen.dart';
import 'hisab_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _hisabController = TextEditingController();

  Box box = Hive.box("HisabList");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.orange,
      ),
      body: getMainLayout,
    );
  }

  get getMainLayout => SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(width: 3,color: Colors.blue),
                  borderRadius: BorderRadius.circular(5)),
              child: const Text(
                "Previous Hisab",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.green),
              ),
            ),
          ),
          getPriviosHisabList,
          getAddHisabNamRow,
          getHisabButton,
        ],
      ));

  get getPriviosHisabList => (box.length == 0)
      ? const Center(child: Text("No previous Hisab Found!"))
      : Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              itemCount: box.length,
              itemBuilder: (ctx, ind) {
                return getSingleBoxName(ind);
              }),
        );

  getSingleBoxName(ind) {
    var boxName = box.getAt(ind);
    return Row(
      children: [
        InkWell(
            onTap: () async {
              await Hive.openBox(boxName);
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return HisabScreen(boxName);
              }));
            },
            child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black12,
                    border: Border.all(width: 3)),
                child: Center(
                    child: Text(
                  boxName,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.brown,
                      fontWeight: FontWeight.bold),
                )))),
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.transparent,
                  contentPadding: const EdgeInsets.only(right: 25, left: 25),
                  content: AlertDialogueScreen(),
                ),
              ).then((value) async {
                if (value) {
                  await box.deleteAt(ind);
                  setState(() {});
                }
              });
            },
            icon: const Icon(Icons.close))
      ],
    );
  }

  get getAddHisabNamRow => Container(
        padding: const EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 200,
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Center(
                child: TextField(
                  controller: _hisabController,
                  decoration: const InputDecoration(hintText: "Add New Hisab"),
                ),
              ),
            ),
          ],
        ),
      );

  get getHisabButton => InkWell(
        onTap: () async {
          if (_hisabController?.text.isNotEmpty ?? false) {
            var path = await getApplicationDocumentsDirectory();
            Hive.init(path.path);
            await Hive.openBox(_hisabController?.text ?? "");
            var box = Hive.box("HisabList");
            box.add(_hisabController?.text ?? "");
          } else {
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ADDHisabScreen(_hisabController?.text);
          }));
        },
        child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(left: 25, bottom: 20),
            decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 3)),
            child: const Text("ADD NEW HISAB")),
      );
}
