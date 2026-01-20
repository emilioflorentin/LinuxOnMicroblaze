# 1. Conectar
connect

# 2. Seleccionar la FPGA Zynq y cargar Bitstream
puts "---> Seleccionando FPGA..."
targets -set -nocase -filter {name =~ "xc7z*"}

puts "---> Cargando Bitstream..."
# RUTA BITSTREAM (Verifica que sea correcta)
fpga -file "/home/florentin/Documentos/UNIVERSIDAD/SEI/PRACTICAS_SEI/PROYECTO/project_1/project_1.runs/impl_1/design_1_wrapper.bit"

# =================================================================
# 3.5. INICIALIZACIÓN ROBUSTA DEL ZYNQ PS
# =================================================================
puts "---> Inicializando PS (ARM)..."
targets -set -filter {name =~ "ARM*#0"}

# 1. Paramos el ARM por si acaso
stop
rst -processor

# 2. Cargamos la configuración
source "/home/florentin/Documentos/UNIVERSIDAD/SEI/PRACTICAS_SEI/PROYECTO/design_1_wrapper_1/export/design_1_wrapper_1/hw/ps7_init.tcl"

# 3. Ejecutamos la secuencia SAGRADA
ps7_init
ps7_post_config

# TRUCO: A veces los "Level Shifters" necesitan un empujón extra
# para conectar la FPGA con la DDR. Esperamos un poco.
after 1000
puts "---> ¡Zynq Listo y Puentes Abiertos!"
# =================================================================
puts "---> ¡Relojes activos!"
# =================================================================

# 4. Seleccionar el MicroBlaze (Ahora ya tiene reloj y funcionará)
after 1000 
puts "---> Buscando MicroBlaze..."
targets -set -filter {name =~ "MicroBlaze*#0"}

# 5. Resetear SOLO el procesador
rst -processor

# 6. Cargar Linux en la DDR
puts "---> Cargando Linux en DDR..."
# RUTA SIMPLEIMAGE
dow -data "/home/florentin/Documentos/UNIVERSIDAD/SEI/PRACTICAS_SEI/PROYECTO/linux/buildroot/output/images/simpleImage.microblaze" 0x10000000
rwr pc 0x10000000

# 7. Cargar Bootloader en BRAM
puts "---> Cargando Bootloader en BRAM..."
# RUTA ELF (Trampolín)
dow "/home/florentin/Documentos/UNIVERSIDAD/SEI/PRACTICAS_SEI/PROYECTO/linux_microblaze_3/Debug/linux_microblaze_3.elf"

# 8. Arrancar
puts "Abriendo consola y Arrancando..."
jtagterminal
con
