class BitArray
  attr_reader :size
  attr_reader :field
  include Enumerable

  VERSION = "0.0.5"
  ELEMENT_WIDTH = 32

  def initialize(size, field = nil)
    @size = size
    @field = field || Array.new(((size - 1) / ELEMENT_WIDTH) + 1, 0)
  end

  # Set a bit (1/0)
  def []=(position, value)
    if value == 1
      @field[position / ELEMENT_WIDTH] |= 1 << (position % ELEMENT_WIDTH)
    elsif (@field[position / ELEMENT_WIDTH]) & (1 << (position % ELEMENT_WIDTH)) != 0
      @field[position / ELEMENT_WIDTH] ^= 1 << (position % ELEMENT_WIDTH)
    end
  end

  # Read a bit (1/0)
  def [](position)
    @field[position / ELEMENT_WIDTH] & 1 << (position % ELEMENT_WIDTH) > 0 ? 1 : 0
  end

  # Iterate over each bit
  def each(&block)
    @size.times { |position| yield self[position] }
  end

  # Returns the field as a string like "0101010100111100," etc.
  def to_s
    @field.collect{|ea| ("%032b" % ea).reverse}.join[0..@size-1]
  end

  # Returns the total number of bits that are set
  # (The technique used here is about 6 times faster than using each or inject direct on the bitfield)
  def total_set
    @field.inject(0) { |a, byte| a += byte & 1 and byte >>= 1 until byte == 0; a }
  end


  #AQUÍ EL OPERADOR SUMA QUE DA PROBLEMAS


  #Se trata de una suma binaria simple de dos bits con posible acarreo.
  def +(other) #Se espera que other sea un BitArray
    acarreo = 0 #El acarreo de la suma en principio es 0
    suma = BitArray.new(other.size) #La suma se almacena como un BitArray
    
    for i in 0..other.size do
      #A continuación de aplica la fórmula para la suma lógica. 
      #se puede encontrar en internet un esquema de un sumador de 2 bits
      suma[i] = self[i] ^ other[i]  
      acarreo = self[i] & other[i]
      #Si el acarreo resulta ser 1, cambiará variará el resultado
      #de la siguiente operación de bits, pues se suma también
      #el acarreo. 
      if (acarreo == 1 && suma[i+1] != nil) then
        suma[i+1] = suma[i+1] ^ acarreo 
      end
    end
    return suma
  end

  def equal_array!(array)
    for i in (0..self.size) do
      self[i] = array[i]
    end
  end

  def desp!(lado,entra)  #lado puede valer 'l' o 'r' y entra puede valer 0 o 1
                        #lado indica por donde entrará el bit 
    if (lado == 'l') then
      if (entra == 0) then
        copia = []
        sale = self[self.size-1]
        for i in(0..self.size-2) do
          copia[i] = self[i]
        end
        copia = [0] + copia
        self.equal_array!(copia)
        return sale
      end

      if (entra == 1) then
        copia = []
        sale = self[self.size-1]
        for i in(0..self.size-2) do
          copia[i] = self[i]
        end
        copia = [1] + copia
        self.equal_array!(copia)
        return sale
      end
    end

    if (lado == 'r') then

      if (entra == 0)
        copia = []
        sale = self[0]
        for i in(1..self.size) do
          if (i < self.size) then
            copia[i-1] = self[i]
          end
        end
        copia.push(0)
        self.equal_array!(copia)
        return sale
      end

      if (entra == 1)
        copia = []
        sale = self[0]
        for i in(1..self.size) do
          if (i < self.size) then
            copia[i-1] = self[i]
          end
        end
        copia.push(1)
        self.equal_array!(copia)
        return sale
      end
    end
  end
end





