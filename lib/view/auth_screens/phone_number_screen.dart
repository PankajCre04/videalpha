import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videalpha/view/home_screens/home_screen.dart';
import 'package:videalpha/widgets/otp_field.dart';
import 'package:videalpha/widgets/phone_number_field.dart';

import '../../repository/phone_auth/phone_auth_bloc.dart';
import '../../res/internet_service.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);
  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  late TextEditingController _phoneNumberController;
  late TextEditingController _codeController;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
    _codeController = TextEditingController();
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string = _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string = _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }
      // 2.
      setState(() {});
      // 3.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            string,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PhoneAuthBloc, PhoneAuthState>(
        listener: (context, state) {
          // Phone Otp Verified. Send User to Home Screen
          if (state is PhoneAuthVerified) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
            );
          }
          if (state is PhoneAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        child: BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
          builder: (context, state) {
            if (state is PhoneAuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Firebase x Flutter: \nPhone Authentication",
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(
                      height: 30,
                      endIndent: 20,
                      indent: 20,
                      thickness: 1.5,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (state is! PhoneAuthCodeSentSuccess)
                      PhoneNumberWidget(
                        phoneNumberController: _phoneNumberController,
                      )
                    else
                      OtpWidget(
                        codeController: _codeController,
                        verificationId: state.verificationId,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
    // return Scaffold(
    //   body: Stack(
    //     alignment: Alignment.center,
    //     children: [
    //       Container(
    //         width: double.infinity,
    //         height: double.infinity,
    //         decoration: BoxDecoration(
    //           gradient: LinearGradient(
    //             colors: [
    //               Colors.pink.shade300,
    //               Colors.grey.shade600,
    //             ],
    //             begin: Alignment.topRight,
    //             end: Alignment.bottomLeft,
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         top: 50,
    //         child: RichText(
    //           text: TextSpan(children: [
    //             const TextSpan(
    //               text: "Vide",
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 35,
    //               ),
    //             ),
    //             TextSpan(
    //               text: "Alpha",
    //               style: TextStyle(
    //                 color: Colors.white.withOpacity(0.9),
    //                 fontSize: 25,
    //                 fontWeight: FontWeight.w500,
    //               ),
    //             ),
    //           ]),
    //         ),
    //       ),
    //       Container(
    //         height: 300,
    //         width: double.maxFinite,
    //         margin: const EdgeInsets.symmetric(horizontal: 30),
    //         padding: const EdgeInsets.all(25),
    //         decoration: BoxDecoration(
    //           color: Colors.white.withOpacity(1),
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             const Text(
    //               "Your Phone",
    //               style: TextStyle(
    //                 color: Colors.black,
    //                 fontWeight: FontWeight.w800,
    //                 fontSize: 23,
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 40,
    //             ),
    //             Text(
    //               "Phone Number",
    //               style: TextStyle(
    //                 color: Colors.black.withOpacity(0.6),
    //                 fontWeight: FontWeight.w700,
    //               ),
    //             ),
    //             Row(
    //               children: [
    //                 Expanded(
    //                   child: TextField(
    //                     decoration: InputDecoration(
    //                       hintText: "Enter Number",
    //                       hintStyle: TextStyle(
    //                         color: Colors.grey.withOpacity(0.8),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             const SizedBox(
    //               height: 30,
    //             ),
    //             Text(
    //               "A 4 digit will be sent via sms to verify your mobile number!",
    //               style: TextStyle(color: Colors.blue.shade200, fontWeight: FontWeight.w400, fontSize: 13),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Positioned(
    //         bottom: 30,
    //         child: InkWell(
    //           onTap: () {},
    //           child: Container(
    //             padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 25),
    //             decoration: BoxDecoration(
    //               gradient: LinearGradient(
    //                 colors: [
    //                   Colors.pink.shade200,
    //                   Colors.pink.shade700,
    //                 ],
    //               ),
    //               borderRadius: BorderRadius.circular(30),
    //             ),
    //             child: Row(
    //               children: const [
    //                 Text(
    //                   "Continue",
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 17,
    //                     fontWeight: FontWeight.w500,
    //                   ),
    //                 ),
    //                 SizedBox(width: 5),
    //                 Icon(
    //                   Icons.arrow_circle_right_rounded,
    //                   color: Colors.white,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
