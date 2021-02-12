/*******************************************************
Date    : 2/8/2021
Author  :  Mohmmad Javad Adel
*******************************************************/
#include <mega16.h>
#include <delay.h>
#include <glcd.h>
#include <font5x7.h>
#include <stdio.h>
#include <stdlib.h>

eeprom int counter=0;
eeprom char temprature[128];

void plot(void);
void mean(void);

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];
#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index=0,tx_rd_index=0;
#else
unsigned int tx_wr_index=0,tx_rd_index=0;
#endif
#if TX_BUFFER_SIZE < 256
unsigned char tx_counter=0;
#else
unsigned int tx_counter=0;
#endif

interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

void main(void)
{
int i=0;
float temp=0.0;
char send[10],buffer[16];

GLCDINIT_t glcd_init_data;
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
// ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
// Graphic Display Controller initialization
// The KS0108 connections are specified in the
// Project|Configure|C Compiler|Libraries|Graphic Display menu:
// DB0 - PORTB Bit 0
// DB1 - PORTB Bit 1
// DB2 - PORTB Bit 2
// DB3 - PORTB Bit 3
// DB4 - PORTB Bit 4
// DB5 - PORTB Bit 5
// DB6 - PORTB Bit 6
// DB7 - PORTB Bit 7
// E - PORTC Bit 0
// RD /WR - PORTC Bit 1
// RS - PORTC Bit 2
// /RST - PORTC Bit 3
// CS1 - PORTC Bit 4
// CS2 - PORTC Bit 5
glcd_init_data.font=font5x7;
glcd_init_data.readxmem=NULL;
glcd_init_data.writexmem=NULL;
glcd_init(&glcd_init_data);
#asm("sei")
glcd_clear();
glcd_outtextxy(40,20,"WELCOME!");
for(i=0;i<10;i++) {
   delay_ms(10);
   glcd_bar(10+10*i, 40, 20+10*i, 50);
}
glcd_clear();
glcd_rectround(2,2,124,60, 5);
glcd_outtextxy(15,5,"TEMPRATURE  NOW:");
glcd_circle(32,43,15);
glcd_outtextxy(21,40,"PLOT");
glcd_circle(95,43,15);
glcd_outtextxy(83,40,"INFO");
delay_ms(100);
while (1)
      {
        temp = read_adc(0);
        temprature[counter]=(temp-4)/4;
        counter++;
        if(counter>128){counter=0;}
        sprintf(buffer,"-->%-5.2f<--",(temp-4)/4);
        glcd_outtextxy(33,15,buffer);
        if(PIND.2==0){ while(PIND.2==0); plot(); }
        if(PIND.4==0){ while(PIND.4==0); mean(); }
        sprintf(send,"zZ%05.2f CXx",(temp-4)/4);
        for(i=0;i<10;i++)
        {
                putchar(send[i]);
        }
        if(PIND.2==0){ while(PIND.2==0); plot(); }
        if(PIND.4==0){ while(PIND.4==0); mean(); }
        delay_ms(125);
        if(PIND.2==0){ while(PIND.2==0); plot(); }
        if(PIND.4==0){ while(PIND.4==0); mean(); }
      }
}


void plot(void){
int i=0;
glcd_clear();
glcd_rectround(0,0,128,64, 0);
for(i = 1; i<counter;i++){
    glcd_line(i-1,64-temprature[i-1],i,64-temprature[i]);
}
glcd_circle(10,15,10);
glcd_outtextxy(5,13,"BK");
while(PIND.3==1);
while(PIND.3==0);
glcd_clear();
glcd_rectround(2,2,124,60, 5);
glcd_outtextxy(15,5,"TEMPRATURE  NOW:");
glcd_circle(32,43,15);
glcd_outtextxy(21,40,"PLOT");
glcd_circle(95,43,15);
glcd_outtextxy(83,40,"INFO");
}

void mean(void){
int i=0;
float show=0;
char buffer[20];
glcd_clear();
glcd_outtextxy(10,5,"AVERAGE TEMPRATURE:");
glcd_outtextxy(10,25,"MAX TEMPRATURE:");
glcd_outtextxy(10,45,"MIN TEMPRATURE:");
for(i=0;i<counter;i++){
show = show + temprature[i];
}
show = show / counter ;
sprintf(buffer,"%-5.2f",show);
glcd_outtextxy(20,15,buffer);
show = temprature[0];
for(i=1;i<counter;i++){
if(show <= temprature[i]){ show = temprature[i]; }
}
sprintf(buffer,"%-5.2f",show);
glcd_outtextxy(20,35,buffer);
show = temprature[0];
for(i=1;i<counter;i++){
if(show >= temprature[i]){ show = temprature[i]; }
}
sprintf(buffer,"%-5.2f",show);
glcd_outtextxy(20,55,buffer);
glcd_circle(110,50,10);
glcd_outtextxy(105,48,"BK");
while(PIND.3==1);
while(PIND.3==0);
glcd_clear();
glcd_rectround(2,2,124,60, 5);
glcd_outtextxy(15,5,"TEMPRATURE  NOW:");
glcd_circle(32,43,15);
glcd_outtextxy(21,40,"PLOT");
glcd_circle(95,43,15);
glcd_outtextxy(83,40,"INFO");
}


