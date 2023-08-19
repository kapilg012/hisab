abstract class HisabEvents {}

class addMemberEvent extends HisabEvents {
  List<String> list;

  addMemberEvent(this.list);
}
