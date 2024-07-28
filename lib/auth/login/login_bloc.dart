import 'package:flutter_bloc/flutter_bloc.dart';

import '../form_submission_status.dart';
import '../auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepos;

  LoginBloc({required this.authRepos}) : super(LoginState()) {
    on<LoginUsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        await authRepos.login();
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } catch (e) {
        emit(state.copyWith(
            formStatus: SubmissionFailure(e is Exception ? e : Exception('Unknown error'))));
      }
    });
  }
}
