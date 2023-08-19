import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HisabScreen extends StatefulWidget {
  String hisabName;

  HisabScreen(this.hisabName, {super.key});

  @override
  State<HisabScreen> createState() => _HisabScreenState();
}

class _HisabScreenState extends State<HisabScreen> {
  late Box box;
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  List<num> listOfSum = [];
  List<bool> listOfBool = [];

  @override
  Widget build(BuildContext context) {
    box = Hive.box(widget.hisabName);

    if (listOfBool.isEmpty) {
      box.keys.forEach((element) {
        listOfBool.add(false);
        listOfSum.add(0);
      });
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.hisabName)),
      body: getMainLayout,
    );
  }

  get getMainLayout => SafeArea(
          child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: box.length,
                itemBuilder: (ctx, ind) => singleMainListItem(ind)),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, ind) {
              return singleTextItem(ind);
            },
            itemCount: box.length,
          ))
        ],
      ));

  singleTextItem(ind) {
    num total = 0;
    var name = box.keys.toList()[ind];
    List list = box.get(name);
    listOfSum.forEach((element) {
      total += element;
    });
    var finalValue = total ~/ box.keys.length;
    if (finalValue - listOfSum[ind] > 0) {
      return Text("${name} has to give ${finalValue - listOfSum[ind]}",
          style: TextStyle(color: Colors.red));
    } else {
      return Text(
        "${name} has to take ${finalValue - listOfSum[ind]}",
        style: TextStyle(color: Colors.green),
      );
    }
  }

  singleMainListItem(int index) {
    var name = box.keys.toList()[index];
    List list = box.get(name);

    num sum = 0;
    list.forEach((element) {
      sum += element["amount"];
    });
    listOfSum[index] = sum;
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text("${name}"),
              Text("${sum}"),
              IconButton(
                  onPressed: () {
                    listOfBool[index] = !listOfBool[index];
                    setState(() {});
                  },
                  icon: (listOfBool[index])
                      ? const Icon(Icons.arrow_upward_outlined)
                      : const Icon(Icons.arrow_downward_outlined))
            ],
          ),
          if (listOfBool[index])
            Container(
              height: list.length * 20,
              child: ListView.builder(
                itemBuilder: (cx, ind) {
                  return getSingleItem(name, ind);
                },
                itemCount: list.length,
              ),
            ),
          if (listOfBool[index])
            Row(
              children: [
                const Text("Add Subject :"),
                Container(
                  width: 100,
                  child: TextField(
                    controller: _subjectController,
                  ),
                )
              ],
            ),
          if (listOfBool[index])
            Row(
              children: [
                const Text("Add Amount :"),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _amountController,
                  ),
                )
              ],
            ),
          if (listOfBool[index])
            InkWell(
                onTap: () async {
                  var list = box.get(name);
                  list.add({
                    "subject": _subjectController.text,
                    "amount": double.parse(_amountController.text)
                  });
                  await box.put(name, list);

                  setState(() {
                    _subjectController.text = "";
                    _amountController.text = "";
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 3),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.orange),
                  child: Text("Save"),
                ))
        ],
      ),
    );
  }

  getSingleItem(String name, int listIndex) {
    var item = box.get(name);

    print("${item}");

    return Row(
      children: [
        Text(item[listIndex]["subject"]),
        Text("${item[listIndex]["amount"]}"),
      ],
    );
  }
}