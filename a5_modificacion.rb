# encoding: utf-8
require_relative "BitArray.rb"

#Debemos tener en cuenta que en las variables empezamos por el cero,
#cuando en el algoritmo empezamos por el mayor, el polinomio va de
#mayor a menor, por ello debemos saber la equivalencia de los índices
#@s19:
#0--1--2--3--4--5--6--7--8--9-10-11-12-13-14-15-16-17-18
#18-17-16-15-14-13-12-11-10-9--8--7--6--5--4--3--2--1--0
#@s22:
#0--1--2--3--4--5--6--7--8--9--10-11-12-13-14-15-16-17-18-19-20-21
#21-20-19-18-17-16-15-14-13-12-11-10-9--8--7--6--5--4--3--2--1--0
#@s23:
#0--1--2--3--4--5--6--7--8--9--10-11-12-13-14-15-16-17-18-19-20-21-22
#22-21-20-19-18-17-16-15-14-13-12-11-10-9--8--7--6--5--4--3--2--1--0
#--------------------------------------------------------------------
#En esta modificación la semilla(semilla64) viene en el orden deseado,
#es decir, al introducirla se le ha dado la vuelta a cada una de las
#componenetes de la semilla antes de unirlas en una sola, para así
#poder tratar la semilla grande de la manera adecuada sin necesidad
#de calcular en que posición se encuentra.
#las semillas @s19, @s22 y @s23 las sigo tratando de la manera anterior,
#con las equivalencias de números de las tablas de arriba y desplazando
#hacia la izquierda, entrando el bit correspondiente por la derecha.

class A51

  attr_reader :s19,:s22,:s23

  #En este initialize es donde se encuentra la modificación de la práctica.
  #La modificación consiste en inicializar los registros a partir de la
  #semilla dada, en un bucle desde 0..63(porque el tamaño de la semilla es
  #64) realizamos el cálculo de cada bit de entrada de manera normal con
  #el añadido de que debemos incluir en el XOR el elemento de la clave
  #que tenga índice igual al número de iteración en la que estemos.
  #Teniendo en cuenta que los tres registros comienzan inicializados a 0.
  def initialize(semilla64)
    @s19 = BitArray.new(19)
    @s22 = BitArray.new(22)
    @s23 = BitArray.new(23)
    @s64 = semilla64
    for i in (0..63) do
      entrada19 = @s19[5] ^ @s19[2] ^ @s19[1] ^ @s19[0] ^ @s64[i]
      entrada22 = @s22[1] ^ @s22[0] ^ @s64[i]
      entrada23 = @s23[15] ^ @s23[2] ^ @s23[1] ^ @s23[0] ^ @s64[i]
      @s19.desp!('r',entrada19)
      @s22.desp!('r',entrada22)
      @s23.desp!('r',entrada23)
      print "paso #{i}:"
      puts ""
      puts @s19.to_s
      puts @s22.to_s
      puts @s23.to_s
    end
  end

  def mostrar_semilla
    puts @s19.to_s
    puts @s22.to_s
    puts @s23.to_s
  end

  def encriptar(texto_plano,key_stream)
    encriptado=[]
    for i in 0..texto_plano.size-1 do
      encriptado[i] = texto_plano[i] ^ key_stream[i]
    end
    return encriptado
  end

  def desencriptar(texto_encriptado,key_stream)
    encriptar(texto_encriptado,key_stream)
  end

  def keygen_steps(iteracion)
    #Debemos tener en cuenta que la primera vez no hay que desplazar
    #sino que hay que realizar el XOR directamente con los tres bits
    #más significativos.
    #Luego mostramos los resultados a modo ilustrativo
    if iteracion == 0 then
      puts "Valores de los registros: "
      puts "R1: " + @s19.to_s
      puts "R2: " + @s22.to_s
      puts "R3: " + @s23.to_s
      puts "Bits de control: #{@s19[10]},#{@s22[11]},#{@s23[12]}"
      puts "Bit cifrante: #{@s19[0] ^ @s22[0] ^ @s23[0]}"
      puts "----------------------------------------------"
      puts " "
      puts " "
      puts " "
      puts " "
      return @s19[0] ^ @s22[0] ^ @s23[0]
    end

    #Una vez realizada la primera iteración continuamos, calculamos
    #todos los elementos necesarios en el algoritmo, como el XOR de
    #cada polinomio y la mayoría entre los bits de control.
    #Luego desplazamos los registros según los bits mayoría y se
    #calcula el siguiente bit cifrante.
    r19 = @s19[5] ^ @s19[2] ^ @s19[1] ^ @s19[0]
    r22 = @s22[1] ^ @s22[0]
    r23 = @s23[15] ^ @s23[2] ^ @s23[1] ^ @s23[0]

    #Esta es la función mayoría, donde calculamos un AND entre cada uno de los
    #bits de entrada a dicha función(posiciones 9, 11 y 11 de los polinomios)
    #y luego un XOR entre los resultados de los ANDs, así obtendremos el bit
    #mayoría entre los 3:
    mayoria = (@s19[10] & @s22[11]) ^ (@s19[10] & @s23[12]) ^ (@s22[11] & @s23[12])

    #Comprobamos si el bit de control es igual al bit mayoría entre los 3
    #bits de control, si es así desplazamos(hacia la izquierda) e
    #introducimos(por la derecha) el resultado del XOR según el polinomio
    #adecuado:
    if @s19[10] == mayoria
      @s19.desp!('r',r19)
    end
    if @s22[11] == mayoria
      @s22.desp!('r',r22)
    end
    if @s23[12] == mayoria
      @s23.desp!('r',r23)
    end
    #Y finalmente mostramos los resultados a modo ilustrativo
    puts "Valores de los registros: "
    puts "R1: " + @s19.to_s
    puts "R2: " + @s22.to_s
    puts "R3: " + @s23.to_s
    puts "Bits de control: #{@s19[10]},#{@s22[11]},#{@s23[12]}"
    puts "Bit cifrante: #{@s19[0] ^ @s22[0] ^ @s23[0]}"
    puts "----------------------------------------------"
    puts " "
    puts " "
    puts " "
    puts " "
    return @s19[0] ^ @s22[0] ^ @s23[0]
  end
end
