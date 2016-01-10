//: Playground - noun: a place where people can play

import UIKit
import Observable


//: 对简单值的使用
var language: Observable<String> = Observable("Objc")
language.afterChange += { print("Changed language from \($0) to \($1)") }
language <- "Swift"
language.value = "Oc"

//: 监听属性的更改

struct Person {
    
    var firstName: Observable<String>
    var lastName: Observable<String>
    
    init(firstName: String, lastName: String) {
        
        self.firstName = Observable(firstName)
        self.lastName = Observable(lastName)
        
    }
    
}

var labelFirstName = UILabel(frame: CGRectMake(0, 0, 0, 0))
var labelLastName = UILabel(frame: CGRectMake(0, 0, 0, 0))

var p = Person(firstName: "peter", lastName: "cook")

p.firstName.afterChange += { old,new in
    
    labelFirstName.text = new
    
}

p.lastName.afterChange += { old,new in
    
    labelLastName.text = new
    
}

//: 也可以监听属性改变前的事件

p.firstName.beforeChange += { old,new in

    print("will Change \(new)")
    
}

p.firstName <- "test"

//: 对 struct 本身也可以监听

var observablePerson = Observable(Person(firstName: "peter", lastName: "cook"))
observablePerson.afterChange += { old,new in

    print("person changed to \(new.firstName.value) \(new.lastName.value)")
    
}

observablePerson.value.firstName <- "swift"



//: 删除监听器

let observer = observablePerson.afterChange += { old, new in
}

observablePerson.afterChange -= observer



//: keypath

struct Address {
    
    var city: Observable<String>
    var street: Observable<String>
    
    init(city: String, street: String) {
        
        self.city = Observable(city)
        self.street = Observable(street)
        
    }
    
}

struct PersonWithAddress {

    var firstName: Observable<String>
    var lastName: Observable<String>
    
    var address: Observable<Address>
    
    init(firstName: String, lastName: String, address: Address) {
        
        self.firstName = Observable(firstName)
        self.lastName = Observable(lastName)
        self.address = Observable(address)
        
    }
   
}

var person = PersonWithAddress(firstName: "peter", lastName: "cook", address: Address(city: "Beijing", street: "Road"))

chain(person.address).to{ $0.street }.afterChange += { old,new in
    
    print("street changed from \(old) to \(new)")
    
}


person.address.value.street <- "New Street"
