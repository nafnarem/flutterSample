import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:lockstars_sample/screens/places_list_screen.dart';

enum MobileVerificationState {
  showMobileFormState,
  showOtpFormState,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.showMobileFormState;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String countryCode = '';

  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationId = '';
  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PlacesListScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      scaffoldMessengerKey.currentState
          ?.showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  getMobileFormWidget(context) {
    return Column(children: [
      const Spacer(),
      Row(children: [
        Expanded(
            flex: 1,
            child: CountryCodePicker(
              initialSelection: 'PH',
              alignLeft: false,
              enabled: true,
              onInit: (value) {
                countryCode = value!.dialCode!;
              },
              onChanged: (value) {
                countryCode = value.dialCode!;
              },
            )),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 80, 0),
            child: TextField(
              controller: phoneController,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "Phone Number",
              ),
            ),
          ),
        ),
      ]),
      TextButton(
        onPressed: () async {
          setState(() {
            showLoading = true;
          });
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: countryCode + phoneController.text,
            verificationCompleted: (phoneAuthCredential) async {
              setState(() {
                showLoading = false;
              });
            },
            verificationFailed: (verificationFailed) async {
              setState(() {
                showLoading = false;
              });
              scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(content: Text(verificationFailed.message!)));
            },
            codeSent: (verificationId, resendingToken) async {
              setState(() {
                showLoading = false;
                currentState = MobileVerificationState.showOtpFormState;
                this.verificationId = verificationId;
              });
            },
            codeAutoRetrievalTimeout: (verificationId) async {},
          );
        },
        child: const Text('SEND'),
        style: TextButton.styleFrom(
            primary: Colors.white, backgroundColor: Colors.black),
      ),
      const Spacer(),
    ]);
  }

  getOtpFormWidget(context) {
    return Column(children: [
      const Spacer(),
      Padding(
        padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
        child: TextField(
          controller: otpController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: "EnterOtp",
          ),
        ),
      ),
      TextButton(
        onPressed: () async {
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: otpController.text);
          signInWithPhoneAuthCredential(phoneAuthCredential);
        },
        child: const Text('VERIFY'),
        style: TextButton.styleFrom(
            primary: Colors.white, backgroundColor: Colors.black),
      ),
      const Spacer(),
    ]);
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Sample App Login'),
            ),
            body: showLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : currentState == MobileVerificationState.showMobileFormState
                    ? getMobileFormWidget(context)
                    : getOtpFormWidget(context)));
  }
}
