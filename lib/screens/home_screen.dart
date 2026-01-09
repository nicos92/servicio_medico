// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/counter_widget.dart';
import '../services/database_service.dart';
import '../models/consulta_model.dart';
import '../services/csv_export_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  late Consulta _currentConsulta;
  final DatabaseService _dbService = DatabaseService();
  final CsvExportService _csvService = CsvExportService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDataForSelectedDate();
  }

  Future<void> _loadDataForSelectedDate() async {
    setState(() {
      _isLoading = true;
    });
    
    final consulta = await _dbService.getConsultaByDate(_selectedDate);
    
    setState(() {
      if (consulta != null) {
        _currentConsulta = consulta;
      } else {
        _currentConsulta = Consulta.createWithNewId(fecha: _selectedDate);
      }
      _isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      await _loadDataForSelectedDate();
    }
  }

  void _updateCounter(String type, int newValue) {
    setState(() {
      switch (type) {
        case 'manos_dedos':
          _currentConsulta = _currentConsulta.copyWith(
            manosDedos: newValue,
          );
          break;
        case 'munecas':
          _currentConsulta = _currentConsulta.copyWith(
            munecas: newValue,
          );
          break;
        case 'antebrazo_codos':
          _currentConsulta = _currentConsulta.copyWith(
            antebrazoCodos: newValue,
          );
          break;
        case 'hombros':
          _currentConsulta = _currentConsulta.copyWith(
            hombros: newValue,
          );
          break;
        case 'cuello':
          _currentConsulta = _currentConsulta.copyWith(
            cuello: newValue,
          );
          break;
      }
    });
    
    // Guardar automáticamente en la base de datos
    _dbService.saveConsulta(_currentConsulta);
  }

  Future<void> _exportToCsv() async {
    try {
      final filePath = await _csvService.exportToCsv();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Datos exportados a: $filePath'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicio Médico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportToCsv,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        CounterWidget(
                          label: 'Manos y/o Dedos',
                          initialValue: _currentConsulta.manosDedos,
                          onChanged: (value) => _updateCounter('manos_dedos', value),
                        ),
                        CounterWidget(
                          label: 'Munecas',
                          initialValue: _currentConsulta.munecas,
                          onChanged: (value) => _updateCounter('munecas', value),
                        ),
                        CounterWidget(
                          label: 'Antebrazo y/o Codo',
                          initialValue: _currentConsulta.antebrazoCodos,
                          onChanged: (value) => _updateCounter('antebrazo_codos', value),
                        ),
                        CounterWidget(
                          label: 'Hombros',
                          initialValue: _currentConsulta.hombros,
                          onChanged: (value) => _updateCounter('hombros', value),
                        ),
                        CounterWidget(
                          label: 'Cuello',
                          initialValue: _currentConsulta.cuello,
                          onChanged: (value) => _updateCounter('cuello', value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}