Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:33441 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaCJJv5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 05:51:57 -0400
Received: by mail-we0-f177.google.com with SMTP id u57so8066895wes.22
        for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 02:51:56 -0700 (PDT)
Received: from [192.168.0.101] (ip-95-223-138-4.unitymediagroup.de. [95.223.138.4])
        by mx.google.com with ESMTPSA id az1sm49352418wjb.11.2014.03.10.02.51.54
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 10 Mar 2014 02:51:55 -0700 (PDT)
Message-ID: <531D8B39.9010504@gmail.com>
Date: Mon, 10 Mar 2014 10:51:53 +0100
From: Jan Gebhardt <h.smith05@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: problems with Cinergy HTC HD Rev. 2 (0x0ccd:0x0101) Conexant 231xx
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

i have some problems using the Terratec Cinergy HTC Stick HD Rev. 2 .

The driver or the specification is currenty not implemented into 
driverset of media-build.

All i know is, that there is a buildin Conexant Chip (I think the 
CX23102) and a SiliconLabs Tuner (SI2173). I already tried to adapt this 
knownledge combined with the configuration of the windows driver to the 
driver(cx231xx) but sadly without success.

Hopefully someone can help me with that problem or may tell me what i 
did wrong.

Thanks!



[cx231xx-cards.c]

         .name = "Terratec CINERGY HTC STICK HD Rev. 2",
         .tuner_type = TUNER_ABSENT,                /**/
         .tuner_addr = 0xc0,                                /**/
         .decoder = CX231XX_AVDECODER,
         .output_mode = OUT_MODE_VIP11,
         .demod_xfer_mode = 0,
         .ctl_pin_status_mask = 0xFFFFFFC4,
         .agc_analog_digital_select_gpio = 0x11,
         .tuner_sif_gpio = -1,
         .tuner_scl_gpio = -1,
         .tuner_sda_gpio = -1,
         .gpio_pin_status_mask = 0x4001000,
         .tuner_i2c_master = 3,
         .demod_i2c_master = 2,                        /**/
         .ir_i2c_master = 2,
         .has_dvb = 1,
         .demod_addr = 0xc8,                                /**/
         .norm = V4L2_STD_NTSC_M,
         .input = {{
             .type = CX231XX_VMUX_TELEVISION,
             .vmux = CX231XX_VIN_3_1,
             .amux = CX231XX_AMUX_VIDEO,
             .gpio = NULL,
         }, {
             .type = CX231XX_VMUX_COMPOSITE1,
             .vmux = CX231XX_VIN_2_1,
             .amux = CX231XX_AMUX_LINE_IN,
             .gpio = NULL,
         }, {
             .type = CX231XX_VMUX_SVIDEO,
             .vmux = CX231XX_VIN_1_1 |
                 (CX231XX_VIN_1_2 << 8) |
                 CX25840_SVIDEO_ON,
             .amux = CX231XX_AMUX_LINE_IN,
             .gpio = NULL,
         } },
     },


==============================
[cinergy_htc_stick_hd.inf (orig: cxPolaris.inf)]



; Sony format = 1, Philips format = 0
HKR,"DriverData","I2SInputFormat",0x00010001, 0x00, 0x00, 0x00, 0x00

HKR,"DriverData","EnableAFAudio",0x00010001, 0x01, 0x00, 0x00, 0x00
HKR,"DriverData","GpioMaskFM",0x00010001, 0x01, 0x00, 0x00, 0x00
HKR,"DriverData","GpioSettingFM",0x00010001, 0x01, 0x00, 0x00, 0x00

HKR,"DriverData","VideoStandard",0x00010001, 0x20,0x00,0x00,0x00

;Gain has 7 levels in volume up and down directions. each level gives 
6db gain or attenuation
;for attenuation we need to use 2's complement values.
;for Gain we use levels 1-7, for attenuation we use levels 0x9(-7) - 0xF 
(-1)
HKR,"DriverData","FMAudioGain",0x00010001, 0x1, 0x00, 0x00, 0x00


; for Polaris testing, select HANC to transfer Audio
HKR,"DriverData","EnableHANCAudioOut",0x00010001, 0x00, 0x00, 0x00, 0x00

; ----GPIO Pin values -----
; IMPORTANT !!! if any GPIO is not used - just delete the corresponding 
entry !!!

; AGC_Analog_Digitial_Select_Gpio_Bit is controlled by GPIO 28
HKR,"DriverData","AGC_Analog_Digitial_Select_Gpio_Bit", 0x00010001, 
0x1C, 0x00, 0x00, 0x00
;gpio pin status mask, useless pin bit is 0 ;useful pin bit is 1
HKR,"DriverData","gpio_pin_status_mask",0x00010001, 0x4001000

;PIN_CTRL pin status mask, useless pin bit is 0 ;useful pin bit is 1
HKR,"DriverData","ctrl_pin_status_mask",0x00010001, 0xFFFFFFC4

;Safely_Remove_Hardware=1: enable, by default
;Safely_Remove_Hardware=0: disable, then Polaris will not appear in the 
safely remove hardware icon list.
HKR,"DriverData","Safely_Remove_Hardware",0x00010001, 0x01, 0x00, 0x00, 
0x00

;-------------------------------------------------------------------
; Crossbar AddReg sections
;
;---Crossbar registry values---
;
; Note: For each pin on the crossbar, specify the following:
; (1) Pin type
;     0 - SVIDEO
;     1 - Tuner
;     2 - Composite
;     3 - audio tuner in
;     4 - audio line in
;     7 - YUV
; (2) InputMux - input mux to use for the selected pin
; (3) RelatedPinIndex
;-------------------------------------------------------------------


;---Crossbar registry values---
;Pin 0 - Tuner In
; Input Mux       : VIN2_1 for Tuner input from NXP18271
HKR,"DriverData\XBarPin0","PinType",0x00010001, 0x01,0x00,0x00,0x00
HKR,"DriverData\XBarPin0","InputMux",0x00010001, 0x03,0x00,0x00,0x00
HKR,"DriverData\XBarPin0","RelatedPinIndex",0x00010001, 0x03,0x00,0x00,0x00

;Pin 1 - Composite in
; Input Mux       : VIN2_1 for Composite
HKR,"DriverData\XBarPin1","PinType",0x00010001, 0x02,0x00,0x00,0x00
HKR,"DriverData\XBarPin1","InputMux",0x00010001, 0x02,0x00,0x00,0x00
HKR,"DriverData\XBarPin1","RelatedPinIndex",0x00010001, 0x04,0x00,0x00,0x00

;Pin 2 - S-Video in
; Input Mux       : VIN1_1 for Luma, VIN1_2 for Chroma
HKR,"DriverData\XBarPin2","PinType",0x00010001, 0x00,0x00,0x00,0x00
HKR,"DriverData\XBarPin2","InputMux",0x00010001, 0x01,0x01,0x00,0x00
HKR,"DriverData\XBarPin2","RelatedPinIndex",0x00010001, 0x04,0x00,0x00,0x00

;Pin 3 - Tuner Audio
HKR,"DriverData\XBarPin3","PinType",0x00010001, 0x03,0x00,0x00,0x00
HKR,"DriverData\XBarPin3","InputMux",0x00010001, 0x00,0x00,0x00,0x00
HKR,"DriverData\XBarPin3","RelatedPinIndex",0x00010001, 0x00,0x00,0x00,0x00

;Pin 4 - Audio Line in
HKR,"DriverData\XBarPin4","PinType",0x00010001, 0x04,0x00,0x00,0x00
HKR,"DriverData\XBarPin4","InputMux",0x00010001, 0x00,0x00,0x00,0x00
HKR,"DriverData\XBarPin4","RelatedPinIndex",0x00010001, 0x01,0x00,0x00,0x00
HKR,"DriverData\XBarPin4","GpioMask",0x00010001, 0x01,0x00,0x00,0x00
HKR,"DriverData\XBarPin4","GpioSettings",0x00010001, 0x00,0x00,0x00,0x00

HKR,"DriverData","VideoInputPin",0x00010001, 0x00,0x00,0x00,0x00
HKR,"DriverData","AudioInputPin",0x00010001, 0x03,0x00,0x00,0x00
HKR,"DriverData","ForceAudioWithVideoPin",0x00010001, 0x01,0x00,0x00,0x00
HKR,"DriverData","EnableAutoFormatDetection",0x00010001, 0x01, 0x00, 
0x00, 0x00

HKR,"DriverData","BoardType",0x00010001, 0xeb, 0x03, 0x00, 0x00
HKR,"DriverData","TunerType",0x00010001, 0x2D, 0x00, 0x00, 0x00

;Tuner I2c address SILABS_SI2170 :0xc0
HKR,"DriverData","TunerI2CAddress",0x00010001, 0xc0, 0x00, 0x00, 0x00

;Tuner xceive5000  crystal frequency=32M
;Tuner nxp18271    crystal frequency=16M
HKR,"DriverData","AnalogTunerXTALFreq",0x00010001, 0x10, 0x00, 0x00, 0x00

;Saw filter type: Temex=0,TRIQUINT/SAWTEK=1,EPCOS=2, Bypass=3
;for sidewinder :Temex =>xtal_freq=1218600000(1218.6Mhz)
HKR,"DriverData","SawFilterType",0x00010001, 0x3, 0x00, 0x00, 0x00

;I2C speed: 0-1M,1-400K,2-100K,3-5M
HKR,"DriverData","I2CSpeed",0x00010001, 0x1, 0x00, 0x00, 0x00

;I2C mode: 0-STOP, 1-NON STOP
HKR,"DriverData","I2CMode",0x00010001, 0x0, 0x00, 0x00, 0x00

;Enable SoftEncode - TRUE
HKR,"DriverData","Enable_SW_Encoder",0x00010001, 0x01, 0x00, 0x00, 0x00

; for creating unique serial number to Tuners on the board
HKR,"DriverData","NoOfTuners",0x00010001, 0x01, 0x00, 0x00, 0x00

;tuner category : 0 - Analog, 1 - Digital , 2 - Hybrid
HKR,"DriverData","TunerCategory",0x00010001, 0x02, 0x00, 0x00, 0x00

;Enable TS capture and BDA filter registration
HKR,"DriverData","Enable_BDA",0x00010001, 0x01, 0x00, 0x00, 0x00

; BDA_Demod_Tuner_Type
;SI2165_SI2170 = 0x10
HKR,"DriverData","BDA_Demod_Tuner_type",0x00010001, 0x10, 0x00, 0x00, 0x00

; Demod Crystal Freq
; Altair:56M(0xDAC0),  GeminiIII : 24.69M(0x6072),Aquarius: 24MHz(0x5dc0 
kHz).  NOTE: unit is KHz
HKR,"DriverData","DemodXTALFreqKHz",0x00010001, 0xc0, 0x5d, 0x00, 0x00

; digital Demod I2C address
; Altair:0x0A,  GeminiIII : 0x32, Aquarius: 0x02 , Si2165: 0xc8
HKR,"DriverData","DemodI2CAddress",0x00010001, 0xC8, 0x00, 0x00, 0x00

; GPIO Pin values
; IMPORTANT !!! if any GPIO is not used - just delete the corresponding 
entry !!!
;only for xc5000 tuner
HKR,"DriverData","tuner_reset_gpio_bit", 0x00010001, 0x03, 0x00, 0x00, 0x00

HKR,"DriverData","tuner_sif_fm_gpio_bit", 0x00010001, 0x05, 0x00, 0x00, 
0x00

;The GPIO pin used for XC5000 GPIO emulated I2C bus SCL, GPIO26->SCL
HKR,"DriverData","XC_GPIO_I2C_SCL", 0x00010001, 0x1A, 0x00, 0x00, 0x00

;The GPIO pin used for XC5000 GPIO emulated I2C bus SDA, GPIO27->SDA
HKR,"DriverData","XC_GPIO_I2C_SDA", 0x00010001, 0x1B, 0x00, 0x00, 0x00


;Demod Comm mode : 0x00 = Serial, 0x01 = Parallel
HKR,"DriverData","DemodTransferMode",0x00010001, 0x00, 0x00, 0x00, 0x00

;Tuner I2C master selection
;Polaris I2C master 3--3, Polaris I2C master 2--2
HKR,"DriverData","TunerI2CMaster",0x00010001, 0x03, 0x00, 0x00, 0x00


;Demod I2C master selection
;Polaris I2C master 3--3, Polaris I2C master 2--2
HKR,"DriverData","DemodI2CMaster",0x00010001, 0x02, 0x00, 0x00, 0x00

;Cx24232 demod sleep GPIO control pin
HKR,"DriverData","BDA_Demod_GPIO_PIN",0x00010001, 0x1E, 0x00, 0x00, 0x00

;shutdown tuner power when switch to baseband video
HKR,"DriverData","ShutdownTunerInCVBS",0x00010001, 0x01, 0x00, 0x00, 0x00

