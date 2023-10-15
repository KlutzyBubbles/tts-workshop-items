const { createCanvas } = require("canvas");
const fs = require("fs");

console.log('start')

// Dimensions for the image
const width = 1024;
const height = 1024;
573, 31
// Instantiate the canvas object
const canvas = createCanvas(width, height);
const context = canvas.getContext("2d");

// Background
context.fillStyle = "#764abc";
context.fillRect(0, 0, width, height);


// Light Box
context.fillStyle = "#764a00";
context.fillRect(573, 31, 1000 - 573, 259 - 31);


// White box
context.fillStyle = "#76004a";
context.fillRect(616, 323, 381, 208);

// Ring
// Center 772, 788.5
var ringX = 772, ringY = 788
var outerSize = 207
var strokeWidth = 15

context.fillStyle = "#00764a";
context.fillRect(565, 582, 414, 413);


context.beginPath()
context.fillStyle = "#000000";
context.arc(ringX, ringY, outerSize - (strokeWidth / 2), 0, 2 * Math.PI)
context.strokeStyle = "#FFFFFF"
context.lineWidth = strokeWidth
context.stroke()
context.closePath()


// face ring
// Center 772, 788.5
var faceX = 274, faceY = 270
var gradientInner = 5
var gradientOuter = 220
outerSize = 253
strokeWidth = 20

context.fillStyle = "#00764a";
context.fillRect(21, 17, 506, 505);

context.beginPath()
var gradient = context.createRadialGradient(faceX, faceY, gradientInner, faceX, faceY, gradientOuter);
gradient.addColorStop(0, 'white');
gradient.addColorStop(1, 'blue');
context.arc(faceX, faceY, outerSize, 0, 2 * Math.PI);
context.closePath()

context.fillStyle = gradient;
context.fill();

context.beginPath()
context.arc(faceX, faceY, outerSize - (strokeWidth / 2) + 4, 0, 2 * Math.PI)
context.strokeStyle = "#000000"
context.lineWidth = strokeWidth
context.stroke()
context.closePath()

drawSpade(context, 128, 628, 69, 85)
drawDiamond(context, 128, 865, 69, 85)
drawHeart(context, 346, 628, 69, 85)
drawClub(context, 346, 865, 69, 85)


// Write the image to file
const buffer = canvas.toBuffer("image/png");
fs.writeFileSync("./image.png", buffer);
console.log('end')

function drawSpade(context, x, y, width, height){
    context.save();
    var bottomWidth = width * 0.7;
    var topHeight = height * 0.7;
    var bottomHeight = height * 0.3;
    context.fillStyle = "black";
    
    context.beginPath();
    context.moveTo(x, y);
    
    // top left of spade          
    context.bezierCurveTo(
        x, y + topHeight / 2, // control point 1
        x - width / 2, y + topHeight / 2, // control point 2
        x - width / 2, y + topHeight // end point
    );
    
    // bottom left of spade
    context.bezierCurveTo(
        x - width / 2, y + topHeight * 1.3, // control point 1
        x, y + topHeight * 1.3, // control point 2
        x, y + topHeight // end point
    );
    
    // bottom right of spade
    context.bezierCurveTo(
        x, y + topHeight * 1.3, // control point 1
        x + width / 2, y + topHeight * 1.3, // control point 2
        x + width / 2, y + topHeight // end point
    );
    
    // top right of spade
    context.bezierCurveTo(
        x + width / 2, y + topHeight / 2, // control point 1
        x, y + topHeight / 2, // control point 2
        x, y // end point
    );
    
    context.closePath();
    context.fill();
    
    // bottom of spade
    context.beginPath();
    context.moveTo(x, y + topHeight);
    context.quadraticCurveTo(
        x, y + topHeight + bottomHeight, // control point
        x - bottomWidth / 2, y + topHeight + bottomHeight // end point
    );
    context.lineTo(x + bottomWidth / 2, y + topHeight + bottomHeight);
    context.quadraticCurveTo(
        x, y + topHeight + bottomHeight, // control point
        x, y + topHeight // end point
    );
    context.closePath();
    context.fillStyle = "black";
    context.fill();
    context.restore();
}

function drawHeart(context, x, y, width, height){
    context.save();
    context.beginPath();
    var topCurveHeight = height * 0.3;
    context.moveTo(x, y + topCurveHeight);
    // top left curve
    context.bezierCurveTo(
        x, y, 
        x - width / 2, y, 
        x - width / 2, y + topCurveHeight
    );
    
    // bottom left curve
    context.bezierCurveTo(
        x - width / 2, y + (height + topCurveHeight) / 2, 
        x, y + (height + topCurveHeight) / 2, 
        x, y + height
    );
    
    // bottom right curve
    context.bezierCurveTo(
        x, y + (height + topCurveHeight) / 2, 
        x + width / 2, y + (height + topCurveHeight) / 2, 
        x + width / 2, y + topCurveHeight
    );
    
    // top right curve
    context.bezierCurveTo(
        x + width / 2, y, 
        x, y, 
        x, y + topCurveHeight
    );
    
    context.closePath();
    context.fillStyle = "red";
    context.fill();
    context.restore();
}

function drawClub(context, x, y, width, height){
    context.save();
    var circleRadius = width * 0.3;
    var bottomWidth = width * 0.5;
    var bottomHeight = height * 0.35;
    context.fillStyle = "black";
    
    // top circle
    context.beginPath();
    context.arc(
        x, y + circleRadius + (height * 0.05), 
        circleRadius, 0, 2 * Math.PI, false
    );
    context.fill();
    
    // bottom right circle
    context.beginPath();
    context.arc(
        x + circleRadius, y + (height * 0.6), 
        circleRadius, 0, 2 * Math.PI, false
    );
    context.fill();
    
    // bottom left circle
    context.beginPath();
    context.arc(
        x - circleRadius, y + (height * 0.6), 
        circleRadius, 0, 2 * Math.PI, false
    );
    context.fill();
    
    // center filler circle
    context.beginPath();
    context.arc(
        x, y + (height * 0.5), 
        circleRadius / 2, 0, 2 * Math.PI, false
    );
    context.fill();
    
    // bottom of club
    context.moveTo(x, y + (height * 0.6));
    context.quadraticCurveTo(
        x, y + height, 
        x - bottomWidth / 2, y + height
    );
    context.lineTo(x + bottomWidth / 2, y + height);
    context.quadraticCurveTo(
        x, y + height, 
        x, y + (height * 0.6)
    );
    context.closePath();
    context.fill();
    context.restore();
}

function drawDiamond(context, x, y, width, height){
    context.save();
    context.beginPath();
    context.moveTo(x, y);
    
    // top left edge
    context.lineTo(x - width / 2, y + height / 2);
    
    // bottom left edge
    context.lineTo(x, y + height);
    
    // bottom right edge
    context.lineTo(x + width / 2, y + height / 2);
    
    // closing the path automatically creates
    // the top right edge
    context.closePath();
    
    context.fillStyle = "red";
    context.fill();
    context.restore();
}