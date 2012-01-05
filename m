Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab2AEBBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:11 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511Bi0016392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:11 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 16/47] [media] mt2063: Use state for the state structure
Date: Wed,  4 Jan 2012 23:00:27 -0200
Message-Id: <1325725258-27934-17-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  830 +++++++++++++++++-----------------
 1 files changed, 415 insertions(+), 415 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 66633fa..93015ff 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -415,12 +415,12 @@ struct mt2063_state {
 /* Prototypes */
 static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
                         u32 f_min, u32 f_max);
-static u32 MT2063_ReInit(struct mt2063_state *pInfo);
-static u32 MT2063_Close(struct mt2063_state *pInfo);
-static u32 MT2063_GetReg(struct mt2063_state *pInfo, u8 reg, u8 * val);
-static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param, u32 * pValue);
-static u32 MT2063_SetReg(struct mt2063_state *pInfo, u8 reg, u8 val);
-static u32 MT2063_SetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
+static u32 MT2063_ReInit(struct mt2063_state *state);
+static u32 MT2063_Close(struct mt2063_state *state);
+static u32 MT2063_GetReg(struct mt2063_state *state, u8 reg, u8 * val);
+static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param, u32 * pValue);
+static u32 MT2063_SetReg(struct mt2063_state *state, u8 reg, u8 val);
+static u32 MT2063_SetParam(struct mt2063_state *state, enum MT2063_Param param,
 			   enum MT2063_DNC_Output_Enable nValue);
 
 /*****************/
@@ -1980,7 +1980,7 @@ static u32 MT2063_Close(struct mt2063_state *state)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_GetLocked(struct mt2063_state *pInfo)
+static u32 MT2063_GetLocked(struct mt2063_state *state)
 {
 	const u32 nMaxWait = 100;	/*  wait a maximum of 100 msec   */
 	const u32 nPollRate = 2;	/*  poll status bits every 2 ms */
@@ -1991,19 +1991,19 @@ static u32 MT2063_GetLocked(struct mt2063_state *pInfo)
 	u32 nDelays = 0;
 
 	/*  LO2 Lock bit was in a different place for B0 version  */
-	if (pInfo->tuner_id == MT2063_B0)
+	if (state->tuner_id == MT2063_B0)
 		LO2LK = 0x40;
 
 	do {
 		status |=
-		    MT2063_ReadSub(pInfo,
+		    MT2063_ReadSub(state,
 				   MT2063_REG_LO_STATUS,
-				   &pInfo->reg[MT2063_REG_LO_STATUS], 1);
+				   &state->reg[MT2063_REG_LO_STATUS], 1);
 
 		if (status < 0)
 			return (status);
 
-		if ((pInfo->reg[MT2063_REG_LO_STATUS] & (LO1LK | LO2LK)) ==
+		if ((state->reg[MT2063_REG_LO_STATUS] & (LO1LK | LO2LK)) ==
 		    (LO1LK | LO2LK)) {
 			return (status);
 		}
@@ -2011,9 +2011,9 @@ static u32 MT2063_GetLocked(struct mt2063_state *pInfo)
 	}
 	while (++nDelays < nMaxLoops);
 
-	if ((pInfo->reg[MT2063_REG_LO_STATUS] & LO1LK) == 0x00)
+	if ((state->reg[MT2063_REG_LO_STATUS] & LO1LK) == 0x00)
 		status |= MT2063_UPC_UNLOCK;
-	if ((pInfo->reg[MT2063_REG_LO_STATUS] & LO2LK) == 0x00)
+	if ((state->reg[MT2063_REG_LO_STATUS] & LO2LK) == 0x00)
 		status |= MT2063_DNC_UNLOCK;
 
 	return (status);
@@ -2111,7 +2111,7 @@ static u32 MT2063_GetLocked(struct mt2063_state *pInfo)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param, u32 *pValue)
+static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param, u32 *pValue)
 {
 	u32 status = 0;	/* Status to be returned        */
 	u32 Div;
@@ -2123,7 +2123,7 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 	switch (param) {
 		/*  Serial Bus address of this tuner      */
 	case MT2063_IC_ADDR:
-		*pValue = pInfo->config->tuner_address;
+		*pValue = state->config->tuner_address;
 		break;
 
 		/*  Max # of MT2063's allowed to be open  */
@@ -2138,17 +2138,17 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 
 		/*  crystal frequency                     */
 	case MT2063_SRO_FREQ:
-		*pValue = pInfo->AS_Data.f_ref;
+		*pValue = state->AS_Data.f_ref;
 		break;
 
 		/*  minimum tuning step size              */
 	case MT2063_STEPSIZE:
-		*pValue = pInfo->AS_Data.f_LO2_Step;
+		*pValue = state->AS_Data.f_LO2_Step;
 		break;
 
 		/*  input center frequency                */
 	case MT2063_INPUT_FREQ:
-		*pValue = pInfo->AS_Data.f_in;
+		*pValue = state->AS_Data.f_in;
 		break;
 
 		/*  LO1 Frequency                         */
@@ -2156,53 +2156,53 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 		{
 			/* read the actual tuner register values for LO1C_1 and LO1C_2 */
 			status |=
-			    MT2063_ReadSub(pInfo,
+			    MT2063_ReadSub(state,
 					   MT2063_REG_LO1C_1,
-					   &pInfo->
+					   &state->
 					   reg[MT2063_REG_LO1C_1], 2);
-			Div = pInfo->reg[MT2063_REG_LO1C_1];
-			Num = pInfo->reg[MT2063_REG_LO1C_2] & 0x3F;
-			pInfo->AS_Data.f_LO1 =
-			    (pInfo->AS_Data.f_ref * Div) +
-			    MT2063_fLO_FractionalTerm(pInfo->AS_Data.
+			Div = state->reg[MT2063_REG_LO1C_1];
+			Num = state->reg[MT2063_REG_LO1C_2] & 0x3F;
+			state->AS_Data.f_LO1 =
+			    (state->AS_Data.f_ref * Div) +
+			    MT2063_fLO_FractionalTerm(state->AS_Data.
 						      f_ref, Num, 64);
 		}
-		*pValue = pInfo->AS_Data.f_LO1;
+		*pValue = state->AS_Data.f_LO1;
 		break;
 
 		/*  LO1 minimum step size                 */
 	case MT2063_LO1_STEPSIZE:
-		*pValue = pInfo->AS_Data.f_LO1_Step;
+		*pValue = state->AS_Data.f_LO1_Step;
 		break;
 
 		/*  LO1 FracN keep-out region             */
 	case MT2063_LO1_FRACN_AVOID_PARAM:
-		*pValue = pInfo->AS_Data.f_LO1_FracN_Avoid;
+		*pValue = state->AS_Data.f_LO1_FracN_Avoid;
 		break;
 
 		/*  Current 1st IF in use                 */
 	case MT2063_IF1_ACTUAL:
-		*pValue = pInfo->f_IF1_actual;
+		*pValue = state->f_IF1_actual;
 		break;
 
 		/*  Requested 1st IF                      */
 	case MT2063_IF1_REQUEST:
-		*pValue = pInfo->AS_Data.f_if1_Request;
+		*pValue = state->AS_Data.f_if1_Request;
 		break;
 
 		/*  Center of 1st IF SAW filter           */
 	case MT2063_IF1_CENTER:
-		*pValue = pInfo->AS_Data.f_if1_Center;
+		*pValue = state->AS_Data.f_if1_Center;
 		break;
 
 		/*  Bandwidth of 1st IF SAW filter        */
 	case MT2063_IF1_BW:
-		*pValue = pInfo->AS_Data.f_if1_bw;
+		*pValue = state->AS_Data.f_if1_bw;
 		break;
 
 		/*  zero-IF bandwidth                     */
 	case MT2063_ZIF_BW:
-		*pValue = pInfo->AS_Data.f_zif_bw;
+		*pValue = state->AS_Data.f_zif_bw;
 		break;
 
 		/*  LO2 Frequency                         */
@@ -2210,97 +2210,97 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 		{
 			/* Read the actual tuner register values for LO2C_1, LO2C_2 and LO2C_3 */
 			status |=
-			    MT2063_ReadSub(pInfo,
+			    MT2063_ReadSub(state,
 					   MT2063_REG_LO2C_1,
-					   &pInfo->
+					   &state->
 					   reg[MT2063_REG_LO2C_1], 3);
 			Div =
-			    (pInfo->reg[MT2063_REG_LO2C_1] & 0xFE) >> 1;
+			    (state->reg[MT2063_REG_LO2C_1] & 0xFE) >> 1;
 			Num =
-			    ((pInfo->
+			    ((state->
 			      reg[MT2063_REG_LO2C_1] & 0x01) << 12) |
-			    (pInfo->
-			     reg[MT2063_REG_LO2C_2] << 4) | (pInfo->
+			    (state->
+			     reg[MT2063_REG_LO2C_2] << 4) | (state->
 							     reg
 							     [MT2063_REG_LO2C_3]
 							     & 0x00F);
-			pInfo->AS_Data.f_LO2 =
-			    (pInfo->AS_Data.f_ref * Div) +
-			    MT2063_fLO_FractionalTerm(pInfo->AS_Data.
+			state->AS_Data.f_LO2 =
+			    (state->AS_Data.f_ref * Div) +
+			    MT2063_fLO_FractionalTerm(state->AS_Data.
 						      f_ref, Num, 8191);
 		}
-		*pValue = pInfo->AS_Data.f_LO2;
+		*pValue = state->AS_Data.f_LO2;
 		break;
 
 		/*  LO2 minimum step size                 */
 	case MT2063_LO2_STEPSIZE:
-		*pValue = pInfo->AS_Data.f_LO2_Step;
+		*pValue = state->AS_Data.f_LO2_Step;
 		break;
 
 		/*  LO2 FracN keep-out region             */
 	case MT2063_LO2_FRACN_AVOID:
-		*pValue = pInfo->AS_Data.f_LO2_FracN_Avoid;
+		*pValue = state->AS_Data.f_LO2_FracN_Avoid;
 		break;
 
 		/*  output center frequency               */
 	case MT2063_OUTPUT_FREQ:
-		*pValue = pInfo->AS_Data.f_out;
+		*pValue = state->AS_Data.f_out;
 		break;
 
 		/*  output bandwidth                      */
 	case MT2063_OUTPUT_BW:
-		*pValue = pInfo->AS_Data.f_out_bw - 750000;
+		*pValue = state->AS_Data.f_out_bw - 750000;
 		break;
 
 		/*  min inter-tuner LO separation         */
 	case MT2063_LO_SEPARATION:
-		*pValue = pInfo->AS_Data.f_min_LO_Separation;
+		*pValue = state->AS_Data.f_min_LO_Separation;
 		break;
 
 		/*  ID of avoid-spurs algorithm in use    */
 	case MT2063_AS_ALG:
-		*pValue = pInfo->AS_Data.nAS_Algorithm;
+		*pValue = state->AS_Data.nAS_Algorithm;
 		break;
 
 		/*  max # of intra-tuner harmonics        */
 	case MT2063_MAX_HARM1:
-		*pValue = pInfo->AS_Data.maxH1;
+		*pValue = state->AS_Data.maxH1;
 		break;
 
 		/*  max # of inter-tuner harmonics        */
 	case MT2063_MAX_HARM2:
-		*pValue = pInfo->AS_Data.maxH2;
+		*pValue = state->AS_Data.maxH2;
 		break;
 
 		/*  # of 1st IF exclusion zones           */
 	case MT2063_EXCL_ZONES:
-		*pValue = pInfo->AS_Data.nZones;
+		*pValue = state->AS_Data.nZones;
 		break;
 
 		/*  # of spurs found/avoided              */
 	case MT2063_NUM_SPURS:
-		*pValue = pInfo->AS_Data.nSpursFound;
+		*pValue = state->AS_Data.nSpursFound;
 		break;
 
 		/*  >0 spurs avoided                      */
 	case MT2063_SPUR_AVOIDED:
-		*pValue = pInfo->AS_Data.bSpurAvoided;
+		*pValue = state->AS_Data.bSpurAvoided;
 		break;
 
 		/*  >0 spurs in output (mathematically)   */
 	case MT2063_SPUR_PRESENT:
-		*pValue = pInfo->AS_Data.bSpurPresent;
+		*pValue = state->AS_Data.bSpurPresent;
 		break;
 
 		/*  Predefined receiver setup combination */
 	case MT2063_RCVR_MODE:
-		*pValue = pInfo->rcvr_mode;
+		*pValue = state->rcvr_mode;
 		break;
 
 	case MT2063_PD1:
 	case MT2063_PD2: {
 		u8 mask = (param == MT2063_PD1 ? 0x01 : 0x03);	/* PD1 vs PD2 */
-		u8 orig = (pInfo->reg[MT2063_REG_BYP_CTRL]);
+		u8 orig = (state->reg[MT2063_REG_BYP_CTRL]);
 		u8 reg = (orig & 0xF1) | mask;	/* Only set 3 bits (not 5) */
 		int i;
 
@@ -2309,7 +2309,7 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 		/* Initiate ADC output to reg 0x0A */
 		if (reg != orig)
 			status |=
-			    MT2063_WriteSub(pInfo,
+			    MT2063_WriteSub(state,
 					    MT2063_REG_BYP_CTRL,
 					    &reg, 1);
 
@@ -2318,16 +2318,16 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 
 		for (i = 0; i < 8; i++) {
 			status |=
-			    MT2063_ReadSub(pInfo,
+			    MT2063_ReadSub(state,
 					   MT2063_REG_ADC_OUT,
-					   &pInfo->
+					   &state->
 					   reg
 					   [MT2063_REG_ADC_OUT],
 					   1);
 
 			if (status >= 0)
 				*pValue +=
-				    pInfo->
+				    state->
 				    reg[MT2063_REG_ADC_OUT];
 			else {
 				if (i)
@@ -2341,7 +2341,7 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 		/* Restore value of Register BYP_CTRL */
 		if (reg != orig)
 			status |=
-			    MT2063_WriteSub(pInfo,
+			    MT2063_WriteSub(state,
 					    MT2063_REG_BYP_CTRL,
 						&orig, 1);
 		}
@@ -2352,7 +2352,7 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 	{
 		u8 val;
 		status |=
-		    MT2063_GetReg(pInfo, MT2063_REG_XO_STATUS,
+		    MT2063_GetReg(state, MT2063_REG_XO_STATUS,
 				  &val);
 		*pValue = val & 0x1f;
 	}
@@ -2363,7 +2363,7 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 	{
 		u8 val;
 		status |=
-		    MT2063_GetReg(pInfo, MT2063_REG_RF_STATUS,
+		    MT2063_GetReg(state, MT2063_REG_RF_STATUS,
 				  &val);
 		*pValue = val & 0x1f;
 	}
@@ -2374,7 +2374,7 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 	{
 		u8 val;
 		status |=
-		    MT2063_GetReg(pInfo, MT2063_REG_FIF_STATUS,
+		    MT2063_GetReg(state, MT2063_REG_FIF_STATUS,
 				  &val);
 		*pValue = val & 0x1f;
 	}
@@ -2385,7 +2385,7 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 	{
 		u8 val;
 		status |=
-		    MT2063_GetReg(pInfo, MT2063_REG_LNA_OV,
+		    MT2063_GetReg(state, MT2063_REG_LNA_OV,
 				  &val);
 		*pValue = val & 0x1f;
 	}
@@ -2396,7 +2396,7 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 	{
 		u8 val;
 		status |=
-		    MT2063_GetReg(pInfo, MT2063_REG_RF_OV,
+		    MT2063_GetReg(state, MT2063_REG_RF_OV,
 				  &val);
 		*pValue = val & 0x1f;
 	}
@@ -2407,7 +2407,7 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 	{
 		u8 val;
 		status |=
-		    MT2063_GetReg(pInfo, MT2063_REG_FIF_OV,
+		    MT2063_GetReg(state, MT2063_REG_FIF_OV,
 				  &val);
 		*pValue = val & 0x1f;
 	}
@@ -2416,8 +2416,8 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 	/*  Get current used DNC output */
 	case MT2063_DNC_OUTPUT_ENABLE:
 	{
-		if ((pInfo->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
-			if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
+		if ((state->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
+			if ((state->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
 				*pValue =
 				    (u32) MT2063_DNC_NONE;
 			else
@@ -2425,7 +2425,7 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 				    (u32) MT2063_DNC_2;
 		} else {	/* DNC1 is on */
 
-			if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
+			if ((state->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
 				*pValue =
 				    (u32) MT2063_DNC_1;
 			else
@@ -2437,32 +2437,32 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 
 	/*  Get VGA Gain Code */
 		case MT2063_VGAGC:
-		*pValue = ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x0C) >> 2);
+		*pValue = ((state->reg[MT2063_REG_VGA_GAIN] & 0x0C) >> 2);
 		break;
 
 		/*  Get VGA bias current */
 	case MT2063_VGAOI:
-		*pValue = (pInfo->reg[MT2063_REG_RSVD_31] & 0x07);
+		*pValue = (state->reg[MT2063_REG_RSVD_31] & 0x07);
 		break;
 
 		/*  Get TAGC setting */
 	case MT2063_TAGC:
-		*pValue = (pInfo->reg[MT2063_REG_RSVD_1E] & 0x03);
+		*pValue = (state->reg[MT2063_REG_RSVD_1E] & 0x03);
 		break;
 
 		/*  Get AMP Gain Code */
 	case MT2063_AMPGC:
-		*pValue = (pInfo->reg[MT2063_REG_TEMP_SEL] & 0x03);
+		*pValue = (state->reg[MT2063_REG_TEMP_SEL] & 0x03);
 		break;
 
 		/*  Avoid DECT Frequencies  */
 	case MT2063_AVOID_DECT:
-		*pValue = pInfo->AS_Data.avoidDECT;
+		*pValue = state->AS_Data.avoidDECT;
 		break;
 
 		/*  Cleartune filter selection: 0 - by IC (default), 1 - by software  */
 	case MT2063_CTFILT_SW:
-		*pValue = pInfo->ctfilt_sw;
+		*pValue = state->ctfilt_sw;
 		break;
 
 	case MT2063_EOP:
@@ -2501,7 +2501,7 @@ static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_GetReg(struct mt2063_state *pInfo, u8 reg, u8 * val)
+static u32 MT2063_GetReg(struct mt2063_state *state, u8 reg, u8 * val)
 {
 	u32 status = 0;	/* Status to be returned        */
 
@@ -2511,7 +2511,7 @@ static u32 MT2063_GetReg(struct mt2063_state *pInfo, u8 reg, u8 * val)
 	if (reg >= MT2063_REG_END_REGS)
 		return -ERANGE;
 
-	status = MT2063_ReadSub(pInfo, reg, &pInfo->reg[reg], 1);
+	status = MT2063_ReadSub(state, reg, &state->reg[reg], 1);
 
 	return (status);
 }
@@ -2553,7 +2553,7 @@ static u32 MT2063_GetReg(struct mt2063_state *pInfo, u8 reg, u8 * val)
 **    PD2 Target  |  40 |  33 |  42 |  42 | 33  | 42
 **
 **
-**  Parameters:     pInfo       - ptr to mt2063_state structure
+**  Parameters:     state       - ptr to mt2063_state structure
 **                  Mode        - desired reciever mode
 **
 **  Usage:          status = MT2063_SetReceiverMode(hMT2063, Mode);
@@ -2599,7 +2599,7 @@ static u32 MT2063_GetReg(struct mt2063_state *pInfo, u8 reg, u8 * val)
 **                                        removed GCUAUTO / BYPATNDN/UP
 **
 ******************************************************************************/
-static u32 MT2063_SetReceiverMode(struct mt2063_state *pInfo,
+static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 				      enum MT2063_RCVR_MODES Mode)
 {
 	u32 status = 0;	/* Status to be returned        */
@@ -2612,104 +2612,104 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *pInfo,
 	/* RFAGCen */
 	if (status >= 0) {
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x40) | (RFAGCEN[Mode]
 								   ? 0x40 :
 								   0x00);
-		if (pInfo->reg[MT2063_REG_PD1_TGT] != val) {
-			status |= MT2063_SetReg(pInfo, MT2063_REG_PD1_TGT, val);
+		if (state->reg[MT2063_REG_PD1_TGT] != val) {
+			status |= MT2063_SetReg(state, MT2063_REG_PD1_TGT, val);
 		}
 	}
 
 	/* LNARin */
 	if (status >= 0) {
-		status |= MT2063_SetParam(pInfo, MT2063_LNA_RIN, LNARIN[Mode]);
+		status |= MT2063_SetParam(state, MT2063_LNA_RIN, LNARIN[Mode]);
 	}
 
 	/* FIFFQEN and FIFFQ */
 	if (status >= 0) {
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_FIFF_CTRL2] & (u8) ~ 0xF0) |
 		    (FIFFQEN[Mode] << 7) | (FIFFQ[Mode] << 4);
-		if (pInfo->reg[MT2063_REG_FIFF_CTRL2] != val) {
+		if (state->reg[MT2063_REG_FIFF_CTRL2] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_FIFF_CTRL2, val);
+			    MT2063_SetReg(state, MT2063_REG_FIFF_CTRL2, val);
 			/* trigger FIFF calibration, needed after changing FIFFQ */
 			val =
-			    (pInfo->reg[MT2063_REG_FIFF_CTRL] | (u8) 0x01);
+			    (state->reg[MT2063_REG_FIFF_CTRL] | (u8) 0x01);
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_FIFF_CTRL, val);
+			    MT2063_SetReg(state, MT2063_REG_FIFF_CTRL, val);
 			val =
-			    (pInfo->
+			    (state->
 			     reg[MT2063_REG_FIFF_CTRL] & (u8) ~ 0x01);
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_FIFF_CTRL, val);
+			    MT2063_SetReg(state, MT2063_REG_FIFF_CTRL, val);
 		}
 	}
 
 	/* DNC1GC & DNC2GC */
-	status |= MT2063_GetParam(pInfo, MT2063_DNC_OUTPUT_ENABLE, &longval);
-	status |= MT2063_SetParam(pInfo, MT2063_DNC_OUTPUT_ENABLE, longval);
+	status |= MT2063_GetParam(state, MT2063_DNC_OUTPUT_ENABLE, &longval);
+	status |= MT2063_SetParam(state, MT2063_DNC_OUTPUT_ENABLE, longval);
 
 	/* acLNAmax */
 	if (status >= 0) {
 		status |=
-		    MT2063_SetParam(pInfo, MT2063_ACLNA_MAX, ACLNAMAX[Mode]);
+		    MT2063_SetParam(state, MT2063_ACLNA_MAX, ACLNAMAX[Mode]);
 	}
 
 	/* LNATGT */
 	if (status >= 0) {
-		status |= MT2063_SetParam(pInfo, MT2063_LNA_TGT, LNATGT[Mode]);
+		status |= MT2063_SetParam(state, MT2063_LNA_TGT, LNATGT[Mode]);
 	}
 
 	/* ACRF */
 	if (status >= 0) {
 		status |=
-		    MT2063_SetParam(pInfo, MT2063_ACRF_MAX, ACRFMAX[Mode]);
+		    MT2063_SetParam(state, MT2063_ACRF_MAX, ACRFMAX[Mode]);
 	}
 
 	/* PD1TGT */
 	if (status >= 0) {
-		status |= MT2063_SetParam(pInfo, MT2063_PD1_TGT, PD1TGT[Mode]);
+		status |= MT2063_SetParam(state, MT2063_PD1_TGT, PD1TGT[Mode]);
 	}
 
 	/* FIFATN */
 	if (status >= 0) {
 		status |=
-		    MT2063_SetParam(pInfo, MT2063_ACFIF_MAX, ACFIFMAX[Mode]);
+		    MT2063_SetParam(state, MT2063_ACFIF_MAX, ACFIFMAX[Mode]);
 	}
 
 	/* PD2TGT */
 	if (status >= 0) {
-		status |= MT2063_SetParam(pInfo, MT2063_PD2_TGT, PD2TGT[Mode]);
+		status |= MT2063_SetParam(state, MT2063_PD2_TGT, PD2TGT[Mode]);
 	}
 
 	/* Ignore ATN Overload */
 	if (status >= 0) {
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x80) | (RFOVDIS[Mode]
 								   ? 0x80 :
 								   0x00);
-		if (pInfo->reg[MT2063_REG_LNA_TGT] != val) {
-			status |= MT2063_SetReg(pInfo, MT2063_REG_LNA_TGT, val);
+		if (state->reg[MT2063_REG_LNA_TGT] != val) {
+			status |= MT2063_SetReg(state, MT2063_REG_LNA_TGT, val);
 		}
 	}
 
 	/* Ignore FIF Overload */
 	if (status >= 0) {
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x80) |
 		    (FIFOVDIS[Mode] ? 0x80 : 0x00);
-		if (pInfo->reg[MT2063_REG_PD1_TGT] != val) {
-			status |= MT2063_SetReg(pInfo, MT2063_REG_PD1_TGT, val);
+		if (state->reg[MT2063_REG_PD1_TGT] != val) {
+			status |= MT2063_SetReg(state, MT2063_REG_PD1_TGT, val);
 		}
 	}
 
 	if (status >= 0)
-		pInfo->rcvr_mode = Mode;
+		state->rcvr_mode = Mode;
 
 	return (status);
 }
@@ -2748,7 +2748,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *pInfo,
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ******************************************************************************/
-static u32 MT2063_ReInit(struct mt2063_state *pInfo)
+static u32 MT2063_ReInit(struct mt2063_state *state)
 {
 	u8 all_resets = 0xF0;	/* reset/load bits */
 	u32 status = 0;	/* Status to be returned */
@@ -2816,33 +2816,33 @@ static u32 MT2063_ReInit(struct mt2063_state *pInfo)
 	};
 
 	/*  Read the Part/Rev code from the tuner */
-	status = MT2063_ReadSub(pInfo, MT2063_REG_PART_REV, pInfo->reg, 1);
+	status = MT2063_ReadSub(state, MT2063_REG_PART_REV, state->reg, 1);
 	if (status < 0)
 		return status;
 
 	/* Check the part/rev code */
-	if (((pInfo->reg[MT2063_REG_PART_REV] != MT2063_B0)	/*  MT2063 B0  */
-	    &&(pInfo->reg[MT2063_REG_PART_REV] != MT2063_B1)	/*  MT2063 B1  */
-	    &&(pInfo->reg[MT2063_REG_PART_REV] != MT2063_B3)))	/*  MT2063 B3  */
+	if (((state->reg[MT2063_REG_PART_REV] != MT2063_B0)	/*  MT2063 B0  */
+	    &&(state->reg[MT2063_REG_PART_REV] != MT2063_B1)	/*  MT2063 B1  */
+	    &&(state->reg[MT2063_REG_PART_REV] != MT2063_B3)))	/*  MT2063 B3  */
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 
 	/*  Check the 2nd byte of the Part/Rev code from the tuner */
-	status = MT2063_ReadSub(pInfo,
+	status = MT2063_ReadSub(state,
 			        MT2063_REG_RSVD_3B,
-			        &pInfo->reg[MT2063_REG_RSVD_3B], 1);
+			        &state->reg[MT2063_REG_RSVD_3B], 1);
 
 	if (status >= 0
-	    &&((pInfo->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00))	/* b7 != 0 ==> NOT MT2063 */
+	    &&((state->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00))	/* b7 != 0 ==> NOT MT2063 */
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 
 	/*  Reset the tuner  */
-	status = MT2063_WriteSub(pInfo, MT2063_REG_LO2CQ_3, &all_resets, 1);
+	status = MT2063_WriteSub(state, MT2063_REG_LO2CQ_3, &all_resets, 1);
 	if (status < 0)
 		return status;
 
 	/* change all of the default values that vary from the HW reset values */
-	/*  def = (pInfo->reg[PART_REV] == MT2063_B0) ? MT2063B0_defaults : MT2063B1_defaults; */
-	switch (pInfo->reg[MT2063_REG_PART_REV]) {
+	/*  def = (state->reg[PART_REV] == MT2063_B0) ? MT2063B0_defaults : MT2063B1_defaults; */
+	switch (state->reg[MT2063_REG_PART_REV]) {
 	case MT2063_B3:
 		def = MT2063B3_defaults;
 		break;
@@ -2863,7 +2863,7 @@ static u32 MT2063_ReInit(struct mt2063_state *pInfo)
 	while (status >= 0 && *def) {
 		u8 reg = *def++;
 		u8 val = *def++;
-		status = MT2063_WriteSub(pInfo, reg, &val, 1);
+		status = MT2063_WriteSub(state, reg, &val, 1);
 	}
 	if (status < 0)
 		return status;
@@ -2873,116 +2873,116 @@ static u32 MT2063_ReInit(struct mt2063_state *pInfo)
 	maxReads = 10;
 	while (status >= 0 && (FCRUN != 0) && (maxReads-- > 0)) {
 		msleep(2);
-		status = MT2063_ReadSub(pInfo,
+		status = MT2063_ReadSub(state,
 					 MT2063_REG_XO_STATUS,
-					 &pInfo->
+					 &state->
 					 reg[MT2063_REG_XO_STATUS], 1);
-		FCRUN = (pInfo->reg[MT2063_REG_XO_STATUS] & 0x40) >> 6;
+		FCRUN = (state->reg[MT2063_REG_XO_STATUS] & 0x40) >> 6;
 	}
 
 	if (FCRUN != 0)
 		return -ENODEV;
 
-	status = MT2063_ReadSub(pInfo,
+	status = MT2063_ReadSub(state,
 			   MT2063_REG_FIFFC,
-			   &pInfo->reg[MT2063_REG_FIFFC], 1);
+			   &state->reg[MT2063_REG_FIFFC], 1);
 	if (status < 0)
 		return status;
 
 	/* Read back all the registers from the tuner */
-	status = MT2063_ReadSub(pInfo,
+	status = MT2063_ReadSub(state,
 				MT2063_REG_PART_REV,
-				pInfo->reg, MT2063_REG_END_REGS);
+				state->reg, MT2063_REG_END_REGS);
 	if (status < 0)
 		return status;
 
 	/*  Initialize the tuner state.  */
-	pInfo->tuner_id = pInfo->reg[MT2063_REG_PART_REV];
-	pInfo->AS_Data.f_ref = MT2063_REF_FREQ;
-	pInfo->AS_Data.f_if1_Center = (pInfo->AS_Data.f_ref / 8) *
-				      ((u32) pInfo->reg[MT2063_REG_FIFFC] + 640);
-	pInfo->AS_Data.f_if1_bw = MT2063_IF1_BW;
-	pInfo->AS_Data.f_out = 43750000UL;
-	pInfo->AS_Data.f_out_bw = 6750000UL;
-	pInfo->AS_Data.f_zif_bw = MT2063_ZIF_BW;
-	pInfo->AS_Data.f_LO1_Step = pInfo->AS_Data.f_ref / 64;
-	pInfo->AS_Data.f_LO2_Step = MT2063_TUNE_STEP_SIZE;
-	pInfo->AS_Data.maxH1 = MT2063_MAX_HARMONICS_1;
-	pInfo->AS_Data.maxH2 = MT2063_MAX_HARMONICS_2;
-	pInfo->AS_Data.f_min_LO_Separation = MT2063_MIN_LO_SEP;
-	pInfo->AS_Data.f_if1_Request = pInfo->AS_Data.f_if1_Center;
-	pInfo->AS_Data.f_LO1 = 2181000000UL;
-	pInfo->AS_Data.f_LO2 = 1486249786UL;
-	pInfo->f_IF1_actual = pInfo->AS_Data.f_if1_Center;
-	pInfo->AS_Data.f_in = pInfo->AS_Data.f_LO1 - pInfo->f_IF1_actual;
-	pInfo->AS_Data.f_LO1_FracN_Avoid = MT2063_LO1_FRACN_AVOID;
-	pInfo->AS_Data.f_LO2_FracN_Avoid = MT2063_LO2_FRACN_AVOID;
-	pInfo->num_regs = MT2063_REG_END_REGS;
-	pInfo->AS_Data.avoidDECT = MT2063_AVOID_BOTH;
-	pInfo->ctfilt_sw = 0;
-
-	pInfo->CTFiltMax[0] = 69230000;
-	pInfo->CTFiltMax[1] = 105770000;
-	pInfo->CTFiltMax[2] = 140350000;
-	pInfo->CTFiltMax[3] = 177110000;
-	pInfo->CTFiltMax[4] = 212860000;
-	pInfo->CTFiltMax[5] = 241130000;
-	pInfo->CTFiltMax[6] = 274370000;
-	pInfo->CTFiltMax[7] = 309820000;
-	pInfo->CTFiltMax[8] = 342450000;
-	pInfo->CTFiltMax[9] = 378870000;
-	pInfo->CTFiltMax[10] = 416210000;
-	pInfo->CTFiltMax[11] = 456500000;
-	pInfo->CTFiltMax[12] = 495790000;
-	pInfo->CTFiltMax[13] = 534530000;
-	pInfo->CTFiltMax[14] = 572610000;
-	pInfo->CTFiltMax[15] = 598970000;
-	pInfo->CTFiltMax[16] = 635910000;
-	pInfo->CTFiltMax[17] = 672130000;
-	pInfo->CTFiltMax[18] = 714840000;
-	pInfo->CTFiltMax[19] = 739660000;
-	pInfo->CTFiltMax[20] = 770410000;
-	pInfo->CTFiltMax[21] = 814660000;
-	pInfo->CTFiltMax[22] = 846950000;
-	pInfo->CTFiltMax[23] = 867820000;
-	pInfo->CTFiltMax[24] = 915980000;
-	pInfo->CTFiltMax[25] = 947450000;
-	pInfo->CTFiltMax[26] = 983110000;
-	pInfo->CTFiltMax[27] = 1021630000;
-	pInfo->CTFiltMax[28] = 1061870000;
-	pInfo->CTFiltMax[29] = 1098330000;
-	pInfo->CTFiltMax[30] = 1138990000;
+	state->tuner_id = state->reg[MT2063_REG_PART_REV];
+	state->AS_Data.f_ref = MT2063_REF_FREQ;
+	state->AS_Data.f_if1_Center = (state->AS_Data.f_ref / 8) *
+				      ((u32) state->reg[MT2063_REG_FIFFC] + 640);
+	state->AS_Data.f_if1_bw = MT2063_IF1_BW;
+	state->AS_Data.f_out = 43750000UL;
+	state->AS_Data.f_out_bw = 6750000UL;
+	state->AS_Data.f_zif_bw = MT2063_ZIF_BW;
+	state->AS_Data.f_LO1_Step = state->AS_Data.f_ref / 64;
+	state->AS_Data.f_LO2_Step = MT2063_TUNE_STEP_SIZE;
+	state->AS_Data.maxH1 = MT2063_MAX_HARMONICS_1;
+	state->AS_Data.maxH2 = MT2063_MAX_HARMONICS_2;
+	state->AS_Data.f_min_LO_Separation = MT2063_MIN_LO_SEP;
+	state->AS_Data.f_if1_Request = state->AS_Data.f_if1_Center;
+	state->AS_Data.f_LO1 = 2181000000UL;
+	state->AS_Data.f_LO2 = 1486249786UL;
+	state->f_IF1_actual = state->AS_Data.f_if1_Center;
+	state->AS_Data.f_in = state->AS_Data.f_LO1 - state->f_IF1_actual;
+	state->AS_Data.f_LO1_FracN_Avoid = MT2063_LO1_FRACN_AVOID;
+	state->AS_Data.f_LO2_FracN_Avoid = MT2063_LO2_FRACN_AVOID;
+	state->num_regs = MT2063_REG_END_REGS;
+	state->AS_Data.avoidDECT = MT2063_AVOID_BOTH;
+	state->ctfilt_sw = 0;
+
+	state->CTFiltMax[0] = 69230000;
+	state->CTFiltMax[1] = 105770000;
+	state->CTFiltMax[2] = 140350000;
+	state->CTFiltMax[3] = 177110000;
+	state->CTFiltMax[4] = 212860000;
+	state->CTFiltMax[5] = 241130000;
+	state->CTFiltMax[6] = 274370000;
+	state->CTFiltMax[7] = 309820000;
+	state->CTFiltMax[8] = 342450000;
+	state->CTFiltMax[9] = 378870000;
+	state->CTFiltMax[10] = 416210000;
+	state->CTFiltMax[11] = 456500000;
+	state->CTFiltMax[12] = 495790000;
+	state->CTFiltMax[13] = 534530000;
+	state->CTFiltMax[14] = 572610000;
+	state->CTFiltMax[15] = 598970000;
+	state->CTFiltMax[16] = 635910000;
+	state->CTFiltMax[17] = 672130000;
+	state->CTFiltMax[18] = 714840000;
+	state->CTFiltMax[19] = 739660000;
+	state->CTFiltMax[20] = 770410000;
+	state->CTFiltMax[21] = 814660000;
+	state->CTFiltMax[22] = 846950000;
+	state->CTFiltMax[23] = 867820000;
+	state->CTFiltMax[24] = 915980000;
+	state->CTFiltMax[25] = 947450000;
+	state->CTFiltMax[26] = 983110000;
+	state->CTFiltMax[27] = 1021630000;
+	state->CTFiltMax[28] = 1061870000;
+	state->CTFiltMax[29] = 1098330000;
+	state->CTFiltMax[30] = 1138990000;
 
 	/*
 	 **   Fetch the FCU osc value and use it and the fRef value to
 	 **   scale all of the Band Max values
 	 */
 
-	pInfo->reg[MT2063_REG_CTUNE_CTRL] = 0x0A;
-	status = MT2063_WriteSub(pInfo,
+	state->reg[MT2063_REG_CTUNE_CTRL] = 0x0A;
+	status = MT2063_WriteSub(state,
 				 MT2063_REG_CTUNE_CTRL,
-				 &pInfo->reg[MT2063_REG_CTUNE_CTRL], 1);
+				 &state->reg[MT2063_REG_CTUNE_CTRL], 1);
 	if (status < 0)
 		return status;
 	/*  Read the ClearTune filter calibration value  */
-	status = MT2063_ReadSub(pInfo,
+	status = MT2063_ReadSub(state,
 			        MT2063_REG_FIFFC,
-			        &pInfo->reg[MT2063_REG_FIFFC], 1);
+			        &state->reg[MT2063_REG_FIFFC], 1);
 	if (status < 0)
 		return status;
 
-	fcu_osc = pInfo->reg[MT2063_REG_FIFFC];
+	fcu_osc = state->reg[MT2063_REG_FIFFC];
 
-	pInfo->reg[MT2063_REG_CTUNE_CTRL] = 0x00;
-	status = MT2063_WriteSub(pInfo,
+	state->reg[MT2063_REG_CTUNE_CTRL] = 0x00;
+	status = MT2063_WriteSub(state,
 				 MT2063_REG_CTUNE_CTRL,
-				 &pInfo->reg[MT2063_REG_CTUNE_CTRL], 1);
+				 &state->reg[MT2063_REG_CTUNE_CTRL], 1);
 	if (status < 0)
 		return status;
 
 	/*  Adjust each of the values in the ClearTune filter cross-over table  */
 	for (i = 0; i < 31; i++)
-		pInfo->CTFiltMax[i] =(pInfo->CTFiltMax[i] / 768) * (fcu_osc + 640);
+		state->CTFiltMax[i] =(state->CTFiltMax[i] / 768) * (fcu_osc + 640);
 
 	return (status);
 }
@@ -3070,7 +3070,7 @@ static u32 MT2063_ReInit(struct mt2063_state *pInfo)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-static u32 MT2063_SetParam(struct mt2063_state *pInfo,
+static u32 MT2063_SetParam(struct mt2063_state *state,
 		           enum MT2063_Param param,
 			   enum MT2063_DNC_Output_Enable nValue)
 {
@@ -3080,18 +3080,18 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 	switch (param) {
 		/*  crystal frequency                     */
 	case MT2063_SRO_FREQ:
-		pInfo->AS_Data.f_ref = nValue;
-		pInfo->AS_Data.f_LO1_FracN_Avoid = 0;
-		pInfo->AS_Data.f_LO2_FracN_Avoid = nValue / 80 - 1;
-		pInfo->AS_Data.f_LO1_Step = nValue / 64;
-		pInfo->AS_Data.f_if1_Center =
-		    (pInfo->AS_Data.f_ref / 8) *
-		    (pInfo->reg[MT2063_REG_FIFFC] + 640);
+		state->AS_Data.f_ref = nValue;
+		state->AS_Data.f_LO1_FracN_Avoid = 0;
+		state->AS_Data.f_LO2_FracN_Avoid = nValue / 80 - 1;
+		state->AS_Data.f_LO1_Step = nValue / 64;
+		state->AS_Data.f_if1_Center =
+		    (state->AS_Data.f_ref / 8) *
+		    (state->reg[MT2063_REG_FIFFC] + 640);
 		break;
 
 		/*  minimum tuning step size              */
 	case MT2063_STEPSIZE:
-		pInfo->AS_Data.f_LO2_Step = nValue;
+		state->AS_Data.f_LO2_Step = nValue;
 		break;
 
 		/*  LO1 frequency                         */
@@ -3107,11 +3107,11 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 
 			/* Buffer the queue for restoration later and get actual LO2 values. */
 			status |=
-			    MT2063_ReadSub(pInfo,
+			    MT2063_ReadSub(state,
 					   MT2063_REG_LO2CQ_1,
 					   &(tempLO2CQ[0]), 3);
 			status |=
-			    MT2063_ReadSub(pInfo,
+			    MT2063_ReadSub(state,
 					   MT2063_REG_LO2C_1,
 					   &(tempLO2C[0]), 3);
 
@@ -3125,17 +3125,17 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 			    (tempLO2CQ[2] != tempLO2C[2])) {
 				/* put actual LO2 value into queue (with 0 in one-shot bits) */
 				status |=
-				    MT2063_WriteSub(pInfo,
+				    MT2063_WriteSub(state,
 						    MT2063_REG_LO2CQ_1,
 						    &(tempLO2C[0]), 3);
 
 				if (status == 0) {
 					/* cache the bytes just written. */
-					pInfo->reg[MT2063_REG_LO2CQ_1] =
+					state->reg[MT2063_REG_LO2CQ_1] =
 					    tempLO2C[0];
-					pInfo->reg[MT2063_REG_LO2CQ_2] =
+					state->reg[MT2063_REG_LO2CQ_2] =
 					    tempLO2C[1];
-					pInfo->reg[MT2063_REG_LO2CQ_3] =
+					state->reg[MT2063_REG_LO2CQ_3] =
 					    tempLO2C[2];
 				}
 				restore = 1;
@@ -3144,23 +3144,23 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 			/* Calculate the Divider and Numberator components of LO1 */
 			status =
 			    MT2063_CalcLO1Mult(&Div, &FracN, nValue,
-					       pInfo->AS_Data.f_ref /
+					       state->AS_Data.f_ref /
 					       64,
-					       pInfo->AS_Data.f_ref);
-			pInfo->reg[MT2063_REG_LO1CQ_1] =
+					       state->AS_Data.f_ref);
+			state->reg[MT2063_REG_LO1CQ_1] =
 			    (u8) (Div & 0x00FF);
-			pInfo->reg[MT2063_REG_LO1CQ_2] =
+			state->reg[MT2063_REG_LO1CQ_2] =
 			    (u8) (FracN);
 			status |=
-			    MT2063_WriteSub(pInfo,
+			    MT2063_WriteSub(state,
 					    MT2063_REG_LO1CQ_1,
-					    &pInfo->
+					    &state->
 					    reg[MT2063_REG_LO1CQ_1], 2);
 
 			/* set the one-shot bit to load the pair of LO values */
 			tmpOneShot = tempLO2CQ[2] | 0xE0;
 			status |=
-			    MT2063_WriteSub(pInfo,
+			    MT2063_WriteSub(state,
 					    MT2063_REG_LO2CQ_3,
 					    &tmpOneShot, 1);
 
@@ -3168,43 +3168,43 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 			if (restore) {
 				/* put actual LO2 value into queue (0 in one-shot bits) */
 				status |=
-				    MT2063_WriteSub(pInfo,
+				    MT2063_WriteSub(state,
 						    MT2063_REG_LO2CQ_1,
 						    &(tempLO2CQ[0]), 3);
 
 				/* cache the bytes just written. */
-				pInfo->reg[MT2063_REG_LO2CQ_1] =
+				state->reg[MT2063_REG_LO2CQ_1] =
 				    tempLO2CQ[0];
-				pInfo->reg[MT2063_REG_LO2CQ_2] =
+				state->reg[MT2063_REG_LO2CQ_2] =
 				    tempLO2CQ[1];
-				pInfo->reg[MT2063_REG_LO2CQ_3] =
+				state->reg[MT2063_REG_LO2CQ_3] =
 				    tempLO2CQ[2];
 			}
 
-			MT2063_GetParam(pInfo,
+			MT2063_GetParam(state,
 					MT2063_LO1_FREQ,
-					&pInfo->AS_Data.f_LO1);
+					&state->AS_Data.f_LO1);
 		}
 		break;
 
 		/*  LO1 minimum step size                 */
 	case MT2063_LO1_STEPSIZE:
-		pInfo->AS_Data.f_LO1_Step = nValue;
+		state->AS_Data.f_LO1_Step = nValue;
 		break;
 
 		/*  LO1 FracN keep-out region             */
 	case MT2063_LO1_FRACN_AVOID_PARAM:
-		pInfo->AS_Data.f_LO1_FracN_Avoid = nValue;
+		state->AS_Data.f_LO1_FracN_Avoid = nValue;
 		break;
 
 		/*  Requested 1st IF                      */
 	case MT2063_IF1_REQUEST:
-		pInfo->AS_Data.f_if1_Request = nValue;
+		state->AS_Data.f_if1_Request = nValue;
 		break;
 
 		/*  zero-IF bandwidth                     */
 	case MT2063_ZIF_BW:
-		pInfo->AS_Data.f_zif_bw = nValue;
+		state->AS_Data.f_zif_bw = nValue;
 		break;
 
 		/*  LO2 frequency                         */
@@ -3221,11 +3221,11 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 
 			/* Buffer the queue for restoration later and get actual LO2 values. */
 			status |=
-			    MT2063_ReadSub(pInfo,
+			    MT2063_ReadSub(state,
 					   MT2063_REG_LO1CQ_1,
 					   &(tempLO1CQ[0]), 2);
 			status |=
-			    MT2063_ReadSub(pInfo,
+			    MT2063_ReadSub(state,
 					   MT2063_REG_LO1C_1,
 					   &(tempLO1C[0]), 2);
 
@@ -3234,14 +3234,14 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 			    || (tempLO1CQ[1] != tempLO1C[1])) {
 				/* put actual LO1 value into queue */
 				status |=
-				    MT2063_WriteSub(pInfo,
+				    MT2063_WriteSub(state,
 						    MT2063_REG_LO1CQ_1,
 						    &(tempLO1C[0]), 2);
 
 				/* cache the bytes just written. */
-				pInfo->reg[MT2063_REG_LO1CQ_1] =
+				state->reg[MT2063_REG_LO1CQ_1] =
 				    tempLO1C[0];
-				pInfo->reg[MT2063_REG_LO1CQ_2] =
+				state->reg[MT2063_REG_LO1CQ_2] =
 				    tempLO1C[1];
 				restore = 1;
 			}
@@ -3249,27 +3249,27 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 			/* Calculate the Divider and Numberator components of LO2 */
 			status =
 			    MT2063_CalcLO2Mult(&Div2, &FracN2, nValue,
-					       pInfo->AS_Data.f_ref /
+					       state->AS_Data.f_ref /
 					       8191,
-					       pInfo->AS_Data.f_ref);
-			pInfo->reg[MT2063_REG_LO2CQ_1] =
+					       state->AS_Data.f_ref);
+			state->reg[MT2063_REG_LO2CQ_1] =
 			    (u8) ((Div2 << 1) |
 				      ((FracN2 >> 12) & 0x01)) & 0xFF;
-			pInfo->reg[MT2063_REG_LO2CQ_2] =
+			state->reg[MT2063_REG_LO2CQ_2] =
 			    (u8) ((FracN2 >> 4) & 0xFF);
-			pInfo->reg[MT2063_REG_LO2CQ_3] =
+			state->reg[MT2063_REG_LO2CQ_3] =
 			    (u8) ((FracN2 & 0x0F));
 			status |=
-			    MT2063_WriteSub(pInfo,
+			    MT2063_WriteSub(state,
 					    MT2063_REG_LO1CQ_1,
-					    &pInfo->
+					    &state->
 					    reg[MT2063_REG_LO1CQ_1], 3);
 
 			/* set the one-shot bit to load the LO values */
 			tmpOneShot =
-			    pInfo->reg[MT2063_REG_LO2CQ_3] | 0xE0;
+			    state->reg[MT2063_REG_LO2CQ_3] | 0xE0;
 			status |=
-			    MT2063_WriteSub(pInfo,
+			    MT2063_WriteSub(state,
 					    MT2063_REG_LO2CQ_3,
 					    &tmpOneShot, 1);
 
@@ -3277,61 +3277,61 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 			if (restore) {
 				/* put previous LO1 queue value back into queue */
 				status |=
-				    MT2063_WriteSub(pInfo,
+				    MT2063_WriteSub(state,
 						    MT2063_REG_LO1CQ_1,
 						    &(tempLO1CQ[0]), 2);
 
 				/* cache the bytes just written. */
-				pInfo->reg[MT2063_REG_LO1CQ_1] =
+				state->reg[MT2063_REG_LO1CQ_1] =
 				    tempLO1CQ[0];
-				pInfo->reg[MT2063_REG_LO1CQ_2] =
+				state->reg[MT2063_REG_LO1CQ_2] =
 				    tempLO1CQ[1];
 			}
 
-			MT2063_GetParam(pInfo,
+			MT2063_GetParam(state,
 					MT2063_LO2_FREQ,
-					&pInfo->AS_Data.f_LO2);
+					&state->AS_Data.f_LO2);
 		}
 		break;
 
 		/*  LO2 minimum step size                 */
 	case MT2063_LO2_STEPSIZE:
-		pInfo->AS_Data.f_LO2_Step = nValue;
+		state->AS_Data.f_LO2_Step = nValue;
 		break;
 
 		/*  LO2 FracN keep-out region             */
 	case MT2063_LO2_FRACN_AVOID:
-		pInfo->AS_Data.f_LO2_FracN_Avoid = nValue;
+		state->AS_Data.f_LO2_FracN_Avoid = nValue;
 		break;
 
 		/*  output center frequency               */
 	case MT2063_OUTPUT_FREQ:
-		pInfo->AS_Data.f_out = nValue;
+		state->AS_Data.f_out = nValue;
 		break;
 
 		/*  output bandwidth                      */
 	case MT2063_OUTPUT_BW:
-		pInfo->AS_Data.f_out_bw = nValue + 750000;
+		state->AS_Data.f_out_bw = nValue + 750000;
 		break;
 
 		/*  min inter-tuner LO separation         */
 	case MT2063_LO_SEPARATION:
-		pInfo->AS_Data.f_min_LO_Separation = nValue;
+		state->AS_Data.f_min_LO_Separation = nValue;
 		break;
 
 		/*  max # of intra-tuner harmonics        */
 	case MT2063_MAX_HARM1:
-		pInfo->AS_Data.maxH1 = nValue;
+		state->AS_Data.maxH1 = nValue;
 		break;
 
 		/*  max # of inter-tuner harmonics        */
 	case MT2063_MAX_HARM2:
-		pInfo->AS_Data.maxH2 = nValue;
+		state->AS_Data.maxH2 = nValue;
 		break;
 
 	case MT2063_RCVR_MODE:
 		status |=
-		    MT2063_SetReceiverMode(pInfo,
+		    MT2063_SetReceiverMode(state,
 					   (enum MT2063_RCVR_MODES)
 					   nValue);
 		break;
@@ -3339,12 +3339,12 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 		/* Set LNA Rin -- nValue is desired value */
 	case MT2063_LNA_RIN:
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_CTRL_2C] & (u8) ~ 0x03) |
 		    (nValue & 0x03);
-		if (pInfo->reg[MT2063_REG_CTRL_2C] != val) {
+		if (state->reg[MT2063_REG_CTRL_2C] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_CTRL_2C,
+			    MT2063_SetReg(state, MT2063_REG_CTRL_2C,
 					  val);
 		}
 		break;
@@ -3352,12 +3352,12 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 		/* Set target power level at LNA -- nValue is desired value */
 	case MT2063_LNA_TGT:
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x3F) |
 		    (nValue & 0x3F);
-		if (pInfo->reg[MT2063_REG_LNA_TGT] != val) {
+		if (state->reg[MT2063_REG_LNA_TGT] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_LNA_TGT,
+			    MT2063_SetReg(state, MT2063_REG_LNA_TGT,
 					  val);
 		}
 		break;
@@ -3365,12 +3365,12 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 		/* Set target power level at PD1 -- nValue is desired value */
 	case MT2063_PD1_TGT:
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x3F) |
 		    (nValue & 0x3F);
-		if (pInfo->reg[MT2063_REG_PD1_TGT] != val) {
+		if (state->reg[MT2063_REG_PD1_TGT] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_PD1_TGT,
+			    MT2063_SetReg(state, MT2063_REG_PD1_TGT,
 					  val);
 		}
 		break;
@@ -3378,12 +3378,12 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 		/* Set target power level at PD2 -- nValue is desired value */
 	case MT2063_PD2_TGT:
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_PD2_TGT] & (u8) ~ 0x3F) |
 		    (nValue & 0x3F);
-		if (pInfo->reg[MT2063_REG_PD2_TGT] != val) {
+		if (state->reg[MT2063_REG_PD2_TGT] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_PD2_TGT,
+			    MT2063_SetReg(state, MT2063_REG_PD2_TGT,
 					  val);
 		}
 		break;
@@ -3391,13 +3391,13 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 		/* Set LNA atten limit -- nValue is desired value */
 	case MT2063_ACLNA_MAX:
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_LNA_OV] & (u8) ~ 0x1F) | (nValue
 								  &
 								  0x1F);
-		if (pInfo->reg[MT2063_REG_LNA_OV] != val) {
+		if (state->reg[MT2063_REG_LNA_OV] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_LNA_OV,
+			    MT2063_SetReg(state, MT2063_REG_LNA_OV,
 					  val);
 		}
 		break;
@@ -3405,29 +3405,29 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 		/* Set RF atten limit -- nValue is desired value */
 	case MT2063_ACRF_MAX:
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_RF_OV] & (u8) ~ 0x1F) | (nValue
 								 &
 								 0x1F);
-		if (pInfo->reg[MT2063_REG_RF_OV] != val) {
+		if (state->reg[MT2063_REG_RF_OV] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_RF_OV, val);
+			    MT2063_SetReg(state, MT2063_REG_RF_OV, val);
 		}
 		break;
 
 		/* Set FIF atten limit -- nValue is desired value, max. 5 if no B3 */
 	case MT2063_ACFIF_MAX:
-		if (pInfo->reg[MT2063_REG_PART_REV] != MT2063_B3
+		if (state->reg[MT2063_REG_PART_REV] != MT2063_B3
 		    && nValue > 5)
 			nValue = 5;
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_FIF_OV] & (u8) ~ 0x1F) | (nValue
 								  &
 								  0x1F);
-		if (pInfo->reg[MT2063_REG_FIF_OV] != val) {
+		if (state->reg[MT2063_REG_FIF_OV] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_FIF_OV,
+			    MT2063_SetReg(state, MT2063_REG_FIF_OV,
 					  val);
 		}
 		break;
@@ -3437,27 +3437,27 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 		switch (nValue) {
 		case MT2063_DNC_NONE:
 			{
-				val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
-				if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
+				val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
+				if (state->reg[MT2063_REG_DNC_GAIN] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_DNC_GAIN,
 							  val);
 
-				val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
-				if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
+				val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
+				if (state->reg[MT2063_REG_VGA_GAIN] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_VGA_GAIN,
 							  val);
 
-				val = (pInfo->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
-				if (pInfo->reg[MT2063_REG_RSVD_20] !=
+				val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
+				if (state->reg[MT2063_REG_RSVD_20] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_RSVD_20,
 							  val);
 
@@ -3465,27 +3465,27 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 			}
 		case MT2063_DNC_1:
 			{
-				val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
-				if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
+				val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
+				if (state->reg[MT2063_REG_DNC_GAIN] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_DNC_GAIN,
 							  val);
 
-				val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
-				if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
+				val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
+				if (state->reg[MT2063_REG_VGA_GAIN] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_VGA_GAIN,
 							  val);
 
-				val = (pInfo->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
-				if (pInfo->reg[MT2063_REG_RSVD_20] !=
+				val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
+				if (state->reg[MT2063_REG_RSVD_20] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_RSVD_20,
 							  val);
 
@@ -3493,27 +3493,27 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 			}
 		case MT2063_DNC_2:
 			{
-				val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
-				if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
+				val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
+				if (state->reg[MT2063_REG_DNC_GAIN] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_DNC_GAIN,
 							  val);
 
-				val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
-				if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
+				val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
+				if (state->reg[MT2063_REG_VGA_GAIN] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_VGA_GAIN,
 							  val);
 
-				val = (pInfo->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
-				if (pInfo->reg[MT2063_REG_RSVD_20] !=
+				val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
+				if (state->reg[MT2063_REG_RSVD_20] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_RSVD_20,
 							  val);
 
@@ -3521,27 +3521,27 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 			}
 		case MT2063_DNC_BOTH:
 			{
-				val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
-				if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
+				val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
+				if (state->reg[MT2063_REG_DNC_GAIN] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_DNC_GAIN,
 							  val);
 
-				val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
-				if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
+				val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
+				if (state->reg[MT2063_REG_VGA_GAIN] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_VGA_GAIN,
 							  val);
 
-				val = (pInfo->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
-				if (pInfo->reg[MT2063_REG_RSVD_20] !=
+				val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
+				if (state->reg[MT2063_REG_RSVD_20] !=
 				    val)
 					status |=
-					    MT2063_SetReg(pInfo,
+					    MT2063_SetReg(state,
 							  MT2063_REG_RSVD_20,
 							  val);
 
@@ -3555,12 +3555,12 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 	case MT2063_VGAGC:
 		/* Set VGA gain code */
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_VGA_GAIN] & (u8) ~ 0x0C) |
 		    ((nValue & 0x03) << 2);
-		if (pInfo->reg[MT2063_REG_VGA_GAIN] != val) {
+		if (state->reg[MT2063_REG_VGA_GAIN] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_VGA_GAIN,
+			    MT2063_SetReg(state, MT2063_REG_VGA_GAIN,
 					  val);
 		}
 		break;
@@ -3568,12 +3568,12 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 	case MT2063_VGAOI:
 		/* Set VGA bias current */
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_RSVD_31] & (u8) ~ 0x07) |
 		    (nValue & 0x07);
-		if (pInfo->reg[MT2063_REG_RSVD_31] != val) {
+		if (state->reg[MT2063_REG_RSVD_31] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_RSVD_31,
+			    MT2063_SetReg(state, MT2063_REG_RSVD_31,
 					  val);
 		}
 		break;
@@ -3581,12 +3581,12 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 	case MT2063_TAGC:
 		/* Set TAGC */
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_RSVD_1E] & (u8) ~ 0x03) |
 		    (nValue & 0x03);
-		if (pInfo->reg[MT2063_REG_RSVD_1E] != val) {
+		if (state->reg[MT2063_REG_RSVD_1E] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_RSVD_1E,
+			    MT2063_SetReg(state, MT2063_REG_RSVD_1E,
 					  val);
 		}
 		break;
@@ -3594,12 +3594,12 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 	case MT2063_AMPGC:
 		/* Set Amp gain code */
 		val =
-		    (pInfo->
+		    (state->
 		     reg[MT2063_REG_TEMP_SEL] & (u8) ~ 0x03) |
 		    (nValue & 0x03);
-		if (pInfo->reg[MT2063_REG_TEMP_SEL] != val) {
+		if (state->reg[MT2063_REG_TEMP_SEL] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_TEMP_SEL,
+			    MT2063_SetReg(state, MT2063_REG_TEMP_SEL,
 					  val);
 		}
 		break;
@@ -3612,7 +3612,7 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 			if ((newAvoidSetting >=
 			     MT2063_NO_DECT_AVOIDANCE)
 			    && (newAvoidSetting <= MT2063_AVOID_BOTH)) {
-				pInfo->AS_Data.avoidDECT =
+				state->AS_Data.avoidDECT =
 				    newAvoidSetting;
 			}
 		}
@@ -3620,7 +3620,7 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 
 		/*  Cleartune filter selection: 0 - by IC (default), 1 - by software  */
 	case MT2063_CTFILT_SW:
-		pInfo->ctfilt_sw = (nValue & 0x01);
+		state->ctfilt_sw = (nValue & 0x01);
 		break;
 
 		/*  These parameters are read-only  */
@@ -3673,24 +3673,24 @@ static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *pInfo, enum MT2063_Mask_Bits Bits)
+static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state, enum MT2063_Mask_Bits Bits)
 {
 	u32 status = 0;	/* Status to be returned        */
 
 	Bits = (enum MT2063_Mask_Bits)(Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
 	if ((Bits & 0xFF00) != 0) {
-		pInfo->reg[MT2063_REG_PWR_2] &= ~(u8) (Bits >> 8);
+		state->reg[MT2063_REG_PWR_2] &= ~(u8) (Bits >> 8);
 		status |=
-		    MT2063_WriteSub(pInfo,
+		    MT2063_WriteSub(state,
 				    MT2063_REG_PWR_2,
-				    &pInfo->reg[MT2063_REG_PWR_2], 1);
+				    &state->reg[MT2063_REG_PWR_2], 1);
 	}
 	if ((Bits & 0xFF) != 0) {
-		pInfo->reg[MT2063_REG_PWR_1] &= ~(u8) (Bits & 0xFF);
+		state->reg[MT2063_REG_PWR_1] &= ~(u8) (Bits & 0xFF);
 		status |=
-		    MT2063_WriteSub(pInfo,
+		    MT2063_WriteSub(state,
 				    MT2063_REG_PWR_1,
-				    &pInfo->reg[MT2063_REG_PWR_1], 1);
+				    &state->reg[MT2063_REG_PWR_1], 1);
 	}
 
 	return (status);
@@ -3724,34 +3724,34 @@ static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *pInfo, enum MT2063_Mas
 **                              correct wakeup of the LNA
 **
 ****************************************************************************/
-static u32 MT2063_SoftwareShutdown(struct mt2063_state *pInfo, u8 Shutdown)
+static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
 {
 	u32 status = 0;	/* Status to be returned        */
 
 	if (Shutdown == 1)
-		pInfo->reg[MT2063_REG_PWR_1] |= 0x04;	/* Turn the bit on */
+		state->reg[MT2063_REG_PWR_1] |= 0x04;	/* Turn the bit on */
 	else
-		pInfo->reg[MT2063_REG_PWR_1] &= ~0x04;	/* Turn off the bit */
+		state->reg[MT2063_REG_PWR_1] &= ~0x04;	/* Turn off the bit */
 
 	status |=
-	    MT2063_WriteSub(pInfo,
+	    MT2063_WriteSub(state,
 			    MT2063_REG_PWR_1,
-			    &pInfo->reg[MT2063_REG_PWR_1], 1);
+			    &state->reg[MT2063_REG_PWR_1], 1);
 
 	if (Shutdown != 1) {
-		pInfo->reg[MT2063_REG_BYP_CTRL] =
-		    (pInfo->reg[MT2063_REG_BYP_CTRL] & 0x9F) | 0x40;
+		state->reg[MT2063_REG_BYP_CTRL] =
+		    (state->reg[MT2063_REG_BYP_CTRL] & 0x9F) | 0x40;
 		status |=
-		    MT2063_WriteSub(pInfo,
+		    MT2063_WriteSub(state,
 				    MT2063_REG_BYP_CTRL,
-				    &pInfo->reg[MT2063_REG_BYP_CTRL],
+				    &state->reg[MT2063_REG_BYP_CTRL],
 				    1);
-		pInfo->reg[MT2063_REG_BYP_CTRL] =
-		    (pInfo->reg[MT2063_REG_BYP_CTRL] & 0x9F);
+		state->reg[MT2063_REG_BYP_CTRL] =
+		    (state->reg[MT2063_REG_BYP_CTRL] & 0x9F);
 		status |=
-		    MT2063_WriteSub(pInfo,
+		    MT2063_WriteSub(state,
 				    MT2063_REG_BYP_CTRL,
-				    &pInfo->reg[MT2063_REG_BYP_CTRL],
+				    &state->reg[MT2063_REG_BYP_CTRL],
 				    1);
 	}
 
@@ -3786,17 +3786,17 @@ static u32 MT2063_SoftwareShutdown(struct mt2063_state *pInfo, u8 Shutdown)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_SetReg(struct mt2063_state *pInfo, u8 reg, u8 val)
+static u32 MT2063_SetReg(struct mt2063_state *state, u8 reg, u8 val)
 {
 	u32 status = 0;	/* Status to be returned        */
 
 	if (reg >= MT2063_REG_END_REGS)
 		status |= -ERANGE;
 
-	status = MT2063_WriteSub(pInfo, reg, &val,
+	status = MT2063_WriteSub(state, reg, &val,
 			         1);
 	if (status >= 0)
-		pInfo->reg[reg] = val;
+		state->reg[reg] = val;
 
 	return (status);
 }
@@ -3942,7 +3942,7 @@ static u32 MT2063_CalcLO2Mult(u32 * Div,
 **  Description:    Calculate the corrrect ClearTune filter to be used for
 **                  a given input frequency.
 **
-**  Parameters:     pInfo       - ptr to tuner data structure
+**  Parameters:     state       - ptr to tuner data structure
 **                  f_in        - RF input center frequency (in Hz).
 **
 **  Returns:        ClearTune filter number (0-31)
@@ -3957,7 +3957,7 @@ static u32 MT2063_CalcLO2Mult(u32 * Div,
 **                                        cross-over frequency values.
 **
 ****************************************************************************/
-static u32 FindClearTuneFilter(struct mt2063_state *pInfo, u32 f_in)
+static u32 FindClearTuneFilter(struct mt2063_state *state, u32 f_in)
 {
 	u32 RFBand;
 	u32 idx;		/*  index loop                      */
@@ -3967,7 +3967,7 @@ static u32 FindClearTuneFilter(struct mt2063_state *pInfo, u32 f_in)
 	 */
 	RFBand = 31;		/*  def when f_in > all    */
 	for (idx = 0; idx < 31; ++idx) {
-		if (pInfo->CTFiltMax[idx] >= f_in) {
+		if (state->CTFiltMax[idx] >= f_in) {
 			RFBand = idx;
 			break;
 		}
@@ -4016,7 +4016,7 @@ static u32 FindClearTuneFilter(struct mt2063_state *pInfo, u32 f_in)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-static u32 MT2063_Tune(struct mt2063_state *pInfo, u32 f_in)
+static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 {				/* RF input center frequency   */
 
 	u32 status = 0;	/*  status of operation             */
@@ -4038,35 +4038,35 @@ static u32 MT2063_Tune(struct mt2063_state *pInfo, u32 f_in)
 	if ((f_in < MT2063_MIN_FIN_FREQ) || (f_in > MT2063_MAX_FIN_FREQ))
 		return -EINVAL;
 
-	if ((pInfo->AS_Data.f_out < MT2063_MIN_FOUT_FREQ)
-	    || (pInfo->AS_Data.f_out > MT2063_MAX_FOUT_FREQ))
+	if ((state->AS_Data.f_out < MT2063_MIN_FOUT_FREQ)
+	    || (state->AS_Data.f_out > MT2063_MAX_FOUT_FREQ))
 		return -EINVAL;
 
 	/*
 	 **  Save original LO1 and LO2 register values
 	 */
-	ofLO1 = pInfo->AS_Data.f_LO1;
-	ofLO2 = pInfo->AS_Data.f_LO2;
-	ofin = pInfo->AS_Data.f_in;
-	ofout = pInfo->AS_Data.f_out;
+	ofLO1 = state->AS_Data.f_LO1;
+	ofLO2 = state->AS_Data.f_LO2;
+	ofin = state->AS_Data.f_in;
+	ofout = state->AS_Data.f_out;
 
 	/*
 	 **  Find and set RF Band setting
 	 */
-	if (pInfo->ctfilt_sw == 1) {
-		val = (pInfo->reg[MT2063_REG_CTUNE_CTRL] | 0x08);
-		if (pInfo->reg[MT2063_REG_CTUNE_CTRL] != val) {
+	if (state->ctfilt_sw == 1) {
+		val = (state->reg[MT2063_REG_CTUNE_CTRL] | 0x08);
+		if (state->reg[MT2063_REG_CTUNE_CTRL] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_CTUNE_CTRL, val);
+			    MT2063_SetReg(state, MT2063_REG_CTUNE_CTRL, val);
 		}
-		val = pInfo->reg[MT2063_REG_CTUNE_OV];
-		RFBand = FindClearTuneFilter(pInfo, f_in);
-		pInfo->reg[MT2063_REG_CTUNE_OV] =
-		    (u8) ((pInfo->reg[MT2063_REG_CTUNE_OV] & ~0x1F)
+		val = state->reg[MT2063_REG_CTUNE_OV];
+		RFBand = FindClearTuneFilter(state, f_in);
+		state->reg[MT2063_REG_CTUNE_OV] =
+		    (u8) ((state->reg[MT2063_REG_CTUNE_OV] & ~0x1F)
 			      | RFBand);
-		if (pInfo->reg[MT2063_REG_CTUNE_OV] != val) {
+		if (state->reg[MT2063_REG_CTUNE_OV] != val) {
 			status |=
-			    MT2063_SetReg(pInfo, MT2063_REG_CTUNE_OV, val);
+			    MT2063_SetReg(state, MT2063_REG_CTUNE_OV, val);
 		}
 	}
 
@@ -4075,77 +4075,77 @@ static u32 MT2063_Tune(struct mt2063_state *pInfo, u32 f_in)
 	 */
 	if (status >= 0) {
 		status |=
-		    MT2063_ReadSub(pInfo,
+		    MT2063_ReadSub(state,
 				   MT2063_REG_FIFFC,
-				   &pInfo->reg[MT2063_REG_FIFFC], 1);
-		fiffc = pInfo->reg[MT2063_REG_FIFFC];
+				   &state->reg[MT2063_REG_FIFFC], 1);
+		fiffc = state->reg[MT2063_REG_FIFFC];
 	}
 	/*
 	 **  Assign in the requested values
 	 */
-	pInfo->AS_Data.f_in = f_in;
+	state->AS_Data.f_in = f_in;
 	/*  Request a 1st IF such that LO1 is on a step size */
-	pInfo->AS_Data.f_if1_Request =
-	    MT2063_Round_fLO(pInfo->AS_Data.f_if1_Request + f_in,
-			     pInfo->AS_Data.f_LO1_Step,
-			     pInfo->AS_Data.f_ref) - f_in;
+	state->AS_Data.f_if1_Request =
+	    MT2063_Round_fLO(state->AS_Data.f_if1_Request + f_in,
+			     state->AS_Data.f_LO1_Step,
+			     state->AS_Data.f_ref) - f_in;
 
 	/*
 	 **  Calculate frequency settings.  f_IF1_FREQ + f_in is the
 	 **  desired LO1 frequency
 	 */
-	MT2063_ResetExclZones(&pInfo->AS_Data);
+	MT2063_ResetExclZones(&state->AS_Data);
 
-	f_IF1 = MT2063_ChooseFirstIF(&pInfo->AS_Data);
+	f_IF1 = MT2063_ChooseFirstIF(&state->AS_Data);
 
-	pInfo->AS_Data.f_LO1 =
-	    MT2063_Round_fLO(f_IF1 + f_in, pInfo->AS_Data.f_LO1_Step,
-			     pInfo->AS_Data.f_ref);
+	state->AS_Data.f_LO1 =
+	    MT2063_Round_fLO(f_IF1 + f_in, state->AS_Data.f_LO1_Step,
+			     state->AS_Data.f_ref);
 
-	pInfo->AS_Data.f_LO2 =
-	    MT2063_Round_fLO(pInfo->AS_Data.f_LO1 - pInfo->AS_Data.f_out - f_in,
-			     pInfo->AS_Data.f_LO2_Step, pInfo->AS_Data.f_ref);
+	state->AS_Data.f_LO2 =
+	    MT2063_Round_fLO(state->AS_Data.f_LO1 - state->AS_Data.f_out - f_in,
+			     state->AS_Data.f_LO2_Step, state->AS_Data.f_ref);
 
 	/*
 	 ** Check for any LO spurs in the output bandwidth and adjust
 	 ** the LO settings to avoid them if needed
 	 */
-	status |= MT2063_AvoidSpurs(pInfo, &pInfo->AS_Data);
+	status |= MT2063_AvoidSpurs(state, &state->AS_Data);
 	/*
 	 ** MT_AvoidSpurs spurs may have changed the LO1 & LO2 values.
 	 ** Recalculate the LO frequencies and the values to be placed
 	 ** in the tuning registers.
 	 */
-	pInfo->AS_Data.f_LO1 =
-	    MT2063_CalcLO1Mult(&LO1, &Num1, pInfo->AS_Data.f_LO1,
-			       pInfo->AS_Data.f_LO1_Step, pInfo->AS_Data.f_ref);
-	pInfo->AS_Data.f_LO2 =
-	    MT2063_Round_fLO(pInfo->AS_Data.f_LO1 - pInfo->AS_Data.f_out - f_in,
-			     pInfo->AS_Data.f_LO2_Step, pInfo->AS_Data.f_ref);
-	pInfo->AS_Data.f_LO2 =
-	    MT2063_CalcLO2Mult(&LO2, &Num2, pInfo->AS_Data.f_LO2,
-			       pInfo->AS_Data.f_LO2_Step, pInfo->AS_Data.f_ref);
+	state->AS_Data.f_LO1 =
+	    MT2063_CalcLO1Mult(&LO1, &Num1, state->AS_Data.f_LO1,
+			       state->AS_Data.f_LO1_Step, state->AS_Data.f_ref);
+	state->AS_Data.f_LO2 =
+	    MT2063_Round_fLO(state->AS_Data.f_LO1 - state->AS_Data.f_out - f_in,
+			     state->AS_Data.f_LO2_Step, state->AS_Data.f_ref);
+	state->AS_Data.f_LO2 =
+	    MT2063_CalcLO2Mult(&LO2, &Num2, state->AS_Data.f_LO2,
+			       state->AS_Data.f_LO2_Step, state->AS_Data.f_ref);
 
 	/*
 	 **  Check the upconverter and downconverter frequency ranges
 	 */
-	if ((pInfo->AS_Data.f_LO1 < MT2063_MIN_UPC_FREQ)
-	    || (pInfo->AS_Data.f_LO1 > MT2063_MAX_UPC_FREQ))
+	if ((state->AS_Data.f_LO1 < MT2063_MIN_UPC_FREQ)
+	    || (state->AS_Data.f_LO1 > MT2063_MAX_UPC_FREQ))
 		status |= MT2063_UPC_RANGE;
-	if ((pInfo->AS_Data.f_LO2 < MT2063_MIN_DNC_FREQ)
-	    || (pInfo->AS_Data.f_LO2 > MT2063_MAX_DNC_FREQ))
+	if ((state->AS_Data.f_LO2 < MT2063_MIN_DNC_FREQ)
+	    || (state->AS_Data.f_LO2 > MT2063_MAX_DNC_FREQ))
 		status |= MT2063_DNC_RANGE;
 	/*  LO2 Lock bit was in a different place for B0 version  */
-	if (pInfo->tuner_id == MT2063_B0)
+	if (state->tuner_id == MT2063_B0)
 		LO2LK = 0x40;
 
 	/*
 	 **  If we have the same LO frequencies and we're already locked,
 	 **  then skip re-programming the LO registers.
 	 */
-	if ((ofLO1 != pInfo->AS_Data.f_LO1)
-	    || (ofLO2 != pInfo->AS_Data.f_LO2)
-	    || ((pInfo->reg[MT2063_REG_LO_STATUS] & (LO1LK | LO2LK)) !=
+	if ((ofLO1 != state->AS_Data.f_LO1)
+	    || (ofLO2 != state->AS_Data.f_LO2)
+	    || ((state->reg[MT2063_REG_LO_STATUS] & (LO1LK | LO2LK)) !=
 		(LO1LK | LO2LK))) {
 		/*
 		 **  Calculate the FIFFOF register value
@@ -4155,8 +4155,8 @@ static u32 MT2063_Tune(struct mt2063_state *pInfo, u32 f_in)
 		 **             f_ref/64
 		 */
 		fiffof =
-		    (pInfo->AS_Data.f_LO1 -
-		     f_in) / (pInfo->AS_Data.f_ref / 64) - 8 * (u32) fiffc -
+		    (state->AS_Data.f_LO1 -
+		     f_in) / (state->AS_Data.f_ref / 64) - 8 * (u32) fiffc -
 		    4992;
 		if (fiffof > 0xFF)
 			fiffof = 0xFF;
@@ -4166,32 +4166,32 @@ static u32 MT2063_Tune(struct mt2063_state *pInfo, u32 f_in)
 		 **  register fields.
 		 */
 		if (status >= 0) {
-			pInfo->reg[MT2063_REG_LO1CQ_1] = (u8) (LO1 & 0xFF);	/* DIV1q */
-			pInfo->reg[MT2063_REG_LO1CQ_2] = (u8) (Num1 & 0x3F);	/* NUM1q */
-			pInfo->reg[MT2063_REG_LO2CQ_1] = (u8) (((LO2 & 0x7F) << 1)	/* DIV2q */
+			state->reg[MT2063_REG_LO1CQ_1] = (u8) (LO1 & 0xFF);	/* DIV1q */
+			state->reg[MT2063_REG_LO1CQ_2] = (u8) (Num1 & 0x3F);	/* NUM1q */
+			state->reg[MT2063_REG_LO2CQ_1] = (u8) (((LO2 & 0x7F) << 1)	/* DIV2q */
 								   |(Num2 >> 12));	/* NUM2q (hi) */
-			pInfo->reg[MT2063_REG_LO2CQ_2] = (u8) ((Num2 & 0x0FF0) >> 4);	/* NUM2q (mid) */
-			pInfo->reg[MT2063_REG_LO2CQ_3] = (u8) (0xE0 | (Num2 & 0x000F));	/* NUM2q (lo) */
+			state->reg[MT2063_REG_LO2CQ_2] = (u8) ((Num2 & 0x0FF0) >> 4);	/* NUM2q (mid) */
+			state->reg[MT2063_REG_LO2CQ_3] = (u8) (0xE0 | (Num2 & 0x000F));	/* NUM2q (lo) */
 
 			/*
 			 ** Now write out the computed register values
 			 ** IMPORTANT: There is a required order for writing
 			 **            (0x05 must follow all the others).
 			 */
-			status |= MT2063_WriteSub(pInfo, MT2063_REG_LO1CQ_1, &pInfo->reg[MT2063_REG_LO1CQ_1], 5);	/* 0x01 - 0x05 */
-			if (pInfo->tuner_id == MT2063_B0) {
+			status |= MT2063_WriteSub(state, MT2063_REG_LO1CQ_1, &state->reg[MT2063_REG_LO1CQ_1], 5);	/* 0x01 - 0x05 */
+			if (state->tuner_id == MT2063_B0) {
 				/* Re-write the one-shot bits to trigger the tune operation */
-				status |= MT2063_WriteSub(pInfo, MT2063_REG_LO2CQ_3, &pInfo->reg[MT2063_REG_LO2CQ_3], 1);	/* 0x05 */
+				status |= MT2063_WriteSub(state, MT2063_REG_LO2CQ_3, &state->reg[MT2063_REG_LO2CQ_3], 1);	/* 0x05 */
 			}
 			/* Write out the FIFF offset only if it's changing */
-			if (pInfo->reg[MT2063_REG_FIFF_OFFSET] !=
+			if (state->reg[MT2063_REG_FIFF_OFFSET] !=
 			    (u8) fiffof) {
-				pInfo->reg[MT2063_REG_FIFF_OFFSET] =
+				state->reg[MT2063_REG_FIFF_OFFSET] =
 				    (u8) fiffof;
 				status |=
-				    MT2063_WriteSub(pInfo,
+				    MT2063_WriteSub(state,
 						    MT2063_REG_FIFF_OFFSET,
-						    &pInfo->
+						    &state->
 						    reg[MT2063_REG_FIFF_OFFSET],
 						    1);
 			}
@@ -4202,13 +4202,13 @@ static u32 MT2063_Tune(struct mt2063_state *pInfo, u32 f_in)
 		 */
 
 		if (status >= 0) {
-			status |= MT2063_GetLocked(pInfo);
+			status |= MT2063_GetLocked(state);
 		}
 		/*
 		 **  If we locked OK, assign calculated data to mt2063_state structure
 		 */
 		if (status >= 0) {
-			pInfo->f_IF1_actual = pInfo->AS_Data.f_LO1 - f_in;
+			state->f_IF1_actual = state->AS_Data.f_LO1 - f_in;
 		}
 	}
 
-- 
1.7.7.5

