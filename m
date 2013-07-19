Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59505 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3GSRSW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 13:18:22 -0400
Received: from [192.168.1.101] ([146.52.53.248]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0LhOO8-1UMiZo0Gxc-00mbh0 for
 <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 19:18:20 +0200
Message-ID: <51E974DB.7010609@gmx.net>
Date: Fri, 19 Jul 2013 19:18:19 +0200
From: Jan Taegert <jantaegert@gmx.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, thomas.mair86@googlemail.com
Subject: Re: PROBLEM: dvb-usb-rtl28xxu and Terratec Cinergy TStickRC (rev3)
 - no signal on some frequencies
References: <51E927EC.5030701@gmx.net> <51E92A78.50706@iki.fi>
In-Reply-To: <51E92A78.50706@iki.fi>
Content-Type: multipart/mixed;
 boundary="------------080601030503010206040103"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080601030503010206040103
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

when the culprit is the e4000 driver but the old driver from 
https://github.com/valtri/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0 
worked for me, then must be somewhere there in the driver sources a 
solution for the signal issues.

Does it make sense to look for a particular string in the sources? I 
don't have any clue of coding but perhaps I can be helpful in this way.

There are
- tuner_e4000.c
- nim_rtl2832_e4000.c

Thanks,
Jan.



Am 19.07.2013 14:00, schrieb Antti Palosaari:
> Hello
> It is e4000 driver problem. Someone should take the look what there is
> wrong. Someone sent non-working stick for me, but I wasn't able to
> reproduce issue. I used modulator to generate signal with just same
> parameters he said non-working, but it worked for me. It looks like
> e4000 driver does not perform as well as it should.
>
> Maybe I should take Windows XP and Linux, use modulator to find out
> signal condition where Windows works but Linux not, took sniffs and
> compare registers... But I am busy and help is more than welcome.
>
> regards
> Antti


--------------080601030503010206040103
Content-Type: text/x-csrc;
 name="nim_rtl2832_e4000.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nim_rtl2832_e4000.c"

/**

@file

@brief   RTL2832 E4000 NIM module definition

One can manipulate RTL2832 E4000 NIM through RTL2832 E4000 NIM module.
RTL2832 E4000 NIM module is derived from DVB-T NIM module.

*/


#include "nim_rtl2832_e4000.h"





/**

@brief   RTL2832 E4000 NIM module builder

Use BuildRtl2832E4000Module() to build RTL2832 E4000 NIM module, set all module function pointers with the
corresponding functions, and initialize module private variables.


@param [in]   ppNim                        Pointer to RTL2832 E4000 NIM module pointer
@param [in]   pDvbtNimModuleMemory         Pointer to an allocated DVB-T NIM module memory
@param [in]   I2cReadingByteNumMax         Maximum I2C reading byte number for basic I2C reading function
@param [in]   I2cWritingByteNumMax         Maximum I2C writing byte number for basic I2C writing function
@param [in]   I2cRead                      Basic I2C reading function pointer
@param [in]   I2cWrite                     Basic I2C writing function pointer
@param [in]   WaitMs                       Basic waiting function pointer
@param [in]   DemodDeviceAddr              RTL2832 I2C device address
@param [in]   DemodCrystalFreqHz           RTL2832 crystal frequency in Hz
@param [in]   DemodTsInterfaceMode         RTL2832 TS interface mode for setting
@param [in]   DemodAppMode                 RTL2832 application mode for setting
@param [in]   DemodUpdateFuncRefPeriodMs   RTL2832 update function reference period in millisecond for setting
@param [in]   DemodIsFunc1Enabled          RTL2832 Function 1 enabling status for setting
@param [in]   TunerDeviceAddr              E4000 I2C device address
@param [in]   TunerCrystalFreqHz           E4000 crystal frequency in Hz


@note
	-# One should call BuildRtl2832E4000Module() to build RTL2832 E4000 NIM module before using it.

*/
void
BuildRtl2832E4000Module(
	DVBT_NIM_MODULE **ppNim,							// DVB-T NIM dependence
	DVBT_NIM_MODULE *pDvbtNimModuleMemory,

	unsigned long I2cReadingByteNumMax,					// Base interface dependence
	unsigned long I2cWritingByteNumMax,
	BASE_FP_I2C_READ I2cRead,
	BASE_FP_I2C_WRITE I2cWrite,
	BASE_FP_WAIT_MS WaitMs,

	unsigned char DemodDeviceAddr,						// Demod dependence
	unsigned long DemodCrystalFreqHz,
	int DemodTsInterfaceMode,
	int DemodAppMode,
	unsigned long DemodUpdateFuncRefPeriodMs,
	int DemodIsFunc1Enabled,

	unsigned char TunerDeviceAddr,						// Tuner dependence
	unsigned long TunerCrystalFreqHz
	)
{
	DVBT_NIM_MODULE *pNim;
	RTL2832_E4000_EXTRA_MODULE *pNimExtra;



	// Set NIM module pointer with NIM module memory.
	*ppNim = pDvbtNimModuleMemory;
	
	// Get NIM module.
	pNim = *ppNim;

	// Set I2C bridge module pointer with I2C bridge module memory.
	pNim->pI2cBridge = &pNim->I2cBridgeModuleMemory;

	// Get NIM extra module.
	pNimExtra = &(pNim->Extra.Rtl2832E4000);


	// Set NIM type.
	pNim->NimType = DVBT_NIM_RTL2832_E4000;


	// Build base interface module.
	BuildBaseInterface(
		&pNim->pBaseInterface,
		&pNim->BaseInterfaceModuleMemory,
		I2cReadingByteNumMax,
		I2cWritingByteNumMax,
		I2cRead,
		I2cWrite,
		WaitMs
		);

	// Build RTL2832 demod module.
	BuildRtl2832Module(
		&pNim->pDemod,
		&pNim->DvbtDemodModuleMemory,
		&pNim->BaseInterfaceModuleMemory,
		&pNim->I2cBridgeModuleMemory,
		DemodDeviceAddr,
		DemodCrystalFreqHz,
		DemodTsInterfaceMode,
		DemodAppMode,
		DemodUpdateFuncRefPeriodMs,
		DemodIsFunc1Enabled
		);

	// Build E4000 tuner module.
	BuildE4000Module(
		&pNim->pTuner,
		&pNim->TunerModuleMemory,
		&pNim->BaseInterfaceModuleMemory,
		&pNim->I2cBridgeModuleMemory,
		TunerDeviceAddr,
		TunerCrystalFreqHz
		);


	// Set NIM module function pointers with default functions.
	pNim->GetNimType        = dvbt_nim_default_GetNimType;
	pNim->GetParameters     = dvbt_nim_default_GetParameters;
	pNim->IsSignalPresent   = dvbt_nim_default_IsSignalPresent;
	pNim->IsSignalLocked    = dvbt_nim_default_IsSignalLocked;
	pNim->GetSignalStrength = dvbt_nim_default_GetSignalStrength;
	pNim->GetSignalQuality  = dvbt_nim_default_GetSignalQuality;
	pNim->GetBer            = dvbt_nim_default_GetBer;
	pNim->GetSnrDb          = dvbt_nim_default_GetSnrDb;
	pNim->GetTrOffsetPpm    = dvbt_nim_default_GetTrOffsetPpm;
	pNim->GetCrOffsetHz     = dvbt_nim_default_GetCrOffsetHz;
	pNim->GetTpsInfo        = dvbt_nim_default_GetTpsInfo;

	// Set NIM module function pointers with particular functions.
	pNim->Initialize     = rtl2832_e4000_Initialize;
	pNim->SetParameters  = rtl2832_e4000_SetParameters;
	pNim->UpdateFunction = rtl2832_e4000_UpdateFunction;


	// Initialize NIM extra module variables.
	pNimExtra->TunerModeUpdateWaitTimeMax = 
		DivideWithCeiling(RTL2832_E4000_TUNER_MODE_UPDATE_WAIT_TIME_MS, DemodUpdateFuncRefPeriodMs);
	pNimExtra->TunerModeUpdateWaitTime    = 0;
	pNimExtra->TunerGainMode = RTL2832_E4000_TUNER_GAIN_NORMAL;


	return;
}





/**

@see   DVBT_NIM_FP_INITIALIZE

*/
int
rtl2832_e4000_Initialize(
	DVBT_NIM_MODULE *pNim
	)
{
	typedef struct
	{
		int RegBitName;
		unsigned long Value;
	}
	REG_VALUE_ENTRY;


	static const REG_VALUE_ENTRY AdditionalInitRegValueTable[RTL2832_E4000_ADDITIONAL_INIT_REG_TABLE_LEN] =
	{
		// RegBitName,				Value
		{DVBT_DAGC_TRG_VAL,			0x5a	},
		{DVBT_AGC_TARG_VAL_0,		0x0		},
		{DVBT_AGC_TARG_VAL_8_1,		0x5a	},
		{DVBT_AAGC_LOOP_GAIN,		0x18    },
		{DVBT_LOOP_GAIN2_3_0,		0x8		},
		{DVBT_LOOP_GAIN2_4,			0x1		},
		{DVBT_LOOP_GAIN3,			0x18	},

		{DVBT_VTOP1,				0x35	},
		{DVBT_VTOP2,				0x21	},
		{DVBT_VTOP3,				0x21	},
		{DVBT_KRF1,					0x0		},
		{DVBT_KRF2,					0x40	},
		{DVBT_KRF3,					0x10	},
		{DVBT_KRF4,					0x10	},
		{DVBT_IF_AGC_MIN,			0x80	},
		{DVBT_IF_AGC_MAX,			0x7f	},
		{DVBT_RF_AGC_MIN,			0x80	},
		{DVBT_RF_AGC_MAX,			0x7f	},
		{DVBT_POLAR_RF_AGC,			0x0		},
		{DVBT_POLAR_IF_AGC,			0x0		},
		{DVBT_AD7_SETTING,			0xe9d4	},
		{DVBT_EN_GI_PGA,			0x0		},
		{DVBT_THD_LOCK_UP,			0x0		},
		{DVBT_THD_LOCK_DW,			0x0		},
		{DVBT_THD_UP1,				0x14	},
		{DVBT_THD_DW1,				0xec	},

		{DVBT_INTER_CNT_LEN,		0xc		},
		{DVBT_GI_PGA_STATE,			0x0		},
		{DVBT_EN_AGC_PGA,			0x1		},

		{DVBT_REG_GPE,				0x1		},
		{DVBT_REG_GPO,				0x1		},
		{DVBT_REG_MONSEL,			0x1		},
		{DVBT_REG_MON,				0x1		},
		{DVBT_REG_4MSEL,			0x0		},
	};


	TUNER_MODULE *pTuner;
	DVBT_DEMOD_MODULE *pDemod;

	int i;

	int RegBitName;
	unsigned long Value;



	// Get tuner module and demod module.
	pTuner = pNim->pTuner;
	pDemod = pNim->pDemod;


	// Enable demod DVBT_IIC_REPEAT.
	if(pDemod->SetRegBitsWithPage(pDemod, DVBT_IIC_REPEAT, 0x1) != FUNCTION_SUCCESS)
		goto error_status_set_registers;

	// Initialize tuner.
	if(pTuner->Initialize(pTuner) != FUNCTION_SUCCESS)
		goto error_status_execute_function;

	// Disable demod DVBT_IIC_REPEAT.
	if(pDemod->SetRegBitsWithPage(pDemod, DVBT_IIC_REPEAT, 0x0) != FUNCTION_SUCCESS)
		goto error_status_set_registers;


	// Initialize demod.
	if(pDemod->Initialize(pDemod) != FUNCTION_SUCCESS)
		goto error_status_execute_function;

	// Set demod IF frequency with 0 Hz.
	if(pDemod->SetIfFreqHz(pDemod, IF_FREQ_0HZ) != FUNCTION_SUCCESS)
		goto error_status_execute_function;

	// Set demod spectrum mode with SPECTRUM_NORMAL.
	if(pDemod->SetSpectrumMode(pDemod, SPECTRUM_NORMAL) != FUNCTION_SUCCESS)
		goto error_status_execute_function;


	// Set demod registers.
	for(i = 0; i < RTL2832_E4000_ADDITIONAL_INIT_REG_TABLE_LEN; i++)
	{
		// Get register bit name and its value.
		RegBitName = AdditionalInitRegValueTable[i].RegBitName;
		Value      = AdditionalInitRegValueTable[i].Value;

		// Set demod registers
		if(pDemod->SetRegBitsWithPage(pDemod, RegBitName, Value) != FUNCTION_SUCCESS)
			goto error_status_set_registers;
	}


	return FUNCTION_SUCCESS;


error_status_execute_function:
error_status_set_registers:
	return FUNCTION_ERROR;
}





/**

@see   DVBT_NIM_FP_SET_PARAMETERS

*/
int
rtl2832_e4000_SetParameters(
	DVBT_NIM_MODULE *pNim,
	unsigned long RfFreqHz,
	int BandwidthMode
	)
{
	TUNER_MODULE *pTuner;
	DVBT_DEMOD_MODULE *pDemod;
	E4000_EXTRA_MODULE *pTunerExtra;
	RTL2832_E4000_EXTRA_MODULE *pNimExtra;

	unsigned long TunerBandwidthHz;

	int RfFreqKhz;
	int BandwidthKhz;



	// Get tuner module and demod module.
	pTuner = pNim->pTuner;
	pDemod = pNim->pDemod;

	// Get tuner extra module.
	pTunerExtra = &(pTuner->Extra.E4000);

	// Get NIM extra module.
	pNimExtra = &(pNim->Extra.Rtl2832E4000);


	// Enable demod DVBT_IIC_REPEAT.
	if(pDemod->SetRegBitsWithPage(pDemod, DVBT_IIC_REPEAT, 0x1) != FUNCTION_SUCCESS)
		goto error_status_set_registers;

	// Set tuner RF frequency in Hz.
	if(pTuner->SetRfFreqHz(pTuner, RfFreqHz) != FUNCTION_SUCCESS)
		goto error_status_execute_function;

	// Determine TunerBandwidthHz according to bandwidth mode.
	switch(BandwidthMode)
	{
		default:
		case DVBT_BANDWIDTH_6MHZ:		TunerBandwidthHz = E4000_BANDWIDTH_6000000HZ;		break;
		case DVBT_BANDWIDTH_7MHZ:		TunerBandwidthHz = E4000_BANDWIDTH_7000000HZ;		break;
		case DVBT_BANDWIDTH_8MHZ:		TunerBandwidthHz = E4000_BANDWIDTH_8000000HZ;		break;
	}

	// Set tuner bandwidth Hz with TunerBandwidthHz.
	if(pTunerExtra->SetBandwidthHz(pTuner, TunerBandwidthHz) != FUNCTION_SUCCESS)
		goto error_status_execute_function;


	// Set tuner gain mode with normal condition for update procedure.
	RfFreqKhz = (int)((RfFreqHz + 500) / 1000);
	BandwidthKhz = (int)((TunerBandwidthHz + 500) / 1000);

//	if(E4000_nominal(pTuner, RfFreqKhz, BandwidthKhz) != E4000_1_SUCCESS)
	if(E4000_sensitivity(pTuner, RfFreqKhz, BandwidthKhz) != E4000_1_SUCCESS)
//	if(E4000_linearity(pTuner, RfFreqKhz, BandwidthKhz) != E4000_1_SUCCESS)
		goto error_status_execute_function;

	pNimExtra->TunerGainMode = RTL2832_E4000_TUNER_GAIN_NORMAL;


	// Disable demod DVBT_IIC_REPEAT.
	if(pDemod->SetRegBitsWithPage(pDemod, DVBT_IIC_REPEAT, 0x0) != FUNCTION_SUCCESS)
		goto error_status_set_registers;


	// Set demod bandwidth mode.
	if(pDemod->SetBandwidthMode(pDemod, BandwidthMode) != FUNCTION_SUCCESS)
		goto error_status_execute_function;

	// Reset demod particular registers.
	if(pDemod->ResetFunction(pDemod) != FUNCTION_SUCCESS)
		goto error_status_execute_function;


	// Reset demod by software reset.
	if(pDemod->SoftwareReset(pDemod) != FUNCTION_SUCCESS)
		goto error_status_execute_function;


	return FUNCTION_SUCCESS;


error_status_execute_function:
error_status_set_registers:
	return FUNCTION_ERROR;
}





/**

@see   DVBT_NIM_FP_UPDATE_FUNCTION

*/
int
rtl2832_e4000_UpdateFunction(
	DVBT_NIM_MODULE *pNim
	)
{
	DVBT_DEMOD_MODULE *pDemod;
	RTL2832_E4000_EXTRA_MODULE *pNimExtra;


	// Get demod module.
	pDemod = pNim->pDemod;

	// Get NIM extra module.
	pNimExtra = &(pNim->Extra.Rtl2832E4000);


	// Update demod particular registers.
	if(pDemod->UpdateFunction(pDemod) != FUNCTION_SUCCESS)
		goto error_status_execute_function;


	// Increase tuner mode update waiting time.
	pNimExtra->TunerModeUpdateWaitTime += 1;


	// Check if need to update tuner mode according to update waiting time.
	if(pNimExtra->TunerModeUpdateWaitTime == pNimExtra->TunerModeUpdateWaitTimeMax)
	{
		// Reset update waiting time.
		pNimExtra->TunerModeUpdateWaitTime = 0;

		// Enable demod DVBT_IIC_REPEAT.
		if(pDemod->SetRegBitsWithPage(pDemod, DVBT_IIC_REPEAT, 0x1) != FUNCTION_SUCCESS)
			goto error_status_set_registers;

		// Update tuner mode.
		if(rtl2832_e4000_UpdateTunerMode(pNim) != FUNCTION_SUCCESS)
			goto error_status_execute_function;

		// Disable demod DVBT_IIC_REPEAT.
		if(pDemod->SetRegBitsWithPage(pDemod, DVBT_IIC_REPEAT, 0x0) != FUNCTION_SUCCESS)
			goto error_status_set_registers;
	}


	return FUNCTION_SUCCESS;


error_status_set_registers:
error_status_execute_function:
	return FUNCTION_ERROR;
}





/**

@brief   Update tuner mode.

One can use rtl2832_e4000_UpdateTunerMode() to update tuner mode.


@param [in]   pNim   The NIM module pointer


@retval   FUNCTION_SUCCESS   Update tuner mode successfully.
@retval   FUNCTION_ERROR     Update tuner mode unsuccessfully.

*/
int
rtl2832_e4000_UpdateTunerMode(
	DVBT_NIM_MODULE *pNim
	)
{
	static const long LnaGainTable[RTL2832_E4000_LNA_GAIN_TABLE_LEN][RTL2832_E4000_LNA_GAIN_BAND_NUM] =
	{
		// VHF Gain,	UHF Gain,		ReadingByte
		{-50,			-50	},		//	0x0
		{-25,			-25	},		//	0x1
		{-50,			-50	},		//	0x2
		{-25,			-25	},		//	0x3
		{0,				0	},		//	0x4
		{25,			25	},		//	0x5
		{50,			50	},		//	0x6
		{75,			75	},		//	0x7
		{100,			100	},		//	0x8
		{125,			125	},		//	0x9
		{150,			150	},		//	0xa
		{175,			175	},		//	0xb
		{200,			200	},		//	0xc
		{225,			250	},		//	0xd
		{250,			280	},		//	0xe
		{250,			280	},		//	0xf

		// Note: The gain unit is 0.1 dB.
	};

	static const long LnaGainAddTable[RTL2832_E4000_LNA_GAIN_ADD_TABLE_LEN] =
	{
		// Gain,		ReadingByte
		NO_USE,		//	0x0
		NO_USE,		//	0x1
		NO_USE,		//	0x2
		0,			//	0x3
		NO_USE,		//	0x4
		20,			//	0x5
		NO_USE,		//	0x6
		70,			//	0x7

		// Note: The gain unit is 0.1 dB.
	};

	static const long MixerGainTable[RTL2832_E4000_MIXER_GAIN_TABLE_LEN][RTL2832_E4000_MIXER_GAIN_BAND_NUM] =
	{
		// VHF Gain,	UHF Gain,		ReadingByte
		{90,			40	},		//	0x0
		{170,			120	},		//	0x1

		// Note: The gain unit is 0.1 dB.
	};

	static const long IfStage1GainTable[RTL2832_E4000_IF_STAGE_1_GAIN_TABLE_LEN] =
	{
		// Gain,		ReadingByte
		-30,		//	0x0
		60,			//	0x1

		// Note: The gain unit is 0.1 dB.
	};

	static const long IfStage2GainTable[RTL2832_E4000_IF_STAGE_2_GAIN_TABLE_LEN] =
	{
		// Gain,		ReadingByte
		0,			//	0x0
		30,			//	0x1
		60,			//	0x2
		90,			//	0x3

		// Note: The gain unit is 0.1 dB.
	};

	static const long IfStage3GainTable[RTL2832_E4000_IF_STAGE_3_GAIN_TABLE_LEN] =
	{
		// Gain,		ReadingByte
		0,			//	0x0
		30,			//	0x1
		60,			//	0x2
		90,			//	0x3

		// Note: The gain unit is 0.1 dB.
	};

	static const long IfStage4GainTable[RTL2832_E4000_IF_STAGE_4_GAIN_TABLE_LEN] =
	{
		// Gain,		ReadingByte
		0,			//	0x0
		10,			//	0x1
		20,			//	0x2
		20,			//	0x3

		// Note: The gain unit is 0.1 dB.
	};

	static const long IfStage5GainTable[RTL2832_E4000_IF_STAGE_5_GAIN_TABLE_LEN] =
	{
		// Gain,		ReadingByte
		0,			//	0x0
		30,			//	0x1
		60,			//	0x2
		90,			//	0x3
		120,		//	0x4
		120,		//	0x5
		120,		//	0x6
		120,		//	0x7

		// Note: The gain unit is 0.1 dB.
	};

	static const long IfStage6GainTable[RTL2832_E4000_IF_STAGE_6_GAIN_TABLE_LEN] =
	{
		// Gain,		ReadingByte
		0,			//	0x0
		30,			//	0x1
		60,			//	0x2
		90,			//	0x3
		120,		//	0x4
		120,		//	0x5
		120,		//	0x6
		120,		//	0x7

		// Note: The gain unit is 0.1 dB.
	};


	TUNER_MODULE *pTuner;
	E4000_EXTRA_MODULE *pTunerExtra;
	RTL2832_E4000_EXTRA_MODULE *pNimExtra;

	unsigned long RfFreqHz;
	int RfFreqKhz;
	unsigned long BandwidthHz;
	int BandwidthKhz;

	unsigned char ReadingByte;
	int BandIndex;

	unsigned char TunerBitsLna, TunerBitsLnaAdd, TunerBitsMixer;
	unsigned char TunerBitsIfStage1, TunerBitsIfStage2, TunerBitsIfStage3, TunerBitsIfStage4;
	unsigned char TunerBitsIfStage5, TunerBitsIfStage6;

	long TunerGainLna, TunerGainLnaAdd, TunerGainMixer;
	long TunerGainIfStage1, TunerGainIfStage2, TunerGainIfStage3, TunerGainIfStage4;
	long TunerGainIfStage5, TunerGainIfStage6;

	long TunerGainTotal;
	long TunerInputPower;


	// Get tuner module.
	pTuner = pNim->pTuner;

	// Get tuner extra module.
	pTunerExtra = &(pTuner->Extra.E4000);

	// Get NIM extra module.
	pNimExtra = &(pNim->Extra.Rtl2832E4000);


	// Get tuner RF frequency in KHz.
	// Note: RfFreqKhz = round(RfFreqHz / 1000)
	if(pTuner->GetRfFreqHz(pTuner, &RfFreqHz) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;

	RfFreqKhz = (int)((RfFreqHz + 500) / 1000);

	// Get tuner bandwidth in KHz.
	// Note: BandwidthKhz = round(BandwidthHz / 1000)
	if(pTunerExtra->GetBandwidthHz(pTuner, &BandwidthHz) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;

	BandwidthKhz = (int)((BandwidthHz + 500) / 1000);


	// Determine band index.
	BandIndex = (RfFreqHz < RTL2832_E4000_RF_BAND_BOUNDARY_HZ) ? 0 : 1;


	// Get tuner LNA gain according to reading byte and table.
	if(pTunerExtra->GetRegByte(pTuner, RTL2832_E4000_LNA_GAIN_ADDR, &ReadingByte) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;

	TunerBitsLna = (ReadingByte & RTL2832_E4000_LNA_GAIN_MASK) >> RTL2832_E4000_LNA_GAIN_SHIFT;
	TunerGainLna = LnaGainTable[TunerBitsLna][BandIndex];


	// Get tuner LNA additional gain according to reading byte and table.
	if(pTunerExtra->GetRegByte(pTuner, RTL2832_E4000_LNA_GAIN_ADD_ADDR, &ReadingByte) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;

	TunerBitsLnaAdd = (ReadingByte & RTL2832_E4000_LNA_GAIN_ADD_MASK) >> RTL2832_E4000_LNA_GAIN_ADD_SHIFT;
	TunerGainLnaAdd = LnaGainAddTable[TunerBitsLnaAdd];


	// Get tuner mixer gain according to reading byte and table.
	if(pTunerExtra->GetRegByte(pTuner, RTL2832_E4000_MIXER_GAIN_ADDR, &ReadingByte) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;

	TunerBitsMixer = (ReadingByte & RTL2832_E4000_MIXER_GAIN_MASK) >> RTL2832_E4000_LNA_GAIN_ADD_SHIFT;
	TunerGainMixer = MixerGainTable[TunerBitsMixer][BandIndex];


	// Get tuner IF stage 1 gain according to reading byte and table.
	if(pTunerExtra->GetRegByte(pTuner, RTL2832_E4000_IF_STAGE_1_GAIN_ADDR, &ReadingByte) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;

	TunerBitsIfStage1 = (ReadingByte & RTL2832_E4000_IF_STAGE_1_GAIN_MASK) >> RTL2832_E4000_IF_STAGE_1_GAIN_SHIFT;
	TunerGainIfStage1 = IfStage1GainTable[TunerBitsIfStage1];


	// Get tuner IF stage 2 gain according to reading byte and table.
	if(pTunerExtra->GetRegByte(pTuner, RTL2832_E4000_IF_STAGE_2_GAIN_ADDR, &ReadingByte) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;

	TunerBitsIfStage2 = (ReadingByte & RTL2832_E4000_IF_STAGE_2_GAIN_MASK) >> RTL2832_E4000_IF_STAGE_2_GAIN_SHIFT;
	TunerGainIfStage2 = IfStage2GainTable[TunerBitsIfStage2];


	// Get tuner IF stage 3 gain according to reading byte and table.
	if(pTunerExtra->GetRegByte(pTuner, RTL2832_E4000_IF_STAGE_3_GAIN_ADDR, &ReadingByte) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;

	TunerBitsIfStage3 = (ReadingByte & RTL2832_E4000_IF_STAGE_3_GAIN_MASK) >> RTL2832_E4000_IF_STAGE_3_GAIN_SHIFT;
	TunerGainIfStage3 = IfStage3GainTable[TunerBitsIfStage3];


	// Get tuner IF stage 4 gain according to reading byte and table.
	if(pTunerExtra->GetRegByte(pTuner, RTL2832_E4000_IF_STAGE_4_GAIN_ADDR, &ReadingByte) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;

	TunerBitsIfStage4 = (ReadingByte & RTL2832_E4000_IF_STAGE_4_GAIN_MASK) >> RTL2832_E4000_IF_STAGE_4_GAIN_SHIFT;
	TunerGainIfStage4 = IfStage4GainTable[TunerBitsIfStage4];


	// Get tuner IF stage 5 gain according to reading byte and table.
	if(pTunerExtra->GetRegByte(pTuner, RTL2832_E4000_IF_STAGE_5_GAIN_ADDR, &ReadingByte) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;

	TunerBitsIfStage5 = (ReadingByte & RTL2832_E4000_IF_STAGE_5_GAIN_MASK) >> RTL2832_E4000_IF_STAGE_5_GAIN_SHIFT;
	TunerGainIfStage5 = IfStage5GainTable[TunerBitsIfStage5];


	// Get tuner IF stage 6 gain according to reading byte and table.
	if(pTunerExtra->GetRegByte(pTuner, RTL2832_E4000_IF_STAGE_6_GAIN_ADDR, &ReadingByte) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;

	TunerBitsIfStage6 = (ReadingByte & RTL2832_E4000_IF_STAGE_6_GAIN_MASK) >> RTL2832_E4000_IF_STAGE_6_GAIN_SHIFT;
	TunerGainIfStage6 = IfStage6GainTable[TunerBitsIfStage6];


	// Calculate tuner total gain.
	// Note: The unit of tuner total gain is 0.1 dB.
	TunerGainTotal = TunerGainLna + TunerGainLnaAdd + TunerGainMixer + 
	                 TunerGainIfStage1 + TunerGainIfStage2 + TunerGainIfStage3 + TunerGainIfStage4 +
	                 TunerGainIfStage5 + TunerGainIfStage6;

	// Calculate tuner input power.
	// Note: The unit of tuner input power is 0.1 dBm
	TunerInputPower = RTL2832_E4000_TUNER_OUTPUT_POWER_UNIT_0P1_DBM - TunerGainTotal;


	// Determine tuner gain mode according to tuner input power.
	// Note: The unit of tuner input power is 0.1 dBm
	switch(pNimExtra->TunerGainMode)
	{
		default:
		case RTL2832_E4000_TUNER_GAIN_SENSITIVE:

			if(TunerInputPower > -650)
				pNimExtra->TunerGainMode = RTL2832_E4000_TUNER_GAIN_NORMAL;

			break;


		case RTL2832_E4000_TUNER_GAIN_NORMAL:

			if(TunerInputPower < -750)
				pNimExtra->TunerGainMode = RTL2832_E4000_TUNER_GAIN_SENSITIVE;

			if(TunerInputPower > -400)
				pNimExtra->TunerGainMode = RTL2832_E4000_TUNER_GAIN_LINEAR;

			break;


		case RTL2832_E4000_TUNER_GAIN_LINEAR:

			if(TunerInputPower < -500)
				pNimExtra->TunerGainMode = RTL2832_E4000_TUNER_GAIN_NORMAL;

			break;
	}


	// Set tuner gain mode.
	switch(pNimExtra->TunerGainMode)
	{
		default:
		case RTL2832_E4000_TUNER_GAIN_SENSITIVE:

			if(E4000_sensitivity(pTuner, RfFreqKhz, BandwidthKhz) != E4000_1_SUCCESS)
				goto error_status_execute_function;

			break;


		case RTL2832_E4000_TUNER_GAIN_NORMAL:

			if(E4000_nominal(pTuner, RfFreqKhz, BandwidthKhz) != E4000_1_SUCCESS)
				goto error_status_execute_function;

			break;


		case RTL2832_E4000_TUNER_GAIN_LINEAR:

			if(E4000_linearity(pTuner, RfFreqKhz, BandwidthKhz) != E4000_1_SUCCESS)
				goto error_status_execute_function;

			break;
	}


	return FUNCTION_SUCCESS;


error_status_execute_function:
error_status_get_tuner_registers:
	return FUNCTION_ERROR;
}






--------------080601030503010206040103
Content-Type: text/x-csrc;
 name="tuner_e4000.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tuner_e4000.c"

/**

@file

@brief   E4000 tuner module definition

One can manipulate E4000 tuner through E4000 module.
E4000 module is derived from tuner module.

*/


#include "tuner_e4000.h"





/**

@brief   E4000 tuner module builder

Use BuildE4000Module() to build E4000 module, set all module function pointers with the corresponding functions,
and initialize module private variables.


@param [in]   ppTuner                      Pointer to E4000 tuner module pointer
@param [in]   pTunerModuleMemory           Pointer to an allocated tuner module memory
@param [in]   pBaseInterfaceModuleMemory   Pointer to an allocated base interface module memory
@param [in]   pI2cBridgeModuleMemory       Pointer to an allocated I2C bridge module memory
@param [in]   DeviceAddr                   E4000 I2C device address
@param [in]   CrystalFreqHz                E4000 crystal frequency in Hz
@param [in]   AgcMode                      E4000 AGC mode


@note
	-# One should call BuildE4000Module() to build E4000 module before using it.

*/
void
BuildE4000Module(
	TUNER_MODULE **ppTuner,
	TUNER_MODULE *pTunerModuleMemory,
	BASE_INTERFACE_MODULE *pBaseInterfaceModuleMemory,
	I2C_BRIDGE_MODULE *pI2cBridgeModuleMemory,
	unsigned char DeviceAddr,
	unsigned long CrystalFreqHz
	)
{
	TUNER_MODULE *pTuner;
	E4000_EXTRA_MODULE *pExtra;



	// Set tuner module pointer.
	*ppTuner = pTunerModuleMemory;

	// Get tuner module.
	pTuner = *ppTuner;

	// Set base interface module pointer and I2C bridge module pointer.
	pTuner->pBaseInterface = pBaseInterfaceModuleMemory;
	pTuner->pI2cBridge = pI2cBridgeModuleMemory;

	// Get tuner extra module.
	pExtra = &(pTuner->Extra.E4000);



	// Set tuner type.
	pTuner->TunerType = TUNER_TYPE_E4000;

	// Set tuner I2C device address.
	pTuner->DeviceAddr = DeviceAddr;


	// Initialize tuner parameter setting status.
	pTuner->IsRfFreqHzSet = NO;


	// Set tuner module manipulating function pointers.
	pTuner->GetTunerType  = e4000_GetTunerType;
	pTuner->GetDeviceAddr = e4000_GetDeviceAddr;

	pTuner->Initialize    = e4000_Initialize;
	pTuner->SetRfFreqHz   = e4000_SetRfFreqHz;
	pTuner->GetRfFreqHz   = e4000_GetRfFreqHz;


	// Initialize tuner extra module variables.
	pExtra->CrystalFreqHz    = CrystalFreqHz;
	pExtra->IsBandwidthHzSet = NO;

	// Set tuner extra module function pointers.
	pExtra->GetRegByte     = e4000_GetRegByte;
	pExtra->SetBandwidthHz = e4000_SetBandwidthHz;
	pExtra->GetBandwidthHz = e4000_GetBandwidthHz;


	return;
}





/**

@see   TUNER_FP_GET_TUNER_TYPE

*/
void
e4000_GetTunerType(
	TUNER_MODULE *pTuner,
	int *pTunerType
	)
{
	// Get tuner type from tuner module.
	*pTunerType = pTuner->TunerType;


	return;
}





/**

@see   TUNER_FP_GET_DEVICE_ADDR

*/
void
e4000_GetDeviceAddr(
	TUNER_MODULE *pTuner,
	unsigned char *pDeviceAddr
	)
{
	// Get tuner I2C device address from tuner module.
	*pDeviceAddr = pTuner->DeviceAddr;


	return;
}





/**

@see   TUNER_FP_INITIALIZE

*/
int
e4000_Initialize(
	TUNER_MODULE *pTuner
	)
{
	E4000_EXTRA_MODULE *pExtra;



	// Get tuner extra module.
	pExtra = &(pTuner->Extra.E4000);


	// Initialize tuner.
	// Note: Call E4000 source code functions.
	if(tunerreset(pTuner) != E4000_1_SUCCESS)
		goto error_status_execute_function;

	if(Tunerclock(pTuner) != E4000_1_SUCCESS)
		goto error_status_execute_function;

	if(Qpeak(pTuner) != E4000_1_SUCCESS)
		goto error_status_execute_function;

	if(DCoffloop(pTuner) != E4000_1_SUCCESS)
		goto error_status_execute_function;

	if(GainControlinit(pTuner) != E4000_1_SUCCESS)
		goto error_status_execute_function;


	return FUNCTION_SUCCESS;


error_status_execute_function:
	return FUNCTION_ERROR;
}





/**

@see   TUNER_FP_SET_RF_FREQ_HZ

*/
int
e4000_SetRfFreqHz(
	TUNER_MODULE *pTuner,
	unsigned long RfFreqHz
	)
{
	E4000_EXTRA_MODULE *pExtra;

	int RfFreqKhz;
	int CrystalFreqKhz;



	// Get tuner extra module.
	pExtra = &(pTuner->Extra.E4000);


	// Set tuner RF frequency in KHz.
	// Note: 1. RfFreqKhz = round(RfFreqHz / 1000)
	//          CrystalFreqKhz = round(CrystalFreqHz / 1000)
	//       2. Call E4000 source code functions.
	RfFreqKhz      = (int)((RfFreqHz + 500) / 1000);
	CrystalFreqKhz = (int)((pExtra->CrystalFreqHz + 500) / 1000);

	if(Gainmanual(pTuner) != E4000_1_SUCCESS)
		goto error_status_execute_function;

	if(E4000_gain_freq(pTuner, RfFreqKhz) != E4000_1_SUCCESS)
		goto error_status_execute_function;

	if(PLL(pTuner, CrystalFreqKhz, RfFreqKhz) != E4000_1_SUCCESS)
		goto error_status_execute_function;

	if(LNAfilter(pTuner, RfFreqKhz) != E4000_1_SUCCESS)
		goto error_status_execute_function;

	if(freqband(pTuner, RfFreqKhz) != E4000_1_SUCCESS)
		goto error_status_execute_function;

	if(DCoffLUT(pTuner) != E4000_1_SUCCESS)
		goto error_status_execute_function;

	if(GainControlauto(pTuner) != E4000_1_SUCCESS)
		goto error_status_execute_function;


	// Set tuner RF frequency parameter.
	pTuner->RfFreqHz      = RfFreqHz;
	pTuner->IsRfFreqHzSet = YES;


	return FUNCTION_SUCCESS;


error_status_execute_function:
	return FUNCTION_ERROR;
}





/**

@see   TUNER_FP_GET_RF_FREQ_HZ

*/
int
e4000_GetRfFreqHz(
	TUNER_MODULE *pTuner,
	unsigned long *pRfFreqHz
	)
{
	// Get tuner RF frequency in Hz from tuner module.
	if(pTuner->IsRfFreqHzSet != YES)
		goto error_status_get_tuner_rf_frequency;

	*pRfFreqHz = pTuner->RfFreqHz;


	return FUNCTION_SUCCESS;


error_status_get_tuner_rf_frequency:
	return FUNCTION_ERROR;
}





/**

@brief   Get E4000 register byte.

*/
int
e4000_GetRegByte(
	TUNER_MODULE *pTuner,
	unsigned char RegAddr,
	unsigned char *pReadingByte
	)
{
	// Call I2CReadByte() to read tuner register.
	if(I2CReadByte(pTuner, NO_USE, RegAddr, pReadingByte) != E4000_I2C_SUCCESS)
		goto error_status_execute_function;


	return FUNCTION_SUCCESS;


error_status_execute_function:
	return FUNCTION_ERROR;
}





/**

@brief   Set E4000 tuner bandwidth.

*/
int
e4000_SetBandwidthHz(
	TUNER_MODULE *pTuner,
	unsigned long BandwidthHz
	)
{
	E4000_EXTRA_MODULE *pExtra;

	int BandwidthKhz;
	int CrystalFreqKhz;



	// Get tuner extra module.
	pExtra = &(pTuner->Extra.E4000);


	// Set tuner bandwidth Hz.
	// Note: 1. BandwidthKhz = round(BandwidthHz / 1000)
	//          CrystalFreqKhz = round(CrystalFreqHz / 1000)
	//       2. Call E4000 source code functions.
	BandwidthKhz   = (int)((BandwidthHz + 500) / 1000);
	CrystalFreqKhz = (int)((pExtra->CrystalFreqHz + 500) / 1000);

	if(IFfilter(pTuner, BandwidthKhz, CrystalFreqKhz) != E4000_1_SUCCESS)
		goto error_status_execute_function;


	// Set tuner bandwidth Hz parameter.
	pExtra->BandwidthHz      = BandwidthHz;
	pExtra->IsBandwidthHzSet = YES;


	return FUNCTION_SUCCESS;


error_status_execute_function:
	return FUNCTION_ERROR;
}





/**

@brief   Get E4000 tuner bandwidth.

*/
int
e4000_GetBandwidthHz(
	TUNER_MODULE *pTuner,
	unsigned long *pBandwidthHz
	)
{
	E4000_EXTRA_MODULE *pExtra;



	// Get tuner extra module.
	pExtra = &(pTuner->Extra.E4000);


	// Get tuner bandwidth Hz from tuner module.
	if(pExtra->IsBandwidthHzSet != YES)
		goto error_status_get_tuner_bandwidth_hz;

	*pBandwidthHz = pExtra->BandwidthHz;


	return FUNCTION_SUCCESS;


error_status_get_tuner_bandwidth_hz:
	return FUNCTION_ERROR;
}























// Function (implemeted for E4000)
int
I2CReadByte(
	TUNER_MODULE *pTuner,
	unsigned char NoUse,
	unsigned char RegAddr,
	unsigned char *pReadingByte
	)
{
	I2C_BRIDGE_MODULE *pI2cBridge;
	unsigned char DeviceAddr;


	// Get I2C bridge.
	pI2cBridge = pTuner->pI2cBridge;

	// Get tuner device address.
	pTuner->GetDeviceAddr(pTuner, &DeviceAddr);


	// Set tuner register reading address.
	// Note: The I2C format of tuner register reading address setting is as follows:
	//       start_bit + (DeviceAddr | writing_bit) + addr + stop_bit
	if(pI2cBridge->ForwardI2cWritingCmd(pI2cBridge, DeviceAddr, &RegAddr, LEN_1_BYTE) != FUNCTION_SUCCESS)
		goto error_status_set_tuner_register_reading_address;

	// Get tuner register byte.
	// Note: The I2C format of tuner register byte getting is as follows:
	//       start_bit + (DeviceAddr | reading_bit) + read_data + stop_bit
	if(pI2cBridge->ForwardI2cReadingCmd(pI2cBridge, DeviceAddr, pReadingByte, LEN_1_BYTE) != FUNCTION_SUCCESS)
		goto error_status_get_tuner_registers;


	return E4000_I2C_SUCCESS;


error_status_get_tuner_registers:
error_status_set_tuner_register_reading_address:
	return E4000_I2C_FAIL;
}





int
I2CWriteByte(
	TUNER_MODULE *pTuner,
	unsigned char NoUse,
	unsigned char RegAddr,
	unsigned char WritingByte
	)
{
	I2C_BRIDGE_MODULE *pI2cBridge;
	unsigned char DeviceAddr;
	unsigned char WritingBuffer[LEN_2_BYTE];


	// Get I2C bridge.
	pI2cBridge = pTuner->pI2cBridge;

	// Get tuner device address.
	pTuner->GetDeviceAddr(pTuner, &DeviceAddr);


	// Set writing bytes.
	// Note: The I2C format of tuner register byte setting is as follows:
	//       start_bit + (DeviceAddr | writing_bit) + addr + data + stop_bit
	WritingBuffer[0] = RegAddr;
	WritingBuffer[1] = WritingByte;

	// Set tuner register bytes with writing buffer.
	if(pI2cBridge->ForwardI2cWritingCmd(pI2cBridge, DeviceAddr, WritingBuffer, LEN_2_BYTE) != FUNCTION_SUCCESS)
		goto error_status_set_tuner_registers;


	return E4000_I2C_SUCCESS;


error_status_set_tuner_registers:
	return E4000_I2C_FAIL;
}





int
I2CWriteArray(
	TUNER_MODULE *pTuner,
	unsigned char NoUse,
	unsigned char RegStartAddr,
	unsigned char ByteNum,
	unsigned char *pWritingBytes
	)
{
	I2C_BRIDGE_MODULE *pI2cBridge;
	unsigned char DeviceAddr;

	unsigned int i;

	unsigned char WritingBuffer[I2C_BUFFER_LEN];


	// Get I2C bridge.
	pI2cBridge = pTuner->pI2cBridge;

	// Get tuner device address.
	pTuner->GetDeviceAddr(pTuner, &DeviceAddr);


	// Set writing buffer.
	// Note: The I2C format of demod register byte setting is as follows:
	//       start_bit + (DeviceAddr | writing_bit) + RegWritingAddr + writing_bytes (WritingByteNum bytes) + stop_bit
	WritingBuffer[0] = RegStartAddr;

	for(i = 0; i < ByteNum; i++)
		WritingBuffer[LEN_1_BYTE + i] = pWritingBytes[i];


	/// Set tuner register bytes with writing buffer.
	if(pI2cBridge->ForwardI2cWritingCmd(pI2cBridge, DeviceAddr, WritingBuffer, ByteNum + LEN_1_BYTE) != FUNCTION_SUCCESS)
		goto error_status_set_tuner_registers;


	return E4000_I2C_SUCCESS;


error_status_set_tuner_registers:
	return E4000_I2C_FAIL;
}























// The following context is source code provided by Elonics.





// Elonics source code - E4000_API_rev2_04_realtek.cpp


//****************************************************************************/
//
//  Filename    E4000_initialisation.c
//  Revision    2.04
//  
// Description:
//  Initialisation script for the Elonics E4000 revC tuner
//   
//  Copyright (c)  Elonics Ltd
//
//    Any software supplied free of charge for use with elonics
//    evaluation kits is supplied without warranty and for
//    evaluation purposes only. Incorporation of any of this
//    code into products for open sale is permitted but only at
//    the user's own risk. Elonics accepts no liability for the 
//    integrity of this software whatsoever.
//  
//
//****************************************************************************/
//#include <stdio.h>
//#include <stdlib.h>
//
// User defined variable definitions
//
/*
int Ref_clk = 26000;   // Reference clock frequency(kHz).
int Freq = 590000; // RF Frequency (kHz)
int bandwidth = 8000;  //RF channel bandwith (kHz)
*/
//
// API defined variable definitions
//int VCO_freq;
//unsigned char writearray[5];
//unsigned char read1[1];
//int status;
//
//
// function definitions
//
/*
int tunerreset ();
int Tunerclock();
int filtercal();
int Qpeak();
int PLL(int Ref_clk, int Freq);
int LNAfilter(int Freq);
int IFfilter(int bandwidth, int Ref_clk);
int freqband(int Freq);
int DCoffLUT();
int DCoffloop();
int commonmode();
int GainControlinit();  
*/
//
//****************************************************************************
// --- Public functions ------------------------------------------------------
/****************************************************************************\  
*  Function: tunerreset
*
*  Detailed Description:
*  The function resets the E4000 tuner. (Register 0x00).
*
\****************************************************************************/

int tunerreset(TUNER_MODULE *pTuner)
{
	unsigned char writearray[5];
	int status;

	writearray[0] = 64;
	// For dummy I2C command, don't check executing status.
	status=I2CWriteByte (pTuner, 200,2,writearray[0]);
	status=I2CWriteByte (pTuner, 200,2,writearray[0]);
	//printf("\nRegister 0=%d", writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = 0;
	status=I2CWriteByte (pTuner, 200,9,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = 0;
	status=I2CWriteByte (pTuner, 200,5,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = 7;
	status=I2CWriteByte (pTuner, 200,0,writearray[0]);
	//printf("\nRegister 0=%d", writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS;
}
/****************************************************************************\  
*  Function: Tunerclock
*
*  Detailed Description:
*  The function configures the E4000 clock. (Register 0x06, 0x7a).
*  Function disables the clock - values can be modified to enable if required.
\****************************************************************************/

int Tunerclock(TUNER_MODULE *pTuner)
{
	unsigned char writearray[5];
	int status;

	writearray[0] = 0;
	status=I2CWriteByte(pTuner, 200,6,writearray[0]);
	//printf("\nRegister 6=%d", writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = 150;
	status=I2CWriteByte(pTuner, 200,122,writearray[0]);
	//printf("\nRegister 7a=%d", writearray[0]);
	//**Modify commands above with value required if output clock is required, 
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS;  
}
/****************************************************************************\  
*  Function: filtercal
*
*  Detailed Description:
*  Instructs RC filter calibration. (Register 0x7b).
*
\****************************************************************************/
/*
int filtercal(TUNER_MODULE *pTuner)
{
  //writearray[0] = 1;
 //I2CWriteByte (pTuner, 200,123,writearray[0]);
 //printf("\nRegister 7b=%d", writearray[0]);
  //return;
   return E4000_1_SUCCESS;  
}
*/
/****************************************************************************\  
*  Function: Qpeak()
*
*  Detailed Description:
*  The function configures the E4000 gains. 
*  Also sigma delta controller. (Register 0x82).
*
\****************************************************************************/

int Qpeak(TUNER_MODULE *pTuner)
{
	unsigned char writearray[5];
	int status;

	writearray[0] = 1;
	writearray[1] = 254;
	status=I2CWriteArray(pTuner, 200,126,2,writearray);
	//printf("\nRegister 7e=%d", writearray[0]);
	//printf("\nRegister 7f=%d", writearray[1]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	status=I2CWriteByte (pTuner, 200,130,0);
	//printf("\nRegister 82=0");
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	status=I2CWriteByte (pTuner, 200,36,5);
	//printf("\nRegister 24=5");
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = 32;
	writearray[1] = 1;
	status=I2CWriteArray(pTuner, 200,135,2,writearray);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	//printf("\nRegister 87=%d", writearray[0]);
	//printf("\nRegister 88=%d", writearray[1]);
	return E4000_1_SUCCESS;
}
/****************************************************************************\  
*  Function: E4000_gain_freq()
*
*  Detailed Description:
*  The function configures the E4000 gains vs. freq 
*  0xa3 to 0xa7. Also 0x24.
*
\****************************************************************************/
int E4000_gain_freq(TUNER_MODULE *pTuner, int Freq)
{
	unsigned char writearray[5];
	int status;

	if (Freq<=350000)
	{
		writearray[0] = 0x10;
		writearray[1] = 0x42;
		writearray[2] = 0x09;
		writearray[3] = 0x21;
		writearray[4] = 0x94;
	}
	else if(Freq>=1000000)
	{
		writearray[0] = 0x10;
		writearray[1] = 0x42;
		writearray[2] = 0x09;
		writearray[3] = 0x21;
		writearray[4] = 0x94;
	}
	else 
	{
		writearray[0] = 0x10;
		writearray[1] = 0x42;
		writearray[2] = 0x09;
		writearray[3] = 0x21;
		writearray[4] = 0x94;
	}
	status=I2CWriteArray(pTuner, 200,163,5,writearray);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	if (Freq<=350000)
	{
		writearray[0] = 94;
		writearray[1] = 6;
		status=I2CWriteArray(pTuner, 200,159,2,writearray);
		if(status != E4000_I2C_SUCCESS)
		{
			return E4000_1_FAIL;
		}

		writearray[0] = 0;
		status=I2CWriteArray(pTuner, 200,136,1,writearray);
		if(status != E4000_I2C_SUCCESS)
		{
			return E4000_1_FAIL;
		}
	}
	else 
	{
		writearray[0] = 127;
		writearray[1] = 7;
		status=I2CWriteArray(pTuner, 200,159,2,writearray);
		if(status != E4000_I2C_SUCCESS)
		{
			return E4000_1_FAIL;
		}

		writearray[0] = 1;
		status=I2CWriteArray(pTuner, 200,136,1,writearray);
		if(status != E4000_I2C_SUCCESS)
		{
			return E4000_1_FAIL;
		}
	}

	//printf("\nRegister 9f=%d", writearray[0]);
	//printf("\nRegister a0=%d", writearray[1]);
	return E4000_1_SUCCESS;
}
/****************************************************************************\  
*  Function: DCoffloop
*
*  Detailed Description:
*  Populates DC offset LUT. (Registers 0x2d, 0x70, 0x71).
*  Turns on DC offset LUT and time varying DC offset.
\****************************************************************************/
int DCoffloop(TUNER_MODULE *pTuner)
{
	unsigned char writearray[5];
	int status;

	//writearray[0]=0;
	//I2CWriteByte(pTuner, 200,115,writearray[0]);
	//printf("\nRegister 73=%d", writearray[0]);
	writearray[0] = 31;
	status=I2CWriteByte(pTuner, 200,45,writearray[0]);
	//printf("\nRegister 2d=%d", writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = 1;
	writearray[1] = 1;
	status=I2CWriteArray(pTuner, 200,112,2,writearray);
	//printf("\nRegister 70=%d", writearray[0]);
	//printf("\nRegister 71=%d", writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS;
}
/****************************************************************************\  
*  Function: commonmode
*
*  Detailed Description:
*  Configures common mode voltage. (Registers 0x2f).
*  
\****************************************************************************/
/*
int commonmode(TUNER_MODULE *pTuner)
{
     //writearray[0] = 0;  
     //I2CWriteByte(Device_address,47,writearray[0]);
     //printf("\nRegister 0x2fh = %d", writearray[0]);
     // Sets 550mV. Modify if alternative is desired.
     return E4000_1_SUCCESS;
}
*/
/****************************************************************************\  
*  Function: GainControlinit
*
*  Detailed Description:
*  Configures gain control mode. (Registers 0x1d, 0x1e, 0x1f, 0x20, 0x21, 
*  0x1a, 0x74h, 0x75h).
*  User may wish to modify values depending on usage scenario.
*  Routine configures LNA: autonomous gain control
*  IF PWM gain control. 
*  PWM thresholds = default
*  Mixer: switches when LNA gain =7.5dB
*  Sensitivity / Linearity mode: manual switch
*  
\****************************************************************************/
int GainControlinit(TUNER_MODULE *pTuner)
{
	unsigned char writearray[5];
	unsigned char read1[1];
	int status;

	unsigned char sum=255;

	writearray[0] = 23;
	status=I2CWriteByte(pTuner, 200,26,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}
	//printf("\nRegister 1a=%d", writearray[0]);

	status=I2CReadByte(pTuner, 201,27,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = 16;  
	writearray[1] = 4;
	writearray[2] = 26;  
	writearray[3] = 15;  
	writearray[4] = 167;  
	status=I2CWriteArray(pTuner, 200,29,5,writearray);
	//printf("\nRegister 1d=%d", writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = 81;
	status=I2CWriteByte(pTuner, 200,134,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}
	//printf("\nRegister 86=%d", writearray[0]);

	//For Realtek - gain control logic
	status=I2CReadByte(pTuner, 201,27,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	if(read1[0]<=sum)
	{
		sum=read1[0];
	}

	status=I2CWriteByte(pTuner, 200,31,writearray[2]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}
	status=I2CReadByte(pTuner, 201,27,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	if(read1[0] <= sum)
	{
		sum=read1[0];
	}

	status=I2CWriteByte(pTuner, 200,31,writearray[2]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	status=I2CReadByte(pTuner, 201,27,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	if(read1[0] <= sum)
	{
		sum=read1[0];
	}

	status=I2CWriteByte(pTuner, 200,31,writearray[2]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	status=I2CReadByte(pTuner, 201,27,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	if(read1[0] <= sum)
	{
		sum=read1[0];
	}

	status=I2CWriteByte(pTuner, 200,31,writearray[2]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	status=I2CReadByte(pTuner, 201,27,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	if (read1[0]<=sum)
	{
		sum=read1[0];
	}

	writearray[0]=sum;
	status=I2CWriteByte(pTuner, 200,27,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}
	//printf("\nRegister 1b=%d", writearray[0]);
	//printf("\nRegister 1e=%d", writearray[1]);
	//printf("\nRegister 1f=%d", writearray[2]);
	//printf("\nRegister 20=%d", writearray[3]);
	//printf("\nRegister 21=%d", writearray[4]);
	//writearray[0] = 3;
	//writearray[1] = 252;
	//writearray[2] = 3;  
	//writearray[3] = 252; 
	//I2CWriteArray(pTuner, 200,116,4,writearray);
	//printf("\nRegister 74=%d", writearray[0]);
	//printf("\nRegister 75=%d", writearray[1]);
	//printf("\nRegister 76=%d", writearray[2]);
	//printf("\nRegister 77=%d", writearray[3]);

	return E4000_1_SUCCESS;
}

/****************************************************************************\  
*  Main program
*   
*  
*  
\****************************************************************************/
/*
int main()
{
     tunerreset (); 
     Tunerclock();
     //filtercal();
     Qpeak();
     //PLL(Ref_clk, Freq);
     //LNAfilter(Freq);
     //IFfilter(bandwidth, Ref_clk);
     //freqband(Freq);
     //DCoffLUT();
     DCoffloop();
     //commonmode();
     GainControlinit();
//     system("PAUSE");
  return(0);
}
*/






















// Elonics source code - frequency_change_rev2.04_realtek.c


//****************************************************************************/
//
//  Filename    E4000_freqchangerev2.04.c
//  Revision    2.04
//  
// Description:
//  Frequency change script for the Elonics E4000 revB tuner
//   
//  Copyright (c)  Elonics Ltd
//
//    Any software supplied free of charge for use with elonics
//    evaluation kits is supplied without warranty and for
//    evaluation purposes only. Incorporation of any of this
//    code into products for open sale is permitted but only at
//    the user's own risk. Elonics accepts no liability for the 
//    integrity of this software whatsoever.
//  
//
//****************************************************************************/
//#include <stdio.h>
//#include <stdlib.h>
//
// User defined variable definitions
//
/*
int Ref_clk = 20000;   // Reference clock frequency(kHz).
int Freq = 590000; // RF Frequency (kHz)
int bandwidth = 8;  //RF channel bandwith (MHz)
*/
//
// API defined variable definitions
//int VCO_freq;
//unsigned char writearray[5];
//unsigned char read1[1];
//int E4000_1_SUCCESS;
//int E4000_1_FAIL;
//int E4000_I2C_SUCCESS;
//int status;
//
//
// function definitions
//
/*
int Gainmanual();
int PLL(int Ref_clk, int Freq);
int LNAfilter(int Freq);
int IFfilter(int bandwidth, int Ref_clk);
int freqband(int Freq);
int DCoffLUT();
int GainControlauto();  
*/
//
//****************************************************************************
// --- Public functions ------------------------------------------------------
/****************************************************************************\  
//****************************************************************************\  
*  Function: Gainmanual
*
*  Detailed Description:
*  Sets Gain control to serial interface control.
*
\****************************************************************************/
int Gainmanual(TUNER_MODULE *pTuner)
{
	unsigned char writearray[5];
	int status;

	writearray[0]=0;
	status=I2CWriteByte(pTuner, 200,26,writearray[0]);
	//printf("\nRegister 1a=%d", writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = 0;
	status=I2CWriteByte (pTuner, 200,9,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}
 
	writearray[0] = 0;
	status=I2CWriteByte (pTuner, 200,5,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS; 
}

/****************************************************************************\  
*  Function: PLL
*
*  Detailed Description:
*  Configures E4000 PLL divider & sigma delta. 0x0d,0x09, 0x0a, 0x0b).
*
\****************************************************************************/
int PLL(TUNER_MODULE *pTuner, int Ref_clk, int Freq)
{
	int VCO_freq;
	unsigned char writearray[5];
	int status;

	unsigned char divider;
	int intVCOfreq; 
	int SigDel;
	int SigDel2;
	int SigDel3;  
//	int harmonic_freq;
//	int offset;

	if (Freq<=72400)
	{
		writearray[4] = 15;
		VCO_freq=Freq*48;
	}
	else if (Freq<=81200)
    {
		writearray[4] = 14;
		VCO_freq=Freq*40;
	}
	else if (Freq<=108300)
	{
		writearray[4]=13;
		VCO_freq=Freq*32;
	}
	else if (Freq<=162500)
	{
		writearray[4]=12;
		VCO_freq=Freq*24;
	}   
	else if (Freq<=216600)       
	{
		writearray[4]=11;  
		VCO_freq=Freq*16;
	}
	else if (Freq<=325000)
	{
		writearray[4]=10;
		VCO_freq=Freq*12;
	}
	else if (Freq<=350000)
	{
		writearray[4]=9;
		VCO_freq=Freq*8;  
	}
	else if (Freq<=432000)
	{
		writearray[4]=3;
		VCO_freq=Freq*8;
	}
	else if (Freq<=667000)
	{
		writearray[4]=2; 
		VCO_freq=Freq*6; 
	}
	else if (Freq<=1200000)
	{
		writearray[4]=1;
		VCO_freq=Freq*4;
	}
	else
	{
		writearray[4]=0;
		VCO_freq=Freq*2; 
	}

	//printf("\nVCOfreq=%d", VCO_freq);     
//	divider =  VCO_freq * 1000 / Ref_clk;
	divider =  VCO_freq / Ref_clk;
	//printf("\ndivider=%d", divider); 
	writearray[0]= divider;  
//	intVCOfreq = divider * Ref_clk /1000;
	intVCOfreq = divider * Ref_clk;
	//printf("\ninteger VCO freq=%d", intVCOfreq);
//	SigDel=65536 * 1000 * (VCO_freq - intVCOfreq) / Ref_clk;
	SigDel=65536 * (VCO_freq - intVCOfreq) / Ref_clk;
	//printf("\nSigma delta=%d", SigDel);
	if (SigDel<=1024)
	{
		SigDel = 1024;
	}
	else if (SigDel>=64512)
	{
		SigDel=64512;
	}
	SigDel2 = SigDel / 256;
	//printf("\nSigdel2=%d", SigDel2);
	writearray[2] = (unsigned char)SigDel2;
	SigDel3 = SigDel - (256 * SigDel2);
	//printf("\nSig del3=%d", SigDel3);
	writearray[1]= (unsigned char)SigDel3;
	writearray[3]=(unsigned char)0;
	status=I2CWriteArray(pTuner, 200,9,5,writearray);
	//printf("\nRegister 9=%d", writearray[0]);
	//printf("\nRegister a=%d", writearray[1]);
	//printf("\nRegister b=%d", writearray[2]);
	//printf("\nRegister d=%d", writearray[4]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	if (Freq<=82900)
	{
		writearray[0]=0;
		writearray[2]=1;
	}
	else if (Freq<=89900)
	{
		writearray[0]=3;
		writearray[2]=9;
	}
	else if (Freq<=111700)
	{
		writearray[0]=0;
		writearray[2]=1;
	}
	else if (Freq<=118700)
	{
		writearray[0]=3;
		writearray[2]=1;
	}
	else if (Freq<=140500)
	{
		writearray[0]=0;
		writearray[2]=3;
	}
	else if (Freq<=147500)
	{
		writearray[0]=3;
		writearray[2]=11;
	}
	else if (Freq<=169300)
	{
		writearray[0]=0;
		writearray[2]=3;
	}
	else if (Freq<=176300)
	{
		writearray[0]=3;
		writearray[2]=11;
	}
	else if (Freq<=198100)
	{
		writearray[0]=0;
		writearray[2]=3;
	}
	else if (Freq<=205100)
	{
		writearray[0]=3;
		writearray[2]=19;
	}
	else if (Freq<=226900)
	{
		writearray[0]=0;
		writearray[2]=3;
	}
	else if (Freq<=233900)
	{
		writearray[0]=3;
		writearray[2]=3;
	}
	else if (Freq<=350000)
	{
		writearray[0]=0;
		writearray[2]=3;
	}
	else if (Freq<=485600)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=493600)
	{
		writearray[0]=3;
		writearray[2]=5;
	}
	else if (Freq<=514400)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=522400)
	{
		writearray[0]=3;
		writearray[2]=5;
	}
	else if (Freq<=543200)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=551200)
	{
		writearray[0]=3;
		writearray[2]=13;
	}
	else if (Freq<=572000)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=580000)
	{
		writearray[0]=3;
		writearray[2]=13;
	}
	else if (Freq<=600800)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=608800)
	{
		writearray[0]=3;
		writearray[2]=13;
	}
	else if (Freq<=629600)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=637600)
	{
		writearray[0]=3;
		writearray[2]=13;
	}
	else if (Freq<=658400)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=666400)
	{
		writearray[0]=3;
		writearray[2]=13;
	}
	else if (Freq<=687200)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=695200)
	{
		writearray[0]=3;
		writearray[2]=13;
	}
	else if (Freq<=716000)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=724000)
	{
		writearray[0]=3;
		writearray[2]=13;
	}
	else if (Freq<=744800)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=752800)
	{
		writearray[0]=3;
		writearray[2]=21;
	}
	else if (Freq<=773600)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=781600)
	{
		writearray[0]=3;
		writearray[2]=21;
	}
	else if (Freq<=802400)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=810400)
	{
		writearray[0]=3;
		writearray[2]=21;
	}
	else if (Freq<=831200)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=839200)
	{
		writearray[0]=3;
		writearray[2]=21;
	}
	else if (Freq<=860000)
	{
		writearray[0]=0;
		writearray[2]=5;
	}
	else if (Freq<=868000)
	{
		writearray[0]=3;
		writearray[2]=21;
	}
	else
	{
		writearray[0]=0;
		writearray[2]=7;
	}

	status=I2CWriteByte (pTuner, 200,7,writearray[2]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	status=I2CWriteByte (pTuner, 200,5,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS; 
}

/****************************************************************************\  
*  Function: LNAfilter
*
*  Detailed Description:
*  The function configures the E4000 LNA filter. (Register 0x10).
*
\****************************************************************************/

int LNAfilter(TUNER_MODULE *pTuner, int Freq)
{
	unsigned char writearray[5];
	int status;

	if(Freq<=370000)
	{
		writearray[0]=0;
	}
	else if(Freq<=392500)
	{
		writearray[0]=1;
	}
	else if(Freq<=415000)
	{
		writearray[0] =2;
	}
	else if(Freq<=437500)
	{
		writearray[0]=3;
	}
	else if(Freq<=462500)
	{
		writearray[0]=4;
	}
	else if(Freq<=490000)
	{
		writearray[0]=5;
	}
	else if(Freq<=522500)
	{
		writearray[0]=6;
	}
	else if(Freq<=557500)
	{
		writearray[0]=7;
	}
	else if(Freq<=595000)
	{
		writearray[0]=8;
	}
	else if(Freq<=642500)
	{
		writearray[0]=9;
	}
	else if(Freq<=695000)
	{
		writearray[0]=10;
	}
	else if(Freq<=740000)
	{
		writearray[0]=11;
	}
	else if(Freq<=800000)
	{
		writearray[0]=12;
	}
	else if(Freq<=865000)
	{
		writearray[0] =13;
	}
	else if(Freq<=930000)
	{
		writearray[0]=14;
	}
	else if(Freq<=1000000)
	{
		writearray[0]=15;
	}
	else if(Freq<=1310000)
	{
		writearray[0]=0;
	}
	else if(Freq<=1340000)
	{
		writearray[0]=1;
	}
	else if(Freq<=1385000)
	{
		writearray[0]=2;
	}
	else if(Freq<=1427500)
	{
		writearray[0]=3;
	}
	else if(Freq<=1452500)
	{
		writearray[0]=4;
	}
	else if(Freq<=1475000)
	{
		writearray[0]=5;
	}
	else if(Freq<=1510000)
	{
		writearray[0]=6;
	}
	else if(Freq<=1545000)
	{
		writearray[0]=7;
	}
	else if(Freq<=1575000)
	{
		writearray[0] =8;
	}
	else if(Freq<=1615000)
	{
		writearray[0]=9;
	}
	else if(Freq<=1650000)
	{
		writearray[0] =10;
	}
	else if(Freq<=1670000)
	{
		writearray[0]=11;
	}
	else if(Freq<=1690000)
	{
		writearray[0]=12;
	}
	else if(Freq<=1710000)
	{
		writearray[0]=13;
	}
	else if(Freq<=1735000)
	{
		writearray[0]=14;
	}
	else
	{
		writearray[0]=15;
	}
	status=I2CWriteByte (pTuner, 200,16,writearray[0]);
	//printf("\nRegister 10=%d", writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS;   
}
/****************************************************************************\  
*  Function: IFfilter
*
*  Detailed Description:
*  The function configures the E4000 IF filter. (Register 0x11,0x12).
*
\****************************************************************************/
int IFfilter(TUNER_MODULE *pTuner, int bandwidth, int Ref_clk)
{
	unsigned char writearray[5];
	int status;

	int IF_BW;

	IF_BW = bandwidth / 2;
	if(IF_BW<=2150)
	{
		writearray[0]=253;
		writearray[1]=31;
	}
	else if(IF_BW<=2200)
	{
		writearray[0]=253;
		writearray[1]=30;
	}
	else if(IF_BW<=2240)
	{
		writearray[0]=252;                  
		writearray[1]=29;
	}
	else if(IF_BW<=2280)
	{
		writearray[0]=252;                  
		writearray[1]=28;
	}
	else if(IF_BW<=2300)
	{
		writearray[0]=252;
		writearray[1]=27;
	}
	else if(IF_BW<=2400)
	{
		writearray[0]=252;
		writearray[1]=26;
	}
	else if(IF_BW<=2450)
	{
		writearray[0]=252;                  
		writearray[1]=25;
	}
	else if(IF_BW<=2500)
	{
		writearray[0]=252;               
		writearray[1]=24;
	}
	else if(IF_BW<=2550)
	{
		writearray[0]=252;                 
		writearray[1]=23;
	}
	else if(IF_BW<=2600)
	{
		writearray[0]=252;                 
		writearray[1]=22;
	}
	else if(IF_BW<=2700)
	{
		writearray[0]=252;                 
		writearray[1]=21;
	}
	else if(IF_BW<=2750)
	{
		writearray[0]=252;                  
		writearray[1]=20;
	}
	else if(IF_BW<=2800)
	{
		writearray[0]=252;
		writearray[1]=19;
	}
	else if(IF_BW<=2900)
	{
		writearray[0]=251;                
		writearray[1]=18;
	}
	else if(IF_BW<=2950)
	{
		writearray[0]=251;
		writearray[1]=17;
	}
	else if(IF_BW<=3000)
	{
		writearray[0]=251;              
		writearray[1]=16;
	}
	else if(IF_BW<=3100)
	{
		writearray[0]=251;                 
		writearray[1]=15;
	}
	else if(IF_BW<=3200)
	{
		writearray[0]=250;
		writearray[1]=14;
	}
	else if(IF_BW<=3300)
	{
		writearray[0]=250;                 
		writearray[1]=13;
	}
	else if(IF_BW<=3400)
	{
		writearray[0]=249;                 
		writearray[1]=12;
	}
	else if(IF_BW<=3600)
	{
		writearray[0]=249;
		writearray[1]=11;
	}
	else if(IF_BW<=3700)
	{
		writearray[0]=249;
		writearray[1]=10;
	}
	else if(IF_BW<=3800)
	{
		writearray[0]=248;
		writearray[1]=9;
	}
	else if(IF_BW<=3900)
	{
		writearray[0]=248;
		writearray[1]=8;
	}
	else if(IF_BW<=4100)
	{
		writearray[0]=248;
		writearray[1]=7;
	}
	else if(IF_BW<=4300)
	{
		writearray[0]=247;
		writearray[1]=6;
	}
	else if(IF_BW<=4400)
	{
		writearray[0]=247;
		writearray[1]=5;
	}
	else if(IF_BW<=4600)
	{
		writearray[0]=247;
		writearray[1]=4;
	}
	else if(IF_BW<=4800)
	{
		writearray[0]=246;
		writearray[1]=3;
	}
	else if(IF_BW<=5000)
	{
		writearray[0]=246;
		writearray[1]=2;
	}
	else if(IF_BW<=5300)
	{
		writearray[0]=245;
		writearray[1]=1;
	}
	else if(IF_BW<=5500)
	{
		writearray[0]=245;
		writearray[1]=0;
	}
	else
	{
		writearray[0]=0;
		writearray[1]=32;
	}
	status=I2CWriteArray(pTuner, 200,17,2,writearray);
	//printf("\nRegister 11=%d", writearray[0]);
	//printf("\nRegister 12=%d", writearray[1]);             
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS; 
}
/****************************************************************************\  
*  Function: freqband
*
*  Detailed Description:
*  Configures the E4000 frequency band. (Registers 0x07, 0x78).
*
\****************************************************************************/
int freqband(TUNER_MODULE *pTuner, int Freq)
{      
	unsigned char writearray[5];
	int status;

	if (Freq<=140000)
	{
		writearray[0] = 3;
		status=I2CWriteByte(pTuner, 200,120,writearray[0]);
		if(status != E4000_I2C_SUCCESS)
		{
			return E4000_1_FAIL;
		}
	}
	else if (Freq<=350000)
	{
		writearray[0] = 3;
		status=I2CWriteByte(pTuner, 200,120,writearray[0]);
		if(status != E4000_I2C_SUCCESS)
		{
			return E4000_1_FAIL;
		}
	}
	else if (Freq<=1000000)
	{
		writearray[0] = 3;
		status=I2CWriteByte(pTuner, 200,120,writearray[0]);
		if(status != E4000_I2C_SUCCESS)
		{
			return E4000_1_FAIL;
		}
	}
	else 
	{
		writearray[0] = 7;
		status=I2CWriteByte(pTuner, 200,7,writearray[0]);
		if(status != E4000_I2C_SUCCESS)
		{
			return E4000_1_FAIL;
		}

		writearray[0] = 0;
		status=I2CWriteByte(pTuner, 200,120,writearray[0]);
		if(status != E4000_I2C_SUCCESS)
		{
			return E4000_1_FAIL;
		}
	}

	return E4000_1_SUCCESS;  
}
/****************************************************************************\  
*  Function: DCoffLUT
*
*  Detailed Description:
*  Populates DC offset LUT. (Registers 0x50 - 0x53, 0x60 - 0x63).
*
\****************************************************************************/
int DCoffLUT(TUNER_MODULE *pTuner)
{
	unsigned char writearray[5];
	int status;

	unsigned char read1[1];
	unsigned char IOFF;
	unsigned char QOFF;
	unsigned char RANGE1;
//	unsigned char RANGE2;
	unsigned char QRANGE;
	unsigned char IRANGE;
	writearray[0] = 0;
	writearray[1] = 126;
	writearray[2] = 36;
	status=I2CWriteArray(pTuner, 200,21,3,writearray);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	// Sets mixer & IF stage 1 gain = 00 and IF stg 2+ to max gain.
	writearray[0] = 1;
	status=I2CWriteByte(pTuner, 200,41,writearray[0]);
	// Instructs a DC offset calibration. 
	status=I2CReadByte(pTuner, 201,42,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	IOFF=read1[0];
	status=I2CReadByte(pTuner, 201,43,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	QOFF=read1[0];
	status=I2CReadByte(pTuner, 201,44,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	RANGE1=read1[0];
	//reads DC offset values back
	if(RANGE1>=32)
	{
		RANGE1 = RANGE1 -32;
	}
	if(RANGE1>=16)
	{
		RANGE1 = RANGE1 - 16;
	}
	IRANGE=RANGE1;
	QRANGE = (read1[0] - RANGE1) / 16;

	writearray[0] = (IRANGE * 64) + IOFF;
	status=I2CWriteByte(pTuner, 200,96,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = (QRANGE * 64) + QOFF;
	status=I2CWriteByte(pTuner, 200,80,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	// Populate DC offset LUT
	writearray[0] = 0;
	writearray[1] = 127;
	status=I2CWriteArray(pTuner, 200,21,2,writearray);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	// Sets mixer & IF stage 1 gain = 01 leaving IF stg 2+ at max gain.
	writearray[0]= 1;
	status=I2CWriteByte(pTuner, 200,41,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	// Instructs a DC offset calibration.
	status=I2CReadByte(pTuner, 201,42,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	IOFF=read1[0];
	status=I2CReadByte(pTuner, 201,43,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	QOFF=read1[0];
	status=I2CReadByte(pTuner, 201,44,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	RANGE1=read1[0];
	// Read DC offset values
	if(RANGE1>=32)
	{
		RANGE1 = RANGE1 -32;
	}
	if(RANGE1>=16)
    {
		RANGE1 = RANGE1 - 16;
	}
	IRANGE = RANGE1;
	QRANGE = (read1[0] - RANGE1) / 16;

	writearray[0] = (IRANGE * 64) + IOFF;
	status=I2CWriteByte(pTuner, 200,97,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = (QRANGE * 64) + QOFF;
	status=I2CWriteByte(pTuner, 200,81,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	// Populate DC offset LUT
	writearray[0] = 1;
	status=I2CWriteByte(pTuner, 200,21,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	// Sets mixer & IF stage 1 gain = 11 leaving IF stg 2+ at max gain.
	writearray[0] = 1;
	status=I2CWriteByte(pTuner, 200,41,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	// Instructs a DC offset calibration.
	status=I2CReadByte(pTuner, 201,42,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	IOFF=read1[0];
	status=I2CReadByte(pTuner, 201,43,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	QOFF=read1[0];
	status=I2CReadByte(pTuner, 201,44,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	RANGE1 = read1[0];
	// Read DC offset values
	if(RANGE1>=32)
	{
		RANGE1 = RANGE1 -32;
	}
	if(RANGE1>=16)
	{
		RANGE1 = RANGE1 - 16;
	}
	IRANGE = RANGE1;
	QRANGE = (read1[0] - RANGE1) / 16;
	writearray[0] = (IRANGE * 64) + IOFF;
	status=I2CWriteByte(pTuner, 200,99,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = (QRANGE * 64) + QOFF;
	status=I2CWriteByte(pTuner, 200,83,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	// Populate DC offset LUT
	writearray[0] = 126;
	status=I2CWriteByte(pTuner, 200,22,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	// Sets mixer & IF stage 1 gain = 11 leaving IF stg 2+ at max gain.
	writearray[0] = 1;
	status=I2CWriteByte(pTuner, 200,41,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	// Instructs a DC offset calibration.
	status=I2CReadByte(pTuner, 201,42,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}
	IOFF=read1[0];

	status=I2CReadByte(pTuner, 201,43,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}
	QOFF=read1[0];
	
	status=I2CReadByte(pTuner, 201,44,read1);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}
	RANGE1=read1[0];
	
	// Read DC offset values
	if(RANGE1>=32)
	{
		RANGE1 = RANGE1 -32;
	}
	if(RANGE1>=16)
	{
		RANGE1 = RANGE1 - 16;
	}
	IRANGE = RANGE1;
	QRANGE = (read1[0] - RANGE1) / 16;

	writearray[0]=(IRANGE * 64) + IOFF;
	status=I2CWriteByte(pTuner, 200,98,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	writearray[0] = (QRANGE * 64) + QOFF;
	status=I2CWriteByte(pTuner, 200,82,writearray[0]);
	// Populate DC offset LUT
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS; 
}
/****************************************************************************\  
*  Function: GainControlinit
*
*  Detailed Description:
*  Configures gain control mode. (Registers 0x1a)
*
\****************************************************************************/
int GainControlauto(TUNER_MODULE *pTuner)
{
	unsigned char writearray[5];
	int status;

	writearray[0] = 23;
	status=I2CWriteByte(pTuner, 200,26,writearray[0]);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS; 
}
/****************************************************************************\  
*  Main program
*   
*  
*  
\****************************************************************************/
/*
int main()
{
     Gainmanual();
     PLL(Ref_clk, Freq);
     LNAfilter(Freq);
     IFfilter(bandwidth, Ref_clk);
     freqband(Freq);
     DCoffLUT();
     GainControlauto();
  return(0);
}
*/






















// Elonics source code - RT2832_SW_optimisation_rev2.c



/****************************************************************************\  
*  Function: E4000_sensitivity
*
*  Detailed Description:
*  The function configures the E4000 for sensitivity mode.
*
\****************************************************************************/

int E4000_sensitivity(TUNER_MODULE *pTuner, int Freq, int bandwidth)
{
	unsigned char writearray[2];
	int status;
	int IF_BW;

	if(Freq<=700000)
	{
		writearray[0] = 0x07;
	}
	else
	{
		writearray[0] = 0x05;
	}
	status = I2CWriteArray(pTuner,200,36,1,writearray);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	IF_BW = bandwidth / 2;
	if(IF_BW<=2500)
	{
		writearray[0]=0xfc;
		writearray[1]=0x17;
	}
    else if(IF_BW<=3000)
	{
		writearray[0]=0xfb;
		writearray[1]=0x0f;
	}
	else if(IF_BW<=3500)
	{
		writearray[0]=0xf9;                  
		writearray[1]=0x0b;
	}
	else if(IF_BW<=4000)
	{
		writearray[0]=0xf8;                  
		writearray[1]=0x07;
	}
	status = I2CWriteArray(pTuner,200,17,2,writearray);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS;
}
/****************************************************************************\  
*  Function: E4000_linearity
*
*  Detailed Description:
*  The function configures the E4000 for linearity mode.
*
\****************************************************************************/
int E4000_linearity(TUNER_MODULE *pTuner, int Freq, int bandwidth)
{
	
	unsigned char writearray[2];
	int status;
	int IF_BW;

	if(Freq<=700000)
	{
		writearray[0] = 0x03;
	}
	else
	{
		writearray[0] = 0x01;
	}
	status = I2CWriteArray(pTuner,200,36,1,writearray);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	IF_BW = bandwidth / 2;
	if(IF_BW<=2500)
	{
		writearray[0]=0xfe;                 
		writearray[1]=0x19;
	}
	else if(IF_BW<=3000)
	{
		writearray[0]=0xfd;                 
		writearray[1]=0x11;
	}
	else if(IF_BW<=3500)
	{
		writearray[0]=0xfb;
		writearray[1]=0x0d;
	}
	else if(IF_BW<=4000)
	{
		writearray[0]=0xfa;
		writearray[1]=0x0a;
	}
	status = I2CWriteArray(pTuner,200,17,2,writearray);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS;
}
/****************************************************************************\  
*  Function: E4000_nominal
*
*  Detailed Description:
*  The function configures the E4000 for nominal
*
\****************************************************************************/
int E4000_nominal(TUNER_MODULE *pTuner, int Freq, int bandwidth)
{
	unsigned char writearray[2];
	int status;
	int IF_BW;

	if(Freq<=700000)
	{
		writearray[0] = 0x03;
	}
	else
	{
		writearray[0] = 0x01;
	}
	status = I2CWriteArray(pTuner,200,36,1,writearray);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	IF_BW = bandwidth / 2;
	if(IF_BW<=2500)
	{
		writearray[0]=0xfc;                 
		writearray[1]=0x17;
	}
	else if(IF_BW<=3000)
	{
		writearray[0]=0xfb;                 
		writearray[1]=0x0f;
	}
	else if(IF_BW<=3500)
	{
		writearray[0]=0xf9;
		writearray[1]=0x0b;
	}
	else if(IF_BW<=4000)
	{
		writearray[0]=0xf8;
		writearray[1]=0x07;
	}
	status = I2CWriteArray(pTuner,200,17,2,writearray);
	if(status != E4000_I2C_SUCCESS)
	{
		return E4000_1_FAIL;
	}

	return E4000_1_SUCCESS;
}











--------------080601030503010206040103--
