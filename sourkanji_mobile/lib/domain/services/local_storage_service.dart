import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sourkanji_mobile/domain/auth/loggable.dart';
import 'package:sourkanji_mobile/shared/utils/app_logger.dart';

class LocalStorageService implements Disposable {
  static LocalStorageService get to => Modular.get();
  static Future<LocalStorageService> get toAsync => Modular.getAsync();

  // Boxes
  final String authBoxName = 'auth';
  late Box authBox;

  Future<List<int>> clearBoxes() async {
    return Future.wait([
      authBox.clear(),
    ]);
  }

  // ⎧⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎫
  // ⎨ Auth Box                                                             ⎬
  // ⎩⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎭

  LoggableAuthenticated? getLoggableAuthenticated() {
    if (authBox.isEmpty) return null;
    final Map<String, dynamic>? data = authBox.getAt(0);
    if (data == null) return null;
    return LoggableAuthenticated.fromJson(data);
  }

  Future<void> saveLoggableAuthenticated(
      LoggableAuthenticated authenticated) async {
    return authBox.putAt(0, authenticated.toJson());
  }

  Future<void> clearLoggableAuthenticated() async {
    return authBox.putAt(0, null);
  }

  // ⎧⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎫
  // ⎨ Lifecycle                                                            ⎬
  // ⎩⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎭

  Future<LocalStorageService> init() async {
    await Hive.initFlutter();
    final boxes = await Future.wait([
      Hive.openBox(authBoxName),
    ]);
    authBox = boxes[0];

    // ignore: no_runtimetype_tostring
    AppLogger.v('$runtimeType ready!');

    return this;
  }

  @override
  void dispose() {
    Hive.close();
  }
}
