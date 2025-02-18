/*
 * ADC_program.c
 *
 *  Created on: Jan 17, 2021
 *      Author: Yousef
 */

#include "STD_TYPES.h"
#include "BIT_MATH.h"

#include "DIO_interface.h"
#include "RCC_interface.h"

#include "ADC_private.h"
#include "ADC_interface.h"
#include "ADC_config.h"
void ADC_VoidInit(void)
{
	CLR_REG(ADC_CR1);

	/*for enable and disable scan mode*/
	if(SCAN_MODE == ENABLE_SCAN_MODE)
		SET_BIT(ADC_CR1,SCAN);
	else 
		CLR_BIT(ADC_CR1,SCAN);


	CLR_REG(ADC_CR2);	
	/*to data aligenment*/
	if(DATA_ALIGENMENT == RIGHT_ALIGNMENT)
		CLR_BIT(ADC_CR2,ALIGN);
	else
		SET_BIT(ADC_CR2,ALIGN);

	if (CONVERSION_MODE == CONTINOUS_CONVERSION)
		SET_BIT(ADC_CR2,CONT);
	else
		CLR_BIT(ADC_CR2,CONT);

	CLR_REG(ADC_SMPR2);
	/* Sampling time*/
	ADC_SMPR2 |= SAMPLING_TIME;

	/*number of conversion = 1*/
	ADC_SQR1 |= (NUMBER_CONVERSION << 20 );

	/*Channel_0 Rank_1*/
	ADC_SQR3 |= SELECTED_CHANNEL;

	/*ADC_Power_On*/
	SET_BIT(ADC_CR2,ADON);

	/*reset calibration*/
	SET_BIT(ADC_CR2,RCAL);

	/*calibration*/
	SET_BIT(ADC_CR2,CAL);

}


void start_coversion(void)
{
	/*ADC_Power_On*/
	SET_BIT(ADC_CR2,ADON);
}

u32 ADC_getValue()
{
    return ADC_DR;
}
