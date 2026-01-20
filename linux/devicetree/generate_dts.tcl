# 1. Abrir el diseño de hardware
hsi::open_hw_design design_1_wrapper.xsa

# 2. Decirle dónde descargamos el repositorio de github (carpeta actual/device-tree-xlnx)
hsi::set_repo_path ./device-tree-xlnx

# 3. Crear el proyecto de software para el MicroBlaze
# OJO: "microblaze_0" es el nombre que tiene en tu Block Design. Si lo cambiaste, cámbialo aquí.
hsi::create_sw_design device-tree -os device_tree -proc microblaze_0

# 4. Generar los archivos en la carpeta "my_dts"
hsi::generate_target -dir ./my_dts

# 5. Cerrar y limpiar
hsi::close_hw_design [hsi::current_hw_design]
exit
