import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

typedef FetchNumberFun = Int32 Function();
typedef FetchNumber = int Function();

typedef CreateNumberNative = Function(
    Pointer<Utf8> firstName, Pointer<Utf8> lastName);
typedef CreateName = Function(Pointer<Utf8> firstName, Pointer<Utf8> lastName);

class FfiService {
  int fetchRandomNumber() {
    try {
      final dyLib = DynamicLibrary.open('lib/library/linux/librandomNumber.so');

      final fetchNumberPointer =
          dyLib.lookup<NativeFunction<FetchNumberFun>>('fetch_number');
      final number = fetchNumberPointer.asFunction<FetchNumber>();
      return number();
    } catch (e) {
      debugPrint("Something went wrong in fetchRandom ${e.toString()}");
    }
    return 0;
  }

  String stringReverse(String input) {
    final dylib = DynamicLibrary.open('lib/library/linux/libstringops.so');
    final inputToUtf8 = input.toNativeUtf8();
    final reverse = dylib.lookupFunction<Void Function(Pointer<Utf8>),
        void Function(Pointer<Utf8>)>('reverse');

    reverse(inputToUtf8);
    final resp = inputToUtf8.toDartString();
    malloc.free(inputToUtf8);
    return resp;
  }
}
