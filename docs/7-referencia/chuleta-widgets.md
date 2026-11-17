# Chuleta de widgets

Los widgets que usa VigiaApp, agrupados por para qué sirven, con su forma mínima. Los detalles, en la [Parte 3](../3-flutter/index.md).

## Estructura de la app y de las pantallas

```dart
MaterialApp(
  title: 'VigiaApp',
  theme: ThemeData(colorSchemeSeed: Colors.indigo),
  navigatorKey: _navegador,              // navegar desde afuera
  home: const Inicio(),
)

Scaffold(
  appBar: AppBar(title: const Text('Título'), actions: [IconButton(…)]),
  drawer: const Drawer(child: …),
  body: …,
  floatingActionButton: FloatingActionButton(onPressed: …, child: const Icon(Icons.add)),
  bottomNavigationBar: NavigationBar(selectedIndex: 0, onDestinationSelected: …, destinations: […]),
)

SafeArea(child: …)                       // evita la barra de estado y la "isla"
```

## Widgets propios

```dart
class Saludo extends StatelessWidget {
  const Saludo({required this.nombre, super.key});
  final String nombre;
  @override
  Widget build(BuildContext context) => Text('Hola, $nombre');
}

class Contador extends StatefulWidget {
  const Contador({super.key});
  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  int _n = 0;
  @override
  void initState() { super.initState(); … }
  @override
  void dispose() { …; super.dispose(); }
  @override
  Widget build(BuildContext context) =>
      TextButton(onPressed: () => setState(() => _n++), child: Text('$_n'));
}
```

## Layout

[:octicons-arrow-right-24: Layout](../3-flutter/3-layout.md)

| Widget | Para qué | Forma mínima |
|---|---|---|
| `Column` / `Row` | Hijos uno debajo / al lado del otro | `Column(children: [a, b])` |
| `Expanded` | Ocupar lo que sobra en una `Row`/`Column` | `Expanded(child: Text(largo))` |
| `Padding` | Margen alrededor | `Padding(padding: const EdgeInsets.all(16), child: …)` |
| `SizedBox` | Espacio fijo / tamaño fijo | `const SizedBox(height: 16)` |
| `Center` / `Align` | Centrar / alinear | `Center(child: …)` |
| `Container` | Caja con color, tamaño, borde | `Container(color: …, width: 80, child: …)` |
| `Stack` + `Positioned` | Encimar | `Stack(children: [fondo, Positioned(right: 8, bottom: 8, child: …)])` |
| `Wrap` | Como `Row`, pero pasa a la línea siguiente | `Wrap(spacing: 8, children: chips)` |
| `ListView` | Lista desplazable (pocos hijos) | `ListView(children: […])` |
| `ListView.builder` | Lista larga, construye a demanda | `ListView.builder(itemCount: n, itemBuilder: (c, i) => …)` |
| `SingleChildScrollView` | Hacer desplazable un hijo | `SingleChildScrollView(child: Column(…))` |
| `RefreshIndicator` | Tirar para actualizar | `RefreshIndicator(onRefresh: cargar, child: ListView(…))` |

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,     // eje principal
  crossAxisAlignment: CrossAxisAlignment.start,     // eje cruzado
  mainAxisSize: MainAxisSize.min,                   // ocupar lo justo
  spacing: 8,                                       // espacio entre hijos
  children: […],
)
```

## Textos e íconos

```dart
Text('Hola', style: Theme.of(context).textTheme.titleMedium,
    maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)
Icon(Icons.campaign_outlined, size: 32, color: Theme.of(context).colorScheme.primary)
CircleAvatar(child: Text('MR'))
Badge(label: const Text('5'), child: const Icon(Icons.campaign_outlined))
const Divider()
```

## Botones

[:octicons-arrow-right-24: Botones](../3-flutter/4-material.md#botones)

```dart
FilledButton(onPressed: ocupado ? null : guardar, child: const Text('Guardar'))  // null = deshabilitado
FilledButton.icon(onPressed: …, icon: const Icon(Icons.send), label: const Text('Publicar'))
FilledButton.tonal(onPressed: …, child: …)
OutlinedButton(onPressed: …, child: …)
TextButton(onPressed: …, child: …)
IconButton(onPressed: …, tooltip: 'Enviar', icon: const Icon(Icons.send))
FloatingActionButton(onPressed: …, child: const Icon(Icons.add))
```

## Listas y tarjetas

```dart
ListTile(leading: const Icon(Icons.email_outlined), title: Text(t), subtitle: Text(s),
    trailing: const Icon(Icons.chevron_right), onTap: …)
SwitchListTile(title: const Text('Activo'), value: activo, onChanged: (v) => …)
CheckboxListTile(title: Text(nombre), value: elegido, onChanged: (v) => …)
Card(child: Padding(padding: const EdgeInsets.all(16), child: …))
Dismissible(key: ValueKey(id), onDismissed: (_) => …, child: …)
```

## Elegir

```dart
FilterChip(label: const Text('Obras'), selected: sel, onSelected: (_) => …)
ChoiceChip(label: const Text('Todas'), selected: sel, onSelected: (_) => …)
SegmentedButton<String>(
  segments: const [ButtonSegment(value: 'a', label: Text('A')), ButtonSegment(value: 'b', label: Text('B'))],
  selected: {valor},
  onSelectionChanged: (s) => elegir(s.first),
)
DropdownButtonFormField<String>(initialValue: v, items: […DropdownMenuItem(value: …, child: …)], onChanged: …)
```

## Formularios

[:octicons-arrow-right-24: Formularios](../3-flutter/5-formularios.md)

```dart
final _form = GlobalKey<FormState>();
final _email = TextEditingController();        // dispose() en el State

Form(
  key: _form,
  child: TextFormField(
    controller: _email,
    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    obscureText: false,
    validator: validarEmail,                   // null = válido
  ),
)

if (_form.currentState!.validate()) { … }
```

## Avisos y diálogos

[:octicons-arrow-right-24: Avisos](../3-flutter/4-material.md#avisos-que-aparecen-encima)

```dart
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listo')));

final ok = await showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('¿Borrar?'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
      FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Borrar')),
    ],
  ),
);

final origen = await showModalBottomSheet<OrigenFoto>(context: context, builder: (context) => …);
final fecha = await showDatePicker(context: context, firstDate: …, lastDate: …);
```

## Navegación

[:octicons-arrow-right-24: Navegación](../3-flutter/6-navegacion.md)

```dart
Navigator.push(context, MaterialPageRoute(builder: (context) => const Perfil()));
final r = await Navigator.push<Publicacion>(context, MaterialPageRoute(builder: …));
Navigator.pop(context);
Navigator.pop(context, valor);
Navigator.of(context).popUntil((ruta) => ruta.isFirst);
Rutas.perfil(context);                       // en VigiaApp
```

## Estado compartido

[:octicons-arrow-right-24: Estado compartido](../3-flutter/7-estado-compartido.md)

```dart
class Modelo extends ChangeNotifier {
  int _n = 0;
  int get n => _n;
  void sumar() { _n++; notifyListeners(); }
}

ListenableBuilder(listenable: modelo, builder: (context, _) => Text('${modelo.n}'))

class Dependencias extends InheritedWidget {
  const Dependencias({required this.sesion, required super.child, super.key});
  final SesionRepository sesion;
  static Dependencias of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<Dependencias>()!;
  @override
  bool updateShouldNotify(Dependencias old) => false;
}
```

## Cargando, error y vacío

```dart
const Center(child: CircularProgressIndicator())
const Cargando()                                         // VigiaApp
ErrorConReintento(mensaje: 'No se pudo…', onReintentar: cargar)   // VigiaApp
TextoError(mensaje)                                      // VigiaApp
```

## Del contexto

```dart
Theme.of(context).colorScheme.primary       // colores
Theme.of(context).textTheme.titleLarge      // tipografía
MediaQuery.sizeOf(context).width            // tamaño de pantalla
MediaQuery.viewInsetsOf(context).bottom     // alto del teclado
context.mounted / mounted                   // ¿sigue en pantalla? (después de await)
```
