import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_credentials.dart';
import '../auth_cubit.dart';
import '../form_submission_status.dart';
import '../auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepos;
  final AuthCubit? authCubit;

  LoginBloc({required this.authRepos, this.authCubit}) : super(LoginState()) {
    on<LoginUsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        final userId = await authRepos.login(
          username: state.username,
          password: state.password,
        );
        emit(state.copyWith(formStatus: SubmissionSuccess()));

        authCubit!.launchSession(AuthCredentials(
          username: state.username,
          userId: userId,
        ));
      } catch (e) {
        emit(state.copyWith(
            formStatus: SubmissionFailure(
                e is Exception ? e : Exception('Unknown error'))));
      }
    });
  }
}
