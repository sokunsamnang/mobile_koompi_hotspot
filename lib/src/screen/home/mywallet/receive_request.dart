import 'package:koompi_hotspot/all_export.dart';

class ReceiveRequest extends StatefulWidget {
  @override
  _ReceiveRequestState createState() => _ReceiveRequestState();
}

class _ReceiveRequestState extends State<ReceiveRequest> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void showSnackBar() {
    final snackBarContent = SnackBar(
      content: Text("Copied"),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }

  void copyWallet(String _wallet) {
    Clipboard.setData(
      ClipboardData(
        text: _wallet,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          _lang.translate('receive_request'),
          style: TextStyle(
              color: Colors.black, fontFamily: 'Medium', fontSize: 22.0),
        ),
      ),
      body: mBalance.token != null
          ? Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 80),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'SELENDRA (SEL)', 
                              style: GoogleFonts.nunito(
                              textStyle: TextStyle(color: Colors.blue, fontSize: 25, fontWeight: FontWeight.w700)
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            QrImage(
                              data: mData.wallet ?? '',
                              version: QrVersions.auto,
                              embeddedImage: AssetImage('assets/images/sld_stroke.png'),
                              size: 225.0,
                              embeddedImageStyle: QrEmbeddedImageStyle(
                                size: Size(30, 30),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              mData.wallet ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Center(
                              child: InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color(0xFF17ead9),
                                        Color(0xFF6078ea)
                                      ]),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF6078ea)
                                                .withOpacity(.3),
                                            offset: Offset(0.0, 8.0),
                                            blurRadius: 8.0)
                                      ]),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      onTap: () async {
                                        copyWallet(mData.wallet);
                                        showSnackBar();
                                      },
                                      child: Center(
                                        child: Text(_lang.translate('copy'),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Poppins-Bold",
                                                fontSize: 18,)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Center(
                              child: InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color(0xFF17ead9),
                                        Color(0xFF6078ea)
                                      ]),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF6078ea)
                                                .withOpacity(.3),
                                            offset: Offset(0.0, 8.0),
                                            blurRadius: 8.0)
                                      ]),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      onTap: () async {
                                        Share.share('Here is my Selendra wallet ID: ${mData.wallet}', subject: 'My Selendra Wallet ID');
                                      },
                                      child: Center(
                                        child: Text(_lang.translate('share'),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Poppins-Bold",
                                                fontSize: 18,)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Container(
                //       margin: const EdgeInsets.only(top: 50),
                //       child: BtnSocial(
                //           () {}, AssetImage('assets/images/avatar.png'))),
                // ),
                // ReuseIndicator(currentIndex),
              ],
            )
          : Center(
              child: Text('No Data'),
            ),
    );
  }
}
