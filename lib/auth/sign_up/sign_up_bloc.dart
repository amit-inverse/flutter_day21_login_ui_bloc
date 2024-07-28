import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_cubit.dart';
import '../form_submission_status.dart';
import '../auth_repository.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepos;
  final AuthCubit? authCubit;

  SignUpBloc({required this.authRepos, this.authCubit})
      : super(SignUpState()) {
    on<SignUpUsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    on<SignUpEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<SignUpPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<SignUpSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        await authRepos.signUp(
          username: state.username,
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith(formStatus: SubmissionSuccess()));

        authCubit!.showConfirmSignUp(
          username: state.username,
          email: state.email,
          password: state.password,
        );
      } catch (e) {
        emit(state.copyWith(
            formStatus: SubmissionFailure(
                e is Exception ? e : Exception('Unknown error'))));
      }
    });
  }
}
