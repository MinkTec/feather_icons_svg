import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

Future<void> main() async {
  await removeCacheAndCloneRepo();

  final files = await _getIconFiles();
  final file = File(p.join('lib', 'src', 'icons.dart'));
  print('[main] Generating icon classes');

  final iconClass = Class(
    (b) => b
      ..name = 'FeatherIcons'
      ..fields.addAll(
        [
          Field((b) {
            b.name = 'name';
            b.type = Reference("final String");
          }),
          Field((b) {
            b.name = 'data';
            b.type = Reference("final String");
          }),
          ...files.map((file) {
            return Field((b) {
              final name = p.basenameWithoutExtension(file.name);
              final data = file.data;
              final recase = ReCase(name);
              b.name = recase.camelCase;
              b.assignment = Code("FeatherIcons._('$name', '''$data''')");
              b.modifier = FieldModifier.constant;
              b.static = true;
              b.docs.add('/// ${recase.titleCase} icon');
            });
          }),
        ],
      )
      ..constructors.add(
        Constructor((b) {
          b.name = '_';
          b.constant = true;
          b.requiredParameters.add(Parameter((b) {
            b.name = 'name';
            b.toThis = true;
          }));
          b.requiredParameters.add(Parameter((b) {
            b.name = 'data';
            b.toThis = true;
          }));
        }),
      ),
  );

  final lib = Library((b) {
    b.body.add(iconClass);
  });

  final emitter = DartEmitter();
  final x = lib.accept(emitter);
  await file.writeAsString(
    DartFormatter().format('library feather_icons_svg; $x'),
  );
}

Future<void> removeCacheAndCloneRepo() async {
  try {
    final dir = Directory("./.cache");
    print(dir);
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  } catch (e) {
    print(e);
  }

  final res = await Process.run("git",
      ["clone", "https://github.com/feathericons/feather.git", ".cache"]);
  print(res.stderr);
  print(res.stdout);
  if (res.exitCode == 0) {
    return null;
  } else {
    throw "cloning git repo failed";
  }
}

Future<List<IconFile>> _getIconFiles() async {
  final files = await Directory(
    p.join(Directory.current.path,
        Platform.isWindows ? r'.cache\icons' : '.cache/icons'),
  ).list().toList();
  final _f = <IconFile>[];
  for (final file in files) {
    if (file is File) {
      final name = file.name;
      final data = await file.readAsString();
      _f.add(IconFile(name, data));
    }
  }
  print('[_getIconFiles] Found ${_f.length} files');
  return _f;
}

extension on FileSystemEntity {
  String get name => path.split(Platform.pathSeparator).last;
}

class IconFile {
  const IconFile(this.name, this.data);

  final String name;
  final String data;

  @override
  String toString() => 'IconFile{name: $name}';
}
