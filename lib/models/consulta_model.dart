// models/consulta_model.dart
import 'package:uuid/uuid.dart';

class Consulta {
  final String id;
  final DateTime fecha;
  final int manosDedos;
  final int munecas;
  final int antebrazoCodos;
  final int hombros;
  final int cuello;

  Consulta({
    required this.id,
    required this.fecha,
    this.manosDedos = 0,
    this.munecas = 0,
    this.antebrazoCodos = 0,
    this.hombros = 0,
    this.cuello = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fecha': fecha.toIso8601String(),
      'consultas': [
        {
          'manos_dedos': manosDedos,
          'munecas': munecas,
          'antebrazo_codos': antebrazoCodos,
          'hombros': hombros,
          'cuello': cuello,
        }
      ]
    };
  }

  factory Consulta.fromJson(Map<String, dynamic> json) {
    final consultas = json['consultas'][0];
    return Consulta(
      id: json['_id'],
      fecha: DateTime.parse(json['fecha']),
      manosDedos: consultas['manos_dedos'],
      munecas: consultas['munecas'],
      antebrazoCodos: consultas['antebrazo_codos'],
      hombros: consultas['hombros'],
      cuello: consultas['cuello'],
    );
  }

  // Método para crear una nueva instancia con valores actualizados
  Consulta copyWith({
    String? id,
    DateTime? fecha,
    int? manosDedos,
    int? munecas,
    int? antebrazoCodos,
    int? hombros,
    int? cuello,
  }) {
    return Consulta(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      manosDedos: manosDedos ?? this.manosDedos,
      munecas: munecas ?? this.munecas,
      antebrazoCodos: antebrazoCodos ?? this.antebrazoCodos,
      hombros: hombros ?? this.hombros,
      cuello: cuello ?? this.cuello,
    );
  }

  // Método para crear una nueva instancia con ID generado automáticamente
  static Consulta createWithNewId({
    required DateTime fecha,
    int manosDedos = 0,
    int munecas = 0,
    int antebrazoCodos = 0,
    int hombros = 0,
    int cuello = 0,
  }) {
    var uuid = const Uuid();
    return Consulta(
      id: uuid.v4(),
      fecha: fecha,
      manosDedos: manosDedos,
      munecas: munecas,
      antebrazoCodos: antebrazoCodos,
      hombros: hombros,
      cuello: cuello,
    );
  }
}