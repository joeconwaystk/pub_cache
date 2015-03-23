// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library pub_cache_test;

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:pub_cache/pub_cache.dart';
import 'package:unittest/unittest.dart';

void main() {
  // We need at least one activated application for our test suite.
  if (new PubCache().getGlobalApplications().isEmpty) {
    ProcessResult result = Process.runSync('pub', ['global', 'activate', 'dart_coveralls']);
    print(result.exitCode);
    print(result.stdout);
    print(result.stderr);
  }

  defineTests();
}

void defineTests() {
  final String cacheDirName = Platform.isWindows ? 'Cache' : 'pub-cache';

  group('PubCache', () {
    test('getSystemCacheLocation', () {
      Directory cacheDir = PubCache.getSystemCacheLocation();
      expect(cacheDir, isNotNull);
      expect(path.basename(cacheDir.path), contains(cacheDirName));
    });

    test('PubCache', () {
      PubCache cache = new PubCache();
      expect(cache, isNotNull);
      expect(cache.location, isNotNull);
      expect(path.basename(cache.location.path), contains(cacheDirName));
    });

    test('getBinaries', () {
      PubCache cache = new PubCache();
      expect(cache.getBinaries(), isNotNull);
    });

    test('getGlobalApplications', () {
      PubCache cache = new PubCache();
      expect(cache.getGlobalApplications(), isNotEmpty);
    });

    test('getPackageRefs', () {
      PubCache cache = new PubCache();
      expect(cache.getPackageRefs(), isNotEmpty);
    });

    test('getCachedPackages', () {
      PubCache cache = new PubCache();
      expect(cache.getCachedPackages(), isNotEmpty);
    });

    test('getAllPackageVersions', () {
      PubCache cache = new PubCache();
      expect(cache.getAllPackageVersions('path'), isNotEmpty);
    });
  });

  group('Application', () {
    PubCache cache;
    Application app;

    setUp(() {
      cache = new PubCache();
      app = cache.getGlobalApplications().first;
    });

    test('name', () {
      expect(app.name, isNotEmpty);
    });

    test('version', () {
      expect(app.version, isNotNull);
    });

    test('getDefiningPackageRef', () {
      expect(app.getDefiningPackageRef().name, app.name);
    });

    test('getPackageRefs', () {
      expect(app.getPackageRefs(), isNotEmpty);
    });

    test('toString', () {
      expect(app.toString(), isNotEmpty);
    });
  });

  group('PackageRef', () {
    PubCache cache;
    Application app;
    PackageRef ref;

    setUp(() {
      cache = new PubCache();
      app = cache.getGlobalApplications().first;
      ref = app.getPackageRefs().first;
    });

    test('name', () {
      expect(ref.name, isNotEmpty);
    });

    test('==', () {
      PackageRef ref0 = app.getPackageRefs()[0];
      PackageRef ref1 = app.getPackageRefs()[1];

      expect(ref0, equals(ref0));
      expect(ref0, isNot(equals(ref1)));
    });

    test('resolve', () {
      expect(ref.resolve(), isNotNull);
    });

    test('toString', () {
      expect(ref.toString(), isNotEmpty);
    });
  });

  group('Package', () {
    test('toString', () {
      PubCache cache = new PubCache();
      Package p = cache.getPackageRefs().first.resolve();
      expect(p, isNotNull);
      expect(p.toString(), isNotEmpty);
    });
  });
}
