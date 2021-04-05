import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/src/models/lang.dart';
import 'package:koompi_hotspot/src/utils/data_connectiviy_service.dart';
import 'package:koompi_hotspot/src/utils/shortcut.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:koompi_hotspot/src/screen/web_view/captive_portal_web.dart';
import 'package:koompi_hotspot/src/utils/constants.dart' as global;

class App extends StatefulWidget{

  App({Key key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    DataConnectivityService()
        .connectivityStreamController
        .stream
        .listen((event) {
      print(event);
      if (event == DataConnectionStatus.connected) {
        // _paused();
      } 
      else if(event == DataConnectionStatus.disconnected){
        _paused();
      }
      else {
        return null;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
          DataConnectivityService()
            .connectivityStreamController
            .stream
            .listen((event) {
          print(event);
          if (event == DataConnectionStatus.connected) {
            // _paused();
          } 
          else if(event == DataConnectionStatus.disconnected){
            _paused();
          }
          else {
            return null;
          }
        });
        break;
      case AppLifecycleState.inactive:
        break;
      default:
        break;
    }
  }

  Future _paused() async {
    print('paused');
    return inputWeb();
  }


  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged> _onchanged; 

  Future inputWeb() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      global.phone = prefs.getString('phone');
      global.password = prefs.getString('password');
    });

    print('Run web portal');
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.launch(selectedUrl, hidden: true, withJavascript: true, ignoreSSLErrors: true);
    _onchanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if(state.type== WebViewState.finishLoad){ // if the full website page loaded
          print('web laoded');
          flutterWebViewPlugin.evalJavascript('document.getElementById("user").value="${global.phone}"'); // Replace with the id of username field
          flutterWebViewPlugin.evalJavascript('document.getElementById("password").value="${global.password}"'); // Replace with the id of password field
          flutterWebViewPlugin.evalJavascript('document.getElementById("btnlogin").click()');  // Replace with Submit button id

        }else if (state.type== WebViewState.abortLoad){ // if there is a problem with loading the url
          print("there is a problem...");
        } else if(state.type== WebViewState.startLoad){ // if the url started loading
          print("start loading...");
        }
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  
  Widget build (context){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LangProvider>(
          create: (context) => LangProvider(),
        ),
        ChangeNotifierProvider<BalanceProvider>(
          create: (context) => BalanceProvider(),
        ),
        ChangeNotifierProvider<TrxHistoryProvider>(
          create: (context) => TrxHistoryProvider()
        ),
        ChangeNotifierProvider<GetPlanProvider>(
          create: (context) => GetPlanProvider(),
        ),
      ],
      child: Consumer<LangProvider>(
        builder: (context, value, child) => MaterialApp(
          builder: (context, child) => ScrollConfiguration(
            behavior: ScrollBehavior()
              ..buildViewportChrome(context, child, AxisDirection.down),
            child: child,
          ),

          locale: value.manualLocale,
          supportedLocales: [
              const Locale('en', 'US'),
              const Locale('km', 'KH'),
            ],
          localizationsDelegates: [
            AppLocalizeService.delegate,
            //build-in localization for material wiidgets
            GlobalWidgetsLocalizations.delegate,

            GlobalMaterialLocalizations.delegate,
          ],
          initialRoute: '/',
          routes: {
            '/navbar': (context) => Navbar(),
            '/plan': (context) => HotspotPlan(),
            '/loginEmail':(context) => LoginPage(),
            '/loginPhone': (context) => LoginPhone(),
            '/welcome': (context) => WelcomeScreen(),
            '/walletScreen': (context) => WalletScreen(),
          },
          title: 'Koompi Hotspot',
          home: Splash(),
        ),
      ),
      
    );
  }
}

class Splash extends StatefulWidget {
    @override
    _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {

  NetworkStatus _networkStatus = NetworkStatus();

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    // var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {// Not first time
      return isLoggedIn();
    } 
    else {// First time
      prefs.setBool('first_time', false);
      return navigationOnboardingScreen();
    }
  }

  void navigationOnboardingScreen() {
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => OnboardingScreen())
    ); 
  }

  void isLoggedIn() async{
    setState(() {
      StorageServices().checkUser(context);
    });
  }

  void setDefaultLang() {
    var _lang = Provider.of<LangProvider>(context, listen: false);
    StorageServices().read('lang').then(
      (value) {
        _lang.setLocal(value, context);
      },
    );
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      global.phone = prefs.getString('phone');
      global.password = prefs.getString('password');
    });
    print('${global.phone}');
    print('${global.password}');
  }
  


  @override
  void initState() {
    super.initState();
    setState(() {
      isInternet();
      getValue();
      startTime();
    });
    initQuickActions();

    //Set Language
    setDefaultLang();
  }

  final quickActions = QuickActions();
  
  void initQuickActions() {
    quickActions.initialize((type) {
      if (type == null) return;

      if (type == ShortcutItems.actionCaptivePortal.type) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CaptivePortalWeb()),
        );
      }
    });

    quickActions.setShortcutItems(ShortcutItems.items);
  }

  @override
  void dispose(){
    super.dispose();
  }

  Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Mobile data detected & internet connection confirmed.
        print('Mobile data detected & internet connection confirmed.');
        return true;
      } else {
        // Mobile data detected but no internet connection found.
        print('Mobile data detected but no internet connection found.');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
      print('I am connected to a WIFI network, make sure there is actually a net connection.');
      if (await DataConnectionChecker().hasConnection) {
        // Wifi detected & internet connection confirmed.
        print('Wifi detected & internet connection confirmed.');
        return true;
      } else {
        // Wifi detected but no internet connection found.
        print('Wifi detected but no internet connection found.');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CaptivePortalWeb()),
        );
        return false;
      }
    } else {
      // Neither mobile data or WIFI detected, not internet connection found.
      print('Neither mobile data or WIFI detected, not internet connection found.');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _networkStatus.restartApp(context)),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0caddb),
      body: Center(
        child: FlareActor( 
          'assets/animations/koompi_splash_screen.flr', 
          animation: 'Splash_Loop',
        ),
      ),
    );
  }
}