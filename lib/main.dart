import 'package:flutter/material.dart';
import 'splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget 
  {@override
   Widget build(BuildContext context) 
    {return  MaterialApp
      (title: 'ArtisanalDips',
       home: SplashScreen()
      );
    }
  }