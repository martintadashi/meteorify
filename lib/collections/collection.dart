import 'dart:async';

import 'package:logger/logger.dart';

import '../meteor/subscribed_collection.dart';
import '../models/document.dart';

class Collection<T extends MeteorDocument> {
  Collection({String name, Function constructor}) {
    try {
      this.collectionName = name;
      this.collection = SubscribedCollection.collection(name);

      this.collection.addUpdateListener(
          (String collectionName, String message, String docId, Map map) {
        if (collectionName != name) {
          return;
        }

        try {
          switch (message) {
            case 'create':
            case 'update':
              map['_id'] = docId;
              T doc = constructor(map);
              if (doc is T) {
                this.addDocument(doc);
              }
              break;
            case 'remove':
              this.removeDocument(docId);
              break;
            default:
              break;
          }
        } catch (exception) {
          final log =
              Logger(printer: PrettyPrinter(colors: false, methodCount: 10));
          log.e("Collection<$name> error ${exception.toString()}");
        }
      });
    } catch (exception) {
      final log = Logger(printer: PrettyPrinter(colors: false, methodCount: 2));
      log.e("Collection constructor <$name> error ${exception.toString()}");
    }
  }

  final StreamController<int> _streamController =
      StreamController<int>.broadcast();

  String collectionName;
  SubscribedCollection collection;

  List<T> _documents = List<T>();

  List<T> find({bool where(T element), int sorted(T a, T b)}) {
    var docs = _documents;
    if (sorted != null) {
      docs.sort(sorted);
    }
    if (where != null) {
      docs = docs.where(where).toList();
    }

    return docs;
  }

  T findOne({bool where(T element), int sorted(T a, T b)}) {
    try {
      return find(where: where, sorted: sorted)[0];
    } catch (err) {
      return null;
    }
  }

  void addDocument(T doc) {
    final index = _documents.indexWhere((e) {
      return e.id == doc.id;
    });
    if (index != -1) {
      _documents[index] = doc;
    } else {
      _documents.add(doc);
    }
    final log = Logger(printer: PrettyPrinter(colors: false, methodCount: 0));
    log.d("Collection<${this.collectionName}> updated ${_documents.length}");

    this._streamController.sink.add(0);
  }

  void removeDocument(String id) {
    int index = _documents.indexWhere((doc) => doc.id == id);
    if (index != -1) {
      _documents.removeAt(index);
      final log = Logger(printer: PrettyPrinter(colors: false, methodCount: 0));
      log.d(
          "Collection<${this.collectionName}> removed with id $id ${_documents.length}");
      this._streamController.sink.add(0);
    }
  }

  Stream<int> get stream {
    return this._streamController.stream;
  }

  void autorun(Function(int) listener) {
    this.stream.listen(listener);
    this._streamController.sink.add(0);
  }
}
