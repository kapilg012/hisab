import 'package:flutter/material.dart';

class AlertDialogueScreen extends StatefulWidget {
  AlertDialogueScreen();

  @override
  _AlertDialogueScreenState createState() => _AlertDialogueScreenState();
}

class _AlertDialogueScreenState extends State<AlertDialogueScreen> {
  @override
  Widget build(BuildContext context) {
    return getDeleteCard;
  }

  get getDeleteCard => Container(
        height: 200,
        width: double.infinity,
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Alert",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Do you want to delete this Hisab?",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getCancelButton,
                const SizedBox(
                  width: 5,
                ),
                getWinnerButton,
              ],
            ),
          ],
        ),
      );

  get getCancelButton => Expanded(
        child: InkWell(
          onTap: () async {
            Navigator.of(context).pop(false);
          },
          child: Container(
            height: 35,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(25)),
            child: const Center(
              child: Text(
                "No",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      );

  get getWinnerButton => Expanded(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop(true);
          },
          child: Container(
            height: 35,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(25)),
            child: const Center(
              child: Text(
                "Yes !!!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
}
