# Glosario

Las palabras técnicas de la wiki, en orden alfabético. El enlace lleva a donde se explican con detalle.

## A

**ABI** (*Application Binary Interface*)
:   La familia de procesador de un celular (`arm64-v8a`, `armeabi-v7a`, `x86_64`). El código release se compila para cada una. [Compilar](../6-pruebas-y-entrega/7-compilar.md#que-es-eso-de-abi)

**`abstract`** (clase abstracta)
:   Una clase que no se puede instanciar y puede tener métodos sin cuerpo; existe para que otras hereden de ella o la implementen. `VigiaApi` y `ViewModel` lo son. [Herencia](../2-dart/6-herencia-y-abstraccion.md#clases-abstractas)

**`AndroidManifest.xml`**
:   La declaración de la app ante Android: permisos, enlaces que la abren, claves de los plugins. [Plugins](../3-flutter/8-plugins-y-plataformas.md#el-manifiesto)

**API** (*Application Programming Interface*)
:   Un programa que responde pedidos. En la wiki, casi siempre el servidor `vigia_api`, al que la app le habla por HTTP. [Contrato de la API](contrato-api.md)

**APK**
:   El archivo instalable de una app de Android. [Compilar](../6-pruebas-y-entrega/7-compilar.md)

**App Bundle** (`.aab`)
:   El formato que se sube a Google Play; la tienda arma un APK por celular.

**`async` / `await`**
:   `async` marca una función que devuelve un `Future`; `await` espera un `Future` sin congelar la app. [Future](../2-dart/8-asincronia-future.md)

**`async*` / `yield`**
:   Una función que devuelve un `Stream` y emite valores con `yield`. [Stream](../2-dart/9-streams-y-timers.md#async-y-yield)

## B

**`BuildContext`**
:   La posición de un widget en el árbol; sirve para buscar hacia arriba (`Theme.of(context)`). [Widgets](../3-flutter/1-todo-es-un-widget.md#buildcontext-donde-estoy-en-el-arbol)

**`build`**
:   El método que describe cómo se ve un widget. Debe ser rápido y sin efectos. [Widgets](../3-flutter/1-todo-es-un-widget.md#build-describir-no-hacer)

**BottomSheet** (hoja de abajo)
:   Un panel que sube desde abajo. [Material](../3-flutter/4-material.md#bottomsheet)

**Breakpoint**
:   Un punto donde el depurador frena la app. [Depurar](../1-preparacion/4-correr-y-depurar.md#el-depurador)

## C

**Callback**
:   Una función que se pasa para que otro la llame después (`onPressed`). [Stateless y Stateful](../3-flutter/2-stateless-y-stateful.md#avisarle-al-padre-callbacks)

**Capa**
:   Un grupo de piezas con la misma responsabilidad: interfaz (vistas y ViewModels) o datos (repositorios y servicios). [MVVM](../4-arquitectura/2-mvvm-y-capas.md)

**Caracterización** (test de)
:   Un test que fija lo que la app hace hoy, para cambiar el código sin cambiar el comportamiento. [Caracterización](../6-pruebas-y-entrega/5-tests-de-caracterizacion.md)

**Cascada** (`..`)
:   Llama un método y devuelve el objeto, no el resultado: `Sesion(…)..iniciar()`. [Clases](../2-dart/5-clases.md#la-cascada)

**`ChangeNotifier`**
:   Una clase de Flutter que avisa a sus suscriptores con `notifyListeners()`. Base de los ViewModels. [Estado compartido](../3-flutter/7-estado-compartido.md#changenotifier)

**CI** (integración continua)
:   Un servidor que corre `flutter analyze` y `flutter test` en cada cambio. [Trabajo en equipo](../6-pruebas-y-entrega/8-trabajo-en-equipo.md#integracion-continua-ci)

**Clase sellada** (`sealed`)
:   Una clase cuyas hijas están todas en el mismo archivo; el compilador conoce la lista y controla los `switch`. `Resultado`, `VigiaException`. [Patrones](../2-dart/7-enums-records-patrones.md#clases-selladas)

**Clausura** (*closure*)
:   Una función que recuerda las variables del lugar donde se creó. [Funciones](../2-dart/3-funciones.md#clausuras-closures)

**Collection if / for**
:   `if` y `for` adentro de una lista o mapa literal. [Colecciones](../2-dart/4-colecciones.md#collection-if-y-collection-for)

**Commit**
:   Una foto del código guardada en Git, con un mensaje. [Git](../6-pruebas-y-entrega/8-trabajo-en-equipo.md)

**`const`**
:   Un valor que se conoce al compilar y no cambia nunca. En widgets, evita reconstruirlos. [Variables](../2-dart/1-variables-y-tipos.md#final-y-const)

**Contrato**
:   Una clase abstracta que dice qué se puede pedir sin decir cómo (`VigiaApi`). [Dependencias](../4-arquitectura/3-direccion-de-dependencias.md#depender-de-un-contrato)

**Controlador** (`TextEditingController`)
:   El objeto que tiene el texto de un campo. Se crea en el `State` y se descarta en `dispose`. [Formularios](../3-flutter/5-formularios.md#leer-lo-que-se-escribio-texteditingcontroller)

## D

**`dart:` / `package:`**
:   Imports de la biblioteca de Dart o de un paquete. [Librerías](../2-dart/10-librerias-y-paquetes.md#tres-tipos-de-import)

**`--dart-define`**
:   Pasa un valor al compilar, que se lee con `String.fromEnvironment`. Así se elige la API. [Capítulo 1](../5-construccion/01-esqueleto.md#paso-4-la-configuracion)

**Debug / Profile / Release**
:   Los tres modos de compilación: para desarrollar, para medir, para entregar. [Compilar](../6-pruebas-y-entrega/7-compilar.md#los-tres-modos)

**Deep link** (enlace profundo)
:   Un enlace que abre la app en una pantalla: `vigiaapp://clave?token=…`. [Capítulo 7](../5-construccion/07-dependencias-y-rutas.md)

**`Dependencias`**
:   El `InheritedWidget` de VigiaApp que deja los repositorios disponibles para todo el árbol. [Inyección](../4-arquitectura/5-inyeccion-de-dependencias.md#repartir-dependencias-y-rutas)

**DevTools**
:   Herramientas para mirar la app por dentro: árbol de widgets, red, rendimiento. [Depurar](../1-preparacion/4-correr-y-depurar.md#flutter-devtools)

**`dispose`**
:   El método donde se libera lo que se abrió (timers, suscripciones, controladores). [Ciclo de vida](../3-flutter/2-stateless-y-stateful.md#ciclo-de-vida)

**Dominio** (`domain/`)
:   Los modelos de la app, en Dart puro. [MVVM](../4-arquitectura/2-mvvm-y-capas.md#modelos)

**`dynamic`**
:   Un tipo que apaga los controles; solo para el JSON, convertido enseguida con `as`. [Variables](../2-dart/1-variables-y-tipos.md#dynamic-y-object)

## E

**Elemento opcional** (`?valor`)
:   En una lista o mapa, solo se agrega si no es `null`. [Colecciones](../2-dart/4-colecciones.md#elementos-opcionales)

**`ejecutar`**
:   El método del `ViewModel` base que corre una acción, marca "ocupado" y convierte errores en `Fallo`. [ViewModel base](../4-arquitectura/6-viewmodel-base.md)

**Endpoint** (ruta)
:   Una dirección de la API con un método: `POST /auth/login`. [Contrato](contrato-api.md)

**Enum**
:   Un tipo con una lista fija de valores: `EstadoSesion`. [Enums](../2-dart/7-enums-records-patrones.md#enums)

**`Expanded`**
:   Hace que un hijo de `Row`/`Column` ocupe lo que sobra. Arregla el overflow. [Layout](../3-flutter/3-layout.md#expanded)

**Extensión** (`extension`)
:   Agrega métodos a una clase ajena: `lista.soloLectura`. [Herencia](../2-dart/6-herencia-y-abstraccion.md#extensiones)

## F

**`factory`**
:   Un constructor que devuelve un objeto y puede calcular antes: `Sesion.fromJson`. [Clases](../2-dart/5-clases.md#constructores-factory)

**`FakeVigiaApi`**
:   El servidor de mentira, con datos en memoria. [Capítulo 4](../5-construccion/04-contrato-api.md)

**`final`**
:   Una variable que no se puede reasignar. [Variables](../2-dart/1-variables-y-tipos.md#final-y-const)

**Finder**
:   En un test de widgets, lo que encuentra widgets: `find.text('…')`. [Tests de widgets](../6-pruebas-y-entrega/4-tests-de-widgets.md#finders-encontrar-cosas-en-pantalla)

**`fromJson`**
:   El constructor factory que arma un modelo desde el JSON. [Capítulo 3](../5-construccion/03-dominio.md)

**`Future<T>`**
:   Un valor que va a llegar (o un error). [Future](../2-dart/8-asincronia-future.md)

## G

**Genérico** (`<T>`)
:   Una clase o función con un tipo como parámetro: `List<String>`, `Resultado<T>`. [Clases](../2-dart/5-clases.md#genericos)

**Getter**
:   Un "campo" que se calcula al leerlo: `bool get esComite => …`. [Clases](../2-dart/5-clases.md#getters-y-setters)

**Gitflow**
:   El flujo de ramas del equipo: `master`, `develop`, `feature/…`, `release/…`. [Git](../6-pruebas-y-entrega/8-trabajo-en-equipo.md#gitflow-en-vigiaapp)

**`GlobalKey`**
:   Una key única en la app, que deja acceder al `State` desde afuera (`_form.currentState`). [Keys](../3-flutter/7-estado-compartido.md#keys)

**Golden** (test)
:   Un test que compara una captura de la pantalla con una imagen guardada. Las capturas de la wiki se generaron así.

## H

**Hot reload / hot restart**
:   Aplicar cambios sin reiniciar (conserva el estado) / reiniciando desde `main` (lo pierde). [Correr](../1-preparacion/4-correr-y-depurar.md#hot-reload-hot-restart-y-reinicio-completo)

**HTTP**
:   El protocolo con el que la app le habla al servidor: métodos `GET`, `POST`, `PUT`, `PATCH`, `DELETE` y códigos como 200, 401, 409.

**`HttpVigiaApi`**
:   La implementación de `VigiaApi` que habla con el servidor real. [API real](../6-pruebas-y-entrega/2-api-real.md)

## I

**`if case`**
:   Un `if` con un patrón: `if (resultado case Fallo(:final mensaje))`. [Patrones](../2-dart/7-enums-records-patrones.md#if-case)

**`implements`**
:   Prometer cumplir el contrato de otra clase, sin heredar su código. [Herencia](../2-dart/6-herencia-y-abstraccion.md#interfaces-implements)

**`InheritedWidget`**
:   Un widget que deja algo disponible para todos sus descendientes. [Estado compartido](../3-flutter/7-estado-compartido.md#inheritedwidget)

**`initState`**
:   El método que corre una vez al crear el `State`. [Ciclo de vida](../3-flutter/2-stateless-y-stateful.md#ciclo-de-vida)

**Inyección de dependencias**
:   Recibir lo que se usa por el constructor en vez de crearlo. [Inyección](../4-arquitectura/5-inyeccion-de-dependencias.md)

## J — L

**JSON**
:   El formato de texto con el que viajan los datos: objetos `{…}` y listas `[…]`. En Dart, `Map<String, dynamic>` y `List`. [Colecciones](../2-dart/4-colecciones.md#map)

**Key**
:   Un identificador que controla cuándo Flutter reutiliza un `State`: `ValueKey(id)`. [Keys](../3-flutter/7-estado-compartido.md#keys)

**`late`**
:   "La voy a inicializar después" (o la primera vez que se use). [Variables](../2-dart/1-variables-y-tipos.md#late-lo-voy-a-inicializar-despues)

**Linter / analizador**
:   El que marca problemas en el código sin correrlo: `flutter analyze`. [Correr](../1-preparacion/4-correr-y-depurar.md#el-analizador-errores-antes-de-correr)

**`ListenableBuilder`**
:   Un widget que escucha un `ChangeNotifier` y se redibuja cuando avisa. [Estado compartido](../3-flutter/7-estado-compartido.md#listenablebuilder)

## M

**Material 3**
:   El sistema de diseño de Google que trae Flutter. [Material](../3-flutter/4-material.md)

**Matcher**
:   En un test, una condición para `expect`: `isNull`, `hasLength(3)`, `findsOneWidget`. [Estrategia](../6-pruebas-y-entrega/1-estrategia.md#los-matchers-mas-usados)

**`MockClient`**
:   Un cliente HTTP de prueba que responde lo que el test decide. [Cliente HTTP](../6-pruebas-y-entrega/6-tests-del-cliente-http.md)

**Modelo**
:   Una clase que representa un dato de la app: `Mensaje`, `Sesion`. [MVVM](../4-arquitectura/2-mvvm-y-capas.md#modelos)

**`mounted`**
:   `true` si el widget sigue en pantalla; se revisa después de un `await`. [Ciclo de vida](../3-flutter/2-stateless-y-stateful.md#mounted-despues-de-un-await)

**MVVM** (*Model–View–ViewModel*)
:   La arquitectura de VigiaApp. [Parte 4](../4-arquitectura/index.md)

## N — O

**`Navigator`**
:   La pila de pantallas: `push` apila, `pop` desapila. [Navegación](../3-flutter/6-navegacion.md)

**`notifyListeners`**
:   Lo que llama un `ChangeNotifier` cuando cambia. [Estado compartido](../3-flutter/7-estado-compartido.md#changenotifier)

**Null safety**
:   Ninguna variable puede ser `null` salvo que su tipo tenga `?`. [Variables](../2-dart/1-variables-y-tipos.md#null-safety)

**`Ok` / `Fallo`**
:   Las dos formas de un `Resultado`. [Capítulo 2](../5-construccion/02-utilidades.md)

**Overflow**
:   Cuando algo no entra en su espacio; las rayas amarillas y negras. [Layout](../3-flutter/3-layout.md#el-error-mas-famoso)

## P

**Paquete / plugin**
:   Código reutilizable de pub.dev; un plugin además tiene código nativo. [Librerías](../2-dart/10-librerias-y-paquetes.md#paquetes)

**Parámetro con nombre**
:   Un parámetro que se pasa escribiendo su nombre: `Text('…', maxLines: 2)`. [Funciones](../2-dart/3-funciones.md#parametros-con-nombre)

**Patrón**
:   Describe la forma de un dato para preguntar y desestructurar: `Fallo(:final mensaje)`. [Patrones](../2-dart/7-enums-records-patrones.md#patrones)

**PATH**
:   La lista de carpetas donde la terminal busca los comandos. [Instalar](../1-preparacion/2-instalacion.md#paso-2-flutter)

**Permiso**
:   Algo que la app tiene que declarar (y a veces pedir al usuario): ubicación, cámara. [Plugins](../3-flutter/8-plugins-y-plataformas.md#permisos-en-tiempo-de-ejecucion)

**Promoción de tipos**
:   Cuando Dart sabe que una variable nullable no es `null` y la trata como no nullable. [Variables](../2-dart/1-variables-y-tipos.md#promocion)

**Pull Request** (PR)
:   Un pedido de unir una rama, con revisión. [Git](../6-pruebas-y-entrega/8-trabajo-en-equipo.md#pull-requests)

**`pubspec.yaml`**
:   La ficha del proyecto: nombre, versión de Dart y paquetes. [Crear el proyecto](../1-preparacion/3-crear-el-proyecto.md#pubspecyaml-la-ficha)

**`pump` / `pumpAndSettle`**
:   En un test de widgets, dibujar un cuadro / dibujar hasta que no quede nada pendiente. [Tests de widgets](../6-pruebas-y-entrega/4-tests-de-widgets.md)

## R

**Raíz de composición**
:   El lugar donde se crean y conectan todos los objetos: `main.dart`. [Inyección](../4-arquitectura/5-inyeccion-de-dependencias.md#la-raiz-de-composicion)

**Record**
:   Varios valores juntos sin escribir una clase: `(bytes: …, mime: …)`. [Records](../2-dart/7-enums-records-patrones.md#records)

**Repositorio**
:   La fuente de verdad de un área de datos. [Repositorios](../4-arquitectura/2-mvvm-y-capas.md#repositorios)

**`Resultado`**
:   Lo que devuelve una acción de un ViewModel: `Ok(valor)` o `Fallo(mensaje)`. [ViewModel base](../4-arquitectura/6-viewmodel-base.md#ejecutar-y-resultado)

**`Rutas`**
:   La clase que arma el ViewModel de cada pantalla y la abre. [Navegación](../3-flutter/6-navegacion.md#rutas-toda-la-navegacion-en-un-lugar)

## S

**`Scaffold`**
:   El esqueleto de una pantalla Material: `appBar`, `body`, `drawer`… [Material](../3-flutter/4-material.md#la-estructura-de-una-pantalla-scaffold)

**Servicio**
:   Una clase que habla con algo de afuera (servidor, GPS, cámara). [MVVM](../4-arquitectura/2-mvvm-y-capas.md#servicios)

**`setState`**
:   Cambia datos del `State` y pide redibujar. [Stateless y Stateful](../3-flutter/2-stateless-y-stateful.md#setstate)

**SnackBar**
:   Un mensaje corto abajo que se va solo. [Material](../3-flutter/4-material.md#snackbar)

**Sondeo** (*polling*)
:   Preguntar al servidor cada tanto si hay novedades. [Timer](../2-dart/9-streams-y-timers.md#el-sondeo-de-vigiaapp)

**`StatefulWidget` / `StatelessWidget`**
:   Widget con estado propio (y ciclo de vida) / sin estado. [Stateless y Stateful](../3-flutter/2-stateless-y-stateful.md)

**`Stream<T>`**
:   Muchos valores que llegan con el tiempo. [Stream](../2-dart/9-streams-y-timers.md)

**`switch` expresión**
:   Un `switch` que devuelve un valor, con `=>` en cada caso. [Patrones](../2-dart/7-enums-records-patrones.md#switch-como-expresion)

## T — Z

**Tear-off**
:   Pasar un método sin llamarlo: `onPause: _viewModel.pausar`. [Funciones](../2-dart/3-funciones.md#tear-offs-pasar-un-metodo-sin-envolverlo)

**`Timer`**
:   Hacer algo dentro de un rato (`Timer`) o cada tanto (`Timer.periodic`). [Timer](../2-dart/9-streams-y-timers.md#timer-mas-tarde-o-cada-tanto)

**Token**
:   El texto que prueba que hay una sesión; va en el encabezado `Authorization`. Vale 24 horas.

**`typedef`**
:   Un nombre para un tipo: `typedef CargarFoto = Future<Uint8List> Function(int);`. [Funciones](../2-dart/3-funciones.md#typedef-un-nombre-para-un-tipo-de-funcion)

**Vista**
:   Los widgets de una pantalla: dibujan y avisan. [MVVM](../4-arquitectura/2-mvvm-y-capas.md#la-vista)

**`VigiaApi`**
:   El contrato de todo lo que se le puede pedir al servidor. [Capítulo 4](../5-construccion/04-contrato-api.md)

**`VigiaException`**
:   La familia de errores de la app: `ApiException`, `UbicacionException`, `FotoException`. [Errores](../4-arquitectura/7-errores.md#la-familia-de-errores)

**ViewModel**
:   El estado de una pantalla y sus acciones; un `ChangeNotifier`. [MVVM](../4-arquitectura/2-mvvm-y-capas.md#el-viewmodel)

**Widget**
:   Una descripción inmutable de un pedazo de interfaz. [Widgets](../3-flutter/1-todo-es-un-widget.md)

**YAML**
:   El formato del `pubspec.yaml`: texto con sangría de espacios.
