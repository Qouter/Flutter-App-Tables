import 'package:app_components/src/pages/sounds_page.dart';
import 'package:flutter/material.dart';

import 'package:app_components/src/pages/alert_page.dart';


Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/'     : ( BuildContext context) => AlertPage(),
    'sounds': (BuildContext context) => SoundsPage(),
  };
}