Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab2AEBBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:11 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511Ao0029468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 13/47] [media] mt2063: Use Unix standard error handling
Date: Wed,  4 Jan 2012 23:00:24 -0200
Message-Id: <1325725258-27934-14-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c | 2359 ++++++++++++++++------------------
 1 files changed, 1139 insertions(+), 1220 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 98bc2e2..a1acfcc 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -16,64 +16,18 @@ module_param(verbose, int, 0644);
 #define DVBFE_TUNER_SOFTWARE_SHUTDOWN		100
 #define DVBFE_TUNER_CLEAR_POWER_MASKBITS	101
 
-#define MT2063_ERROR (1 << 31)
-#define MT2063_USER_ERROR (1 << 30)
-
-/*  Macro to be used to check for errors  */
-#define MT2063_IS_ERROR(s) (((s) >> 30) != 0)
-#define MT2063_NO_ERROR(s) (((s) >> 30) == 0)
-
-#define MT2063_OK                           (0x00000000)
-
-/*  Unknown error  */
-#define MT2063_UNKNOWN                      (0x80000001)
-
+/* FIXME: Those error codes need conversion*/
 /*  Error:  Upconverter PLL is not locked  */
 #define MT2063_UPC_UNLOCK                   (0x80000002)
-
 /*  Error:  Downconverter PLL is not locked  */
 #define MT2063_DNC_UNLOCK                   (0x80000004)
-
-/*  Error:  Two-wire serial bus communications error  */
-#define MT2063_COMM_ERR                     (0x80000008)
-
-/*  Error:  Tuner handle passed to function was invalid  */
-#define MT2063_INV_HANDLE                   (0x80000010)
-
-/*  Error:  Function argument is invalid (out of range)  */
-#define MT2063_ARG_RANGE                    (0x80000020)
-
-/*  Error:  Function argument (ptr to return value) was NULL  */
-#define MT2063_ARG_NULL                     (0x80000040)
-
-/*  Error: Attempt to open more than MT_TUNER_CNT tuners  */
-#define MT2063_TUNER_CNT_ERR                (0x80000080)
-
-/*  Error: Tuner Part Code / Rev Code mismatches expected value  */
-#define MT2063_TUNER_ID_ERR                 (0x80000100)
-
-/*  Error: Tuner Initialization failure  */
-#define MT2063_TUNER_INIT_ERR               (0x80000200)
-
-#define MT2063_TUNER_OPEN_ERR               (0x80000400)
-
-/*  User-definable fields (see mt_userdef.h)  */
-#define MT2063_USER_DEFINED1                (0x00001000)
-#define MT2063_USER_DEFINED2                (0x00002000)
-#define MT2063_USER_DEFINED3                (0x00004000)
-#define MT2063_USER_DEFINED4                (0x00008000)
-#define MT2063_USER_MASK                    (0x4000f000)
-#define MT2063_USER_SHIFT                   (12)
+/*  Info: Unavoidable LO-related spur may be present in the output  */
+#define MT2063_SPUR_PRESENT_ERR                 (0x00800000)
 
 /*  Info: Mask of bits used for # of LO-related spurs that were avoided during tuning  */
 #define MT2063_SPUR_CNT_MASK                (0x001f0000)
 #define MT2063_SPUR_SHIFT                   (16)
 
-/*  Info: Tuner timeout waiting for condition  */
-#define MT2063_TUNER_TIMEOUT                (0x00400000)
-
-/*  Info: Unavoidable LO-related spur may be present in the output  */
-#define MT2063_SPUR_PRESENT_ERR                 (0x00800000)
 
 /*  Info: Tuner input frequency is out of range */
 #define MT2063_FIN_RANGE                    (0x01000000)
@@ -539,12 +493,12 @@ struct mt2063_state {
 /* Prototypes */
 static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
                         u32 f_min, u32 f_max);
-static u32 MT2063_ReInit(void *h);
-static u32 MT2063_Close(void *hMT2063);
-static u32 MT2063_GetReg(void *h, u8 reg, u8 * val);
-static u32 MT2063_GetParam(void *h, enum MT2063_Param param, u32 * pValue);
-static u32 MT2063_SetReg(void *h, u8 reg, u8 val);
-static u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue);
+static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo);
+static u32 MT2063_Close(struct MT2063_Info_t *pInfo);
+static u32 MT2063_GetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 * val);
+static u32 MT2063_GetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param, u32 * pValue);
+static u32 MT2063_SetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 val);
+static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param, u32 nValue);
 
 /*****************/
 /* From drivers/media/common/tuners/mt2063_cfg.h */
@@ -769,7 +723,7 @@ static u32 MT2063_WriteSub(void *hUserData,
 			u32 addr,
 			u8 subAddress, u8 * pData, u32 cnt)
 {
-	u32 status = MT2063_OK;	/* Status to be returned        */
+	u32 status = 0;	/* Status to be returned        */
 	struct dvb_frontend *fe = hUserData;
 	struct mt2063_state *state = fe->tuner_priv;
 	/*
@@ -782,7 +736,7 @@ static u32 MT2063_WriteSub(void *hUserData,
 	fe->ops.i2c_gate_ctrl(fe, 1);	//I2C bypass drxk3926 close i2c bridge
 
 	if (mt2063_writeregs(state, subAddress, pData, cnt) < 0) {
-		status = MT2063_ERROR;
+		status = -EINVAL;
 	}
 	fe->ops.i2c_gate_ctrl(fe, 0);	//I2C bypass drxk3926 close i2c bridge
 
@@ -838,7 +792,7 @@ static u32 MT2063_ReadSub(void *hUserData,
 	 **         return MT_OK.
 	 */
 /*  return status;  */
-	u32 status = MT2063_OK;	/* Status to be returned        */
+	u32 status = 0;	/* Status to be returned        */
 	struct dvb_frontend *fe = hUserData;
 	struct mt2063_state *state = fe->tuner_priv;
 	u32 i = 0;
@@ -846,7 +800,7 @@ static u32 MT2063_ReadSub(void *hUserData,
 
 	for (i = 0; i < cnt; i++) {
 		if (mt2063_read_regs(state, subAddress + i, pData + i, 1) < 0) {
-			status = MT2063_ERROR;
+			status = -EINVAL;
 			break;
 		}
 	}
@@ -962,7 +916,7 @@ static u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 #if MT2063_TUNER_CNT == 1
 	pAS_Info->nAS_Algorithm = 1;
-	return MT2063_OK;
+	return 0;
 #else
 	u32 index;
 
@@ -973,7 +927,7 @@ static u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 	 */
 	for (index = 0; index < TunerCount; index++) {
 		if (TunerList[index] == pAS_Info) {
-			return MT2063_OK;	/* Already here - no problem  */
+			return 0;	/* Already here - no problem  */
 		}
 	}
 
@@ -983,9 +937,9 @@ static u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 	if (TunerCount < MT2063_TUNER_CNT) {
 		TunerList[TunerCount] = pAS_Info;
 		TunerCount++;
-		return MT2063_OK;
+		return 0;
 	} else
-		return MT2063_TUNER_CNT_ERR;
+		return -ENODEV;
 #endif
 }
 
@@ -1810,13 +1764,13 @@ static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 *****************************************************************************/
 static u32 MT2063_AvoidSpurs(void *h, struct MT2063_AvoidSpursData_t * pAS_Info)
 {
-	u32 status = MT2063_OK;
+	u32 status = 0;
 	u32 fm, fp;		/*  restricted range on LO's        */
 	pAS_Info->bSpurAvoided = 0;
 	pAS_Info->nSpursFound = 0;
 
 	if (pAS_Info->maxH1 == 0)
-		return MT2063_OK;
+		return 0;
 
 	/*
 	 **  Avoid LO Generated Spurs
@@ -2030,14 +1984,14 @@ static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num,
 ******************************************************************************/
 static u32 MT2063_Open(u32 MT2063_Addr, struct MT2063_Info_t **hMT2063, void *hUserData)
 {
-	u32 status = MT2063_OK;	/*  Status to be returned.  */
+	u32 status = 0;	/*  Status to be returned.  */
 	struct MT2063_Info_t *pInfo = NULL;
 	struct dvb_frontend *fe = (struct dvb_frontend *)hUserData;
 	struct mt2063_state *state = fe->tuner_priv;
 
 	/*  Check the argument before using  */
 	if (hMT2063 == NULL) {
-		return MT2063_ARG_NULL;
+		return -ENODEV;
 	}
 
 	/*  Default tuner handle to NULL.  If successful, it will be reassigned  */
@@ -2045,7 +1999,7 @@ static u32 MT2063_Open(u32 MT2063_Addr, struct MT2063_Info_t **hMT2063, void *hU
 	if (state->MT2063_init == false) {
 		pInfo = kzalloc(sizeof(struct MT2063_Info_t), GFP_KERNEL);
 		if (pInfo == NULL) {
-			return MT2063_TUNER_OPEN_ERR;
+			return -ENOMEM;
 		}
 		pInfo->handle = NULL;
 		pInfo->address = MAX_UDATA;
@@ -2055,11 +2009,11 @@ static u32 MT2063_Open(u32 MT2063_Addr, struct MT2063_Info_t **hMT2063, void *hU
 		pInfo = *hMT2063;
 	}
 
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		status |= MT2063_RegisterTuner(&pInfo->AS_Data);
 	}
 
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		pInfo->handle = (void *) pInfo;
 
 		pInfo->hUserData = hUserData;
@@ -2068,7 +2022,7 @@ static u32 MT2063_Open(u32 MT2063_Addr, struct MT2063_Info_t **hMT2063, void *hU
 		status |= MT2063_ReInit((void *) pInfo);
 	}
 
-	if (MT2063_IS_ERROR(status))
+	if (status < 0)
 		/*  MT2063_Close handles the un-registration of the tuner  */
 		MT2063_Close((void *) pInfo);
 	else {
@@ -2106,12 +2060,10 @@ static u32 MT2063_IsValidHandle(struct MT2063_Info_t *handle)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-static u32 MT2063_Close(void *hMT2063)
+static u32 MT2063_Close(struct MT2063_Info_t *pInfo)
 {
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)hMT2063;
-
 	if (!MT2063_IsValidHandle(pInfo))
-		return MT2063_INV_HANDLE;
+		return -ENODEV;
 
 	/* Unregister tuner with SpurAvoidance routines (if needed) */
 	MT2063_UnRegisterTuner(&pInfo->AS_Data);
@@ -2122,7 +2074,7 @@ static u32 MT2063_Close(void *hMT2063)
 	//kfree(pInfo);
 	//pInfo = NULL;
 
-	return MT2063_OK;
+	return 0;
 }
 
 /****************************************************************************
@@ -2150,19 +2102,18 @@ static u32 MT2063_Close(void *hMT2063)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_GetLocked(void *h)
+static u32 MT2063_GetLocked(struct MT2063_Info_t *pInfo)
 {
 	const u32 nMaxWait = 100;	/*  wait a maximum of 100 msec   */
 	const u32 nPollRate = 2;	/*  poll status bits every 2 ms */
 	const u32 nMaxLoops = nMaxWait / nPollRate;
 	const u8 LO1LK = 0x80;
 	u8 LO2LK = 0x08;
-	u32 status = MT2063_OK;	/* Status to be returned        */
+	u32 status = 0;	/* Status to be returned        */
 	u32 nDelays = 0;
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	if (MT2063_IsValidHandle(pInfo) == 0)
-		return MT2063_INV_HANDLE;
+		return -ENODEV;
 
 	/*  LO2 Lock bit was in a different place for B0 version  */
 	if (pInfo->tuner_id == MT2063_B0)
@@ -2174,7 +2125,7 @@ static u32 MT2063_GetLocked(void *h)
 				   MT2063_REG_LO_STATUS,
 				   &pInfo->reg[MT2063_REG_LO_STATUS], 1);
 
-		if (MT2063_IS_ERROR(status))
+		if (status < 0)
 			return (status);
 
 		if ((pInfo->reg[MT2063_REG_LO_STATUS] & (LO1LK | LO2LK)) ==
@@ -2285,378 +2236,375 @@ static u32 MT2063_GetLocked(void *h)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-static u32 MT2063_GetParam(void *h, enum MT2063_Param param, u32 * pValue)
+static u32 MT2063_GetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param, u32 * pValue)
 {
-	u32 status = MT2063_OK;	/* Status to be returned        */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
+	u32 status = 0;	/* Status to be returned        */
 	u32 Div;
 	u32 Num;
 
 	if (pValue == NULL)
-		status |= MT2063_ARG_NULL;
+		return -EINVAL;
 
 	/*  Verify that the handle passed points to a valid tuner         */
 	if (MT2063_IsValidHandle(pInfo) == 0)
-		status |= MT2063_INV_HANDLE;
-
-	if (MT2063_NO_ERROR(status)) {
-		switch (param) {
-			/*  Serial Bus address of this tuner      */
-		case MT2063_IC_ADDR:
-			*pValue = pInfo->address;
-			break;
-
-			/*  Max # of MT2063's allowed to be open  */
-		case MT2063_MAX_OPEN:
-			*pValue = nMT2063MaxTuners;
-			break;
-
-			/*  # of MT2063's open                    */
-		case MT2063_NUM_OPEN:
-			*pValue = nMT2063OpenTuners;
-			break;
-
-			/*  crystal frequency                     */
-		case MT2063_SRO_FREQ:
-			*pValue = pInfo->AS_Data.f_ref;
-			break;
-
-			/*  minimum tuning step size              */
-		case MT2063_STEPSIZE:
-			*pValue = pInfo->AS_Data.f_LO2_Step;
-			break;
-
-			/*  input center frequency                */
-		case MT2063_INPUT_FREQ:
-			*pValue = pInfo->AS_Data.f_in;
-			break;
-
-			/*  LO1 Frequency                         */
-		case MT2063_LO1_FREQ:
-			{
-				/* read the actual tuner register values for LO1C_1 and LO1C_2 */
-				status |=
-				    MT2063_ReadSub(pInfo->hUserData,
-						   pInfo->address,
-						   MT2063_REG_LO1C_1,
-						   &pInfo->
-						   reg[MT2063_REG_LO1C_1], 2);
-				Div = pInfo->reg[MT2063_REG_LO1C_1];
-				Num = pInfo->reg[MT2063_REG_LO1C_2] & 0x3F;
-				pInfo->AS_Data.f_LO1 =
-				    (pInfo->AS_Data.f_ref * Div) +
-				    MT2063_fLO_FractionalTerm(pInfo->AS_Data.
-							      f_ref, Num, 64);
-			}
-			*pValue = pInfo->AS_Data.f_LO1;
-			break;
-
-			/*  LO1 minimum step size                 */
-		case MT2063_LO1_STEPSIZE:
-			*pValue = pInfo->AS_Data.f_LO1_Step;
-			break;
-
-			/*  LO1 FracN keep-out region             */
-		case MT2063_LO1_FRACN_AVOID_PARAM:
-			*pValue = pInfo->AS_Data.f_LO1_FracN_Avoid;
-			break;
-
-			/*  Current 1st IF in use                 */
-		case MT2063_IF1_ACTUAL:
-			*pValue = pInfo->f_IF1_actual;
-			break;
-
-			/*  Requested 1st IF                      */
-		case MT2063_IF1_REQUEST:
-			*pValue = pInfo->AS_Data.f_if1_Request;
-			break;
-
-			/*  Center of 1st IF SAW filter           */
-		case MT2063_IF1_CENTER:
-			*pValue = pInfo->AS_Data.f_if1_Center;
-			break;
-
-			/*  Bandwidth of 1st IF SAW filter        */
-		case MT2063_IF1_BW:
-			*pValue = pInfo->AS_Data.f_if1_bw;
-			break;
-
-			/*  zero-IF bandwidth                     */
-		case MT2063_ZIF_BW:
-			*pValue = pInfo->AS_Data.f_zif_bw;
-			break;
-
-			/*  LO2 Frequency                         */
-		case MT2063_LO2_FREQ:
-			{
-				/* Read the actual tuner register values for LO2C_1, LO2C_2 and LO2C_3 */
-				status |=
-				    MT2063_ReadSub(pInfo->hUserData,
-						   pInfo->address,
-						   MT2063_REG_LO2C_1,
-						   &pInfo->
-						   reg[MT2063_REG_LO2C_1], 3);
-				Div =
-				    (pInfo->reg[MT2063_REG_LO2C_1] & 0xFE) >> 1;
-				Num =
-				    ((pInfo->
-				      reg[MT2063_REG_LO2C_1] & 0x01) << 12) |
-				    (pInfo->
-				     reg[MT2063_REG_LO2C_2] << 4) | (pInfo->
-								     reg
-								     [MT2063_REG_LO2C_3]
-								     & 0x00F);
-				pInfo->AS_Data.f_LO2 =
-				    (pInfo->AS_Data.f_ref * Div) +
-				    MT2063_fLO_FractionalTerm(pInfo->AS_Data.
-							      f_ref, Num, 8191);
-			}
-			*pValue = pInfo->AS_Data.f_LO2;
-			break;
-
-			/*  LO2 minimum step size                 */
-		case MT2063_LO2_STEPSIZE:
-			*pValue = pInfo->AS_Data.f_LO2_Step;
-			break;
-
-			/*  LO2 FracN keep-out region             */
-		case MT2063_LO2_FRACN_AVOID:
-			*pValue = pInfo->AS_Data.f_LO2_FracN_Avoid;
-			break;
-
-			/*  output center frequency               */
-		case MT2063_OUTPUT_FREQ:
-			*pValue = pInfo->AS_Data.f_out;
-			break;
-
-			/*  output bandwidth                      */
-		case MT2063_OUTPUT_BW:
-			*pValue = pInfo->AS_Data.f_out_bw - 750000;
-			break;
-
-			/*  min inter-tuner LO separation         */
-		case MT2063_LO_SEPARATION:
-			*pValue = pInfo->AS_Data.f_min_LO_Separation;
-			break;
-
-			/*  ID of avoid-spurs algorithm in use    */
-		case MT2063_AS_ALG:
-			*pValue = pInfo->AS_Data.nAS_Algorithm;
-			break;
-
-			/*  max # of intra-tuner harmonics        */
-		case MT2063_MAX_HARM1:
-			*pValue = pInfo->AS_Data.maxH1;
-			break;
-
-			/*  max # of inter-tuner harmonics        */
-		case MT2063_MAX_HARM2:
-			*pValue = pInfo->AS_Data.maxH2;
-			break;
-
-			/*  # of 1st IF exclusion zones           */
-		case MT2063_EXCL_ZONES:
-			*pValue = pInfo->AS_Data.nZones;
-			break;
-
-			/*  # of spurs found/avoided              */
-		case MT2063_NUM_SPURS:
-			*pValue = pInfo->AS_Data.nSpursFound;
-			break;
-
-			/*  >0 spurs avoided                      */
-		case MT2063_SPUR_AVOIDED:
-			*pValue = pInfo->AS_Data.bSpurAvoided;
-			break;
-
-			/*  >0 spurs in output (mathematically)   */
-		case MT2063_SPUR_PRESENT:
-			*pValue = pInfo->AS_Data.bSpurPresent;
-			break;
-
-			/*  Predefined receiver setup combination */
-		case MT2063_RCVR_MODE:
-			*pValue = pInfo->rcvr_mode;
-			break;
-
-		case MT2063_PD1:
-		case MT2063_PD2:
-			{
-				u8 mask = (param == MT2063_PD1 ? 0x01 : 0x03);	/* PD1 vs PD2 */
-				u8 orig = (pInfo->reg[MT2063_REG_BYP_CTRL]);
-				u8 reg = (orig & 0xF1) | mask;	/* Only set 3 bits (not 5) */
-				int i;
-
-				*pValue = 0;
-
-				/* Initiate ADC output to reg 0x0A */
-				if (reg != orig)
-					status |=
-					    MT2063_WriteSub(pInfo->hUserData,
-							    pInfo->address,
-							    MT2063_REG_BYP_CTRL,
-							    &reg, 1);
-
-				if (MT2063_IS_ERROR(status))
-					return (status);
-
-				for (i = 0; i < 8; i++) {
-					status |=
-					    MT2063_ReadSub(pInfo->hUserData,
-							   pInfo->address,
-							   MT2063_REG_ADC_OUT,
-							   &pInfo->
-							   reg
-							   [MT2063_REG_ADC_OUT],
-							   1);
-
-					if (MT2063_NO_ERROR(status))
-						*pValue +=
-						    pInfo->
-						    reg[MT2063_REG_ADC_OUT];
-					else {
-						if (i)
-							*pValue /= i;
-						return (status);
-					}
-				}
-				*pValue /= 8;	/*  divide by number of reads  */
-				*pValue >>= 2;	/*  only want 6 MSB's out of 8  */
-
-				/* Restore value of Register BYP_CTRL */
-				if (reg != orig)
-					status |=
-					    MT2063_WriteSub(pInfo->hUserData,
-							    pInfo->address,
-							    MT2063_REG_BYP_CTRL,
-							    &orig, 1);
-			}
-			break;
-
-			/*  Get LNA attenuator code                */
-		case MT2063_ACLNA:
-			{
-				u8 val;
-				status |=
-				    MT2063_GetReg(pInfo, MT2063_REG_XO_STATUS,
-						  &val);
-				*pValue = val & 0x1f;
-			}
-			break;
-
-			/*  Get RF attenuator code                */
-		case MT2063_ACRF:
-			{
-				u8 val;
-				status |=
-				    MT2063_GetReg(pInfo, MT2063_REG_RF_STATUS,
-						  &val);
-				*pValue = val & 0x1f;
-			}
-			break;
-
-			/*  Get FIF attenuator code               */
-		case MT2063_ACFIF:
-			{
-				u8 val;
-				status |=
-				    MT2063_GetReg(pInfo, MT2063_REG_FIF_STATUS,
-						  &val);
-				*pValue = val & 0x1f;
-			}
-			break;
-
-			/*  Get LNA attenuator limit              */
-		case MT2063_ACLNA_MAX:
-			{
-				u8 val;
-				status |=
-				    MT2063_GetReg(pInfo, MT2063_REG_LNA_OV,
-						  &val);
-				*pValue = val & 0x1f;
-			}
-			break;
-
-			/*  Get RF attenuator limit               */
-		case MT2063_ACRF_MAX:
-			{
-				u8 val;
-				status |=
-				    MT2063_GetReg(pInfo, MT2063_REG_RF_OV,
-						  &val);
-				*pValue = val & 0x1f;
-			}
-			break;
-
-			/*  Get FIF attenuator limit               */
-		case MT2063_ACFIF_MAX:
-			{
-				u8 val;
-				status |=
-				    MT2063_GetReg(pInfo, MT2063_REG_FIF_OV,
-						  &val);
-				*pValue = val & 0x1f;
-			}
-			break;
-
-			/*  Get current used DNC output */
-		case MT2063_DNC_OUTPUT_ENABLE:
-			{
-				if ((pInfo->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
-					if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
-						*pValue =
-						    (u32) MT2063_DNC_NONE;
-					else
-						*pValue =
-						    (u32) MT2063_DNC_2;
-				} else {	/* DNC1 is on */
-
-					if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
-						*pValue =
-						    (u32) MT2063_DNC_1;
-					else
-						*pValue =
-						    (u32) MT2063_DNC_BOTH;
-				}
-			}
-			break;
-
-			/*  Get VGA Gain Code */
-		case MT2063_VGAGC:
-			*pValue =
-			    ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x0C) >> 2);
-			break;
-
-			/*  Get VGA bias current */
-		case MT2063_VGAOI:
-			*pValue = (pInfo->reg[MT2063_REG_RSVD_31] & 0x07);
-			break;
-
-			/*  Get TAGC setting */
-		case MT2063_TAGC:
-			*pValue = (pInfo->reg[MT2063_REG_RSVD_1E] & 0x03);
-			break;
-
-			/*  Get AMP Gain Code */
-		case MT2063_AMPGC:
-			*pValue = (pInfo->reg[MT2063_REG_TEMP_SEL] & 0x03);
-			break;
-
-			/*  Avoid DECT Frequencies  */
-		case MT2063_AVOID_DECT:
-			*pValue = pInfo->AS_Data.avoidDECT;
-			break;
-
-			/*  Cleartune filter selection: 0 - by IC (default), 1 - by software  */
-		case MT2063_CTFILT_SW:
-			*pValue = pInfo->ctfilt_sw;
-			break;
-
-		case MT2063_EOP:
-		default:
-			status |= MT2063_ARG_RANGE;
-		}
-	}
+		return -ENODEV;
+
+	    switch (param) {
+		    /*  Serial Bus address of this tuner      */
+	    case MT2063_IC_ADDR:
+		    *pValue = pInfo->address;
+		    break;
+
+		    /*  Max # of MT2063's allowed to be open  */
+	    case MT2063_MAX_OPEN:
+		    *pValue = nMT2063MaxTuners;
+		    break;
+
+		    /*  # of MT2063's open                    */
+	    case MT2063_NUM_OPEN:
+		    *pValue = nMT2063OpenTuners;
+		    break;
+
+		    /*  crystal frequency                     */
+	    case MT2063_SRO_FREQ:
+		    *pValue = pInfo->AS_Data.f_ref;
+		    break;
+
+		    /*  minimum tuning step size              */
+	    case MT2063_STEPSIZE:
+		    *pValue = pInfo->AS_Data.f_LO2_Step;
+		    break;
+
+		    /*  input center frequency                */
+	    case MT2063_INPUT_FREQ:
+		    *pValue = pInfo->AS_Data.f_in;
+		    break;
+
+		    /*  LO1 Frequency                         */
+	    case MT2063_LO1_FREQ:
+		    {
+			    /* read the actual tuner register values for LO1C_1 and LO1C_2 */
+			    status |=
+				MT2063_ReadSub(pInfo->hUserData,
+					       pInfo->address,
+					       MT2063_REG_LO1C_1,
+					       &pInfo->
+					       reg[MT2063_REG_LO1C_1], 2);
+			    Div = pInfo->reg[MT2063_REG_LO1C_1];
+			    Num = pInfo->reg[MT2063_REG_LO1C_2] & 0x3F;
+			    pInfo->AS_Data.f_LO1 =
+				(pInfo->AS_Data.f_ref * Div) +
+				MT2063_fLO_FractionalTerm(pInfo->AS_Data.
+							  f_ref, Num, 64);
+		    }
+		    *pValue = pInfo->AS_Data.f_LO1;
+		    break;
+
+		    /*  LO1 minimum step size                 */
+	    case MT2063_LO1_STEPSIZE:
+		    *pValue = pInfo->AS_Data.f_LO1_Step;
+		    break;
+
+		    /*  LO1 FracN keep-out region             */
+	    case MT2063_LO1_FRACN_AVOID_PARAM:
+		    *pValue = pInfo->AS_Data.f_LO1_FracN_Avoid;
+		    break;
+
+		    /*  Current 1st IF in use                 */
+	    case MT2063_IF1_ACTUAL:
+		    *pValue = pInfo->f_IF1_actual;
+		    break;
+
+		    /*  Requested 1st IF                      */
+	    case MT2063_IF1_REQUEST:
+		    *pValue = pInfo->AS_Data.f_if1_Request;
+		    break;
+
+		    /*  Center of 1st IF SAW filter           */
+	    case MT2063_IF1_CENTER:
+		    *pValue = pInfo->AS_Data.f_if1_Center;
+		    break;
+
+		    /*  Bandwidth of 1st IF SAW filter        */
+	    case MT2063_IF1_BW:
+		    *pValue = pInfo->AS_Data.f_if1_bw;
+		    break;
+
+		    /*  zero-IF bandwidth                     */
+	    case MT2063_ZIF_BW:
+		    *pValue = pInfo->AS_Data.f_zif_bw;
+		    break;
+
+		    /*  LO2 Frequency                         */
+	    case MT2063_LO2_FREQ:
+		    {
+			    /* Read the actual tuner register values for LO2C_1, LO2C_2 and LO2C_3 */
+			    status |=
+				MT2063_ReadSub(pInfo->hUserData,
+					       pInfo->address,
+					       MT2063_REG_LO2C_1,
+					       &pInfo->
+					       reg[MT2063_REG_LO2C_1], 3);
+			    Div =
+				(pInfo->reg[MT2063_REG_LO2C_1] & 0xFE) >> 1;
+			    Num =
+				((pInfo->
+				  reg[MT2063_REG_LO2C_1] & 0x01) << 12) |
+				(pInfo->
+				 reg[MT2063_REG_LO2C_2] << 4) | (pInfo->
+								 reg
+								 [MT2063_REG_LO2C_3]
+								 & 0x00F);
+			    pInfo->AS_Data.f_LO2 =
+				(pInfo->AS_Data.f_ref * Div) +
+				MT2063_fLO_FractionalTerm(pInfo->AS_Data.
+							  f_ref, Num, 8191);
+		    }
+		    *pValue = pInfo->AS_Data.f_LO2;
+		    break;
+
+		    /*  LO2 minimum step size                 */
+	    case MT2063_LO2_STEPSIZE:
+		    *pValue = pInfo->AS_Data.f_LO2_Step;
+		    break;
+
+		    /*  LO2 FracN keep-out region             */
+	    case MT2063_LO2_FRACN_AVOID:
+		    *pValue = pInfo->AS_Data.f_LO2_FracN_Avoid;
+		    break;
+
+		    /*  output center frequency               */
+	    case MT2063_OUTPUT_FREQ:
+		    *pValue = pInfo->AS_Data.f_out;
+		    break;
+
+		    /*  output bandwidth                      */
+	    case MT2063_OUTPUT_BW:
+		    *pValue = pInfo->AS_Data.f_out_bw - 750000;
+		    break;
+
+		    /*  min inter-tuner LO separation         */
+	    case MT2063_LO_SEPARATION:
+		    *pValue = pInfo->AS_Data.f_min_LO_Separation;
+		    break;
+
+		    /*  ID of avoid-spurs algorithm in use    */
+	    case MT2063_AS_ALG:
+		    *pValue = pInfo->AS_Data.nAS_Algorithm;
+		    break;
+
+		    /*  max # of intra-tuner harmonics        */
+	    case MT2063_MAX_HARM1:
+		    *pValue = pInfo->AS_Data.maxH1;
+		    break;
+
+		    /*  max # of inter-tuner harmonics        */
+	    case MT2063_MAX_HARM2:
+		    *pValue = pInfo->AS_Data.maxH2;
+		    break;
+
+		    /*  # of 1st IF exclusion zones           */
+	    case MT2063_EXCL_ZONES:
+		    *pValue = pInfo->AS_Data.nZones;
+		    break;
+
+		    /*  # of spurs found/avoided              */
+	    case MT2063_NUM_SPURS:
+		    *pValue = pInfo->AS_Data.nSpursFound;
+		    break;
+
+		    /*  >0 spurs avoided                      */
+	    case MT2063_SPUR_AVOIDED:
+		    *pValue = pInfo->AS_Data.bSpurAvoided;
+		    break;
+
+		    /*  >0 spurs in output (mathematically)   */
+	    case MT2063_SPUR_PRESENT:
+		    *pValue = pInfo->AS_Data.bSpurPresent;
+		    break;
+
+		    /*  Predefined receiver setup combination */
+	    case MT2063_RCVR_MODE:
+		    *pValue = pInfo->rcvr_mode;
+		    break;
+
+	    case MT2063_PD1:
+	    case MT2063_PD2:
+		    {
+			    u8 mask = (param == MT2063_PD1 ? 0x01 : 0x03);	/* PD1 vs PD2 */
+			    u8 orig = (pInfo->reg[MT2063_REG_BYP_CTRL]);
+			    u8 reg = (orig & 0xF1) | mask;	/* Only set 3 bits (not 5) */
+			    int i;
+
+			    *pValue = 0;
+
+			    /* Initiate ADC output to reg 0x0A */
+			    if (reg != orig)
+				    status |=
+					MT2063_WriteSub(pInfo->hUserData,
+							pInfo->address,
+							MT2063_REG_BYP_CTRL,
+							&reg, 1);
+
+			    if (status < 0)
+				    return (status);
+
+			    for (i = 0; i < 8; i++) {
+				    status |=
+					MT2063_ReadSub(pInfo->hUserData,
+						       pInfo->address,
+						       MT2063_REG_ADC_OUT,
+						       &pInfo->
+						       reg
+						       [MT2063_REG_ADC_OUT],
+						       1);
+
+				    if (status >= 0)
+					    *pValue +=
+						pInfo->
+						reg[MT2063_REG_ADC_OUT];
+				    else {
+					    if (i)
+						    *pValue /= i;
+					    return (status);
+				    }
+			    }
+			    *pValue /= 8;	/*  divide by number of reads  */
+			    *pValue >>= 2;	/*  only want 6 MSB's out of 8  */
+
+			    /* Restore value of Register BYP_CTRL */
+			    if (reg != orig)
+				    status |=
+					MT2063_WriteSub(pInfo->hUserData,
+							pInfo->address,
+							MT2063_REG_BYP_CTRL,
+							&orig, 1);
+		    }
+		    break;
+
+		    /*  Get LNA attenuator code                */
+	    case MT2063_ACLNA:
+		    {
+			    u8 val;
+			    status |=
+				MT2063_GetReg(pInfo, MT2063_REG_XO_STATUS,
+					      &val);
+			    *pValue = val & 0x1f;
+		    }
+		    break;
+
+		    /*  Get RF attenuator code                */
+	    case MT2063_ACRF:
+		    {
+			    u8 val;
+			    status |=
+				MT2063_GetReg(pInfo, MT2063_REG_RF_STATUS,
+					      &val);
+			    *pValue = val & 0x1f;
+		    }
+		    break;
+
+		    /*  Get FIF attenuator code               */
+	    case MT2063_ACFIF:
+		    {
+			    u8 val;
+			    status |=
+				MT2063_GetReg(pInfo, MT2063_REG_FIF_STATUS,
+					      &val);
+			    *pValue = val & 0x1f;
+		    }
+		    break;
+
+		    /*  Get LNA attenuator limit              */
+	    case MT2063_ACLNA_MAX:
+		    {
+			    u8 val;
+			    status |=
+				MT2063_GetReg(pInfo, MT2063_REG_LNA_OV,
+					      &val);
+			    *pValue = val & 0x1f;
+		    }
+		    break;
+
+		    /*  Get RF attenuator limit               */
+	    case MT2063_ACRF_MAX:
+		    {
+			    u8 val;
+			    status |=
+				MT2063_GetReg(pInfo, MT2063_REG_RF_OV,
+					      &val);
+			    *pValue = val & 0x1f;
+		    }
+		    break;
+
+		    /*  Get FIF attenuator limit               */
+	    case MT2063_ACFIF_MAX:
+		    {
+			    u8 val;
+			    status |=
+				MT2063_GetReg(pInfo, MT2063_REG_FIF_OV,
+					      &val);
+			    *pValue = val & 0x1f;
+		    }
+		    break;
+
+		    /*  Get current used DNC output */
+	    case MT2063_DNC_OUTPUT_ENABLE:
+		    {
+			    if ((pInfo->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
+				    if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
+					    *pValue =
+						(u32) MT2063_DNC_NONE;
+				    else
+					    *pValue =
+						(u32) MT2063_DNC_2;
+			    } else {	/* DNC1 is on */
+
+				    if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
+					    *pValue =
+						(u32) MT2063_DNC_1;
+				    else
+					    *pValue =
+						(u32) MT2063_DNC_BOTH;
+			    }
+		    }
+		    break;
+
+		    /*  Get VGA Gain Code */
+	    case MT2063_VGAGC:
+		    *pValue =
+			((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x0C) >> 2);
+		    break;
+
+		    /*  Get VGA bias current */
+	    case MT2063_VGAOI:
+		    *pValue = (pInfo->reg[MT2063_REG_RSVD_31] & 0x07);
+		    break;
+
+		    /*  Get TAGC setting */
+	    case MT2063_TAGC:
+		    *pValue = (pInfo->reg[MT2063_REG_RSVD_1E] & 0x03);
+		    break;
+
+		    /*  Get AMP Gain Code */
+	    case MT2063_AMPGC:
+		    *pValue = (pInfo->reg[MT2063_REG_TEMP_SEL] & 0x03);
+		    break;
+
+		    /*  Avoid DECT Frequencies  */
+	    case MT2063_AVOID_DECT:
+		    *pValue = pInfo->AS_Data.avoidDECT;
+		    break;
+
+		    /*  Cleartune filter selection: 0 - by IC (default), 1 - by software  */
+	    case MT2063_CTFILT_SW:
+		    *pValue = pInfo->ctfilt_sw;
+		    break;
+
+	    case MT2063_EOP:
+	    default:
+		    status |= -ERANGE;
+	    }
 	return (status);
 }
 
@@ -2689,28 +2637,22 @@ static u32 MT2063_GetParam(void *h, enum MT2063_Param param, u32 * pValue)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_GetReg(void *h, u8 reg, u8 * val)
+static u32 MT2063_GetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 * val)
 {
-	u32 status = MT2063_OK;	/* Status to be returned        */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
+	u32 status = 0;	/* Status to be returned        */
 
 	/*  Verify that the handle passed points to a valid tuner         */
 	if (MT2063_IsValidHandle(pInfo) == 0)
-		status |= MT2063_INV_HANDLE;
+		return -ENODEV;
 
 	if (val == NULL)
-		status |= MT2063_ARG_NULL;
+		return -EINVAL;
 
 	if (reg >= MT2063_REG_END_REGS)
-		status |= MT2063_ARG_RANGE;
+		return -ERANGE;
 
-	if (MT2063_NO_ERROR(status)) {
-		status |=
-		    MT2063_ReadSub(pInfo->hUserData, pInfo->address, reg,
-				   &pInfo->reg[reg], 1);
-		if (MT2063_NO_ERROR(status))
-			*val = pInfo->reg[reg];
-	}
+	status = MT2063_ReadSub(pInfo->hUserData, pInfo->address, reg,
+			   &pInfo->reg[reg], 1);
 
 	return (status);
 }
@@ -2801,15 +2743,15 @@ static u32 MT2063_GetReg(void *h, u8 reg, u8 * val)
 static u32 MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 				      enum MT2063_RCVR_MODES Mode)
 {
-	u32 status = MT2063_OK;	/* Status to be returned        */
+	u32 status = 0;	/* Status to be returned        */
 	u8 val;
 	u32 longval;
 
 	if (Mode >= MT2063_NUM_RCVR_MODES)
-		status = MT2063_ARG_RANGE;
+		status = -ERANGE;
 
 	/* RFAGCen */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		val =
 		    (pInfo->
 		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x40) | (RFAGCEN[Mode]
@@ -2821,12 +2763,12 @@ static u32 MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 	}
 
 	/* LNARin */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		status |= MT2063_SetParam(pInfo, MT2063_LNA_RIN, LNARIN[Mode]);
 	}
 
 	/* FIFFQEN and FIFFQ */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		val =
 		    (pInfo->
 		     reg[MT2063_REG_FIFF_CTRL2] & (u8) ~ 0xF0) |
@@ -2852,40 +2794,40 @@ static u32 MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 	status |= MT2063_SetParam(pInfo, MT2063_DNC_OUTPUT_ENABLE, longval);
 
 	/* acLNAmax */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		status |=
 		    MT2063_SetParam(pInfo, MT2063_ACLNA_MAX, ACLNAMAX[Mode]);
 	}
 
 	/* LNATGT */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		status |= MT2063_SetParam(pInfo, MT2063_LNA_TGT, LNATGT[Mode]);
 	}
 
 	/* ACRF */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		status |=
 		    MT2063_SetParam(pInfo, MT2063_ACRF_MAX, ACRFMAX[Mode]);
 	}
 
 	/* PD1TGT */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		status |= MT2063_SetParam(pInfo, MT2063_PD1_TGT, PD1TGT[Mode]);
 	}
 
 	/* FIFATN */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		status |=
 		    MT2063_SetParam(pInfo, MT2063_ACFIF_MAX, ACFIFMAX[Mode]);
 	}
 
 	/* PD2TGT */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		status |= MT2063_SetParam(pInfo, MT2063_PD2_TGT, PD2TGT[Mode]);
 	}
 
 	/* Ignore ATN Overload */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		val =
 		    (pInfo->
 		     reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x80) | (RFOVDIS[Mode]
@@ -2897,7 +2839,7 @@ static u32 MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 	}
 
 	/* Ignore FIF Overload */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		val =
 		    (pInfo->
 		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x80) |
@@ -2907,7 +2849,7 @@ static u32 MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 		}
 	}
 
-	if (MT2063_NO_ERROR(status))
+	if (status >= 0)
 		pInfo->rcvr_mode = Mode;
 
 	return (status);
@@ -2947,13 +2889,15 @@ static u32 MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ******************************************************************************/
-static u32 MT2063_ReInit(void *h)
+static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
 {
 	u8 all_resets = 0xF0;	/* reset/load bits */
-	u32 status = MT2063_OK;	/* Status to be returned */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
+	u32 status = 0;	/* Status to be returned */
 	u8 *def = NULL;
-
+	u32 FCRUN;
+	s32 maxReads;
+	u32 fcu_osc;
+	u32 i;
 	u8 MT2063B0_defaults[] = {	/* Reg,  Value */
 		0x19, 0x05,
 		0x1B, 0x1D,
@@ -2976,7 +2920,6 @@ static u32 MT2063_ReInit(void *h)
 		0x28, 0xE0,	/*  Clear the FIFCrst bit here    */
 		0x00
 	};
-
 	/* writing 0x05 0xf0 sw-resets all registers, so we write only needed changes */
 	u8 MT2063B1_defaults[] = {	/* Reg,  Value */
 		0x05, 0xF0,
@@ -3002,7 +2945,6 @@ static u32 MT2063_ReInit(void *h)
 		0x28, 0xE0,	/*  Clear the FIFCrst bit here    */
 		0x00
 	};
-
 	/* writing 0x05 0xf0 sw-resets all registers, so we write only needed changes */
 	u8 MT2063B3_defaults[] = {	/* Reg,  Value */
 		0x05, 0xF0,
@@ -3016,37 +2958,35 @@ static u32 MT2063_ReInit(void *h)
 
 	/*  Verify that the handle passed points to a valid tuner         */
 	if (MT2063_IsValidHandle(pInfo) == 0)
-		status |= MT2063_INV_HANDLE;
+		return -ENODEV;
 
 	/*  Read the Part/Rev code from the tuner */
-	if (MT2063_NO_ERROR(status)) {
-		status |=
-		    MT2063_ReadSub(pInfo->hUserData, pInfo->address,
-				   MT2063_REG_PART_REV, pInfo->reg, 1);
-	}
-
-	if (MT2063_NO_ERROR(status)	/* Check the part/rev code */
-	    &&((pInfo->reg[MT2063_REG_PART_REV] != MT2063_B0)	/*  MT2063 B0  */
-	       &&(pInfo->reg[MT2063_REG_PART_REV] != MT2063_B1)	/*  MT2063 B1  */
-	       &&(pInfo->reg[MT2063_REG_PART_REV] != MT2063_B3)))	/*  MT2063 B3  */
-		status |= MT2063_TUNER_ID_ERR;	/*  Wrong tuner Part/Rev code */
-
-	/*  Read the Part/Rev code (2nd byte) from the tuner */
-	if (MT2063_NO_ERROR(status))
-		status |=
-		    MT2063_ReadSub(pInfo->hUserData, pInfo->address,
-				   MT2063_REG_RSVD_3B,
-				   &pInfo->reg[MT2063_REG_RSVD_3B], 1);
-
-	if (MT2063_NO_ERROR(status)	/* Check the 2nd part/rev code */
+	status = MT2063_ReadSub(pInfo->hUserData, pInfo->address,
+				MT2063_REG_PART_REV, pInfo->reg, 1);
+	if (status < 0)
+		return status;
+
+	/* Check the part/rev code */
+	if (((pInfo->reg[MT2063_REG_PART_REV] != MT2063_B0)	/*  MT2063 B0  */
+	    &&(pInfo->reg[MT2063_REG_PART_REV] != MT2063_B1)	/*  MT2063 B1  */
+	    &&(pInfo->reg[MT2063_REG_PART_REV] != MT2063_B3)))	/*  MT2063 B3  */
+		return -ENODEV;	/*  Wrong tuner Part/Rev code */
+
+	/*  Check the 2nd byte of the Part/Rev code from the tuner */
+	status = MT2063_ReadSub(pInfo->hUserData, pInfo->address,
+			        MT2063_REG_RSVD_3B,
+			        &pInfo->reg[MT2063_REG_RSVD_3B], 1);
+
+	if (status >= 0
 	    &&((pInfo->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00))	/* b7 != 0 ==> NOT MT2063 */
-		status |= MT2063_TUNER_ID_ERR;	/*  Wrong tuner Part/Rev code */
+		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 
 	/*  Reset the tuner  */
-	if (MT2063_NO_ERROR(status))
-		status |= MT2063_WriteSub(pInfo->hUserData,
-					  pInfo->address,
-					  MT2063_REG_LO2CQ_3, &all_resets, 1);
+	status = MT2063_WriteSub(pInfo->hUserData,
+				 pInfo->address,
+				 MT2063_REG_LO2CQ_3, &all_resets, 1);
+	if (status < 0)
+		return status;
 
 	/* change all of the default values that vary from the HW reset values */
 	/*  def = (pInfo->reg[PART_REV] == MT2063_B0) ? MT2063B0_defaults : MT2063B1_defaults; */
@@ -3064,145 +3004,136 @@ static u32 MT2063_ReInit(void *h)
 		break;
 
 	default:
-		status |= MT2063_TUNER_ID_ERR;
+		return -ENODEV;
 		break;
 	}
 
-	while (MT2063_NO_ERROR(status) && *def) {
+	while (status >= 0 && *def) {
 		u8 reg = *def++;
 		u8 val = *def++;
-		status |=
-		    MT2063_WriteSub(pInfo->hUserData, pInfo->address, reg, &val,
-				    1);
+		status = MT2063_WriteSub(pInfo->hUserData, pInfo->address, reg,
+					 &val, 1);
 	}
+	if (status < 0)
+		return status;
 
 	/*  Wait for FIFF location to complete.  */
-	if (MT2063_NO_ERROR(status)) {
-		u32 FCRUN = 1;
-		s32 maxReads = 10;
-		while (MT2063_NO_ERROR(status) && (FCRUN != 0)
-		       && (maxReads-- > 0)) {
-			msleep(2);
-			status |= MT2063_ReadSub(pInfo->hUserData,
-						 pInfo->address,
-						 MT2063_REG_XO_STATUS,
-						 &pInfo->
-						 reg[MT2063_REG_XO_STATUS], 1);
-			FCRUN = (pInfo->reg[MT2063_REG_XO_STATUS] & 0x40) >> 6;
-		}
-
-		if (FCRUN != 0)
-			status |= MT2063_TUNER_INIT_ERR | MT2063_TUNER_TIMEOUT;
-
-		if (MT2063_NO_ERROR(status))	/* Re-read FIFFC value */
-			status |=
-			    MT2063_ReadSub(pInfo->hUserData, pInfo->address,
-					   MT2063_REG_FIFFC,
-					   &pInfo->reg[MT2063_REG_FIFFC], 1);
+	FCRUN = 1;
+	maxReads = 10;
+	while (status >= 0 && (FCRUN != 0) && (maxReads-- > 0)) {
+		msleep(2);
+		status = MT2063_ReadSub(pInfo->hUserData,
+					 pInfo->address,
+					 MT2063_REG_XO_STATUS,
+					 &pInfo->
+					 reg[MT2063_REG_XO_STATUS], 1);
+		FCRUN = (pInfo->reg[MT2063_REG_XO_STATUS] & 0x40) >> 6;
 	}
 
-	/* Read back all the registers from the tuner */
-	if (MT2063_NO_ERROR(status))
-		status |= MT2063_ReadSub(pInfo->hUserData,
-					 pInfo->address,
-					 MT2063_REG_PART_REV,
-					 pInfo->reg, MT2063_REG_END_REGS);
+	if (FCRUN != 0)
+		return -ENODEV;
 
-	if (MT2063_NO_ERROR(status)) {
-		/*  Initialize the tuner state.  */
-		pInfo->tuner_id = pInfo->reg[MT2063_REG_PART_REV];
-		pInfo->AS_Data.f_ref = MT2063_REF_FREQ;
-		pInfo->AS_Data.f_if1_Center =
-		    (pInfo->AS_Data.f_ref / 8) *
-		    ((u32) pInfo->reg[MT2063_REG_FIFFC] + 640);
-		pInfo->AS_Data.f_if1_bw = MT2063_IF1_BW;
-		pInfo->AS_Data.f_out = 43750000UL;
-		pInfo->AS_Data.f_out_bw = 6750000UL;
-		pInfo->AS_Data.f_zif_bw = MT2063_ZIF_BW;
-		pInfo->AS_Data.f_LO1_Step = pInfo->AS_Data.f_ref / 64;
-		pInfo->AS_Data.f_LO2_Step = MT2063_TUNE_STEP_SIZE;
-		pInfo->AS_Data.maxH1 = MT2063_MAX_HARMONICS_1;
-		pInfo->AS_Data.maxH2 = MT2063_MAX_HARMONICS_2;
-		pInfo->AS_Data.f_min_LO_Separation = MT2063_MIN_LO_SEP;
-		pInfo->AS_Data.f_if1_Request = pInfo->AS_Data.f_if1_Center;
-		pInfo->AS_Data.f_LO1 = 2181000000UL;
-		pInfo->AS_Data.f_LO2 = 1486249786UL;
-		pInfo->f_IF1_actual = pInfo->AS_Data.f_if1_Center;
-		pInfo->AS_Data.f_in =
-		    pInfo->AS_Data.f_LO1 - pInfo->f_IF1_actual;
-		pInfo->AS_Data.f_LO1_FracN_Avoid = MT2063_LO1_FRACN_AVOID;
-		pInfo->AS_Data.f_LO2_FracN_Avoid = MT2063_LO2_FRACN_AVOID;
-		pInfo->num_regs = MT2063_REG_END_REGS;
-		pInfo->AS_Data.avoidDECT = MT2063_AVOID_BOTH;
-		pInfo->ctfilt_sw = 0;
-	}
+	status = MT2063_ReadSub(pInfo->hUserData, pInfo->address,
+			   MT2063_REG_FIFFC,
+			   &pInfo->reg[MT2063_REG_FIFFC], 1);
+	if (status < 0)
+		return status;
 
-	if (MT2063_NO_ERROR(status)) {
-		pInfo->CTFiltMax[0] = 69230000;
-		pInfo->CTFiltMax[1] = 105770000;
-		pInfo->CTFiltMax[2] = 140350000;
-		pInfo->CTFiltMax[3] = 177110000;
-		pInfo->CTFiltMax[4] = 212860000;
-		pInfo->CTFiltMax[5] = 241130000;
-		pInfo->CTFiltMax[6] = 274370000;
-		pInfo->CTFiltMax[7] = 309820000;
-		pInfo->CTFiltMax[8] = 342450000;
-		pInfo->CTFiltMax[9] = 378870000;
-		pInfo->CTFiltMax[10] = 416210000;
-		pInfo->CTFiltMax[11] = 456500000;
-		pInfo->CTFiltMax[12] = 495790000;
-		pInfo->CTFiltMax[13] = 534530000;
-		pInfo->CTFiltMax[14] = 572610000;
-		pInfo->CTFiltMax[15] = 598970000;
-		pInfo->CTFiltMax[16] = 635910000;
-		pInfo->CTFiltMax[17] = 672130000;
-		pInfo->CTFiltMax[18] = 714840000;
-		pInfo->CTFiltMax[19] = 739660000;
-		pInfo->CTFiltMax[20] = 770410000;
-		pInfo->CTFiltMax[21] = 814660000;
-		pInfo->CTFiltMax[22] = 846950000;
-		pInfo->CTFiltMax[23] = 867820000;
-		pInfo->CTFiltMax[24] = 915980000;
-		pInfo->CTFiltMax[25] = 947450000;
-		pInfo->CTFiltMax[26] = 983110000;
-		pInfo->CTFiltMax[27] = 1021630000;
-		pInfo->CTFiltMax[28] = 1061870000;
-		pInfo->CTFiltMax[29] = 1098330000;
-		pInfo->CTFiltMax[30] = 1138990000;
-	}
+	/* Read back all the registers from the tuner */
+	status = MT2063_ReadSub(pInfo->hUserData,
+				pInfo->address,
+				MT2063_REG_PART_REV,
+				pInfo->reg, MT2063_REG_END_REGS);
+	if (status < 0)
+		return status;
+
+	/*  Initialize the tuner state.  */
+	pInfo->tuner_id = pInfo->reg[MT2063_REG_PART_REV];
+	pInfo->AS_Data.f_ref = MT2063_REF_FREQ;
+	pInfo->AS_Data.f_if1_Center = (pInfo->AS_Data.f_ref / 8) *
+				      ((u32) pInfo->reg[MT2063_REG_FIFFC] + 640);
+	pInfo->AS_Data.f_if1_bw = MT2063_IF1_BW;
+	pInfo->AS_Data.f_out = 43750000UL;
+	pInfo->AS_Data.f_out_bw = 6750000UL;
+	pInfo->AS_Data.f_zif_bw = MT2063_ZIF_BW;
+	pInfo->AS_Data.f_LO1_Step = pInfo->AS_Data.f_ref / 64;
+	pInfo->AS_Data.f_LO2_Step = MT2063_TUNE_STEP_SIZE;
+	pInfo->AS_Data.maxH1 = MT2063_MAX_HARMONICS_1;
+	pInfo->AS_Data.maxH2 = MT2063_MAX_HARMONICS_2;
+	pInfo->AS_Data.f_min_LO_Separation = MT2063_MIN_LO_SEP;
+	pInfo->AS_Data.f_if1_Request = pInfo->AS_Data.f_if1_Center;
+	pInfo->AS_Data.f_LO1 = 2181000000UL;
+	pInfo->AS_Data.f_LO2 = 1486249786UL;
+	pInfo->f_IF1_actual = pInfo->AS_Data.f_if1_Center;
+	pInfo->AS_Data.f_in = pInfo->AS_Data.f_LO1 - pInfo->f_IF1_actual;
+	pInfo->AS_Data.f_LO1_FracN_Avoid = MT2063_LO1_FRACN_AVOID;
+	pInfo->AS_Data.f_LO2_FracN_Avoid = MT2063_LO2_FRACN_AVOID;
+	pInfo->num_regs = MT2063_REG_END_REGS;
+	pInfo->AS_Data.avoidDECT = MT2063_AVOID_BOTH;
+	pInfo->ctfilt_sw = 0;
+
+	pInfo->CTFiltMax[0] = 69230000;
+	pInfo->CTFiltMax[1] = 105770000;
+	pInfo->CTFiltMax[2] = 140350000;
+	pInfo->CTFiltMax[3] = 177110000;
+	pInfo->CTFiltMax[4] = 212860000;
+	pInfo->CTFiltMax[5] = 241130000;
+	pInfo->CTFiltMax[6] = 274370000;
+	pInfo->CTFiltMax[7] = 309820000;
+	pInfo->CTFiltMax[8] = 342450000;
+	pInfo->CTFiltMax[9] = 378870000;
+	pInfo->CTFiltMax[10] = 416210000;
+	pInfo->CTFiltMax[11] = 456500000;
+	pInfo->CTFiltMax[12] = 495790000;
+	pInfo->CTFiltMax[13] = 534530000;
+	pInfo->CTFiltMax[14] = 572610000;
+	pInfo->CTFiltMax[15] = 598970000;
+	pInfo->CTFiltMax[16] = 635910000;
+	pInfo->CTFiltMax[17] = 672130000;
+	pInfo->CTFiltMax[18] = 714840000;
+	pInfo->CTFiltMax[19] = 739660000;
+	pInfo->CTFiltMax[20] = 770410000;
+	pInfo->CTFiltMax[21] = 814660000;
+	pInfo->CTFiltMax[22] = 846950000;
+	pInfo->CTFiltMax[23] = 867820000;
+	pInfo->CTFiltMax[24] = 915980000;
+	pInfo->CTFiltMax[25] = 947450000;
+	pInfo->CTFiltMax[26] = 983110000;
+	pInfo->CTFiltMax[27] = 1021630000;
+	pInfo->CTFiltMax[28] = 1061870000;
+	pInfo->CTFiltMax[29] = 1098330000;
+	pInfo->CTFiltMax[30] = 1138990000;
 
 	/*
 	 **   Fetch the FCU osc value and use it and the fRef value to
 	 **   scale all of the Band Max values
 	 */
-	if (MT2063_NO_ERROR(status)) {
-		u32 fcu_osc;
-		u32 i;
 
-		pInfo->reg[MT2063_REG_CTUNE_CTRL] = 0x0A;
-		status |=
-		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
-				    MT2063_REG_CTUNE_CTRL,
-				    &pInfo->reg[MT2063_REG_CTUNE_CTRL], 1);
-		/*  Read the ClearTune filter calibration value  */
-		status |=
-		    MT2063_ReadSub(pInfo->hUserData, pInfo->address,
-				   MT2063_REG_FIFFC,
-				   &pInfo->reg[MT2063_REG_FIFFC], 1);
-		fcu_osc = pInfo->reg[MT2063_REG_FIFFC];
-
-		pInfo->reg[MT2063_REG_CTUNE_CTRL] = 0x00;
-		status |=
-		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
-				    MT2063_REG_CTUNE_CTRL,
-				    &pInfo->reg[MT2063_REG_CTUNE_CTRL], 1);
-
-		/*  Adjust each of the values in the ClearTune filter cross-over table  */
-		for (i = 0; i < 31; i++) {
-			pInfo->CTFiltMax[i] =
-			    (pInfo->CTFiltMax[i] / 768) * (fcu_osc + 640);
-		}
-	}
+	pInfo->reg[MT2063_REG_CTUNE_CTRL] = 0x0A;
+	status = MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+				 MT2063_REG_CTUNE_CTRL,
+				 &pInfo->reg[MT2063_REG_CTUNE_CTRL], 1);
+	if (status < 0)
+		return status;
+	/*  Read the ClearTune filter calibration value  */
+	status = MT2063_ReadSub(pInfo->hUserData, pInfo->address,
+			        MT2063_REG_FIFFC,
+			        &pInfo->reg[MT2063_REG_FIFFC], 1);
+	if (status < 0)
+		return status;
+
+	fcu_osc = pInfo->reg[MT2063_REG_FIFFC];
+
+	pInfo->reg[MT2063_REG_CTUNE_CTRL] = 0x00;
+	status = MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+				 MT2063_REG_CTUNE_CTRL,
+				 &pInfo->reg[MT2063_REG_CTUNE_CTRL], 1);
+	if (status < 0)
+		return status;
+
+	/*  Adjust each of the values in the ClearTune filter cross-over table  */
+	for (i = 0; i < 31; i++)
+		pInfo->CTFiltMax[i] =(pInfo->CTFiltMax[i] / 768) * (fcu_osc + 640);
 
 	return (status);
 }
@@ -3290,595 +3221,592 @@ static u32 MT2063_ReInit(void *h)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-static u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue)
+static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param, u32 nValue)
 {
-	u32 status = MT2063_OK;	/* Status to be returned        */
+	u32 status = 0;	/* Status to be returned        */
 	u8 val = 0;
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
 	if (MT2063_IsValidHandle(pInfo) == 0)
-		status |= MT2063_INV_HANDLE;
-
-	if (MT2063_NO_ERROR(status)) {
-		switch (param) {
-			/*  crystal frequency                     */
-		case MT2063_SRO_FREQ:
-			pInfo->AS_Data.f_ref = nValue;
-			pInfo->AS_Data.f_LO1_FracN_Avoid = 0;
-			pInfo->AS_Data.f_LO2_FracN_Avoid = nValue / 80 - 1;
-			pInfo->AS_Data.f_LO1_Step = nValue / 64;
-			pInfo->AS_Data.f_if1_Center =
-			    (pInfo->AS_Data.f_ref / 8) *
-			    (pInfo->reg[MT2063_REG_FIFFC] + 640);
-			break;
-
-			/*  minimum tuning step size              */
-		case MT2063_STEPSIZE:
-			pInfo->AS_Data.f_LO2_Step = nValue;
-			break;
+		return -ENODEV;
 
-			/*  LO1 frequency                         */
-		case MT2063_LO1_FREQ:
-			{
-				/* Note: LO1 and LO2 are BOTH written at toggle of LDLOos  */
-				/* Capture the Divider and Numerator portions of other LO  */
-				u8 tempLO2CQ[3];
-				u8 tempLO2C[3];
-				u8 tmpOneShot;
-				u32 Div, FracN;
-				u8 restore = 0;
-
-				/* Buffer the queue for restoration later and get actual LO2 values. */
-				status |=
-				    MT2063_ReadSub(pInfo->hUserData,
-						   pInfo->address,
-						   MT2063_REG_LO2CQ_1,
-						   &(tempLO2CQ[0]), 3);
-				status |=
-				    MT2063_ReadSub(pInfo->hUserData,
-						   pInfo->address,
-						   MT2063_REG_LO2C_1,
-						   &(tempLO2C[0]), 3);
-
-				/* clear the one-shot bits */
-				tempLO2CQ[2] = tempLO2CQ[2] & 0x0F;
-				tempLO2C[2] = tempLO2C[2] & 0x0F;
-
-				/* only write the queue values if they are different from the actual. */
-				if ((tempLO2CQ[0] != tempLO2C[0]) ||
-				    (tempLO2CQ[1] != tempLO2C[1]) ||
-				    (tempLO2CQ[2] != tempLO2C[2])) {
-					/* put actual LO2 value into queue (with 0 in one-shot bits) */
-					status |=
-					    MT2063_WriteSub(pInfo->hUserData,
-							    pInfo->address,
-							    MT2063_REG_LO2CQ_1,
-							    &(tempLO2C[0]), 3);
-
-					if (status == MT2063_OK) {
-						/* cache the bytes just written. */
-						pInfo->reg[MT2063_REG_LO2CQ_1] =
-						    tempLO2C[0];
-						pInfo->reg[MT2063_REG_LO2CQ_2] =
-						    tempLO2C[1];
-						pInfo->reg[MT2063_REG_LO2CQ_3] =
-						    tempLO2C[2];
-					}
-					restore = 1;
-				}
+	switch (param) {
+		/*  crystal frequency                     */
+	case MT2063_SRO_FREQ:
+		pInfo->AS_Data.f_ref = nValue;
+		pInfo->AS_Data.f_LO1_FracN_Avoid = 0;
+		pInfo->AS_Data.f_LO2_FracN_Avoid = nValue / 80 - 1;
+		pInfo->AS_Data.f_LO1_Step = nValue / 64;
+		pInfo->AS_Data.f_if1_Center =
+		    (pInfo->AS_Data.f_ref / 8) *
+		    (pInfo->reg[MT2063_REG_FIFFC] + 640);
+		break;
 
-				/* Calculate the Divider and Numberator components of LO1 */
-				status =
-				    MT2063_CalcLO1Mult(&Div, &FracN, nValue,
-						       pInfo->AS_Data.f_ref /
-						       64,
-						       pInfo->AS_Data.f_ref);
-				pInfo->reg[MT2063_REG_LO1CQ_1] =
-				    (u8) (Div & 0x00FF);
-				pInfo->reg[MT2063_REG_LO1CQ_2] =
-				    (u8) (FracN);
-				status |=
-				    MT2063_WriteSub(pInfo->hUserData,
-						    pInfo->address,
-						    MT2063_REG_LO1CQ_1,
-						    &pInfo->
-						    reg[MT2063_REG_LO1CQ_1], 2);
+		/*  minimum tuning step size              */
+	case MT2063_STEPSIZE:
+		pInfo->AS_Data.f_LO2_Step = nValue;
+		break;
 
-				/* set the one-shot bit to load the pair of LO values */
-				tmpOneShot = tempLO2CQ[2] | 0xE0;
+		/*  LO1 frequency                         */
+	case MT2063_LO1_FREQ:
+		{
+			/* Note: LO1 and LO2 are BOTH written at toggle of LDLOos  */
+			/* Capture the Divider and Numerator portions of other LO  */
+			u8 tempLO2CQ[3];
+			u8 tempLO2C[3];
+			u8 tmpOneShot;
+			u32 Div, FracN;
+			u8 restore = 0;
+
+			/* Buffer the queue for restoration later and get actual LO2 values. */
+			status |=
+			    MT2063_ReadSub(pInfo->hUserData,
+					   pInfo->address,
+					   MT2063_REG_LO2CQ_1,
+					   &(tempLO2CQ[0]), 3);
+			status |=
+			    MT2063_ReadSub(pInfo->hUserData,
+					   pInfo->address,
+					   MT2063_REG_LO2C_1,
+					   &(tempLO2C[0]), 3);
+
+			/* clear the one-shot bits */
+			tempLO2CQ[2] = tempLO2CQ[2] & 0x0F;
+			tempLO2C[2] = tempLO2C[2] & 0x0F;
+
+			/* only write the queue values if they are different from the actual. */
+			if ((tempLO2CQ[0] != tempLO2C[0]) ||
+			    (tempLO2CQ[1] != tempLO2C[1]) ||
+			    (tempLO2CQ[2] != tempLO2C[2])) {
+				/* put actual LO2 value into queue (with 0 in one-shot bits) */
 				status |=
 				    MT2063_WriteSub(pInfo->hUserData,
 						    pInfo->address,
-						    MT2063_REG_LO2CQ_3,
-						    &tmpOneShot, 1);
-
-				/* only restore the queue values if they were different from the actual. */
-				if (restore) {
-					/* put actual LO2 value into queue (0 in one-shot bits) */
-					status |=
-					    MT2063_WriteSub(pInfo->hUserData,
-							    pInfo->address,
-							    MT2063_REG_LO2CQ_1,
-							    &(tempLO2CQ[0]), 3);
+						    MT2063_REG_LO2CQ_1,
+						    &(tempLO2C[0]), 3);
 
+				if (status == 0) {
 					/* cache the bytes just written. */
 					pInfo->reg[MT2063_REG_LO2CQ_1] =
-					    tempLO2CQ[0];
+					    tempLO2C[0];
 					pInfo->reg[MT2063_REG_LO2CQ_2] =
-					    tempLO2CQ[1];
+					    tempLO2C[1];
 					pInfo->reg[MT2063_REG_LO2CQ_3] =
-					    tempLO2CQ[2];
+					    tempLO2C[2];
 				}
-
-				MT2063_GetParam(pInfo->hUserData,
-						MT2063_LO1_FREQ,
-						&pInfo->AS_Data.f_LO1);
+				restore = 1;
 			}
-			break;
 
-			/*  LO1 minimum step size                 */
-		case MT2063_LO1_STEPSIZE:
-			pInfo->AS_Data.f_LO1_Step = nValue;
-			break;
+			/* Calculate the Divider and Numberator components of LO1 */
+			status =
+			    MT2063_CalcLO1Mult(&Div, &FracN, nValue,
+					       pInfo->AS_Data.f_ref /
+					       64,
+					       pInfo->AS_Data.f_ref);
+			pInfo->reg[MT2063_REG_LO1CQ_1] =
+			    (u8) (Div & 0x00FF);
+			pInfo->reg[MT2063_REG_LO1CQ_2] =
+			    (u8) (FracN);
+			status |=
+			    MT2063_WriteSub(pInfo->hUserData,
+					    pInfo->address,
+					    MT2063_REG_LO1CQ_1,
+					    &pInfo->
+					    reg[MT2063_REG_LO1CQ_1], 2);
+
+			/* set the one-shot bit to load the pair of LO values */
+			tmpOneShot = tempLO2CQ[2] | 0xE0;
+			status |=
+			    MT2063_WriteSub(pInfo->hUserData,
+					    pInfo->address,
+					    MT2063_REG_LO2CQ_3,
+					    &tmpOneShot, 1);
+
+			/* only restore the queue values if they were different from the actual. */
+			if (restore) {
+				/* put actual LO2 value into queue (0 in one-shot bits) */
+				status |=
+				    MT2063_WriteSub(pInfo->hUserData,
+						    pInfo->address,
+						    MT2063_REG_LO2CQ_1,
+						    &(tempLO2CQ[0]), 3);
 
-			/*  LO1 FracN keep-out region             */
-		case MT2063_LO1_FRACN_AVOID_PARAM:
-			pInfo->AS_Data.f_LO1_FracN_Avoid = nValue;
-			break;
+				/* cache the bytes just written. */
+				pInfo->reg[MT2063_REG_LO2CQ_1] =
+				    tempLO2CQ[0];
+				pInfo->reg[MT2063_REG_LO2CQ_2] =
+				    tempLO2CQ[1];
+				pInfo->reg[MT2063_REG_LO2CQ_3] =
+				    tempLO2CQ[2];
+			}
 
-			/*  Requested 1st IF                      */
-		case MT2063_IF1_REQUEST:
-			pInfo->AS_Data.f_if1_Request = nValue;
-			break;
+			MT2063_GetParam(pInfo->hUserData,
+					MT2063_LO1_FREQ,
+					&pInfo->AS_Data.f_LO1);
+		}
+		break;
 
-			/*  zero-IF bandwidth                     */
-		case MT2063_ZIF_BW:
-			pInfo->AS_Data.f_zif_bw = nValue;
-			break;
+		/*  LO1 minimum step size                 */
+	case MT2063_LO1_STEPSIZE:
+		pInfo->AS_Data.f_LO1_Step = nValue;
+		break;
 
-			/*  LO2 frequency                         */
-		case MT2063_LO2_FREQ:
-			{
-				/* Note: LO1 and LO2 are BOTH written at toggle of LDLOos  */
-				/* Capture the Divider and Numerator portions of other LO  */
-				u8 tempLO1CQ[2];
-				u8 tempLO1C[2];
-				u32 Div2;
-				u32 FracN2;
-				u8 tmpOneShot;
-				u8 restore = 0;
-
-				/* Buffer the queue for restoration later and get actual LO2 values. */
-				status |=
-				    MT2063_ReadSub(pInfo->hUserData,
-						   pInfo->address,
-						   MT2063_REG_LO1CQ_1,
-						   &(tempLO1CQ[0]), 2);
-				status |=
-				    MT2063_ReadSub(pInfo->hUserData,
-						   pInfo->address,
-						   MT2063_REG_LO1C_1,
-						   &(tempLO1C[0]), 2);
-
-				/* only write the queue values if they are different from the actual. */
-				if ((tempLO1CQ[0] != tempLO1C[0])
-				    || (tempLO1CQ[1] != tempLO1C[1])) {
-					/* put actual LO1 value into queue */
-					status |=
-					    MT2063_WriteSub(pInfo->hUserData,
-							    pInfo->address,
-							    MT2063_REG_LO1CQ_1,
-							    &(tempLO1C[0]), 2);
+		/*  LO1 FracN keep-out region             */
+	case MT2063_LO1_FRACN_AVOID_PARAM:
+		pInfo->AS_Data.f_LO1_FracN_Avoid = nValue;
+		break;
 
-					/* cache the bytes just written. */
-					pInfo->reg[MT2063_REG_LO1CQ_1] =
-					    tempLO1C[0];
-					pInfo->reg[MT2063_REG_LO1CQ_2] =
-					    tempLO1C[1];
-					restore = 1;
-				}
+		/*  Requested 1st IF                      */
+	case MT2063_IF1_REQUEST:
+		pInfo->AS_Data.f_if1_Request = nValue;
+		break;
 
-				/* Calculate the Divider and Numberator components of LO2 */
-				status =
-				    MT2063_CalcLO2Mult(&Div2, &FracN2, nValue,
-						       pInfo->AS_Data.f_ref /
-						       8191,
-						       pInfo->AS_Data.f_ref);
-				pInfo->reg[MT2063_REG_LO2CQ_1] =
-				    (u8) ((Div2 << 1) |
-					      ((FracN2 >> 12) & 0x01)) & 0xFF;
-				pInfo->reg[MT2063_REG_LO2CQ_2] =
-				    (u8) ((FracN2 >> 4) & 0xFF);
-				pInfo->reg[MT2063_REG_LO2CQ_3] =
-				    (u8) ((FracN2 & 0x0F));
+		/*  zero-IF bandwidth                     */
+	case MT2063_ZIF_BW:
+		pInfo->AS_Data.f_zif_bw = nValue;
+		break;
+
+		/*  LO2 frequency                         */
+	case MT2063_LO2_FREQ:
+		{
+			/* Note: LO1 and LO2 are BOTH written at toggle of LDLOos  */
+			/* Capture the Divider and Numerator portions of other LO  */
+			u8 tempLO1CQ[2];
+			u8 tempLO1C[2];
+			u32 Div2;
+			u32 FracN2;
+			u8 tmpOneShot;
+			u8 restore = 0;
+
+			/* Buffer the queue for restoration later and get actual LO2 values. */
+			status |=
+			    MT2063_ReadSub(pInfo->hUserData,
+					   pInfo->address,
+					   MT2063_REG_LO1CQ_1,
+					   &(tempLO1CQ[0]), 2);
+			status |=
+			    MT2063_ReadSub(pInfo->hUserData,
+					   pInfo->address,
+					   MT2063_REG_LO1C_1,
+					   &(tempLO1C[0]), 2);
+
+			/* only write the queue values if they are different from the actual. */
+			if ((tempLO1CQ[0] != tempLO1C[0])
+			    || (tempLO1CQ[1] != tempLO1C[1])) {
+				/* put actual LO1 value into queue */
 				status |=
 				    MT2063_WriteSub(pInfo->hUserData,
 						    pInfo->address,
 						    MT2063_REG_LO1CQ_1,
-						    &pInfo->
-						    reg[MT2063_REG_LO1CQ_1], 3);
+						    &(tempLO1C[0]), 2);
+
+				/* cache the bytes just written. */
+				pInfo->reg[MT2063_REG_LO1CQ_1] =
+				    tempLO1C[0];
+				pInfo->reg[MT2063_REG_LO1CQ_2] =
+				    tempLO1C[1];
+				restore = 1;
+			}
 
-				/* set the one-shot bit to load the LO values */
-				tmpOneShot =
-				    pInfo->reg[MT2063_REG_LO2CQ_3] | 0xE0;
+			/* Calculate the Divider and Numberator components of LO2 */
+			status =
+			    MT2063_CalcLO2Mult(&Div2, &FracN2, nValue,
+					       pInfo->AS_Data.f_ref /
+					       8191,
+					       pInfo->AS_Data.f_ref);
+			pInfo->reg[MT2063_REG_LO2CQ_1] =
+			    (u8) ((Div2 << 1) |
+				      ((FracN2 >> 12) & 0x01)) & 0xFF;
+			pInfo->reg[MT2063_REG_LO2CQ_2] =
+			    (u8) ((FracN2 >> 4) & 0xFF);
+			pInfo->reg[MT2063_REG_LO2CQ_3] =
+			    (u8) ((FracN2 & 0x0F));
+			status |=
+			    MT2063_WriteSub(pInfo->hUserData,
+					    pInfo->address,
+					    MT2063_REG_LO1CQ_1,
+					    &pInfo->
+					    reg[MT2063_REG_LO1CQ_1], 3);
+
+			/* set the one-shot bit to load the LO values */
+			tmpOneShot =
+			    pInfo->reg[MT2063_REG_LO2CQ_3] | 0xE0;
+			status |=
+			    MT2063_WriteSub(pInfo->hUserData,
+					    pInfo->address,
+					    MT2063_REG_LO2CQ_3,
+					    &tmpOneShot, 1);
+
+			/* only restore LO1 queue value if they were different from the actual. */
+			if (restore) {
+				/* put previous LO1 queue value back into queue */
 				status |=
 				    MT2063_WriteSub(pInfo->hUserData,
 						    pInfo->address,
-						    MT2063_REG_LO2CQ_3,
-						    &tmpOneShot, 1);
+						    MT2063_REG_LO1CQ_1,
+						    &(tempLO1CQ[0]), 2);
 
-				/* only restore LO1 queue value if they were different from the actual. */
-				if (restore) {
-					/* put previous LO1 queue value back into queue */
-					status |=
-					    MT2063_WriteSub(pInfo->hUserData,
-							    pInfo->address,
-							    MT2063_REG_LO1CQ_1,
-							    &(tempLO1CQ[0]), 2);
+				/* cache the bytes just written. */
+				pInfo->reg[MT2063_REG_LO1CQ_1] =
+				    tempLO1CQ[0];
+				pInfo->reg[MT2063_REG_LO1CQ_2] =
+				    tempLO1CQ[1];
+			}
 
-					/* cache the bytes just written. */
-					pInfo->reg[MT2063_REG_LO1CQ_1] =
-					    tempLO1CQ[0];
-					pInfo->reg[MT2063_REG_LO1CQ_2] =
-					    tempLO1CQ[1];
-				}
+			MT2063_GetParam(pInfo->hUserData,
+					MT2063_LO2_FREQ,
+					&pInfo->AS_Data.f_LO2);
+		}
+		break;
 
-				MT2063_GetParam(pInfo->hUserData,
-						MT2063_LO2_FREQ,
-						&pInfo->AS_Data.f_LO2);
-			}
-			break;
+		/*  LO2 minimum step size                 */
+	case MT2063_LO2_STEPSIZE:
+		pInfo->AS_Data.f_LO2_Step = nValue;
+		break;
 
-			/*  LO2 minimum step size                 */
-		case MT2063_LO2_STEPSIZE:
-			pInfo->AS_Data.f_LO2_Step = nValue;
-			break;
+		/*  LO2 FracN keep-out region             */
+	case MT2063_LO2_FRACN_AVOID:
+		pInfo->AS_Data.f_LO2_FracN_Avoid = nValue;
+		break;
 
-			/*  LO2 FracN keep-out region             */
-		case MT2063_LO2_FRACN_AVOID:
-			pInfo->AS_Data.f_LO2_FracN_Avoid = nValue;
-			break;
+		/*  output center frequency               */
+	case MT2063_OUTPUT_FREQ:
+		pInfo->AS_Data.f_out = nValue;
+		break;
 
-			/*  output center frequency               */
-		case MT2063_OUTPUT_FREQ:
-			pInfo->AS_Data.f_out = nValue;
-			break;
+		/*  output bandwidth                      */
+	case MT2063_OUTPUT_BW:
+		pInfo->AS_Data.f_out_bw = nValue + 750000;
+		break;
 
-			/*  output bandwidth                      */
-		case MT2063_OUTPUT_BW:
-			pInfo->AS_Data.f_out_bw = nValue + 750000;
-			break;
+		/*  min inter-tuner LO separation         */
+	case MT2063_LO_SEPARATION:
+		pInfo->AS_Data.f_min_LO_Separation = nValue;
+		break;
 
-			/*  min inter-tuner LO separation         */
-		case MT2063_LO_SEPARATION:
-			pInfo->AS_Data.f_min_LO_Separation = nValue;
-			break;
+		/*  max # of intra-tuner harmonics        */
+	case MT2063_MAX_HARM1:
+		pInfo->AS_Data.maxH1 = nValue;
+		break;
 
-			/*  max # of intra-tuner harmonics        */
-		case MT2063_MAX_HARM1:
-			pInfo->AS_Data.maxH1 = nValue;
-			break;
+		/*  max # of inter-tuner harmonics        */
+	case MT2063_MAX_HARM2:
+		pInfo->AS_Data.maxH2 = nValue;
+		break;
 
-			/*  max # of inter-tuner harmonics        */
-		case MT2063_MAX_HARM2:
-			pInfo->AS_Data.maxH2 = nValue;
-			break;
+	case MT2063_RCVR_MODE:
+		status |=
+		    MT2063_SetReceiverMode(pInfo,
+					   (enum MT2063_RCVR_MODES)
+					   nValue);
+		break;
 
-		case MT2063_RCVR_MODE:
+		/* Set LNA Rin -- nValue is desired value */
+	case MT2063_LNA_RIN:
+		val =
+		    (pInfo->
+		     reg[MT2063_REG_CTRL_2C] & (u8) ~ 0x03) |
+		    (nValue & 0x03);
+		if (pInfo->reg[MT2063_REG_CTRL_2C] != val) {
 			status |=
-			    MT2063_SetReceiverMode(pInfo,
-						   (enum MT2063_RCVR_MODES)
-						   nValue);
-			break;
+			    MT2063_SetReg(pInfo, MT2063_REG_CTRL_2C,
+					  val);
+		}
+		break;
 
-			/* Set LNA Rin -- nValue is desired value */
-		case MT2063_LNA_RIN:
-			val =
-			    (pInfo->
-			     reg[MT2063_REG_CTRL_2C] & (u8) ~ 0x03) |
-			    (nValue & 0x03);
-			if (pInfo->reg[MT2063_REG_CTRL_2C] != val) {
-				status |=
-				    MT2063_SetReg(pInfo, MT2063_REG_CTRL_2C,
-						  val);
-			}
-			break;
+		/* Set target power level at LNA -- nValue is desired value */
+	case MT2063_LNA_TGT:
+		val =
+		    (pInfo->
+		     reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x3F) |
+		    (nValue & 0x3F);
+		if (pInfo->reg[MT2063_REG_LNA_TGT] != val) {
+			status |=
+			    MT2063_SetReg(pInfo, MT2063_REG_LNA_TGT,
+					  val);
+		}
+		break;
 
-			/* Set target power level at LNA -- nValue is desired value */
-		case MT2063_LNA_TGT:
-			val =
-			    (pInfo->
-			     reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x3F) |
-			    (nValue & 0x3F);
-			if (pInfo->reg[MT2063_REG_LNA_TGT] != val) {
-				status |=
-				    MT2063_SetReg(pInfo, MT2063_REG_LNA_TGT,
-						  val);
-			}
-			break;
+		/* Set target power level at PD1 -- nValue is desired value */
+	case MT2063_PD1_TGT:
+		val =
+		    (pInfo->
+		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x3F) |
+		    (nValue & 0x3F);
+		if (pInfo->reg[MT2063_REG_PD1_TGT] != val) {
+			status |=
+			    MT2063_SetReg(pInfo, MT2063_REG_PD1_TGT,
+					  val);
+		}
+		break;
 
-			/* Set target power level at PD1 -- nValue is desired value */
-		case MT2063_PD1_TGT:
-			val =
-			    (pInfo->
-			     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x3F) |
-			    (nValue & 0x3F);
-			if (pInfo->reg[MT2063_REG_PD1_TGT] != val) {
-				status |=
-				    MT2063_SetReg(pInfo, MT2063_REG_PD1_TGT,
-						  val);
-			}
-			break;
+		/* Set target power level at PD2 -- nValue is desired value */
+	case MT2063_PD2_TGT:
+		val =
+		    (pInfo->
+		     reg[MT2063_REG_PD2_TGT] & (u8) ~ 0x3F) |
+		    (nValue & 0x3F);
+		if (pInfo->reg[MT2063_REG_PD2_TGT] != val) {
+			status |=
+			    MT2063_SetReg(pInfo, MT2063_REG_PD2_TGT,
+					  val);
+		}
+		break;
 
-			/* Set target power level at PD2 -- nValue is desired value */
-		case MT2063_PD2_TGT:
-			val =
-			    (pInfo->
-			     reg[MT2063_REG_PD2_TGT] & (u8) ~ 0x3F) |
-			    (nValue & 0x3F);
-			if (pInfo->reg[MT2063_REG_PD2_TGT] != val) {
-				status |=
-				    MT2063_SetReg(pInfo, MT2063_REG_PD2_TGT,
-						  val);
-			}
-			break;
+		/* Set LNA atten limit -- nValue is desired value */
+	case MT2063_ACLNA_MAX:
+		val =
+		    (pInfo->
+		     reg[MT2063_REG_LNA_OV] & (u8) ~ 0x1F) | (nValue
+								  &
+								  0x1F);
+		if (pInfo->reg[MT2063_REG_LNA_OV] != val) {
+			status |=
+			    MT2063_SetReg(pInfo, MT2063_REG_LNA_OV,
+					  val);
+		}
+		break;
 
-			/* Set LNA atten limit -- nValue is desired value */
-		case MT2063_ACLNA_MAX:
-			val =
-			    (pInfo->
-			     reg[MT2063_REG_LNA_OV] & (u8) ~ 0x1F) | (nValue
-									  &
-									  0x1F);
-			if (pInfo->reg[MT2063_REG_LNA_OV] != val) {
-				status |=
-				    MT2063_SetReg(pInfo, MT2063_REG_LNA_OV,
-						  val);
-			}
-			break;
+		/* Set RF atten limit -- nValue is desired value */
+	case MT2063_ACRF_MAX:
+		val =
+		    (pInfo->
+		     reg[MT2063_REG_RF_OV] & (u8) ~ 0x1F) | (nValue
+								 &
+								 0x1F);
+		if (pInfo->reg[MT2063_REG_RF_OV] != val) {
+			status |=
+			    MT2063_SetReg(pInfo, MT2063_REG_RF_OV, val);
+		}
+		break;
 
-			/* Set RF atten limit -- nValue is desired value */
-		case MT2063_ACRF_MAX:
-			val =
-			    (pInfo->
-			     reg[MT2063_REG_RF_OV] & (u8) ~ 0x1F) | (nValue
-									 &
-									 0x1F);
-			if (pInfo->reg[MT2063_REG_RF_OV] != val) {
-				status |=
-				    MT2063_SetReg(pInfo, MT2063_REG_RF_OV, val);
-			}
-			break;
+		/* Set FIF atten limit -- nValue is desired value, max. 5 if no B3 */
+	case MT2063_ACFIF_MAX:
+		if (pInfo->reg[MT2063_REG_PART_REV] != MT2063_B3
+		    && nValue > 5)
+			nValue = 5;
+		val =
+		    (pInfo->
+		     reg[MT2063_REG_FIF_OV] & (u8) ~ 0x1F) | (nValue
+								  &
+								  0x1F);
+		if (pInfo->reg[MT2063_REG_FIF_OV] != val) {
+			status |=
+			    MT2063_SetReg(pInfo, MT2063_REG_FIF_OV,
+					  val);
+		}
+		break;
 
-			/* Set FIF atten limit -- nValue is desired value, max. 5 if no B3 */
-		case MT2063_ACFIF_MAX:
-			if (pInfo->reg[MT2063_REG_PART_REV] != MT2063_B3
-			    && nValue > 5)
-				nValue = 5;
-			val =
-			    (pInfo->
-			     reg[MT2063_REG_FIF_OV] & (u8) ~ 0x1F) | (nValue
-									  &
-									  0x1F);
-			if (pInfo->reg[MT2063_REG_FIF_OV] != val) {
-				status |=
-				    MT2063_SetReg(pInfo, MT2063_REG_FIF_OV,
-						  val);
-			}
-			break;
+	case MT2063_DNC_OUTPUT_ENABLE:
+		/* selects, which DNC output is used */
+		switch ((enum MT2063_DNC_Output_Enable)nValue) {
+		case MT2063_DNC_NONE:
+			{
+				val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
+				if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_DNC_GAIN,
+							  val);
+
+				val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
+				if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_VGA_GAIN,
+							  val);
+
+				val = (pInfo->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
+				if (pInfo->reg[MT2063_REG_RSVD_20] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_RSVD_20,
+							  val);
 
-		case MT2063_DNC_OUTPUT_ENABLE:
-			/* selects, which DNC output is used */
-			switch ((enum MT2063_DNC_Output_Enable)nValue) {
-			case MT2063_DNC_NONE:
-				{
-					val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
-					if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_DNC_GAIN,
-								  val);
-
-					val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
-					if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_VGA_GAIN,
-								  val);
-
-					val = (pInfo->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
-					if (pInfo->reg[MT2063_REG_RSVD_20] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_RSVD_20,
-								  val);
-
-					break;
-				}
-			case MT2063_DNC_1:
-				{
-					val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
-					if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_DNC_GAIN,
-								  val);
-
-					val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
-					if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_VGA_GAIN,
-								  val);
-
-					val = (pInfo->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
-					if (pInfo->reg[MT2063_REG_RSVD_20] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_RSVD_20,
-								  val);
-
-					break;
-				}
-			case MT2063_DNC_2:
-				{
-					val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
-					if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_DNC_GAIN,
-								  val);
-
-					val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
-					if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_VGA_GAIN,
-								  val);
-
-					val = (pInfo->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
-					if (pInfo->reg[MT2063_REG_RSVD_20] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_RSVD_20,
-								  val);
-
-					break;
-				}
-			case MT2063_DNC_BOTH:
-				{
-					val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
-					if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_DNC_GAIN,
-								  val);
-
-					val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
-					if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_VGA_GAIN,
-								  val);
-
-					val = (pInfo->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
-					if (pInfo->reg[MT2063_REG_RSVD_20] !=
-					    val)
-						status |=
-						    MT2063_SetReg(h,
-								  MT2063_REG_RSVD_20,
-								  val);
-
-					break;
-				}
-			default:
 				break;
 			}
-			break;
+		case MT2063_DNC_1:
+			{
+				val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
+				if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_DNC_GAIN,
+							  val);
 
-		case MT2063_VGAGC:
-			/* Set VGA gain code */
-			val =
-			    (pInfo->
-			     reg[MT2063_REG_VGA_GAIN] & (u8) ~ 0x0C) |
-			    ((nValue & 0x03) << 2);
-			if (pInfo->reg[MT2063_REG_VGA_GAIN] != val) {
-				status |=
-				    MT2063_SetReg(pInfo, MT2063_REG_VGA_GAIN,
-						  val);
-			}
-			break;
+				val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
+				if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_VGA_GAIN,
+							  val);
 
-		case MT2063_VGAOI:
-			/* Set VGA bias current */
-			val =
-			    (pInfo->
-			     reg[MT2063_REG_RSVD_31] & (u8) ~ 0x07) |
-			    (nValue & 0x07);
-			if (pInfo->reg[MT2063_REG_RSVD_31] != val) {
-				status |=
-				    MT2063_SetReg(pInfo, MT2063_REG_RSVD_31,
-						  val);
-			}
-			break;
+				val = (pInfo->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
+				if (pInfo->reg[MT2063_REG_RSVD_20] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_RSVD_20,
+							  val);
 
-		case MT2063_TAGC:
-			/* Set TAGC */
-			val =
-			    (pInfo->
-			     reg[MT2063_REG_RSVD_1E] & (u8) ~ 0x03) |
-			    (nValue & 0x03);
-			if (pInfo->reg[MT2063_REG_RSVD_1E] != val) {
-				status |=
-				    MT2063_SetReg(pInfo, MT2063_REG_RSVD_1E,
-						  val);
+				break;
 			}
-			break;
+		case MT2063_DNC_2:
+			{
+				val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
+				if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_DNC_GAIN,
+							  val);
 
-		case MT2063_AMPGC:
-			/* Set Amp gain code */
-			val =
-			    (pInfo->
-			     reg[MT2063_REG_TEMP_SEL] & (u8) ~ 0x03) |
-			    (nValue & 0x03);
-			if (pInfo->reg[MT2063_REG_TEMP_SEL] != val) {
-				status |=
-				    MT2063_SetReg(pInfo, MT2063_REG_TEMP_SEL,
-						  val);
-			}
-			break;
+				val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
+				if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_VGA_GAIN,
+							  val);
+
+				val = (pInfo->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
+				if (pInfo->reg[MT2063_REG_RSVD_20] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_RSVD_20,
+							  val);
 
-			/*  Avoid DECT Frequencies                */
-		case MT2063_AVOID_DECT:
+				break;
+			}
+		case MT2063_DNC_BOTH:
 			{
-				enum MT2063_DECT_Avoid_Type newAvoidSetting =
-				    (enum MT2063_DECT_Avoid_Type)nValue;
-				if ((newAvoidSetting >=
-				     MT2063_NO_DECT_AVOIDANCE)
-				    && (newAvoidSetting <= MT2063_AVOID_BOTH)) {
-					pInfo->AS_Data.avoidDECT =
-					    newAvoidSetting;
-				}
+				val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
+				if (pInfo->reg[MT2063_REG_DNC_GAIN] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_DNC_GAIN,
+							  val);
+
+				val = (pInfo->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[pInfo->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
+				if (pInfo->reg[MT2063_REG_VGA_GAIN] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_VGA_GAIN,
+							  val);
+
+				val = (pInfo->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
+				if (pInfo->reg[MT2063_REG_RSVD_20] !=
+				    val)
+					status |=
+					    MT2063_SetReg(pInfo,
+							  MT2063_REG_RSVD_20,
+							  val);
+
+				break;
 			}
+		default:
 			break;
+		}
+		break;
 
-			/*  Cleartune filter selection: 0 - by IC (default), 1 - by software  */
-		case MT2063_CTFILT_SW:
-			pInfo->ctfilt_sw = (nValue & 0x01);
-			break;
+	case MT2063_VGAGC:
+		/* Set VGA gain code */
+		val =
+		    (pInfo->
+		     reg[MT2063_REG_VGA_GAIN] & (u8) ~ 0x0C) |
+		    ((nValue & 0x03) << 2);
+		if (pInfo->reg[MT2063_REG_VGA_GAIN] != val) {
+			status |=
+			    MT2063_SetReg(pInfo, MT2063_REG_VGA_GAIN,
+					  val);
+		}
+		break;
 
-			/*  These parameters are read-only  */
-		case MT2063_IC_ADDR:
-		case MT2063_MAX_OPEN:
-		case MT2063_NUM_OPEN:
-		case MT2063_INPUT_FREQ:
-		case MT2063_IF1_ACTUAL:
-		case MT2063_IF1_CENTER:
-		case MT2063_IF1_BW:
-		case MT2063_AS_ALG:
-		case MT2063_EXCL_ZONES:
-		case MT2063_SPUR_AVOIDED:
-		case MT2063_NUM_SPURS:
-		case MT2063_SPUR_PRESENT:
-		case MT2063_ACLNA:
-		case MT2063_ACRF:
-		case MT2063_ACFIF:
-		case MT2063_EOP:
-		default:
-			status |= MT2063_ARG_RANGE;
+	case MT2063_VGAOI:
+		/* Set VGA bias current */
+		val =
+		    (pInfo->
+		     reg[MT2063_REG_RSVD_31] & (u8) ~ 0x07) |
+		    (nValue & 0x07);
+		if (pInfo->reg[MT2063_REG_RSVD_31] != val) {
+			status |=
+			    MT2063_SetReg(pInfo, MT2063_REG_RSVD_31,
+					  val);
 		}
+		break;
+
+	case MT2063_TAGC:
+		/* Set TAGC */
+		val =
+		    (pInfo->
+		     reg[MT2063_REG_RSVD_1E] & (u8) ~ 0x03) |
+		    (nValue & 0x03);
+		if (pInfo->reg[MT2063_REG_RSVD_1E] != val) {
+			status |=
+			    MT2063_SetReg(pInfo, MT2063_REG_RSVD_1E,
+					  val);
+		}
+		break;
+
+	case MT2063_AMPGC:
+		/* Set Amp gain code */
+		val =
+		    (pInfo->
+		     reg[MT2063_REG_TEMP_SEL] & (u8) ~ 0x03) |
+		    (nValue & 0x03);
+		if (pInfo->reg[MT2063_REG_TEMP_SEL] != val) {
+			status |=
+			    MT2063_SetReg(pInfo, MT2063_REG_TEMP_SEL,
+					  val);
+		}
+		break;
+
+		/*  Avoid DECT Frequencies                */
+	case MT2063_AVOID_DECT:
+		{
+			enum MT2063_DECT_Avoid_Type newAvoidSetting =
+			    (enum MT2063_DECT_Avoid_Type)nValue;
+			if ((newAvoidSetting >=
+			     MT2063_NO_DECT_AVOIDANCE)
+			    && (newAvoidSetting <= MT2063_AVOID_BOTH)) {
+				pInfo->AS_Data.avoidDECT =
+				    newAvoidSetting;
+			}
+		}
+		break;
+
+		/*  Cleartune filter selection: 0 - by IC (default), 1 - by software  */
+	case MT2063_CTFILT_SW:
+		pInfo->ctfilt_sw = (nValue & 0x01);
+		break;
+
+		/*  These parameters are read-only  */
+	case MT2063_IC_ADDR:
+	case MT2063_MAX_OPEN:
+	case MT2063_NUM_OPEN:
+	case MT2063_INPUT_FREQ:
+	case MT2063_IF1_ACTUAL:
+	case MT2063_IF1_CENTER:
+	case MT2063_IF1_BW:
+	case MT2063_AS_ALG:
+	case MT2063_EXCL_ZONES:
+	case MT2063_SPUR_AVOIDED:
+	case MT2063_NUM_SPURS:
+	case MT2063_SPUR_PRESENT:
+	case MT2063_ACLNA:
+	case MT2063_ACRF:
+	case MT2063_ACFIF:
+	case MT2063_EOP:
+	default:
+		status |= -ERANGE;
 	}
 	return (status);
 }
@@ -3912,27 +3840,25 @@ static u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue)
 ****************************************************************************/
 static u32 MT2063_ClearPowerMaskBits(struct MT2063_Info_t *pInfo, enum MT2063_Mask_Bits Bits)
 {
-	u32 status = MT2063_OK;	/* Status to be returned        */
+	u32 status = 0;	/* Status to be returned        */
 
 	/*  Verify that the handle passed points to a valid tuner         */
 	if (MT2063_IsValidHandle(pInfo) == 0)
-		status = MT2063_INV_HANDLE;
-	else {
-		Bits = (enum MT2063_Mask_Bits)(Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
-		if ((Bits & 0xFF00) != 0) {
-			pInfo->reg[MT2063_REG_PWR_2] &= ~(u8) (Bits >> 8);
-			status |=
-			    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
-					    MT2063_REG_PWR_2,
-					    &pInfo->reg[MT2063_REG_PWR_2], 1);
-		}
-		if ((Bits & 0xFF) != 0) {
-			pInfo->reg[MT2063_REG_PWR_1] &= ~(u8) (Bits & 0xFF);
-			status |=
-			    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
-					    MT2063_REG_PWR_1,
-					    &pInfo->reg[MT2063_REG_PWR_1], 1);
-		}
+		return -ENODEV;
+	Bits = (enum MT2063_Mask_Bits)(Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
+	if ((Bits & 0xFF00) != 0) {
+		pInfo->reg[MT2063_REG_PWR_2] &= ~(u8) (Bits >> 8);
+		status |=
+		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+				    MT2063_REG_PWR_2,
+				    &pInfo->reg[MT2063_REG_PWR_2], 1);
+	}
+	if ((Bits & 0xFF) != 0) {
+		pInfo->reg[MT2063_REG_PWR_1] &= ~(u8) (Bits & 0xFF);
+		status |=
+		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+				    MT2063_REG_PWR_1,
+				    &pInfo->reg[MT2063_REG_PWR_1], 1);
 	}
 
 	return (status);
@@ -3968,38 +3894,36 @@ static u32 MT2063_ClearPowerMaskBits(struct MT2063_Info_t *pInfo, enum MT2063_Ma
 ****************************************************************************/
 static u32 MT2063_SoftwareShutdown(struct MT2063_Info_t *pInfo, u8 Shutdown)
 {
-	u32 status = MT2063_OK;	/* Status to be returned        */
+	u32 status = 0;	/* Status to be returned        */
 
 	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0) {
-		status = MT2063_INV_HANDLE;
-	} else {
-		if (Shutdown == 1)
-			pInfo->reg[MT2063_REG_PWR_1] |= 0x04;	/* Turn the bit on */
-		else
-			pInfo->reg[MT2063_REG_PWR_1] &= ~0x04;	/* Turn off the bit */
+	if (MT2063_IsValidHandle(pInfo) == 0)
+		return -ENODEV;
+	if (Shutdown == 1)
+		pInfo->reg[MT2063_REG_PWR_1] |= 0x04;	/* Turn the bit on */
+	else
+		pInfo->reg[MT2063_REG_PWR_1] &= ~0x04;	/* Turn off the bit */
 
+	status |=
+	    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+			    MT2063_REG_PWR_1,
+			    &pInfo->reg[MT2063_REG_PWR_1], 1);
+
+	if (Shutdown != 1) {
+		pInfo->reg[MT2063_REG_BYP_CTRL] =
+		    (pInfo->reg[MT2063_REG_BYP_CTRL] & 0x9F) | 0x40;
 		status |=
 		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
-				    MT2063_REG_PWR_1,
-				    &pInfo->reg[MT2063_REG_PWR_1], 1);
-
-		if (Shutdown != 1) {
-			pInfo->reg[MT2063_REG_BYP_CTRL] =
-			    (pInfo->reg[MT2063_REG_BYP_CTRL] & 0x9F) | 0x40;
-			status |=
-			    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
-					    MT2063_REG_BYP_CTRL,
-					    &pInfo->reg[MT2063_REG_BYP_CTRL],
-					    1);
-			pInfo->reg[MT2063_REG_BYP_CTRL] =
-			    (pInfo->reg[MT2063_REG_BYP_CTRL] & 0x9F);
-			status |=
-			    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
-					    MT2063_REG_BYP_CTRL,
-					    &pInfo->reg[MT2063_REG_BYP_CTRL],
-					    1);
-		}
+				    MT2063_REG_BYP_CTRL,
+				    &pInfo->reg[MT2063_REG_BYP_CTRL],
+				    1);
+		pInfo->reg[MT2063_REG_BYP_CTRL] =
+		    (pInfo->reg[MT2063_REG_BYP_CTRL] & 0x9F);
+		status |=
+		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+				    MT2063_REG_BYP_CTRL,
+				    &pInfo->reg[MT2063_REG_BYP_CTRL],
+				    1);
 	}
 
 	return (status);
@@ -4033,25 +3957,21 @@ static u32 MT2063_SoftwareShutdown(struct MT2063_Info_t *pInfo, u8 Shutdown)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_SetReg(void *h, u8 reg, u8 val)
+static u32 MT2063_SetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 val)
 {
-	u32 status = MT2063_OK;	/* Status to be returned        */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
+	u32 status = 0;	/* Status to be returned        */
 
 	/*  Verify that the handle passed points to a valid tuner         */
 	if (MT2063_IsValidHandle(pInfo) == 0)
-		status |= MT2063_INV_HANDLE;
+		return -ENODEV;
 
 	if (reg >= MT2063_REG_END_REGS)
-		status |= MT2063_ARG_RANGE;
+		status |= -ERANGE;
 
-	if (MT2063_NO_ERROR(status)) {
-		status |=
-		    MT2063_WriteSub(pInfo->hUserData, pInfo->address, reg, &val,
-				    1);
-		if (MT2063_NO_ERROR(status))
-			pInfo->reg[reg] = val;
-	}
+	status = MT2063_WriteSub(pInfo->hUserData, pInfo->address, reg, &val,
+			         1);
+	if (status >= 0)
+		pInfo->reg[reg] = val;
 
 	return (status);
 }
@@ -4271,11 +4191,10 @@ static u32 FindClearTuneFilter(struct MT2063_Info_t *pInfo, u32 f_in)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-static u32 MT2063_Tune(void *h, u32 f_in)
+static u32 MT2063_Tune(struct MT2063_Info_t *pInfo, u32 f_in)
 {				/* RF input center frequency   */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
-	u32 status = MT2063_OK;	/*  status of operation             */
+	u32 status = 0;	/*  status of operation             */
 	u32 LO1;		/*  1st LO register value           */
 	u32 Num1;		/*  Numerator for LO1 reg. value    */
 	u32 f_IF1;		/*  1st IF requested                */
@@ -4292,15 +4211,15 @@ static u32 MT2063_Tune(void *h, u32 f_in)
 
 	/*  Verify that the handle passed points to a valid tuner         */
 	if (MT2063_IsValidHandle(pInfo) == 0)
-		return MT2063_INV_HANDLE;
+		return -ENODEV;
 
 	/*  Check the input and output frequency ranges                   */
 	if ((f_in < MT2063_MIN_FIN_FREQ) || (f_in > MT2063_MAX_FIN_FREQ))
-		status |= MT2063_FIN_RANGE;
+		return -EINVAL;
 
 	if ((pInfo->AS_Data.f_out < MT2063_MIN_FOUT_FREQ)
 	    || (pInfo->AS_Data.f_out > MT2063_MAX_FOUT_FREQ))
-		status |= MT2063_FOUT_RANGE;
+		return -EINVAL;
 
 	/*
 	 **  Save original LO1 and LO2 register values
@@ -4333,7 +4252,7 @@ static u32 MT2063_Tune(void *h, u32 f_in)
 	/*
 	 **  Read the FIFF Center Frequency from the tuner
 	 */
-	if (MT2063_NO_ERROR(status)) {
+	if (status >= 0) {
 		status |=
 		    MT2063_ReadSub(pInfo->hUserData, pInfo->address,
 				   MT2063_REG_FIFFC,
@@ -4370,7 +4289,7 @@ static u32 MT2063_Tune(void *h, u32 f_in)
 	 ** Check for any LO spurs in the output bandwidth and adjust
 	 ** the LO settings to avoid them if needed
 	 */
-	status |= MT2063_AvoidSpurs(h, &pInfo->AS_Data);
+	status |= MT2063_AvoidSpurs(pInfo, &pInfo->AS_Data);
 	/*
 	 ** MT_AvoidSpurs spurs may have changed the LO1 & LO2 values.
 	 ** Recalculate the LO frequencies and the values to be placed
@@ -4425,7 +4344,7 @@ static u32 MT2063_Tune(void *h, u32 f_in)
 		 **  Place all of the calculated values into the local tuner
 		 **  register fields.
 		 */
-		if (MT2063_NO_ERROR(status)) {
+		if (status >= 0) {
 			pInfo->reg[MT2063_REG_LO1CQ_1] = (u8) (LO1 & 0xFF);	/* DIV1q */
 			pInfo->reg[MT2063_REG_LO1CQ_2] = (u8) (Num1 & 0x3F);	/* NUM1q */
 			pInfo->reg[MT2063_REG_LO2CQ_1] = (u8) (((LO2 & 0x7F) << 1)	/* DIV2q */
@@ -4462,13 +4381,13 @@ static u32 MT2063_Tune(void *h, u32 f_in)
 		 **  Check for LO's locking
 		 */
 
-		if (MT2063_NO_ERROR(status)) {
-			status |= MT2063_GetLocked(h);
+		if (status >= 0) {
+			status |= MT2063_GetLocked(pInfo);
 		}
 		/*
 		 **  If we locked OK, assign calculated data to MT2063_Info_t structure
 		 */
-		if (MT2063_NO_ERROR(status)) {
+		if (status >= 0) {
 			pInfo->f_IF1_actual = pInfo->AS_Data.f_LO1 - f_in;
 		}
 	}
@@ -4480,7 +4399,7 @@ static u32 MT_Tune_atv(void *h, u32 f_in, u32 bw_in,
 		    enum MTTune_atv_standard tv_type)
 {
 
-	u32 status = MT2063_OK;
+	u32 status = 0;
 
 	s32 pict_car = 0;
 	s32 pict2chanb_vsb = 0;
@@ -4608,14 +4527,14 @@ static u32 MT_Tune_atv(void *h, u32 f_in, u32 bw_in,
 
 static int mt2063_init(struct dvb_frontend *fe)
 {
-	u32 status = MT2063_ERROR;
+	u32 status = -EINVAL;
 	struct mt2063_state *state = fe->tuner_priv;
 
 	status = MT2063_Open(0xC0, &(state->MT2063_ht), fe);
 	status |= MT2063_SoftwareShutdown(state->MT2063_ht, 1);
 	status |= MT2063_ClearPowerMaskBits(state->MT2063_ht, MT2063_ALL_SD);
 
-	if (MT2063_OK != status) {
+	if (0 != status) {
 		printk("%s %d error status = 0x%x!!\n", __func__, __LINE__,
 		       status);
 		return -1;
@@ -4665,7 +4584,7 @@ static int mt2063_set_state(struct dvb_frontend *fe,
 			    enum tuner_param param, struct tuner_state *state)
 {
 	struct mt2063_state *mt2063State = fe->tuner_priv;
-	u32 status = MT2063_OK;
+	u32 status = 0;
 
 	switch (param) {
 	case DVBFE_TUNER_FREQUENCY:
-- 
1.7.7.5

