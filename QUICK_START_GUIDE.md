# SmartQue Appointments System - Quick Start Guide

## ✅ What's Been Implemented (Frontend)

### New Features
1. **Complete Appointment Management Screen**
   - View all your appointments
   - Filter by status (Upcoming, Completed, Cancelled)
   - Reschedule appointments with date/time picker
   - Cancel appointments with confirmation
   - Real-time countdown timer for upcoming appointments

2. **Automatic Queue Management**
   - Queue numbers assigned automatically based on department and date
   - Prevents queue number duplicates
   - Later bookings get higher queue numbers

3. **Persistent Storage**
   - All appointments saved to database
   - User-specific appointment retrieval
   - Appointment history tracking

4. **Advanced UI/UX**
   - Gradient backgrounds with glassmorphic design
   - Color-coded status badges
   - Smooth animations and transitions
   - Responsive layout
   - Professional typography with Google Fonts

### Files Modified/Created
- ✅ `lib/models/appointment_model.dart` - Enhanced with userId and timestamp
- ✅ `lib/providers/appointment_provider.dart` - Complete API integration
- ✅ `lib/services/api_service.dart` - 5 new appointment endpoints
- ✅ `lib/screens/appointments_screen.dart` - NEW: Full appointment management UI
- ✅ `lib/screens/home_screen.dart` - Updated with user context
- ✅ `lib/screens/booking_flow.dart` - Updated to use new API
- ✅ `lib/widgets/advanced_sidebar.dart` - Updated navigation
- ✅ `lib/routes.dart` - Added appointments route

## 📋 Backend Setup Required

You need to implement these API endpoints on your Node.js/Express backend:

### Required Endpoints

**1. POST /api/appointments/book**
- Books a new appointment
- Auto-assigns queue number
- Requires: userId, doctorName, departmentName, dateTime, consultationFee

**2. GET /api/appointments/user/:userId**
- Fetches all appointments for a user
- Returns list of appointments with all details

**3. POST /api/appointments/cancel/:appointmentId**
- Cancels an appointment
- Updates status to "cancelled"

**4. POST /api/appointments/reschedule/:appointmentId**
- Reschedules appointment to new date/time
- Recalculates queue number if needed

**5. GET /api/appointments/next-queue**
- Gets next available queue number
- Query params: department, date
- Returns: nextQueueNumber

### Database Schema (MongoDB Example)
```javascript
{
  _id: ObjectId,
  userId: ObjectId,
  doctorName: String,
  departmentName: String,
  dateTime: Date,
  queueNumber: Number,
  status: String, // 'upcoming', 'completed', 'cancelled'
  consultationFee: Number,
  createdAt: Date,
  updatedAt: Date
}
```

## 🚀 Setup Instructions

### Step 1: Backend Implementation
1. Copy code from `BACKEND_EXAMPLE_CODE.js`
2. Create Appointment model in your database
3. Implement the 5 endpoints mentioned above
4. Add proper authentication middleware
5. Create database indexes as specified

### Step 2: Update API Endpoint
In `lib/services/api_service.dart`, update the `_baseUrl`:
```dart
static const String _baseUrl = 'http://YOUR_BACKEND_URL:PORT/api';
```

### Step 3: Test the Flow
1. Open the app
2. Login with valid credentials
3. Book an appointment through the booking flow
4. Click "Appointments" in sidebar
5. Verify appointment appears with queue number

## 🔧 Environment Configuration

### Required Environment Variables (Backend)
```
JWT_SECRET=your_secret_key
MONGODB_URI=mongodb://localhost:27017/smartque
PORT=5000 (or your port)
```

### API Configuration (Frontend)
- Update `API_BASE_URL` in api_service.dart
- Ensure CORS is enabled on backend
- All endpoints require Bearer token authentication

## 🎯 User Flow

### Booking Appointment
1. User navigates to department
2. Selects doctor and time
3. Confirms booking
4. System sends to API with queue number from `/next-queue`
5. Appointment saved to database

### Managing Appointments
1. User clicks "Appointments" in sidebar
2. Sees all their appointments in tabs
3. Can reschedule with date/time picker
4. Can cancel with confirmation dialog
5. Sees countdown timer for upcoming appointments

## 🔐 Security Checklist

- ✅ Bearer token required for all endpoints
- ✅ User context validation (userId matches auth user)
- ✅ Users only see their own appointments
- ✅ Proper error handling (401, 403, 404, 400)
- ⚠️ TODO: Implement rate limiting on backend
- ⚠️ TODO: Add appointment time validation (not too far in future)
- ⚠️ TODO: Implement cancellation policy

## 📊 Testing Checklist

- [ ] Test booking with different times
- [ ] Verify queue numbers increment per department
- [ ] Test rescheduling to different dates
- [ ] Test cancellation with multiple users
- [ ] Verify countdown timer works
- [ ] Test tab filtering
- [ ] Test offline error handling
- [ ] Test API error responses
- [ ] Test user isolation
- [ ] Load test with multiple concurrent bookings

## 🎨 UI Customization

Colors used in appointments screen:
- Primary: `#6C63FF` (Purple)
- Secondary: `#00BFA6` (Cyan)
- Success: `#4CAF50` (Green)
- Error: `#FF6B6B` (Red)
- Background: `#0A0A0F` (Dark)

To change colors, update the Color() values in `appointments_screen.dart`.

## 📱 Device Compatibility

The appointments screen is optimized for:
- ✅ Android phones (5.0 and above)
- ✅ iOS (12.0 and above)
- ✅ Web (responsive design)
- ✅ Tablets (optimized layout)

## 🐛 Troubleshooting

### Appointments not loading
- Check backend API is running
- Verify JWT token is valid
- Check network connectivity
- Look at console logs for errors

### Queue numbers not incrementing
- Ensure `/next-queue` endpoint is implemented
- Verify department and date params are passed correctly
- Check database queries are correct

### Reschedule/Cancel not working
- Verify appointment ID is correct
- Check user has permission to modify
- Ensure date is valid (in future)

### UI not styled correctly
- Clear Flutter build cache: `flutter clean`
- Ensure Google Fonts package is installed
- Check all imports are correct

## 📚 Additional Resources

- `APPOINTMENTS_IMPLEMENTATION.md` - Detailed feature documentation
- `BACKEND_API_REFERENCE.md` - API specifications
- `BACKEND_EXAMPLE_CODE.js` - Example implementation

## 🔄 Next Steps

1. Implement backend endpoints
2. Test API integration
3. Add notification system
4. Implement email/SMS confirmations
5. Create admin dashboard
6. Add analytics and reporting
7. Implement doctor availability
8. Add patient reviews

## 📞 Support

For questions about:
- **Frontend**: Check the code comments in appointment_provider.dart and appointments_screen.dart
- **Backend**: See BACKEND_EXAMPLE_CODE.js and BACKEND_API_REFERENCE.md
- **Design**: All styling is in appointments_screen.dart using Material Design 3

---

**Last Updated**: January 25, 2026
**Status**: Ready for backend integration
