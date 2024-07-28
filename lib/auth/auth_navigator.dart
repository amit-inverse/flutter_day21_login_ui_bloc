import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_cubit.dart';
import 'confirm/confirmation_view.dart';
import 'login/login_view.dart';
import 'sign_up/sign_up_view.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Navigator(
          pages: [
            // show login
            if (state == AuthState.login) MaterialPage(child: LoginView()),

            // allow push animation
            if (state == AuthState.signUp ||
                state == AuthState.confirmSignUp) ...[
              // show sign up
              MaterialPage(child: SignUpView()),

              // show confirm sign up
              if (state == AuthState.confirmSignUp)
                MaterialPage(child: ConfirmationView())
            ]
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      },
    );
  }
}
