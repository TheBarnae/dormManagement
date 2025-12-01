# Quick Reference Guide

## 🚀 Starting the Application

```bash
cd c:\Users\ADMIN\Documents\dormManagement-1
python app.py
```

Access: `http://localhost:5000`

## 📊 Module Order (Database Dependencies)

| # | Module | Purpose | Route |
|---|--------|---------|-------|
| 1 | **Users** | Manage all users | `/users` |
| 2 | **Buildings** | Manage dormitory buildings | `/buildings` |
| 3 | **Room Types** | View room categories | `/room_types` |
| 4 | **Rooms** | List physical rooms | `/rooms` |
| 5 | **Assignments** | Tenant-room mapping | `/assignments` |
| 6 | **Payments** | Rent payments | `/payments` |
| 7 | **Reports** | Generate reports | `/reports` |

## 📁 Template File Mapping

### Dashboard
- `01_index.html` - Main dashboard with navigation

### Users (Module 2)
- `02_users.html` - List all users
- `02_add_user.html` - Add new user form
- `02_edit_user.html` - Edit user form

### Buildings (Module 3)
- `03_buildings.html` - List buildings (card view)
- `03_add_building.html` - Add building form
- `03_edit_building.html` - Edit building form

### Room Types (Module 4)
- `04_room_types.html` - View room types

### Rooms (Module 5)
- `05_rooms.html` - List all rooms

### Assignments (Module 6)
- `06_assignments.html` - List assignments

### Payments (Module 7)
- `07_payments.html` - List payments
- `07_payment.html` - Record payment form

### Reports (Module 8)
- `08_reports.html` - View reports

## 🔗 URL Patterns

```
GET  /                          Dashboard
GET  /users                     User list
GET  /add_user                  Add user form
POST /add_user                  Create user
GET  /edit_user/<id>            Edit user form
POST /edit_user/<id>            Update user
POST /delete_user/<id>          Delete user

GET  /buildings                 Buildings list
GET  /add_building              Add building form
POST /add_building              Create building
GET  /edit_building/<id>        Edit building form
POST /edit_building/<id>        Update building

GET  /room_types                Room types
GET  /rooms                     Rooms list
GET  /assignments               Assignments list
GET  /payments                  Payments list
GET  /payment                   Record payment form
POST /payment                   Create payment
GET  /reports                   Reports list
```

## 🎯 Common Tasks

### Add a New User
1. Go to Dashboard → Users
2. Click "+ Add User"
3. Fill in the form
4. Click "Add User"

### Manage Buildings
1. Go to Dashboard → Buildings
2. Click "+ Add Building" to add
3. Click "Edit" on card to modify
4. Click "Delete" to remove

### View Room Status
1. Go to Dashboard → Rooms
2. Check "Available" or "Occupied" status
3. See building and room type info

### Record Rent Payment
1. Go to Dashboard → Payments
2. Click "+ Record Payment"
3. Select tenant and fill in details
4. Click "Record Payment"

### View Assignments
1. Go to Dashboard → Room Assignments
2. See all tenant-to-room mappings
3. Check contract dates and rates

## 🗄️ Database Tables

```sql
users                  -- User accounts
├── user_id (PK)
├── username
├── password_hash
├── role (admin, student, landlord)
├── first_name, last_name
├── email, phone
└── is_active

buildings              -- Dormitory buildings
├── building_id (PK)
├── building_name
├── address
├── total_floors
└── is_active

room_types             -- Room categories
├── type_id (PK)
├── type_name
├── base_rate
├── capacity
├── description
└── is_active

rooms                  -- Physical rooms
├── room_id (PK)
├── building_id (FK → buildings)
├── type_id (FK → room_types)
├── room_number
├── floor_number
└── is_available

room_assignments       -- Tenant assignments
├── assignment_id (PK)
├── user_id (FK → users)
├── room_id (FK → rooms)
├── start_date, end_date
├── monthly_rate
└── status

payments               -- Rent payments
├── payment_id (PK)
├── user_id (FK → users)
├── assignment_id (FK → room_assignments)
├── amount
├── payment_method
├── payment_date
└── receipt_number

reports                -- Generated reports
├── report_id (PK)
├── generated_by (FK → users)
├── report_type
├── report_title
├── file_path
└── generated_on
```

## 🎨 Bootstrap Features Used

- **Grid System**: `row`, `col-md-*`, `col-lg-*`
- **Components**: Cards, Tables, Forms, Badges, Buttons
- **Utilities**: Spacing (mb, mt, p), Text (text-center), Display (d-flex)
- **Colors**: Primary, Success, Warning, Danger, Info
- **Responsive**: Mobile-first design, breakpoints

## 🔐 Default Users (for testing)

| Username | Password | Role |
|----------|----------|------|
| admin1 | hashedpassword1 | admin |
| stud001 | hashedpass3 | student |

## 📝 File Statistics

- Templates: 13 files
- Routes: 25+ endpoints
- Database Tables: 7 tables
- Bootstrap Classes: 50+
- Total Lines of Code: 2000+

## ⚙️ Configuration Files

- `app.py` - Flask application (UPDATED)
- `db.py` - Database connection
- `.env` - Environment variables
- `database/manager.sql` - Database schema

## 🔧 Development Notes

1. All templates use numbered prefixes for easy sorting
2. Each route corresponds to a specific template
3. Bootstrap CDN with local fallback for offline support
4. Forms include proper validation and error handling
5. Tables use LEFT JOINs for related data display
6. Status badges indicate active/inactive, available/occupied states

## 📱 Responsive Breakpoints

- **Desktop**: Full width tables and forms
- **Tablet**: 2-column layouts
- **Mobile**: Single column, stacked buttons

## 🌐 Navigation Flow

```
Dashboard (01_index.html)
    ├─→ Users (02_users.html)
    ├─→ Buildings (03_buildings.html)
    ├─→ Room Types (04_room_types.html)
    ├─→ Rooms (05_rooms.html)
    ├─→ Assignments (06_assignments.html)
    ├─→ Payments (07_payments.html)
    └─→ Reports (08_reports.html)
```

## 💡 Tips

1. Use the numbered filenames to understand the module order
2. Always start from Dashboard to understand the system flow
3. Follow the database dependency order when managing data
4. Use the Quick Reference URL Patterns for API calls
5. Bootstrap classes make styling consistent across all pages

---

**Version**: 2.0 | **Updated**: December 1, 2025

For complete documentation, see:
- `SYSTEM_STRUCTURE.md` - Detailed system design
- `CHANGES.md` - Complete list of changes
