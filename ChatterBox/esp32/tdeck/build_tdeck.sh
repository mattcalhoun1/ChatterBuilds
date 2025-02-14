# python3 "/home/matt/.arduino15/packages/esp32/tools/esptool_py/4.5.1/esptool.py"
# --chip esp32s3 --port "/dev/ttyACM0" --baud 921600 
# --before default_reset --after hard_reset write_flash 
# -z --flash_mode dio --flash_freq 80m --flash_size 16MB
# 0x0 "/tmp/arduino/sketches/B1F79DF924A5523C4E2762AADE194DAC/ChatterTDeck.ino.bootloader.bin"
# 0x8000 "/tmp/arduino/sketches/B1F79DF924A5523C4E2762AADE194DAC/ChatterTDeck.ino.partitions.bin"
# 0xe000 "/home/matt/.arduino15/packages/esp32/hardware/esp32/2.0.14/tools/partitions/boot_app0.bin"
# 0x10000 "/tmp/arduino/sketches/B1F79DF924A5523C4E2762AADE194DAC/ChatterTDeck.ino.bin" 

# clean prior build
rm ../chatter_tdeck.bin
rm *.bin
rm *.elf
rm *.map

# copy binaries
cp /home/matt/projects/Lilygo/ChatterTDeck/build/esp32.esp32.esp32s3/* ./
cp /home/matt/.arduino15/packages/esp32/hardware/esp32/2.0.14/tools/partitions/boot_app0.bin ./

# merge so it will be usable by web installer
esptool.py --chip ESP32-S3 merge_bin -o ../chatter_tdeck.bin --flash_freq keep --flash_mode keep --flash_size 16MB 0x00000 ChatterTDeck.ino.bootloader.bin 0x8000 ChatterTDeck.ino.partitions.bin 0xe000 boot_app0.bin 0x10000 ChatterTDeck.ino.bin

# cleanup
rm *.bin
rm *.elf
rm *.map
