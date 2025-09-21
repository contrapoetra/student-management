import 'package:flutter/material.dart';
import 'main.dart';
import 'student.dart';
import 'db.dart';

class StudentDetailPage extends StatefulWidget {
  final String id;
  const StudentDetailPage({super.key, required this.id});
  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  bool editing = false;
  final name = TextEditingController();
  final nis = TextEditingController();
  final grade = TextEditingController();
  final address = TextEditingController();
  final birthdate = TextEditingController();
  final bloodtype = TextEditingController();
  final sex = TextEditingController();
  final hobby = TextEditingController();
  final mother = TextEditingController();
  final father = TextEditingController();
  bool _initialized = false;
  DatabaseHelper db = DatabaseHelper();

  void printUpdate() async {
    print(await db.students());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final state = StateProvider.of(context);
    final s = state.byId(widget.id);
    name.text = s?.name ?? '';
    nis.text = s?.nis ?? '';
    grade.text = s?.grade ?? '';
    address.text = s?.address ?? '';
    birthdate.text = s?.birthdate ?? '';
    bloodtype.text = s?.bloodtype ?? '';
    sex.text = s?.sex ?? '';
    hobby.text = s?.hobby ?? '';
    mother.text = s?.mother ?? '';
    father.text = s?.father ?? '';
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final state = StateProvider.of(context);
    final s = state.byId(widget.id);
    if (s == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Siswa')),
        body: const Center(child: Text('Data tidak ditemukan')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Siswa'),
        actions: [
          IconButton(
            icon: Icon(editing ? Icons.check : Icons.edit),
            onPressed: () {
              if (!editing) {
                setState(() => editing = true);
                return;
              }
              final u = Student(
                id: s.id,
                name: name.text.trim(),
                nis: nis.text.trim(),
                grade: grade.text.trim(),
                address: address.text.trim(),
                birthdate: birthdate.text.trim(),
                bloodtype: bloodtype.text.trim(),
                sex: sex.text.trim(),
                hobby: hobby.text.trim(),
                father: father.text.trim(),
                mother: mother.text.trim(),
              );
              state.update(u);
              db.updateStudent(u);
              printUpdate();
              setState(() => editing = false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Hapus data?'),
                  content: const Text('Tindakan ini tidak dapat dibatalkan.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                state.remove(s.id);
                db.deleteStudent(s.id);
                printUpdate();
                if (mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Nama'),
            enabled: editing,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: nis,
            decoration: const InputDecoration(labelText: 'NIS'),
            keyboardType: TextInputType.number,
            enabled: editing,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: grade,
            decoration: const InputDecoration(labelText: 'Kelas'),
            enabled: editing,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: address,
            decoration: const InputDecoration(labelText: 'Alamat'),
            enabled: editing,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: birthdate,
            decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
            enabled: editing,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: bloodtype,
            decoration: const InputDecoration(labelText: 'Golongan Darah'),
            enabled: editing,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: sex,
            decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
            enabled: editing,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: hobby,
            decoration: const InputDecoration(labelText: 'Hobi'),
            enabled: editing,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: mother,
            decoration: const InputDecoration(labelText: 'Nama Ibu'),
            enabled: editing,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: father,
            decoration: const InputDecoration(labelText: 'Nama Ayah'),
            enabled: editing,
          ),
        ],
      ),
    );
  }
}
