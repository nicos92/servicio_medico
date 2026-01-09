// services/database_service.dart
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/consulta_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;
  StoreRef<String, Map<String, dynamic>> get _store => stringMapStoreFactory.store('consultas');

  Future<Database> get database async {
    if (_database == null) {
      await _initDatabase();
    }
    return _database!;
  }

  Future<void> _initDatabase() async {
    final dir = await getApplicationSupportDirectory();
    final dbPath = join(dir.path, 'consultas.db');
    _database = await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<void> saveConsulta(Consulta consulta) async {
    final db = await database;
    await _store.record(consulta.id).put(db, consulta.toJson());
  }

  Future<List<Consulta>> getAllConsultas() async {
    final db = await database;
    final records = await _store.find(db);
    return records.map((snapshot) => Consulta.fromJson(snapshot.value)).toList();
  }

  Future<Consulta?> getConsultaByDate(DateTime fecha) async {
    final db = await database;
    final dateString = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}'; // Formato YYYY-MM-DD
    
    final finder = Finder(
      filter: Filter.custom((record) {
        final recordFecha = DateTime.parse(record['fecha'] as String);
        final recordDateString = '${recordFecha.year}-${recordFecha.month.toString().padLeft(2, '0')}-${recordFecha.day.toString().padLeft(2, '0')}';
        return recordDateString == dateString;
      })
    );
    
    final records = await _store.find(db, finder: finder);
    return records.isNotEmpty ? Consulta.fromJson(records.first.value) : null;
  }

  Future<void> deleteConsulta(String id) async {
    final db = await database;
    await _store.record(id).delete(db);
  }
  
  Future<void> close() async {
    await _database?.close();
  }
}