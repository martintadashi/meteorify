import 'package:ddp/ddp.dart';

import '../meteor/meteor.dart';

/// Provides useful methods to read data from a collection on the frontend.
///
/// [SubscribedCollection] supports only read functionality useful in case of getting only the data subscribed by user and not any other data.
/// To access other methods use `Meteor.getCustomDatabase(dbUrl)` and use the methods of the `Db` class.
class SubscribedCollection {
  /// The internal collection instance.
  Collection _collection;

  /// Name of the collection.
  String name;

  /// Construct a subscribed collection.
  SubscribedCollection(this._collection, this.name);

  /// Returns a single object by matching the [id] of the object.
  Map<String, dynamic> findOne(String id) {
    return _collection.findOne(id);
  }

  /// Returns all objects of the subscribed collection.
  Map<String, Map<String, dynamic>> findAll() {
    return _collection.findAll();
  }

  void addUpdateListener(UpdateListener listener) {
    _collection.addUpdateListener(listener);
  }

  /// Returns specific objects from a subscribed collection using a set of [selectors].
  Map<String, Map<String, dynamic>> find(Map<String, dynamic> selectors) {
    Map<String, Map<String, dynamic>> filteredCollection =
        Map<String, Map<String, dynamic>>();
    print("Finding docs");
    print(selectors.keys);
    _collection.findAll().forEach((key, document) {
      bool shouldAdd = true;
      selectors.forEach((selector, value) {
        print("Key: $selector");
        print("Value: ${document[selector]}");
        if (document[selector] != value) {
          shouldAdd = false;
        }
      });
      if (shouldAdd) {
        print('Add');
        filteredCollection[key] = document;
      } else {
        print("Don't add");
      }
    });

    return filteredCollection;
  }

  /*
 * Methods related to collections
 */

  /// Returns a [SubscribedCollection] using the [collectionName].
  ///
  /// [SubscribedCollection] supports only read operations.
  static SubscribedCollection collection(String collectionName) {
    Collection collection = Meteor.client.collectionByName(collectionName);
    return SubscribedCollection(collection, collectionName);
  }
}
