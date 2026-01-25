# Appointments Screen - Visual Reference & Colors

## Screen Layout

```
┌─────────────────────────────────────┐
│  ← My Appointments              [X] │
│  View and manage your appointments  │
├─────────────────────────────────────┤
│  [Upcoming]  [Completed]  [Cancelled]│
│────────────────────────────────────│
│                                      │
│  ┌──────────────────────────────────┐ │
│  │ Dr. Sarah Johnson      [UPCOMING]│ │
│  │ Cardiology                       │ │
│  ├──────────────────────────────────┤ │
│  │ 📅 15 Jan, 2026  |  🕐 2:30 PM  │ │
│  │ 🎫 Queue #5      |  2h 15m left │ │
│  ├──────────────────────────────────┤ │
│  │ [Reschedule]     [Cancel]        │ │
│  └──────────────────────────────────┘ │
│                                      │
│  ┌──────────────────────────────────┐ │
│  │ Dr. Michael Chen   [UPCOMING]    │ │
│  │ Neurology                        │ │
│  ├──────────────────────────────────┤ │
│  │ 📅 20 Jan, 2026  |  🕐 10:00 AM │ │
│  │ 🎫 Queue #3      |  5d 6h left  │ │
│  ├──────────────────────────────────┤ │
│  │ [Reschedule]     [Cancel]        │ │
│  └──────────────────────────────────┘ │
│                                      │
└─────────────────────────────────────┘
```

## Color Coding

### Status Badges
```
UPCOMING ────────────── Cyan (#00BFA6)
COMPLETED ───────────── Green (#4CAF50)
CANCELLED ───────────── Red (#FF6B6B)
```

### Component Colors
```
Primary Color:        #6C63FF (Purple)
Secondary Color:      #00BFA6 (Cyan)
Success Color:        #4CAF50 (Green)
Error Color:          #FF6B6B (Red)
Background:           #0A0A0F (Very Dark)
Card Background:      #1A1A2E (Dark)
Text Primary:         #FFFFFF (White)
Text Secondary:       #FFFFFF99 (White 60%)
Border/Dividers:      #FFFFFF1A (White 10%)
```

## Typography

```
Title (My Appointments):
  - Font: Poppins
  - Size: 28px
  - Weight: Bold (700)
  - Color: White (#FFFFFF)

Subtitle (View and manage...):
  - Font: Poppins
  - Size: 14px
  - Weight: Regular (400)
  - Color: White 60% (#FFFFFF99)

Doctor Name:
  - Font: Poppins
  - Size: 16px
  - Weight: Bold (600)
  - Color: White

Department Name:
  - Font: Poppins
  - Size: 13px
  - Color: White 60%

Date/Time Info:
  - Font: Poppins
  - Size: 13px
  - Color: White 70% (#FFFFFFB3)

Queue Number:
  - Font: Poppins
  - Size: 13px
  - Weight: SemiBold (600)
  - Color: Primary (#6C63FF)

Time Remaining:
  - Font: Poppins
  - Size: 12px
  - Weight: SemiBold (600)
  - Color: Secondary (#00BFA6)
```

## Card Design

### Appointment Card Structure
```
┌─ Container ─────────────────────────────┐
│  Background: Gradient (transparent white) │
│  Border: 1px white (10% opacity)         │
│  Border Radius: 18px                     │
│  Padding: 18px                           │
│  ───────────────────────────────────────│
│  │ Doctor Name         [Status Badge]   │
│  │ Department Name                      │
│  ├───────────────────────────────────────│
│  │ 📅 Date  |  🕐 Time                  │
│  │ 🎫 Queue #X  |  Time Remaining       │
│  │                                       │
│  │ [Action Button] [Action Button]       │
│  └───────────────────────────────────────┘
```

## Button Styling

### Reschedule Button (Upcoming)
```
Background: Cyan with 20% opacity (#00BFA61A)
Border: 1px Cyan (#00BFA6)
Text Color: Cyan (#00BFA6)
Icon: Edit (18px)
Border Radius: 10px
Padding: Vertical 10px
Font: Poppins, Weight: 600
```

### Cancel Button (Upcoming)
```
Background: Red with 20% opacity (#FF6B6B1A)
Border: 1px Red (#FF6B6B)
Text Color: Red (#FF6B6B)
Icon: Close (18px)
Border Radius: 10px
Padding: Vertical 10px
Font: Poppins, Weight: 600
```

### Dialog Action Buttons
```
Primary (Confirm):
  Background: Cyan (#00BFA6)
  Text Color: White
  
Secondary (Cancel):
  Background: White with 10% opacity
  Text Color: White
```

## Tab Bar Styling

```
Background: White with 5% opacity (#FFFFFF0D)
Border: 1px white (10% opacity)
Border Radius: 15px
Tab Spacing: Equal distribution

Active Tab Indicator:
  Background: Primary with 20% opacity (#6C63FF33)
  Border Radius: 12px
  Color: Primary (#6C63FF)

Inactive Tab:
  Color: White 50% (#FFFFFF80)
```

## Icons Used

```
Close/Back:        Icons.arrow_back
Calendar:          Icons.calendar_today
Time:              Icons.access_time
Queue:             Icons.queue
Edit/Reschedule:   Icons.edit
Cancel:            Icons.close
Empty State:       Icons.calendar_today
Warning:           Icons.warning_rounded
Medical Services:  Icons.medical_services
```

## Spacing & Layout

```
Screen Padding:        20px
Card Margin (bottom):  15px
Card Internal Padding: 18px
Section Spacing:       15px (within card)
Button Gap:            10px
Tab Bar Margin:        20px (all sides)
Tab Bar Height:        ~50px
```

## Animations & Transitions

```
Card Transitions:
  - Opacity: Fade in on load
  - Scale: Subtle entrance animation
  - Duration: 300ms

Dialog Animations:
  - Scale: Entrance animation
  - Duration: 300ms
  - Curve: EaseOut

Timer Updates:
  - Continuously updates countdown
  - No animation needed
```

## Responsive Breakpoints

```
Small Devices (<480px):
  - Single column layout
  - Reduced padding
  - Full-width buttons

Medium Devices (480-768px):
  - Optimized spacing
  - Side-by-side buttons
  - Touch-friendly sizes

Large Devices (>768px):
  - Wider cards
  - Maximum width constraints
  - Comfortable spacing
```

## Empty State

When no appointments exist:
```
┌─────────────────────────────┐
│                             │
│         [📅 Icon]           │
│    (100x100, Purple 10%)    │
│                             │
│   "No appointments"         │
│   (Poppins, 18px, Bold)     │
│                             │
│  "You don't have any        │
│   appointments in this      │
│   category"                 │
│   (Poppins, 14px, White 50%)│
│                             │
└─────────────────────────────┘
```

## Status Badge Styling

```
Status Badge Container:
  - Padding: Horizontal 12px, Vertical 6px
  - Border Radius: 20px
  - Border: 1px with status color
  - Background: Status color with 20% opacity
  - Font: Poppins, 11px, Bold
  
Examples:
  UPCOMING:  Cyan bg (#00BFA61A), Cyan border & text (#00BFA6)
  COMPLETED: Green bg (#4CAF501A), Green border & text (#4CAF50)
  CANCELLED: Red bg (#FF6B6B1A), Red border & text (#FF6B6B)
```

## Dialog Styling

### Reschedule Dialog
```
Background: Card color (#1A1A2E)
Border Radius: 20px
Padding: 25px
Max Width: 90% of screen

Contains:
  - Title (Poppins, 20px, Bold)
  - Date picker button
  - Time picker button
  - Action buttons row

Buttons use same styling as card action buttons
```

### Cancel Confirmation Dialog
```
Background: Card color (#1A1A2E)
Border Radius: 20px
Padding: 25px

Contains:
  - Warning icon (70x70, red background 20%)
  - Title: "Cancel Appointment?"
  - Description text
  - Two buttons: "Keep It" (secondary), "Cancel It" (red)
```

## Performance Optimizations

- Lazy loading of appointment cards
- Efficient rebuild using Consumer widget
- Debounced countdown timer
- Cached user appointments
- Minimal widget rebuilds

## Accessibility Features

- Clear color contrast (WCAG AA compliant)
- Touch-friendly button sizes (48x48 minimum)
- Clear icon labels
- Readable font sizes (minimum 12px)
- High contrast status indicators
- Clear user feedback with SnackBars

---

All colors, sizes, and styling can be customized by modifying the values in `appointments_screen.dart`. The design follows Material Design 3 principles with a modern, glassmorphic aesthetic.
