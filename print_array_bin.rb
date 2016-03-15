def print_array_bin(cadena)
	for i in (0..cadena.size-1)
		print cadena[i].to_s(2)
		print " "
		STDOUT.flush
	end
	puts "\n"
end

def print_array_bin_paused(cadena,sleep_time)
	for i in (0..cadena.size-1)
		print cadena[i].to_s(2)
		sleep(sleep_time)
		STDOUT.flush
	end
	puts "\n"
end

def print_array_bin_gets(cadena)
	for i in (0..cadena.size-1)
		print cadena[i].to_s(2)
		pausa = gets.chomp
		STDOUT.flush
	end
	puts "\n"
end

