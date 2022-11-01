using JuMP
using GLPK


# Avem un rucsac in care putem introduce maxim 15 KG. Avem 6 tipuri de cutii: Verde/12Kg/4$; Portocaliu/1Kg/1$; Albastru/2kg/2$, Gri/1kg/2$; Galben/4kg/10$. 
       
# Versiunea 1: Avem un singur exemplar din fiecare cutie. Valoarea maxima care poate fi introdusa in rucsac fara sa depasim limita de kg:

model = Model(GLPK.Optimizer)

@variable(model, verde, Bin) 
@variable(model, portocaliu, Bin)
@variable(model, albastru, Bin)
@variable(model, gri, Bin)
@variable(model, galben, Bin)

# Greutatea fiecarui obiect

@constraint(model, weight,
    verde * 12 + portocaliu * 1 + albastru * 2 + gri * 1 + galben * 4 <= 15 # 15 este greutatea maxima care incape in ghiozdan
)

# Valoarea fiecarui obiect

@objective(model, Max,
    verde * 4 + portocaliu * 1 + albastru * 2 + gri * 2 + galben * 10
)

optimize!(model)

boxes = [verde, portocaliu, albastru, gri, galben]

for box in boxes
    println(box, " = " , value(box))
    
end
println("Greutatea totala = $(value(weight))")
println("Valarea in dolari = $(objective_value(model))")


# Versiunea 2: Avem exemplare infinite


model = Model(GLPK.Optimizer)


@variable(model, verde >= 0, Int) 
@variable(model, portocaliu >= 0, Int)
@variable(model, albastru >= 0, Int)
@variable(model, galben >= 0, Int)
@variable(model, gri >= 0, Int)

# Greutatea fiecarui obiect

@constraint(model, weight,
    verde * 12 + portocaliu * 1 + albastru * 2 + gri * 1 + galben * 4 <= 15
)

# Valoarea fiecarui obiect

@objective(model, Max,
    verde * 4 + portocaliu * 1 + albastru * 2 + gri * 2 + galben * 10
)

optimize!(model)


boxes = [verde, portocaliu, albastru, gri, galben]

for box in boxes
    println(box, " = " , value(box))
    
end
println("Greutatea totala = $(value(weight))")
println("Valarea in dolari = $(objective_value(model))")