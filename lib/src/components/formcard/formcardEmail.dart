import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@override
Widget formCardEmail(
    BuildContext context,
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    bool _obscureText,
    Function _toggle,
    bool _secondObscureText,
    Function _secondToggle) {

    return new Container(
      width: double.infinity,
  //      height: ScreenUtil.getInstance().setHeight(500),
      padding: EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
    child: Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Sign Up",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(45),
                  fontFamily: "Poppins-Bold",
                  letterSpacing: .6)),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Text("Username",
              style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontSize: ScreenUtil().setSp(26))),
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
                hintText: "Username",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Text("Email",
              style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontSize: ScreenUtil().setSp(26))),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Text("Password",
              style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontSize: ScreenUtil().setSp(26))),
          TextFormField(
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    _toggle();
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Text("Confirm Password",
              style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontSize: ScreenUtil().setSp(26))),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: _secondObscureText,
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    _secondToggle();
                  },
                  child: Icon(
                    _secondObscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                hintText: "Confirm Password",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(35),
          ),
        ],
      ),
    ),
  );
}
