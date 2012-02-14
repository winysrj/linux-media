Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:28215 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab2BNVsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:25 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 09/22] mt2063: move global setting into a header file
Date: Tue, 14 Feb 2012 22:47:33 +0100
Message-Id: <1329256066-8844-9-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c      |  385 +----------------------------
 drivers/media/common/tuners/mt2063_priv.h |  234 +++++++++++++++++
 2 files changed, 239 insertions(+), 380 deletions(-)
 create mode 100644 drivers/media/common/tuners/mt2063_priv.h

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index c3b5108..ac8a0dc 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -27,6 +27,7 @@
 #include <linux/videodev2.h>
 
 #include "mt2063.h"
+#include "mt2063_priv.h"
 
 static unsigned int debug;
 module_param(debug, int, 0644);
@@ -46,121 +47,6 @@ if (debug >= level)						\
 	printk(KERN_DEBUG "mt2063 %s: " fmt, __func__, ##arg);	\
 } while (0)
 
-/*
- * Parameter for function MT2063_SetPowerMask that specifies the power down
- * of various sections of the MT2063.
- */
-enum MT2063_Mask_Bits {
-	MT2063_REG_SD = 0x0040,		/* Shutdown regulator                 */
-	MT2063_SRO_SD = 0x0020,		/* Shutdown SRO                       */
-	MT2063_AFC_SD = 0x0010,		/* Shutdown AFC A/D                   */
-	MT2063_PD_SD = 0x0002,		/* Enable power detector shutdown     */
-	MT2063_PDADC_SD = 0x0001,	/* Enable power detector A/D shutdown */
-	MT2063_VCO_SD = 0x8000,		/* Enable VCO shutdown                */
-	MT2063_LTX_SD = 0x4000,		/* Enable LTX shutdown                */
-	MT2063_LT1_SD = 0x2000,		/* Enable LT1 shutdown                */
-	MT2063_LNA_SD = 0x1000,		/* Enable LNA shutdown                */
-	MT2063_UPC_SD = 0x0800,		/* Enable upconverter shutdown        */
-	MT2063_DNC_SD = 0x0400,		/* Enable downconverter shutdown      */
-	MT2063_VGA_SD = 0x0200,		/* Enable VGA shutdown                */
-	MT2063_AMP_SD = 0x0100,		/* Enable AMP shutdown                */
-	MT2063_ALL_SD = 0xFF73,		/* All shutdown bits for this tuner   */
-	MT2063_NONE_SD = 0x0000		/* No shutdown bits                   */
-};
-
-/*
- *  Two-wire serial bus subaddresses of the tuner registers.
- *  Also known as the tuner's register addresses.
- */
-enum MT2063_Register_Offsets {
-	MT2063_REG_PART_REV = 0,	/*  0x00: Part/Rev Code         */
-	MT2063_REG_LO1CQ_1,		/*  0x01: LO1C Queued Byte 1    */
-	MT2063_REG_LO1CQ_2,		/*  0x02: LO1C Queued Byte 2    */
-	MT2063_REG_LO2CQ_1,		/*  0x03: LO2C Queued Byte 1    */
-	MT2063_REG_LO2CQ_2,		/*  0x04: LO2C Queued Byte 2    */
-	MT2063_REG_LO2CQ_3,		/*  0x05: LO2C Queued Byte 3    */
-	MT2063_REG_RSVD_06,		/*  0x06: Reserved              */
-	MT2063_REG_LO_STATUS,		/*  0x07: LO Status             */
-	MT2063_REG_FIFFC,		/*  0x08: FIFF Center           */
-	MT2063_REG_CLEARTUNE,		/*  0x09: ClearTune Filter      */
-	MT2063_REG_ADC_OUT,		/*  0x0A: ADC_OUT               */
-	MT2063_REG_LO1C_1,		/*  0x0B: LO1C Byte 1           */
-	MT2063_REG_LO1C_2,		/*  0x0C: LO1C Byte 2           */
-	MT2063_REG_LO2C_1,		/*  0x0D: LO2C Byte 1           */
-	MT2063_REG_LO2C_2,		/*  0x0E: LO2C Byte 2           */
-	MT2063_REG_LO2C_3,		/*  0x0F: LO2C Byte 3           */
-	MT2063_REG_RSVD_10,		/*  0x10: Reserved              */
-	MT2063_REG_PWR_1,		/*  0x11: PWR Byte 1            */
-	MT2063_REG_PWR_2,		/*  0x12: PWR Byte 2            */
-	MT2063_REG_TEMP_STATUS,		/*  0x13: Temp Status           */
-	MT2063_REG_XO_STATUS,		/*  0x14: Crystal Status        */
-	MT2063_REG_RF_STATUS,		/*  0x15: RF Attn Status        */
-	MT2063_REG_FIF_STATUS,		/*  0x16: FIF Attn Status       */
-	MT2063_REG_LNA_OV,		/*  0x17: LNA Attn Override     */
-	MT2063_REG_RF_OV,		/*  0x18: RF Attn Override      */
-	MT2063_REG_FIF_OV,		/*  0x19: FIF Attn Override     */
-	MT2063_REG_LNA_TGT,		/*  0x1A: Reserved              */
-	MT2063_REG_PD1_TGT,		/*  0x1B: Pwr Det 1 Target      */
-	MT2063_REG_PD2_TGT,		/*  0x1C: Pwr Det 2 Target      */
-	MT2063_REG_RSVD_1D,		/*  0x1D: Reserved              */
-	MT2063_REG_RSVD_1E,		/*  0x1E: Reserved              */
-	MT2063_REG_RSVD_1F,		/*  0x1F: Reserved              */
-	MT2063_REG_RSVD_20,		/*  0x20: Reserved              */
-	MT2063_REG_BYP_CTRL,		/*  0x21: Bypass Control        */
-	MT2063_REG_RSVD_22,		/*  0x22: Reserved              */
-	MT2063_REG_RSVD_23,		/*  0x23: Reserved              */
-	MT2063_REG_RSVD_24,		/*  0x24: Reserved              */
-	MT2063_REG_RSVD_25,		/*  0x25: Reserved              */
-	MT2063_REG_RSVD_26,		/*  0x26: Reserved              */
-	MT2063_REG_RSVD_27,		/*  0x27: Reserved              */
-	MT2063_REG_FIFF_CTRL,		/*  0x28: FIFF Control          */
-	MT2063_REG_FIFF_OFFSET,		/*  0x29: FIFF Offset           */
-	MT2063_REG_CTUNE_CTRL,		/*  0x2A: Reserved              */
-	MT2063_REG_CTUNE_OV,		/*  0x2B: Reserved              */
-	MT2063_REG_CTRL_2C,		/*  0x2C: Reserved              */
-	MT2063_REG_FIFF_CTRL2,		/*  0x2D: Fiff Control          */
-	MT2063_REG_RSVD_2E,		/*  0x2E: Reserved              */
-	MT2063_REG_DNC_GAIN,		/*  0x2F: DNC Control           */
-	MT2063_REG_VGA_GAIN,		/*  0x30: VGA Gain Ctrl         */
-	MT2063_REG_RSVD_31,		/*  0x31: Reserved              */
-	MT2063_REG_TEMP_SEL,		/*  0x32: Temperature Selection */
-	MT2063_REG_RSVD_33,		/*  0x33: Reserved              */
-	MT2063_REG_RSVD_34,		/*  0x34: Reserved              */
-	MT2063_REG_RSVD_35,		/*  0x35: Reserved              */
-	MT2063_REG_RSVD_36,		/*  0x36: Reserved              */
-	MT2063_REG_RSVD_37,		/*  0x37: Reserved              */
-	MT2063_REG_RSVD_38,		/*  0x38: Reserved              */
-	MT2063_REG_RSVD_39,		/*  0x39: Reserved              */
-	MT2063_REG_RSVD_3A,		/*  0x3A: Reserved              */
-	MT2063_REG_RSVD_3B,		/*  0x3B: Reserved              */
-	MT2063_REG_RSVD_3C,		/*  0x3C: Reserved              */
-	MT2063_REG_END_REGS
-};
-
-struct mt2063_state {
-	struct i2c_adapter *i2c;
-
-	bool init;
-
-	const struct mt2063_config *config;
-	struct dvb_tuner_ops ops;
-	struct dvb_frontend *frontend;
-	struct tuner_state status;
-
-	u32 frequency;
-	u32 srate;
-	u32 bandwidth;
-	u32 reference;
-
-	u32 tuner_id;
-	struct MT2063_AvoidSpursData_t AS_Data;
-	u32 f_IF1_actual;
-	u32 rcvr_mode;
-	u32 ctfilt_sw;
-	u32 CTFiltMax[31];
-	u32 num_regs;
-	u8 reg[MT2063_REG_END_REGS];
-};
 static int mt2063_write(struct mt2063_state *state, u8 reg, u8 data)
 {
 	int ret;
@@ -270,37 +156,6 @@ static void mt2063_shutdown(struct mt2063_state *state,
 	 *
 	 *
 	 */
-
-/*
- * Constants used by the tuning algorithm
- */
-#define MT2063_REF_FREQ          (16000000UL)	/* Reference oscillator Frequency (in Hz) */
-#define MT2063_IF1_BW            (22000000UL)	/* The IF1 filter bandwidth (in Hz) */
-#define MT2063_TUNE_STEP_SIZE       (50000UL)	/* Tune in steps of 50 kHz */
-#define MT2063_SPUR_STEP_HZ        (250000UL)	/* Step size (in Hz) to move IF1 when avoiding spurs */
-#define MT2063_ZIF_BW             (2000000UL)	/* Zero-IF spur-free bandwidth (in Hz) */
-#define MT2063_MAX_HARMONICS_1         (15UL)	/* Highest intra-tuner LO Spur Harmonic to be avoided */
-#define MT2063_MAX_HARMONICS_2          (5UL)	/* Highest inter-tuner LO Spur Harmonic to be avoided */
-#define MT2063_MIN_LO_SEP         (1000000UL)	/* Minimum inter-tuner LO frequency separation */
-#define MT2063_LO1_FRACN_AVOID          (0UL)	/* LO1 FracN numerator avoid region (in Hz) */
-#define MT2063_LO2_FRACN_AVOID     (199999UL)	/* LO2 FracN numerator avoid region (in Hz) */
-#define MT2063_MIN_FIN_FREQ      (44000000UL)	/* Minimum input frequency (in Hz) */
-#define MT2063_MAX_FIN_FREQ    (1100000000UL)	/* Maximum input frequency (in Hz) */
-#define MT2063_MIN_FOUT_FREQ     (36000000UL)	/* Minimum output frequency (in Hz) */
-#define MT2063_MAX_FOUT_FREQ     (57000000UL)	/* Maximum output frequency (in Hz) */
-#define MT2063_MIN_DNC_FREQ    (1293000000UL)	/* Minimum LO2 frequency (in Hz) */
-#define MT2063_MAX_DNC_FREQ    (1614000000UL)	/* Maximum LO2 frequency (in Hz) */
-#define MT2063_MIN_UPC_FREQ    (1396000000UL)	/* Minimum LO1 frequency (in Hz) */
-#define MT2063_MAX_UPC_FREQ    (2750000000UL)	/* Maximum LO1 frequency (in Hz) */
-
-/*
- *  Define the supported Part/Rev codes for the MT2063
- */
-#define MT2063_B0       (0x9B)
-#define MT2063_B1       (0x9C)
-#define MT2063_B2       (0x9D)
-#define MT2063_B3       (0x9E)
-
 /**
  * mt2063_lockStatus - Checks to see if LO1 and LO2 are locked
  *
@@ -344,76 +199,6 @@ static unsigned int mt2063_lockStatus(struct mt2063_state *state)
 	return 0;
 }
 
-/*
- *  Constants for setting receiver modes.
- *  (6 modes defined at this time, enumerated by mt2063_delivery_sys)
- *  (DNC1GC & DNC2GC are the values, which are used, when the specific
- *   DNC Output is selected, the other is always off)
- *
- *                enum mt2063_delivery_sys
- * -------------+----------------------------------------------
- * Mode 0 :     | MT2063_CABLE_QAM
- * Mode 1 :     | MT2063_CABLE_ANALOG
- * Mode 2 :     | MT2063_OFFAIR_COFDM
- * Mode 3 :     | MT2063_OFFAIR_COFDM_SAWLESS
- * Mode 4 :     | MT2063_OFFAIR_ANALOG
- * Mode 5 :     | MT2063_OFFAIR_8VSB
- * --------------+----------------------------------------------
- *
- *                |<----------   Mode  -------------->|
- *    Reg Field   |  0  |  1  |  2  |  3  |  4  |  5  |
- *    ------------+-----+-----+-----+-----+-----+-----+
- *    RFAGCen     | OFF | OFF | OFF | OFF | OFF | OFF
- *    LNARin      |   0 |   0 |   3 |   3 |  3  |  3
- *    FIFFQen     |   1 |   1 |   1 |   1 |  1  |  1
- *    FIFFq       |   0 |   0 |   0 |   0 |  0  |  0
- *    DNC1gc      |   0 |   0 |   0 |   0 |  0  |  0
- *    DNC2gc      |   0 |   0 |   0 |   0 |  0  |  0
- *    GCU Auto    |   1 |   1 |   1 |   1 |  1  |  1
- *    LNA max Atn |  31 |  31 |  31 |  31 | 31  | 31
- *    LNA Target  |  44 |  43 |  43 |  43 | 43  | 43
- *    ign  RF Ovl |   0 |   0 |   0 |   0 |  0  |  0
- *    RF  max Atn |  31 |  31 |  31 |  31 | 31  | 31
- *    PD1 Target  |  36 |  36 |  38 |  38 | 36  | 38
- *    ign FIF Ovl |   0 |   0 |   0 |   0 |  0  |  0
- *    FIF max Atn |   5 |   5 |   5 |   5 |  5  |  5
- *    PD2 Target  |  40 |  33 |  42 |  42 | 33  | 42
- */
-
-enum mt2063_delivery_sys {
-	MT2063_CABLE_QAM = 0,
-	MT2063_CABLE_ANALOG,
-	MT2063_OFFAIR_COFDM,
-	MT2063_OFFAIR_COFDM_SAWLESS,
-	MT2063_OFFAIR_ANALOG,
-	MT2063_OFFAIR_8VSB,
-	MT2063_NUM_RCVR_MODES
-};
-
-static const char *mt2063_mode_name[] = {
-	[MT2063_CABLE_QAM]		= "digital cable",
-	[MT2063_CABLE_ANALOG]		= "analog cable",
-	[MT2063_OFFAIR_COFDM]		= "digital offair",
-	[MT2063_OFFAIR_COFDM_SAWLESS]	= "digital offair without SAW",
-	[MT2063_OFFAIR_ANALOG]		= "analog offair",
-	[MT2063_OFFAIR_8VSB]		= "analog offair 8vsb",
-};
-
-static const u8 RFAGCEN[]	= {  0,  0,  0,  0,  0,  0 };
-static const u8 LNARIN[]	= {  0,  0,  3,  3,  3,  3 };
-static const u8 FIFFQEN[]	= {  1,  1,  1,  1,  1,  1 };
-static const u8 FIFFQ[]		= {  0,  0,  0,  0,  0,  0 };
-static const u8 DNC1GC[]	= {  0,  0,  0,  0,  0,  0 };
-static const u8 DNC2GC[]	= {  0,  0,  0,  0,  0,  0 };
-static const u8 ACLNAMAX[]	= { 31, 31, 31, 31, 31, 31 };
-static const u8 LNATGT[]	= { 44, 43, 43, 43, 43, 43 };
-static const u8 RFOVDIS[]	= {  0,  0,  0,  0,  0,  0 };
-static const u8 ACRFMAX[]	= { 31, 31, 31, 31, 31, 31 };
-static const u8 PD1TGT[]	= { 36, 36, 38, 38, 36, 38 };
-static const u8 FIFOVDIS[]	= {  0,  0,  0,  0,  0,  0 };
-static const u8 ACFIFMAX[]	= { 29, 29, 29, 29, 29, 29 };
-static const u8 PD2TGT[]	= { 40, 33, 38, 42, 30, 38 };
-
 {
 
 
@@ -489,10 +274,6 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		}
 	}
 
-	/* DNC1GC & DNC2GC */
-	status |= mt2063_get_dnc_output_enable(state, &longval);
-	status |= mt2063_set_dnc_output_enable(state, longval);
-
 	/* acLNAmax */
 	if (status >= 0) {
 		u8 val = (state->reg[MT2063_REG_LNA_OV] & (u8) ~0x1F) |
@@ -569,79 +350,6 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 	return status;
 }
 
-/*
- * MT2063_ClearPowerMaskBits () - Clears the power-down mask bits for various
- *				  sections of the MT2063
- *
- * @Bits:		Mask bits to be cleared.
- *
- * See definition of MT2063_Mask_Bits type for description
- * of each of the power bits.
- */
-static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state,
-				     enum MT2063_Mask_Bits Bits)
-{
-	u32 status = 0;
-
-	dprintk(2, "\n");
-	Bits = (enum MT2063_Mask_Bits)(Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
-	if ((Bits & 0xFF00) != 0) {
-		state->reg[MT2063_REG_PWR_2] &= ~(u8) (Bits >> 8);
-		status |=
-		    mt2063_write(state,
-				    MT2063_REG_PWR_2,
-				    &state->reg[MT2063_REG_PWR_2], 1);
-	}
-	if ((Bits & 0xFF) != 0) {
-		state->reg[MT2063_REG_PWR_1] &= ~(u8) (Bits & 0xFF);
-		status |=
-		    mt2063_write(state,
-				    MT2063_REG_PWR_1,
-				    &state->reg[MT2063_REG_PWR_1], 1);
-	}
-
-	return status;
-}
-
-/*
- * MT2063_SoftwareShutdown() - Enables or disables software shutdown function.
- *			       When Shutdown is 1, any section whose power
- *			       mask is set will be shutdown.
- */
-static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
-{
-	u32 status;
-
-	dprintk(2, "\n");
-	if (Shutdown == 1)
-		state->reg[MT2063_REG_PWR_1] |= 0x04;
-	else
-		state->reg[MT2063_REG_PWR_1] &= ~0x04;
-
-	status = mt2063_write(state,
-			    MT2063_REG_PWR_1,
-			    &state->reg[MT2063_REG_PWR_1], 1);
-
-	if (Shutdown != 1) {
-		state->reg[MT2063_REG_BYP_CTRL] =
-		    (state->reg[MT2063_REG_BYP_CTRL] & 0x9F) | 0x40;
-		status |=
-		    mt2063_write(state,
-				    MT2063_REG_BYP_CTRL,
-				    &state->reg[MT2063_REG_BYP_CTRL],
-				    1);
-		state->reg[MT2063_REG_BYP_CTRL] =
-		    (state->reg[MT2063_REG_BYP_CTRL] & 0x9F);
-		status |=
-		    mt2063_write(state,
-				    MT2063_REG_BYP_CTRL,
-				    &state->reg[MT2063_REG_BYP_CTRL],
-				    1);
-	}
-
-	return status;
-}
-
 
 
 
@@ -811,69 +519,6 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	return status;
 }
 
-static const u8 MT2063B0_defaults[] = {
-	/* Reg,  Value */
-	0x19, 0x05,
-	0x1B, 0x1D,
-	0x1C, 0x1F,
-	0x1D, 0x0F,
-	0x1E, 0x3F,
-	0x1F, 0x0F,
-	0x20, 0x3F,
-	0x22, 0x21,
-	0x23, 0x3F,
-	0x24, 0x20,
-	0x25, 0x3F,
-	0x27, 0xEE,
-	0x2C, 0x27,	/*  bit at 0x20 is cleared below  */
-	0x30, 0x03,
-	0x2C, 0x07,	/*  bit at 0x20 is cleared here   */
-	0x2D, 0x87,
-	0x2E, 0xAA,
-	0x28, 0xE1,	/*  Set the FIFCrst bit here      */
-	0x28, 0xE0,	/*  Clear the FIFCrst bit here    */
-	0x00
-};
-
-/* writing 0x05 0xf0 sw-resets all registers, so we write only needed changes */
-static const u8 MT2063B1_defaults[] = {
-	/* Reg,  Value */
-	0x05, 0xF0,
-	0x11, 0x10,	/* New Enable AFCsd */
-	0x19, 0x05,
-	0x1A, 0x6C,
-	0x1B, 0x24,
-	0x1C, 0x28,
-	0x1D, 0x8F,
-	0x1E, 0x14,
-	0x1F, 0x8F,
-	0x20, 0x57,
-	0x22, 0x21,	/* New - ver 1.03 */
-	0x23, 0x3C,	/* New - ver 1.10 */
-	0x24, 0x20,	/* New - ver 1.03 */
-	0x2C, 0x24,	/*  bit at 0x20 is cleared below  */
-	0x2D, 0x87,	/*  FIFFQ=0  */
-	0x2F, 0xF3,
-	0x30, 0x0C,	/* New - ver 1.11 */
-	0x31, 0x1B,	/* New - ver 1.11 */
-	0x2C, 0x04,	/*  bit at 0x20 is cleared here  */
-	0x28, 0xE1,	/*  Set the FIFCrst bit here      */
-	0x28, 0xE0,	/*  Clear the FIFCrst bit here    */
-	0x00
-};
-
-/* writing 0x05 0xf0 sw-resets all registers, so we write only needed changes */
-static const u8 MT2063B3_defaults[] = {
-	/* Reg,  Value */
-	0x05, 0xF0,
-	0x19, 0x3D,
-	0x2C, 0x24,	/*  bit at 0x20 is cleared below  */
-	0x2C, 0x04,	/*  bit at 0x20 is cleared here  */
-	0x28, 0xE1,	/*  Set the FIFCrst bit here      */
-	0x28, 0xE0,	/*  Clear the FIFCrst bit here    */
-	0x00
-};
-
 static int mt2063_init(struct dvb_frontend *fe)
 {
 	u32 status;
@@ -993,30 +638,10 @@ static int mt2063_init(struct dvb_frontend *fe)
 	if (status < 0)
 		return status;
 
-	/*  Initialize the tuner state.  */
-	state->tuner_id = state->reg[MT2063_REG_PART_REV];
-	state->AS_Data.f_ref = MT2063_REF_FREQ;
-	state->AS_Data.f_if1_Center = (state->AS_Data.f_ref / 8) *
-				      ((u32) state->reg[MT2063_REG_FIFFC] + 640);
-	state->AS_Data.f_if1_bw = MT2063_IF1_BW;
-	state->AS_Data.f_out = 43750000UL;
-	state->AS_Data.f_out_bw = 6750000UL;
-	state->AS_Data.f_zif_bw = MT2063_ZIF_BW;
-	state->AS_Data.f_LO1_Step = state->AS_Data.f_ref / 64;
-	state->AS_Data.f_LO2_Step = MT2063_TUNE_STEP_SIZE;
-	state->AS_Data.maxH1 = MT2063_MAX_HARMONICS_1;
-	state->AS_Data.maxH2 = MT2063_MAX_HARMONICS_2;
-	state->AS_Data.f_min_LO_Separation = MT2063_MIN_LO_SEP;
-	state->AS_Data.f_if1_Request = state->AS_Data.f_if1_Center;
-	state->AS_Data.f_LO1 = 2181000000UL;
-	state->AS_Data.f_LO2 = 1486249786UL;
-	state->f_IF1_actual = state->AS_Data.f_if1_Center;
-	state->AS_Data.f_in = state->AS_Data.f_LO1 - state->f_IF1_actual;
-	state->AS_Data.f_LO1_FracN_Avoid = MT2063_LO1_FRACN_AVOID;
-	state->AS_Data.f_LO2_FracN_Avoid = MT2063_LO2_FRACN_AVOID;
-	state->num_regs = MT2063_REG_END_REGS;
-	state->AS_Data.avoidDECT = MT2063_AVOID_BOTH;
-	state->ctfilt_sw = 0;
+	/* set DNC1 GC on */
+	mt2063_set_reg_mask(state, MT2063_REG_DNC_GAIN, 0x00, 0x03);
+	/* set DNC2 GC on */
+	mt2063_set_reg_mask(state, MT2063_REG_VGA_GAIN, 0x00, 0x03);
 
 	/*
 	 **   Fetch the FCU osc value and use it and the fRef value to
diff --git a/drivers/media/common/tuners/mt2063_priv.h b/drivers/media/common/tuners/mt2063_priv.h
new file mode 100644
index 0000000..a164bae
--- /dev/null
+++ b/drivers/media/common/tuners/mt2063_priv.h
@@ -0,0 +1,234 @@
+/*
+ * Driver for microtune mt2063 tuner
+ *
+ * Copyright (c) 2012 Stefan Ringel <linuxtv@stefanringel.de>
+ * Copyright (c) 2011 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This driver came from a driver originally written by:
+ *              Henry Wang <Henry.wang@AzureWave.com>
+ * Made publicly available by Terratec, at:
+ *      http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
+ * The original driver's license is GPL, as declared with MODULE_LICENSE()
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include "tuner-i2c.h"
+
+#ifndef __MT2063_PRIV_H__
+#define __MT2063_PRIV_H__
+
+#define MT2063_REG_PART_REV     0x00    /* Part/Rev Code */
+#define MT2063_REG_LO1CQ_1      0x01    /* LO1C Queued Byte 1 */
+#define MT2063_REG_LO1CQ_2      0x02    /* LO1C Queued Byte 2 */
+#define MT2063_REG_LO2CQ_1      0x03    /* LO2C Queued Byte 1 */
+#define MT2063_REG_LO2CQ_2      0x04    /* LO2C Queued Byte 2 */
+#define MT2063_REG_LO2CQ_3      0x05    /* LO2C Queued Byte 3 */
+#define MT2063_REG_RSVD_06      0x06
+#define MT2063_REG_LO_STATUS    0x07    /* LO Status */
+#define MT2063_REG_FIFFC        0x08    /* FIFF Center */
+#define MT2063_REG_CLEARTUNE    0x09    /* ClearTune Filter */
+#define MT2063_REG_ADC_OUT      0x0a    /* ADC Output */
+#define MT2063_REG_LO1C_1       0x0b    /* LO1C Byte 1 */
+#define MT2063_REG_LO1C_2       0x0c    /* LO1C Byte 2 */
+#define MT2063_REG_LO2C_1       0x0d    /* LO2C Byte 1 */
+#define MT2063_REG_LO2C_2       0x0e    /* LO2C Byte 2 */
+#define MT2063_REG_LO2C_3       0x0f    /* LO2C Byte 3 */
+#define MT2063_REG_RSVD_10      0x10
+#define MT2063_REG_PWR_1        0x11    /* Power Byte 1 */
+#define MT2063_REG_PWR_2        0x12    /* Power Byte 2 */
+#define MT2063_REG_TEMP_STATUS  0x13    /* Temperature Status */
+#define MT2063_REG_XO_STATUS    0x14    /* Crystal Status */
+#define MT2063_REG_RF_STATUS    0x15    /* RF Attn Status */
+#define MT2063_REG_FIF_STATUS   0x16    /* FIF Attn Status */
+#define MT2063_REG_LNA_OV       0x17    /* LNA Attn Override */
+#define MT2063_REG_RF_OV        0x18    /* RF Attn Override */
+#define MT2063_REG_FIF_OV       0x19    /* FIF Attn Override */
+#define MT2063_REG_LNA_TGT      0x1a    /* LNA Target */
+#define MT2063_REG_PD1_TGT      0x1b    /* Power Detection 1 Target */
+#define MT2063_REG_PD2_TGT      0x1c    /* Power Detection 2 Target */
+#define MT2063_REG_RSVD_1D      0x1d
+#define MT2063_REG_RSVD_1E      0x1e
+#define MT2063_REG_RSVD_1F      0x1f
+#define MT2063_REG_RSVD_20      0x20
+#define MT2063_REG_BYP_CTRL     0x21    /* Bypass Control */
+#define MT2063_REG_RSVD_22      0x22
+#define MT2063_REG_RSVD_23      0x23
+#define MT2063_REG_RSVD_24      0x24
+#define MT2063_REG_RSVD_25      0x25
+#define MT2063_REG_RSVD_26      0x26
+#define MT2063_REG_RSVD_27      0x27
+#define MT2063_REG_FIFF_CTRL    0x28    /* FIFF Control */
+#define MT2063_REG_FIFF_OFFSET  0x29    /* FIFF Offset */
+#define MT2063_REG_CTUNE_CTRL   0x2a    /* ClearTune Control */
+#define MT2063_REG_CTUNE_OV     0x2b    /* ClearTune Override */
+#define MT2063_REG_CTRL_2C      0x2c
+#define MT2063_REG_FIFF_CTRL2   0x2d    /* FIFF Control 2 */
+#define MT2063_REG_RSVD_2E      0x2e
+#define MT2063_REG_DNC_GAIN     0x2f    /* DNC Gain Control */
+#define MT2063_REG_VGA_GAIN     0x30    /* VGA Gain Control */
+#define MT2063_REG_RSVD_31      0x31
+#define MT2063_REG_TEMP_SEL     0x32    /* Temperature Selection */
+#define MT2063_REG_RSVD_33      0x33
+#define MT2063_REG_RSVD_34      0x34
+#define MT2063_REG_RSVD_35      0x35
+#define MT2063_REG_RSVD_36      0x36
+#define MT2063_REG_RSVD_37      0x37
+#define MT2063_REG_RSVD_38      0x38
+#define MT2063_REG_RSVD_39      0x39
+#define MT2063_REG_RSVD_3A      0x3a
+#define MT2063_REG_RSVD_3B      0x3b
+#define MT2063_REG_RSVD_3C      0x3c
+
+/*
+ * Chip ID's
+ */
+#define MT2063_B0   0x9b
+#define MT2063_B1   0x9c
+#define MT2063_B2   0x9d
+#define MT2063_B3   0x9e
+
+
+/*
+ * tuner defaults for each tuner
+ */
+static const u8 MT2063B0_defaults[] = {
+	/* Reg, Value */
+	0x19, 0x05,
+	0x1b, 0x1d,
+	0x1c, 0x1f,
+	0x1d, 0x0f,
+	0x1e, 0x3f,
+	0x1f, 0x0f,
+	0x20, 0x3f,
+	0x22, 0x21,
+	0x23, 0x3f,
+	0x24, 0x20,
+	0x25, 0x3f,
+	0x27, 0xee,
+	0x2c, 0x27, /* bit at 0x20 is cleared below */
+	0x30, 0x03,
+	0x2c, 0x07, /* bit at 0x20 is cleared here */
+	0x2d, 0x87,
+	0x2e, 0xaa,
+	0x28, 0xe1, /* Set the FIFCrst bit here */
+	0x28, 0xe0, /* Clear the FIFCrst bit here */
+	0x00
+};
+
+static const u8 MT2063B1_defaults [] = {
+	0x11, 0x10, /* new EnableAFCsd */
+	0x19, 0x05,
+	0x1a, 0x6c,
+	0x1b, 0x24,
+	0x1c, 0x28,
+	0x1d, 0x8f,
+	0x1e, 0x14,
+	0x1f, 0x8f,
+	0x20, 0x57,
+	0x22, 0x21,
+	0x23, 0x3c,
+	0x24, 0x20,
+	0x2c, 0x24, /* bit at 0x20 is cleared below */
+	0x2d, 0x87,
+	0x2f, 0xf3,
+	0x30, 0x0c,
+	0x31, 0x1b,
+	0x2c, 0x04, /* bit at 0x20 is cleared here */
+	0x28, 0xe1, /* Set the FIFCrst bit here */
+	0x28, 0xe0, /* Clear the FIFCrst bit here */
+	0x00
+};
+
+static const u8 MT2063B3_defaults [] = {
+	0x19, 0x3d,
+	0x2c, 0x24, /* bit at 0x20 is cleared below */
+	0x2c, 0x04, /* bit at 0x20 is cleared here */
+	0x28, 0xe1, /* Set the FIFCrst bit here */
+	0x28, 0xe0, /* Clear the FIFCrst bit here */
+	0x00
+};
+
+/*
+ * Parameter for function MT2063_SetPowerMask that specifies the power down
+ * of various sections of the MT2063.
+ */
+enum MT2063_Mask_Bits {
+	MT2063_REG_SD   = 0x0040,   /* Shutdown regulator                   */
+	MT2063_SRO_SD   = 0x0020,   /* Shutdown SRO                         */
+	MT2063_AFC_SD   = 0x0010,   /* Shutdown AFC A/D                     */
+	MT2063_PD_SD    = 0x0002,   /* Enable power detector shutdown       */
+	MT2063_PDADC_SD = 0x0001,   /* Enable power detector A/D shutdown   */
+	MT2063_VCO_SD   = 0x8000,   /* Enable VCO shutdown                  */
+	MT2063_LTX_SD   = 0x4000,   /* Enable LTX shutdown                  */
+	MT2063_LT1_SD   = 0x2000,   /* Enable LT1 shutdown                  */
+	MT2063_LNA_SD   = 0x1000,   /* Enable LNA shutdown                  */
+	MT2063_UPC_SD   = 0x0800,   /* Enable upconverter shutdown          */
+	MT2063_DNC_SD   = 0x0400,   /* Enable downconverter shutdown        */
+	MT2063_VGA_SD   = 0x0200,   /* Enable VGA shutdown                  */
+	MT2063_AMP_SD   = 0x0100,   /* Enable AMP shutdown                  */
+	MT2063_ALL_SD   = 0xFF73,   /* All shutdown bits for this tuner     */
+	MT2063_NONE_SD  = 0x0000    /* No shutdown bits                     */
+};
+
+enum mt2063_delsys {
+	MT2063_CABLE_QAM = 0,		/* dvb-c */
+	MT2063_CABLE_ANALOG,		/* analog tv */
+	MT2063_OFFAIR_COFDM,		/* dvb-t */
+	MT2063_OFFAIR_COFDM_SAWLESS,	/* dvb-t sawless */
+	MT2063_OFFAIR_ANALOG,		/* analog radio */
+	MT2063_OFFAIR_8VSB,		/* atsc */
+};
+
+static const char *mt2063_mode_name[] = {
+	[MT2063_CABLE_QAM]		= "digital cable",
+	[MT2063_CABLE_ANALOG]		= "analog cable",
+	[MT2063_OFFAIR_COFDM]		= "digital offair",
+	[MT2063_OFFAIR_COFDM_SAWLESS]	= "digital offair without sawless",
+	[MT2063_OFFAIR_ANALOG]		= "analog offair",
+	[MT2063_OFFAIR_8VSB]		= "digital offair 8vsb/ATSC",
+};
+
+static const u8 LNARIN []	= {  0,  0,  3,  3,  3,  3 };
+static const u8 LNATGT []	= { 44, 43, 43, 43, 43, 43 };
+static const u8 RFOVDIS []	= {  0,  0,  0,  0,  0,  0 };
+static const u8 PD1TGT []	= { 36, 36, 38, 38, 36, 38 };
+static const u8 FIFOVDIS []	= {  0,  0,  0,  0,  0,  0 };
+static const u8 PD2TGT []	= { 40, 33, 42, 42, 33, 42 };
+
+/*
+ * main structure of mt2063
+ */
+struct mt2063_state {
+	/* i2c adapter */
+	struct i2c_adapter *i2c;
+	u8 i2c_addr;
+
+	/* hybrid stuff */
+	struct list_head hybrid_tuner_instance_list;
+	struct tuner_i2c_props i2c_props;
+
+	/* device lock for remote calls */
+	struct mutex lock;
+
+	/* device configurations */
+	const struct mt2063_config *config;
+	struct dvb_tuner_ops ops;
+	struct dvb_frontend *frontend;
+	struct tuner_state status;	/* ? */
+	u32 frequency;			/* input frequency in kHz */
+	u32 if2;			/* if output frequency in kHz */
+	u32 bw;				/* bandwidth spurcheck */
+	u32 tuner_id;
+	enum mt2063_delsys mode;
+};
+
+
+#endif /* __MT2063_PRIV_H__ */
-- 
1.7.7.6

