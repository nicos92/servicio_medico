// services/csv_export_service.dart
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'database_service.dart';

class CsvExportService {
  final DatabaseService _dbService = DatabaseService();

  Future<String> exportToCsv() async {
    final consultas = await _dbService.getAllConsultas();
    
    // Preparar los datos para CSV
    List<List<dynamic>> rows = [];
    
    // Cabecera
    rows.add(['Fecha', 'Manos y/o Dedos', 'Munecas', 'Antebrazo y/o Codo', 'Hombros', 'Cuello']);
    
    // Datos
    for (final consulta in consultas) {
      rows.add([
        consulta.fecha.toString().split(' ')[0], // Solo la fecha sin hora
        consulta.manosDedos,
        consulta.munecas,
        consulta.antebrazoCodos,
        consulta.hombros,
        consulta.cuello,
      ]);
    }
    
    // Convertir a CSV
    String csv = const ListToCsvConverter().convert(rows);
    
    // Guardar archivo
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/consultas_export.csv');
    await file.writeAsString(csv);
    
    return file.path;
  }
}