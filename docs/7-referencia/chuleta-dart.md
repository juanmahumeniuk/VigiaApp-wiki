# Chuleta de Dart

Todo Dart en una página. Cada sección enlaza a la explicación completa de la [Parte 2](../2-dart/index.md).

## Variables y tipos

[:octicons-arrow-right-24: Variables, tipos y null safety](../2-dart/1-variables-y-tipos.md)

```dart
int n = 4;                  // entero
double d = -34.6;           // decimal
num x = 3;                  // int o double
String s = 'hola';          // texto
bool b = true;
DateTime ahora = DateTime.now();
Duration espera = const Duration(seconds: 15);

var inferido = 'Dart deduce el tipo';   // String, y no cambia
final unaVez = DateTime.now();          // no se reasigna
const siempre = 'vigia1234';            // se conoce al compilar
late final String despues;              // se asigna más tarde
```

## Null safety

```dart
String? tel;                 // puede ser null
tel?.length                  // null si tel es null
tel ?? 'sin teléfono'        // valor por defecto
tel ??= '0800';              // asigna solo si era null
tel!.length                  // "te juro que no es null" (explota si lo es)

if (tel != null) tel.length; // promoción: adentro es String
final t = this.tel;          // copiá campos a una local para promoverlos
if (tel case final t?) t.length;  // con patrón
```

## Operadores

[:octicons-arrow-right-24: Operadores y textos](../2-dart/2-operadores-y-strings.md)

| | |
|---|---|
| `+ - * /` | `/` siempre da `double` |
| `~/` `%` | División entera, resto |
| `== != < <= > >=` | Comparación |
| `&& \|\| !` | Y, o, no (cortocircuito) |
| `c ? a : b` | Ternario |
| `a ?? b` | `a`, o `b` si `a` es null |
| `x is T` / `x as T` | ¿Es de tipo T? / Tratalo como T |
| `++ -- += -=` | Incrementos |
| `..` | Cascada: `lista..add(1)..add(2)` |
| `...` / `...?` | Spread en colecciones |

## Textos

```dart
'Hola, $nombre'                    // interpolación
'Total: ${a + b}'                  // con expresión
'''varias
líneas'''
r'^[^\s@]+@'                       // raw: sin escapes
'a' 'b'                            // se pegan: 'ab'

s.length  s.isEmpty  s.trim()  s.toUpperCase()  s.split(' ')
s.contains('x')  s.startsWith('x')  s.replaceFirst('a', 'b')
s.padLeft(2, '0')  s.substring(0, 3)  s[0]
int.parse('42')  int.tryParse('x')  42.toString()  3.14.toStringAsFixed(1)
RegExp(r'^\d+$').hasMatch(s)
```

## Control de flujo

```dart
if (a) { … } else if (b) { … } else { … }

for (var i = 0; i < 5; i++) { … }
for (final x in lista) { … }
for (final (i, x) in lista.indexed) { … }
while (cond) { … }
break;  continue;

switch (valor) {                       // instrucción (sin break)
  case 1:
    …
  case Fallo(:final mensaje):
    …
}

final texto = switch (estado) {        // expresión
  EstadoSesion.iniciando => 'Cargando',
  EstadoSesion.sinSesion => 'Entrá',
  _ => 'Hola',                         // comodín
};
```

## Funciones

[:octicons-arrow-right-24: Funciones](../2-dart/3-funciones.md)

```dart
int sumar(int a, int b) { return a + b; }
int sumar(int a, int b) => a + b;                  // flecha

void f(int a, [int b = 0]) {}                      // posicional opcional
void g(int a, {required int b, int c = 0, int? d}) {}  // con nombre
g(1, b: 2);

final doble = (int x) => x * 2;                    // anónima
int Function(int) op = doble;                      // tipo de función
typedef Op = int Function(int);
boton(onPressed: guardar);                         // tear-off (sin paréntesis)
boton(onPressed: () => borrar(id));                // anónima
T primero<T>(List<T> l) => l[0];                   // genérica
```

## Colecciones

[:octicons-arrow-right-24: Colecciones](../2-dart/4-colecciones.md)

```dart
final l = [1, 2, 3];               // List<int>
final m = {'id': 1, 'n': 'Ana'};   // Map<String, Object>
final s = <int>{1, 2};             // Set<int>

l.add(4)  l.remove(1)  l.length  l.first  l.last  l.contains(2)  l.firstOrNull
l.sort((a, b) => a.compareTo(b))
m['id']  m['x'] ?? 0  m.containsKey('id')  m.keys  m.values  m.entries

l.map((x) => x * 2).where((x) => x > 2).take(2).toList()
l.any((x) => x > 2)  l.every((x) => x > 0)  l.fold(0, (a, x) => a + x)  l.join(', ')

[
  'fijo',
  if (cond) 'condicional',
  for (final x in xs) 'item $x',
  ...otraLista,
  ?talVezNull,                     // solo si no es null (Dart 3.8)
]
{'rol': ?rol}                      // la clave solo si rol no es null

UnmodifiableListView(lista)        // de solo lectura (dart:collection)
```

## Clases

[:octicons-arrow-right-24: Clases](../2-dart/5-clases.md)

```dart
class Vecino {
  Vecino({required this.id, required this.nombre, this.telefono});  // constructor
  const Vecino.vacio() : id = 0, nombre = '', telefono = null;      // con nombre
  factory Vecino.fromJson(Map<String, dynamic> j) =>                  // factory
      Vecino(id: j['id'] as int, nombre: j['nombre'] as String);

  final int id;
  final String nombre;
  final String? telefono;
  int _privado = 0;                    // privado al archivo

  static const maximo = 40;            // de la clase
  bool get tieneTelefono => telefono != null;   // getter
  set valor(int v) => _privado = v;             // setter
  String saludar() => 'Hola, $nombre';          // método

  @override
  String toString() => 'Vecino($nombre)';
}

// Parámetros privados con nombre (Dart 3.12):
class VM {
  VM({required this._repo});          // desde afuera: VM(repo: r)
  final Repo _repo;
}
```

## Herencia y abstracción

[:octicons-arrow-right-24: Herencia y clases abstractas](../2-dart/6-herencia-y-abstraccion.md)

```dart
abstract class VigiaApi { Future<Sesion> login(String e, String p); }
class FakeVigiaApi implements VigiaApi { @override Future<Sesion> login(…) async {…} }

abstract class ViewModel extends ChangeNotifier { … }
class LoginViewModel extends ViewModel {
  LoginViewModel(super.algo);          // pasa al padre
  @override
  void dispose() { …; super.dispose(); }
}

sealed class Resultado<T> {}           // hijas solo en este archivo
final class Ok<T> extends Resultado<T> { … }
abstract final class Rutas { static … }    // solo un espacio de nombres
class X with UnMixin {}                // mixin

extension SoloLectura<T> on List<T> {
  List<T> get soloLectura => UnmodifiableListView(this);
}
```

## Excepciones

```dart
throw ApiException('Sin conexión', codigo: 0);

try {
  await algo();
} on ApiException catch (e) {
  print(e.mensaje);
} catch (e) {
  …                                    // cualquier otra
} finally {
  …                                    // siempre
}

rethrow;                               // dentro de un catch: relanzar
```

## Enums, records y patrones

[:octicons-arrow-right-24: Enums, records y patrones](../2-dart/7-enums-records-patrones.md)

```dart
enum EstadoSesion { iniciando, sinSesion, conSesion }
EstadoSesion.values  e.name  e.index
abrir(.camara);                        // dot shorthand (Dart 3.10)

(int, String) par = (7, 'Jorge');      par.$1
({double lat, double lng}) p = (lat: 1, lng: 2);   p.lat
typedef FotoElegida = ({Uint8List bytes, String mime});

final (id, nombre) = par;              // desestructurar
final (:lat, :lng) = p;
if (r case Ok(:final valor)) …         // patrón de objeto
if (r case Fallo(mensaje: final m)) …
if (x case final y?) …                 // no-null
if (o case int n when n > 0) …         // con guarda
```

## Asincronía

[:octicons-arrow-right-24: Future](../2-dart/8-asincronia-future.md) · [:octicons-arrow-right-24: Stream y Timer](../2-dart/9-streams-y-timers.md)

```dart
Future<String> buscar() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'listo';
}
final r = await buscar();
await Future.wait([a(), b(), c()]);    // a la vez

Stream<int> contar() async* {
  for (var i = 0; i < 3; i++) yield i;
}
yield* otroStream;
final sub = stream.listen((x) {…}, onError: (e) {…}, onDone: () {…});
await sub.cancel();
await for (final x in stream) { … }
stream.map(f).where(g).take(1)

final t = Timer(const Duration(seconds: 1), () {…});
final p = Timer.periodic(const Duration(seconds: 10), (_) {…});
p.cancel();
```

## Librerías y paquetes

[:octicons-arrow-right-24: Librerías y paquetes](../2-dart/10-librerias-y-paquetes.md)

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' show max;
import '../../utils/fechas.dart';      // relativo (dentro de lib/)
export 'errores.dart' show ApiException;
```

```bash
flutter pub add http           # agregar
flutter pub add --dev x        # de desarrollo
flutter pub get                # bajar
flutter pub outdated           # ¿hay versiones nuevas?
```

`^1.6.0` = `>= 1.6.0` y `< 2.0.0`.
