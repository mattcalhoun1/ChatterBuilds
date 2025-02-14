# clean prior build
rm ../chatter_node.bin
rm *.bin
rm *.elf
rm *.map

# copy bin files
cp /home/matt/projects/ChatterNode/build/esp32.esp32.esp32s3/* ./
cp /home/matt/.arduino15/packages/esp32/hardware/esp32/2.0.14/tools/partitions/boot_app0.bin ./

# merge so it will be usable by web installer
esptool.py --chip ESP32-S3 merge_bin --output ../chatter_node.bin --flash_freq keep --flash_mode keep --flash_size 4MB 0x00000 ChatterNode.ino.bootloader.bin 0x8000 ChatterNode.ino.partitions.bin 0xe000 boot_app0.bin 0x10000 ChatterNode.ino.bin

# cleanup
rm *.bin
rm *.elf
rm *.map
