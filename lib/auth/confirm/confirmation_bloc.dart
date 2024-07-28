import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_cubit.dart';
import '../form_submission_status.dart';
import '../auth_repository.dart';
import 'confirmation_event.dart';
import 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepository authRepos;
  final AuthCubit? authCubit;

  ConfirmationBloc({required this.authRepos, this.authCubit}) : super(ConfirmationState()) {
    on<ConfirmationCodeChanged>((event, emit) {
      emit(state.copyWith(code: event.code));
    });

    on<ConfirmationSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        final userId = await authRepos.confirmSignUp(
          username: authCubit!.credentials!.username,
          confirmationCode: state.code,
        );
        emit(state.copyWith(formStatus: SubmissionSuccess()));

        final credentials = authCubit!.credentials;
        credentials!.userId = userId;

        authCubit!.launchSession(credentials);
      } catch (e) {
        emit(state.copyWith(
            formStatus: SubmissionFailure(
                e is Exception ? e : Exception('Unknown error'))));
      }
    });
  }
}
