import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videalpha/repository/phone_auth/phone_auth_bloc.dart';
import 'package:videalpha/repository/phone_auth/phone_auth_repository.dart';
import 'package:videalpha/view/auth_screens/otp_verification_screen.dart';
import 'package:videalpha/view/auth_screens/phone_number_screen.dart';
import 'package:videalpha/view/home_screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  Future<bool> isUserLoggedIn() async {
    final User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data ?? false) {
              return RepositoryProvider(
                create: (context) => PhoneAuthRepository(),
                child: BlocProvider(
                  create: (context) => PhoneAuthBloc(
                    phoneAuthRepository: RepositoryProvider.of<PhoneAuthRepository>(context),
                  ),
                  child: const PhoneNumberScreen(),
                ),
              );
            } else {
              return RepositoryProvider(
                create: (context) => PhoneAuthRepository(),
                child: BlocProvider(
                  create: (context) => PhoneAuthBloc(
                    phoneAuthRepository: RepositoryProvider.of<PhoneAuthRepository>(context),
                  ),
                  child: const HomeScreen(),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: SizedBox(
                  height: 50,
                  child: Text(
                    "Oops Something went Wrong",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
