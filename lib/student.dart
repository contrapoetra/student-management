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

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'nis': nis,
      'grade': grade,
      'address': address,
      'birthdate': birthdate,
      'bloodtype': bloodtype,
      'sex': sex,
      'hobby': hobby,
      'father': father,
      'mother': mother,
    };
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, nis: $nis, grade: $grade, address: $address, birthdate: $birthdate, bloodtype: $bloodtype, sex: $sex, hobby: $hobby, father: $father, mother: $mother}';
  }
}
