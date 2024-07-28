import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_navigator.dart';
// import 'auth/auth_cubit.dart';
// import 'auth/auth_navigator.dart';
import 'auth/auth_repository.dart';
import 'session_cubit.dart';
// import 'auth/login/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Media App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider(
        create: (context) => AuthRepository(),
        child: BlocProvider(
          create: (context) => SessionCubit(authRepo: context.read<AuthRepository>()),
          child: const AppNavigator(),
        ),
      ),
    );
  }
}
