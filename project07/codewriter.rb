require 'erb'
class Code_Writer
	attr_accessor :out, :command, :segment, :value, :jump_count
	def initialize(output)
		@out = File.new(output,'w')
		@jump_count = 0 #I always count from zero now, it confuses the pants off people around me, useful at parties
	end

	def setFileName(in_file_name)
	end

	def write_arithmetic(command)
		#puts "In write_arithmetic #{command}" #part of a debug at one point
		@command = command
		command += ".erb"
		begin
			f1 = File.new(command, "r")
			@out.write("//#{@command}\n")
		rescue => e
			puts e
			exit
		end
		for i in f1
			erb = ERB.new(i)
			@out.write erb.result(binding)
		end
		@out.write "\n" #to make sure next line starts on a new line, had problems iwth that
		@jump_count += 1 if increase_jump?
	end

	def increase_jump?
		/eq|gt|lt/.match(@command)
	end

	def write_push_pop(command, seg, arg)
		#puts "In write_push_pop #{command} #{seg} #{arg}" #same here, look at write_arithmetic
		file = command + "_" + seg + ".erb"
		@value = arg
		begin
			f1 = File.new(file, "r")
			@out.write("//#{command} #{seg} #{arg}\n")
		rescue => e
			puts e
			exit
		end
		for i in f1
			erb = ERB.new(i)
			@out.write erb.result(binding)
		end
		@out.write "\n"
	end
end