from flask import Flask, render_template, jsonify, request
from flask_cors import CORS
import psycopg2
import psycopg2.extras

app = Flask(__name__)
CORS(app)

# 🔹 Database Connection Function
def get_db_connection():
    conn = psycopg2.connect(
        host="localhost",
        database="urban bite",  # your exact DB name
        user="postgres",
        password="root"     # your real password
    )
    return conn

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

# 🔥 ADD THIS BELOW IT 🔥
@app.route("/api/products/<category>")
def get_products_by_category(category):
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

    cur.execute("SELECT * FROM products WHERE category = %s ORDER BY id;", (category,))
    products = cur.fetchall()

    cur.close()
    conn.close()

    return jsonify(products)

if __name__ == "__main__":
    app.run(debug=True)

# 🔹 API Route: Get All Products
@app.route("/api/products")
def get_products():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

    cur.execute("SELECT * FROM products ORDER BY id;")
    products = cur.fetchall()

    cur.close()
    conn.close()

    return jsonify(products)


