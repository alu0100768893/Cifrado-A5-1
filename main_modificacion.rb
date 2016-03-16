# encoding: utf-8
require_relative "a5_modificacion.rb"
require_relative "print_array_bin.rb"
require 'scanf'

#print "Introduzca el texto a cifrar:"
#puts ""
#texto_plano = gets.chomp

#En el ejemplo de la práctica:
string19 = "1001000100011010001"
string22 = "0101100111100010011010"
string23 = "10111100110111100001111"
=begin
print "Introduzca la semilla para el registro de 19: "
puts ""
string19 = gets.chomp
print "Introduzca la semilla para el registro de 22: "
puts ""
string22 = gets.chomp
print "Introduzca la semilla para el registro de 23: "
puts ""
string23 = gets.chomp
=end

#Convertimos de string a array de enteros
array19 = string19.scanf("%1d" * 19)
array22 = string22.scanf("%1d" * 22)
array23 = string23.scanf("%1d" * 23)
array19 = array19.reverse!
array22 = array22.reverse!
array23 = array23.reverse!
for i in (0..21) do
    array19.push(array22[i])
end
for i in (0..22) do
    array19.push(array23[i])
end
array64 = array19
bits64 = BitArray.new(64)
print "Array64: #{array64}\n"
bits64.equal_array!(array64)
a5_mod = A51.new(bits64)

#-----------------------------------------------------------------|
#-----------------------------------------------------------------|
#A partir de aquí lo comentaré todo porque no es necesario para la|
#modificación de la práctica, ya que la modificación consta de la |
#inicialización de los registros.                                 |
#-----------------------------------------------------------------|
#-----------------------------------------------------------------|
#Creamos los BitArray
#bits19 = BitArray.new(19)
#bits22 = BitArray.new(22)
#bits23 = BitArray.new(23)

#Pasamos los datos Array a BitArray
#bits19.equal_array!(array19)
#bits22.equal_array!(array22)
#bits23.equal_array!(array23)

#Creamos e inicializamos la variable a5 con la semilla:
#a5 = A51.new(bits19,bits22,bits23)

#variable que contendrá la secuencia cifrante
#key_stream = []

#Comenzamos a generar la secuencia cifrante de manera ilustrativa
#for i in (0..texto_plano.size-1) do
=begin
for i in (0..10) do
    print "Etapa "
    print i
    puts ":"
    key_stream[i] = a5.keygen_steps(i)
end
puts "**************************************************************"
print "Secuencia cifrante: #{key_stream}\n"
puts "**************************************************************"
puts ""
STDOUT.flush
=end
#encriptado = a5.encriptar(texto_plano,key_stream)
#print_array_bin(encriptado)

#desencriptado = a5.desencriptar(encriptado,key_stream)
#print_array_bin(desencriptado)
