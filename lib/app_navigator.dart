import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/auth_cubit.dart';
import 'auth/auth_navigator.dart';
import 'loading_view.dart';
import 'session_cubit.dart';
import 'session_state.dart';
import 'session_view.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return Navigator(
          pages: [
            // show loading screen
            if (state is UnknownSessionState)
              const MaterialPage(child: LoadingView()),

            // show auth flow
            if (state is Unauthenticated)
              MaterialPage(
                child: BlocProvider(
                  create: (context) => AuthCubit(sessionCubit: context.read<SessionCubit>()),
                  child: const AuthNavigator(),
                ),
              ),

            // show session flow
            if (state is Authenticated) const MaterialPage(child: SessionView())
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      },
    );
  }
}
