import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:koompi_hotspot/src/backend/post_request.dart';
import 'package:koompi_hotspot/src/components/reuse_widget.dart';
import 'package:koompi_hotspot/src/screen/login/login_page.dart';
import 'package:koompi_hotspot/src/screen/reset_new_password/reset_password_body.dart';

class ResetNewPassword extends StatefulWidget {
  final String email;

  ResetNewPassword(this.email);
  _ResetNewPasswordState createState() => _ResetNewPasswordState();
}

class _ResetNewPasswordState extends State<ResetNewPassword> {

  bool _isLoading = false;
  String alertText;
  // Initially password is obscure
  bool _obscureText = true;
  bool _obscureText2 = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  final formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  

  void _submit(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      _resetPassword();
    }
    else{
      setState(() {
        _autoValidate = true;
      });
    }
  }
  
  Future <void> _resetPassword() async {
    dialogLoading(context);

    var responseBody;
    try {
      String apiUrl = 'https://api-hotspot.koompi.org/api/reset-password';
      setState(() {
        _isLoading = true;
      });
      var response = await http.put(apiUrl,
        headers: <String, String>{
          "accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(<String, String>{
          "email": widget.email,
          "new_password": _confirmPasswordController.text,
        }));
      if (response.statusCode == 200) {
        print(response.body);
        Future.delayed(Duration(seconds: 2), () {
          Timer(Duration(milliseconds: 500), () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            ModalRoute.withName('/'),
          ));
        });
      } else {
        Navigator.pop(context);
        showErrorDialog(context);
        print(response.body);
      }
    } catch (e) {
      Navigator.pop(context);
      alertText = responseBody['message'];
    }
    // try {
    //   final result = await InternetAddress.lookup('google.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     print('Internet connected');
    //     var response = await PostRequest().resetPassword(
    //       widget.email,
    //       _passwordController.text);
      //   if (response.statusCode == 200) {
      //     Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => LoginPage()),
      //       ModalRoute.withName('/'),
      //     );
      //   } 
      //   else if (response.statusCode == 401){
      //     Navigator.pop(context);
      //     return showErrorDialog(context);
      //   }
      //   else if (response.statusCode >= 500 && response.statusCode <600){
      //     Navigator.pop(context);
      //     return showErrorServerDialog(context);
      //   }
      // }
    // } on SocketException catch (_) {
    //   Navigator.pop(context);
    //   print('not connected');
    // }
  }

  showErrorServerDialog(BuildContext context) async {
    var response = await PostRequest().forgotPasswordByEmail(widget.email);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${response.body}'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
  }

  showErrorDialog(BuildContext context) async {
    var response = await PostRequest().forgotPasswordByEmail(widget.email);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${response.body}'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
  }



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          child: resetNewPasswordBody(
            context, 
            _passwordController, 
            _confirmPasswordController, 
            _obscureText, 
            _toggle, 
            _obscureText2, 
            _toggle2, 
            _submit, 
            formKey, 
            _autoValidate)
        ),
      )
    );
  }
}
