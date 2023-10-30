import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'generated/pcsc_lib.dart';

PcscLib pcscLibOpen() {
  if (Platform.isLinux) {
    return PcscLib(DynamicLibrary.open('libpcsclite.so.1'));
  }
  if (Platform.isWindows) {
    return PcscLibWin(DynamicLibrary.open('winscard.dll'));
  }
  throw UnsupportedError('Platform unsupported');
}

final pcscLib = pcscLibOpen();

Iterable<String> multiStringToDart(Pointer<Utf8> multiString) sync* {
  while (multiString.cast<Int8>().value != 0) {
    final length = multiString.length;
    yield multiString.toDartString(length: length);
    multiString = Pointer.fromAddress(multiString.address + length + 1);
  }
}
