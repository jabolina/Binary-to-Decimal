#Jose Augusto Bolina
#Trabalho feito em dupla com Esdras de Lima Chaves
.data
	string_01: .asciiz "Entre com a cadeia de bits: "
	string_02: .asciiz " "
	myArray: .word  0:56
	pow2: .word 3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15
	vetor: .word 0:56
#um numero com mais de 10bits o proprio syscall já não consegue ler
.text
	li $v0, 4		#
	la $a0, string_01	# Printa a mensagem de entrada
	syscall			#
	
	li $v0, 5		# Le o inteiro dados pelo usuário
	syscall			#
	
	move $t0, $v0		# Salva a cadeia de bits nos registradores $t0 e $t1
	move $t1, $v0		#
	
	move $s6, $v0
	
	addi $t9, $zero, 1
	
	move $t1, $t0		# copia da sequencia em $t1
	addi $s3, $zero, 0
	j Laco
	
	
	j Exit
	
	
	Laco:
		beqz $t1, Exit
		addi $t5, $zero, 0
		divu $t1, $t1, 10
		mfhi $t6
		mflo $t1
		lw $t2, pow2($s3)
		addi $s3, $s3, 4
		move $t8, $t2
		
		jal Vetor
		
		addi $s2, $s2, 1
		j Laco
		
	Vetor:
		beqz $t8, Return
		andi $t7, $t8, 1
		sra $t8, $t8, 1
		beq $t9, $t7, Xor
		Aki:
			addi $t5, $t5, 1
		
		j Vetor
		
	Xor:
		mul $s1, $t5, 4
		move $s4, $zero
		lw $s4, myArray($s1)
		xor $s4, $s4, $t6
		sw $s4, myArray($s1) 
		j Aki
		
	Return:
		jr $ra
		
		
	Exit:
		move $s3, $zero		#indice vetor
		move $t0, $zero		#lw
		move $s1, $zero		#indices myArray
		move $s2, $zero		#indices pow
		addi $t3, $zero, 1	#marcar
		jal Imprime
		
	Imprime:
		beqz $s6, quase
		lw $t0, pow2($s2)
		beq $t0, $t3, original
		lw $a0, myArray($s1)
		sw $a0, vetor($s3)
		addi $s3, $s3, 4
		addi $t3, $t3, 1
		addi $s1, $s1, 4
		j Imprime
	original:
		div $s6, $s6, 10
		mfhi $a0
		sw $a0, vetor($s3)
		addi $s3, $s3, 4
		addi $t3, $t3, 1
		addi $s2, $s2, 4
		j Imprime
	quase:
		subi $s3, $s3, 4
		j Finalmente
		
	Finalmente:
		blt $s3,$zero, fim
		li $v0, 1
		lw $a0, vetor($s3)
		syscall
		subi $s3, $s3, 4
		j Finalmente 
	fim:
		li $v0, 10	
		syscall
