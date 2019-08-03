
class Pixel {
    constructor(x, y, k, temp){
        this.x = x
        this.y = y
        this.temp = temp
        this.canChange = true
        this.k = k
    }
    get_color() {
        return color(this.temp / 3,this.temp / 3,this.temp / 3)
    }
}