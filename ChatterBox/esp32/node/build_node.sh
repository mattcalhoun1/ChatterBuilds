# python3 "/home/matt/.arduino15/packages/esp32/tools/esptool_py/4.5.1/esptool.py"
#  --chip esp32s3 --port "/dev/ttyACM0" --baud 921600  --before default_reset --after hard_reset write_flash
#  -z --flash_mode dio --flash_freq 80m --flash_size 8MB 
# ------ here are the offsets, they may change in future builds, check arduino upload logs ----
# 0x0 "/tmp/arduino/sketches/7E3AFF40B2BCC9F8AD2876060EAF3DA4/ChatterNode.ino.bootloader.bin" 
# 0x8000 "/tmp/arduino/sketches/7E3AFF40B2BCC9F8AD2876060EAF3DA4/ChatterNode.ino.partitions.bin"
# 0xe000 "/home/matt/.arduino15/packages/esp32/hardware/esp32/2.0.14/tools/partitions/boot_app0.bin"
# 0x10000 "/tmp/arduino/sketches/7E3AFF40B2BCC9F8AD2876060EAF3DA4/ChatterNode.ino.bin" 

# uses QSPI ram

# clean prior build
rm ../chatter_node.bin
rm *.bin
rm *.elf
rm *.map

# copy bin files
cp /home/matt/projects/ChatterNode/build/esp32.esp32.esp32s3/* ./
cp /home/matt/.arduino15/packages/esp32/hardware/esp32/2.0.14/tools/partitions/boot_app0.bin ./

# merge so it will be usable by web installer
esptool.py --chip ESP32-S3 merge_bin --output ../chatter_node.bin --flash_freq keep --flash_mode keep --flash_size 8MB 0x00000 ChatterNode.ino.bootloader.bin 0x8000 ChatterNode.ino.partitions.bin 0xe000 boot_app0.bin 0x10000 ChatterNode.ino.bin

# cleanup
rm *.bin
rm *.elf
rm *.map
