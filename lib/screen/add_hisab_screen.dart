import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab/events/hisab_events.dart';
import 'package:hisab/state/hisab_state.dart';
import 'package:hive/hive.dart';
import '../bloc/add_member_bloc.dart';
import 'hisab_screen.dart';

class ADDHisabScreen extends StatefulWidget {
  String? hisabName;

  ADDHisabScreen(this.hisabName, {super.key});

  @override
  State<ADDHisabScreen> createState() => _ADDHisabScreenState();
}

class _ADDHisabScreenState extends State<ADDHisabScreen> {
  final TextEditingController _controller = TextEditingController();

  late HisabBloc bloc;
  Box? box;

  List<String> _listOfMembers = [];

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<HisabBloc>(context);
    box = Hive.box(widget.hisabName ?? "");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("${widget.hisabName}")),
      body: getMainlayout,
    );
  }

  get getMainlayout => SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.max,
          children: [
            getMemberList,
            getAddMemberRow,
            getStartButton,
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ));

  get getMemberList => BlocBuilder(
      bloc: BlocProvider.of<HisabBloc>(context),
      builder: (ctx, HisabState state) {
        _listOfMembers = state.memberList;
        return Container(
          height: double.parse("${state.memberList.length}") * 80,
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.memberList.length,
              itemBuilder: (ctx, index) {
                return getSingleMember(index, state);
              }),
        );
      });

  getSingleMember(index, HisabState state) {
    return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            state.memberList[index],
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ));
  }

  get getAddMemberRow => Container(
        padding: const EdgeInsets.all(30),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all(width: 3)),
              width: 200,
              padding: EdgeInsets.only(left: 20),
              child: TextField(
                decoration: InputDecoration(hintText: "ADD MEMBER"),
                controller: _controller,
              ),
            ),
            TextButton(
                onPressed: () async {
                  if (_controller?.text.isNotEmpty ?? false) {
                    _listOfMembers.add(_controller?.text.trim() ?? "");

                    bloc.add(addMemberEvent(_listOfMembers));

                    await box?.put(_controller?.text, []);

                    print(box?.values.toString());
                    print(box?.keys.toString());
                    _controller?.text = "";
                  }
                },
                child: const Text("Add Member")),
          ],
        ),
      );

  get getStartButton => InkWell(
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            return HisabScreen(widget.hisabName ?? "");
          }));
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 3)),
          child: const Text(
            "Start Hisab",
            style: TextStyle(fontSize: 30),
          ),
        ),
      );
}
