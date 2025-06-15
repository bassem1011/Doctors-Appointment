import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final AuthService _authService = AuthService();
  String? _loggedInUsername;

  // Dummy data for doctors
  final List<Map<String, String>> _doctors = [
    {
      'name': 'Dr. Joseph Church',
      'specialty': 'Dental Speciality',
      'hospital': 'St Bartholomew\'s Hospital',
      'location': 'London',
      'fees': '\$300',
      'time': '10:30am-02:30am',
      'imageUrl': 'https://via.placeholder.com/150/0000FF/FFFFFF?text=JC',
    },
    {
      'name': 'Dr. David Bryant',
      'specialty': 'Heart Speciality',
      'hospital': 'St Thomas Hospital',
      'location': 'London',
      'fees': '\$450',
      'time': '10:30am-02:30am',
      'imageUrl': 'https://via.placeholder.com/150/FF0000/FFFFFF?text=DB',
    },
    {
      'name': 'Dr. Robert Adler',
      'specialty': 'Dental Speciality',
      'hospital': 'St Bartholomew\'s Hospital',
      'location': 'London',
      'fees': '\$350',
      'time': '11:00am-03:00pm',
      'imageUrl': 'https://via.placeholder.com/150/00FF00/FFFFFF?text=RA',
    },
    {
      'name': 'Dr. Emily White',
      'specialty': 'Brain Speciality',
      'hospital': 'Royal London Hospital',
      'location': 'London',
      'fees': '\$500',
      'time': '09:00am-01:00pm',
      'imageUrl': 'https://via.placeholder.com/150/FFFF00/000000?text=EW',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await _authService.getUsername();
    setState(() {
      _loggedInUsername = username;
    });
  }

  void _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF4A148C), // Deep purple
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding:
                    const EdgeInsets.only(top: 60.0, left: 25.0, right: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${_loggedInUsername ?? 'User'}!', // Display logged-in username
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Let\'s find your doctor',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout,
                              color: Colors.white, size: 30),
                          onPressed: _logout, // Logout button
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for doctors...',
                          hintStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.search, color: Colors.white70),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final doctor = _doctors[index];
                  return _DoctorCard(
                    name: doctor['name']!,
                    specialty: doctor['specialty']!,
                    hospital: doctor['hospital']!,
                    location: doctor['location']!,
                    fees: doctor['fees']!,
                    time: doctor['time']!,
                    imageUrl: doctor['imageUrl']!,
                  );
                },
                childCount: _doctors.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String hospital;
  final String location;
  final String fees;
  final String time;
  final String imageUrl;

  const _DoctorCard({
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.location,
    required this.fees,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(imageUrl),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    specialty,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    hospital,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 5),
                      Text(
                        location,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 15),
                      Icon(Icons.attach_money,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 5),
                      Text(
                        fees,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Optional: Add a favorite icon or arrow if needed
            // IconButton(
            //   icon: Icon(Icons.favorite_border),
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
