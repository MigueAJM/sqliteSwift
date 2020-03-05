//
//  Registro.swift
//  SqLite
//
//  Created by Jose-Omar-GM on 3/4/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import Foundation
class Registro {
    var cve : Int = 0
    var nom : String = ""
    var pso : Double = 0
    var altr : Double = 0.0
    var imc : Double = 0.0
    init(clave : Int, nombre : String, peso : Double, altura : Double, imc : Double) {
        self.cve = clave
        self.nom = nombre
        self.pso = peso
        self.altr = altura
        self.imc = imc
    }
}
