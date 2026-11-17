// lib/data/services/api/fake_vigia_api.dart
//
// Implementación de VigiaApi con datos en memoria: se usa cuando la app se
// compila sin --dart-define=API_URL (demo sin servidor) y en los tests.
//
// Los datos se guardan como Map, igual que el JSON que va a devolver la API
// real, y se convierten con los mismos fromJson. Así, cuando cambiemos a
// HttpVigiaApi, los modelos ya están probados con el formato correcto.

import 'dart:math';
import 'dart:typed_data';

import '../../../domain/models/alerta.dart';
import '../../../domain/models/comite.dart';
import '../../../domain/models/mensaje.dart';
import '../../../domain/models/noticia.dart';
import '../../../domain/models/publicacion.dart';
import '../../../domain/models/rondin.dart';
import '../../../domain/models/sesion.dart';
import '../../../utils/fechas.dart';
import 'vigia_api.dart';

class FakeVigiaApi implements VigiaApi {
  FakeVigiaApi({
    this.demora = const Duration(milliseconds: 400),
    this.simularError = false,
    bool conAlertaVecino = false,
  }) {
    _armarDatos();
    if (conAlertaVecino) _alertaDeJorge();
  }

  /// Cuánto "tarda" el servidor en responder.
  final Duration demora;

  /// Cambiala a true para probar el estado de error de las pantallas.
  bool simularError;

  @override
  String? token;

  @override
  void Function()? onSesionVencida;

  /// Contraseña de todos los vecinos de ejemplo (igual que el seed de la API).
  static const clave = 'vigia1234';

  // Los mismos vecinos que `npm run db:seed` en vigia_api.
  final List<Map<String, dynamic>> _vecinos = [];
  final List<Map<String, dynamic>> _manzanas = [
    for (var i = 1; i <= 5; i++) {'id': i, 'nombre': 'Manzana $i'},
  ];
  final Map<int, String> _claves = {};

  final List<Map<String, dynamic>> _publicaciones = [];
  final List<Map<String, dynamic>> _turnos = [];
  final Map<int, Map<String, dynamic>> _alertas = {};
  final Map<int, List<Map<String, dynamic>>> _respuestas = {};
  final List<Map<String, dynamic>> _mensajes = [];
  final Map<int, Uint8List> _fotos = {};

  // Simula la espera de la red y, si corresponde, un error de conexión.
  Future<void> _esperar() async {
    await Future.delayed(demora);
    if (simularError) throw ApiException('Sin conexión');
  }

  Never _error(String mensaje, int codigo) =>
      throw ApiException(mensaje, codigo: codigo);

  /// El vecino de la sesión: el token del fake es `fake-<id>`.
  Map<String, dynamic> get _yo {
    final id = int.tryParse(token?.replaceFirst('fake-', '') ?? '');
    for (final v in _vecinos) {
      if (v['id'] == id) return v;
    }
    token = null;
    onSesionVencida?.call();
    _error('Sesión vencida. Volvé a iniciar sesión.', 401);
  }

  Sesion _abrirSesion(Map<String, dynamic> vecino) {
    token = 'fake-${vecino['id']}';
    return Sesion.fromJson({
      'token': token,
      'expira_en': DateTime.now()
          .add(const Duration(hours: 24))
          .toUtc()
          .toIso8601String(),
      'vecino': {
        'id': vecino['id'],
        'nombre': '${vecino['nombre']} ${vecino['apellido']}',
        'manzana': vecino['manzana'],
        'rol': vecino['rol'],
      },
    });
  }

  // ---- Sesión ----

  @override
  Future<Sesion> login(String email, String password) async {
    await _esperar();
    for (final v in _vecinos) {
      if (v['email'] == email.trim().toLowerCase() &&
          _claves[v['id']] == password) {
        return _abrirSesion(v);
      }
    }
    _error('Email o contraseña incorrectos.', 401);
  }

  /// Cualquier token de 64 hex vale como la invitación de Sofía Paz (la
  /// vecina del seed con la invitación pendiente).
  @override
  Future<Sesion> elegirClave(String tokenEnlace, String password) async {
    await _esperar();
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(tokenEnlace)) {
      _error('El enlace no es válido.', 400);
    }
    if (password.length < 8) {
      _error('password debe tener entre 8 y 128 caracteres.', 400);
    }
    final sofia = _vecinos.firstWhere((v) => v['id'] == 9);
    _claves[9] = password;
    sofia['invitacion_pendiente'] = false;
    return _abrirSesion(sofia);
  }

  @override
  Future<void> recuperarClave(String email) => _esperar();

  @override
  Future<void> logout() async {
    await _esperar();
    token = null;
  }

  @override
  Future<Perfil> obtenerPerfil() async {
    await _esperar();
    return Perfil.fromJson(_yo);
  }

  @override
  Future<void> cambiarClave(String actual, String nueva) async {
    await _esperar();
    final id = _yo['id'] as int;
    if (_claves[id] != actual) {
      _error('La contraseña actual no es correcta.', 400);
    }
    if (nueva.length < 8) {
      _error('nueva debe tener entre 8 y 128 caracteres.', 400);
    }
    _claves[id] = nueva;
  }

  // ---- Inicio, noticias, rondines y alertas ----

  @override
  Future<EstadoBarrio> obtenerEstadoBarrio() async {
    await _esperar();
    return EstadoBarrio.fromJson({'vecinos_en_linea': 38, 'vecinos_total': 40});
  }

  @override
  Future<List<Publicacion>> obtenerActividad() async {
    await _esperar();
    return [
      for (final p in _publicaciones)
        if (p['tipo'] == 'actividad') Publicacion.fromJson(p),
    ];
  }

  @override
  Future<List<Noticia>> obtenerNoticias({String? etiqueta}) async {
    await _esperar();
    return [
      for (final p in _publicaciones)
        if (p['tipo'] == 'noticia' &&
            (etiqueta == null || p['etiqueta'] == etiqueta))
          Noticia.fromJson(p),
    ];
  }

  Map<String, dynamic> _publicacion(int id) {
    for (final p in _publicaciones) {
      if (p['id'] == id) return p;
    }
    _error('La publicación no existe.', 404);
  }

  @override
  Future<Publicacion> publicar({
    required String tipo,
    required String titulo,
    String? cuerpo,
    String? etiqueta,
    String? firma,
    int? fotoId,
  }) async {
    await _esperar();
    final yo = _yo;
    if ((tipo == 'noticia' || firma != null) && yo['rol'] != 'comite') {
      _error(
        'Solo el comité publica noticias o firma en nombre de otros.',
        403,
      );
    }
    if (tipo == 'noticia' && etiqueta == null) {
      _error('Las noticias llevan etiqueta.', 400);
    }
    if (tipo == 'actividad' && etiqueta != null) {
      _error('Las actividades no llevan etiqueta.', 400);
    }
    final nombre = yo['nombre'] as String;
    final apellido = yo['apellido'] as String;
    final publicacion = {
      'id': _publicaciones.fold<int>(0, (m, p) => max(m, p['id'] as int)) + 1,
      'tipo': tipo,
      'titulo': titulo.trim(),
      'cuerpo': cuerpo,
      'etiqueta': etiqueta,
      'foto_id': fotoId,
      'autor': firma ?? '$nombre ${apellido[0]}.',
      'iniciales': '${nombre[0]}${apellido[0]}',
      'autor_id': yo['id'],
      'creado_en': DateTime.now().toUtc().toIso8601String(),
      'respuestas': 0,
    };
    _publicaciones.insert(0, publicacion); // la más nueva primero
    return Publicacion.fromJson(publicacion);
  }

  @override
  Future<Publicacion> obtenerPublicacion(int id) async {
    await _esperar();
    return Publicacion.fromJson(_publicacion(id));
  }

  @override
  Future<void> borrarPublicacion(int id) async {
    await _esperar();
    final publicacion = _publicacion(id);
    if (publicacion['autor_id'] != _yo['id'] && _yo['rol'] != 'comite') {
      _error('Solo el autor o el comité pueden borrarla.', 403);
    }
    _publicaciones.remove(publicacion);
    _respuestas.remove(id);
  }

  @override
  Future<List<RespuestaPublicacion>> obtenerRespuestas(
    int publicacionId,
  ) async {
    await _esperar();
    _publicacion(publicacionId);
    return [
      for (final r in _respuestas[publicacionId] ?? const [])
        RespuestaPublicacion.fromJson(r),
    ];
  }

  @override
  Future<RespuestaPublicacion> responder(
    int publicacionId,
    String texto,
  ) async {
    await _esperar();
    final publicacion = _publicacion(publicacionId);
    final yo = _yo;
    final nombre = yo['nombre'] as String;
    final apellido = yo['apellido'] as String;
    final lista = _respuestas.putIfAbsent(publicacionId, () => []);
    final respuesta = {
      'id': lista.length + 1,
      'texto': texto.trim(),
      'autor': '$nombre ${apellido[0]}.',
      'iniciales': '${nombre[0]}${apellido[0]}',
      'autor_id': yo['id'],
      'creado_en': DateTime.now().toUtc().toIso8601String(),
    };
    lista.add(respuesta);
    publicacion['respuestas'] = lista.length;
    return RespuestaPublicacion.fromJson(respuesta);
  }

  @override
  Future<List<Mensaje>> obtenerMensajes({int? despues}) async {
    await _esperar();
    _yo;
    final lista = [
      for (final m in _mensajes)
        if (despues == null || (m['id'] as int) > despues) m,
    ];
    return [
      for (final m in lista.skip(max(0, lista.length - 50)))
        Mensaje.fromJson(m),
    ];
  }

  @override
  Future<Mensaje> enviarMensaje({String? texto, int? fotoId}) async {
    await _esperar();
    final yo = _yo;
    if ((texto == null || texto.trim().isEmpty) && fotoId == null) {
      _error('El mensaje necesita texto o una foto.', 400);
    }
    final nombre = yo['nombre'] as String;
    final apellido = yo['apellido'] as String;
    final mensaje = {
      'id': _mensajes.length + 1,
      'texto': texto?.trim(),
      'foto_id': fotoId,
      'autor': '$nombre ${apellido[0]}.',
      'iniciales': '${nombre[0]}${apellido[0]}',
      'autor_id': yo['id'],
      'creado_en': DateTime.now().toUtc().toIso8601String(),
    };
    _mensajes.add(mensaje);
    return Mensaje.fromJson(mensaje);
  }

  Map<String, dynamic> _vecino(int id) => _vecinos.firstWhere(
    (v) => v['id'] == id,
    orElse: () => _error('Alguno de los vecinos no existe.', 400),
  );

  // Un turno guardado → el JSON de GET /rondines/semana, visto por "yo".
  TurnoRondin _turnoJson(Map<String, dynamic> turno) {
    final yo = _yo['id'];
    final asignados = turno['asignados'] as List<Map<String, dynamic>>;
    return TurnoRondin.fromJson({
      ...turno,
      'pareja': [
        for (final a in asignados)
          '${_vecino(a['vecino_id'])['nombre']} '
              '${(_vecino(a['vecino_id'])['apellido'] as String)[0]}.',
      ],
      'mi_estado': asignados
          .where((a) => a['vecino_id'] == yo)
          .map((a) => a['estado'])
          .firstOrNull,
    });
  }

  Map<String, dynamic> _turno(int id) => _turnos.firstWhere(
    (t) => t['id'] == id,
    orElse: () => _error('El turno no existe.', 404),
  );

  void _soloComite() {
    if (_yo['rol'] != 'comite') _error('Solo el comité puede hacer esto.', 403);
  }

  @override
  Future<List<TurnoRondin>> obtenerSemanaRondin({DateTime? desde}) async {
    await _esperar();
    final inicio = fechaApi(desde ?? lunesDe(DateTime.now()));
    final fin = fechaApi(DateTime.parse(inicio).add(const Duration(days: 6)));
    final semana = [
      for (final t in _turnos)
        if ((t['fecha'] as String).compareTo(inicio) >= 0 &&
            (t['fecha'] as String).compareTo(fin) <= 0)
          t,
    ]..sort((a, b) => (a['fecha'] as String).compareTo(b['fecha'] as String));
    return [for (final t in semana) _turnoJson(t)];
  }

  @override
  Future<TurnoRondin> responderAsistencia(int turnoId, bool presente) async {
    await _esperar();
    final turno = _turno(turnoId);
    final asignados = turno['asignados'] as List<Map<String, dynamic>>;
    final mia = asignados.firstWhere(
      (a) => a['vecino_id'] == _yo['id'],
      orElse: () => _error('No estás asignado a ese turno.', 404),
    );
    mia['estado'] = presente ? 'confirmado' : 'ausente';
    mia['respondido_en'] = DateTime.now().toUtc().toIso8601String();
    return _turnoJson(turno);
  }

  // ---- Comité ----

  @override
  Future<List<Manzana>> obtenerManzanas() async {
    await _esperar();
    return [for (final m in _manzanas) Manzana.fromJson(m)];
  }

  @override
  Future<Manzana> crearManzana(String nombre) async {
    await _esperar();
    _soloComite();
    final manzana = {'id': _manzanas.length + 1, 'nombre': nombre.trim()};
    _manzanas.add(manzana);
    return Manzana.fromJson(manzana);
  }

  @override
  Future<List<VecinoAdmin>> obtenerVecinos() async {
    await _esperar();
    _soloComite();
    final lista = [..._vecinos]
      ..sort((a, b) => (a['apellido'] as String).compareTo(b['apellido']));
    return [for (final v in lista) VecinoAdmin.fromJson(v)];
  }

  @override
  Future<VecinoAdmin> crearVecino({
    required String nombre,
    required String apellido,
    required String email,
    String? telefono,
    required int manzanaId,
    String rol = 'vecino',
  }) async {
    await _esperar();
    _soloComite();
    final mail = email.trim().toLowerCase();
    if (_vecinos.any((v) => v['email'] == mail)) {
      _error('Ya hay un vecino con ese email o teléfono.', 409);
    }
    final manzana = _manzanas.firstWhere(
      (m) => m['id'] == manzanaId,
      orElse: () => _error('La manzana no existe.', 400),
    );
    final vecino = {
      'id': _vecinos.fold<int>(0, (m, v) => max(m, v['id'] as int)) + 1,
      'nombre': nombre.trim(),
      'apellido': apellido.trim(),
      'email': mail,
      'telefono': telefono,
      'manzana_id': manzanaId,
      'manzana': manzana['nombre'],
      'rol': rol,
      'activo': true,
      'invitacion_pendiente': true,
    };
    _vecinos.add(vecino);
    return VecinoAdmin.fromJson({...vecino, 'invitacion_enviada': true});
  }

  @override
  Future<VecinoAdmin> editarVecino(int id, Map<String, dynamic> cambios) async {
    await _esperar();
    _soloComite();
    if (id == _yo['id'] &&
        (cambios.containsKey('rol') || cambios.containsKey('activo'))) {
      _error('No podés cambiar tu propio rol ni desactivarte.', 409);
    }
    final vecino = _vecinos.firstWhere(
      (v) => v['id'] == id,
      orElse: () => _error('El vecino no existe.', 404),
    );
    vecino.addAll(cambios);
    if (cambios.containsKey('manzana_id')) {
      vecino['manzana'] = _manzanas.firstWhere(
        (m) => m['id'] == cambios['manzana_id'],
      )['nombre'];
    }
    return VecinoAdmin.fromJson(vecino);
  }

  @override
  Future<void> reenviarInvitacion(int vecinoId) async {
    await _esperar();
    _soloComite();
    final vecino = _vecinos.firstWhere(
      (v) => v['id'] == vecinoId,
      orElse: () => _error('El vecino no existe.', 404),
    );
    if (vecino['invitacion_pendiente'] != true) {
      _error(
        'El vecino ya activó su cuenta; puede usar "olvidé mi contraseña".',
        409,
      );
    }
  }

  @override
  Future<TurnoRondin> crearTurno({
    required DateTime fecha,
    required String ruta,
    String? horaInicio,
    String? horaFin,
    List<int> vecinoIds = const [],
  }) async {
    await _esperar();
    _soloComite();
    if (_turnos.any((t) => t['fecha'] == fechaApi(fecha))) {
      _error('Ya hay un turno en esa fecha.', 409);
    }
    vecinoIds.forEach(_vecino); // 400 si alguno no existe
    final turno = {
      'id': _turnos.fold<int>(0, (m, t) => max(m, t['id'] as int)) + 1,
      'fecha': fechaApi(fecha),
      'hora_inicio': horaInicio ?? '22:00',
      'hora_fin': horaFin ?? '02:00',
      'ruta': ruta.trim(),
      'asignados': <Map<String, dynamic>>[
        for (final id in vecinoIds.toSet())
          {'vecino_id': id, 'estado': 'pendiente', 'respondido_en': null},
      ],
    };
    _turnos.add(turno);
    return _turnoJson(turno);
  }

  List<Asignacion> _asignaciones(Map<String, dynamic> turno) => [
    for (final a in turno['asignados'] as List<Map<String, dynamic>>)
      Asignacion.fromJson({
        ...a,
        'nombre':
            '${_vecino(a['vecino_id'])['nombre']} '
            '${_vecino(a['vecino_id'])['apellido']}',
      }),
  ];

  @override
  Future<List<Asignacion>> obtenerAsignaciones(int turnoId) async {
    await _esperar();
    _soloComite();
    return _asignaciones(_turno(turnoId));
  }

  @override
  Future<List<Asignacion>> reasignarTurno(
    int turnoId,
    List<int> vecinoIds,
  ) async {
    await _esperar();
    _soloComite();
    final turno = _turno(turnoId);
    vecinoIds.forEach(_vecino);
    final antes = turno['asignados'] as List<Map<String, dynamic>>;
    // Quien sigue asignado conserva su respuesta; los nuevos, pendientes.
    turno['asignados'] = <Map<String, dynamic>>[
      for (final id in vecinoIds.toSet())
        antes.firstWhere(
          (a) => a['vecino_id'] == id,
          orElse: () => {
            'vecino_id': id,
            'estado': 'pendiente',
            'respondido_en': null,
          },
        ),
    ];
    return _asignaciones(turno);
  }

  @override
  Future<void> borrarTurno(int turnoId) async {
    await _esperar();
    _soloComite();
    _turnos.remove(_turno(turnoId));
  }

  @override
  Future<int> crearAlerta({double? lat, double? lng}) async {
    await _esperar();
    final yo = _yo;
    // Como la API: si ya tengo una alerta activa, devuelve esa.
    for (final a in _alertas.values) {
      if (a['estado'] == 'activa' && a['vecino']['id'] == yo['id']) {
        return a['id'] as int;
      }
    }
    final id = _alertas.length + 1;
    _alertas[id] = {
      'id': id,
      'estado': 'activa',
      'central_911_confirmada': false,
      'vecinos_avisados': 0,
      'en_camino': 0,
      'mi_respuesta': null, // la disparé yo: no me avisan a mí
      'lat': lat,
      'lng': lng,
      'creada_en': DateTime.now().toUtc().toIso8601String(),
      'vecino': _resumenVecino(yo),
    };
    return id;
  }

  Map<String, dynamic> _resumenVecino(Map<String, dynamic> v) => {
    'id': v['id'],
    'nombre': '${v['nombre']} ${v['apellido']}',
    'manzana': v['manzana'],
  };

  Map<String, dynamic> _alerta(int alertaId) =>
      _alertas[alertaId] ?? _error('La alerta no existe.', 404);

  @override
  Future<EstadoAlerta> obtenerAlerta(int alertaId) async {
    await _esperar();
    final alerta = _alerta(alertaId);
    // En las alertas propias, cada consulta "avanza" el despacho: la central
    // confirma y los vecinos en línea (38) van recibiendo el aviso de a tandas.
    if (alerta['estado'] == 'activa' && alerta['mi_respuesta'] == null) {
      final avisados = alerta['vecinos_avisados'] as int;
      final enCamino = alerta['en_camino'] as int;
      alerta['central_911_confirmada'] = true;
      alerta['vecinos_avisados'] = min(avisados + 13, 38);
      if (avisados > 0) alerta['en_camino'] = min(enCamino + 1, 4);
    }
    return EstadoAlerta.fromJson(alerta);
  }

  @override
  Future<List<EstadoAlerta>> obtenerAlertas({String estado = 'activa'}) async {
    await _esperar();
    return [
      for (final a in _alertas.values.toList().reversed)
        if (a['estado'] == estado) EstadoAlerta.fromJson(a),
    ];
  }

  // Como la API: la víctima actualiza la de la alerta; un vecino en camino,
  // la suya (en la lista que dibuja el mapa).
  @override
  Future<void> enviarUbicacion(int alertaId, double lat, double lng) async {
    await _esperar();
    final alerta = _alerta(alertaId);
    final yo = _yo;
    if (alerta['estado'] != 'activa') {
      _error('La alerta ya no está activa.', 409);
    }
    final ahora = DateTime.now().toUtc().toIso8601String();
    if (alerta['vecino']['id'] == yo['id']) {
      alerta['lat'] = lat;
      alerta['lng'] = lng;
      alerta['ubicacion_en'] = ahora;
      return;
    }
    if (alerta['mi_respuesta'] != 'en_camino') {
      _error(
        'Solo comparten ubicación quien disparó la alerta y los vecinos '
        'que van en camino.',
        403,
      );
    }
    _sacarUbicacion(alerta, yo['id'] as int);
    _ubicaciones(alerta).add({
      'vecino_id': yo['id'],
      'nombre': '${yo['nombre']} ${yo['apellido']}',
      'lat': lat,
      'lng': lng,
      'actualizado_en': ahora,
    });
  }

  List<Map<String, dynamic>> _ubicaciones(Map<String, dynamic> alerta) =>
      (alerta['en_camino_ubicaciones'] ??= <Map<String, dynamic>>[])
          as List<Map<String, dynamic>>;

  void _sacarUbicacion(Map<String, dynamic> alerta, int vecinoId) =>
      _ubicaciones(alerta).removeWhere((u) => u['vecino_id'] == vecinoId);

  @override
  Future<EstadoAlerta> adjuntarFotoAlerta(int alertaId, int fotoId) async {
    await _esperar();
    final alerta = _alerta(alertaId);
    if (alerta['vecino']['id'] != _yo['id']) {
      _error('Solo quien disparó la alerta puede agregarle una foto.', 403);
    }
    if (alerta['estado'] != 'activa') {
      _error('La alerta ya no está activa.', 409);
    }
    alerta['foto_id'] = fotoId;
    return EstadoAlerta.fromJson(alerta);
  }

  @override
  Future<int> subirFoto(Uint8List bytes, String mime) async {
    await _esperar();
    _yo;
    if (bytes.isEmpty) _error('La foto tiene que ser JPEG, PNG o WEBP.', 400);
    final id = _fotos.length + 1;
    _fotos[id] = bytes;
    return id;
  }

  @override
  Future<Uint8List> obtenerFoto(int fotoId) async {
    await _esperar();
    return _fotos[fotoId] ?? _error('La foto no existe.', 404);
  }

  // Cierra una alerta activa (cancelar o resolver); si ya estaba cerrada, 409.
  void _cerrar(Map<String, dynamic> alerta, String estado) {
    if (alerta['estado'] != 'activa') {
      _error('La alerta ya no está activa.', 409);
    }
    alerta['estado'] = estado;
    _ubicaciones(alerta).clear(); // privacidad: igual que la API
  }

  @override
  Future<void> cancelarAlerta(int alertaId) async {
    await _esperar();
    final alerta = _alerta(alertaId);
    if (alerta['vecino']['id'] != _yo['id']) {
      _error('La alerta no existe.', 404);
    }
    _cerrar(alerta, 'cancelada');
  }

  @override
  Future<void> resolverAlerta(int alertaId) async {
    await _esperar();
    final alerta = _alerta(alertaId);
    if (alerta['vecino']['id'] != _yo['id'] && _yo['rol'] != 'comite') {
      _error(
        'Solo quien disparó la alerta o el comité pueden resolverla.',
        403,
      );
    }
    _cerrar(alerta, 'resuelta');
  }

  @override
  Future<EstadoAlerta> marcarEnCamino(
    int alertaId, {
    bool enCamino = true,
  }) async {
    await _esperar();
    final alerta = _alerta(alertaId);
    final antes = alerta['mi_respuesta'];
    if (antes == null) _error('No fuiste avisado de esta alerta.', 404);
    if (alerta['estado'] != 'activa') {
      _error('La alerta ya no está activa.', 409);
    }
    final ahora = enCamino ? 'en_camino' : 'notificado';
    if (!enCamino) _sacarUbicacion(alerta, _yo['id'] as int);
    if (antes != ahora) {
      alerta['mi_respuesta'] = ahora;
      alerta['en_camino'] = (alerta['en_camino'] as int) + (enCamino ? 1 : -1);
    }
    return EstadoAlerta.fromJson(alerta);
  }

  @override
  Future<EstadoAlerta> confirmar911(int alertaId) async {
    await _esperar();
    if (_yo['rol'] != 'comite') {
      _error('Solo el comité puede hacer esto.', 403);
    }
    final alerta = _alerta(alertaId);
    if (alerta['estado'] != 'activa') {
      _error('La alerta ya no está activa.', 409);
    }
    alerta['central_911_confirmada'] = true;
    return EstadoAlerta.fromJson(alerta);
  }

  /// Una alerta activa de Jorge López, para ver el banner del Inicio sin
  /// servidor: `FakeVigiaApi(conAlertaVecino: true)`.
  void _alertaDeJorge() {
    final jorge = _vecinos.firstWhere((v) => v['id'] == 3);
    _alertas[1] = {
      'id': 1,
      'estado': 'activa',
      'central_911_confirmada': false,
      'vecinos_avisados': 8,
      'en_camino': 1,
      'mi_respuesta': 'notificado',
      // Una esquina del barrio de ejemplo, y Ana que ya va en camino.
      'lat': -34.6037,
      'lng': -58.3816,
      'ubicacion_en': DateTime.now().toUtc().toIso8601String(),
      'en_camino_ubicaciones': <Map<String, dynamic>>[
        {
          'vecino_id': 4,
          'nombre': 'Ana Castro',
          'lat': -34.6049,
          'lng': -58.3834,
          'actualizado_en': DateTime.now().toUtc().toIso8601String(),
        },
      ],
      'creada_en': DateTime.now()
          .subtract(const Duration(minutes: 2))
          .toUtc()
          .toIso8601String(),
      'vecino': _resumenVecino(jorge),
    };
  }

  // ---- Datos de ejemplo (los mismos del prototipo Diseño.html) ----

  void _armarDatos() {
    const personas = [
      ['María', 'Ríos', 'maria', 4, 'vigia'],
      ['Tomás', 'Rodríguez', 'tomas', 4, 'vigia'],
      ['Jorge', 'López', 'jorge', 2, 'vecino'],
      ['Ana', 'Castro', 'ana', 2, 'vecino'],
      ['Laura', 'Gómez', 'laura', 1, 'comite'],
      ['Pedro', 'Sosa', 'pedro', 3, 'vecino'],
      ['Lucía', 'Fernández', 'lucia', 3, 'vigia'],
      ['Diego', 'Martínez', 'diego', 5, 'vecino'],
      ['Sofía', 'Paz', 'sofia', 5, 'vecino'], // invitación pendiente
    ];
    for (final (i, p) in personas.indexed) {
      final id = i + 1;
      _vecinos.add({
        'id': id,
        'nombre': p[0],
        'apellido': p[1],
        'email': '${p[2]}@vigia.test',
        'telefono': '+54911000000${id.toString().padLeft(2, '0')}',
        'manzana_id': p[3],
        'manzana': 'Manzana ${p[3]}',
        'rol': p[4],
        'activo': true,
        'invitacion_pendiente': id == 9,
      });
      if (id != 9) _claves[id] = clave;
    }

    final ahora = DateTime.now();
    String hace(Duration d) => ahora.subtract(d).toUtc().toIso8601String();

    _mensajes.addAll([
      {
        'id': 1,
        'texto': '¿Alguien vio un perro marrón suelto por la plaza?',
        'autor': 'Ana C.',
        'iniciales': 'AC',
        'autor_id': 4,
        'creado_en': hace(const Duration(minutes: 40)),
      },
      {
        'id': 2,
        'texto': 'Sí, estaba en la esquina de Morelos hace un rato.',
        'autor': 'Jorge L.',
        'iniciales': 'JL',
        'autor_id': 3,
        'creado_en': hace(const Duration(minutes: 32)),
      },
    ]);

    _publicaciones.addAll([
      {
        'id': 1,
        'tipo': 'actividad',
        'titulo': 'Cierre de la calle Juárez por obra',
        'autor': 'Jorge L.',
        'iniciales': 'JL',
        'creado_en': hace(const Duration(minutes: 25)),
        'respuestas': 0,
      },
      {
        'id': 2,
        'tipo': 'actividad',
        'titulo': 'Camioneta gris estacionada desde ayer',
        'autor': 'Ana C.',
        'iniciales': 'AC',
        'creado_en': hace(const Duration(hours: 1)),
        'respuestas': 2,
      },
      {
        'id': 3,
        'tipo': 'actividad',
        'titulo': 'Rondín de anoche sin incidentes',
        'autor': 'Pedro S.',
        'iniciales': 'PS',
        'creado_en': hace(const Duration(hours: 9)),
        'respuestas': 0,
      },
      {
        'id': 4,
        'tipo': 'actividad',
        'titulo': 'Nueva luminaria instalada en el parque',
        'autor': 'Comité',
        'iniciales': 'RM',
        'creado_en': hace(const Duration(hours: 30)),
        'respuestas': 0,
      },
      {
        'id': 5,
        'tipo': 'noticia',
        'etiqueta': 'seguridad',
        'titulo': 'Reunión con el cuadrante policial el jueves 19 h',
        'autor': 'Comité',
        'creado_en': hace(const Duration(hours: 2)),
      },
      {
        'id': 6,
        'tipo': 'noticia',
        'etiqueta': 'obras',
        'titulo': 'Repavimentación de calle Morelos hasta el viernes',
        'autor': 'Municipio',
        'creado_en': hace(const Duration(hours: 5)),
      },
      {
        'id': 7,
        'tipo': 'noticia',
        'etiqueta': 'alumbrado',
        'titulo': 'Se repararon las 3 luminarias del Parque',
        'autor': 'Comité',
        'creado_en': hace(const Duration(hours: 26)),
      },
      {
        'id': 8,
        'tipo': 'noticia',
        'etiqueta': 'convivencia',
        'titulo': 'Recordatorio: horario de sacar la basura 20 a 22 h',
        'autor': 'Comité',
        'creado_en': hace(const Duration(hours: 28)),
      },
      {
        'id': 9,
        'tipo': 'noticia',
        'etiqueta': 'seguridad',
        'titulo': 'Nuevo número directo del cuadrante 41',
        'autor': 'Comité',
        'creado_en': hace(const Duration(days: 3)),
      },
    ]);

    // Autor de cada publicación de ejemplo (id del vecino) y las respuestas
    // de la camioneta gris.
    const autores = {
      'Jorge L.': 3,
      'Ana C.': 4,
      'Pedro S.': 6,
      'Comité': 5,
      'Municipio': 5,
    };
    for (final p in _publicaciones) {
      p['autor_id'] = autores[p['autor']];
      p['respuestas'] ??= 0;
    }
    _respuestas[2] = [
      {
        'id': 1,
        'texto': 'La vi también, tiene patente de otra provincia.',
        'autor': 'Pedro S.',
        'iniciales': 'PS',
        'autor_id': 6,
        'creado_en': hace(const Duration(minutes: 50)),
      },
      {
        'id': 2,
        'texto': 'Ya avisé al cuadrante.',
        'autor': 'Laura G.',
        'iniciales': 'LG',
        'autor_id': 5,
        'creado_en': hace(const Duration(minutes: 40)),
      },
    ];

    // Los 7 turnos de esta semana (lunes a domingo), de a dos vecinos
    // (ids). El de hoy es de María, así la demo siempre tiene "mi turno".
    const parejas = [
      [3, 4],
      [6, 7],
      [2, 8],
      [3, 4],
      [7, 8],
      [6, 2],
      [4, 8],
    ];
    final lunes = lunesDe(ahora);
    for (var i = 0; i < 7; i++) {
      final esHoy = i == ahora.weekday - 1;
      final pareja = esHoy ? [1, parejas[i][1]] : parejas[i];
      _turnos.add({
        'id': 100 + i,
        'fecha': fechaApi(lunes.add(Duration(days: i))),
        'hora_inicio': '22:00',
        'hora_fin': '02:00',
        'ruta': 'Morelos → Juárez → Parque → Morelos',
        'asignados': <Map<String, dynamic>>[
          for (final id in pareja)
            {'vecino_id': id, 'estado': 'pendiente', 'respondido_en': null},
        ],
      });
    }
  }
}
