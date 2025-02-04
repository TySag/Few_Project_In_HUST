/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* The TRAPHANDLER macro defines a globally-visible function for handling
 * a trap.  It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 */ 
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(routine_divide, T_DIVIDE)
TRAPHANDLER_NOEC(routine_debug, T_DEBUG)
TRAPHANDLER_NOEC(routine_nmi, T_NMI)
TRAPHANDLER_NOEC(routine_brkpt, T_BRKPT)
TRAPHANDLER_NOEC(routine_oflow, T_OFLOW)
TRAPHANDLER_NOEC(routine_bound, T_BOUND)
TRAPHANDLER_NOEC(routine_illop, T_ILLOP)
TRAPHANDLER_NOEC(routine_device, T_DEVICE)
TRAPHANDLER(routine_dblflt, T_DBLFLT)
TRAPHANDLER(routine_tss, T_TSS)
TRAPHANDLER(routine_segnp, T_SEGNP)
TRAPHANDLER(routine_stack, T_STACK)
TRAPHANDLER(routine_gpflt, T_GPFLT)
TRAPHANDLER(routine_pgflt, T_PGFLT)
TRAPHANDLER_NOEC(routine_fperr, T_FPERR)
TRAPHANDLER(routine_align, T_ALIGN)
TRAPHANDLER_NOEC(routine_mchk, T_MCHK)
TRAPHANDLER_NOEC(routine_simderr, T_SIMDERR)
TRAPHANDLER_NOEC(system_call, T_SYSCALL)
TRAPHANDLER_NOEC(timer, IRQ_OFFSET + IRQ_TIMER)
	

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
/*  
  pushl %ds
  pushl %es
  pushal
  movl $GD_KD, %eax
  movw %ax, %ds
  movw %ax, %es
  pushl %esp
  call trap
  popl %esp
  popal
  popl %es
  popl %ds
  iret
*/
  pushw  $0x0
  pushw  %ds
  pushw  $0x0
  pushw  %es
  pushal
  movl   $GD_KD, %eax
  movw   %ax, %ds
  movw   %ax, %es
  pushl  %esp
  call trap
	
	
	
	
	
	
	
