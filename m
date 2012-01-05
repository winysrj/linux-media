Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab2AEBBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:11 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511AJf016386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 27/47] [media] mt2063: Remove setParm/getParm abstraction layer
Date: Wed,  4 Jan 2012 23:00:38 -0200
Message-Id: <1325725258-27934-28-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This layer just increases the code size for no good reason,
and makes harder to debug.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c | 1130 +++++-----------------------------
 drivers/media/common/tuners/mt2063.h |    2 +-
 2 files changed, 172 insertions(+), 960 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 0bf6292..f9ebe24 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -110,74 +110,6 @@ enum MT2063_Mask_Bits {
 };
 
 /*
- *  Parameter for function MT2063_GetParam & MT2063_SetParam that
- *  specifies the tuning algorithm parameter to be read/written.
- */
-enum MT2063_Param {
-	/*  min tuning step size                            (default: 50000 Hz) */
-	MT2063_STEPSIZE,
-
-	/*  input center frequency                         set by MT2063_Tune() */
-	MT2063_INPUT_FREQ,
-
-	/*  LO1 Frequency                                  set by MT2063_Tune() */
-	MT2063_LO1_FREQ,
-
-	/*  LO2 Frequency                                  set by MT2063_Tune() */
-	MT2063_LO2_FREQ,
-
-	/*  output center frequency                        set by MT2063_Tune() */
-	MT2063_OUTPUT_FREQ,
-
-	/*  output bandwidth                               set by MT2063_Tune() */
-	MT2063_OUTPUT_BW,
-
-	/* Receiver Mode for some parameters. 1 is DVB-T                        */
-	MT2063_RCVR_MODE,
-
-	/* directly set LNA attenuation, parameter is value to set              */
-	MT2063_ACLNA,
-
-	/* maximum LNA attenuation, parameter is value to set                   */
-	MT2063_ACLNA_MAX,
-
-	/* directly set ATN attenuation.  Paremeter is value to set.            */
-	MT2063_ACRF,
-
-	/* maxium ATN attenuation.  Paremeter is value to set.                  */
-	MT2063_ACRF_MAX,
-
-	/* directly set FIF attenuation.  Paremeter is value to set.            */
-	MT2063_ACFIF,
-
-	/* maxium FIF attenuation.  Paremeter is value to set.                  */
-	MT2063_ACFIF_MAX,
-
-	/*  LNA Rin                                                             */
-	MT2063_LNA_RIN,
-
-	/*  Power Detector LNA level target                                     */
-	MT2063_LNA_TGT,
-
-	/*  Power Detector 1 level                                              */
-	MT2063_PD1,
-
-	/*  Power Detector 1 level target                                       */
-	MT2063_PD1_TGT,
-
-	/*  Power Detector 2 level                                              */
-	MT2063_PD2,
-
-	/*  Power Detector 2 level target                                       */
-	MT2063_PD2_TGT,
-
-	/*  Selects, which DNC is activ                                         */
-	MT2063_DNC_OUTPUT_ENABLE,
-
-	MT2063_EOP		/*  last entry in enumerated list         */
-};
-
-/*
  *  Parameter for selecting tuner mode
  */
 enum MT2063_RCVR_MODES {
@@ -311,11 +243,7 @@ struct mt2063_state {
 /* Prototypes */
 static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
                         u32 f_min, u32 f_max);
-static u32 MT2063_GetReg(struct mt2063_state *state, u8 reg, u8 * val);
-static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param, u32 * pValue);
 static u32 MT2063_SetReg(struct mt2063_state *state, u8 reg, u8 val);
-static u32 MT2063_SetParam(struct mt2063_state *state, enum MT2063_Param param,
-			   enum MT2063_DNC_Output_Enable nValue);
 static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown);
 static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state, enum MT2063_Mask_Bits Bits);
 
@@ -1156,371 +1084,152 @@ unsigned int mt2063_lockStatus(struct mt2063_state *state)
 }
 EXPORT_SYMBOL_GPL(mt2063_lockStatus);
 
-/****************************************************************************
-**
-**  Name: MT2063_GetParam
-**
-**  Description:    Gets a tuning algorithm parameter.
-**
-**                  This function provides access to the internals of the
-**                  tuning algorithm - mostly for testing purposes.
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**                  param       - Tuning algorithm parameter
-**                                (see enum MT2063_Param)
-**                  pValue      - ptr to returned value
-**
-**                  param                     Description
-**                  ----------------------    --------------------------------
-**                  MT2063_IC_ADDR            Serial Bus address of this tuner
-**                  MT2063_SRO_FREQ           crystal frequency
-**                  MT2063_STEPSIZE           minimum tuning step size
-**                  MT2063_INPUT_FREQ         input center frequency
-**                  MT2063_LO1_FREQ           LO1 Frequency
-**                  MT2063_LO1_STEPSIZE       LO1 minimum step size
-**                  MT2063_LO1_FRACN_AVOID    LO1 FracN keep-out region
-**                  MT2063_IF1_ACTUAL         Current 1st IF in use
-**                  MT2063_IF1_REQUEST        Requested 1st IF
-**                  MT2063_IF1_CENTER         Center of 1st IF SAW filter
-**                  MT2063_IF1_BW             Bandwidth of 1st IF SAW filter
-**                  MT2063_ZIF_BW             zero-IF bandwidth
-**                  MT2063_LO2_FREQ           LO2 Frequency
-**                  MT2063_LO2_STEPSIZE       LO2 minimum step size
-**                  MT2063_LO2_FRACN_AVOID    LO2 FracN keep-out region
-**                  MT2063_OUTPUT_FREQ        output center frequency
-**                  MT2063_OUTPUT_BW          output bandwidth
-**                  MT2063_LO_SEPARATION      min inter-tuner LO separation
-**                  MT2063_AS_ALG             ID of avoid-spurs algorithm in use
-**                  MT2063_MAX_HARM1          max # of intra-tuner harmonics
-**                  MT2063_MAX_HARM2          max # of inter-tuner harmonics
-**                  MT2063_EXCL_ZONES         # of 1st IF exclusion zones
-**                  MT2063_NUM_SPURS          # of spurs found/avoided
-**                  MT2063_SPUR_AVOIDED       >0 spurs avoided
-**                  MT2063_SPUR_PRESENT       >0 spurs in output (mathematically)
-**                  MT2063_RCVR_MODE          Predefined modes.
-**                  MT2063_ACLNA              LNA attenuator gain code
-**                  MT2063_ACRF               RF attenuator gain code
-**                  MT2063_ACFIF              FIF attenuator gain code
-**                  MT2063_ACLNA_MAX          LNA attenuator limit
-**                  MT2063_ACRF_MAX           RF attenuator limit
-**                  MT2063_ACFIF_MAX          FIF attenuator limit
-**                  MT2063_PD1                Actual value of PD1
-**                  MT2063_PD2                Actual value of PD2
-**                  MT2063_DNC_OUTPUT_ENABLE  DNC output selection
-**                  MT2063_VGAGC              VGA gain code
-**                  MT2063_VGAOI              VGA output current
-**                  MT2063_TAGC               TAGC setting
-**                  MT2063_AMPGC              AMP gain code
-**                  MT2063_AVOID_DECT         Avoid DECT Frequencies
-**                  MT2063_CTFILT_SW          Cleartune filter selection
-**
-**  Usage:          status |= MT2063_GetParam(hMT2063,
-**                                            MT2063_IF1_ACTUAL,
-**                                            &f_IF1_Actual);
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_ARG_NULL      - Null pointer argument passed
-**                      MT_ARG_RANGE     - Invalid parameter requested
-**
-**  Dependencies:   USERS MUST CALL MT2063_Open() FIRST!
-**
-**  See Also:       MT2063_SetParam, MT2063_Open
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**   154   09-13-2007    RSK    Ver 1.05: Get/SetParam changes for LOx_FREQ
-**         10-31-2007    PINZ   Ver 1.08: Get/SetParam add VGAGC, VGAOI, AMPGC, TAGC
-**   173 M 01-23-2008    RSK    Ver 1.12: Read LO1C and LO2C registers from HW
-**                                        in GetParam.
-**         04-18-2008    PINZ   Ver 1.15: Add SetParam LNARIN & PDxTGT
-**                                        Split SetParam up to ACLNA / ACLNA_MAX
-**                                        removed ACLNA_INRC/DECR (+RF & FIF)
-**                                        removed GCUAUTO / BYPATNDN/UP
-**   175 I 16-06-2008    PINZ   Ver 1.16: Add control to avoid US DECT freqs.
-**   175 I 06-19-2008    RSK    Ver 1.17: Refactor DECT control to SpurAvoid.
-**         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
-**
-****************************************************************************/
-static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param, u32 *pValue)
+/*
+ * mt2063_set_dnc_output_enable()
+ */
+static u32 mt2063_get_dnc_output_enable(struct mt2063_state *state,
+				        enum MT2063_DNC_Output_Enable *pValue)
 {
-	u32 status = 0;	/* Status to be returned        */
-	u32 Div;
-	u32 Num;
-
-	if (pValue == NULL)
-		return -EINVAL;
+	if ((state->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
+		if ((state->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
+			*pValue = MT2063_DNC_NONE;
+		else
+			*pValue = MT2063_DNC_2;
+	} else {	/* DNC1 is on */
+		if ((state->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
+			*pValue = MT2063_DNC_1;
+		else
+			*pValue = MT2063_DNC_BOTH;
+	}
+	return 0;
+}
 
-	switch (param) {
-		/*  input center frequency                */
-	case MT2063_INPUT_FREQ:
-		*pValue = state->AS_Data.f_in;
-		break;
+/*
+ * mt2063_set_dnc_output_enable()
+ */
+static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
+				        enum MT2063_DNC_Output_Enable nValue)
+{
+	u32 status = 0;	/* Status to be returned        */
+	u8 val = 0;
 
-		/*  LO1 Frequency                         */
-	case MT2063_LO1_FREQ:
+	/* selects, which DNC output is used */
+	switch (nValue) {
+	case MT2063_DNC_NONE:
 		{
-			/* read the actual tuner register values for LO1C_1 and LO1C_2 */
-			status |=
-			    mt2063_read(state,
-					   MT2063_REG_LO1C_1,
-					   &state->
-					   reg[MT2063_REG_LO1C_1], 2);
-			Div = state->reg[MT2063_REG_LO1C_1];
-			Num = state->reg[MT2063_REG_LO1C_2] & 0x3F;
-			state->AS_Data.f_LO1 =
-			    (state->AS_Data.f_ref * Div) +
-			    MT2063_fLO_FractionalTerm(state->AS_Data.
-						      f_ref, Num, 64);
-		}
-		*pValue = state->AS_Data.f_LO1;
-		break;
+			val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
+			if (state->reg[MT2063_REG_DNC_GAIN] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_DNC_GAIN,
+						  val);
 
-		/*  Bandwidth of 1st IF SAW filter        */
-	case MT2063_IF1_BW:
-		*pValue = state->AS_Data.f_if1_bw;
-		break;
+			val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
+			if (state->reg[MT2063_REG_VGA_GAIN] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_VGA_GAIN,
+						  val);
 
-		/*  zero-IF bandwidth                     */
-	case MT2063_ZIF_BW:
-		*pValue = state->AS_Data.f_zif_bw;
-		break;
+			val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
+			if (state->reg[MT2063_REG_RSVD_20] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_RSVD_20,
+						  val);
 
-		/*  LO2 Frequency                         */
-	case MT2063_LO2_FREQ:
-		{
-			/* Read the actual tuner register values for LO2C_1, LO2C_2 and LO2C_3 */
-			status |=
-			    mt2063_read(state,
-					   MT2063_REG_LO2C_1,
-					   &state->
-					   reg[MT2063_REG_LO2C_1], 3);
-			Div =
-			    (state->reg[MT2063_REG_LO2C_1] & 0xFE) >> 1;
-			Num =
-			    ((state->
-			      reg[MT2063_REG_LO2C_1] & 0x01) << 12) |
-			    (state->
-			     reg[MT2063_REG_LO2C_2] << 4) | (state->
-							     reg
-							     [MT2063_REG_LO2C_3]
-							     & 0x00F);
-			state->AS_Data.f_LO2 =
-			    (state->AS_Data.f_ref * Div) +
-			    MT2063_fLO_FractionalTerm(state->AS_Data.
-						      f_ref, Num, 8191);
+			break;
 		}
-		*pValue = state->AS_Data.f_LO2;
-		break;
-
-		/*  LO2 FracN keep-out region             */
-	case MT2063_LO2_FRACN_AVOID:
-		*pValue = state->AS_Data.f_LO2_FracN_Avoid;
-		break;
-
-		/*  output center frequency               */
-	case MT2063_OUTPUT_FREQ:
-		*pValue = state->AS_Data.f_out;
-		break;
-
-		/*  output bandwidth                      */
-	case MT2063_OUTPUT_BW:
-		*pValue = state->AS_Data.f_out_bw - 750000;
-		break;
-
-		/*  Predefined receiver setup combination */
-	case MT2063_RCVR_MODE:
-		*pValue = state->rcvr_mode;
-		break;
-
-	case MT2063_PD1:
-	case MT2063_PD2: {
-		u8 mask = (param == MT2063_PD1 ? 0x01 : 0x03);	/* PD1 vs PD2 */
-		u8 orig = (state->reg[MT2063_REG_BYP_CTRL]);
-		u8 reg = (orig & 0xF1) | mask;	/* Only set 3 bits (not 5) */
-		int i;
-
-		*pValue = 0;
-
-		/* Initiate ADC output to reg 0x0A */
-		if (reg != orig)
-			status |=
-			    mt2063_write(state,
-					    MT2063_REG_BYP_CTRL,
-					    &reg, 1);
+	case MT2063_DNC_1:
+		{
+			val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
+			if (state->reg[MT2063_REG_DNC_GAIN] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_DNC_GAIN,
+						  val);
 
-		if (status < 0)
-			return (status);
+			val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
+			if (state->reg[MT2063_REG_VGA_GAIN] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_VGA_GAIN,
+						  val);
 
-		for (i = 0; i < 8; i++) {
-			status |=
-			    mt2063_read(state,
-					   MT2063_REG_ADC_OUT,
-					   &state->
-					   reg
-					   [MT2063_REG_ADC_OUT],
-					   1);
-
-			if (status >= 0)
-				*pValue +=
-				    state->
-				    reg[MT2063_REG_ADC_OUT];
-			else {
-				if (i)
-					*pValue /= i;
-				return (status);
-			}
-		}
-		*pValue /= 8;	/*  divide by number of reads  */
-		*pValue >>= 2;	/*  only want 6 MSB's out of 8  */
+			val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
+			if (state->reg[MT2063_REG_RSVD_20] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_RSVD_20,
+						  val);
 
-		/* Restore value of Register BYP_CTRL */
-		if (reg != orig)
-			status |=
-			    mt2063_write(state,
-					    MT2063_REG_BYP_CTRL,
-						&orig, 1);
+			break;
 		}
-		break;
-
-		/*  Get LNA attenuator code                */
-	case MT2063_ACLNA:
-	{
-		u8 val;
-		status |=
-		    MT2063_GetReg(state, MT2063_REG_XO_STATUS,
-				  &val);
-		*pValue = val & 0x1f;
-	}
-	break;
+	case MT2063_DNC_2:
+		{
+			val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
+			if (state->reg[MT2063_REG_DNC_GAIN] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_DNC_GAIN,
+						  val);
 
-	/*  Get RF attenuator code                */
-	case MT2063_ACRF:
-	{
-		u8 val;
-		status |=
-		    MT2063_GetReg(state, MT2063_REG_RF_STATUS,
-				  &val);
-		*pValue = val & 0x1f;
-	}
-	break;
+			val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
+			if (state->reg[MT2063_REG_VGA_GAIN] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_VGA_GAIN,
+						  val);
 
-	/*  Get FIF attenuator code               */
-	case MT2063_ACFIF:
-	{
-		u8 val;
-		status |=
-		    MT2063_GetReg(state, MT2063_REG_FIF_STATUS,
-				  &val);
-		*pValue = val & 0x1f;
-	}
-	break;
+			val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
+			if (state->reg[MT2063_REG_RSVD_20] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_RSVD_20,
+						  val);
 
-	/*  Get LNA attenuator limit              */
-	case MT2063_ACLNA_MAX:
-	{
-		u8 val;
-		status |=
-		    MT2063_GetReg(state, MT2063_REG_LNA_OV,
-				  &val);
-		*pValue = val & 0x1f;
-	}
-	break;
+			break;
+		}
+	case MT2063_DNC_BOTH:
+		{
+			val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
+			if (state->reg[MT2063_REG_DNC_GAIN] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_DNC_GAIN,
+						  val);
 
-	/*  Get RF attenuator limit               */
-	case MT2063_ACRF_MAX:
-	{
-		u8 val;
-		status |=
-		    MT2063_GetReg(state, MT2063_REG_RF_OV,
-				  &val);
-		*pValue = val & 0x1f;
-	}
-	break;
+			val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
+			if (state->reg[MT2063_REG_VGA_GAIN] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_VGA_GAIN,
+						  val);
 
-	/*  Get FIF attenuator limit               */
-	case MT2063_ACFIF_MAX:
-	{
-		u8 val;
-		status |=
-		    MT2063_GetReg(state, MT2063_REG_FIF_OV,
-				  &val);
-		*pValue = val & 0x1f;
-	}
-	break;
-
-	/*  Get current used DNC output */
-	case MT2063_DNC_OUTPUT_ENABLE:
-	{
-		if ((state->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
-			if ((state->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
-				*pValue =
-				    (u32) MT2063_DNC_NONE;
-			else
-				*pValue =
-				    (u32) MT2063_DNC_2;
-		} else {	/* DNC1 is on */
+			val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
+			if (state->reg[MT2063_REG_RSVD_20] !=
+			    val)
+				status |=
+				    MT2063_SetReg(state,
+						  MT2063_REG_RSVD_20,
+						  val);
 
-			if ((state->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
-				*pValue =
-				    (u32) MT2063_DNC_1;
-			else
-				*pValue =
-				    (u32) MT2063_DNC_BOTH;
+			break;
 		}
-	}
-	break;
-
 	default:
-		status |= -ERANGE;
+		break;
 	}
-	return (status);
-}
-
-/****************************************************************************
-**
-**  Name: MT2063_GetReg
-**
-**  Description:    Gets an MT2063 register.
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**                  reg         - MT2063 register/subaddress location
-**                  *val        - MT2063 register/subaddress value
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_COMM_ERR      - Serial bus communications error
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_ARG_NULL      - Null pointer argument passed
-**                      MT_ARG_RANGE     - Argument out of range
-**
-**  Dependencies:   USERS MUST CALL MT2063_Open() FIRST!
-**
-**                  Use this function if you need to read a register from
-**                  the MT2063.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-****************************************************************************/
-static u32 MT2063_GetReg(struct mt2063_state *state, u8 reg, u8 * val)
-{
-	u32 status = 0;	/* Status to be returned        */
-
-	if (val == NULL)
-		return -EINVAL;
-
-	if (reg >= MT2063_REG_END_REGS)
-		return -ERANGE;
-
-	status = mt2063_read(state, reg, &state->reg[reg], 1);
 
 	return (status);
 }
@@ -1632,7 +1341,11 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* LNARin */
 	if (status >= 0) {
-		status |= MT2063_SetParam(state, MT2063_LNA_RIN, LNARIN[Mode]);
+		u8 val = (state-> reg[MT2063_REG_CTRL_2C] & (u8) ~ 0x03) |
+			 (LNARIN[Mode] & 0x03);
+		if (state->reg[MT2063_REG_CTRL_2C] != val)
+			status |= MT2063_SetReg(state, MT2063_REG_CTRL_2C,
+					  val);
 	}
 
 	/* FIFFQEN and FIFFQ */
@@ -1658,40 +1371,59 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 	}
 
 	/* DNC1GC & DNC2GC */
-	status |= MT2063_GetParam(state, MT2063_DNC_OUTPUT_ENABLE, &longval);
-	status |= MT2063_SetParam(state, MT2063_DNC_OUTPUT_ENABLE, longval);
+	status |= mt2063_get_dnc_output_enable(state, &longval);
+	status |= mt2063_set_dnc_output_enable(state, longval);
 
 	/* acLNAmax */
 	if (status >= 0) {
-		status |=
-		    MT2063_SetParam(state, MT2063_ACLNA_MAX, ACLNAMAX[Mode]);
+		u8 val = (state-> reg[MT2063_REG_LNA_OV] & (u8) ~ 0x1F) |
+			 (ACLNAMAX[Mode] & 0x1F);
+		if (state->reg[MT2063_REG_LNA_OV] != val)
+			status |= MT2063_SetReg(state, MT2063_REG_LNA_OV, val);
 	}
 
 	/* LNATGT */
 	if (status >= 0) {
-		status |= MT2063_SetParam(state, MT2063_LNA_TGT, LNATGT[Mode]);
+		u8 val = (state-> reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x3F) |
+			 (LNATGT[Mode] & 0x3F);
+		if (state->reg[MT2063_REG_LNA_TGT] != val)
+			status |= MT2063_SetReg(state, MT2063_REG_LNA_TGT, val);
 	}
 
 	/* ACRF */
 	if (status >= 0) {
-		status |=
-		    MT2063_SetParam(state, MT2063_ACRF_MAX, ACRFMAX[Mode]);
+		u8 val = (state-> reg[MT2063_REG_RF_OV] & (u8) ~ 0x1F) |
+		         (ACRFMAX[Mode] & 0x1F);
+		if (state->reg[MT2063_REG_RF_OV] != val)
+			status |= MT2063_SetReg(state, MT2063_REG_RF_OV, val);
 	}
 
 	/* PD1TGT */
 	if (status >= 0) {
-		status |= MT2063_SetParam(state, MT2063_PD1_TGT, PD1TGT[Mode]);
+		u8 val = (state-> reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x3F) |
+			 (PD1TGT[Mode] & 0x3F);
+		if (state->reg[MT2063_REG_PD1_TGT] != val)
+			status |= MT2063_SetReg(state, MT2063_REG_PD1_TGT, val);
 	}
 
 	/* FIFATN */
 	if (status >= 0) {
-		status |=
-		    MT2063_SetParam(state, MT2063_ACFIF_MAX, ACFIFMAX[Mode]);
+		u8 val = ACFIFMAX[Mode];
+		if (state->reg[MT2063_REG_PART_REV] != MT2063_B3 && val > 5)
+			val = 5;
+		val = (state-> reg[MT2063_REG_FIF_OV] & (u8) ~ 0x1F) |
+		      (val & 0x1F);
+		if (state->reg[MT2063_REG_FIF_OV] != val) {
+			status |= MT2063_SetReg(state, MT2063_REG_FIF_OV, val);
+		}
 	}
 
 	/* PD2TGT */
 	if (status >= 0) {
-		status |= MT2063_SetParam(state, MT2063_PD2_TGT, PD2TGT[Mode]);
+		u8 val = (state-> reg[MT2063_REG_PD2_TGT] & (u8) ~ 0x3F) |
+		    (PD2TGT[Mode] & 0x3F);
+		if (state->reg[MT2063_REG_PD2_TGT] != val)
+			status |= MT2063_SetReg(state, MT2063_REG_PD2_TGT, val);
 	}
 
 	/* Ignore ATN Overload */
@@ -1725,526 +1457,6 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 /****************************************************************************
 **
-**  Name: MT2063_SetParam
-**
-**  Description:    Sets a tuning algorithm parameter.
-**
-**                  This function provides access to the internals of the
-**                  tuning algorithm.  You can override many of the tuning
-**                  algorithm defaults using this function.
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**                  param       - Tuning algorithm parameter
-**                                (see enum MT2063_Param)
-**                  nValue      - value to be set
-**
-**                  param                     Description
-**                  ----------------------    --------------------------------
-**                  MT2063_SRO_FREQ           crystal frequency
-**                  MT2063_STEPSIZE           minimum tuning step size
-**                  MT2063_LO1_FREQ           LO1 frequency
-**                  MT2063_LO1_STEPSIZE       LO1 minimum step size
-**                  MT2063_LO1_FRACN_AVOID    LO1 FracN keep-out region
-**                  MT2063_IF1_REQUEST        Requested 1st IF
-**                  MT2063_ZIF_BW             zero-IF bandwidth
-**                  MT2063_LO2_FREQ           LO2 frequency
-**                  MT2063_LO2_STEPSIZE       LO2 minimum step size
-**                  MT2063_LO2_FRACN_AVOID    LO2 FracN keep-out region
-**                  MT2063_OUTPUT_FREQ        output center frequency
-**                  MT2063_OUTPUT_BW          output bandwidth
-**                  MT2063_LO_SEPARATION      min inter-tuner LO separation
-**                  MT2063_MAX_HARM1          max # of intra-tuner harmonics
-**                  MT2063_MAX_HARM2          max # of inter-tuner harmonics
-**                  MT2063_RCVR_MODE          Predefined modes
-**                  MT2063_LNA_RIN            Set LNA Rin (*)
-**                  MT2063_LNA_TGT            Set target power level at LNA (*)
-**                  MT2063_PD1_TGT            Set target power level at PD1 (*)
-**                  MT2063_PD2_TGT            Set target power level at PD2 (*)
-**                  MT2063_ACLNA_MAX          LNA attenuator limit (*)
-**                  MT2063_ACRF_MAX           RF attenuator limit (*)
-**                  MT2063_ACFIF_MAX          FIF attenuator limit (*)
-**                  MT2063_DNC_OUTPUT_ENABLE  DNC output selection
-**                  MT2063_VGAGC              VGA gain code
-**                  MT2063_VGAOI              VGA output current
-**                  MT2063_TAGC               TAGC setting
-**                  MT2063_AMPGC              AMP gain code
-**                  MT2063_AVOID_DECT         Avoid DECT Frequencies
-**                  MT2063_CTFILT_SW          Cleartune filter selection
-**
-**                  (*) This parameter is set by MT2063_RCVR_MODE, do not call
-**                      additionally.
-**
-**  Usage:          status |= MT2063_SetParam(hMT2063,
-**                                            MT2063_STEPSIZE,
-**                                            50000);
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_ARG_NULL      - Null pointer argument passed
-**                      MT_ARG_RANGE     - Invalid parameter requested
-**                                         or set value out of range
-**                                         or non-writable parameter
-**
-**  Dependencies:   USERS MUST CALL MT2063_Open() FIRST!
-**
-**  See Also:       MT2063_GetParam, MT2063_Open
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**   154   09-13-2007    RSK    Ver 1.05: Get/SetParam changes for LOx_FREQ
-**         10-31-2007    PINZ   Ver 1.08: Get/SetParam add VGAGC, VGAOI, AMPGC, TAGC
-**         04-18-2008    PINZ   Ver 1.15: Add SetParam LNARIN & PDxTGT
-**                                        Split SetParam up to ACLNA / ACLNA_MAX
-**                                        removed ACLNA_INRC/DECR (+RF & FIF)
-**                                        removed GCUAUTO / BYPATNDN/UP
-**   175 I 06-06-2008    PINZ   Ver 1.16: Add control to avoid US DECT freqs.
-**   175 I 06-19-2008    RSK    Ver 1.17: Refactor DECT control to SpurAvoid.
-**         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
-**
-****************************************************************************/
-static u32 MT2063_SetParam(struct mt2063_state *state,
-		           enum MT2063_Param param,
-			   enum MT2063_DNC_Output_Enable nValue)
-{
-	u32 status = 0;	/* Status to be returned        */
-	u8 val = 0;
-
-	switch (param) {
-		/*  LO1 frequency                         */
-	case MT2063_LO1_FREQ:
-		{
-			/* Note: LO1 and LO2 are BOTH written at toggle of LDLOos  */
-			/* Capture the Divider and Numerator portions of other LO  */
-			u8 tempLO2CQ[3];
-			u8 tempLO2C[3];
-			u8 tmpOneShot;
-			u32 Div, FracN;
-			u8 restore = 0;
-
-			/* Buffer the queue for restoration later and get actual LO2 values. */
-			status |=
-			    mt2063_read(state,
-					   MT2063_REG_LO2CQ_1,
-					   &(tempLO2CQ[0]), 3);
-			status |=
-			    mt2063_read(state,
-					   MT2063_REG_LO2C_1,
-					   &(tempLO2C[0]), 3);
-
-			/* clear the one-shot bits */
-			tempLO2CQ[2] = tempLO2CQ[2] & 0x0F;
-			tempLO2C[2] = tempLO2C[2] & 0x0F;
-
-			/* only write the queue values if they are different from the actual. */
-			if ((tempLO2CQ[0] != tempLO2C[0]) ||
-			    (tempLO2CQ[1] != tempLO2C[1]) ||
-			    (tempLO2CQ[2] != tempLO2C[2])) {
-				/* put actual LO2 value into queue (with 0 in one-shot bits) */
-				status |=
-				    mt2063_write(state,
-						    MT2063_REG_LO2CQ_1,
-						    &(tempLO2C[0]), 3);
-
-				if (status == 0) {
-					/* cache the bytes just written. */
-					state->reg[MT2063_REG_LO2CQ_1] =
-					    tempLO2C[0];
-					state->reg[MT2063_REG_LO2CQ_2] =
-					    tempLO2C[1];
-					state->reg[MT2063_REG_LO2CQ_3] =
-					    tempLO2C[2];
-				}
-				restore = 1;
-			}
-
-			/* Calculate the Divider and Numberator components of LO1 */
-			status =
-			    MT2063_CalcLO1Mult(&Div, &FracN, nValue,
-					       state->AS_Data.f_ref /
-					       64,
-					       state->AS_Data.f_ref);
-			state->reg[MT2063_REG_LO1CQ_1] =
-			    (u8) (Div & 0x00FF);
-			state->reg[MT2063_REG_LO1CQ_2] =
-			    (u8) (FracN);
-			status |=
-			    mt2063_write(state,
-					    MT2063_REG_LO1CQ_1,
-					    &state->
-					    reg[MT2063_REG_LO1CQ_1], 2);
-
-			/* set the one-shot bit to load the pair of LO values */
-			tmpOneShot = tempLO2CQ[2] | 0xE0;
-			status |=
-			    mt2063_write(state,
-					    MT2063_REG_LO2CQ_3,
-					    &tmpOneShot, 1);
-
-			/* only restore the queue values if they were different from the actual. */
-			if (restore) {
-				/* put actual LO2 value into queue (0 in one-shot bits) */
-				status |=
-				    mt2063_write(state,
-						    MT2063_REG_LO2CQ_1,
-						    &(tempLO2CQ[0]), 3);
-
-				/* cache the bytes just written. */
-				state->reg[MT2063_REG_LO2CQ_1] =
-				    tempLO2CQ[0];
-				state->reg[MT2063_REG_LO2CQ_2] =
-				    tempLO2CQ[1];
-				state->reg[MT2063_REG_LO2CQ_3] =
-				    tempLO2CQ[2];
-			}
-
-			MT2063_GetParam(state,
-					MT2063_LO1_FREQ,
-					&state->AS_Data.f_LO1);
-		}
-		break;
-
-		/*  zero-IF bandwidth                     */
-	case MT2063_ZIF_BW:
-		state->AS_Data.f_zif_bw = nValue;
-		break;
-
-		/*  LO2 frequency                         */
-	case MT2063_LO2_FREQ:
-		{
-			/* Note: LO1 and LO2 are BOTH written at toggle of LDLOos  */
-			/* Capture the Divider and Numerator portions of other LO  */
-			u8 tempLO1CQ[2];
-			u8 tempLO1C[2];
-			u32 Div2;
-			u32 FracN2;
-			u8 tmpOneShot;
-			u8 restore = 0;
-
-			/* Buffer the queue for restoration later and get actual LO2 values. */
-			status |=
-			    mt2063_read(state,
-					   MT2063_REG_LO1CQ_1,
-					   &(tempLO1CQ[0]), 2);
-			status |=
-			    mt2063_read(state,
-					   MT2063_REG_LO1C_1,
-					   &(tempLO1C[0]), 2);
-
-			/* only write the queue values if they are different from the actual. */
-			if ((tempLO1CQ[0] != tempLO1C[0])
-			    || (tempLO1CQ[1] != tempLO1C[1])) {
-				/* put actual LO1 value into queue */
-				status |=
-				    mt2063_write(state,
-						    MT2063_REG_LO1CQ_1,
-						    &(tempLO1C[0]), 2);
-
-				/* cache the bytes just written. */
-				state->reg[MT2063_REG_LO1CQ_1] =
-				    tempLO1C[0];
-				state->reg[MT2063_REG_LO1CQ_2] =
-				    tempLO1C[1];
-				restore = 1;
-			}
-
-			/* Calculate the Divider and Numberator components of LO2 */
-			status =
-			    MT2063_CalcLO2Mult(&Div2, &FracN2, nValue,
-					       state->AS_Data.f_ref /
-					       8191,
-					       state->AS_Data.f_ref);
-			state->reg[MT2063_REG_LO2CQ_1] =
-			    (u8) ((Div2 << 1) |
-				      ((FracN2 >> 12) & 0x01)) & 0xFF;
-			state->reg[MT2063_REG_LO2CQ_2] =
-			    (u8) ((FracN2 >> 4) & 0xFF);
-			state->reg[MT2063_REG_LO2CQ_3] =
-			    (u8) ((FracN2 & 0x0F));
-			status |=
-			    mt2063_write(state,
-					    MT2063_REG_LO1CQ_1,
-					    &state->
-					    reg[MT2063_REG_LO1CQ_1], 3);
-
-			/* set the one-shot bit to load the LO values */
-			tmpOneShot =
-			    state->reg[MT2063_REG_LO2CQ_3] | 0xE0;
-			status |=
-			    mt2063_write(state,
-					    MT2063_REG_LO2CQ_3,
-					    &tmpOneShot, 1);
-
-			/* only restore LO1 queue value if they were different from the actual. */
-			if (restore) {
-				/* put previous LO1 queue value back into queue */
-				status |=
-				    mt2063_write(state,
-						    MT2063_REG_LO1CQ_1,
-						    &(tempLO1CQ[0]), 2);
-
-				/* cache the bytes just written. */
-				state->reg[MT2063_REG_LO1CQ_1] =
-				    tempLO1CQ[0];
-				state->reg[MT2063_REG_LO1CQ_2] =
-				    tempLO1CQ[1];
-			}
-
-			MT2063_GetParam(state,
-					MT2063_LO2_FREQ,
-					&state->AS_Data.f_LO2);
-		}
-		break;
-
-		/*  LO2 FracN keep-out region             */
-	case MT2063_LO2_FRACN_AVOID:
-		state->AS_Data.f_LO2_FracN_Avoid = nValue;
-		break;
-
-		/*  output center frequency               */
-	case MT2063_OUTPUT_FREQ:
-		state->AS_Data.f_out = nValue;
-		break;
-
-		/*  output bandwidth                      */
-	case MT2063_OUTPUT_BW:
-		state->AS_Data.f_out_bw = nValue + 750000;
-		break;
-
-	case MT2063_RCVR_MODE:
-		status |=
-		    MT2063_SetReceiverMode(state,
-					   (enum MT2063_RCVR_MODES)
-					   nValue);
-		break;
-
-		/* Set LNA Rin -- nValue is desired value */
-	case MT2063_LNA_RIN:
-		val =
-		    (state->
-		     reg[MT2063_REG_CTRL_2C] & (u8) ~ 0x03) |
-		    (nValue & 0x03);
-		if (state->reg[MT2063_REG_CTRL_2C] != val) {
-			status |=
-			    MT2063_SetReg(state, MT2063_REG_CTRL_2C,
-					  val);
-		}
-		break;
-
-		/* Set target power level at LNA -- nValue is desired value */
-	case MT2063_LNA_TGT:
-		val =
-		    (state->
-		     reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x3F) |
-		    (nValue & 0x3F);
-		if (state->reg[MT2063_REG_LNA_TGT] != val) {
-			status |=
-			    MT2063_SetReg(state, MT2063_REG_LNA_TGT,
-					  val);
-		}
-		break;
-
-		/* Set target power level at PD1 -- nValue is desired value */
-	case MT2063_PD1_TGT:
-		val =
-		    (state->
-		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x3F) |
-		    (nValue & 0x3F);
-		if (state->reg[MT2063_REG_PD1_TGT] != val) {
-			status |=
-			    MT2063_SetReg(state, MT2063_REG_PD1_TGT,
-					  val);
-		}
-		break;
-
-		/* Set target power level at PD2 -- nValue is desired value */
-	case MT2063_PD2_TGT:
-		val =
-		    (state->
-		     reg[MT2063_REG_PD2_TGT] & (u8) ~ 0x3F) |
-		    (nValue & 0x3F);
-		if (state->reg[MT2063_REG_PD2_TGT] != val) {
-			status |=
-			    MT2063_SetReg(state, MT2063_REG_PD2_TGT,
-					  val);
-		}
-		break;
-
-		/* Set LNA atten limit -- nValue is desired value */
-	case MT2063_ACLNA_MAX:
-		val =
-		    (state->
-		     reg[MT2063_REG_LNA_OV] & (u8) ~ 0x1F) | (nValue
-								  &
-								  0x1F);
-		if (state->reg[MT2063_REG_LNA_OV] != val) {
-			status |=
-			    MT2063_SetReg(state, MT2063_REG_LNA_OV,
-					  val);
-		}
-		break;
-
-		/* Set RF atten limit -- nValue is desired value */
-	case MT2063_ACRF_MAX:
-		val =
-		    (state->
-		     reg[MT2063_REG_RF_OV] & (u8) ~ 0x1F) | (nValue
-								 &
-								 0x1F);
-		if (state->reg[MT2063_REG_RF_OV] != val) {
-			status |=
-			    MT2063_SetReg(state, MT2063_REG_RF_OV, val);
-		}
-		break;
-
-		/* Set FIF atten limit -- nValue is desired value, max. 5 if no B3 */
-	case MT2063_ACFIF_MAX:
-		if (state->reg[MT2063_REG_PART_REV] != MT2063_B3
-		    && nValue > 5)
-			nValue = 5;
-		val =
-		    (state->
-		     reg[MT2063_REG_FIF_OV] & (u8) ~ 0x1F) | (nValue
-								  &
-								  0x1F);
-		if (state->reg[MT2063_REG_FIF_OV] != val) {
-			status |=
-			    MT2063_SetReg(state, MT2063_REG_FIF_OV,
-					  val);
-		}
-		break;
-
-	case MT2063_DNC_OUTPUT_ENABLE:
-		/* selects, which DNC output is used */
-		switch (nValue) {
-		case MT2063_DNC_NONE:
-			{
-				val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
-				if (state->reg[MT2063_REG_DNC_GAIN] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_DNC_GAIN,
-							  val);
-
-				val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
-				if (state->reg[MT2063_REG_VGA_GAIN] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_VGA_GAIN,
-							  val);
-
-				val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
-				if (state->reg[MT2063_REG_RSVD_20] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_RSVD_20,
-							  val);
-
-				break;
-			}
-		case MT2063_DNC_1:
-			{
-				val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
-				if (state->reg[MT2063_REG_DNC_GAIN] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_DNC_GAIN,
-							  val);
-
-				val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
-				if (state->reg[MT2063_REG_VGA_GAIN] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_VGA_GAIN,
-							  val);
-
-				val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
-				if (state->reg[MT2063_REG_RSVD_20] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_RSVD_20,
-							  val);
-
-				break;
-			}
-		case MT2063_DNC_2:
-			{
-				val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
-				if (state->reg[MT2063_REG_DNC_GAIN] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_DNC_GAIN,
-							  val);
-
-				val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
-				if (state->reg[MT2063_REG_VGA_GAIN] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_VGA_GAIN,
-							  val);
-
-				val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
-				if (state->reg[MT2063_REG_RSVD_20] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_RSVD_20,
-							  val);
-
-				break;
-			}
-		case MT2063_DNC_BOTH:
-			{
-				val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
-				if (state->reg[MT2063_REG_DNC_GAIN] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_DNC_GAIN,
-							  val);
-
-				val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
-				if (state->reg[MT2063_REG_VGA_GAIN] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_VGA_GAIN,
-							  val);
-
-				val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
-				if (state->reg[MT2063_REG_RSVD_20] !=
-				    val)
-					status |=
-					    MT2063_SetReg(state,
-							  MT2063_REG_RSVD_20,
-							  val);
-
-				break;
-			}
-		default:
-			break;
-		}
-		break;
-
-	default:
-		status |= -ERANGE;
-	}
-	return (status);
-}
-
-/****************************************************************************
-**
 **  Name: MT2063_ClearPowerMaskBits
 **
 **  Description:    Clears the power-down mask bits for various sections of
@@ -2816,9 +2028,10 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	return status;
 }
 
-unsigned int mt2063_setTune(void *h, u32 f_in, u32 bw_in,
+int mt2063_setTune(struct dvb_frontend *fe, u32 f_in, u32 bw_in,
 			    enum MTTune_atv_standard tv_type)
 {
+	struct mt2063_state *state = fe->tuner_priv;
 	u32 status = 0;
 	s32 pict_car = 0;
 	s32 pict2chanb_vsb = 0;
@@ -2828,7 +2041,6 @@ unsigned int mt2063_setTune(void *h, u32 f_in, u32 bw_in,
 	s32 ch_bw = 0;
 	s32 if_mid = 0;
 	s32 rcvr_mode = 0;
-	u32 mode_get = 0;
 
 	switch (tv_type) {
 	case MTTUNEA_PAL_B:{
@@ -2931,16 +2143,16 @@ unsigned int mt2063_setTune(void *h, u32 f_in, u32 bw_in,
 	pict2chanb_snd = pict2chanb_vsb - ch_bw;
 	if_mid = pict_car - (pict2chanb_vsb + (ch_bw / 2));
 
-	status |= MT2063_SetParam(h, MT2063_STEPSIZE, 125000);
-	status |= MT2063_SetParam(h, MT2063_OUTPUT_FREQ, if_mid);
-	status |= MT2063_SetParam(h, MT2063_OUTPUT_BW, ch_bw);
-	status |= MT2063_GetParam(h, MT2063_RCVR_MODE, &mode_get);
+	state->AS_Data.f_LO2_Step = 125000;
+	state->AS_Data.f_out = if_mid;
+	state->AS_Data.f_out_bw = ch_bw + 750000;
+	status = MT2063_SetReceiverMode(state, rcvr_mode);
+	if (status < 0)
+	    return status;
 
-	status |= MT2063_SetParam(h, MT2063_RCVR_MODE, rcvr_mode);
-	status |= MT2063_Tune(h, (f_in + (pict2chanb_vsb + (ch_bw / 2))));
-	status |= MT2063_GetParam(h, MT2063_RCVR_MODE, &mode_get);
+	status = MT2063_Tune(state, (f_in + (pict2chanb_vsb + (ch_bw / 2))));
 
-	return (u32) status;
+	return status;
 }
 
 static const u8 MT2063B0_defaults[] = {
@@ -3241,7 +2453,7 @@ static int mt2063_set_state(struct dvb_frontend *fe,
 		//set frequency
 
 		status =
-		    mt2063_setTune(state,
+		    mt2063_setTune(fe,
 				tunstate->frequency, tunstate->bandwidth,
 				state->tv_type);
 
diff --git a/drivers/media/common/tuners/mt2063.h b/drivers/media/common/tuners/mt2063.h
index a95c11e..b2e3abf 100644
--- a/drivers/media/common/tuners/mt2063.h
+++ b/drivers/media/common/tuners/mt2063.h
@@ -23,7 +23,7 @@ static inline struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 	return NULL;
 }
 
-unsigned int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
+int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
 				   u32 bw_in,
 				   enum MTTune_atv_standard tv_type);
 
-- 
1.7.7.5

