# Meteorify

[![Pub](https://img.shields.io/pub/v/meteorify.svg)](https://pub.dartlang.org/packages/meteorify)



A Dart package to interact with Meteor.js

Connect your flutter apps, written in Dart, to the Meteor framework using DDP.



## Features 

- Connect to Meteor server
- Use Meteor Subscriptions
- Meteor Authentication
- Call Meteor Methods


## Dependency

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  meteorify: ^1.0.2
```


## Usage


#### Import

```dart
import 'package:meteorify/meteorify.dart';
````


> ### Capturing the result of operations

> You can use either the `then-catchError` or `await` syntax to capture the result of operations and handle errors.

> **I'll be using the `await` syntax in this documentation to keep it short and straight.**
> You can use either `catchError` on `Future` object or `try/catch` syntax to catch errors.

***
***

## Connection Operations

#### Connecting with Meteor

```dart
Meteor.connect("ws://example.meteor.com/websocket");
```


#### Check connection status

```dart
var isConnected = Meteor.isConnected;		
```

#### Connection status notifier

```dart
Meteor.notifier().addListener((){
   ConnectionStatus status = Meteor.status;
   // Do something when the status changed
}));	
```

##### As provider
```dart
ChangeNotifierProvider<MeteorNotifier>(
  builder: (context) => Meteor.notifier(),
  child: SomeWidget(),
)

final statusProvider = Provider.of<MeteorNotifier>(context);
```

#### Disconnect from server

```dart
Meteor.disconnect();
```

***
***

## Methods

Using `then-catchError`:

```dart
Meteor.call(methodName, params)
  .then((result){
      // Do something with the result
  })
  .catchError((error){
      print(error);
      //Handle error
  });
```

Using `await`:

```dart
try{
  var result = await Meteor.call(methodName, params);
  // Do something with the result
}catch(error){
  print(error);
  //Handle error
}
```

***
***

## Subscriptions

#### Subscribe to Data

```dart
var subscriptionId = await Meteor.subscribe(subscriptionName, params: List<dynamic> params);
```



#### Unsubscribe from Data

```dart
await Meteor.unsubscribe(subscriptionId);
```



#### Get subscribed data/collection

```dart
SubscribedCollection collection = Meteor.collection(collectionName);
//collection.find({selectors});
//collection.findAll();
//collection.findOne(id);
```

***
***

## Authentication


#### Login with password

   ```dart
   String loginToken = await Meteor.loginWithPassword(email,password);
   ```


#### Login with username

   ```dart
   String loginToken = await Meteor.loginWithUsername(username,password);
   ```

#### Login with token

   ```dart
   String token = await Meteor.loginWithToken(loginToken);
   ```

#### Create new account

   ```dart
   String userId = await Accounts.createUser(username,email,password,profileMap);
   ```

#### Change Password (need to be logged in)

   ```dart
   String result = await Accounts.changePassword(oldPassword,newPassword);
   ```

#### Forgot Password

   ```dart
   String result = await Accounts.forgotPassword(email);
   ```

#### Reset Password

   ```dart
   String result = await Accounts.resetPassword(resetToken,newPassword);
   ```

#### Logout

   ```dart
   await Meteor.logout();
   ```

#### Get logged in userId

   ```dart
   String userId = Meteor.currentUserId;
   ```

#### Check if logged in

   ```dart
   bool isLoggedIn = Meteor.isLoggedIn();
   ```