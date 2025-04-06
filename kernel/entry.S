        # qemu loads the kernel at address 0x80000000  
        # and instructs each CPU core (hart) to begin execution from there.  
        # The linker script (kernel.ld) ensures that the following code  
        # is placed at this address.
        # entry.S is placed on 0x80000000 address and that is the first KERNBASE(First Physical address)
        

.section .text
.global _entry
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + (hartid * 4096) 
        # for first cpu sp would be = stack0 + 4096
        # Top of the stack because in RISC-V stack grows down
        la sp, stack0   # loading stack0 address to sp 
        li a0, 1024*4   
        csrr a1, mhartid
        addi a1, a1, 1
        mul a0, a0, a1  # a0 = (mhartid+1)*(4096)
        add sp, sp, a0  # sp = stack0(sp) + a0
        # jump to start() in start.c
        call start
spin:
        j spin
