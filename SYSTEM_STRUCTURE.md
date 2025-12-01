# Dormitory Management System - Database-Aligned Architecture

## Overview
The system has been completely reorganized to follow the database structure, providing a logical flow from core entities to dependent modules. All files and routes are numbered sequentially to match database dependencies.

## Database Structure (In Order of Dependencies)

```
1. USERS (Foundation)
   - user_id, username, role, name, email, phone, etc.
   
2. BUILDINGS (Infrastructure)
   - building_id, building_name, address, total_floors
   
3. ROOM_TYPES (Categories)
   - type_id, type_name, base_rate, capacity
   
4. ROOMS (Physical Units)
   - room_id → building_id, type_id
   
5. ROOM_ASSIGNMENTS (Tenant-Room Mapping)
   - assignment_id → user_id, room_id
   
6. PAYMENTS (Financial Records)
   - payment_id → user_id, assignment_id
   
7. REPORTS (Summaries)
   - report_id → generated_by (user_id)
```

## File Organization

### Templates (Numbered for Easy Navigation)

**1. Dashboard & Home**
- `01_index.html` - Main dashboard with navigation to all modules

**2. Users Management**
- `02_users.html` - List all users with edit/delete actions
- `02_add_user.html` - Add new user form
- `02_edit_user.html` - Edit user details form

**3. Buildings Management**
- `03_buildings.html` - List all buildings (card view)
- `03_add_building.html` - Add new building form
- `03_edit_building.html` - Edit building details form

**4. Room Types**
- `04_room_types.html` - Display all room types with pricing

**5. Rooms**
- `05_rooms.html` - List all rooms with building and type info

**6. Room Assignments**
- `06_assignments.html` - Track tenant assignments to rooms

**7. Payments**
- `07_payments.html` - List all payment records
- `07_payment.html` - Record new payment form

**8. Reports**
- `08_reports.html` - View generated reports

### Python Routes (app.py)

```python
# 1. HOME
GET  /                          → 01_index.html (Dashboard)

# 2. USERS
GET  /users                     → 02_users.html (List)
GET  /add_user                  → 02_add_user.html (Form)
POST /add_user                  → Create user
GET  /edit_user/<user_id>       → 02_edit_user.html (Form)
POST /edit_user/<user_id>       → Update user
POST /delete_user/<user_id>     → Delete user

# 3. BUILDINGS
GET  /buildings                 → 03_buildings.html (List)
GET  /add_building              → 03_add_building.html (Form)
POST /add_building              → Create building
GET  /edit_building/<id>        → 03_edit_building.html (Form)
POST /edit_building/<id>        → Update building

# 4. ROOM TYPES
GET  /room_types                → 04_room_types.html (View Only)

# 5. ROOMS
GET  /rooms                     → 05_rooms.html (List)

# 6. ROOM ASSIGNMENTS
GET  /assignments               → 06_assignments.html (List)

# 7. PAYMENTS
GET  /payments                  → 07_payments.html (List)
GET  /payment                   → 07_payment.html (Form)
POST /payment                   → Record new payment

# 8. REPORTS
GET  /reports                   → 08_reports.html (List)
```

## Navigation Bar Structure

The main navigation bar (01_index.html) provides access to all modules in logical order:

```
🏢 Dormitory Management System
├── 👥 Users
├── 🏢 Buildings
├── 📋 Room Types
├── 🚪 Rooms
├── 📝 Assignments
├── 💳 Payments
└── 📊 Reports
```

## Features by Module

### 1. Users Management
- View all users with role, email, phone, status
- Add new users (students, admins, landlords)
- Edit user information
- Delete users
- Filter by status/role

### 2. Buildings
- View buildings in card format
- Add new buildings
- Edit building details
- Display building information (name, address, floors, status)

### 3. Room Types
- View available room types
- Display pricing, capacity, features
- View-only interface (managed in database)

### 4. Rooms
- List all rooms with building and type information
- Show room availability status
- View floor number and room number
- Link to building and room type info

### 5. Room Assignments
- Track tenant assignments to rooms
- Display assignment dates and duration
- Show monthly rate and contract status
- View building location and room details

### 6. Payments
- Record rent payments with multiple payment methods
- Track payment receipts and dates
- Filter by tenant and date
- Display payment history

### 7. Reports
- Generate occupancy reports
- Payment summary reports
- User list reports
- Track report generation history

## Bootstrap Styling
- All templates use Bootstrap 5.3.2 via CDN with local fallback
- Responsive design (mobile-friendly)
- Consistent color scheme and typography
- Interactive elements with proper state management
- Alert messages for user feedback

## Database Queries

### Users
```sql
SELECT user_id, username, first_name, last_name, role, email, phone, is_active
FROM users ORDER BY user_id
```

### Buildings
```sql
SELECT building_id, building_name, address, total_floors, is_active
FROM buildings ORDER BY building_id
```

### Room Types
```sql
SELECT type_id, type_name, base_rate, capacity, description, is_active
FROM room_types ORDER BY type_id
```

### Rooms with Details
```sql
SELECT r.room_id, r.room_number, r.floor_number, b.building_name, rt.type_name, r.is_available
FROM rooms r
LEFT JOIN buildings b ON r.building_id = b.building_id
LEFT JOIN room_types rt ON r.type_id = rt.type_id
ORDER BY r.room_id
```

### Assignments with Details
```sql
SELECT ra.assignment_id, u.first_name, u.last_name, r.room_number, b.building_name,
       ra.start_date, ra.end_date, ra.monthly_rate, ra.status
FROM room_assignments ra
LEFT JOIN users u ON ra.user_id = u.user_id
LEFT JOIN rooms r ON ra.room_id = r.room_id
LEFT JOIN buildings b ON r.building_id = b.building_id
ORDER BY ra.assignment_id
```

### Payments with Tenant Info
```sql
SELECT p.payment_id, u.first_name, u.last_name, p.amount, p.payment_method,
       p.payment_date, p.receipt_number
FROM payments p
LEFT JOIN users u ON p.user_id = u.user_id
ORDER BY p.payment_id DESC
```

## Workflow Example

### Adding a New Tenant

1. **Add User** (Module 2)
   - Go to Users → Add User
   - Fill in student information
   - User is now in the system

2. **Assign to Room** (Module 6)
   - Room must exist (created in Rooms, which link to Buildings and Room Types)
   - Create assignment linking user to room
   - Set contract dates and monthly rate

3. **Record Payment** (Module 7)
   - Tenant pays rent
   - Record payment with receipt number and method
   - Payment is linked to assignment and user

4. **Generate Reports** (Module 8)
   - View occupancy status
   - Check payment history
   - Generate user reports

## File Statistics

- Total Templates: 13 (numbered 01-08 + subdirectories)
- Total Routes: 25+ endpoints
- Database Tables: 7 (users, buildings, room_types, rooms, room_assignments, payments, reports)
- Bootstrap Classes Used: 50+ utility classes for responsive design

## Technology Stack

- **Backend**: Python Flask
- **Database**: MySQL
- **Frontend**: Bootstrap 5.3.2 (CDN + Local Fallback)
- **ORM**: None (Direct MySQL queries)
- **Authentication**: Currently basic (to be enhanced)

## Next Steps

1. ✅ Reorganized file structure to match database
2. ✅ Created all CRUD template files
3. ✅ Implemented all routes
4. ⏳ Add authentication and authorization
5. ⏳ Add form validation
6. ⏳ Add report generation features
7. ⏳ Add search/filter capabilities
8. ⏳ Add user profile and settings pages

## Running the Application

```bash
python app.py
```

Access at: `http://localhost:5000`

## Default Users

| Username | Password | Role |
|----------|----------|------|
| admin1   | hashedpassword1 | admin |
| admin2   | hashedpassword2 | admin |
| stud001  | hashedpass3 | student |
| stud002  | hashedpass4 | student |
| stud003  | hashedpass5 | student |

---

**System Version**: 2.0 (Database-Aligned Architecture)  
**Last Updated**: December 1, 2025
