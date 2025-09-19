import 'package:flutter/material.dart';
import 'student_detail.dart';
import 'add_student.dart';

void main() => runApp(const StudentApp());

class Student {
  final String id;
  String name;
  String nis;
  String grade;
  String address;
  String birthdate;
  String bloodtype;
  String sex;
  String hobby;
  String father;
  String mother;
  Student({
    required this.id,
    required this.name,
    required this.nis,
    required this.grade,
    required this.address,
    required this.birthdate,
    required this.bloodtype,
    required this.sex,
    required this.hobby,
    required this.father,
    required this.mother,
  });
}

class AppState extends ChangeNotifier {
  final List<Student> _students = [];
  String _q = '';
  List<Student> get students {
    if (_q.isEmpty) return List.unmodifiable(_students);
    return _students
        .where((s) => s.name.toLowerCase().contains(_q.toLowerCase()))
        .toList();
  }

  void setQuery(String q) {
    _q = q;
    notifyListeners();
  }

  void add(Student s) {
    _students.add(s);
    notifyListeners();
  }

  void update(Student s) {
    final i = _students.indexWhere((e) => e.id == s.id);
    if (i != -1) {
      _students[i] = s;
      notifyListeners();
    }
  }

  void remove(String id) {
    _students.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Student? byId(String id) {
    try {
      return _students.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}

class StateProvider extends InheritedNotifier<AppState> {
  const StateProvider({
    super.key,
    required AppState notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StateProvider>()!.notifier!;
}

class StudentApp extends StatefulWidget {
  const StudentApp({super.key});
  @override
  State<StudentApp> createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  final appState = AppState();
  @override
  Widget build(BuildContext context) {
    return StateProvider(
      notifier: appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Manajemen Siswa',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = StateProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Siswa'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: ctrl,
              onChanged: state.setQuery,
              decoration: InputDecoration(
                hintText: 'Cari nama siswa',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: state,
        builder: (_, __) {
          final items = state.students;
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada data'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final s = items[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      s.name.isNotEmpty ? s.name[0].toUpperCase() : '?',
                    ),
                  ),
                  title: Text(s.name),
                  subtitle: Text('NIS: ${s.nis} • Kelas: ${s.grade}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentDetailPage(id: s.id),
                      ),
                    );
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStudentPage()),
          );
          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
