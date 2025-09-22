import 'package:flutter/material.dart';
import 'main.dart';
import 'student.dart';
import 'dart:math';
import 'db.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});
  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final f = GlobalKey<FormState>();
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
  DatabaseHelper db = DatabaseHelper();

  void printUpdate() async {
    print(await db.students());
  }

  @override
  Widget build(BuildContext context) {
    final state = StateProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Siswa')),
      body: Form(
        key: f,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Nama'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: nis,
              decoration: const InputDecoration(labelText: 'NIS'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Wajib diisi';
                } else {
                  bool exists = state.students.any((s) => s.nis == v);
                  return exists ? 'NIS sudah digunakan' : null;
                }
              },
              onChanged: (v) {
                nis.text = v.replaceAll(RegExp(r'\D'), '');
                print(nis.text);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: grade,
              decoration: const InputDecoration(labelText: 'Kelas'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: address,
              decoration: const InputDecoration(labelText: 'Alamat'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: birthdate,
              decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  birthdate.text = '${date.day}/${date.month}/${date.year}';
                }
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: bloodtype,
              decoration: const InputDecoration(labelText: 'Golongan Darah'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: sex,
              decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: hobby,
              decoration: const InputDecoration(labelText: 'Hobi'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: mother,
              decoration: const InputDecoration(labelText: 'Nama Ibu'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: father,
              decoration: const InputDecoration(labelText: 'Nama Ayah'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                if (!f.currentState!.validate()) return;
                final id =
                    '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(999)}';
                Student student = Student(
                  id: id,
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
                state.add(student);
                db.insertStudent(student);
                printUpdate();
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
