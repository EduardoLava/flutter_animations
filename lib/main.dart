import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Animations intro",
      debugShowCheckedModeBanner: false,
      home: LogoApp(),
    );
  }
}

class LogoApp extends StatefulWidget {
  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {// informa toda vez que a tela for renderizada

  AnimationController controller;// pode ser usado em vairas animações
  Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return
        GrowTransparencyTransition(
          child: LogoWidget(),
          animation: animation,
        );

//      return AnimatedLogo(animation);
//    return Center(
//      child: Container(
//        height: animation.value,
//        width: animation.value,
//        child: FlutterLogo(),
//      ),
//    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2)
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        controller.reverse();
      } else if(status == AnimationStatus.dismissed){ // quando ela regride até zero
        controller.forward();
      }
    });

    animation.addListener((){
      print(animation.value);
    });

    /// notacao de cascata
//    ..addListener((){// invoca sempre que tiver alguma alteracao
//      setState(() {
//
//      });
//    });

    controller.forward();// para animar para frente

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


}

//class AnimatedLogo extends AnimatedWidget {
//
//  AnimatedLogo(Animation<double> animation) : super(listenable: animation);
//
//  @override
//  Widget build(BuildContext context) {
//
//    final Animation<double> animation = listenable;
//
//    return Center(
//      child: Container(
//        height: animation.value,
//        width: animation.value,
//        child: FlutterLogo(),
//      ),
//    );
//  }
//
//}

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogo();
  }
}
// animacao
class GrowTransparencyTransition extends StatelessWidget {

  final Widget child;
  final Animation<double> animation;

  final sizeTween = Tween<double>(begin: 0, end: 300);
  final opacityTween = Tween<double>(begin: 0.1, end: 1);

  GrowTransparencyTransition({this.child, this.animation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child){
          return Opacity(
            opacity: opacityTween.evaluate(animation).clamp(0, 1.0),// para nao dar erro quando a animacao passa o valor maximo
            child: Container(
              height: sizeTween.evaluate(animation),
              width: sizeTween.evaluate(animation),
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}

