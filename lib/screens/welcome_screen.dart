import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat_firebase/screens/login_screen.dart';
import 'package:flash_chat_firebase/screens/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>with SingleTickerProviderStateMixin{
  late AnimationController controller ;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
        vsync:this,
        duration: const Duration(seconds: 2) );
    animation =ColorTween(begin:Colors.blueAccent,end:Colors.green).animate(controller);
    controller.forward();
    setState(() {

    });
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(

                  tag:'logo',
                  child: SizedBox(
                    height:60,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              SizedBox(
                width: 250,

                child: DefaultTextStyle(

                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                    color: Colors.black54,
                  ),
                  child: AnimatedTextKit(animatedTexts: [
                    TypewriterAnimatedText("Flash Chat ",speed: Duration(milliseconds: 60))

                  ]

                  ),
                ),
              )
         
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx){
                      return const LoginScreen();
                    }));
                    //Go to login screen.
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    //Go to registration screen.
                    Navigator.push(context, MaterialPageRoute(builder: (ctx){
                      return const RegistrationScreen();
                    }));
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}