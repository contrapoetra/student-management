import 'package:flutter/material.dart';
import 'student_detail.dart';
import 'add_student.dart';
import 'student.dart';
import 'db.dart';

void main() {
  DatabaseHelper();
  runApp(const StudentApp());
}

enum SortOptions { id, name, grade }

class AppState extends ChangeNotifier {
  final List<Student> _students = [];
  String _q = '';
  SortOptions sortBy = SortOptions.id;
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

  void setSortBy(SortOptions sortBy) {
    this.sortBy = sortBy;
    switch (sortBy) {
      case SortOptions.name:
        sortByName();
        break;
      case SortOptions.grade:
        sortByGrade();
        break;
      case SortOptions.id:
        sortByID();
        break;
    }
  }

  void sortByName() {
    _students.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  void sortByGrade() {
    _students.sort((a, b) => a.grade.compareTo(b.grade));
    notifyListeners();
  }

  void sortByID() {
    _students.sort((a, b) => a.id.compareTo(b.id));
    notifyListeners();
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
  DatabaseHelper db = DatabaseHelper();
  bool initialize = true;

  void getStudents(state) async {
    // print("This method is called");
    if (initialize) {
      final students = await db.students();
      for (Student student in students) {
        state.add(student);
      }
      initialize = false;
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    final state = StateProvider.of(context);
    getStudents(state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Siswa', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                TextField(
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
                SizedBox(height: 20),
                // Row(children: [Text('Sort:'), SizedBox(width: 12), Expanded(child: SelectSort())]),
                Row(children: [Expanded(child: SelectSort())]),
                // SelectSort(),
              ],
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

class SelectSort extends StatefulWidget {
  const SelectSort({super.key});

  @override
  State<SelectSort> createState() => _SelectSortState();
}

class _SelectSortState extends State<SelectSort> {
  SortOptions selectedSort = SortOptions.id;

  @override
  Widget build(BuildContext context) {
    final state = StateProvider.of(context);
    return SegmentedButton<SortOptions>(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0)), // Adjust these values
      ),
      segments: const <ButtonSegment<SortOptions>>[
        ButtonSegment<SortOptions>(
          value: SortOptions.id,
          label: Text('Unsorted', style: TextStyle(fontSize: 12)),
          icon: Icon(Icons.sort),
        ),
        ButtonSegment<SortOptions>(
          value: SortOptions.name,
          label: Text('Nama', style: TextStyle(fontSize: 12)),
          icon: Icon(Icons.sort),
        ),
        ButtonSegment<SortOptions>(
          value: SortOptions.grade,
          label: Text('Kelas', style: TextStyle(fontSize: 12)),
          icon: Icon(Icons.sort),
        ),
      ],
      selected: <SortOptions>{selectedSort},
      onSelectionChanged: (Set<SortOptions> select) {
        setState(() {
          selectedSort = select.first;
          state.setSortBy(select.first);
        });
      },
    );
  }
}
