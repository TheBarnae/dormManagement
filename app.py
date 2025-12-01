from flask import Flask, render_template, request, redirect, flash, url_for
from db import get_db_connection
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY", "dev_secret_key")

# -----------------------
# HOME PAGE / DASHBOARD
# -----------------------
@app.route("/")
def home():
    return render_template("01_index.html")

# ===========================
# 1. USERS MANAGEMENT
# ===========================

@app.route("/users")
def users():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    users = []
    try:
        cursor.execute("""
            SELECT user_id, username, first_name, last_name, role, 
                   email, phone, is_active 
            FROM users 
            ORDER BY user_id
        """)
        users = cursor.fetchall()
    except Exception as e:
        flash(f"Error fetching users: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return render_template("02_users.html", users=users)

@app.route("/add_user", methods=["GET", "POST"])
def add_user():
    if request.method == "POST":
        username = request.form.get("username")
        first_name = request.form.get("first_name")
        last_name = request.form.get("last_name")
        email = request.form.get("email")
        phone = request.form.get("phone")
        role = request.form.get("role", "student")
        birth_date = request.form.get("birth_date")

        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("""
                INSERT INTO users 
                (username, password_hash, role, first_name, last_name, email, phone, birth_date, is_active)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, 1)
            """, (username, "hashedpass", role, first_name, last_name, email, phone, birth_date))
            conn.commit()
            flash("User added successfully!", "success")
            return redirect(url_for("users"))
        except Exception as e:
            flash(f"Error adding user: {e}", "danger")
        finally:
            cursor.close()
            conn.close()
    return render_template("02_add_user.html")

@app.route("/edit_user/<int:user_id>", methods=["GET", "POST"])
def edit_user(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    user = None
    try:
        if request.method == "POST":
            first_name = request.form.get("first_name")
            last_name = request.form.get("last_name")
            email = request.form.get("email")
            phone = request.form.get("phone")
            birth_date = request.form.get("birth_date")

            cursor.execute("""
                UPDATE users 
                SET first_name=%s, last_name=%s, email=%s, phone=%s, birth_date=%s
                WHERE user_id=%s
            """, (first_name, last_name, email, phone, birth_date, user_id))
            conn.commit()
            flash("User updated successfully!", "success")
            return redirect(url_for("users"))

        cursor.execute("""
            SELECT user_id, username, first_name, last_name, role, email, phone, birth_date, is_active
            FROM users WHERE user_id=%s
        """, (user_id,))
        user = cursor.fetchone()

        if not user:
            flash("User not found.", "warning")
            return redirect(url_for("users"))

    except Exception as e:
        flash(f"Error editing user: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return render_template("02_edit_user.html", user=user)

@app.route("/delete_user/<int:user_id>", methods=["POST"])
def delete_user(user_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        # Check for child records that reference this user
        cursor.execute("SELECT COUNT(*) FROM room_assignments WHERE user_id=%s", (user_id,))
        assignment_count = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM payments WHERE user_id=%s", (user_id,))
        payment_count = cursor.fetchone()[0]

        if assignment_count > 0 or payment_count > 0:
            # Instead of failing with a FK constraint, perform a soft-delete (deactivate)
            cursor.execute("UPDATE users SET is_active = 0 WHERE user_id=%s", (user_id,))
            conn.commit()
            flash("User cannot be deleted because related records exist. User has been deactivated instead.", "warning")
        else:
            cursor.execute("DELETE FROM users WHERE user_id=%s", (user_id,))
            conn.commit()
            flash("User deleted successfully!", "success")
    except Exception as e:
        flash(f"Error deleting user: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return redirect(url_for("users"))

# ===========================
# 2. BUILDINGS MANAGEMENT
# ===========================

@app.route("/buildings")
def buildings():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    buildings = []
    try:
        cursor.execute("""
            SELECT building_id, building_name, address, total_floors, is_active, created_at
            FROM buildings 
            ORDER BY building_id
        """)
        buildings = cursor.fetchall()
    except Exception as e:
        flash(f"Error fetching buildings: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return render_template("03_buildings.html", buildings=buildings)

@app.route("/add_building", methods=["GET", "POST"])
def add_building():
    if request.method == "POST":
        building_name = request.form.get("building_name")
        address = request.form.get("address")
        total_floors = request.form.get("total_floors")

        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("""
                INSERT INTO buildings (building_name, address, total_floors, is_active)
                VALUES (%s, %s, %s, 1)
            """, (building_name, address, total_floors))
            conn.commit()
            flash("Building added successfully!", "success")
            return redirect(url_for("buildings"))
        except Exception as e:
            flash(f"Error adding building: {e}", "danger")
        finally:
            cursor.close()
            conn.close()
    return render_template("03_add_building.html")

@app.route("/edit_building/<int:building_id>", methods=["GET", "POST"])
def edit_building(building_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    building = None
    try:
        if request.method == "POST":
            building_name = request.form.get("building_name")
            address = request.form.get("address")
            total_floors = request.form.get("total_floors")

            cursor.execute("""
                UPDATE buildings 
                SET building_name=%s, address=%s, total_floors=%s
                WHERE building_id=%s
            """, (building_name, address, total_floors, building_id))
            conn.commit()
            flash("Building updated successfully!", "success")
            return redirect(url_for("buildings"))

        cursor.execute("SELECT * FROM buildings WHERE building_id=%s", (building_id,))
        building = cursor.fetchone()

        if not building:
            flash("Building not found.", "warning")
            return redirect(url_for("buildings"))

    except Exception as e:
        flash(f"Error editing building: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return render_template("03_edit_building.html", building=building)

# ===========================
# 3. ROOM TYPES MANAGEMENT
# ===========================

@app.route("/room_types")
def room_types():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    types = []
    try:
        cursor.execute("""
            SELECT type_id, type_name, base_rate, capacity, description, is_active
            FROM room_types 
            ORDER BY type_id
        """)
        types = cursor.fetchall()
    except Exception as e:
        flash(f"Error fetching room types: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return render_template("04_room_types.html", room_types=types)

# ===========================
# 4. ROOMS MANAGEMENT
# ===========================

@app.route("/rooms")
def rooms():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    rooms = []
    try:
        cursor.execute("""
            SELECT r.room_id, r.room_number, r.floor_number, b.building_name, 
                   rt.type_name, r.is_available
            FROM rooms r
            LEFT JOIN buildings b ON r.building_id = b.building_id
            LEFT JOIN room_types rt ON r.type_id = rt.type_id
            ORDER BY r.room_id
        """)
        rooms = cursor.fetchall()
    except Exception as e:
        flash(f"Error fetching rooms: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return render_template("05_rooms.html", rooms=rooms)

# ===========================
# 5. ROOM ASSIGNMENTS MANAGEMENT
# ===========================

@app.route("/assignments")
def assignments():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    assignments = []
    try:
        cursor.execute("""
            SELECT ra.assignment_id, u.username, u.first_name, u.last_name,
                   r.room_number, b.building_name, ra.start_date, ra.end_date, 
                   ra.monthly_rate, ra.status
            FROM room_assignments ra
            LEFT JOIN users u ON ra.user_id = u.user_id
            LEFT JOIN rooms r ON ra.room_id = r.room_id
            LEFT JOIN buildings b ON r.building_id = b.building_id
            ORDER BY ra.assignment_id
        """)
        assignments = cursor.fetchall()
    except Exception as e:
        flash(f"Error fetching assignments: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return render_template("06_assignments.html", assignments=assignments)

# ===========================
# 6. PAYMENTS MANAGEMENT
# ===========================

@app.route("/payments")
def payments():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    payments = []
    try:
        cursor.execute("""
            SELECT p.payment_id, u.username, u.first_name, u.last_name,
                   p.amount, p.payment_method, p.payment_date, 
                   p.receipt_number
            FROM payments p
            LEFT JOIN users u ON p.user_id = u.user_id
            ORDER BY p.payment_id DESC
        """)
        payments = cursor.fetchall()
    except Exception as e:
        flash(f"Error fetching payments: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return render_template("07_payments.html", payments=payments)

@app.route("/payment", methods=["GET", "POST"])
@app.route("/payment/<int:payment_id>", methods=["GET", "POST"])
def payment(payment_id=None):
    if request.method == "POST":
        user_id = request.form.get("user_id")
        amount = request.form.get("amount")
        payment_method = request.form.get("payment_method")
        payment_date = request.form.get("payment_date")
        receipt_number = request.form.get("receipt_number")

        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("""
                INSERT INTO payments (user_id, amount, payment_method, payment_date, receipt_number)
                VALUES (%s, %s, %s, %s, %s)
            """, (user_id, amount, payment_method, payment_date, receipt_number))
            conn.commit()
            flash("Payment recorded successfully!", "success")
            return redirect(url_for("payments"))
        except Exception as e:
            flash(f"Error recording payment: {e}", "danger")
        finally:
            cursor.close()
            conn.close()
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("SELECT * FROM users WHERE is_active = 1 ORDER BY first_name")
        users = cursor.fetchall()
    except Exception as e:
        flash(f"Error fetching users: {e}", "danger")
        users = []
    finally:
        cursor.close()
        conn.close()
    
    return render_template("07_payment.html", users=users)

# ===========================
# 7. REPORTS
# ===========================

@app.route("/reports")
def reports():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    reports = []
    try:
        cursor.execute("""
            SELECT report_id, report_type, report_title, generated_on, u.username
            FROM reports
            LEFT JOIN users u ON reports.generated_by = u.user_id
            ORDER BY report_id DESC
        """)
        reports = cursor.fetchall()
    except Exception as e:
        flash(f"Error fetching reports: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return render_template("08_reports.html", reports=reports)

# -----------------------
# RUN APP
# -----------------------
if __name__ == "__main__":
    app.run(debug=True)
