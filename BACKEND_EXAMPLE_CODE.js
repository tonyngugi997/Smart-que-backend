/**
 * EXAMPLE BACKEND IMPLEMENTATION
 * Node.js/Express with MongoDB
 * 
 * This is example code to help implement the appointment endpoints.
 * Adjust according to your database choice and project structure.
 */

// ==================== APPOINTMENT MODEL ====================
const appointmentSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  doctorName: {
    type: String,
    required: true,
  },
  departmentName: {
    type: String,
    required: true,
  },
  dateTime: {
    type: Date,
    required: true,
  },
  queueNumber: {
    type: Number,
    required: true,
  },
  status: {
    type: String,
    enum: ['upcoming', 'completed', 'cancelled'],
    default: 'upcoming',
  },
  consultationFee: {
    type: Number,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

// Indexes for performance
appointmentSchema.index({ userId: 1 });
appointmentSchema.index({ dateTime: 1 });
appointmentSchema.index({ departmentName: 1, dateTime: 1 });
appointmentSchema.index({ status: 1 });

const Appointment = mongoose.model('Appointment', appointmentSchema);

// ==================== APPOINTMENT ROUTES ====================

// POST /api/appointments/book
router.post('/appointments/book', authenticateToken, async (req, res) => {
  try {
    const { userId, doctorName, departmentName, dateTime, queueNumber, consultationFee } = req.body;

    // Validate request
    if (!userId || !doctorName || !departmentName || !dateTime || !consultationFee) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Verify user owns this appointment
    if (req.user.id !== userId) {
      return res.status(403).json({ error: 'Unauthorized' });
    }

    // Create appointment
    const appointment = new Appointment({
      userId,
      doctorName,
      departmentName,
      dateTime: new Date(dateTime),
      queueNumber,
      status: 'upcoming',
      consultationFee,
    });

    await appointment.save();

    res.status(201).json({
      success: true,
      appointment: appointment.toObject(),
    });
  } catch (error) {
    console.error('Error booking appointment:', error);
    res.status(500).json({ error: 'Failed to book appointment' });
  }
});

// GET /api/appointments/user/:userId
router.get('/appointments/user/:userId', authenticateToken, async (req, res) => {
  try {
    const { userId } = req.params;

    // Verify user is requesting their own appointments
    if (req.user.id !== userId) {
      return res.status(403).json({ error: 'Unauthorized' });
    }

    const appointments = await Appointment.find({ userId }).sort({ dateTime: -1 });

    res.json({
      success: true,
      appointments: appointments.map(apt => apt.toObject()),
    });
  } catch (error) {
    console.error('Error fetching appointments:', error);
    res.status(500).json({ error: 'Failed to fetch appointments' });
  }
});

// GET /api/appointments/next-queue
router.get('/appointments/next-queue', authenticateToken, async (req, res) => {
  try {
    const { department, date } = req.query;

    if (!department || !date) {
      return res.status(400).json({ error: 'Missing department or date' });
    }

    const appointmentDate = new Date(date);
    const dayStart = new Date(appointmentDate.getFullYear(), appointmentDate.getMonth(), appointmentDate.getDate());
    const dayEnd = new Date(dayStart);
    dayEnd.setDate(dayEnd.getDate() + 1);

    // Find max queue number for the department on that date
    const result = await Appointment.findOne({
      departmentName: department,
      dateTime: {
        $gte: dayStart,
        $lt: dayEnd,
      },
      status: { $ne: 'cancelled' }, // Don't count cancelled appointments
    }).sort({ queueNumber: -1 });

    const nextQueue = result ? result.queueNumber + 1 : 1;

    res.json({
      success: true,
      queueNumber: nextQueue,
    });
  } catch (error) {
    console.error('Error getting next queue number:', error);
    res.status(500).json({ error: 'Failed to get queue number' });
  }
});

// POST /api/appointments/cancel/:appointmentId
router.post('/appointments/cancel/:appointmentId', authenticateToken, async (req, res) => {
  try {
    const { appointmentId } = req.params;

    const appointment = await Appointment.findById(appointmentId);

    if (!appointment) {
      return res.status(404).json({ error: 'Appointment not found' });
    }

    // Verify user owns this appointment
    if (appointment.userId.toString() !== req.user.id) {
      return res.status(403).json({ error: 'Unauthorized' });
    }

    appointment.status = 'cancelled';
    appointment.updatedAt = new Date();
    await appointment.save();

    res.json({
      success: true,
      message: 'Appointment cancelled successfully',
    });
  } catch (error) {
    console.error('Error cancelling appointment:', error);
    res.status(500).json({ error: 'Failed to cancel appointment' });
  }
});

// POST /api/appointments/reschedule/:appointmentId
router.post('/appointments/reschedule/:appointmentId', authenticateToken, async (req, res) => {
  try {
    const { appointmentId } = req.params;
    const { dateTime } = req.body;

    if (!dateTime) {
      return res.status(400).json({ error: 'Missing dateTime' });
    }

    const appointment = await Appointment.findById(appointmentId);

    if (!appointment) {
      return res.status(404).json({ error: 'Appointment not found' });
    }

    // Verify user owns this appointment
    if (appointment.userId.toString() !== req.user.id) {
      return res.status(403).json({ error: 'Unauthorized' });
    }

    // Update appointment
    appointment.dateTime = new Date(dateTime);
    appointment.updatedAt = new Date();

    // Optionally recalculate queue number for new date
    // (Remove this if queue numbers should be permanent)
    const appointmentDate = new Date(dateTime);
    const dayStart = new Date(appointmentDate.getFullYear(), appointmentDate.getMonth(), appointmentDate.getDate());
    const dayEnd = new Date(dayStart);
    dayEnd.setDate(dayEnd.getDate() + 1);

    const result = await Appointment.findOne({
      _id: { $ne: appointmentId },
      departmentName: appointment.departmentName,
      dateTime: {
        $gte: dayStart,
        $lt: dayEnd,
      },
      status: { $ne: 'cancelled' },
    }).sort({ queueNumber: -1 });

    appointment.queueNumber = result ? result.queueNumber + 1 : 1;

    await appointment.save();

    res.json({
      success: true,
      appointment: appointment.toObject(),
    });
  } catch (error) {
    console.error('Error rescheduling appointment:', error);
    res.status(500).json({ error: 'Failed to reschedule appointment' });
  }
});

// ==================== HELPER FUNCTIONS ====================

/**
 * Middleware to verify authentication token
 */
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }

  jwt.verify(token, process.env.JWT_SECRET || 'your_secret_key', (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid token' });
    }
    req.user = user;
    next();
  });
}

/**
 * GET /api/appointments/department-stats/:departmentName
 * (Optional) Get statistics for a department
 */
router.get('/appointments/department-stats/:departmentName', authenticateToken, async (req, res) => {
  try {
    const { departmentName } = req.params;

    const stats = await Appointment.aggregate([
      {
        $match: { departmentName, status: 'upcoming' },
      },
      {
        $group: {
          _id: null,
          totalAppointments: { $sum: 1 },
          averageQueue: { $avg: '$queueNumber' },
        },
      },
    ]);

    res.json({
      success: true,
      stats: stats[0] || { totalAppointments: 0, averageQueue: 0 },
    });
  } catch (error) {
    console.error('Error fetching stats:', error);
    res.status(500).json({ error: 'Failed to fetch statistics' });
  }
});

/**
 * DELETE /api/appointments/:appointmentId
 * (Optional) Permanently delete an appointment (admin only)
 */
router.delete('/appointments/:appointmentId', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { appointmentId } = req.params;

    await Appointment.findByIdAndDelete(appointmentId);

    res.json({
      success: true,
      message: 'Appointment deleted successfully',
    });
  } catch (error) {
    console.error('Error deleting appointment:', error);
    res.status(500).json({ error: 'Failed to delete appointment' });
  }
});

// ==================== EXPORT ====================
module.exports = router;
