from flask import Flask, render_template, request, redirect, flash, url_for
from db import get_db_connection
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY", "dev_secret_key")

# -----------------------
# HOME PAGE
# -----------------------
@app.route("/")
def home():
    return render_template("index.html")

# -----------------------
# USERS PAGE (LIST USERS)
# -----------------------
@app.route("/users")
def users():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    users = []
    try:
        # alias user_id -> id so templates can use user.id
        cursor.execute("SELECT user_id AS id, username, first_name, last_name, role FROM users")
        users = cursor.fetchall()
    except Exception as e:
        flash(f"Error fetching users: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return render_template("users.html", users=users)

# -----------------------
# ADD USER
# -----------------------
@app.route("/add_user", methods=["GET", "POST"])
def add_user():
    if request.method == "POST":
        username = request.form.get("username")
        first = request.form.get("first_name")
        last = request.form.get("last_name")
        role = request.form.get("role")

        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("""
                INSERT INTO users (username, password_hash, role, first_name, last_name, email)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (username, "defaultpass", role, first, last, f"{username}@email.com"))
            conn.commit()
            flash("User added successfully!", "success")
        except Exception as e:
            flash(f"Error adding user: {e}", "danger")
        finally:
            cursor.close()
            conn.close()
        return redirect(url_for("users"))
    return render_template("add_user.html")

# -----------------------
# EDIT USER
# -----------------------
@app.route("/edit_user/<int:id>", methods=["GET", "POST"])
def edit_user(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    user = None
    try:
        if request.method == "POST":
            username = request.form.get("username")
            first = request.form.get("first_name")
            last = request.form.get("last_name")
            role = request.form.get("role")

            cursor.execute("""
                UPDATE users SET username=%s, first_name=%s, last_name=%s, role=%s
                WHERE user_id=%s
            """, (username, first, last, role, id))
            conn.commit()
            flash("User updated successfully!", "success")
            return redirect(url_for("users"))

        cursor.execute("""
            SELECT user_id AS id, username, first_name, last_name, role,
                   address, phone AS contact
            FROM users WHERE user_id=%s
        """, (id,))
        user = cursor.fetchone()

        if not user:
            flash("User not found.", "warning")
            cursor.close()
            conn.close()
            return redirect(url_for("users"))

    except Exception as e:
        flash(f"Error editing user: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return render_template("edit_user.html", user=user)

# -----------------------
# DELETE USER
# -----------------------
@app.route("/delete_user/<int:id>", methods=["GET", "POST"])
def delete_user(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM users WHERE user_id=%s", (id,))
        conn.commit()
        flash("User deleted successfully!", "success")
    except Exception as e:
        flash(f"Error deleting user: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return redirect(url_for("users"))

# -----------------------
# RUN APP
# -----------------------
if __name__ == "__main__":
    app.run(debug=True)
