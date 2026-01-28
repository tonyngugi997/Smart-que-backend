import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl =
      'https://smartque-production.up.railway.app/api';
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Login API call to: $_baseUrl/auth/login');

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('✅ Response status: ${response.statusCode}');

      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          return {
            'success': true,
            'user': data['user'],
            'message': data['message'] ?? 'Login successful',
            'token': data['token'],
          };
        } else {
          return {
            'success': false,
            'error': data['error'] ?? 'Login failed',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Empty response from server',
        };
      }
    } on http.ClientException catch (e) {
      print('🔥 ClientException: $e');
      return {
        'success': false,
        'error': 'Cannot connect to server. Please ensure backend is running.',
      };
    } catch (e) {
      print('🔥 Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred: $e',
      };
    }
  }

  // Generate OTP
  static Future<Map<String, dynamic>> generateOtp(String email) async {
    try {
      print('📱 Generate OTP API call for: $email');

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/generate-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      print('✅ OTP Response status: ${response.statusCode}');
      print('📄 OTP Response body: ${response.body}');

      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          return {
            'success': true,
            'message': data['message'] ?? 'OTP sent',
            'otp': data['otp'], // to remove later
            'expiresIn': data['expiresIn'] ?? 300,
          };
        } else {
          return {
            'success': false,
            'error': data['error'] ?? 'Failed to send OTP',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Empty response from server',
        };
      }
    } on http.ClientException catch (e) {
      print('🔥 OTP ClientException: $e');
      return {
        'success': false,
        'error': 'Cannot connect to server. Please ensure backend is running.',
      };
    } catch (e) {
      print('🔥 OTP Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred: $e',
      };
    }
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      print('🔍 Verify OTP API call for: $email, OTP: $otp');

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );

      print('✅ Verify OTP Response status: ${response.statusCode}');
      print('📄 Verify OTP Response body: ${response.body}');

      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          return {
            'success': true,
            'message': data['message'] ?? 'OTP verified',
            'verified': data['verified'] ?? false,
          };
        } else {
          return {
            'success': false,
            'error': data['error'] ?? 'Invalid OTP',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Empty response from server',
        };
      }
    } on http.ClientException catch (e) {
      print('🔥 Verify OTP ClientException: $e');
      return {
        'success': false,
        'error': 'Cannot connect to server. Please ensure backend is running.',
      };
    } catch (e) {
      print('🔥 Verify OTP Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred: $e',
      };
    }
  }

  // Register with OTP
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    String? otp,
  }) async {
    try {
      print('📝 Register API call for: $email');

      final Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'name': name,
      };

      // Add OTP
      if (otp != null && otp.isNotEmpty) {
        body['otp'] = otp;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('✅ Register Response status: ${response.statusCode}');
      print('📄 Register Response body: ${response.body}');

      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        if (response.statusCode == 201 || response.statusCode == 200) {
          return {
            'success': true,
            'user': data['user'],
            'message': data['message'] ?? 'Registration successful',
            'token': data['token'],
          };
        } else {
          return {
            'success': false,
            'error': data['error'] ?? 'Registration failed',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Empty response from server',
        };
      }
    } on http.ClientException catch (e) {
      print('🔥 Register ClientException: $e');
      return {
        'success': false,
        'error': 'Cannot connect to server. Please ensure backend is running.',
      };
    } catch (e) {
      print('🔥 Register Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred: $e',
      };
    }
  }

  // Check OTP status
  static Future<Map<String, dynamic>> checkOtpStatus(String email) async {
    try {
      print('📊 Check OTP status for: $email');

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/check-otp-status'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      print('✅ OTP Status Response status: ${response.statusCode}');

      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          return {
            'success': true,
            'hasVerifiedOtp': data['hasVerifiedOtp'] ?? false,
          };
        } else {
          return {
            'success': false,
            'error': data['error'] ?? 'Failed to check OTP status',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Empty response from server',
        };
      }
    } on http.ClientException catch (e) {
      print('🔥 OTP Status ClientException: $e');
      return {
        'success': false,
        'error': 'Cannot connect to server.',
      };
    } catch (e) {
      print('🔥 OTP Status Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred: $e',
      };
    }
  }

  // Forgot password
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      print('🔑 Forgot password API call for: $email');

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      print('✅ Forgot password Response status: ${response.statusCode}');

      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          return {
            'success': true,
            'message': data['message'] ?? 'Reset email sent',
          };
        } else {
          return {
            'success': false,
            'error': data['error'] ?? 'Failed to send reset email',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Empty response from server',
        };
      }
    } on http.ClientException catch (e) {
      print('🔥 Forgot password ClientException: $e');
      return {
        'success': false,
        'error': 'Cannot connect to server.',
      };
    } catch (e) {
      print('🔥 Forgot password Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred: $e',
      };
    }
  }

  // Test connection
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      print('🌐 Testing connection to: $_baseUrl/health');

      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Connection successful',
        };
      } else {
        return {
          'success': false,
          'error': 'Server returned ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Cannot connect to server: $e',
      };
    }
  }

  // Appointment endpoints
  static Future<Map<String, dynamic>> bookAppointment({
    required String userId,
    required String doctorName,
    required String departmentName,
    required DateTime dateTime,
    required String queueNumber,
    required double consultationFee,
    required String token,
  }) async {
    try {
      print('📚 Booking appointment with data:');
      print('  - userId: $userId');
      print('  - doctorName: $doctorName');
      print('  - departmentName: $departmentName');
      print('  - dateTime: ${dateTime.toIso8601String()}');
      print('  - queueNumber: $queueNumber');
      print('  - token: ${token.substring(0, 20)}...');

      final client = http.Client();
      try {
        final response = await client
            .post(
          Uri.parse('$_baseUrl/appointments/book'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userId': userId,
            'doctorName': doctorName,
            'departmentName': departmentName,
            'dateTime': dateTime.toIso8601String(),
            'queueNumber': queueNumber,
            'consultationFee': consultationFee,
          }),
        )
            .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException(
                'Booking request timed out after 30 seconds');
          },
        );

        print('📡 Booking response status: ${response.statusCode}');
        print('📡 Booking response body: ${response.body}');

        if (response.body.isEmpty) {
          print('❌ Empty response from server');
          return {
            'success': false,
            'error': 'Empty response from server',
          };
        }

        final data = jsonDecode(response.body);
        if (response.statusCode == 201 || response.statusCode == 200) {
          print('✅ Appointment booked successfully');
          return {
            'success': true,
            'appointment': data['appointment'],
          };
        } else {
          print('❌ Booking failed: ${data['error']}');
          return {
            'success': false,
            'error': data['error'] ?? 'Failed to book appointment',
          };
        }
      } finally {
        client.close();
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Cannot connect to server: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getUserAppointments({
    required String userId,
    required String token,
  }) async {
    try {
      print('📋 Fetching appointments for user: $userId');

      final response = await http.get(
        Uri.parse('$_baseUrl/appointments/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📋 Appointments response status: ${response.statusCode}');
      print('📋 Appointments response body: ${response.body}');

      if (response.body.isEmpty) {
        print('❌ Empty appointments response');
        return {
          'success': false,
          'appointments': [],
        };
      }

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print('✅ Appointments fetched successfully');
        return {
          'success': true,
          'appointments': data['appointments'] ?? [],
        };
      } else {
        print('❌ Failed to fetch appointments: ${data['error']}');
        return {
          'success': false,
          'error': data['error'] ?? 'Failed to fetch appointments',
          'appointments': [],
        };
      }
    } catch (e) {
      print('🔥 Error fetching appointments: $e');
      return {
        'success': false,
        'error': 'Cannot connect to server: $e',
        'appointments': [],
      };
    }
  }

  static Future<Map<String, dynamic>> cancelAppointment({
    required String appointmentId,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/appointments/cancel/$appointmentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Appointment cancelled successfully',
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Failed to cancel appointment',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Cannot connect to server: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> rescheduleAppointment({
    required String appointmentId,
    required DateTime newDateTime,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/appointments/reschedule/$appointmentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'dateTime': newDateTime.toIso8601String(),
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'appointment': data['appointment'],
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Failed to reschedule appointment',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Cannot connect to server: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getNextQueueNumber({
    required String departmentName,
    required DateTime dateTime,
    required String token,
  }) async {
    try {
      final url =
          '$_baseUrl/appointments/next-queue?department=$departmentName&date=${dateTime.toIso8601String()}';
      print('🔢 Getting queue number from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🔢 Queue response status: ${response.statusCode}');
      print('🔢 Queue response body: ${response.body}');

      if (response.body.isEmpty) {
        print('❌ Empty queue response');
        return {
          'success': false,
          'queueNumber': '1',
        };
      }

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print('✅ Got queue number: ${data['queueNumber']}');
        return {
          'success': true,
          'queueNumber': data['queueNumber'],
        };
      } else {
        print('⚠️ Queue request failed, using default');
        return {
          'success': false,
          'queueNumber': '1',
        };
      }
    } catch (e) {
      print('🔥 Queue error: $e');
      return {
        'success': false,
        'queueNumber': '1',
      };
    }
  }
}
