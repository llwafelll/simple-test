	.file	"mat_vec.c"
	.text
	.p2align 4
	.globl	mat_vec
	.type	mat_vec, @function
mat_vec:
.LFB39:
	.cfi_startproc
	endbr64
	testl	%ecx, %ecx
	jle	.L11
	leal	-1(%rcx), %eax         ; rcx is n -1 -- read lower bits?
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdx, %r8
	movl	%ecx, %r10d
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	leaq	8(%r8,%rax,8), %r14
	movq	%rdi, %rdx
	xorl	%r9d, %r9d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pxor	%xmm4, %xmm4        ; clear xmm4
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movslq	%ecx, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rax, %rbp           ; move n (actual rax) to rbp register
	salq	$3, %r12
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	%eax, %ebx           ; move n to ebx
	shrl	%ebx                 ; n*2
	addl	$1, %ebx             ; n*2 + 1
	movl	%ebx, %eax           ; eax is now n*2 + 1
	movl	%ebx, %r13d          ; r13d same as above ^
	shrl	%eax                 ; eax is now (n*2 + 1) * 2
	andl	$-2, %r13d
	leal	-1(%rax), %ecx
	leal	(%r13,%r13), %r11d
	addq	$1, %rcx
	salq	$5, %rcx
	.p2align 4,,10
	.p2align 3
.L6:
	movl	%r9d, %eax
	cmpl	$1, %ebp
	jbe	.L7
	xorl	%eax, %eax           ; clear eax
	movapd	%xmm4, %xmm2         ; clear xmm2 (xmm4 is 0)
	.p2align 4,,10
	.p2align 3
.L4:
	movupd	16(%rsi,%rax), %xmm0 ; move 128b = 16B = 2dobule of y to xmm0; at first iteration it will be 3rd & 4th elements of the y array
	movupd	16(%rdx,%rax), %xmm1 ; move 128b = 16B = 2dobule of x to xmm1; at first iteration it will be 3rd & 4th elements of the x array
	movlpd	8(%rsi,%rax), %xmm0  ; move 64b = 8B = 1dobule of y to lower 64b xmm0; at first iteration it will be 4th element of the y array
	movlpd	8(%rdx,%rax), %xmm1  ; move 64b = 8B = 1dobule of x to lower 64b xmm1; at first iteration it will be 4th element of the x array
	movupd	(%rdx,%rax), %xmm3   ; move 128b = 16B = 2dobule of y to xmm3; at first iteration it will be 1st & 2nd element of the y array
	mulpd	%xmm1, %xmm0         ; (_y0, _y1) = (x0, x1) * (y0, y1) -> xmm0
	movupd	(%rsi,%rax), %xmm1   ; (y0, y1) -> xmm1
	movhpd	16(%rdx,%rax), %xmm3
	movhpd	16(%rsi,%rax), %xmm1
	addq	$32, %rax
	mulpd	%xmm3, %xmm1
	addpd	%xmm1, %xmm0
	addsd	%xmm0, %xmm2
	unpckhpd	%xmm0, %xmm0
	addsd	%xmm0, %xmm2
	cmpq	%rcx, %rax
	jne	.L4
	leal	(%r9,%r11), %eax
	movslq	%r11d, %r15
	cmpl	%ebx, %r13d
	je	.L5
.L3:
	cltq
	movsd	8(%rsi,%r15,8), %xmm0
	movsd	(%rsi,%r15,8), %xmm1
	mulsd	8(%rdi,%rax,8), %xmm0
	mulsd	(%rdi,%rax,8), %xmm1
	addsd	%xmm1, %xmm0
	addsd	%xmm0, %xmm2
.L5:
	movsd	%xmm2, (%r8)
	addq	$8, %r8
	addl	%r10d, %r9d
	addq	%r12, %rdx
	cmpq	%r8, %r14
	jne	.L6
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L7:
	.cfi_restore_state
	movapd	%xmm4, %xmm2
	xorl	%r15d, %r15d
	jmp	.L3
.L11:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	ret
	.cfi_endproc
.LFE39:
	.size	mat_vec, .-mat_vec
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
