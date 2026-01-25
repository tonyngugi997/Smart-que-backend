#!/bin/bash
echo "=== Testing Complete OTP System ==="

echo "1. Checking backend..."
curl -s http://localhost:5000/api/health | python3 -m json.tool

echo -e "\n2. Testing OTP generation..."
curl -X POST http://localhost:5000/api/auth/generate-otp \
  -H "Content-Type: application/json" \
  -d '{"email":"otptest@example.com"}' \
  -s | python3 -m json.tool

echo -e "\n3. Testing registration (should fail without OTP verification)..."
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"otptest@example.com","password":"123456","name":"OTP Test"}' \
  -s | python3 -m json.tool

echo -e "\n=== Test Complete ==="
