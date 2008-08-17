Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HHLAlX002555
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 13:21:10 -0400
Received: from web34501.mail.mud.yahoo.com (web34501.mail.mud.yahoo.com
	[66.163.178.167])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7HHKrbv032587
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 13:20:53 -0400
Date: Sun, 17 Aug 2008 10:20:48 -0700 (PDT)
From: Carlos Limarino <climarino@yahoo.com.ar>
To: video4linux-list@redhat.com
In-Reply-To: <474079.21637.qm@web34503.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <413360.56066.qm@web34501.mail.mud.yahoo.com>
Content-Transfer-Encoding: 8bit
Subject: Re: Help needed to add support for the card Compro VideoMate X50
	(CX88/XC2028)
Reply-To: climarino@yahoo.com.ar
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I have more information.

This is the dump of 'RegSpy.exe', a Win32 program that lists the registers of CX88 based cards. 

CX2388x Card [0]:

Vendor ID:           0x14f1
Device ID:           0x8800
Subsystem ID:        0xe000185b

=================================================================================

CX2388x Card - Register Dump:
AUD_INIT:                        00000001   (00000000 00000000 00000000 00000001)                 
AUD_INIT_LD:                     00000001   (00000000 00000000 00000000 00000001)                 
AUD_SOFT_RESET:                  00000000   (00000000 00000000 00000000 00000000)                 
AUD_I2SINPUTCNTL:                00000004   (00000000 00000000 00000000 00000100)                 
AUD_BAUDRATE:                    00000000   (00000000 00000000 00000000 00000000)                 
AUD_I2SOUTPUTCNTL:               00000000   (00000000 00000000 00000000 00000000)                 
AAGC_HYST:                       0000001a   (00000000 00000000 00000000 00011010)                 
AAGC_GAIN:                       00000000   (00000000 00000000 00000000 00000000)                 
AAGC_DEF:                        00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR1_0_SEL:                  00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR1_0_SHIFT:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR1_1_SEL:                  00000002   (00000000 00000000 00000000 00000010)                 
AUD_IIR1_1_SHIFT:                00000007   (00000000 00000000 00000000 00000111)                 
AUD_IIR1_2_SEL:                  00000001   (00000000 00000000 00000000 00000001)                 
AUD_IIR1_2_SHIFT:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR1_3_SEL:                  00000004   (00000000 00000000 00000000 00000100)                 
AUD_IIR1_3_SHIFT:                00000007   (00000000 00000000 00000000 00000111)                 
AUD_IIR1_4_SEL:                  00000021   (00000000 00000000 00000000 00100001)                 
AUD_IIR1_4_SHIFT:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR1_5_SEL:                  00000007   (00000000 00000000 00000000 00000111)                 
AUD_IIR1_5_SHIFT:                00000007   (00000000 00000000 00000000 00000111)                 
AUD_IIR2_0_SEL:                  00000009   (00000000 00000000 00000000 00001001)                 
AUD_IIR2_0_SHIFT:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR2_1_SEL:                  0000001c   (00000000 00000000 00000000 00011100)                 
AUD_IIR2_1_SHIFT:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR2_2_SEL:                  00000020   (00000000 00000000 00000000 00100000)                 
AUD_IIR2_2_SHIFT:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR2_3_SEL:                  0000001f   (00000000 00000000 00000000 00011111)                 
AUD_IIR2_3_SHIFT:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR3_0_SEL:                  00000016   (00000000 00000000 00000000 00010110)                 
AUD_IIR3_0_SHIFT:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR3_1_SEL:                  00000018   (00000000 00000000 00000000 00011000)                 
AUD_IIR3_1_SHIFT:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR3_2_SEL:                  00000018   (00000000 00000000 00000000 00011000)                 
AUD_IIR3_2_SHIFT:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_IIR4_0_SEL:                  0000000b   (00000000 00000000 00000000 00001011)                 
AUD_IIR4_0_SHIFT:                00000006   (00000000 00000000 00000000 00000110)                 
AUD_IIR4_1_SEL:                  0000000d   (00000000 00000000 00000000 00001101)                 
AUD_IIR4_1_SHIFT:                00000006   (00000000 00000000 00000000 00000110)                 
AUD_IIR4_2_SEL:                  0000000b   (00000000 00000000 00000000 00001011)                 
AUD_IIR4_2_SHIFT:                00000006   (00000000 00000000 00000000 00000110)                 
AUD_IIR4_0_CA0:                  00006349   (00000000 00000000 01100011 01001001)                 
AUD_IIR4_0_CA1:                  00006f27   (00000000 00000000 01101111 00100111)                 
AUD_IIR4_0_CA2:                  0000e7a3   (00000000 00000000 11100111 10100011)                 
AUD_IIR4_0_CB0:                  00005653   (00000000 00000000 01010110 01010011)                 
AUD_IIR4_0_CB1:                  0000cf97   (00000000 00000000 11001111 10010111)                 
AUD_IIR4_1_CA0:                  00006349   (00000000 00000000 01100011 01001001)                 
AUD_IIR4_1_CA1:                  00006f27   (00000000 00000000 01101111 00100111)                 
AUD_IIR4_1_CA2:                  0000e7a3   (00000000 00000000 11100111 10100011)                 
AUD_IIR4_1_CB0:                  00005653   (00000000 00000000 01010110 01010011)                 
AUD_IIR4_1_CB1:                  0000cf97   (00000000 00000000 11001111 10010111)                 
AUD_IIR4_2_CA0:                  00007834   (00000000 00000000 01111000 00110100)                 
AUD_IIR4_2_CA1:                  00007b3d   (00000000 00000000 01111011 00111101)                 
AUD_IIR4_2_CA2:                  0000fabd   (00000000 00000000 11111010 10111101)                 
AUD_IIR4_2_CB0:                  000073ba   (00000000 00000000 01110011 10111010)                 
AUD_IIR4_2_CB1:                  0000f340   (00000000 00000000 11110011 01000000)                 
AUD_HP_MD_IIR4_1:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_HP_PROG_IIR4_1:              00000000   (00000000 00000000 00000000 00000000)                 
AUD_FM_MODE_ENABLE:              00000000   (00000000 00000000 00000000 00000000)                 
AUD_POLY0_DDS_CONSTANT:          0012010c   (00000000 00010010 00000001 00001100)                 
AUD_DN0_FREQ:                    0000283b   (00000000 00000000 00101000 00111011)                 
AUD_DN1_FREQ:                    00004000   (00000000 00000000 01000000 00000000)                 
AUD_DN1_FREQ_SHIFT:              00000000   (00000000 00000000 00000000 00000000)                 
AUD_DN1_AFC:                     00000000   (00000000 00000000 00000000 00000000)                 
AUD_DN1_SRC_SEL:                 00000009   (00000000 00000000 00000000 00001001)                 
AUD_DN1_SHFT:                    00000000   (00000000 00000000 00000000 00000000)                 
AUD_DN2_FREQ:                    00003000   (00000000 00000000 00110000 00000000)                 
AUD_DN2_FREQ_SHIFT:              00000000   (00000000 00000000 00000000 00000000)                 
AUD_DN2_AFC:                     00000002   (00000000 00000000 00000000 00000010)                 
AUD_DN2_SRC_SEL:                 00000008   (00000000 00000000 00000000 00001000)                 
AUD_DN2_SHFT:                    00000000   (00000000 00000000 00000000 00000000)                 
AUD_CRDC0_SRC_SEL:               000000c5   (00000000 00000000 00000000 11000101)                 
AUD_CRDC0_SHIFT:                 00000000   (00000000 00000000 00000000 00000000)                 
AUD_CORDIC_SHIFT_0:              00000006   (00000000 00000000 00000000 00000110)                 
AUD_CRDC1_SRC_SEL:               000003ce   (00000000 00000000 00000011 11001110)                 
AUD_CRDC1_SHIFT:                 00000000   (00000000 00000000 00000000 00000000)                 
AUD_CORDIC_SHIFT_1:              00000007   (00000000 00000000 00000000 00000111)                 
AUD_DCOC_0_SRC:                  0000001a   (00000000 00000000 00000000 00011010)                 
AUD_DCOC0_SHIFT:                 00000000   (00000000 00000000 00000000 00000000)                 
AUD_DCOC_0_SHIFT_IN0:            0000000a   (00000000 00000000 00000000 00001010)                 
AUD_DCOC_0_SHIFT_IN1:            00000008   (00000000 00000000 00000000 00001000)                 
AUD_DCOC_1_SRC:                  0000001b   (00000000 00000000 00000000 00011011)                 
AUD_DCOC1_SHIFT:                 00000000   (00000000 00000000 00000000 00000000)                 
AUD_DCOC_1_SHIFT_IN0:            0000000a   (00000000 00000000 00000000 00001010)                 
AUD_DCOC_1_SHIFT_IN1:            00000008   (00000000 00000000 00000000 00001000)                 
AUD_DCOC_2_SRC:                  0000001b   (00000000 00000000 00000000 00011011)                 
AUD_DCOC2_SHIFT:                 00000000   (00000000 00000000 00000000 00000000)                 
AUD_DCOC_2_SHIFT_IN0:            00000006   (00000000 00000000 00000000 00000110)                 
AUD_DCOC_2_SHIFT_IN1:            00000008   (00000000 00000000 00000000 00001000)                 
AUD_DCOC_PASS_IN:                00000003   (00000000 00000000 00000000 00000011)                 
AUD_PDET_SRC:                    00000019   (00000000 00000000 00000000 00011001)                 
AUD_PDET_SHIFT:                  00000002   (00000000 00000000 00000000 00000010)                 
AUD_PILOT_BQD_1_K0:              00001525   (00000000 00000000 00010101 00100101)                 
AUD_PILOT_BQD_1_K1:              007f8d4f   (00000000 01111111 10001101 01001111)                 
AUD_PILOT_BQD_1_K2:              ff80dd2f   (11111111 10000000 11011101 00101111)                 
AUD_PILOT_BQD_1_K3:              ffc071de   (11111111 11000000 01110001 11011110)                 
AUD_PILOT_BQD_1_K4:              00400000   (00000000 01000000 00000000 00000000)                 
AUD_PILOT_BQD_2_K0:              0000a3d7   (00000000 00000000 10100011 11010111)                 
AUD_PILOT_BQD_2_K1:              003f8dcd   (00000000 00111111 10001101 11001101)                 
AUD_PILOT_BQD_2_K2:              00400000   (00000000 01000000 00000000 00000000)                 
AUD_PILOT_BQD_2_K3:              00000000   (00000000 00000000 00000000 00000000)                 
AUD_PILOT_BQD_2_K4:              00000000   (00000000 00000000 00000000 00000000)                 
AUD_THR_FR:                      00000001   (00000000 00000000 00000000 00000001)                 
AUD_X_PROG:                      00000008   (00000000 00000000 00000000 00001000)                 
AUD_Y_PROG:                      02000000   (00000010 00000000 00000000 00000000)                 
AUD_HARMONIC_MULT:               00000002   (00000000 00000000 00000000 00000010)                 
AUD_C1_UP_THR:                   00001111   (00000000 00000000 00010001 00010001)                 
AUD_C1_LO_THR:                   00000f0f   (00000000 00000000 00001111 00001111)                 
AUD_C2_UP_THR:                   00000000   (00000000 00000000 00000000 00000000)                 
AUD_C2_LO_THR:                   00000000   (00000000 00000000 00000000 00000000)                 
AUD_PLL_EN:                      00000003   (00000000 00000000 00000000 00000011)                 
AUD_PLL_SRC:                     00000019   (00000000 00000000 00000000 00011001)                 
AUD_PLL_SHIFT:                   00000002   (00000000 00000000 00000000 00000010)                 
AUD_PLL_IF_SEL:                  00000009   (00000000 00000000 00000000 00001001)                 
AUD_PLL_IF_SHIFT:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_BIQUAD_PLL_K0:               00008a68   (00000000 00000000 10001010 01101000)                 
AUD_BIQUAD_PLL_K1:               00092305   (00000000 00001001 00100011 00000101)                 
AUD_BIQUAD_PLL_K2:               00100000   (00000000 00010000 00000000 00000000)                 
AUD_BIQUAD_PLL_K3:               00fcb368   (00000000 11111100 10110011 01101000)                 
AUD_BIQUAD_PLL_K4:               00080000   (00000000 00001000 00000000 00000000)                 
AUD_DEEMPH0_SRC_SEL:             00000011   (00000000 00000000 00000000 00010001)                 
AUD_DEEMPH0_SHIFT:               00000000   (00000000 00000000 00000000 00000000)                 
AUD_DEEMPH0_G0:                  00001323   (00000000 00000000 00010011 00100011)                 
AUD_DEEMPH0_A0:                  000067a0   (00000000 00000000 01100111 10100000)                 
AUD_DEEMPH0_B0:                  00000e20   (00000000 00000000 00001110 00100000)                 
AUD_DEEMPH0_A1:                  0003c280   (00000000 00000011 11000010 10000000)                 
AUD_DEEMPH0_B1:                  00003d80   (00000000 00000000 00111101 10000000)                 
AUD_DEEMPH1_SRC_SEL:             00000013   (00000000 00000000 00000000 00010011)                 
AUD_DEEMPH1_SHIFT:               00000000   (00000000 00000000 00000000 00000000)                 
AUD_DEEMPH1_G0:                  00001323   (00000000 00000000 00010011 00100011)                 
AUD_DEEMPH1_A0:                  000067a0   (00000000 00000000 01100111 10100000)                 
AUD_DEEMPH1_B0:                  00000e20   (00000000 00000000 00001110 00100000)                 
AUD_DEEMPH1_A1:                  0003c280   (00000000 00000011 11000010 10000000)                 
AUD_DEEMPH1_B1:                  00003d80   (00000000 00000000 00111101 10000000)                 
AUD_OUT0_SEL:                    0000003f   (00000000 00000000 00000000 00111111)                 
AUD_OUT0_SHIFT:                  00000000   (00000000 00000000 00000000 00000000)                 
AUD_OUT1_SEL:                    00000013   (00000000 00000000 00000000 00010011)                 
AUD_OUT1_SHIFT:                  00000000   (00000000 00000000 00000000 00000000)                 
AUD_RDSI_SEL:                    00000007   (00000000 00000000 00000000 00000111)                 
AUD_RDSI_SHIFT:                  00000000   (00000000 00000000 00000000 00000000)                 
AUD_RDSQ_SEL:                    00000007   (00000000 00000000 00000000 00000111)                 
AUD_RDSQ_SHIFT:                  00000000   (00000000 00000000 00000000 00000000)                 
AUD_DBX_IN_GAIN:                 00004734   (00000000 00000000 01000111 00110100)                 
AUD_DBX_WBE_GAIN:                00004640   (00000000 00000000 01000110 01000000)                 
AUD_DBX_SE_GAIN:                 00008d31   (00000000 00000000 10001101 00110001)                 
AUD_DBX_RMS_WBE:                 00000002   (00000000 00000000 00000000 00000010)                 
AUD_DBX_RMS_SE:                  00000023   (00000000 00000000 00000000 00100011)                 
AUD_DBX_SE_BYPASS:               00000000   (00000000 00000000 00000000 00000000)                 
AUD_FAWDETCTL:                   00000678   (00000000 00000000 00000110 01111000)                 
AUD_FAWDETWINCTL:                000012d6   (00000000 00000000 00010010 11010110)                 
AUD_DEEMPHGAIN_R:                00010000   (00000000 00000001 00000000 00000000)                 
AUD_DEEMPHNUMER1_R:              00000000   (00000000 00000000 00000000 00000000)                 
AUD_DEEMPHNUMER2_R:              00000000   (00000000 00000000 00000000 00000000)                 
AUD_DEEMPHDENOM1_R:              00000000   (00000000 00000000 00000000 00000000)                 
AUD_DEEMPHDENOM2_R:              00000000   (00000000 00000000 00000000 00000000)                 
AUD_ERRLOGPERIOD_R:              000003e8   (00000000 00000000 00000011 11101000)                 
AUD_ERRINTRPTTHSHLD1_R:          00000fff   (00000000 00000000 00001111 11111111)                 
AUD_ERRINTRPTTHSHLD2_R:          00000fff   (00000000 00000000 00001111 11111111)                 
AUD_ERRINTRPTTHSHLD3_R:          00000fff   (00000000 00000000 00001111 11111111)                 
AUD_NICAM_STATUS1:               0000841f   (00000000 00000000 10000100 00011111)                 
AUD_NICAM_STATUS2:               0000000d   (00000000 00000000 00000000 00001101)                 
AUD_ERRLOG1:                     00000000   (00000000 00000000 00000000 00000000)                 
AUD_ERRLOG2:                     00000000   (00000000 00000000 00000000 00000000)                 
AUD_ERRLOG3:                     00000000   (00000000 00000000 00000000 00000000)                 
AUD_DAC_BYPASS_L:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_DAC_BYPASS_R:                00000000   (00000000 00000000 00000000 00000000)                 
AUD_DAC_BYPASS_CTL:              00000000   (00000000 00000000 00000000 00000000)                 
AUD_CTL:                         00001203   (00000000 00000000 00010010 00000011)                 
AUD_STATUS:                      0000fff2   (00000000 00000000 11111111 11110010)                 
AUD_VOL_CTL:                     0000000f   (00000000 00000000 00000000 00001111)                 
AUD_BAL_CTL:                     00000000   (00000000 00000000 00000000 00000000)                 
AUD_START_TIMER:                 00000000   (00000000 00000000 00000000 00000000)                 
AUD_MODE_CHG_TIMER:              000001b5   (00000000 00000000 00000001 10110101)                 
AUD_POLYPH80SCALEFAC:            00000003   (00000000 00000000 00000000 00000011)                 
AUD_DMD_RA_DDS:                  00c33ef7   (00000000 11000011 00111110 11110111)                 
AUD_I2S_RA_DDS:                  00400000   (00000000 01000000 00000000 00000000)                 
AUD_RATE_THRES_DMD:              000000b4   (00000000 00000000 00000000 10110100)                 
AUD_RATE_THRES_I2S:              00000005   (00000000 00000000 00000000 00000101)                 
AUD_RATE_ADJ1:                   00000100   (00000000 00000000 00000001 00000000)                 
AUD_RATE_ADJ2:                   00000200   (00000000 00000000 00000010 00000000)                 
AUD_RATE_ADJ3:                   00000300   (00000000 00000000 00000011 00000000)                 
AUD_RATE_ADJ4:                   00000400   (00000000 00000000 00000100 00000000)                 
AUD_RATE_ADJ5:                   00000500   (00000000 00000000 00000101 00000000)                 
AUD_APB_IN_RATE_ADJ:             00000000   (00000000 00000000 00000000 00000000)                 
AUD_PHASE_FIX_CTL:               00000020   (00000000 00000000 00000000 00100000)                 
AUD_PLL_PRESCALE:                00000002   (00000000 00000000 00000000 00000010)                 
AUD_PLL_DDS:                     00000000   (00000000 00000000 00000000 00000000)                 
AUD_PLL_INT:                     0000001e   (00000000 00000000 00000000 00011110)                 
AUD_PLL_FRAC:                    0000e542   (00000000 00000000 11100101 01000010)                 
AUD_PLL_JTAG:                    00000000   (00000000 00000000 00000000 00000000)                 
AUD_PLL_SPMP:                    00000004   (00000000 00000000 00000000 00000100)                 
AUD_AFE_12DB_EN:                 00000001   (00000000 00000000 00000000 00000001)                 
AUD_PDF_DDS_CNST_BYTE2:          48         (01001000)                                            
AUD_PDF_DDS_CNST_BYTE1:          3d         (00111101)                                            
AUD_PDF_DDS_CNST_BYTE0:          f5         (11110101)                                            
AUD_QAM_MODE:                    05         (00000101)                                            
AUD_PHACC_FREQ_8MSB:             3a         (00111010)                                            
AUD_PHACC_FREQ_8LSB:             4a         (01001010)                                            
MO_GP0_IO:                       000004fb   (00000000 00000000 00000100 11111011)                 
MO_GP1_IO:                       000000ff   (00000000 00000000 00000000 11111111)                 
MO_GP2_IO:                       00001ef3   (00000000 00000000 00011110 11110011)                 
MO_GP3_IO:                       00000000   (00000000 00000000 00000000 00000000)                 

end of dump

And this is in the INF of the driver provided by the manufacturer:

HKR,"DriverData","TunerType",0x00010001, 0x1A, 0x00, 0x00, 0x00
HKR,"DriverData","TunerI2CAddress",0x00010001, 0xC2, 0x00, 0x00, 0x00
HKR,"DriverData","TunerResetGPIO",0x00010001, 0x0F,0x00,0x00,0x00


--- El sáb 16-ago-08, Carlos Limarino <climarino@yahoo.com.ar> escribió:

> De: Carlos Limarino <climarino@yahoo.com.ar>
> Asunto: Help needed to add support for the card Compro VideoMate X50 (CX88/XC2028)
> Para: video4linux-list@redhat.com
> Fecha: sábado, 16 de agosto de 2008, 10:54 pm
> Hi, 
> 
> I'm trying to add support for a CX23880 based card that
> uses the Xceive 2028 tuner. Support for this tuner was
> recently added to the kernel, I tried using similar cards
> already supported by the driver. The results were:
> 
> using card=62 (PowerColor RA330)
> 
> cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
> ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [APC2] ->
> GSI 17 (level, low) -> IRQ 17
> cx88[0]: subsystem: 185b:e000, board: PowerColor RA330
> [card=62,insmod option]
> cx88[0]: TV tuner type 71, Radio tuner type 0
> tuner' 2-0061: chip found @ 0xc2 (cx88[0])
> xc2028 2-0061: creating new instance
> xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
> cx88 IR (PowerColor RA330): unknown key: key=0x3f raw=0x3f
> down=1
> cx88 IR (PowerColor RA330): unknown key: key=0x3f raw=0x3f
> down=0
> input: cx88 IR (PowerColor RA330) as
> /devices/pci0000:00/0000:00:10.0/0000:02:09.0/input/input6
> cx88[0]/0: found at 0000:02:09.0, rev: 5, irq: 17, latency:
> 32, mmio: 0xfc000000
> cx88[0]/0: registered device video0 [v4l2]
> cx88[0]/0: registered device vbi0
> cx88[0]/0: registered device radio0
> firmware: requesting xc3028-v27.fw
> xc2028 2-0061: Loading 80 firmware images from
> xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> cx88[0]: Calling XC2028/3028 callback
> xc2028 2-0061: Loading firmware for type=BASE (1), id
> 0000000000000000.
> cx88[0]: Calling XC2028/3028 callback
> xc2028 2-0061: i2c output error: rc = -121 (should be 64)
> xc2028 2-0061: -121 returned from send
> xc2028 2-0061: Error -22 while loading base firmware
> cx88[0]: Calling XC2028/3028 callback
> xc2028 2-0061: Loading firmware for type=BASE (1), id
> 0000000000000000.
> cx88[0]: Calling XC2028/3028 callback
> xc2028 2-0061: i2c output error: rc = -121 (should be 64)
> xc2028 2-0061: -121 returned from send
> xc2028 2-0061: Error -22 while loading base firmware
> cx88[0]: Calling XC2028/3028 callback
> xc2028 2-0061: Loading firmware for type=BASE FM (401), id
> 0000000000000000.
> cx88[0]: Calling XC2028/3028 callback
> xc2028 2-0061: Loading firmware for type=FM (400), id
> 0000000000000000.
> cx88[0]: Calling XC2028/3028 callback
> 
> using card=61 (Winfast TV2000 XP Global)
> 
> cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [APC2] ->
> GSI 17 (level, low) -> IRQ 17
> cx88[0]: subsystem: 185b:e000, board: Winfast TV2000 XP
> Global [card=61,insmod option]
> cx88[0]: TV tuner type 71, Radio tuner type 0
> tuner' 2-0061: chip found @ 0xc2 (cx88[0])
> xc2028 2-0061: creating new instance
> xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
> cx88[0]/0: found at 0000:02:09.0, rev: 5, irq: 17, latency:
> 32, mmio: 0xfc000000
> cx88[0]/0: registered device video0 [v4l2]
> cx88[0]/0: registered device vbi0
> cx88[0]/0: registered device radio0
> firmware: requesting xc3028-v27.fw
> xc2028 2-0061: Loading 80 firmware images from
> xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> cx88[0]: Calling XC2028/3028 callback
> xc2028 2-0061: Loading firmware for type=BASE MTS (5), id
> 0000000000000000.
> cx88[0]: Calling XC2028/3028 callback
> i2c-adapter i2c-2: sendbytes: NAK bailout.
> xc2028 2-0061: i2c output error: rc = -5 (should be 64)
> xc2028 2-0061: -5 returned from send
> xc2028 2-0061: Error -22 while loading base firmware
> cx88[0]: Calling XC2028/3028 callback
> xc2028 2-0061: Loading firmware for type=BASE MTS (5), id
> 0000000000000000.
> cx88[0]: Calling XC2028/3028 callback
> i2c-adapter i2c-2: sendbytes: NAK bailout.
> xc2028 2-0061: i2c output error: rc = -5 (should be 64)
> xc2028 2-0061: -5 returned from send
> xc2028 2-0061: Error -22 while loading base firmware
> cx88[0]: Calling XC2028/3028 callback
> xc2028 2-0061: Loading firmware for type=BASE FM (401), id
> 0000000000000000.
> cx88[0]: Calling XC2028/3028 callback
> i2c-adapter i2c-2: sendbytes: NAK bailout.
> xc2028 2-0061: i2c output error: rc = -5 (should be 64)
> xc2028 2-0061: -5 returned from send
> xc2028 2-0061: Error -22 while loading base firmware
> cx88[0]: Calling XC2028/3028 callback
> xc2028 2-0061: Loading firmware for type=BASE FM (401), id
> 0000000000000000.
> cx88[0]: Calling XC2028/3028 callback
> i2c-adapter i2c-2: sendbytes: NAK bailout.
> xc2028 2-0061: i2c output error: rc = -5 (should be 64)
> xc2028 2-0061: -5 returned from send
> xc2028 2-0061: Error -22 while loading base firmware
> 
> Developers of the CX18 driver found a similar problem with
> some cards, it seems that the pin that is used to reset the
> tuner changes from card to card:
> 
> http://www.gossamer-threads.com/lists/ivtv/devel/38594
> 
> Since I don't have much knowledge about driver
> programming, I can't find something similar to
> 'xceive_pin' to change & test. I would greatly
> appreciate any help with this.
> 
> Thank you!
> 
> 
> 
>       Yahoo! Cocina
> Recetas prácticas y comida saludable
> http://ar.mujer.yahoo.com/cocina/
> 
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


      Yahoo! Cocina
Recetas prácticas y comida saludable
http://ar.mujer.yahoo.com/cocina/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
