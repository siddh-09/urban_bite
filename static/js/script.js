// Urban Bite JavaScript

// Navbar scroll effect

window.addEventListener("scroll", function(){

const navbar = document.querySelector(".navbar");

if(window.scrollY > 50){

navbar.style.background = "rgba(0,0,0,0.8)";

}
else{

navbar.style.background = "rgba(255,255,255,0.05)";

}

});



// Smooth hover animation for dish cards

const cards = document.querySelectorAll(".dish-card");

cards.forEach(card => {

card.addEventListener("mouseenter", () => {

card.style.transform = "scale(1.05)";

});

card.addEventListener("mouseleave", () => {

card.style.transform = "scale(1)";

});

});



// Button click animation

const buttons = document.querySelectorAll(".hero-btn, .btn");

buttons.forEach(button => {

button.addEventListener("click", function(){

button.style.transform = "scale(0.95)";

setTimeout(() => {

button.style.transform = "scale(1)";

},150);

});

});
