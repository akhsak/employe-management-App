class Employee {
  final int id;
  String firstName;
  String lastName;
  final String email;
  String phone;
  final String image;
  final String gender;
  final Address address;
  final Company company;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.image,
    required this.gender,
    required this.address,
    required this.company,
  });

  String get fullName => '$firstName $lastName';

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      gender: json['gender'],
      address: Address.fromJson(json['address']),
      company: Company.fromJson(json['company']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'image': image,
      'gender': gender,
      'address': address.toJson(),
      'company': company.toJson(),
    };
  }
}

class Address {
  final String address;
  final String city;
  final String postalCode;
  final String state;

  Address({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      city: json['city'],
      postalCode: json['postalCode'].toString(),
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'state': state,
    };
  }

  String get fullAddress => '$address, $city, $state, $postalCode';
}

class Company {
  final String name;
  final String title;
  final String department;

  Company({
    required this.name,
    required this.title,
    required this.department,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      title: json['title'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'department': department,
    };
  }
}