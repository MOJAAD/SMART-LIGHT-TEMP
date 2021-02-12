
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _flag=R5
	.DEF _i=R6
	.DEF _i_msb=R7
	.DEF _tx_wr_index=R4
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8
	.DEF _rx_wr_index=R11
	.DEF _rx_rd_index=R10
	.DEF _rx_counter=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
_shift:
	.DB  0xFE,0xFD,0xFB,0xF7
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x20,0x49,0x4E,0x20,0x54,0x48,0x45,0x20
	.DB  0x4E,0x41,0x4D,0x45,0x20,0x4F,0x46,0x20
	.DB  0x47,0x4F,0x44,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x57,0x45,0x4C,0x43,0x4F,0x4D
	.DB  0x45,0x21,0x0,0x45,0x4E,0x54,0x45,0x52
	.DB  0x20,0x4E,0x55,0x4D,0x42,0x45,0x52,0x3A
	.DB  0x0,0x31,0x2E,0x20,0x53,0x68,0x6F,0x77
	.DB  0x20,0x20,0x50,0x61,0x74,0x74,0x65,0x72
	.DB  0x6E,0x0,0x32,0x2E,0x20,0x45,0x64,0x69
	.DB  0x74,0x20,0x20,0x50,0x61,0x74,0x74,0x65
	.DB  0x72,0x6E,0x0,0x33,0x2E,0x20,0x53,0x68
	.DB  0x6F,0x77,0x20,0x20,0x54,0x65,0x6D,0x70
	.DB  0x72,0x61,0x74,0x75,0x72,0x65,0x0,0x34
	.DB  0x2E,0x20,0x41,0x62,0x6F,0x75,0x74,0x20
	.DB  0x4D,0x45,0x21,0x0,0x54,0x45,0x4D,0x50
	.DB  0x52,0x41,0x54,0x55,0x52,0x45,0x3A,0x0
	.DB  0x42,0x4B,0x0,0x53,0x4D,0x41,0x52,0x54
	.DB  0x20,0x20,0x20,0x4C,0x49,0x47,0x48,0x54
	.DB  0x20,0x20,0x20,0x41,0x4E,0x44,0x0,0x54
	.DB  0x45,0x4D,0x50,0x52,0x41,0x54,0x55,0x52
	.DB  0x45,0x20,0x20,0x50,0x52,0x4F,0x4A,0x45
	.DB  0x43,0x54,0x0,0x4D,0x4F,0x48,0x41,0x41
	.DB  0x4D,0x41,0x44,0x20,0x4A,0x41,0x56,0x41
	.DB  0x44,0x20,0x20,0x41,0x44,0x45,0x4C,0x0
	.DB  0x39,0x36,0x32,0x31,0x30,0x31,0x30,0x30
	.DB  0x34,0x32,0x0,0x3C,0x3C,0x0,0x3E,0x3E
	.DB  0x0,0x4F,0x4B,0x0,0x31,0x0,0x33,0x0
	.DB  0x34,0x0,0x35,0x0,0x36,0x0,0x37,0x0
	.DB  0x38,0x0,0x50,0x61,0x74,0x74,0x65,0x72
	.DB  0x6E,0x20,0x25,0x64,0x20,0x41,0x70,0x70
	.DB  0x6C,0x69,0x65,0x64,0x20,0x21,0x0,0x45
	.DB  0x44,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x50,0x52,0x45,0x53
	.DB  0x53,0x20,0x45,0x44,0x0,0x54,0x4F,0x20
	.DB  0x45,0x44,0x49,0x54,0x0,0x55,0x53,0x45
	.DB  0x20,0x4B,0x45,0x59,0x53,0x0,0x53,0x56
	.DB  0x0,0x42,0x4C,0x4F,0x43,0x4B,0x0,0x53
	.DB  0x41,0x56,0x45,0x44,0x20,0x21,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x14
	.DW  _0x58
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0x58+20
	.DW  _0x0*2+20

	.DW  0x0E
	.DW  _0x60
	.DW  _0x0*2+35

	.DW  0x11
	.DW  _0x60+14
	.DW  _0x0*2+49

	.DW  0x11
	.DW  _0x60+31
	.DW  _0x0*2+66

	.DW  0x14
	.DW  _0x60+48
	.DW  _0x0*2+83

	.DW  0x0D
	.DW  _0x60+68
	.DW  _0x0*2+103

	.DW  0x0C
	.DW  _0x86
	.DW  _0x0*2+116

	.DW  0x03
	.DW  _0x86+12
	.DW  _0x0*2+128

	.DW  0x14
	.DW  _0x8D
	.DW  _0x0*2+131

	.DW  0x14
	.DW  _0x8D+20
	.DW  _0x0*2+151

	.DW  0x15
	.DW  _0x8D+40
	.DW  _0x0*2+171

	.DW  0x0B
	.DW  _0x8D+61
	.DW  _0x0*2+192

	.DW  0x03
	.DW  _0x8D+72
	.DW  _0x0*2+128

	.DW  0x08
	.DW  _0x94
	.DW  _0x0*2+58

	.DW  0x03
	.DW  _0x94+8
	.DW  _0x0*2+203

	.DW  0x03
	.DW  _0x94+11
	.DW  _0x0*2+206

	.DW  0x03
	.DW  _0x94+14
	.DW  _0x0*2+209

	.DW  0x03
	.DW  _0x94+17
	.DW  _0x0*2+128

	.DW  0x02
	.DW  _0x94+20
	.DW  _0x0*2+212

	.DW  0x02
	.DW  _0x94+22
	.DW  _0x0*2+201

	.DW  0x02
	.DW  _0x94+24
	.DW  _0x0*2+214

	.DW  0x02
	.DW  _0x94+26
	.DW  _0x0*2+216

	.DW  0x02
	.DW  _0x94+28
	.DW  _0x0*2+218

	.DW  0x02
	.DW  _0x94+30
	.DW  _0x0*2+220

	.DW  0x02
	.DW  _0x94+32
	.DW  _0x0*2+222

	.DW  0x02
	.DW  _0x94+34
	.DW  _0x0*2+224

	.DW  0x08
	.DW  _0xC6
	.DW  _0x0*2+58

	.DW  0x03
	.DW  _0xC6+8
	.DW  _0x0*2+203

	.DW  0x03
	.DW  _0xC6+11
	.DW  _0x0*2+206

	.DW  0x03
	.DW  _0xC6+14
	.DW  _0x0*2+247

	.DW  0x03
	.DW  _0xC6+17
	.DW  _0x0*2+128

	.DW  0x02
	.DW  _0xC6+20
	.DW  _0x0*2+212

	.DW  0x02
	.DW  _0xC6+22
	.DW  _0x0*2+201

	.DW  0x02
	.DW  _0xC6+24
	.DW  _0x0*2+214

	.DW  0x02
	.DW  _0xC6+26
	.DW  _0x0*2+216

	.DW  0x02
	.DW  _0xC6+28
	.DW  _0x0*2+218

	.DW  0x02
	.DW  _0xC6+30
	.DW  _0x0*2+220

	.DW  0x02
	.DW  _0xC6+32
	.DW  _0x0*2+222

	.DW  0x02
	.DW  _0xC6+34
	.DW  _0x0*2+224

	.DW  0x0A
	.DW  _0xE7
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0xE7+10
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0xE7+20
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0xE7+30
	.DW  _0x0*2+250

	.DW  0x09
	.DW  _0xE7+40
	.DW  _0x0*2+260

	.DW  0x08
	.DW  _0xE7+49
	.DW  _0x0*2+269

	.DW  0x0A
	.DW  _0xE7+57
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0xE7+67
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0xE7+77
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0xE7+87
	.DW  _0x0*2+250

	.DW  0x03
	.DW  _0xE7+97
	.DW  _0x0*2+203

	.DW  0x03
	.DW  _0xE7+100
	.DW  _0x0*2+206

	.DW  0x0A
	.DW  _0x119
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0x119+10
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0x119+20
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0x119+30
	.DW  _0x0*2+250

	.DW  0x09
	.DW  _0x119+40
	.DW  _0x0*2+277

	.DW  0x08
	.DW  _0x119+49
	.DW  _0x0*2+269

	.DW  0x03
	.DW  _0x119+57
	.DW  _0x0*2+286

	.DW  0x0A
	.DW  _0x119+60
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0x119+70
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0x119+80
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0x119+90
	.DW  _0x0*2+250

	.DW  0x06
	.DW  _0x119+100
	.DW  _0x0*2+289

	.DW  0x08
	.DW  _0x119+106
	.DW  _0x0*2+295

	.DW  0x0A
	.DW  _0x119+114
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0x119+124
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0x119+134
	.DW  _0x0*2+250

	.DW  0x0A
	.DW  _0x119+144
	.DW  _0x0*2+250

	.DW  0x09
	.DW  _0x119+154
	.DW  _0x0*2+260

	.DW  0x08
	.DW  _0x119+163
	.DW  _0x0*2+269

	.DW  0x03
	.DW  _0x119+171
	.DW  _0x0*2+247

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;Author  :  Mohammad Javad Adel 9621010042
;*******************************************************/
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdlib.h>
;#include <stdio.h>
;#include <glcd.h>
;#include <delay.h>
;#include <font5x7.h>
;
;char recive[7],flag=0;
;int i=0;
;flash char shift[4]= { 0xFE , 0xFD , 0xFB , 0xF7} ;
;eeprom char  center[16][8][2];
;
;int keypad(void);
;void firstmain(void);
;void showpattern(void);
;void editpattern(void);
;void showtemp(void);
;void aboutme(void);
;void tablepattern(void);
;void savepattern(int x);
;//void defaultpattern(void);
;void showled(int d);
;void clearround(int w);
;void save2pattern(int j,int x);
;void patternapply(int d);
;void writeapply(int d,int w);
;
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0020 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
; 0000 0021   #asm("cli")
	cli
; 0000 0022 
; 0000 0023 //    glcd_clear();
; 0000 0024 //    glcd_rectround(5,5,118,54, 5);
; 0000 0025 //    glcd_outtextxy(28,10, recive);
; 0000 0026 //    delay_ms(125);
; 0000 0027 //    glcd_clear();
; 0000 0028      #asm("sei")
	sei
; 0000 0029 
; 0000 002A }
	RETI
; .FEND
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 002D {
_ext_int1_isr:
; .FSTART _ext_int1_isr
; 0000 002E  #asm("cli")
	cli
; 0000 002F 
; 0000 0030 // glcd_clear();
; 0000 0031 // glcd_outtextxy(28,30, recive);
; 0000 0032 // delay_ms(125);
; 0000 0033 // glcd_clear();
; 0000 0034 
; 0000 0035  #asm("sei")
	sei
; 0000 0036 
; 0000 0037 }
	RETI
; .FEND
;
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 003A {
_ext_int2_isr:
; .FSTART _ext_int2_isr
; 0000 003B // Place your code here
; 0000 003C 
; 0000 003D }
	RETI
; .FEND
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0052 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0053 if (tx_counter)
	TST  R8
	BREQ _0x3
; 0000 0054    {
; 0000 0055    --tx_counter;
	DEC  R8
; 0000 0056    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0057 #if TX_BUFFER_SIZE != 256
; 0000 0058    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x4
	CLR  R9
; 0000 0059 #endif
; 0000 005A    }
_0x4:
; 0000 005B }
_0x3:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0062 {
_putchar:
; .FSTART _putchar
; 0000 0063 while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0x5:
	LDI  R30,LOW(8)
	CP   R30,R8
	BREQ _0x5
; 0000 0064 #asm("cli")
	cli
; 0000 0065 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R8
	BRNE _0x9
	SBIC 0xB,5
	RJMP _0x8
_0x9:
; 0000 0066    {
; 0000 0067    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0068 #if TX_BUFFER_SIZE != 256
; 0000 0069    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0xB
	CLR  R4
; 0000 006A #endif
; 0000 006B    ++tx_counter;
_0xB:
	INC  R8
; 0000 006C    }
; 0000 006D else
	RJMP _0xC
_0x8:
; 0000 006E    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 006F #asm("sei")
_0xC:
	sei
; 0000 0070 }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;bit rx_buffer_overflow;
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0082 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0083 char test;
; 0000 0084 char status,data;
; 0000 0085 #asm("cli")
	CALL __SAVELOCR4
;	test -> R17
;	status -> R16
;	data -> R19
	cli
; 0000 0086 
; 0000 0087 status=UCSRA;
	IN   R16,11
; 0000 0088 data=UDR;
	IN   R19,12
; 0000 0089 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R16
	ANDI R30,LOW(0x1C)
	BRNE _0xD
; 0000 008A    {
; 0000 008B    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R11
	INC  R11
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R19
; 0000 008C #if RX_BUFFER_SIZE == 256
; 0000 008D    // special case for receiver buffer size=256
; 0000 008E    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 008F #else
; 0000 0090    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0xE
	CLR  R11
; 0000 0091    if (++rx_counter == RX_BUFFER_SIZE)
_0xE:
	INC  R13
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0xF
; 0000 0092       {
; 0000 0093       rx_counter=0;
	CLR  R13
; 0000 0094       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0095       }
; 0000 0096 }
_0xF:
; 0000 0097 #endif
; 0000 0098  //zZ36.25 CXx
; 0000 0099 test=getchar();
_0xD:
	RCALL _getchar
	MOV  R17,R30
; 0000 009A switch(i){
	MOVW R30,R6
; 0000 009B  case 0:
	SBIW R30,0
	BRNE _0x13
; 0000 009C     if(test=='z'){flag=1;break;}
	CPI  R17,122
	BRNE _0x14
	LDI  R30,LOW(1)
	MOV  R5,R30
	RJMP _0x12
; 0000 009D  case 1:
_0x14:
	RJMP _0x15
_0x13:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x16
_0x15:
; 0000 009E     if(test=='Z' && flag==1){break;}
	CPI  R17,90
	BRNE _0x18
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0x19
_0x18:
	RJMP _0x17
_0x19:
	RJMP _0x12
; 0000 009F     else{flag=0;break;}
_0x17:
	CLR  R5
	RJMP _0x12
; 0000 00A0  case 2:
_0x16:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1C
; 0000 00A1     if(flag==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1D
; 0000 00A2     if(test >='1' && test <='6'){recive[0]=test;break;}
	CPI  R17,49
	BRLO _0x1F
	CPI  R17,55
	BRLO _0x20
_0x1F:
	RJMP _0x1E
_0x20:
	STS  _recive,R17
	RJMP _0x12
; 0000 00A3     }
_0x1E:
; 0000 00A4     else{flag=0;break;}
	RJMP _0x21
_0x1D:
	CLR  R5
	RJMP _0x12
_0x21:
; 0000 00A5  case 3:
	RJMP _0x22
_0x1C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x23
_0x22:
; 0000 00A6     if(flag==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x24
; 0000 00A7     if(test >='0' && test <='9'){recive[1]=test;break;}
	CPI  R17,48
	BRLO _0x26
	CPI  R17,58
	BRLO _0x27
_0x26:
	RJMP _0x25
_0x27:
	__PUTBMRN _recive,1,17
	RJMP _0x12
; 0000 00A8     }
_0x25:
; 0000 00A9     else{flag=0;break;}
	RJMP _0x28
_0x24:
	CLR  R5
	RJMP _0x12
_0x28:
; 0000 00AA  case 4:
	RJMP _0x29
_0x23:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2A
_0x29:
; 0000 00AB     if(flag==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x2B
; 0000 00AC     recive[2]='.';
	LDI  R30,LOW(46)
	__PUTB1MN _recive,2
; 0000 00AD     break;
	RJMP _0x12
; 0000 00AE     }
; 0000 00AF     else{flag=0;break;}
_0x2B:
	CLR  R5
	RJMP _0x12
; 0000 00B0  case 5:
_0x2A:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2E
; 0000 00B1     if(flag==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x2F
; 0000 00B2     if(test >='0' && test <='9'){recive[3]=test;break;}
	CPI  R17,48
	BRLO _0x31
	CPI  R17,58
	BRLO _0x32
_0x31:
	RJMP _0x30
_0x32:
	__PUTBMRN _recive,3,17
	RJMP _0x12
; 0000 00B3     }
_0x30:
; 0000 00B4     else{flag=0;break;}
	RJMP _0x33
_0x2F:
	CLR  R5
	RJMP _0x12
_0x33:
; 0000 00B5  case 6:
	RJMP _0x34
_0x2E:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x35
_0x34:
; 0000 00B6     if(flag==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x36
; 0000 00B7     if(test >='0' && test <='9'){recive[4]=test;break;}
	CPI  R17,48
	BRLO _0x38
	CPI  R17,58
	BRLO _0x39
_0x38:
	RJMP _0x37
_0x39:
	__PUTBMRN _recive,4,17
	RJMP _0x12
; 0000 00B8     }
_0x37:
; 0000 00B9     else{flag=0;break;}
	RJMP _0x3A
_0x36:
	CLR  R5
	RJMP _0x12
_0x3A:
; 0000 00BA  case 7:
	RJMP _0x3B
_0x35:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x3C
_0x3B:
; 0000 00BB     if(test==' ' && flag==1){recive[5]=test;break;}
	CPI  R17,32
	BRNE _0x3E
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0x3F
_0x3E:
	RJMP _0x3D
_0x3F:
	__PUTBMRN _recive,5,17
	RJMP _0x12
; 0000 00BC     else{flag=0;break;}
_0x3D:
	CLR  R5
	RJMP _0x12
; 0000 00BD  case 8:
_0x3C:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x42
; 0000 00BE     if(test=='C' && flag==1){recive[6]=test;break;}
	CPI  R17,67
	BRNE _0x44
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0x45
_0x44:
	RJMP _0x43
_0x45:
	__PUTBMRN _recive,6,17
	RJMP _0x12
; 0000 00BF     else{flag=0;break;}
_0x43:
	CLR  R5
	RJMP _0x12
; 0000 00C0  case 9:
_0x42:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x48
; 0000 00C1     if(test=='X' && flag==1){break;}
	CPI  R17,88
	BRNE _0x4A
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0x4B
_0x4A:
	RJMP _0x49
_0x4B:
	RJMP _0x12
; 0000 00C2     else{flag=0;break;}
_0x49:
	CLR  R5
	RJMP _0x12
; 0000 00C3  case 10:
_0x48:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x12
; 0000 00C4     if(test=='x' && flag==1){break;}
	CPI  R17,120
	BRNE _0x50
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0x51
_0x50:
	RJMP _0x4F
_0x51:
	RJMP _0x12
; 0000 00C5     else{flag=0;break;}
_0x4F:
	CLR  R5
; 0000 00C6 }
_0x12:
; 0000 00C7 i++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 00C8 if(i>=10){i=0;}
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x53
	CLR  R6
	CLR  R7
; 0000 00C9    #asm("sei")
_0x53:
	sei
; 0000 00CA }
	CALL __LOADLOCR4
	ADIW R28,4
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;#ifndef _DEBUG_TERMINAL_IO_
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 00CF {
_getchar:
; .FSTART _getchar
; 0000 00D0 char data;
; 0000 00D1 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x54:
	TST  R13
	BREQ _0x54
; 0000 00D2 data=rx_buffer[rx_rd_index++];
	MOV  R30,R10
	INC  R10
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 00D3 #if RX_BUFFER_SIZE != 256
; 0000 00D4 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x57
	CLR  R10
; 0000 00D5 #endif
; 0000 00D6 #asm("cli")
_0x57:
	cli
; 0000 00D7 --rx_counter;
	DEC  R13
; 0000 00D8 #asm("sei")
	sei
; 0000 00D9 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 00DA }
; .FEND
;#pragma used-
;#endif
;
;void main(void)
; 0000 00DF {
_main:
; .FSTART _main
; 0000 00E0 int j;
; 0000 00E1 GLCDINIT_t glcd_init_data;
; 0000 00E2 
; 0000 00E3 //defaultpattern();
; 0000 00E4 
; 0000 00E5 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	SBIW R28,6
;	j -> R16,R17
;	glcd_init_data -> Y+0
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 00E6 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);
	OUT  0x1B,R30
; 0000 00E7 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 00E8 PORTB=(1<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (1<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(132)
	OUT  0x18,R30
; 0000 00E9 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 00EA PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 00EB DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 00EC PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 00ED TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00EE TCNT0=0x00;
	OUT  0x32,R30
; 0000 00EF OCR0=0x00;
	OUT  0x3C,R30
; 0000 00F0 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00F1 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00F2 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00F3 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00F4 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00F5 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00F6 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00F7 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00F8 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00F9 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00FA ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00FB TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00FC TCNT2=0x00;
	OUT  0x24,R30
; 0000 00FD OCR2=0x00;
	OUT  0x23,R30
; 0000 00FE TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00FF 
; 0000 0100 // External Interrupt(s) initialization
; 0000 0101 // INT0: On
; 0000 0102 // INT0 Mode: Falling Edge
; 0000 0103 // INT1: On
; 0000 0104 // INT1 Mode: Falling Edge
; 0000 0105 // INT2: On
; 0000 0106 // INT2 Mode: Falling Edge
; 0000 0107 GICR|=(0<<INT1) | (0<<INT0) | (0<<INT2);
	IN   R30,0x3B
	OUT  0x3B,R30
; 0000 0108 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0109 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 010A GIFR=(1<<INTF1) | (1<<INTF0) | (1<<INTF2);
	LDI  R30,LOW(224)
	OUT  0x3A,R30
; 0000 010B 
; 0000 010C // USART initialization
; 0000 010D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 010E // USART Receiver: On
; 0000 010F // USART Transmitter: On
; 0000 0110 // USART Mode: Asynchronous
; 0000 0111 // USART Baud Rate: 9600
; 0000 0112 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0113 UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0114 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0115 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0116 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0117 
; 0000 0118 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0119 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 011A ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 011B SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 011C TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 011D 
; 0000 011E // Graphic Display Controller initialization
; 0000 011F // The KS0108 connections are specified in the
; 0000 0120 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 0121 // DB0 - PORTC Bit 0
; 0000 0122 // DB1 - PORTC Bit 1
; 0000 0123 // DB2 - PORTC Bit 2
; 0000 0124 // DB3 - PORTC Bit 3
; 0000 0125 // DB4 - PORTC Bit 4
; 0000 0126 // DB5 - PORTC Bit 5
; 0000 0127 // DB6 - PORTC Bit 6
; 0000 0128 // DB7 - PORTC Bit 7
; 0000 0129 // E - PORTB Bit 4
; 0000 012A // RD /WR - PORTB Bit 3
; 0000 012B // RS - PORTB Bit 1
; 0000 012C // /RST - PORTB Bit 0
; 0000 012D // CS1 - PORTB Bit 5
; 0000 012E // CS2 - PORTB Bit 6
; 0000 012F glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0130 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0131 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 0132 glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 0133 
; 0000 0134 glcd_clear();
	CALL _glcd_clear
; 0000 0135 glcd_rectround(2,2,124,60, 5);
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(124)
	ST   -Y,R30
	LDI  R30,LOW(60)
	CALL SUBOPT_0x0
; 0000 0136 glcd_outtextxy(5,15, " IN THE NAME OF GOD");
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	__POINTW2MN _0x58,0
	CALL SUBOPT_0x1
; 0000 0137 glcd_outtextxy(5,25,"      WELCOME!");
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x58,20
	CALL _glcd_outtextxy
; 0000 0138 for(j=0;j<10;j++) {
	__GETWRN 16,17,0
_0x5A:
	__CPWRN 16,17,10
	BRGE _0x5B
; 0000 0139    delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 013A    glcd_bar(10+10*j, 40, 20+10*j, 50);
	LDI  R26,LOW(10)
	MULS R16,R26
	MOVW R30,R0
	MOVW R26,R30
	SUBI R30,-LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	MOVW R30,R26
	SUBI R30,-LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(50)
	CALL _glcd_bar
; 0000 013B }
	__ADDWRN 16,17,1
	RJMP _0x5A
_0x5B:
; 0000 013C glcd_clear();
	CALL _glcd_clear
; 0000 013D #asm("sei")
	sei
; 0000 013E while (1)
_0x5C:
; 0000 013F       {
; 0000 0140             firstmain();
	RCALL _firstmain
; 0000 0141             //glcd_clear();
; 0000 0142       }
	RJMP _0x5C
; 0000 0143 }
_0x5F:
	RJMP _0x5F
; .FEND

	.DSEG
_0x58:
	.BYTE 0x23
;
;void firstmain(void){
; 0000 0145 void firstmain(void){

	.CSEG
_firstmain:
; .FSTART _firstmain
; 0000 0146 int j=0;
; 0000 0147   glcd_rectround(22,1,85,16, 2);
	CALL SUBOPT_0x2
;	j -> R16,R17
	LDI  R30,LOW(22)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(85)
	ST   -Y,R30
	LDI  R30,LOW(16)
	CALL SUBOPT_0x3
; 0000 0148   glcd_outtextxy(24,5,"ENTER NUMBER:");
	LDI  R30,LOW(24)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	__POINTW2MN _0x60,0
	CALL _glcd_outtextxy
; 0000 0149   glcd_rectround(2,20,124,55, 2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R30,LOW(124)
	ST   -Y,R30
	LDI  R30,LOW(55)
	CALL SUBOPT_0x3
; 0000 014A   glcd_outtextxy(5,25,"1. Show  Pattern");
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x60,14
	CALL SUBOPT_0x1
; 0000 014B   glcd_outtextxy(5,35,"2. Edit  Pattern");
	LDI  R30,LOW(35)
	ST   -Y,R30
	__POINTW2MN _0x60,31
	CALL SUBOPT_0x1
; 0000 014C   glcd_outtextxy(5,45,"3. Show  Temprature");
	LDI  R30,LOW(45)
	ST   -Y,R30
	__POINTW2MN _0x60,48
	CALL SUBOPT_0x1
; 0000 014D   glcd_outtextxy(5,55,"4. About ME!");
	LDI  R30,LOW(55)
	ST   -Y,R30
	__POINTW2MN _0x60,68
	CALL _glcd_outtextxy
; 0000 014E   j=keypad();
	RCALL _keypad
	MOVW R16,R30
; 0000 014F   switch(j){
; 0000 0150     case 0:
	SBIW R30,0
	BRNE _0x64
; 0000 0151         showpattern();
	RCALL _showpattern
; 0000 0152         break;
	RJMP _0x63
; 0000 0153     case 1:
_0x64:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x65
; 0000 0154         glcd_clear();
	CALL _glcd_clear
; 0000 0155         editpattern();
	RCALL _editpattern
; 0000 0156         break;
	RJMP _0x63
; 0000 0157     case 2:
_0x65:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x66
; 0000 0158         glcd_clear();
	CALL _glcd_clear
; 0000 0159         showtemp();
	RCALL _showtemp
; 0000 015A         break;
	RJMP _0x63
; 0000 015B     case 3:
_0x66:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x63
; 0000 015C         glcd_clear();
	CALL _glcd_clear
; 0000 015D         aboutme();
	RCALL _aboutme
; 0000 015E   }
_0x63:
; 0000 015F }
	RJMP _0x2120010
; .FEND

	.DSEG
_0x60:
	.BYTE 0x51
;
;int keypad(void){
; 0000 0161 int keypad(void){

	.CSEG
_keypad:
; .FSTART _keypad
; 0000 0162 int i=0,column=0;
; 0000 0163 while(1){
	CALL __SAVELOCR4
;	i -> R16,R17
;	column -> R18,R19
	CALL SUBOPT_0x4
_0x68:
; 0000 0164             for  (i=0;i<4;i++){
	__GETWRN 16,17,0
_0x6C:
	__CPWRN 16,17,4
	BRGE _0x6D
; 0000 0165             PORTA = shift[i] ;
	MOVW R30,R16
	SUBI R30,LOW(-_shift*2)
	SBCI R31,HIGH(-_shift*2)
	LPM  R0,Z
	OUT  0x1B,R0
; 0000 0166             delay_us(10);
	__DELAY_USB 27
; 0000 0167             if(PINA.4==0){column=0;while(PINA.4==0){}return i*4 + column;}
	SBIC 0x19,4
	RJMP _0x6E
	__GETWRN 18,19,0
_0x6F:
	SBIS 0x19,4
	RJMP _0x6F
	CALL SUBOPT_0x5
	RJMP _0x2120013
; 0000 0168             if(PINA.5==0){column=1;while(PINA.5==0){}return i*4 + column;}
_0x6E:
	SBIC 0x19,5
	RJMP _0x72
	__GETWRN 18,19,1
_0x73:
	SBIS 0x19,5
	RJMP _0x73
	CALL SUBOPT_0x5
	RJMP _0x2120013
; 0000 0169             if(PINA.6==0){column=2;while(PINA.6==0){}return i*4 + column;}
_0x72:
	SBIC 0x19,6
	RJMP _0x76
	__GETWRN 18,19,2
_0x77:
	SBIS 0x19,6
	RJMP _0x77
	CALL SUBOPT_0x5
	RJMP _0x2120013
; 0000 016A             if(PINA.7==0){column=3;while(PINA.7==0){}return i*4 + column;}
_0x76:
	SBIC 0x19,7
	RJMP _0x7A
	__GETWRN 18,19,3
_0x7B:
	SBIS 0x19,7
	RJMP _0x7B
	CALL SUBOPT_0x5
	RJMP _0x2120013
; 0000 016B             }
_0x7A:
	__ADDWRN 16,17,1
	RJMP _0x6C
_0x6D:
; 0000 016C         if(PINB.2==0){while(PINB.2==0);return 16;}
	SBIC 0x16,2
	RJMP _0x7E
_0x7F:
	SBIS 0x16,2
	RJMP _0x7F
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP _0x2120013
; 0000 016D         if(PINB.7==0){while(PINB.7==0);return 17;}
_0x7E:
	SBIC 0x16,7
	RJMP _0x82
_0x83:
	SBIS 0x16,7
	RJMP _0x83
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	RJMP _0x2120013
; 0000 016E         }
_0x82:
	RJMP _0x68
; 0000 016F }
_0x2120013:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;void showtemp(void){
; 0000 0171 void showtemp(void){
_showtemp:
; .FSTART _showtemp
; 0000 0172 glcd_rectround(1,1,126,62, 5);
	CALL SUBOPT_0x6
; 0000 0173 glcd_outtextxy(30,10,"TEMPRATURE:");
	LDI  R30,LOW(30)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	__POINTW2MN _0x86,0
	CALL _glcd_outtextxy
; 0000 0174 glcd_outtextxy(43,20,recive);
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(_recive)
	LDI  R27,HIGH(_recive)
	CALL _glcd_outtextxy
; 0000 0175 glcd_circle(62,45,15);
	LDI  R30,LOW(62)
	ST   -Y,R30
	LDI  R30,LOW(45)
	ST   -Y,R30
	LDI  R26,LOW(15)
	CALL _glcd_circle
; 0000 0176 glcd_outtextxy(57,42,"BK");
	LDI  R30,LOW(57)
	ST   -Y,R30
	LDI  R30,LOW(42)
	ST   -Y,R30
	__POINTW2MN _0x86,12
	CALL _glcd_outtextxy
; 0000 0177 while(PINB.7==0);
_0x87:
	SBIS 0x16,7
	RJMP _0x87
; 0000 0178 while(PINB.7==1);
_0x8A:
	SBIC 0x16,7
	RJMP _0x8A
; 0000 0179 glcd_clear();
	RJMP _0x2120012
; 0000 017A }
; .FEND

	.DSEG
_0x86:
	.BYTE 0xF
;
;void aboutme(void){
; 0000 017C void aboutme(void){

	.CSEG
_aboutme:
; .FSTART _aboutme
; 0000 017D glcd_rectround(1,1,126,62, 5);
	CALL SUBOPT_0x6
; 0000 017E glcd_outtextxy(5,8,"SMART   LIGHT   AND");
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	__POINTW2MN _0x8D,0
	CALL SUBOPT_0x1
; 0000 017F glcd_outtextxy(5,21,"TEMPRATURE  PROJECT");
	LDI  R30,LOW(21)
	ST   -Y,R30
	__POINTW2MN _0x8D,20
	CALL SUBOPT_0x1
; 0000 0180 glcd_outtextxy(5,33,"MOHAAMAD JAVAD  ADEL");
	LDI  R30,LOW(33)
	ST   -Y,R30
	__POINTW2MN _0x8D,40
	CALL _glcd_outtextxy
; 0000 0181 glcd_outtextxy(45,47,"9621010042");
	LDI  R30,LOW(45)
	ST   -Y,R30
	LDI  R30,LOW(47)
	ST   -Y,R30
	__POINTW2MN _0x8D,61
	CALL _glcd_outtextxy
; 0000 0182 glcd_circle(30,50,10);
	LDI  R30,LOW(30)
	CALL SUBOPT_0x7
; 0000 0183 glcd_outtextxy(25,47,"BK");
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R30,LOW(47)
	ST   -Y,R30
	__POINTW2MN _0x8D,72
	CALL _glcd_outtextxy
; 0000 0184 while(PINB.7==0);
_0x8E:
	SBIS 0x16,7
	RJMP _0x8E
; 0000 0185 while(PINB.7==1);
_0x91:
	SBIC 0x16,7
	RJMP _0x91
; 0000 0186 glcd_clear();
_0x2120012:
	CALL _glcd_clear
; 0000 0187 }
	RET
; .FEND

	.DSEG
_0x8D:
	.BYTE 0x4B
;
;void showpattern(void){
; 0000 0189 void showpattern(void){

	.CSEG
_showpattern:
; .FSTART _showpattern
; 0000 018A int d=0;
; 0000 018B char buffer[20];
; 0000 018C tablepattern();
	SBIW R28,20
	CALL SUBOPT_0x2
;	d -> R16,R17
;	buffer -> Y+2
	CALL SUBOPT_0x8
; 0000 018D glcd_rectround(68,0,60,64,2);
; 0000 018E glcd_outtextxy(70,5,"Pattern");
	LDI  R30,LOW(70)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	__POINTW2MN _0x94,0
	CALL SUBOPT_0x9
; 0000 018F glcd_circle(84,25,10);
; 0000 0190 glcd_outtextxy(78,22,"<<");
	__POINTW2MN _0x94,8
	CALL SUBOPT_0xA
; 0000 0191 glcd_circle(110,25,10);
; 0000 0192 glcd_outtextxy(106,22,">>");
	__POINTW2MN _0x94,11
	CALL _glcd_outtextxy
; 0000 0193 glcd_circle(84,50,10);
	LDI  R30,LOW(84)
	CALL SUBOPT_0x7
; 0000 0194 glcd_outtextxy(78,48,"OK");
	CALL SUBOPT_0xB
	__POINTW2MN _0x94,14
	CALL _glcd_outtextxy
; 0000 0195 glcd_circle(110,50,10);
	LDI  R30,LOW(110)
	CALL SUBOPT_0x7
; 0000 0196 glcd_outtextxy(105,48,"BK");
	LDI  R30,LOW(105)
	ST   -Y,R30
	LDI  R30,LOW(48)
	ST   -Y,R30
	__POINTW2MN _0x94,17
	CALL _glcd_outtextxy
; 0000 0197 while(1){
_0x95:
; 0000 0198  switch(d){
	MOVW R30,R16
; 0000 0199   case 0:
	SBIW R30,0
	BRNE _0x9B
; 0000 019A     glcd_outtextxy(117,5,"1");
	CALL SUBOPT_0xC
	__POINTW2MN _0x94,20
	RJMP _0x127
; 0000 019B     showled(d);
; 0000 019C     break;
; 0000 019D   case 1:
_0x9B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x9C
; 0000 019E     glcd_outtextxy(117,5,"2");
	CALL SUBOPT_0xC
	__POINTW2MN _0x94,22
	RJMP _0x127
; 0000 019F     showled(d);
; 0000 01A0     break;
; 0000 01A1   case 2:
_0x9C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x9D
; 0000 01A2     glcd_outtextxy(117,5,"3");
	CALL SUBOPT_0xC
	__POINTW2MN _0x94,24
	RJMP _0x127
; 0000 01A3     showled(d);
; 0000 01A4     break;
; 0000 01A5   case 3:
_0x9D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x9E
; 0000 01A6     glcd_outtextxy(117,5,"4");
	CALL SUBOPT_0xC
	__POINTW2MN _0x94,26
	RJMP _0x127
; 0000 01A7     showled(d);
; 0000 01A8     break;
; 0000 01A9   case 4:
_0x9E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x9F
; 0000 01AA     glcd_outtextxy(117,5,"5");
	CALL SUBOPT_0xC
	__POINTW2MN _0x94,28
	RJMP _0x127
; 0000 01AB     showled(d);
; 0000 01AC     break;
; 0000 01AD   case 5:
_0x9F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xA0
; 0000 01AE     glcd_outtextxy(117,5,"6");
	CALL SUBOPT_0xC
	__POINTW2MN _0x94,30
	RJMP _0x127
; 0000 01AF     showled(d);
; 0000 01B0     break;
; 0000 01B1   case 6:
_0xA0:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xA1
; 0000 01B2     glcd_outtextxy(117,5,"7");
	CALL SUBOPT_0xC
	__POINTW2MN _0x94,32
	RJMP _0x127
; 0000 01B3     showled(d);
; 0000 01B4     break;
; 0000 01B5   case 7:
_0xA1:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x9A
; 0000 01B6     glcd_outtextxy(117,5,"8");
	CALL SUBOPT_0xC
	__POINTW2MN _0x94,34
_0x127:
	CALL _glcd_outtextxy
; 0000 01B7     showled(d);
	MOVW R26,R16
	RCALL _showled
; 0000 01B8     break;
; 0000 01B9  }
_0x9A:
; 0000 01BA  if(PINB.7==0){while(PINB.7==0);break;}
	SBIC 0x16,7
	RJMP _0xA3
_0xA4:
	SBIS 0x16,7
	RJMP _0xA4
	RJMP _0x97
; 0000 01BB  if(PIND.6==0){while(PIND.6==0);d++;if(d>7){d=0;}}
_0xA3:
	SBIC 0x10,6
	RJMP _0xA7
_0xA8:
	SBIS 0x10,6
	RJMP _0xA8
	__ADDWRN 16,17,1
	__CPWRN 16,17,8
	BRLT _0xAB
	__GETWRN 16,17,0
_0xAB:
; 0000 01BC  if(PIND.4==0){while(PIND.4==0);d--;if(d<0){d=7;}}
_0xA7:
	SBIC 0x10,4
	RJMP _0xAC
_0xAD:
	SBIS 0x10,4
	RJMP _0xAD
	__SUBWRN 16,17,1
	TST  R17
	BRPL _0xB0
	__GETWRN 16,17,7
_0xB0:
; 0000 01BD  if(PINB.2==0){
_0xAC:
	SBIC 0x16,2
	RJMP _0xB1
; 0000 01BE     while(PINB.2==0);
_0xB2:
	SBIS 0x16,2
	RJMP _0xB2
; 0000 01BF     glcd_clear();
	CALL _glcd_clear
; 0000 01C0     glcd_rectround(5,20,118,18,5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R30,LOW(118)
	ST   -Y,R30
	LDI  R30,LOW(18)
	CALL SUBOPT_0x0
; 0000 01C1     sprintf(buffer,"Pattern %d Applied !",d+1);
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,226
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 01C2     glcd_outtextxy(7,25,buffer);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,4
	CALL _glcd_outtextxy
; 0000 01C3     patternapply(d);
	MOVW R26,R16
	RCALL _patternapply
; 0000 01C4     delay_ms(125);
	LDI  R26,LOW(125)
	LDI  R27,0
	CALL _delay_ms
; 0000 01C5     break;
	RJMP _0x97
; 0000 01C6     }
; 0000 01C7 }
_0xB1:
	RJMP _0x95
_0x97:
; 0000 01C8 glcd_clear();
	CALL _glcd_clear
; 0000 01C9 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,22
	RET
; .FEND

	.DSEG
_0x94:
	.BYTE 0x24
;
;void tablepattern(void){
; 0000 01CB void tablepattern(void){

	.CSEG
_tablepattern:
; .FSTART _tablepattern
; 0000 01CC int j=0,k=0,x=0,w=0;
; 0000 01CD glcd_clear();
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	CALL __SAVELOCR6
;	j -> R16,R17
;	k -> R18,R19
;	x -> R20,R21
;	w -> Y+6
	CALL SUBOPT_0x4
	__GETWRN 20,21,0
	CALL _glcd_clear
; 0000 01CE for(j=0;j<16;j++){
	__GETWRN 16,17,0
_0xB6:
	__CPWRN 16,17,16
	BRGE _0xB7
; 0000 01CF     for(k=0;k<16;k++){
	__GETWRN 18,19,0
_0xB9:
	__CPWRN 18,19,16
	BRGE _0xBA
; 0000 01D0         glcd_rectround(1+w,1+x,3,3, 0);
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R30,R20
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _glcd_rectround
; 0000 01D1         x=x+4;
	__ADDWRN 20,21,4
; 0000 01D2     }
	__ADDWRN 18,19,1
	RJMP _0xB9
_0xBA:
; 0000 01D3     w=w+4;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,4
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 01D4     x=0;
	__GETWRN 20,21,0
; 0000 01D5 }
	__ADDWRN 16,17,1
	RJMP _0xB6
_0xB7:
; 0000 01D6 }
	RJMP _0x2120011
; .FEND
;
;//void defaultpattern(void){
;// int j,k;
;// for(j=0;j<16;j++){
;//    for(k=0;k<8;k++){
;//      center[j][k][0]=0b01010101;
;//      center[j][k][1]=0b10101010;
;//  }
;// }
;//for(j=0;j<16;j++){
;//    center[j][2][0]=0b11110000;
;//    center[j][2][1]=0b00001111;
;//}
;//}
;
;void showled(int d){
; 0000 01E6 void showled(int d){
_showled:
; .FSTART _showled
; 0000 01E7 int j,shifter;
; 0000 01E8 char k,binary;
; 0000 01E9 for(j=0;j<16;j++){
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	d -> Y+6
;	j -> R16,R17
;	shifter -> R18,R19
;	k -> R21
;	binary -> R20
	__GETWRN 16,17,0
_0xBC:
	__CPWRN 16,17,16
	BRGE _0xBD
; 0000 01EA     for(k=0;k<2;k++){
	LDI  R21,LOW(0)
_0xBF:
	CPI  R21,2
	BRSH _0xC0
; 0000 01EB         for(shifter=0;shifter<8;shifter++){
	__GETWRN 18,19,0
_0xC2:
	__CPWRN 18,19,8
	BRGE _0xC3
; 0000 01EC             binary = 0b00000001 << shifter ;
	MOV  R30,R18
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R20,R30
; 0000 01ED             if( (center[j][d][k] & binary) == binary ){
	MOVW R30,R16
	CALL SUBOPT_0xD
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	CALL __EEPROMRDB
	AND  R30,R20
	CP   R20,R30
	BRNE _0xC4
; 0000 01EE                 glcd_setpixel( (4*(shifter%4)) + (16*(j%4)) + 2 , (k*8) + (4*(shifter/4)) + (16*(j/4)) + 2 );
	CALL SUBOPT_0xE
	CALL _glcd_setpixel
; 0000 01EF             }
; 0000 01F0             else{
	RJMP _0xC5
_0xC4:
; 0000 01F1                 glcd_clrpixel( (4*(shifter%4)) + (16*(j%4)) + 2 , (k*8) + (4*(shifter/4)) + (16*(j/4)) + 2 );
	CALL SUBOPT_0xE
	CALL _glcd_clrpixel
; 0000 01F2             }
_0xC5:
; 0000 01F3         }
	__ADDWRN 18,19,1
	RJMP _0xC2
_0xC3:
; 0000 01F4     }
	SUBI R21,-1
	RJMP _0xBF
_0xC0:
; 0000 01F5 }
	__ADDWRN 16,17,1
	RJMP _0xBC
_0xBD:
; 0000 01F6 }
_0x2120011:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
;
;void editpattern(void){
; 0000 01F8 void editpattern(void){
_editpattern:
; .FSTART _editpattern
; 0000 01F9 int d=0;
; 0000 01FA tablepattern();
	CALL SUBOPT_0x2
;	d -> R16,R17
	CALL SUBOPT_0x8
; 0000 01FB glcd_rectround(68,0,60,64,2);
; 0000 01FC glcd_outtextxy(70,5,"Pattern");
	LDI  R30,LOW(70)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	__POINTW2MN _0xC6,0
	CALL SUBOPT_0x9
; 0000 01FD glcd_circle(84,25,10);
; 0000 01FE glcd_outtextxy(78,22,"<<");
	__POINTW2MN _0xC6,8
	CALL SUBOPT_0xA
; 0000 01FF glcd_circle(110,25,10);
; 0000 0200 glcd_outtextxy(106,22,">>");
	__POINTW2MN _0xC6,11
	CALL _glcd_outtextxy
; 0000 0201 glcd_circle(84,50,10);
	LDI  R30,LOW(84)
	CALL SUBOPT_0x7
; 0000 0202 glcd_outtextxy(78,48,"ED");
	CALL SUBOPT_0xB
	__POINTW2MN _0xC6,14
	CALL _glcd_outtextxy
; 0000 0203 glcd_circle(110,50,10);
	LDI  R30,LOW(110)
	CALL SUBOPT_0x7
; 0000 0204 glcd_outtextxy(105,48,"BK");
	LDI  R30,LOW(105)
	ST   -Y,R30
	LDI  R30,LOW(48)
	ST   -Y,R30
	__POINTW2MN _0xC6,17
	CALL _glcd_outtextxy
; 0000 0205 while(1){
_0xC7:
; 0000 0206  switch(d){
	MOVW R30,R16
; 0000 0207   case 0:
	SBIW R30,0
	BRNE _0xCD
; 0000 0208     glcd_outtextxy(117,5,"1");
	CALL SUBOPT_0xC
	__POINTW2MN _0xC6,20
	RJMP _0x128
; 0000 0209     showled(d);
; 0000 020A     break;
; 0000 020B   case 1:
_0xCD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xCE
; 0000 020C     glcd_outtextxy(117,5,"2");
	CALL SUBOPT_0xC
	__POINTW2MN _0xC6,22
	RJMP _0x128
; 0000 020D     showled(d);
; 0000 020E     break;
; 0000 020F   case 2:
_0xCE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xCF
; 0000 0210     glcd_outtextxy(117,5,"3");
	CALL SUBOPT_0xC
	__POINTW2MN _0xC6,24
	RJMP _0x128
; 0000 0211     showled(d);
; 0000 0212     break;
; 0000 0213   case 3:
_0xCF:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xD0
; 0000 0214     glcd_outtextxy(117,5,"4");
	CALL SUBOPT_0xC
	__POINTW2MN _0xC6,26
	RJMP _0x128
; 0000 0215     showled(d);
; 0000 0216     break;
; 0000 0217   case 4:
_0xD0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xD1
; 0000 0218     glcd_outtextxy(117,5,"5");
	CALL SUBOPT_0xC
	__POINTW2MN _0xC6,28
	RJMP _0x128
; 0000 0219     showled(d);
; 0000 021A     break;
; 0000 021B   case 5:
_0xD1:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xD2
; 0000 021C     glcd_outtextxy(117,5,"6");
	CALL SUBOPT_0xC
	__POINTW2MN _0xC6,30
	RJMP _0x128
; 0000 021D     showled(d);
; 0000 021E     break;
; 0000 021F   case 6:
_0xD2:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xD3
; 0000 0220     glcd_outtextxy(117,5,"7");
	CALL SUBOPT_0xC
	__POINTW2MN _0xC6,32
	RJMP _0x128
; 0000 0221     showled(d);
; 0000 0222     break;
; 0000 0223   case 7:
_0xD3:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xCC
; 0000 0224     glcd_outtextxy(117,5,"8");
	CALL SUBOPT_0xC
	__POINTW2MN _0xC6,34
_0x128:
	CALL _glcd_outtextxy
; 0000 0225     showled(d);
	MOVW R26,R16
	RCALL _showled
; 0000 0226     break;
; 0000 0227     }
_0xCC:
; 0000 0228  if(PINB.7==0){while(PINB.7==0);break;}
	SBIC 0x16,7
	RJMP _0xD5
_0xD6:
	SBIS 0x16,7
	RJMP _0xD6
	RJMP _0xC9
; 0000 0229  if(PINB.2==0){while(PINB.2==0);savepattern(d);}
_0xD5:
	SBIC 0x16,2
	RJMP _0xD9
_0xDA:
	SBIS 0x16,2
	RJMP _0xDA
	MOVW R26,R16
	RCALL _savepattern
; 0000 022A  if(PIND.6==0){while(PIND.6==0);d++;if(d>7){d=0;}}
_0xD9:
	SBIC 0x10,6
	RJMP _0xDD
_0xDE:
	SBIS 0x10,6
	RJMP _0xDE
	__ADDWRN 16,17,1
	__CPWRN 16,17,8
	BRLT _0xE1
	__GETWRN 16,17,0
_0xE1:
; 0000 022B  if(PIND.4==0){while(PIND.4==0);d--;if(d<0){d=7;}}
_0xDD:
	SBIC 0x10,4
	RJMP _0xE2
_0xE3:
	SBIS 0x10,4
	RJMP _0xE3
	__SUBWRN 16,17,1
	TST  R17
	BRPL _0xE6
	__GETWRN 16,17,7
_0xE6:
; 0000 022C }
_0xE2:
	RJMP _0xC7
_0xC9:
; 0000 022D glcd_clear();
	CALL _glcd_clear
; 0000 022E }
_0x2120010:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0xC6:
	.BYTE 0x24
;
;void savepattern(int x){
; 0000 0230 void savepattern(int x){

	.CSEG
_savepattern:
; .FSTART _savepattern
; 0000 0231 int j=0;
; 0000 0232 glcd_outtextxy(70,15,"         ");
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x2
;	x -> Y+2
;	j -> R16,R17
	CALL SUBOPT_0xF
	__POINTW2MN _0xE7,0
	CALL SUBOPT_0x10
; 0000 0233 glcd_outtextxy(70,20,"         ");
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0xE7,10
	CALL SUBOPT_0x10
; 0000 0234 glcd_outtextxy(70,25,"         ");
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0xE7,20
	CALL SUBOPT_0x10
; 0000 0235 glcd_outtextxy(70,30,"         ");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0xE7,30
	CALL SUBOPT_0x11
; 0000 0236 glcd_outtextxy(74,20,"PRESS ED");
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0xE7,40
	CALL SUBOPT_0x12
; 0000 0237 glcd_outtextxy(77,30,"TO EDIT");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0xE7,49
	CALL _glcd_outtextxy
; 0000 0238 while(1){
_0xE8:
; 0000 0239     glcd_rectround(16*(j%4),16*(j/4),17,17, 0);
	CALL SUBOPT_0x13
	LDI  R26,LOW(16)
	MULS R30,R26
	ST   -Y,R0
	CALL SUBOPT_0x14
	LDI  R26,LOW(16)
	MULS R30,R26
	ST   -Y,R0
	LDI  R30,LOW(17)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _glcd_rectround
; 0000 023A     if(PIND.7==0){while(PIND.7==0);clearround(j);if(j>11){j=(j%4);}else{j=j+4;}}
	SBIC 0x10,7
	RJMP _0xEB
_0xEC:
	SBIS 0x10,7
	RJMP _0xEC
	MOVW R26,R16
	RCALL _clearround
	__CPWRN 16,17,12
	BRLT _0xEF
	CALL SUBOPT_0x13
	MOVW R16,R30
	RJMP _0xF0
_0xEF:
	__ADDWRN 16,17,4
_0xF0:
; 0000 023B     if(PIND.5==0){while(PIND.5==0);clearround(j);if(j<4){j=12+(j%4);}else{j=j-4;}}
_0xEB:
	SBIC 0x10,5
	RJMP _0xF1
_0xF2:
	SBIS 0x10,5
	RJMP _0xF2
	MOVW R26,R16
	RCALL _clearround
	__CPWRN 16,17,4
	BRGE _0xF5
	MOVW R26,R16
	CALL SUBOPT_0x15
	ADIW R30,12
	MOVW R16,R30
	RJMP _0xF6
_0xF5:
	__SUBWRN 16,17,4
_0xF6:
; 0000 023C     if(PIND.6==0){while(PIND.6==0);clearround(j);if((j+1)%4==0){j=(j/4)*4;}else{j=j+1;}}
_0xF1:
	SBIC 0x10,6
	RJMP _0xF7
_0xF8:
	SBIS 0x10,6
	RJMP _0xF8
	MOVW R26,R16
	RCALL _clearround
	MOVW R26,R16
	ADIW R26,1
	CALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0xFB
	CALL SUBOPT_0x14
	CALL __LSLW2
	MOVW R16,R30
	RJMP _0xFC
_0xFB:
	__ADDWRN 16,17,1
_0xFC:
; 0000 023D     if(PIND.4==0){while(PIND.4==0);clearround(j);if(j%4==0){j=j+3;}else{j=j-1;}}
_0xF7:
	SBIC 0x10,4
	RJMP _0xFD
_0xFE:
	SBIS 0x10,4
	RJMP _0xFE
	MOVW R26,R16
	RCALL _clearround
	MOVW R26,R16
	CALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0x101
	__ADDWRN 16,17,3
	RJMP _0x102
_0x101:
	__SUBWRN 16,17,1
_0x102:
; 0000 023E     if(PINB.7==0){while(PINB.7==0);clearround(j);break;}
_0xFD:
	SBIC 0x16,7
	RJMP _0x103
_0x104:
	SBIS 0x16,7
	RJMP _0x104
	MOVW R26,R16
	RCALL _clearround
	RJMP _0xEA
; 0000 023F     if(PINB.2==0){while(PINB.2==0);save2pattern(j,x);}
_0x103:
	SBIC 0x16,2
	RJMP _0x107
_0x108:
	SBIS 0x16,2
	RJMP _0x108
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _save2pattern
; 0000 0240 }
_0x107:
	RJMP _0xE8
_0xEA:
; 0000 0241 glcd_outtextxy(70,15,"         ");
	CALL SUBOPT_0xF
	__POINTW2MN _0xE7,57
	CALL SUBOPT_0x10
; 0000 0242 glcd_outtextxy(70,20,"         ");
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0xE7,67
	CALL SUBOPT_0x10
; 0000 0243 glcd_outtextxy(70,25,"         ");
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0xE7,77
	CALL SUBOPT_0x10
; 0000 0244 glcd_outtextxy(70,30,"         ");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0xE7,87
	CALL SUBOPT_0x9
; 0000 0245 glcd_circle(84,25,10);
; 0000 0246 glcd_outtextxy(78,22,"<<");
	__POINTW2MN _0xE7,97
	CALL SUBOPT_0xA
; 0000 0247 glcd_circle(110,25,10);
; 0000 0248 glcd_outtextxy(106,22,">>");
	__POINTW2MN _0xE7,100
	CALL _glcd_outtextxy
; 0000 0249 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x212000E
; .FEND

	.DSEG
_0xE7:
	.BYTE 0x67
;
;void clearround(int w){
; 0000 024B void clearround(int w){

	.CSEG
_clearround:
; .FSTART _clearround
; 0000 024C int k=0;
; 0000 024D     for(k=0;k<16;k++){
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x2
;	w -> Y+2
;	k -> R16,R17
	__GETWRN 16,17,0
_0x10C:
	__CPWRN 16,17,16
	BRGE _0x10D
; 0000 024E         glcd_clrpixel( ((w%4)*16)+k , (w/4)*16 );
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	MOV  R26,R30
	CALL _glcd_clrpixel
; 0000 024F     }
	__ADDWRN 16,17,1
	RJMP _0x10C
_0x10D:
; 0000 0250     for(k=0;k<16;k++){
	__GETWRN 16,17,0
_0x10F:
	__CPWRN 16,17,16
	BRGE _0x110
; 0000 0251         glcd_clrpixel( ((w%4)*16)+16 , ((w/4)*16) + k );
	CALL SUBOPT_0x16
	SUBI R30,-LOW(16)
	ST   -Y,R30
	CALL SUBOPT_0x18
; 0000 0252     }
	__ADDWRN 16,17,1
	RJMP _0x10F
_0x110:
; 0000 0253     for(k=16;k>0;k--){
	__GETWRN 16,17,16
_0x112:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x113
; 0000 0254         if ( w<12 ) { glcd_clrpixel( ((w%4)*16)+k , (w/4)*16 + 16 ); }
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,12
	BRGE _0x114
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	SUBI R30,-LOW(16)
	MOV  R26,R30
	CALL _glcd_clrpixel
; 0000 0255         else { glcd_clrpixel( ((w%4)*16)+k , (w/4)*16 + 15 ); k=k-3; }
	RJMP _0x115
_0x114:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	SUBI R30,-LOW(15)
	MOV  R26,R30
	CALL _glcd_clrpixel
	__SUBWRN 16,17,3
_0x115:
; 0000 0256     }
	__SUBWRN 16,17,1
	RJMP _0x112
_0x113:
; 0000 0257     for(k=16;k>0;k--){
	__GETWRN 16,17,16
_0x117:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x118
; 0000 0258         glcd_clrpixel( (w%4)*16 , ((w/4)*16) + k );
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x19
	MULS R30,R26
	ST   -Y,R0
	CALL SUBOPT_0x18
; 0000 0259     }
	__SUBWRN 16,17,1
	RJMP _0x117
_0x118:
; 0000 025A }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x212000E
; .FEND
;
;void save2pattern(int j,int x){
; 0000 025C void save2pattern(int j,int x){
_save2pattern:
; .FSTART _save2pattern
; 0000 025D int shifter=0,k=0;
; 0000 025E char binary,buffer_center[2];
; 0000 025F glcd_outtextxy(70,15,"         ");
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,2
	CALL __SAVELOCR6
;	j -> Y+10
;	x -> Y+8
;	shifter -> R16,R17
;	k -> R18,R19
;	binary -> R21
;	buffer_center -> Y+6
	CALL SUBOPT_0x4
	CALL SUBOPT_0xF
	__POINTW2MN _0x119,0
	CALL SUBOPT_0x10
; 0000 0260 glcd_outtextxy(70,20,"         ");
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0x119,10
	CALL SUBOPT_0x10
; 0000 0261 glcd_outtextxy(70,25,"         ");
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x119,20
	CALL SUBOPT_0x10
; 0000 0262 glcd_outtextxy(70,30,"         ");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0x119,30
	CALL SUBOPT_0x11
; 0000 0263 glcd_outtextxy(74,19,"USE KEYS");
	LDI  R30,LOW(19)
	ST   -Y,R30
	__POINTW2MN _0x119,40
	CALL SUBOPT_0x12
; 0000 0264 glcd_outtextxy(77,29,"TO EDIT");
	LDI  R30,LOW(29)
	ST   -Y,R30
	__POINTW2MN _0x119,49
	CALL _glcd_outtextxy
; 0000 0265 glcd_outtextxy(78,48,"SV");
	CALL SUBOPT_0xB
	__POINTW2MN _0x119,57
	CALL _glcd_outtextxy
; 0000 0266 buffer_center[0]=center[j][x][0];
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDB
	STD  Y+6,R30
; 0000 0267 buffer_center[1]=center[j][x][1];
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	CALL __EEPROMRDB
	STD  Y+7,R30
; 0000 0268 while(1){
_0x11A:
; 0000 0269     shifter=keypad();
	RCALL _keypad
	MOVW R16,R30
; 0000 026A     if( shifter<8 ){
	__CPWRN 16,17,8
	BRGE _0x11D
; 0000 026B         binary = 0b00000001 << shifter ;
	MOV  R30,R16
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R21,R30
; 0000 026C         k=0;
	__GETWRN 18,19,0
; 0000 026D         if( (buffer_center[k] & binary) == binary ){
	CALL SUBOPT_0x1C
	AND  R30,R21
	CP   R21,R30
	BRNE _0x11E
; 0000 026E             glcd_clrpixel( (j%4)*16 + 2 + (shifter%4)*4 , (j/4)*16 + 2 + (shifter/4)*4 );
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	CALL _glcd_clrpixel
; 0000 026F             buffer_center[k]=buffer_center[k] ^ binary ;
	RJMP _0x129
; 0000 0270         }
; 0000 0271         else{
_0x11E:
; 0000 0272             glcd_setpixel( (j%4)*16 + 2 + (shifter%4)*4 , (j/4)*16 + 2 + (shifter/4)*4 );
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	CALL _glcd_setpixel
; 0000 0273             buffer_center[k]=buffer_center[k] ^ binary ;
_0x129:
	MOVW R30,R18
	CALL SUBOPT_0x21
	EOR  R30,R21
	MOVW R26,R0
	ST   X,R30
; 0000 0274         }
; 0000 0275     }
; 0000 0276     else if(shifter == 16){
	RJMP _0x120
_0x11D:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+2
	RJMP _0x121
; 0000 0277         center[j][x][0]=buffer_center[0];
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+6
	CALL __EEPROMWRB
; 0000 0278         center[j][x][1]=buffer_center[1];
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LDD  R30,Y+7
	CALL __EEPROMWRB
; 0000 0279         glcd_outtextxy(70,15,"         ");
	CALL SUBOPT_0xF
	__POINTW2MN _0x119,60
	CALL SUBOPT_0x10
; 0000 027A         glcd_outtextxy(70,20,"         ");
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0x119,70
	CALL SUBOPT_0x10
; 0000 027B         glcd_outtextxy(70,25,"         ");
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x119,80
	CALL SUBOPT_0x10
; 0000 027C         glcd_outtextxy(70,30,"         ");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0x119,90
	CALL _glcd_outtextxy
; 0000 027D         glcd_outtextxy(82,20,"BLOCK");
	LDI  R30,LOW(82)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0x119,100
	CALL _glcd_outtextxy
; 0000 027E         glcd_outtextxy(78,30,"SAVED !");
	LDI  R30,LOW(78)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0x119,106
	CALL _glcd_outtextxy
; 0000 027F         writeapply(x,j);
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL _writeapply
; 0000 0280         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0281         break; }
	RJMP _0x11C
; 0000 0282     else if(shifter == 17){ break; }
_0x121:
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x11C
; 0000 0283     else {
; 0000 0284         binary = 0b00000001 << (shifter-8) ;
	MOV  R30,R16
	SUBI R30,LOW(8)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R21,R30
; 0000 0285         k=1;
	__GETWRN 18,19,1
; 0000 0286         if( (buffer_center[k] & binary) == binary ){
	CALL SUBOPT_0x1C
	AND  R30,R21
	CP   R21,R30
	BRNE _0x125
; 0000 0287             glcd_clrpixel( (j%4)*16 + 2 + (shifter%4)*4 , (j/4)*16 + 2 + (shifter/4)*4 );
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	CALL _glcd_clrpixel
; 0000 0288             buffer_center[k]=buffer_center[k] ^ binary ;
	RJMP _0x12A
; 0000 0289         }
; 0000 028A         else{
_0x125:
; 0000 028B             glcd_setpixel( (j%4)*16 + 2 + (shifter%4)*4 , (j/4)*16 + 2 + (shifter/4)*4 );
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	CALL _glcd_setpixel
; 0000 028C             buffer_center[k]=buffer_center[k] ^ binary ;
_0x12A:
	MOVW R30,R18
	CALL SUBOPT_0x21
	EOR  R30,R21
	MOVW R26,R0
	ST   X,R30
; 0000 028D         }
; 0000 028E     }
_0x120:
; 0000 028F }
	RJMP _0x11A
_0x11C:
; 0000 0290 glcd_outtextxy(70,15,"         ");
	CALL SUBOPT_0xF
	__POINTW2MN _0x119,114
	CALL SUBOPT_0x10
; 0000 0291 glcd_outtextxy(70,20,"         ");
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0x119,124
	CALL SUBOPT_0x10
; 0000 0292 glcd_outtextxy(70,25,"         ");
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x119,134
	CALL SUBOPT_0x10
; 0000 0293 glcd_outtextxy(70,30,"         ");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0x119,144
	CALL SUBOPT_0x11
; 0000 0294 glcd_outtextxy(74,19,"PRESS ED");
	LDI  R30,LOW(19)
	ST   -Y,R30
	__POINTW2MN _0x119,154
	CALL SUBOPT_0x12
; 0000 0295 glcd_outtextxy(77,29,"TO EDIT");
	LDI  R30,LOW(29)
	ST   -Y,R30
	__POINTW2MN _0x119,163
	CALL _glcd_outtextxy
; 0000 0296 glcd_outtextxy(78,48,"ED");
	CALL SUBOPT_0xB
	__POINTW2MN _0x119,171
	CALL _glcd_outtextxy
; 0000 0297 }
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND

	.DSEG
_0x119:
	.BYTE 0xAE
;
;void patternapply(int d){
; 0000 0299 void patternapply(int d){

	.CSEG
_patternapply:
; .FSTART _patternapply
; 0000 029A     char temp,select=0b10001111;
; 0000 029B     temp = d << 4 ;
	CALL SUBOPT_0x22
;	d -> Y+2
;	temp -> R17
;	select -> R16
	LDI  R16,143
	LDD  R30,Y+2
	SWAP R30
	ANDI R30,0xF0
	MOV  R17,R30
; 0000 029C     temp = select ^ temp ;
	EOR  R17,R16
; 0000 029D //    putchar('X');
; 0000 029E //    delay_us(50);
; 0000 029F     putchar(temp);
	MOV  R26,R17
	CALL _putchar
; 0000 02A0 //    delay_us(50);
; 0000 02A1 //    putchar('Z') ;
; 0000 02A2 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x212000E
; .FEND
;
;void writeapply(int d,int w){
; 0000 02A4 void writeapply(int d,int w){
_writeapply:
; .FSTART _writeapply
; 0000 02A5 char temp,write=0b00000000;
; 0000 02A6 temp = d << 4 ;
	CALL SUBOPT_0x22
;	d -> Y+4
;	w -> Y+2
;	temp -> R17
;	write -> R16
	LDI  R16,0
	LDD  R30,Y+4
	SWAP R30
	ANDI R30,0xF0
	MOV  R17,R30
; 0000 02A7 write = write ^ temp ;
	EOR  R16,R17
; 0000 02A8 temp = w << 0 ;
	LDD  R17,Y+2
; 0000 02A9 write = write ^ temp ;
	EOR  R16,R17
; 0000 02AA //putchar('X');
; 0000 02AB //delay_us(100);
; 0000 02AC putchar(write);
	MOV  R26,R16
	CALL SUBOPT_0x23
; 0000 02AD delay_us(100);
; 0000 02AE putchar(center[w][d][0]);
	MOVW R26,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDB
	MOV  R26,R30
	CALL SUBOPT_0x23
; 0000 02AF delay_us(100);
; 0000 02B0 putchar(center[w][d][1]);
	MOVW R26,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	CALL __EEPROMRDB
	MOV  R26,R30
	CALL _putchar
; 0000 02B1 //delay_us(100);
; 0000 02B2 //putchar('Z') ;
; 0000 02B3 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x212000B
; .FEND
;
;//void defaultpattern(void){
;//int block=0,pattern=0,row=0;
;//int num =0b11011101;
;//for(block=0;block<16;block++){
;//    for(pattern=0;pattern<8;pattern++){
;//        for(row=0;row<2;row++){
;//            center[block][pattern][row]= num;
;//            num++;
;//        }
;//    }
;//num=0b11011101;
;//}
;//}
;
;
;

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	CALL SUBOPT_0x22
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	JMP  _0x212000D
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x24
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x24
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x25
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x26
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x25
	CALL SUBOPT_0x27
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x25
	CALL SUBOPT_0x27
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x24
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x24
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x26
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x24
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x26
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x29
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x212000F
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x29
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x212000F:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_ks0108_enable_G102:
; .FSTART _ks0108_enable_G102
	nop
	SBI  0x18,4
	nop
	RET
; .FEND
_ks0108_disable_G102:
; .FSTART _ks0108_disable_G102
	CBI  0x18,4
	CBI  0x18,5
	CBI  0x18,6
	RET
; .FEND
_ks0108_rdbus_G102:
; .FSTART _ks0108_rdbus_G102
	ST   -Y,R17
	RCALL _ks0108_enable_G102
	IN   R17,19
	CBI  0x18,4
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G102:
; .FSTART _ks0108_busy_G102
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(0)
	OUT  0x14,R30
	SBI  0x18,3
	CBI  0x18,1
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x2040003
	SBI  0x18,5
	RJMP _0x2040004
_0x2040003:
	CBI  0x18,5
_0x2040004:
	SBRS R17,1
	RJMP _0x2040005
	SBI  0x18,6
	RJMP _0x2040006
_0x2040005:
	CBI  0x18,6
_0x2040006:
_0x2040007:
	RCALL _ks0108_rdbus_G102
	ANDI R30,LOW(0x80)
	BRNE _0x2040007
	LDD  R17,Y+0
	RJMP _0x212000C
; .FEND
_ks0108_wrcmd_G102:
; .FSTART _ks0108_wrcmd_G102
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G102
	CALL SUBOPT_0x2A
	RJMP _0x212000C
; .FEND
_ks0108_setloc_G102:
; .FSTART _ks0108_setloc_G102
	__GETB1MN _ks0108_coord_G102,1
	ST   -Y,R30
	LDS  R30,_ks0108_coord_G102
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G102
	__GETB1MN _ks0108_coord_G102,1
	ST   -Y,R30
	__GETB1MN _ks0108_coord_G102,2
	ORI  R30,LOW(0xB8)
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G102
	RET
; .FEND
_ks0108_gotoxp_G102:
; .FSTART _ks0108_gotoxp_G102
	ST   -Y,R26
	LDD  R30,Y+1
	STS  _ks0108_coord_G102,R30
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	__PUTB1MN _ks0108_coord_G102,1
	LD   R30,Y
	__PUTB1MN _ks0108_coord_G102,2
	RCALL _ks0108_setloc_G102
	RJMP _0x212000C
; .FEND
_ks0108_nextx_G102:
; .FSTART _ks0108_nextx_G102
	LDS  R26,_ks0108_coord_G102
	SUBI R26,-LOW(1)
	STS  _ks0108_coord_G102,R26
	CPI  R26,LOW(0x80)
	BRLO _0x204000A
	LDI  R30,LOW(0)
	STS  _ks0108_coord_G102,R30
_0x204000A:
	LDS  R30,_ks0108_coord_G102
	ANDI R30,LOW(0x3F)
	BRNE _0x204000B
	LDS  R30,_ks0108_coord_G102
	ST   -Y,R30
	__GETB2MN _ks0108_coord_G102,2
	RCALL _ks0108_gotoxp_G102
_0x204000B:
	RET
; .FEND
_ks0108_wrdata_G102:
; .FSTART _ks0108_wrdata_G102
	ST   -Y,R26
	__GETB2MN _ks0108_coord_G102,1
	RCALL _ks0108_busy_G102
	SBI  0x18,1
	CALL SUBOPT_0x2A
	ADIW R28,1
	RET
; .FEND
_ks0108_rddata_G102:
; .FSTART _ks0108_rddata_G102
	__GETB2MN _ks0108_coord_G102,1
	RCALL _ks0108_busy_G102
	LDI  R30,LOW(0)
	OUT  0x14,R30
	SBI  0x18,3
	SBI  0x18,1
	RCALL _ks0108_rdbus_G102
	RET
; .FEND
_ks0108_rdbyte_G102:
; .FSTART _ks0108_rdbyte_G102
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	RCALL _ks0108_rddata_G102
	RCALL _ks0108_setloc_G102
	RCALL _ks0108_rddata_G102
	RJMP _0x212000C
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x17,4
	SBI  0x17,3
	SBI  0x17,1
	SBI  0x17,0
	SBI  0x18,0
	SBI  0x17,5
	SBI  0x17,6
	RCALL _ks0108_disable_G102
	CBI  0x18,0
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x18,0
	LDI  R17,LOW(0)
_0x204000C:
	CPI  R17,2
	BRSH _0x204000E
	ST   -Y,R17
	LDI  R26,LOW(63)
	RCALL _ks0108_wrcmd_G102
	ST   -Y,R17
	INC  R17
	LDI  R26,LOW(192)
	RCALL _ks0108_wrcmd_G102
	RJMP _0x204000C
_0x204000E:
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x204000F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20400AC
_0x204000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20400AC:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R16,0
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2040015
	LDI  R16,LOW(255)
_0x2040015:
_0x2040016:
	CPI  R19,8
	BRSH _0x2040018
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R19
	SUBI R19,-1
	RCALL _ks0108_gotoxp_G102
	LDI  R17,LOW(0)
_0x2040019:
	MOV  R26,R17
	SUBI R17,-1
	CPI  R26,LOW(0x80)
	BRSH _0x204001B
	MOV  R26,R16
	CALL SUBOPT_0x2D
	RJMP _0x2040019
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ks0108_gotoxp_G102
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
_0x212000E:
	ADIW R28,4
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x80)
	BRSH _0x204001D
	LDD  R26,Y+3
	CPI  R26,LOW(0x40)
	BRLO _0x204001C
_0x204001D:
	RJMP _0x212000D
_0x204001C:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _ks0108_rdbyte_G102
	MOV  R17,R30
	RCALL _ks0108_setloc_G102
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x204001F
	OR   R17,R16
	RJMP _0x2040020
_0x204001F:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2040020:
	MOV  R26,R17
	RCALL _ks0108_wrdata_G102
_0x212000D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
_glcd_getpixel:
; .FSTART _glcd_getpixel
	ST   -Y,R26
	LDD  R26,Y+1
	CPI  R26,LOW(0x80)
	BRSH _0x2040022
	LD   R26,Y
	CPI  R26,LOW(0x40)
	BRLO _0x2040021
_0x2040022:
	LDI  R30,LOW(0)
	RJMP _0x212000C
_0x2040021:
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _ks0108_rdbyte_G102
	MOV  R1,R30
	LD   R30,Y
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R1
	BREQ _0x2040024
	LDI  R30,LOW(1)
	RJMP _0x2040025
_0x2040024:
	LDI  R30,LOW(0)
_0x2040025:
_0x212000C:
	ADIW R28,2
	RET
; .FEND
_ks0108_wrmasked_G102:
; .FSTART _ks0108_wrmasked_G102
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _ks0108_rdbyte_G102
	MOV  R17,R30
	RCALL _ks0108_setloc_G102
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x204002B
	CPI  R30,LOW(0x8)
	BRNE _0x204002C
_0x204002B:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x204002D
_0x204002C:
	CPI  R30,LOW(0x3)
	BRNE _0x204002F
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2040030
_0x204002F:
	CPI  R30,0
	BRNE _0x2040031
_0x2040030:
_0x204002D:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2040032
_0x2040031:
	CPI  R30,LOW(0x2)
	BRNE _0x2040033
_0x2040032:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2040029
_0x2040033:
	CPI  R30,LOW(0x1)
	BRNE _0x2040034
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2040029
_0x2040034:
	CPI  R30,LOW(0x4)
	BRNE _0x2040029
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2040029:
	MOV  R26,R17
	CALL SUBOPT_0x2D
	LDD  R17,Y+0
_0x212000B:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x80)
	BRSH _0x2040037
	LDD  R26,Y+15
	CPI  R26,LOW(0x40)
	BRSH _0x2040037
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x2040037
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x2040036
_0x2040037:
	RJMP _0x212000A
_0x2040036:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2040039
	LDD  R26,Y+16
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+14,R30
_0x2040039:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x204003A
	LDD  R26,Y+15
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+13,R30
_0x204003A:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x204003B
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x204003F
	RJMP _0x212000A
_0x204003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2040042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2040041
	RJMP _0x212000A
_0x2040041:
_0x2040042:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2040044
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2040043
_0x2040044:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x2E
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x2040046:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x2040048
	MOV  R17,R16
_0x2040049:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204004B
	CALL SUBOPT_0x2F
	RJMP _0x2040049
_0x204004B:
	RJMP _0x2040046
_0x2040048:
_0x2040043:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x204004C
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x2E
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x204004D
	SUBI R19,-LOW(1)
_0x204004D:
	LDI  R18,LOW(0)
_0x204004E:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2040050
	LDD  R17,Y+14
_0x2040051:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2040053
	CALL SUBOPT_0x2F
	RJMP _0x2040051
_0x2040053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x2E
	RJMP _0x204004E
_0x2040050:
_0x204004C:
_0x204003B:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2040054:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040056
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x2040057
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x2040058
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x204005D
	CPI  R30,LOW(0x3)
	BRNE _0x204005E
_0x204005D:
	RJMP _0x204005F
_0x204005E:
	CPI  R30,LOW(0x7)
	BRNE _0x2040060
_0x204005F:
	RJMP _0x2040061
_0x2040060:
	CPI  R30,LOW(0x8)
	BRNE _0x2040062
_0x2040061:
	RJMP _0x2040063
_0x2040062:
	CPI  R30,LOW(0x6)
	BRNE _0x2040064
_0x2040063:
	RJMP _0x2040065
_0x2040064:
	CPI  R30,LOW(0x9)
	BRNE _0x2040066
_0x2040065:
	RJMP _0x2040067
_0x2040066:
	CPI  R30,LOW(0xA)
	BRNE _0x204005B
_0x2040067:
	ST   -Y,R16
	LDD  R30,Y+16
	CALL SUBOPT_0x2C
_0x204005B:
_0x2040069:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204006B
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x204006C
	RCALL _ks0108_rddata_G102
	RCALL _ks0108_setloc_G102
	CALL SUBOPT_0x30
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ks0108_rddata_G102
	MOV  R26,R30
	CALL _glcd_writemem
	RCALL _ks0108_nextx_G102
	RJMP _0x204006D
_0x204006C:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2040071
	LDI  R21,LOW(0)
	RJMP _0x2040072
_0x2040071:
	CPI  R30,LOW(0xA)
	BRNE _0x2040070
	LDI  R21,LOW(255)
	RJMP _0x2040072
_0x2040070:
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2040079
	CPI  R30,LOW(0x8)
	BRNE _0x204007A
_0x2040079:
_0x2040072:
	CALL SUBOPT_0x32
	MOV  R21,R30
	RJMP _0x204007B
_0x204007A:
	CPI  R30,LOW(0x3)
	BRNE _0x204007D
	COM  R21
	RJMP _0x204007E
_0x204007D:
	CPI  R30,0
	BRNE _0x2040080
_0x204007E:
_0x204007B:
	MOV  R26,R21
	CALL SUBOPT_0x2D
	RJMP _0x2040077
_0x2040080:
	CALL SUBOPT_0x33
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G102
_0x2040077:
_0x204006D:
	RJMP _0x2040069
_0x204006B:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2040081
_0x2040058:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2040082
_0x2040057:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2040083
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2040084
_0x2040083:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2040084:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2040088
_0x2040089:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204008B
	CALL SUBOPT_0x34
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x35
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x30
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2040089
_0x204008B:
	RJMP _0x2040087
_0x2040088:
	CPI  R30,LOW(0x9)
	BRNE _0x204008C
	LDI  R21,LOW(0)
	RJMP _0x204008D
_0x204008C:
	CPI  R30,LOW(0xA)
	BRNE _0x2040093
	LDI  R21,LOW(255)
_0x204008D:
	CALL SUBOPT_0x32
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2040090:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2040092
	CALL SUBOPT_0x33
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G102
	RJMP _0x2040090
_0x2040092:
	RJMP _0x2040087
_0x2040093:
_0x2040094:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2040096
	CALL SUBOPT_0x36
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G102
	RJMP _0x2040094
_0x2040096:
_0x2040087:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x2040097
	RJMP _0x2040056
_0x2040097:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x2040098
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20400AD
_0x2040098:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20400AD:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2040082:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x204009D
_0x204009E:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20400A0
	CALL SUBOPT_0x34
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x35
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x30
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x204009E
_0x20400A0:
	RJMP _0x204009C
_0x204009D:
	CPI  R30,LOW(0x9)
	BRNE _0x20400A1
	LDI  R21,LOW(0)
	RJMP _0x20400A2
_0x20400A1:
	CPI  R30,LOW(0xA)
	BRNE _0x20400A8
	LDI  R21,LOW(255)
_0x20400A2:
	CALL SUBOPT_0x32
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x20400A5:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20400A7
	CALL SUBOPT_0x33
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G102
	RJMP _0x20400A5
_0x20400A7:
	RJMP _0x204009C
_0x20400A8:
_0x20400A9:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20400AB
	CALL SUBOPT_0x36
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G102
	RJMP _0x20400A9
_0x20400AB:
_0x204009C:
_0x2040081:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2040054
_0x2040056:
_0x212000A:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x37
	BRLT _0x2060003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120003
_0x2060003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2060004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	JMP  _0x2120003
_0x2060004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x37
	BRLT _0x2060005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120003
_0x2060005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2060006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	JMP  _0x2120003
_0x2060006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120003
; .FEND
_glcd_setpixel:
; .FSTART _glcd_setpixel
	CALL SUBOPT_0x2B
	ST   -Y,R30
	LDS  R26,_glcd_state
	RCALL _glcd_putpixel
	JMP  _0x2120003
; .FEND
_glcd_clrpixel:
; .FSTART _glcd_clrpixel
	CALL SUBOPT_0x2B
	ST   -Y,R30
	__GETB2MN _glcd_state,1
	RCALL _glcd_putpixel
	JMP  _0x2120003
; .FEND
_glcd_getcharw_G103:
; .FSTART _glcd_getcharw_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x38
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x206000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120009
_0x206000B:
	CALL SUBOPT_0x39
	STD  Y+7,R0
	CALL SUBOPT_0x39
	STD  Y+6,R0
	CALL SUBOPT_0x39
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x206000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120009
_0x206000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x206000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120009
_0x206000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x206000E
	SUBI R20,-LOW(1)
_0x206000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x206000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120009
_0x206000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2060010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2060012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2060010
_0x2060012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2120009:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G103:
; .FSTART _glcd_new_line_G103
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x3A
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x38
	SBIW R30,0
	BRNE PC+2
	RJMP _0x206001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2060020
	RJMP _0x2060021
_0x2060020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G103
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2060022
	CALL __LOADLOCR6
	RJMP _0x2120006
_0x2060022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	CALL SUBOPT_0x3B
	__CPWRN 16,17,129
	BRLO _0x2060023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G103
_0x2060023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x3A
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3C
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x3A
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x3C
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2060024
_0x2060021:
	RCALL _glcd_new_line_G103
	CALL __LOADLOCR6
	RJMP _0x2120006
_0x2060024:
_0x206001F:
	__PUTBMRN _glcd_state,2,16
	CALL __LOADLOCR6
	RJMP _0x2120006
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2060025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2060025
_0x2060027:
	LDD  R17,Y+0
	JMP  _0x2120004
; .FEND
_glcd_putpixelm_G103:
; .FSTART _glcd_putpixelm_G103
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x206003E
	LDS  R30,_glcd_state
	RJMP _0x206003F
_0x206003E:
	__GETB1MN _glcd_state,1
_0x206003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2060041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2060041:
	LD   R30,Y
	JMP  _0x2120002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	JMP  _0x2120003
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2060042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2060043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G103
	RJMP _0x2120008
_0x2060043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2060044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2060045
_0x2060044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2060045:
_0x2060047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2060049:
	CALL SUBOPT_0x3D
	BRSH _0x206004B
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G103
	STD  Y+7,R30
	RJMP _0x2060049
_0x206004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2060047
	RJMP _0x206004C
_0x2060042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x206004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x206004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x206011B
_0x206004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x206011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2060051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2060053:
	CALL SUBOPT_0x3D
	BRSH _0x2060055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x3E
	STD  Y+7,R30
	RJMP _0x2060053
_0x2060055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2060051
	RJMP _0x2060056
_0x206004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2060057:
	CALL SUBOPT_0x3D
	BRLO PC+2
	RJMP _0x2060059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x206005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x206005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x206005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x206005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G103
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x206005C
_0x206005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x3F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2060060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x40
_0x2060060:
	ST   -Y,R17
	CALL SUBOPT_0x3E
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x206005E
	RJMP _0x2060061
_0x206005C:
_0x2060063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x3F
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2060065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x40
_0x2060065:
	ST   -Y,R17
	CALL SUBOPT_0x3E
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2060063
_0x2060061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2060057
_0x2060059:
_0x2060056:
_0x206004C:
_0x2120008:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND
_glcd_corners_G103:
; .FSTART _glcd_corners_G103
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R17,Z+3
	LDD  R16,Z+1
	LDD  R19,Z+2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X
	CP   R16,R17
	BRSH _0x2060066
	MOV  R21,R16
	MOV  R16,R17
	MOV  R17,R21
_0x2060066:
	CP   R18,R19
	BRSH _0x2060067
	MOV  R21,R18
	MOV  R18,R19
	MOV  R19,R21
_0x2060067:
	MOV  R30,R17
	__PUTB1SNS 6,3
	MOV  R30,R19
	__PUTB1SNS 6,2
	MOV  R30,R16
	__PUTB1SNS 6,1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R18
	CALL __LOADLOCR6
	RJMP _0x2120006
; .FEND
_glcd_rectround:
; .FSTART _glcd_rectround
	ST   -Y,R26
	SBIW R28,2
	CALL __SAVELOCR6
	LDD  R30,Y+10
	CPI  R30,0
	BREQ _0x2060069
	LDD  R30,Y+9
	CPI  R30,0
	BRNE _0x206006A
_0x2060069:
	RJMP _0x2060068
_0x206006A:
	LDD  R30,Y+8
	LDD  R26,Y+12
	ADD  R30,R26
	MOV  R17,R30
	LDD  R30,Y+8
	LDD  R26,Y+11
	ADD  R30,R26
	MOV  R18,R30
	__GETB1MN _glcd_state,8
	SUBI R30,LOW(1)
	STD  Y+7,R30
	LDD  R30,Y+10
	LDD  R26,Y+12
	ADD  R26,R30
	SUBI R26,LOW(1)
	MOV  R19,R26
	LDD  R26,Y+8
	MOV  R30,R19
	SUB  R30,R26
	MOV  R16,R30
	LDD  R26,Y+7
	SUB  R19,R26
	LDD  R30,Y+9
	LDD  R26,Y+11
	ADD  R26,R30
	SUBI R26,LOW(1)
	MOV  R20,R26
	LDD  R26,Y+8
	MOV  R30,R20
	SUB  R30,R26
	MOV  R21,R30
	LDD  R26,Y+7
	SUB  R20,R26
	__GETB1MN _glcd_state,9
	STD  Y+6,R30
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	ST   -Y,R17
	LDD  R30,Y+12
	ST   -Y,R30
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	LDD  R26,Y+14
	RCALL _glcd_line
	ST   -Y,R16
	ST   -Y,R18
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(129)
	RCALL _glcd_quadrant_G103
	ST   -Y,R19
	ST   -Y,R18
	ST   -Y,R19
	MOV  R26,R21
	SUBI R26,LOW(1)
	RCALL _glcd_line
	ST   -Y,R16
	ST   -Y,R21
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(136)
	RCALL _glcd_quadrant_G103
	ST   -Y,R16
	ST   -Y,R20
	ST   -Y,R17
	MOV  R26,R20
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R21
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(132)
	RCALL _glcd_quadrant_G103
	LDD  R30,Y+12
	ST   -Y,R30
	ST   -Y,R21
	LDD  R30,Y+14
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R18
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(130)
	RCALL _glcd_quadrant_G103
	LDD  R30,Y+6
	__PUTB1MN _glcd_state,9
	RJMP _0x206006B
_0x2060068:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+12
	RCALL _glcd_setpixel
_0x206006B:
	CALL __LOADLOCR6
	ADIW R28,13
	RET
; .FEND
_glcd_plot8_G103:
; .FSTART _glcd_plot8_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R30,Y+13
	STD  Y+8,R30
	__GETB1MN _glcd_state,8
	STD  Y+7,R30
	LDS  R30,_glcd_state
	STD  Y+6,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	CALL SUBOPT_0x3B
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+16
	CALL SUBOPT_0x41
	LDD  R30,Y+16
	CALL SUBOPT_0x42
	BREQ _0x2060073
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2060075
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x43
	BRLT _0x2060077
	CALL SUBOPT_0x44
	BRGE _0x2060078
_0x2060077:
	RJMP _0x2060076
_0x2060078:
_0x2060073:
	TST  R19
	BRMI _0x2060079
	CALL SUBOPT_0x45
_0x2060079:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x206007B
	__CPWRN 18,19,2
	BRGE _0x206007C
_0x206007B:
	RJMP _0x206007A
_0x206007C:
	CALL SUBOPT_0x46
	BRNE _0x206007D
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x206007D:
_0x206007A:
_0x2060076:
_0x2060075:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x206007F
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2060081
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x47
	BRLT _0x2060083
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x48
	BRGE _0x2060084
_0x2060083:
	RJMP _0x2060082
_0x2060084:
_0x206007F:
	CALL SUBOPT_0x49
	BRLO _0x2060085
	CALL SUBOPT_0x4A
	BRNE _0x2060086
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x2060086:
_0x2060085:
_0x2060082:
_0x2060081:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x2060087
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x2060089
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x206008B
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x47
	BRLT _0x206008D
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x48
	BRGE _0x206008E
_0x206008D:
	RJMP _0x206008C
_0x206008E:
_0x2060089:
	TST  R19
	BRMI _0x206008F
	CALL SUBOPT_0x45
_0x206008F:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x2060091
	__CPWRN 18,19,2
	BRGE _0x2060092
_0x2060091:
	RJMP _0x2060090
_0x2060092:
	CALL SUBOPT_0x46
	BRNE _0x2060093
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x2060093:
_0x2060090:
_0x206008C:
_0x206008B:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x2060095
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2060097
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x43
	BRLT _0x2060099
	CALL SUBOPT_0x44
	BRGE _0x206009A
_0x2060099:
	RJMP _0x2060098
_0x206009A:
_0x2060095:
	CALL SUBOPT_0x49
	BRLO _0x206009B
	CALL SUBOPT_0x4A
	BRNE _0x206009C
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x206009C:
_0x206009B:
_0x2060098:
_0x2060097:
_0x2060087:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	CALL SUBOPT_0x3B
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+15
	CALL SUBOPT_0x41
	LDD  R30,Y+15
	CALL SUBOPT_0x42
	BREQ _0x206009E
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20600A0
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x20600A2
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x20600A3
_0x20600A2:
	RJMP _0x20600A1
_0x20600A3:
_0x206009E:
	TST  R19
	BRMI _0x20600A4
	CALL SUBOPT_0x45
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20600A5
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x4B
	BRNE _0x20600A6
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20600A6:
_0x20600A5:
_0x20600A4:
_0x20600A1:
_0x20600A0:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x20600A8
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20600AA
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	CALL SUBOPT_0x43
	BRLT _0x20600AC
	CALL SUBOPT_0x44
	BRGE _0x20600AD
_0x20600AC:
	RJMP _0x20600AB
_0x20600AD:
_0x20600A8:
	CALL SUBOPT_0x49
	BRLO _0x20600AE
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x4C
	BRNE _0x20600AF
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20600AF:
_0x20600AE:
_0x20600AB:
_0x20600AA:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x20600B0
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x20600B2
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20600B4
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x43
	BRLT _0x20600B6
	CALL SUBOPT_0x44
	BRGE _0x20600B7
_0x20600B6:
	RJMP _0x20600B5
_0x20600B7:
_0x20600B2:
	TST  R19
	BRMI _0x20600B8
	CALL SUBOPT_0x45
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20600BA
	__CPWRN 16,17,2
	BRGE _0x20600BB
_0x20600BA:
	RJMP _0x20600B9
_0x20600BB:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x4B
	BRNE _0x20600BC
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20600BC:
_0x20600B9:
_0x20600B8:
_0x20600B5:
_0x20600B4:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x20600BE
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20600C0
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x47
	BRLT _0x20600C2
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x48
	BRGE _0x20600C3
_0x20600C2:
	RJMP _0x20600C1
_0x20600C3:
_0x20600BE:
	CALL SUBOPT_0x49
	BRLO _0x20600C5
	__CPWRN 16,17,2
	BRGE _0x20600C6
_0x20600C5:
	RJMP _0x20600C4
_0x20600C6:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x4C
	BRNE _0x20600C7
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20600C7:
_0x20600C4:
_0x20600C1:
_0x20600C0:
_0x20600B0:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
; .FEND
_glcd_line2_G103:
; .FSTART _glcd_line2_G103
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipx
	MOV  R17,R30
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipx
	MOV  R16,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipy
	MOV  R19,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	MOV  R18,R30
	ST   -Y,R17
	ST   -Y,R19
	ST   -Y,R16
	MOV  R26,R19
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R18
	ST   -Y,R16
	MOV  R26,R18
	RCALL _glcd_line
	RJMP _0x2120005
; .FEND
_glcd_quadrant_G103:
; .FSTART _glcd_quadrant_G103
	ST   -Y,R26
	CALL __SAVELOCR6
	LDD  R26,Y+9
	CPI  R26,LOW(0x80)
	BRSH _0x20600C9
	LDD  R26,Y+8
	CPI  R26,LOW(0x40)
	BRLO _0x20600C8
_0x20600C9:
	RJMP _0x2120007
_0x20600C8:
	__GETBRMN 21,_glcd_state,8
_0x20600CB:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20600CD
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x20600CE
	RJMP _0x2120007
_0x20600CE:
	LDD  R30,Y+7
	SUBI R30,LOW(1)
	STD  Y+7,R30
	SUBI R30,-LOW(1)
	MOV  R16,R30
	LDI  R31,0
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
	CALL __LSLW2
	CALL __ASRW2
	MOVW R18,R30
	LDI  R17,LOW(0)
_0x20600D0:
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRNE _0x20600D2
	CALL SUBOPT_0x4D
	ST   -Y,R17
	MOV  R26,R16
	RCALL _glcd_line2_G103
	CALL SUBOPT_0x4D
	ST   -Y,R16
	MOV  R26,R17
	RCALL _glcd_line2_G103
	RJMP _0x20600D3
_0x20600D2:
	CALL SUBOPT_0x4D
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+10
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _glcd_plot8_G103
_0x20600D3:
	SUBI R17,-1
	TST  R19
	BRPL _0x20600D4
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x206011C
_0x20600D4:
	SUBI R16,1
	MOV  R26,R17
	CLR  R27
	MOV  R30,R16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
_0x206011C:
	LSL  R30
	ROL  R31
	ADIW R30,1
	__ADDWRR 18,19,30,31
	CP   R16,R17
	BRSH _0x20600D0
	RJMP _0x20600CB
_0x20600CD:
_0x2120007:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
_glcd_circle:
; .FSTART _glcd_circle
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDI  R26,LOW(143)
	RCALL _glcd_quadrant_G103
	JMP  _0x2120002
; .FEND
_glcd_barrel:
; .FSTART _glcd_barrel
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+7
	CPI  R26,LOW(0x80)
	BRSH _0x20600ED
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRLO _0x20600EC
_0x20600ED:
	RJMP _0x2120005
_0x20600EC:
	LDD  R30,Y+5
	CPI  R30,0
	BREQ _0x20600F0
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x20600F1
_0x20600F0:
	RJMP _0x20600EF
_0x20600F1:
	LDD  R19,Y+6
	MOV  R30,R19
	LDD  R26,Y+4
	ADD  R30,R26
	STD  Y+4,R30
	LDD  R30,Y+7
	LDD  R26,Y+5
	ADD  R30,R26
	STD  Y+5,R30
_0x20600F2:
	LDD  R30,Y+4
	CP   R19,R30
	BRSH _0x20600F4
	SUB  R30,R19
	MOV  R18,R30
	CPI  R18,9
	BRLO _0x20600F5
	LDI  R18,LOW(8)
_0x20600F5:
	LDD  R17,Y+7
_0x20600F6:
	LDD  R30,Y+5
	CP   R17,R30
	BRSH _0x20600F8
	SUB  R30,R17
	MOV  R16,R30
	CPI  R16,9
	BRLO _0x20600F9
	LDI  R16,LOW(8)
_0x20600F9:
	ST   -Y,R17
	ST   -Y,R19
	ST   -Y,R16
	ST   -Y,R18
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _glcd_block
	ADD  R17,R16
	RJMP _0x20600F6
_0x20600F8:
	ADD  R19,R18
	RJMP _0x20600F2
_0x20600F4:
_0x20600EF:
_0x2120005:
	CALL __LOADLOCR4
_0x2120006:
	ADIW R28,8
	RET
; .FEND
_glcd_bar:
; .FSTART _glcd_bar
	ST   -Y,R26
	MOVW R26,R28
	RCALL _glcd_corners_G103
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R30,Y+3
	SUB  R30,R26
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R30,Y+3
	SUB  R30,R26
	SUBI R30,-LOW(1)
	MOV  R26,R30
	RCALL _glcd_barrel
	JMP  _0x2120001
; .FEND

	.CSEG

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2120004:
	ADIW R28,5
	RET
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2120003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2100007
	CPI  R30,LOW(0xA)
	BRNE _0x2100008
_0x2100007:
	LDS  R17,_glcd_state
	RJMP _0x2100009
_0x2100008:
	CPI  R30,LOW(0x9)
	BRNE _0x210000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2100009
_0x210000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2100005
	__GETBRMN 17,_glcd_state,16
_0x2100009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x210000E
	CPI  R17,0
	BREQ _0x210000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x210000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120002
_0x210000E:
	CPI  R17,0
	BRNE _0x2100011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x2100011:
_0x2100005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2100015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120002
_0x2100015:
	CPI  R30,LOW(0x2)
	BRNE _0x2100016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120002
_0x2100016:
	CPI  R30,LOW(0x3)
	BRNE _0x2100018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120002
_0x2100018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2120002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x210001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x210001B
_0x210001C:
	CPI  R30,LOW(0x2)
	BRNE _0x210001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x210001B
_0x210001D:
	CPI  R30,LOW(0x3)
	BRNE _0x210001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x210001B:
_0x2120001:
	ADIW R28,4
	RET
; .FEND

	.DSEG
_glcd_state:
	.BYTE 0x1D
_recive:
	.BYTE 0x7

	.ESEG
_center:
	.BYTE 0x100

	.DSEG
_tx_buffer:
	.BYTE 0x8
_rx_buffer:
	.BYTE 0x8
__seed_G100:
	.BYTE 0x4
_ks0108_coord_G102:
	.BYTE 0x3

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	LDI  R26,LOW(5)
	JMP  _glcd_rectround

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	CALL _glcd_outtextxy
	LDI  R30,LOW(5)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _glcd_rectround

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	MOVW R30,R16
	CALL __LSLW2
	ADD  R30,R18
	ADC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(126)
	ST   -Y,R30
	LDI  R30,LOW(62)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R26,LOW(10)
	JMP  _glcd_circle

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	CALL _tablepattern
	LDI  R30,LOW(68)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R30,LOW(64)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x9:
	CALL _glcd_outtextxy
	LDI  R30,LOW(84)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R26,LOW(10)
	CALL _glcd_circle
	LDI  R30,LOW(78)
	ST   -Y,R30
	LDI  R30,LOW(22)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xA:
	CALL _glcd_outtextxy
	LDI  R30,LOW(110)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R26,LOW(10)
	CALL _glcd_circle
	LDI  R30,LOW(106)
	ST   -Y,R30
	LDI  R30,LOW(22)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(78)
	ST   -Y,R30
	LDI  R30,LOW(48)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(117)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	CALL __LSLW4
	SUBI R30,LOW(-_center)
	SBCI R31,HIGH(-_center)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0xE:
	MOVW R30,R18
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	LSL  R30
	LSL  R30
	MOV  R22,R30
	MOVW R30,R16
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	LDI  R26,LOW(16)
	MULS R30,R26
	MOVW R30,R0
	ADD  R30,R22
	SUBI R30,-LOW(2)
	ST   -Y,R30
	MOV  R30,R21
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R22,R30
	MOVW R26,R18
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	LSL  R30
	LSL  R30
	ADD  R22,R30
	MOVW R26,R16
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	LDI  R26,LOW(16)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R22
	ADD  R26,R30
	SUBI R26,-LOW(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(70)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x10:
	CALL _glcd_outtextxy
	LDI  R30,LOW(70)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	CALL _glcd_outtextxy
	LDI  R30,LOW(74)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL _glcd_outtextxy
	LDI  R30,LOW(77)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x13:
	MOVW R30,R16
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x14:
	MOVW R26,R16
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x16:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	LDI  R26,LOW(16)
	MULS R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x17:
	ADD  R30,R16
	ST   -Y,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	LDI  R26,LOW(16)
	MULS R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x18:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	LDI  R26,LOW(16)
	MULS R30,R26
	MOVW R30,R0
	ADD  R30,R16
	MOV  R26,R30
	JMP  _glcd_clrpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	LDI  R26,LOW(16)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	MOVW R26,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1E:
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(2)
	MOV  R0,R30
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x1F:
	LSL  R30
	LSL  R30
	ADD  R30,R0
	ST   -Y,R30
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	LDI  R26,LOW(16)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(2)
	MOV  R20,R30
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	LSL  R30
	LSL  R30
	MOV  R26,R20
	ADD  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	CALL _putchar
	__DELAY_USW 200
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x24:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x28:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
	CBI  0x18,3
	LDI  R30,LOW(255)
	OUT  0x14,R30
	LD   R30,Y
	OUT  0x15,R30
	CALL _ks0108_enable_G102
	JMP  _ks0108_disable_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	CALL _ks0108_wrdata_G102
	JMP  _ks0108_nextx_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2F:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x30:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G102
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x36:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3A:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3D:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R18,R26
	LDD  R26,Y+17
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x42:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDD  R30,Y+8
	ANDI R30,LOW(0x81)
	CPI  R30,LOW(0x81)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x43:
	SUB  R30,R26
	SBC  R31,R27
	MOVW R0,R30
	MOVW R26,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	ST   -Y,R16
	MOV  R26,R18
	JMP  _glcd_setpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x49:
	ST   -Y,R16
	MOV  R26,R20
	CALL _glcd_setpixel
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4B:
	ST   -Y,R30
	MOV  R26,R18
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4C:
	ST   -Y,R30
	MOV  R26,R20
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	LDD  R30,Y+9
	ST   -Y,R30
	LDD  R30,Y+9
	ST   -Y,R30
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
