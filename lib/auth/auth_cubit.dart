import 'package:flutter_bloc/flutter_bloc.dart';

import '../session_cubit.dart';
import 'auth_credentials.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  AuthCredentials? credentials;
  final SessionCubit? sessionCubit;

  AuthCubit({this.credentials, this.sessionCubit})
      : super(AuthState.login);

  void showLogin() => emit(AuthState.login);
  void showSignUp() => emit(AuthState.signUp);
  void showConfirmSignUp({
    required String username,
    required String email,
    required String password,
  }) {
    credentials =
        AuthCredentials(username: username, email: email, password: password);
    emit(AuthState.confirmSignUp);
  }

  void launchSession(AuthCredentials credentials) => sessionCubit!.showSession(credentials);
}
