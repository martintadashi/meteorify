import 'package:ddp/ddp.dart';
import 'package:flutter/foundation.dart';

import './meteor.dart';

/// An enum for describing the [ConnectionStatus].

class MeteorNotifier with ChangeNotifier {
  MeteorNotifier(DdpClient client) {
    client?.addStatusListener((status) {
      switch (status) {
        case ConnectStatus.dialing:
          this.status = ConnectionStatus.DIALING;
          break;
        case ConnectStatus.connecting:
          this.status = ConnectionStatus.CONNECTED;
          break;
        case ConnectStatus.connected:
          this.status = ConnectionStatus.CONNECTED;
          break;
        default:
          this.status = ConnectionStatus.DISCONNECTED;
      }
    });
  }

  ConnectionStatus _status = ConnectionStatus.DISCONNECTED;

  ConnectionStatus get status => _status;

  set status(ConnectionStatus status) {
    _status = status;
    Meteor.status = status;
    if (status == ConnectionStatus.CONNECTED) {
      Meteor.isConnected = true;
    } else {
      Meteor.isConnected = false;
    }
    print("STATUS: " + status.toString());
    notifyListeners();
  }

  String _currentUserId;

  String get currentUserId => _currentUserId;

  set currentUserId(String userId) {
    _currentUserId = userId;
    _loginAttempt = true;
    notifyListeners();
  }

  bool _loginAttempt = false;

  bool get loginAttempt => _loginAttempt;

  set loginAttempt(bool attempt) {
    _loginAttempt = attempt;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
