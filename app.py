from flask import Flask, render_template, jsonify, request
from flask_cors import CORS
import psycopg2
import psycopg2.extras

app = Flask(__name__)
CORS(app)

# 🔹 Database Connection
def get_db_connection():
    try:
        conn = psycopg2.connect(
            host="localhost",
            database="urban bite",
            user="postgres",
            password="root"
        )
        print("DB Connected ")
        return conn
    except Exception as e:
        print("DB Error :", e)


# 🔹 Page Routes
@app.route("/")
def home():
    return render_template("index.html")

@app.route("/menu")
def menu():
    return render_template("menu.html")

@app.route("/order")
def order():
    return render_template("order.html")

@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/register")
def register():
    return render_template("register.html")

@app.route("/about")
def about():
    return render_template("about.html")

@app.route("/contact")
def contact():
    return render_template("contact.html")

@app.route("/explore-menu")
def explore():
    return render_template("explore-menu.html")


# 🔹 API: All Products
@app.route("/api/products")
def get_products():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

    cur.execute("SELECT * FROM products ORDER BY id;")
    products = cur.fetchall()

    cur.close()
    conn.close()

    return jsonify(products) 


# 🔹 API: Category Wise
@app.route("/api/products/<category>")
def get_products_by_category(category):
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

    cur.execute("""
        SELECT * FROM products 
        WHERE LOWER(category) = LOWER(%s)
        ORDER BY id;
    """, (category,))

    products = cur.fetchall()

    cur.close()
    conn.close()

    return jsonify(products)

# 🔥 API: SEARCH (FIXED)
@app.route("/api/search")
def search_products():
    query = request.args.get("q")

    if not query:
        return jsonify([])

    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

    cur.execute("""
        SELECT * FROM products 
        WHERE LOWER(name) LIKE %s 
        OR LOWER(category) LIKE %s
        OR LOWER(description) LIKE %s
    """, (
        '%' + query.lower() + '%',
        '%' + query.lower() + '%',
        '%' + query.lower() + '%'
    ))

    results = cur.fetchall()   # 🔥 IMPORTANT

    cur.close()
    conn.close()

    return jsonify(results)




import time  # 🔥 ADD THIS

@app.route("/api/register", methods=["POST"])
def register_user():

    data = request.json

    name = data["name"]
    email = data["email"]
    password = data["password"]
    phone = data["phone"]

    user_id = "U" + str(int(time.time()))[-4:]  # simple unique id

    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO userid (user_id, name, email, password, phone)
        VALUES (%s, %s, %s, %s, %s)
    """, (user_id, name, email, password, phone))

    conn.commit()
    cur.close()
    conn.close()

    return jsonify({"message": "Registered Successfully"})


@app.route("/api/login", methods=["POST"])
def login_user():

    data = request.json
    email = data["email"]
    password = data["password"]

    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

    cur.execute("""
        SELECT * FROM userid WHERE email=%s AND password=%s
    """, (email, password))

    user = cur.fetchone()

    cur.close()
    conn.close()

    if user:
        return jsonify(user)
    else:
        return jsonify({"error": "Invalid credentials"}), 401

import time

@app.route("/api/create-order", methods=["POST"])
def create_order():

    data = request.json

    user_id = data["user_id"]
    total = data["total"]

    # 🔥 UNIQUE ORDER ID
    order_id = "ORD" + str(int(time.time()))[-5:]

    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO orderid (order_id, user_id, total, status)
        VALUES (%s, %s, %s, %s)
    """, (order_id, user_id, total, "Pending"))

    conn.commit()

    cur.close()
    conn.close()

    return jsonify({"order_id": order_id})

# 🔹 RUN APP (ALWAYS LAST)
if __name__ == "__main__":
    app.run(debug=True)