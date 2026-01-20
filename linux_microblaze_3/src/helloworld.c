#include <xil_io.h>
#include <xil_printf.h>
#include <xil_cache.h>
#include <xil_exception.h>
#include "platform.h"

int main()
{
    init_platform();

    // Mensaje corto para ahorrar espacio en .rodata
    print("Bootloader: Saltando a Linux...\n\r");

    // --- LIMPIEZA CRÍTICA ---
    // Sin esto, Linux crashea.
    Xil_DCacheDisable();
    Xil_ICacheDisable();
    Xil_ExceptionDisable();

    // Pequeña espera para asegurar que el UART termine de enviar
    for(volatile int k=0; k<50000; k++);

    // --- SALTO ---
    void *targetAddr = (void*)0x10000000;

    __asm__ volatile (
        "bra %0 \n\t"
        "nop    \n\t"
        :
        : "r" (targetAddr)
        : "memory"
    );

    return 0;
}
