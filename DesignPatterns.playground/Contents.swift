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
    var radius: Double
    {
        return sqrt(pow(width / 2, 2) * 2)
    }
}


let hole = RoundHole(radius: 5.0)
for i in 5...10
{
    let peg = SqurePeg(width: Double(i))
    let fit = hole.pegFits(peg)
    print("width:\(peg.width), fit:\(fit)")
}



//Iterator
struct NovellasCollection<T>
{
    let novellas: [T]
}


extension NovellasCollection: SequenceType
{
    typealias Generator = AnyGenerator<T>
    
    
    func generate() -> AnyGenerator<T>
    {
        var i = 0
        return anyGenerator{ return i >= self.novellas.count ? nil : self.novellas[i++] }
    }
}


let greatNovellas = NovellasCollection(novellas: ["Mist", "Abc"])
for novella in greatNovellas
{
    print("I've read:\(novella)")
}



//Observer
protocol PropertyObserver: class
{
    func willChangePropertyName(propertyName: String, newPropertyValue: AnyObject?)
    func didChangePropertyName(propertyName: String, oldPropertyValue: AnyObject?)
}


class TestChambers
{
    weak var observer: PropertyObserver?
    
    var testChamberNumber: Int = 0
    {
        willSet{
            observer?.willChangePropertyName("testChamberNumber", newPropertyValue: newValue)
        }
        didSet{
            observer?.didChangePropertyName("testChamberNumber", oldPropertyValue: oldValue)
        }
    }
}


class Observer: PropertyObserver
{
    func willChangePropertyName(propertyName: String, newPropertyValue: AnyObject?)
    {
        if newPropertyValue as? Int == 1
        {
            print("newValue: \(newPropertyValue!)")
        }
    }
    
    
    func didChangePropertyName(propertyName: String, oldPropertyValue: AnyObject?)
    {
        if oldPropertyValue as? Int == 0
        {
            print("oldValue: \(oldPropertyValue!)")
        }
    }
}


var observerInstance = Observer()
var testChambers = TestChambers()
testChambers.observer = observerInstance
testChambers.testChamberNumber = 1



//State
class Context
{
    private var state: State = UnauthorizedState()
    
    
    var isAuthorized: Bool
    {
        return state.isAuthorized(self)
    }
    
    var userId: String?
    {
        return state.userId(self)
    }
    
    
    func changeStateToAuthorized(userId: String)
    {
        state = AuthorizedState(userId: userId)
    }
    
    
    func changeStateToUnauthorized()
    {
        state = UnauthorizedState()
    }
}


protocol State
{
    func isAuthorized(context: Context) -> Bool
    func userId(context: Context) -> String?
}


class UnauthorizedState: State
{
    func isAuthorized(context: Context) -> Bool
    {
        return false
    }
    
    
    func userId(context: Context) -> String?
    {
        return nil
    }
}


class AuthorizedState: State
{
    let userId: String
    
    
    init(userId: String)
    {
        self.userId = userId
    }
    
    
    func isAuthorized(context: Context) -> Bool
    {
        return true
    }
    
    
    func userId(context: Context) -> String?
    {
        return userId
    }
}


let context = Context()
context.isAuthorized
context.userId
context.changeStateToAuthorized("admin")
context.isAuthorized
context.userId
context.changeStateToUnauthorized()
context.isAuthorized
context.userId



//Builder
class DeathStarBuilder
{
    var x: Double?
    var y: Double?
    var z: Double?
    
    typealias BuilderClosure = (DeathStarBuilder) -> ()
    
    
    init(builderClosure: BuilderClosure)
    {
        builderClosure(self)
    }
}


struct DeathStar: CustomStringConvertible
{
    let x: Double
    let y: Double
    let z: Double
    
    
    init?(builder: DeathStarBuilder)
    {
        if let x = builder.x, y = builder.y, z = builder.z
        {
            self.x = x
            self.y = y
            self.z = z
        }
        else
        {
            return nil
        }
    }
    
    
    var description: String
    {
        return "Death Star at (x:\(x) y:\(y) z:\(z))"
    }
}


let empire = DeathStarBuilder{  builder in
    builder.x = 0.1
    builder.y = 0.2
    builder.z = 0.3
}
let deathStar = DeathStar(builder: empire)



//Prototype
class ChungasRevengDisplay
{
    var name: String?
    let font: String
    
    
    init(font: String)
    {
        self.font = font
    }
    
    
    func clone() -> ChungasRevengDisplay
    {
        return ChungasRevengDisplay(font: self.font)
    }
}

let prototype = ChungasRevengDisplay(font: "GotanProject")

let Philippe = prototype.clone()
Philippe.name = "Philippe"

let ChristoPh = prototype.clone()
ChristoPh.name = "ChristoPh"

let Eduardo = prototype.clone()
Eduardo.name = "Eduardo"



//Singleton
class DeathStarSuperlaser
{
    static let sharedInstance = DeathStarSuperlaser()
    
    
    private init() {}
}

let laser = DeathStarSuperlaser.sharedInstance



//Adapter
protocol OlderDeathStartSuperLaserAiming
{
    var angleV: NSNumber { get }
    var angleH: NSNumber { get }
}


struct DeathStarSuperlaserTarget
{
    let angleHoriztonal: Double
    let angleVeritical: Double
    
    
    init(angleHoriztonal: Double, angleVeritical: Double)
    {
        self.angleHoriztonal = angleHoriztonal
        self.angleVeritical = angleVeritical
    }
}


struct OldDeathStarSuperlaserTarget: OlderDeathStartSuperLaserAiming
{
    private let target: DeathStarSuperlaserTarget
    
    var angleH: NSNumber {
        return target.angleHoriztonal
    }
    
    var angleV: NSNumber {
        return target.angleVeritical
    }
    
    
    init(_ target: DeathStarSuperlaserTarget)
    {
        self.target = target
    }
}


let target = DeathStarSuperlaserTarget(angleHoriztonal: 14.0, angleVeritical: 12.0)
let oldFormat = OldDeathStarSuperlaserTarget(target)

oldFormat.angleH
oldFormat.angleV



//Bridge
protocol Appliance
{
    func run()
}


protocol Switch
{
    var appliance: Appliance {get set}
    
    func turnOn()
}


class RemoteControl: Switch
{
    var appliance: Appliance
    
    
    init(appliance: Appliance)
    {
        self.appliance = appliance
    }
    
    
    func turnOn()
    {
        self.appliance.run()
    }
}


class TV: Appliance
{
    func run()
    {
        print("tv turned on")
    }
}


class VacuumCleaner: Appliance
{
    func run()
    {
        print("vacuum cleaner turned on")
    }
}


var tvRemoteControl = RemoteControl(appliance: TV())
tvRemoteControl.turnOn()

var fancyVacuumCleanerRemoteControl = RemoteControl(appliance: VacuumCleaner())
fancyVacuumCleanerRemoteControl.turnOn()



//Composite
protocol Shape
{
    func draw(fillColor: String)
}


class Square: Shape
{
    func draw(fillColor: String)
    {
        print("Drawing s Square with color \(fillColor)")
    }
}


class Circle: Shape
{
    func draw(fillColor: String)
    {
        print("Drawing a Circle with color \(fillColor)")
    }
}


class Whiteboard: Shape
{
    lazy var shapes = [Shape]()
    
    init(_ shapes: Shape...)
    {
        self.shapes = shapes
    }
    
    func draw(fillColor: String)
    {
        for shape in shapes
        {
            shape.draw(fillColor)
        }
    }
}


var whiteBoard = Whiteboard(Circle(), Square())
whiteBoard.draw("Red")



//Facade
class Eternal
{
    class func setObject(value: AnyObject!, forKey defaultName: String!)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: defaultName)
        defaults.synchronize()
    }
    
    
    class func objectForKey(defaultName: String!) -> AnyObject!
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(defaultName)
    }
}

Eternal.setObject("Disconnect me. I'd rather be nothing", forKey: "Bishop")
Eternal.objectForKey("Bishop")



//Protection Proxy
protocol DoorOperator
{
    func openDoors(door: String) -> String
}


class HAL9000: DoorOperator
{
    func openDoors(door: String) -> String
    {
        return "HAL9000: Affirmative, Dave. I read you. Opened \(door)"
    }
}


class CurrentComputer: DoorOperator
{
    private var computer: HAL9000!
    
    
    func authenticateWithPassword(pass: String) -> Bool
    {
        guard pass == "pass" else {
            return false
        }
        
        computer = HAL9000()
        
        return true
    }
    
    func openDoors(door: String) -> String
    {
        guard computer != nil else {
            return "Access Denied. I'm afraid I can't do that."
        }
        
        return computer.openDoors(door)
    }
}


let computer = CurrentComputer()
let doors = "Pod Bay Doors"
computer.openDoors(doors)

computer.authenticateWithPassword("pass")
computer.openDoors(doors)



//Virtual Proxy
protocol HEVSuitMedicalAid
{
    func administerMorphine() -> String
}


class HEVSuit: HEVSuitMedicalAid
{
    func administerMorphine() -> String
    {
        return "Morphine administered."
    }
}


class HEVSuitHumanInterface: HEVSuitMedicalAid
{
    lazy private var physicalSuit = HEVSuit()
    
    func administerMorphine() -> String
    {
        return physicalSuit.administerMorphine()
    }
}


let humanInterface = HEVSuitHumanInterface()
humanInterface.administerMorphine()


