# a makefile is a special file containing shell commands or rules that you want executed. They compile or recompile a series of files. 

#it contains two parts: the dependency and the actions/commands. 
#the dependency that you create a

#in the make file, you do 4 main things,
# default= define parameters, 
#compile 
#upload = compiled files we want to upload to the microcontroller
#clean= after upload, we clean all files that were created

#name of file
FILENAME   = Length

#port in which the device is connected to
PORT       = /dev/tty11


DEVICE     = atmega328p


PROGRAMMER = linuxgpio

#communication baud rate of the microcontroller
BAUD       = 9600

#baud rate of the microcontroller
COMPILE    = avr-gcc -Wall -Os -mmcu=$(DEVICE)


default: compile upload clean

#compile with avr-gcc
# warning all , O is ptimizer mmcu size bcos mmcu don;'t ahave a lot of memory

# compile to make an output but not make an executable file with the same name 
# compile into elf= the executable file the microcontroller can read and compile it from the name of the file.o
# copy the code to hex format and is achieved by the avr-objcopy 
#  the output will be saved in intel hexadecimal.
# to avoid uploading all the elf file, we need the .text n .data part
#know the size of the code 
compile:
	$(COMPILE) -c $(FILENAME).c -o $(FILENAME).o
	$(COMPILE) -o $(FILENAME).elf $(FILENAME).o
	avr-objcopy -j .text -j .data -O ihex $(FILENAME).elf $(FILENAME).hex
	avr-size --format=avr --mcu=$(DEVICE) $(FILENAME).elf

# upload the code unto the microcontroller. v - verbose - Device to upload to - c=programmer -U flash write
upload:
	avrdude -v -p $(DEVICE) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -U flash:w:$(FILENAME).hex:i

#clean all the files that have been created after uploading the code/flashing the microcontroller
clean:
	rm $(FILENAME).o
	rm $(FILENAME).elf
	rm $(FILENAME).hex
	
	
