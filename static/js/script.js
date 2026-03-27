document.addEventListener("DOMContentLoaded", function () {

    console.log("JS Loaded ✅");

    // =========================
    // 🔍 FOOD SEARCH
    // =========================
    const searchInput = document.getElementById("search-input");
    const resultsBox = document.getElementById("search-results");

    if (searchInput && resultsBox) {
        searchInput.addEventListener("keyup", function () {

            let query = this.value.trim();

            if (query.length < 1) {
                resultsBox.innerHTML = "";
                return;
            }

            fetch(`/api/search?q=${encodeURIComponent(query)}`)
                .then(res => res.json())
                .then(data => {

                    let html = "";

                    if (data.length === 0) {
                        html = "<div style='padding:10px;'>No results</div>";
                    } else {
                        data.forEach(item => {
                            html += `
                                <div style="padding:10px;cursor:pointer;border-bottom:1px solid #ddd;"
                                onclick="goToItem('${item.name}')">
                                    ${item.name} - ₹${item.price}
                                </div>
                            `;
                        });
                    }

                    resultsBox.innerHTML = html;

                })
                .catch(err => console.log("Search Error ❌", err));
        });
    }

    // =========================
    // 📍 LOCATION (FIXED + STABLE)
    // =========================
    const locationInput = document.getElementById("location-input");
    const suggestionBox = document.getElementById("location-suggestions");

    // 👉 Load saved location first
    if (locationInput) {
        let saved = localStorage.getItem("userLocation");
        if (saved) {
            locationInput.value = saved;
        } else {
            getUserLocation(); // auto detect
        }
    }

    // 👉 Suggestion typing
    if (locationInput && suggestionBox) {

        locationInput.addEventListener("input", function () {

            let query = this.value.trim();

            if (query.length < 2) {
                suggestionBox.innerHTML = "";
                return;
            }

            fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}`)
                .then(res => res.json())
                .then(data => {

                    let html = "";

                    data.slice(0, 5).forEach(place => {
                        html += `
                            <div style="padding:10px;cursor:pointer;border-bottom:1px solid #ddd;"
                            onclick="selectLocation('${place.display_name.replace(/'/g, "")}')">
                                ${place.display_name}
                            </div>
                        `;
                    });

                    suggestionBox.innerHTML = html;

                })
                .catch(err => console.log("Location Error ❌", err));
        });
    }

    // =========================
    // 📦 LOAD MENU
    // =========================
    loadCategory("Starter", "starter-container");
    loadCategory("Veg", "veg-container");
    loadCategory("Non-Veg", "nonveg-container");
    loadCategory("Fast Food", "fastfood-container");
    loadCategory("Thali", "thali-container");
    loadCategory("Signature", "signature-container");
    loadCategory("Mocktail", "mocktail-container");
    loadCategory("Cold Drink", "cold-container");

});


// =========================
// 📍 GET USER LOCATION
// =========================
function getUserLocation() {

    const locationInput = document.getElementById("location-input");

    if (!navigator.geolocation) return;

    navigator.geolocation.getCurrentPosition(

        position => {

            let lat = position.coords.latitude;
            let lon = position.coords.longitude;

            fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}`)
                .then(res => res.json())
                .then(data => {

                    let addr = data.address;

                    let city = addr.city || addr.town || addr.village || "";
                    let state = addr.state || "";
                    let pincode = addr.postcode || "";

                    let fullLocation = `${city}, ${state} - ${pincode}`;

                    locationInput.value = fullLocation;

                    // ✅ SAVE
                

                })
                .catch(() => {
                    locationInput.value = "Enter manually";
                });

        },

        error => {
            console.log("Location denied ❌");
        }
    );
}


// =========================
// 📍 SELECT LOCATION
// =========================
function selectLocation(location) {

    const input = document.getElementById("location-input");

    input.value = location;

    // ✅ SAVE
    localStorage.setItem("userLocation", location);

    document.getElementById("location-suggestions").innerHTML = "";

    // 🔥 IMPORTANT FIX
    input.focus();   // 👉 focus wapas la
}

// =========================
// 🔁 REDIRECT SEARCH
// =========================
function goToItem(name) {
    localStorage.setItem("searchItem", name);
    window.location.href = "/explore-menu";
}


// =========================
// 📦 LOAD CATEGORY
// =========================
function loadCategory(category, containerId) {

    const container = document.getElementById(containerId);

    fetch(`/api/products/${category}`)
        .then(res => res.json())
        .then(data => {

            container.innerHTML = "";

            data.forEach(product => {

                const item = document.createElement("div");
                item.classList.add("menu-item");

                item.innerHTML = `
                    <h3>${product.name}</h3>
                    <p>${product.description}</p>
                    <span>₹${product.price}</span>
                    <button class="add-btn">Add</button>
                `;

                item.querySelector(".add-btn").addEventListener("click", () => {
                    addToCart(product.name, product.price);
                });

                container.appendChild(item);

            });

        })
        .catch(err => console.log("Fetch Error:", err));
}


// =========================
// 🛒 ADD TO CART
// =========================
function addToCart(name, price) {

    let cart = JSON.parse(localStorage.getItem("cart")) || [];

    let item = cart.find(i => i.name === name);

    if (item) {
        item.quantity++;
    } else {
        cart.push({ name, price, quantity: 1 });
    }

    localStorage.setItem("cart", JSON.stringify(cart));

    alert(name + " added to cart ✅"); // debug
}



function registerUser() {

    const name = document.getElementById("name").value;
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;
    const phone = document.getElementById("phone").value;

    fetch("/api/register", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            name: name,
            email: email,
            password: password,
            phone: phone
        })
    })
    .then(res => res.json())
    .then(data => {

    alert("✅ Registered Successfully");

    // 🔥 user save kar (IMPORTANT)
    localStorage.setItem("user", JSON.stringify({
        name: name,
        email: email,
        phone: phone,
        user_id: "TEMP"  // later DB se ayega
    }));

    window.location.href = "/";
    })
    .catch(err => {
        console.log(err);
        alert("❌ Registration Error");
    });
} 
function loginUser() {

    let email = document.getElementById("login-email").value;
    let password = document.getElementById("login-password").value;

    fetch("/api/login", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ email, password })
    })
    .then(res => res.json())
    .then(data => {

        if (data.error) {
            alert("❌ Incorrect Email or Password");
        } else {

            localStorage.setItem("user", JSON.stringify(data));

            // 🔥 message save
            localStorage.setItem("loginSuccess", "true");

            // 🔥 redirect
            window.location.href = "/";
        }

    })
    .catch(err => console.log(err));
}

document.addEventListener("DOMContentLoaded", function () {

    let success = localStorage.getItem("loginSuccess");

    if (success === "true") {

        // message show
        let msg = document.createElement("div");
        msg.innerText = "✅ Successfully Logged In";
        msg.style.position = "fixed";
        msg.style.top = "20px";
        msg.style.right = "20px";
        msg.style.background = "#28a745";
        msg.style.color = "white";
        msg.style.padding = "10px 20px";
        msg.style.borderRadius = "8px";
        msg.style.zIndex = "999";
        msg.style.boxShadow = "0 0 15px rgba(226, 221, 221, 0.93)";
        msg.style.fontWeight = "bold";

        document.body.appendChild(msg);

        // 3 sec baad remove
        setTimeout(() => {
            msg.remove();
        }, 10000); 

        // reset flag
        localStorage.removeItem("loginSuccess");
    }

});
        // 🔥 SAVE USER
document.addEventListener("DOMContentLoaded", function () {

    let user = JSON.parse(localStorage.getItem("user"));

    if (user) {
        document.getElementById("user-info").innerText =
            "👤 " + user.name + " (" + user.user_id + ")";
    }

});


function handleContact(event) {
    event.preventDefault();

    let name = document.querySelector("input[type='text']").value;
    let email = document.querySelector("input[type='email']").value;
    let phone = document.querySelectorAll("input[type='text']")[1].value;
    let message = document.querySelector("textarea").value;

    // ❌ agar kuch empty hai
    if (!name || !email || !phone || !message) {
        alert("⚠ Please fill all information!");
        return;
    }

    // ✅ sab filled hai → toast show
    const toast = document.getElementById("toast");
    toast.classList.add("show");

    setTimeout(() => {
        toast.classList.remove("show");
    }, 3000);

    event.target.reset();
}