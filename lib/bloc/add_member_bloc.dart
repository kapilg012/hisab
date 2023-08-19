import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/hisab_events.dart';
import '../state/hisab_state.dart';

class HisabBloc extends Bloc<HisabEvents, HisabState> {
  /// {@macro counter_bloc}
  HisabBloc() : super(HisabState([])) {
    on<addMemberEvent>((addMemberEvent event, emit) => onAddMemberEvent(event));
  }

  onAddMemberEvent(addMemberEvent event) {
    emit(HisabState(event.list));
  }
}
