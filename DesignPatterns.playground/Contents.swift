//: Playground - noun: a place where people can play

import Foundation


//Chain Of Responsibility
class MoneyPile
{
    let value: Int
    var quantity: Int
    var nextPile: MoneyPile?
    
    init(value: Int, quantity: Int, nextPile: MoneyPile?)
    {
        self.value = value
        self.quantity = quantity
        self.nextPile = nextPile
    }
    
    
    func canWithdraw(var v: Int) -> Bool
    {
        func canTakeSomeBill(want: Int) -> Bool
        {
            return (want / self.value) > 0
        }
        
        var q = self.quantity
        while canTakeSomeBill(v)
        {
            if q == 0
            {
                break
            }
            
            v -= self.value
            q -= 1
        }
        
        if v == 0
        {
            return true
        }
        else if let next = self.nextPile
        {
            return next.canWithdraw(v)
        }
        
        return false
    }
}


class ATM
{
    private let hundred: MoneyPile
    private let fifty: MoneyPile
    private let twenty: MoneyPile
    private let ten: MoneyPile
    
    private var startPile: MoneyPile
    {
        return self.hundred
    }
    
    
    init(hundred: MoneyPile, fifty: MoneyPile, twenty: MoneyPile, ten: MoneyPile)
    {
        self.hundred = hundred
        self.fifty = fifty
        self.twenty = twenty
        self.ten = ten
    }
    
    
    func canWithdraw(value: Int) -> String
    {
        return "Can withdraw: \(self.startPile.canWithdraw(value))"
    }
}


let ten = MoneyPile(value: 10, quantity: 6, nextPile: nil)
let twenty = MoneyPile(value: 20, quantity: 2, nextPile: ten)
let fifty = MoneyPile(value: 50, quantity: 2, nextPile: twenty)
let hundred = MoneyPile(value: 100, quantity: 1, nextPile: fifty)

var atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
atm.canWithdraw(310)
atm.canWithdraw(100)
atm.canWithdraw(165)
atm.canWithdraw(30)



//Command
class Light
{
    func turnOn()
    {
        print("The light is on")
    }
    
    
    func turnOff()
    {
        print("The light is off")
    }
}


class LightSwiftFP
{
    var queue: Array<(Light) -> ()> = []
    
    
    func addCommand(command: (Light) -> ())
    {
        queue.append(command)
    }
    
    
    func execute(light: Light)
    {
        for command in queue
        {
            command(light)
        }
    }
}


class ClientFP
{
    static func pressSwitch()
    {
        let lamp = Light()
        let flipUp = { (light: Light) -> () in light.turnOn() }
        let flipDown = { (light: Light) -> () in light.turnOff() }
        
        let lightSwitchFP = LightSwiftFP()
        lightSwitchFP.addCommand(flipUp)
        lightSwitchFP.addCommand(flipDown)
        lightSwitchFP.addCommand(flipUp)
        lightSwitchFP.addCommand(flipDown)
        
        lightSwitchFP.execute(lamp)
    }
}

ClientFP.pressSwitch()



//Strategy
let add = { (first: Int, second: Int) -> Int in
    return first + second
}

let multiply = { (first: Int, second: Int) -> Int in
    return first * second
}

class ContextFP
{
    let strategy: (Int, Int) -> Int
    
    
    init(strategy: (Int, Int) -> Int)
    {
        self.strategy = strategy
    }
    
    
    func use(first: Int, second: Int) -> Int
    {
        return self.strategy(first, second)
    }
}

let contextFP = ContextFP(strategy: add)
contextFP.use(3, second: 7)



//Abstract Factory
protocol Product
{
    var brand: String { get }
    var name: String { get }
}
protocol Phone: Product {}
protocol Pad: Product {}


class ApplePhone: Phone
{
    var brand: String
    {
        return "Apple"
    }
    
    var name: String
    
    
    init(name: String)
    {
        self.name = name
    }
}


class SamsungPhone: Phone
{
    var brand: String
        {
            return "Samsung"
    }
    
    var name: String
    
    
    init(name: String)
    {
        self.name = name
    }
}


class ApplePad: Pad
{
    var brand: String
        {
            return "Apple"
    }
    
    var name: String
    
    
    init(name: String)
    {
        self.name = name
    }
}


class SamsungPad: Pad
{
    var brand: String
        {
            return "Samsung"
    }
    
    var name: String
    
    
    init(name: String)
    {
        self.name = name
    }
}


func createProductWithType(type: String)(brand: String)(name: String) -> Product?
{
    switch (type, brand)
    {
    case ("Phone", "Apple"):
        return ApplePhone(name: name)

    case ("Pad", "Apple"):
        return ApplePad(name: name)
    
    case ("Phone", "Samsung"):
        return SamsungPhone(name: name)
    
    case ("Pad", "Samsung"):
        return SamsungPad(name: name)
    
    default:
        return nil
    }
}


let createApplePhone = createProductWithType("Phone")(brand: "Apple")
print(createApplePhone(name: "iPhone 6S"))



//Adapter
protocol Circularity
{
    var radius: Double { get }
}


class RoundPeg: Circularity
{
    let radius: Double
    
    
    init(radius: Double)
    {
        self.radius = radius
    }
}


class RoundHole: Circularity
{
    let radius: Double
    
    
    init(radius: Double)
    {
        self.radius = radius
    }
    
    
    func pegFits(peg: Circularity) -> Bool
    {
        return peg.radius <= radius
    }
}


class SqurePeg
{
    let width: Double
    
    
    init(width: Double)
    {
        self.width = width
    }
}


extension SqurePeg: Circularity
{
    var radius: Double {
        get {
            return sqrt(pow(width / 2, 2) * 2)
        }
    }
}


let hole = RoundHole(radius: 5.0)
for i in 5...10
{
    let peg = SqurePeg(width: Double(i))
    let fit = hole.pegFits(peg)
    print("width:\(peg.width), fit:\(fit)")
}





































