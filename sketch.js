let nodes = []
const width = 50;
const height = 50;

function getChangeTemp(n1, n2) {
    return -n1.k * (n1.temp - n2.temp)
}

function updateNodes() {
    let tmp = nodes.slice(0);

    for (let x = 1; x < width-1; x++) {
        for (let y = 1; y < height-1; y++) {
            let dx = 0;
            let dy = 0;
            
            let node = nodes[x][y]

            dx += getChangeTemp(node, nodes[x+1][y])
            dx += getChangeTemp(node, nodes[x-1][y])
            dy += getChangeTemp(node, nodes[x][y+1])
            dy += getChangeTemp(node, nodes[x][y-1])
            
            tmp[x][y].temp = (node.temp + dx + dy)
        }
    }
    nodes = tmp
}

function setup() {
    for (let x = 0; x < width; x++) {
        nodes.push([])
        for (let y = 0; y < height; y++) {
            nodes[x].push(new Pixel(x,y,0.1,0));
        }
    }
    for (let x = 0; x < width; x++) {
        nodes[x][0].temp = 600
        nodes[x][width-1].temp = 600
    }
    for (let y = 0; y < height; y++) {
        nodes[0][y].temp = 600
        nodes[height-1][y].temp = 600
    }
    for (let y = 1; y < height/2; y++) {
        for (let x = 1; x < width; x++) {
            nodes[x][y].temp = 600
        }
    }
    createCanvas(width, height);
    pixelDensity(2)
  }
  
  function draw() {
    let d = pixelDensity()
    loadPixels();
    
    for (let x = 0; x < width; x++) {
        for (let y = 0; y < height; y++) {

            for (let i = 0; i < d; i++) {
                for (let j = 0; j < d; j++) {
                  index = 4 * ((y * d + j) * width * d + (x * d + i));
                  let color = nodes[x][y].get_color()
                  pixels[index] = red(color);
                  pixels[index+1] = green(color);
                  pixels[index+2] = blue(color);
                  pixels[index+3] = alpha(color);
                }
              }
        }
    }

    updatePixels();
    updateNodes();
  }