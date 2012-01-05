Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab2AEBBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:10 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511AYi016658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 15/47] [media] mt2063: Merge the two state structures into one
Date: Wed,  4 Jan 2012 23:00:26 -0200
Message-Id: <1325725258-27934-16-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c | 1021 +++++++++++++++-------------------
 1 files changed, 454 insertions(+), 567 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 30c72c0..66633fa 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -372,20 +372,6 @@ enum MT2063_Register_Offsets {
 	MT2063_REG_END_REGS
 };
 
-struct MT2063_Info_t {
-	void *handle;
-	void *hUserData;
-	u32 address;
-	u32 tuner_id;
-	struct MT2063_AvoidSpursData_t AS_Data;
-	u32 f_IF1_actual;
-	u32 rcvr_mode;
-	u32 ctfilt_sw;
-	u32 CTFiltMax[31];
-	u32 num_regs;
-	u8 reg[MT2063_REG_END_REGS];
-};
-
 enum MTTune_atv_standard {
 	MTTUNEA_UNKNOWN = 0,
 	MTTUNEA_PAL_B,
@@ -408,7 +394,6 @@ struct mt2063_state {
 	struct dvb_tuner_ops ops;
 	struct dvb_frontend *frontend;
 	struct tuner_state status;
-	struct MT2063_Info_t *MT2063_ht;
 	bool MT2063_init;
 
 	enum MTTune_atv_standard tv_type;
@@ -416,37 +401,44 @@ struct mt2063_state {
 	u32 srate;
 	u32 bandwidth;
 	u32 reference;
+
+	u32 tuner_id;
+	struct MT2063_AvoidSpursData_t AS_Data;
+	u32 f_IF1_actual;
+	u32 rcvr_mode;
+	u32 ctfilt_sw;
+	u32 CTFiltMax[31];
+	u32 num_regs;
+	u8 reg[MT2063_REG_END_REGS];
 };
 
 /* Prototypes */
 static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
                         u32 f_min, u32 f_max);
-static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo);
-static u32 MT2063_Close(struct MT2063_Info_t *pInfo);
-static u32 MT2063_GetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 * val);
-static u32 MT2063_GetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param, u32 * pValue);
-static u32 MT2063_SetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 val);
-static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param,
+static u32 MT2063_ReInit(struct mt2063_state *pInfo);
+static u32 MT2063_Close(struct mt2063_state *pInfo);
+static u32 MT2063_GetReg(struct mt2063_state *pInfo, u8 reg, u8 * val);
+static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param, u32 * pValue);
+static u32 MT2063_SetReg(struct mt2063_state *pInfo, u8 reg, u8 val);
+static u32 MT2063_SetParam(struct mt2063_state *pInfo, enum MT2063_Param param,
 			   enum MT2063_DNC_Output_Enable nValue);
 
 /*****************/
 /* From drivers/media/common/tuners/mt2063_cfg.h */
 
 unsigned int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
-				   u32 bw_in,
-				   enum MTTune_atv_standard tv_type)
+			    u32 bw_in,
+			    enum MTTune_atv_standard tv_type)
 {
-	//return (int)MT_Tune_atv(h, f_in, bw_in, tv_type);
-
 	struct dvb_frontend_ops *frontend_ops = NULL;
 	struct dvb_tuner_ops *tuner_ops = NULL;
 	struct tuner_state t_state;
-	struct mt2063_state *mt2063State = fe->tuner_priv;
+	struct mt2063_state *state = fe->tuner_priv;
 	int err = 0;
 
 	t_state.frequency = f_in;
 	t_state.bandwidth = bw_in;
-	mt2063State->tv_type = tv_type;
+	state->tv_type = tv_type;
 	if (&fe->ops)
 		frontend_ops = &fe->ops;
 	if (&frontend_ops->tuner_ops)
@@ -558,7 +550,7 @@ unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 
 //i2c operation
 static int mt2063_writeregs(struct mt2063_state *state, u8 reg1,
-			    u8 * data, int len)
+			    u8 *data, int len)
 {
 	int ret;
 	u8 buf[60];		/* = { reg1, data }; */
@@ -648,19 +640,17 @@ static int mt2063_read_regs(struct mt2063_state *state, u8 reg1, u8 * b, u8 len)
 **   N/A   03-25-2004    DAD    Original
 **
 *****************************************************************************/
-static u32 MT2063_WriteSub(void *hUserData,
-			u32 addr,
-			u8 subAddress, u8 * pData, u32 cnt)
+static u32 MT2063_WriteSub(struct mt2063_state *state,
+			   u8 subAddress, u8 *pData, u32 cnt)
 {
 	u32 status = 0;	/* Status to be returned        */
-	struct dvb_frontend *fe = hUserData;
-	struct mt2063_state *state = fe->tuner_priv;
+	struct dvb_frontend *fe = state->frontend;
+
 	/*
 	 **  ToDo:  Add code here to implement a serial-bus write
 	 **         operation to the MTxxxx tuner.  If successful,
 	 **         return MT_OK.
 	 */
-/*  return status;  */
 
 	fe->ops.i2c_gate_ctrl(fe, 1);	//I2C bypass drxk3926 close i2c bridge
 
@@ -711,20 +701,18 @@ static u32 MT2063_WriteSub(void *hUserData,
 **   N/A   03-25-2004    DAD    Original
 **
 *****************************************************************************/
-static u32 MT2063_ReadSub(void *hUserData,
-		       u32 addr,
-		       u8 subAddress, u8 * pData, u32 cnt)
+static u32 MT2063_ReadSub(struct mt2063_state *state,
+			   u8 subAddress, u8 *pData, u32 cnt)
 {
+	u32 status = 0;	/* Status to be returned        */
+	struct dvb_frontend *fe = state->frontend;
+	u32 i = 0;
+
 	/*
 	 **  ToDo:  Add code here to implement a serial-bus read
 	 **         operation to the MTxxxx tuner.  If successful,
 	 **         return MT_OK.
 	 */
-/*  return status;  */
-	u32 status = 0;	/* Status to be returned        */
-	struct dvb_frontend *fe = hUserData;
-	struct mt2063_state *state = fe->tuner_priv;
-	u32 i = 0;
 	fe->ops.i2c_gate_ctrl(fe, 1);	//I2C bypass drxk3926 close i2c bridge
 
 	for (i = 0; i < cnt; i++) {
@@ -1911,63 +1899,32 @@ static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-static u32 MT2063_Open(u32 MT2063_Addr, struct MT2063_Info_t **hMT2063, void *hUserData)
+static u32 MT2063_Open(struct dvb_frontend *fe)
 {
-	u32 status = 0;	/*  Status to be returned.  */
-	struct MT2063_Info_t *pInfo = NULL;
-	struct dvb_frontend *fe = (struct dvb_frontend *)hUserData;
+	u32 status;	/*  Status to be returned.  */
 	struct mt2063_state *state = fe->tuner_priv;
 
-	/*  Check the argument before using  */
-	if (hMT2063 == NULL) {
-		return -ENODEV;
-	}
-
 	/*  Default tuner handle to NULL.  If successful, it will be reassigned  */
 
-	if (state->MT2063_init == false) {
-		pInfo = kzalloc(sizeof(struct MT2063_Info_t), GFP_KERNEL);
-		if (pInfo == NULL) {
-			return -ENOMEM;
-		}
-		pInfo->handle = NULL;
-		pInfo->address = MAX_UDATA;
-		pInfo->rcvr_mode = MT2063_CABLE_QAM;
-		pInfo->hUserData = NULL;
-	} else {
-		pInfo = *hMT2063;
-	}
+	if (state->MT2063_init == false)
+		state->rcvr_mode = MT2063_CABLE_QAM;
 
+	status = MT2063_RegisterTuner(&state->AS_Data);
 	if (status >= 0) {
-		status |= MT2063_RegisterTuner(&pInfo->AS_Data);
-	}
-
-	if (status >= 0) {
-		pInfo->handle = (void *) pInfo;
-
-		pInfo->hUserData = hUserData;
-		pInfo->address = MT2063_Addr;
-		pInfo->rcvr_mode = MT2063_CABLE_QAM;
-		status |= MT2063_ReInit((void *) pInfo);
+		state->rcvr_mode = MT2063_CABLE_QAM;
+		status = MT2063_ReInit(state);
 	}
 
 	if (status < 0)
 		/*  MT2063_Close handles the un-registration of the tuner  */
-		MT2063_Close((void *) pInfo);
+		MT2063_Close(state);
 	else {
 		state->MT2063_init = true;
-		*hMT2063 = pInfo->handle;
-
 	}
 
 	return (status);
 }
 
-static u32 MT2063_IsValidHandle(struct MT2063_Info_t *handle)
-{
-	return ((handle != NULL) && (handle->handle == handle)) ? 1 : 0;
-}
-
 /******************************************************************************
 **
 **  Name: MT2063_Close
@@ -1989,19 +1946,11 @@ static u32 MT2063_IsValidHandle(struct MT2063_Info_t *handle)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-static u32 MT2063_Close(struct MT2063_Info_t *pInfo)
+static u32 MT2063_Close(struct mt2063_state *state)
 {
-	if (!MT2063_IsValidHandle(pInfo))
-		return -ENODEV;
-
 	/* Unregister tuner with SpurAvoidance routines (if needed) */
-	MT2063_UnRegisterTuner(&pInfo->AS_Data);
+	MT2063_UnRegisterTuner(&state->AS_Data);
 	/* Now remove the tuner from our own list of tuners */
-	pInfo->handle = NULL;
-	pInfo->address = MAX_UDATA;
-	pInfo->hUserData = NULL;
-	//kfree(pInfo);
-	//pInfo = NULL;
 
 	return 0;
 }
@@ -2031,7 +1980,7 @@ static u32 MT2063_Close(struct MT2063_Info_t *pInfo)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_GetLocked(struct MT2063_Info_t *pInfo)
+static u32 MT2063_GetLocked(struct mt2063_state *pInfo)
 {
 	const u32 nMaxWait = 100;	/*  wait a maximum of 100 msec   */
 	const u32 nPollRate = 2;	/*  poll status bits every 2 ms */
@@ -2041,16 +1990,13 @@ static u32 MT2063_GetLocked(struct MT2063_Info_t *pInfo)
 	u32 status = 0;	/* Status to be returned        */
 	u32 nDelays = 0;
 
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return -ENODEV;
-
 	/*  LO2 Lock bit was in a different place for B0 version  */
 	if (pInfo->tuner_id == MT2063_B0)
 		LO2LK = 0x40;
 
 	do {
 		status |=
-		    MT2063_ReadSub(pInfo->hUserData, pInfo->address,
+		    MT2063_ReadSub(pInfo,
 				   MT2063_REG_LO_STATUS,
 				   &pInfo->reg[MT2063_REG_LO_STATUS], 1);
 
@@ -2165,7 +2111,7 @@ static u32 MT2063_GetLocked(struct MT2063_Info_t *pInfo)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-static u32 MT2063_GetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param, u32 *pValue)
+static u32 MT2063_GetParam(struct mt2063_state *pInfo, enum MT2063_Param param, u32 *pValue)
 {
 	u32 status = 0;	/* Status to be returned        */
 	u32 Div;
@@ -2174,366 +2120,355 @@ static u32 MT2063_GetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param,
 	if (pValue == NULL)
 		return -EINVAL;
 
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return -ENODEV;
+	switch (param) {
+		/*  Serial Bus address of this tuner      */
+	case MT2063_IC_ADDR:
+		*pValue = pInfo->config->tuner_address;
+		break;
+
+		/*  Max # of MT2063's allowed to be open  */
+	case MT2063_MAX_OPEN:
+		*pValue = nMT2063MaxTuners;
+		break;
+
+		/*  # of MT2063's open                    */
+	case MT2063_NUM_OPEN:
+		*pValue = nMT2063OpenTuners;
+		break;
+
+		/*  crystal frequency                     */
+	case MT2063_SRO_FREQ:
+		*pValue = pInfo->AS_Data.f_ref;
+		break;
+
+		/*  minimum tuning step size              */
+	case MT2063_STEPSIZE:
+		*pValue = pInfo->AS_Data.f_LO2_Step;
+		break;
+
+		/*  input center frequency                */
+	case MT2063_INPUT_FREQ:
+		*pValue = pInfo->AS_Data.f_in;
+		break;
+
+		/*  LO1 Frequency                         */
+	case MT2063_LO1_FREQ:
+		{
+			/* read the actual tuner register values for LO1C_1 and LO1C_2 */
+			status |=
+			    MT2063_ReadSub(pInfo,
+					   MT2063_REG_LO1C_1,
+					   &pInfo->
+					   reg[MT2063_REG_LO1C_1], 2);
+			Div = pInfo->reg[MT2063_REG_LO1C_1];
+			Num = pInfo->reg[MT2063_REG_LO1C_2] & 0x3F;
+			pInfo->AS_Data.f_LO1 =
+			    (pInfo->AS_Data.f_ref * Div) +
+			    MT2063_fLO_FractionalTerm(pInfo->AS_Data.
+						      f_ref, Num, 64);
+		}
+		*pValue = pInfo->AS_Data.f_LO1;
+		break;
+
+		/*  LO1 minimum step size                 */
+	case MT2063_LO1_STEPSIZE:
+		*pValue = pInfo->AS_Data.f_LO1_Step;
+		break;
+
+		/*  LO1 FracN keep-out region             */
+	case MT2063_LO1_FRACN_AVOID_PARAM:
+		*pValue = pInfo->AS_Data.f_LO1_FracN_Avoid;
+		break;
+
+		/*  Current 1st IF in use                 */
+	case MT2063_IF1_ACTUAL:
+		*pValue = pInfo->f_IF1_actual;
+		break;
+
+		/*  Requested 1st IF                      */
+	case MT2063_IF1_REQUEST:
+		*pValue = pInfo->AS_Data.f_if1_Request;
+		break;
+
+		/*  Center of 1st IF SAW filter           */
+	case MT2063_IF1_CENTER:
+		*pValue = pInfo->AS_Data.f_if1_Center;
+		break;
+
+		/*  Bandwidth of 1st IF SAW filter        */
+	case MT2063_IF1_BW:
+		*pValue = pInfo->AS_Data.f_if1_bw;
+		break;
+
+		/*  zero-IF bandwidth                     */
+	case MT2063_ZIF_BW:
+		*pValue = pInfo->AS_Data.f_zif_bw;
+		break;
+
+		/*  LO2 Frequency                         */
+	case MT2063_LO2_FREQ:
+		{
+			/* Read the actual tuner register values for LO2C_1, LO2C_2 and LO2C_3 */
+			status |=
+			    MT2063_ReadSub(pInfo,
+					   MT2063_REG_LO2C_1,
+					   &pInfo->
+					   reg[MT2063_REG_LO2C_1], 3);
+			Div =
+			    (pInfo->reg[MT2063_REG_LO2C_1] & 0xFE) >> 1;
+			Num =
+			    ((pInfo->
+			      reg[MT2063_REG_LO2C_1] & 0x01) << 12) |
+			    (pInfo->
+			     reg[MT2063_REG_LO2C_2] << 4) | (pInfo->
+							     reg
+							     [MT2063_REG_LO2C_3]
+							     & 0x00F);
+			pInfo->AS_Data.f_LO2 =
+			    (pInfo->AS_Data.f_ref * Div) +
+			    MT2063_fLO_FractionalTerm(pInfo->AS_Data.
+						      f_ref, Num, 8191);
+		}
+		*pValue = pInfo->AS_Data.f_LO2;
+		break;
+
+		/*  LO2 minimum step size                 */
+	case MT2063_LO2_STEPSIZE:
+		*pValue = pInfo->AS_Data.f_LO2_Step;
+		break;
+
+		/*  LO2 FracN keep-out region             */
+	case MT2063_LO2_FRACN_AVOID:
+		*pValue = pInfo->AS_Data.f_LO2_FracN_Avoid;
+		break;
+
+		/*  output center frequency               */
+	case MT2063_OUTPUT_FREQ:
+		*pValue = pInfo->AS_Data.f_out;
+		break;
+
+		/*  output bandwidth                      */
+	case MT2063_OUTPUT_BW:
+		*pValue = pInfo->AS_Data.f_out_bw - 750000;
+		break;
+
+		/*  min inter-tuner LO separation         */
+	case MT2063_LO_SEPARATION:
+		*pValue = pInfo->AS_Data.f_min_LO_Separation;
+		break;
+
+		/*  ID of avoid-spurs algorithm in use    */
+	case MT2063_AS_ALG:
+		*pValue = pInfo->AS_Data.nAS_Algorithm;
+		break;
+
+		/*  max # of intra-tuner harmonics        */
+	case MT2063_MAX_HARM1:
+		*pValue = pInfo->AS_Data.maxH1;
+		break;
+
+		/*  max # of inter-tuner harmonics        */
+	case MT2063_MAX_HARM2:
+		*pValue = pInfo->AS_Data.maxH2;
+		break;
+
+		/*  # of 1st IF exclusion zones           */
+	case MT2063_EXCL_ZONES:
+		*pValue = pInfo->AS_Data.nZones;
+		break;
+
+		/*  # of spurs found/avoided              */
+	case MT2063_NUM_SPURS:
+		*pValue = pInfo->AS_Data.nSpursFound;
+		break;
+
+		/*  >0 spurs avoided                      */
+	case MT2063_SPUR_AVOIDED:
+		*pValue = pInfo->AS_Data.bSpurAvoided;
+		break;
+
+		/*  >0 spurs in output (mathematically)   */
+	case MT2063_SPUR_PRESENT:
+		*pValue = pInfo->AS_Data.bSpurPresent;
+		break;
+
+		/*  Predefined receiver setup combination */
+	case MT2063_RCVR_MODE:
+		*pValue = pInfo->rcvr_mode;
+		break;
+
+	case MT2063_PD1:
+	case MT2063_PD2: {
+		u8 mask = (param == MT2063_PD1 ? 0x01 : 0x03);	/* PD1 vs PD2 */
+		u8 orig = (pInfo->reg[MT2063_REG_BYP_CTRL]);
+		u8 reg = (orig & 0xF1) | mask;	/* Only set 3 bits (not 5) */
+		int i;
+
+		*pValue = 0;
+
+		/* Initiate ADC output to reg 0x0A */
+		if (reg != orig)
+			status |=
+			    MT2063_WriteSub(pInfo,
+					    MT2063_REG_BYP_CTRL,
+					    &reg, 1);
+
+		if (status < 0)
+			return (status);
+
+		for (i = 0; i < 8; i++) {
+			status |=
+			    MT2063_ReadSub(pInfo,
+					   MT2063_REG_ADC_OUT,
+					   &pInfo->
+					   reg
+					   [MT2063_REG_ADC_OUT],
+					   1);
+
+			if (status >= 0)
+				*pValue +=
+				    pInfo->
+				    reg[MT2063_REG_ADC_OUT];
+			else {
+				if (i)
+					*pValue /= i;
+				return (status);
+			}
+		}
+		*pValue /= 8;	/*  divide by number of reads  */
+		*pValue >>= 2;	/*  only want 6 MSB's out of 8  */
+
+		/* Restore value of Register BYP_CTRL */
+		if (reg != orig)
+			status |=
+			    MT2063_WriteSub(pInfo,
+					    MT2063_REG_BYP_CTRL,
+						&orig, 1);
+		}
+		break;
+
+		/*  Get LNA attenuator code                */
+	case MT2063_ACLNA:
+	{
+		u8 val;
+		status |=
+		    MT2063_GetReg(pInfo, MT2063_REG_XO_STATUS,
+				  &val);
+		*pValue = val & 0x1f;
+	}
+	break;
+
+	/*  Get RF attenuator code                */
+	case MT2063_ACRF:
+	{
+		u8 val;
+		status |=
+		    MT2063_GetReg(pInfo, MT2063_REG_RF_STATUS,
+				  &val);
+		*pValue = val & 0x1f;
+	}
+	break;
 
-	    switch (param) {
-		    /*  Serial Bus address of this tuner      */
-	    case MT2063_IC_ADDR:
-		    *pValue = pInfo->address;
-		    break;
-
-		    /*  Max # of MT2063's allowed to be open  */
-	    case MT2063_MAX_OPEN:
-		    *pValue = nMT2063MaxTuners;
-		    break;
-
-		    /*  # of MT2063's open                    */
-	    case MT2063_NUM_OPEN:
-		    *pValue = nMT2063OpenTuners;
-		    break;
-
-		    /*  crystal frequency                     */
-	    case MT2063_SRO_FREQ:
-		    *pValue = pInfo->AS_Data.f_ref;
-		    break;
-
-		    /*  minimum tuning step size              */
-	    case MT2063_STEPSIZE:
-		    *pValue = pInfo->AS_Data.f_LO2_Step;
-		    break;
-
-		    /*  input center frequency                */
-	    case MT2063_INPUT_FREQ:
-		    *pValue = pInfo->AS_Data.f_in;
-		    break;
-
-		    /*  LO1 Frequency                         */
-	    case MT2063_LO1_FREQ:
-		    {
-			    /* read the actual tuner register values for LO1C_1 and LO1C_2 */
-			    status |=
-				MT2063_ReadSub(pInfo->hUserData,
-					       pInfo->address,
-					       MT2063_REG_LO1C_1,
-					       &pInfo->
-					       reg[MT2063_REG_LO1C_1], 2);
-			    Div = pInfo->reg[MT2063_REG_LO1C_1];
-			    Num = pInfo->reg[MT2063_REG_LO1C_2] & 0x3F;
-			    pInfo->AS_Data.f_LO1 =
-				(pInfo->AS_Data.f_ref * Div) +
-				MT2063_fLO_FractionalTerm(pInfo->AS_Data.
-							  f_ref, Num, 64);
-		    }
-		    *pValue = pInfo->AS_Data.f_LO1;
-		    break;
-
-		    /*  LO1 minimum step size                 */
-	    case MT2063_LO1_STEPSIZE:
-		    *pValue = pInfo->AS_Data.f_LO1_Step;
-		    break;
-
-		    /*  LO1 FracN keep-out region             */
-	    case MT2063_LO1_FRACN_AVOID_PARAM:
-		    *pValue = pInfo->AS_Data.f_LO1_FracN_Avoid;
-		    break;
-
-		    /*  Current 1st IF in use                 */
-	    case MT2063_IF1_ACTUAL:
-		    *pValue = pInfo->f_IF1_actual;
-		    break;
-
-		    /*  Requested 1st IF                      */
-	    case MT2063_IF1_REQUEST:
-		    *pValue = pInfo->AS_Data.f_if1_Request;
-		    break;
-
-		    /*  Center of 1st IF SAW filter           */
-	    case MT2063_IF1_CENTER:
-		    *pValue = pInfo->AS_Data.f_if1_Center;
-		    break;
-
-		    /*  Bandwidth of 1st IF SAW filter        */
-	    case MT2063_IF1_BW:
-		    *pValue = pInfo->AS_Data.f_if1_bw;
-		    break;
-
-		    /*  zero-IF bandwidth                     */
-	    case MT2063_ZIF_BW:
-		    *pValue = pInfo->AS_Data.f_zif_bw;
-		    break;
-
-		    /*  LO2 Frequency                         */
-	    case MT2063_LO2_FREQ:
-		    {
-			    /* Read the actual tuner register values for LO2C_1, LO2C_2 and LO2C_3 */
-			    status |=
-				MT2063_ReadSub(pInfo->hUserData,
-					       pInfo->address,
-					       MT2063_REG_LO2C_1,
-					       &pInfo->
-					       reg[MT2063_REG_LO2C_1], 3);
-			    Div =
-				(pInfo->reg[MT2063_REG_LO2C_1] & 0xFE) >> 1;
-			    Num =
-				((pInfo->
-				  reg[MT2063_REG_LO2C_1] & 0x01) << 12) |
-				(pInfo->
-				 reg[MT2063_REG_LO2C_2] << 4) | (pInfo->
-								 reg
-								 [MT2063_REG_LO2C_3]
-								 & 0x00F);
-			    pInfo->AS_Data.f_LO2 =
-				(pInfo->AS_Data.f_ref * Div) +
-				MT2063_fLO_FractionalTerm(pInfo->AS_Data.
-							  f_ref, Num, 8191);
-		    }
-		    *pValue = pInfo->AS_Data.f_LO2;
-		    break;
-
-		    /*  LO2 minimum step size                 */
-	    case MT2063_LO2_STEPSIZE:
-		    *pValue = pInfo->AS_Data.f_LO2_Step;
-		    break;
-
-		    /*  LO2 FracN keep-out region             */
-	    case MT2063_LO2_FRACN_AVOID:
-		    *pValue = pInfo->AS_Data.f_LO2_FracN_Avoid;
-		    break;
-
-		    /*  output center frequency               */
-	    case MT2063_OUTPUT_FREQ:
-		    *pValue = pInfo->AS_Data.f_out;
-		    break;
-
-		    /*  output bandwidth                      */
-	    case MT2063_OUTPUT_BW:
-		    *pValue = pInfo->AS_Data.f_out_bw - 750000;
-		    break;
-
-		    /*  min inter-tuner LO separation         */
-	    case MT2063_LO_SEPARATION:
-		    *pValue = pInfo->AS_Data.f_min_LO_Separation;
-		    break;
-
-		    /*  ID of avoid-spurs algorithm in use    */
-	    case MT2063_AS_ALG:
-		    *pValue = pInfo->AS_Data.nAS_Algorithm;
-		    break;
-
-		    /*  max # of intra-tuner harmonics        */
-	    case MT2063_MAX_HARM1:
-		    *pValue = pInfo->AS_Data.maxH1;
-		    break;
-
-		    /*  max # of inter-tuner harmonics        */
-	    case MT2063_MAX_HARM2:
-		    *pValue = pInfo->AS_Data.maxH2;
-		    break;
-
-		    /*  # of 1st IF exclusion zones           */
-	    case MT2063_EXCL_ZONES:
-		    *pValue = pInfo->AS_Data.nZones;
-		    break;
-
-		    /*  # of spurs found/avoided              */
-	    case MT2063_NUM_SPURS:
-		    *pValue = pInfo->AS_Data.nSpursFound;
-		    break;
-
-		    /*  >0 spurs avoided                      */
-	    case MT2063_SPUR_AVOIDED:
-		    *pValue = pInfo->AS_Data.bSpurAvoided;
-		    break;
-
-		    /*  >0 spurs in output (mathematically)   */
-	    case MT2063_SPUR_PRESENT:
-		    *pValue = pInfo->AS_Data.bSpurPresent;
-		    break;
-
-		    /*  Predefined receiver setup combination */
-	    case MT2063_RCVR_MODE:
-		    *pValue = pInfo->rcvr_mode;
-		    break;
-
-	    case MT2063_PD1:
-	    case MT2063_PD2:
-		    {
-			    u8 mask = (param == MT2063_PD1 ? 0x01 : 0x03);	/* PD1 vs PD2 */
-			    u8 orig = (pInfo->reg[MT2063_REG_BYP_CTRL]);
-			    u8 reg = (orig & 0xF1) | mask;	/* Only set 3 bits (not 5) */
-			    int i;
-
-			    *pValue = 0;
-
-			    /* Initiate ADC output to reg 0x0A */
-			    if (reg != orig)
-				    status |=
-					MT2063_WriteSub(pInfo->hUserData,
-							pInfo->address,
-							MT2063_REG_BYP_CTRL,
-							&reg, 1);
-
-			    if (status < 0)
-				    return (status);
-
-			    for (i = 0; i < 8; i++) {
-				    status |=
-					MT2063_ReadSub(pInfo->hUserData,
-						       pInfo->address,
-						       MT2063_REG_ADC_OUT,
-						       &pInfo->
-						       reg
-						       [MT2063_REG_ADC_OUT],
-						       1);
-
-				    if (status >= 0)
-					    *pValue +=
-						pInfo->
-						reg[MT2063_REG_ADC_OUT];
-				    else {
-					    if (i)
-						    *pValue /= i;
-					    return (status);
-				    }
-			    }
-			    *pValue /= 8;	/*  divide by number of reads  */
-			    *pValue >>= 2;	/*  only want 6 MSB's out of 8  */
-
-			    /* Restore value of Register BYP_CTRL */
-			    if (reg != orig)
-				    status |=
-					MT2063_WriteSub(pInfo->hUserData,
-							pInfo->address,
-							MT2063_REG_BYP_CTRL,
-							&orig, 1);
-		    }
-		    break;
-
-		    /*  Get LNA attenuator code                */
-	    case MT2063_ACLNA:
-		    {
-			    u8 val;
-			    status |=
-				MT2063_GetReg(pInfo, MT2063_REG_XO_STATUS,
-					      &val);
-			    *pValue = val & 0x1f;
-		    }
-		    break;
-
-		    /*  Get RF attenuator code                */
-	    case MT2063_ACRF:
-		    {
-			    u8 val;
-			    status |=
-				MT2063_GetReg(pInfo, MT2063_REG_RF_STATUS,
-					      &val);
-			    *pValue = val & 0x1f;
-		    }
-		    break;
-
-		    /*  Get FIF attenuator code               */
-	    case MT2063_ACFIF:
-		    {
-			    u8 val;
-			    status |=
-				MT2063_GetReg(pInfo, MT2063_REG_FIF_STATUS,
-					      &val);
-			    *pValue = val & 0x1f;
-		    }
-		    break;
-
-		    /*  Get LNA attenuator limit              */
-	    case MT2063_ACLNA_MAX:
-		    {
-			    u8 val;
-			    status |=
-				MT2063_GetReg(pInfo, MT2063_REG_LNA_OV,
-					      &val);
-			    *pValue = val & 0x1f;
-		    }
-		    break;
-
-		    /*  Get RF attenuator limit               */
-	    case MT2063_ACRF_MAX:
-		    {
-			    u8 val;
-			    status |=
-				MT2063_GetReg(pInfo, MT2063_REG_RF_OV,
-					      &val);
-			    *pValue = val & 0x1f;
-		    }
-		    break;
-
-		    /*  Get FIF attenuator limit               */
-	    case MT2063_ACFIF_MAX:
-		    {
-			    u8 val;
-			    status |=
-				MT2063_GetReg(pInfo, MT2063_REG_FIF_OV,
-					      &val);
-			    *pValue = val & 0x1f;
-		    }
-		    break;
-
-		    /*  Get current used DNC output */
-	    case MT2063_DNC_OUTPUT_ENABLE:
-		    {
-			    if ((pInfo->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
-				    if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
-					    *pValue =
-						(u32) MT2063_DNC_NONE;
-				    else
-					    *pValue =
-						(u32) MT2063_DNC_2;
-			    } else {	/* DNC1 is on */
-
-				    if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
-					    *pValue =
-						(u32) MT2063_DNC_1;
-				    else
-					    *pValue =
-						(u32) MT2063_DNC_BOTH;
-			    }
-		    }
-		    break;
-
-		    /*  Get VGA Gain Code */
-	    case MT2063_VGAGC:
-		    *pValue =
-			((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x0C) >> 2);
-		    break;
-
-		    /*  Get VGA bias current */
-	    case MT2063_VGAOI:
-		    *pValue = (pInfo->reg[MT2063_REG_RSVD_31] & 0x07);
-		    break;
-
-		    /*  Get TAGC setting */
-	    case MT2063_TAGC:
-		    *pValue = (pInfo->reg[MT2063_REG_RSVD_1E] & 0x03);
-		    break;
-
-		    /*  Get AMP Gain Code */
-	    case MT2063_AMPGC:
-		    *pValue = (pInfo->reg[MT2063_REG_TEMP_SEL] & 0x03);
-		    break;
-
-		    /*  Avoid DECT Frequencies  */
-	    case MT2063_AVOID_DECT:
-		    *pValue = pInfo->AS_Data.avoidDECT;
-		    break;
-
-		    /*  Cleartune filter selection: 0 - by IC (default), 1 - by software  */
-	    case MT2063_CTFILT_SW:
-		    *pValue = pInfo->ctfilt_sw;
-		    break;
-
-	    case MT2063_EOP:
-	    default:
-		    status |= -ERANGE;
-	    }
+	/*  Get FIF attenuator code               */
+	case MT2063_ACFIF:
+	{
+		u8 val;
+		status |=
+		    MT2063_GetReg(pInfo, MT2063_REG_FIF_STATUS,
+				  &val);
+		*pValue = val & 0x1f;
+	}
+	break;
+
+	/*  Get LNA attenuator limit              */
+	case MT2063_ACLNA_MAX:
+	{
+		u8 val;
+		status |=
+		    MT2063_GetReg(pInfo, MT2063_REG_LNA_OV,
+				  &val);
+		*pValue = val & 0x1f;
+	}
+	break;
+
+	/*  Get RF attenuator limit               */
+	case MT2063_ACRF_MAX:
+	{
+		u8 val;
+		status |=
+		    MT2063_GetReg(pInfo, MT2063_REG_RF_OV,
+				  &val);
+		*pValue = val & 0x1f;
+	}
+	break;
+
+	/*  Get FIF attenuator limit               */
+	case MT2063_ACFIF_MAX:
+	{
+		u8 val;
+		status |=
+		    MT2063_GetReg(pInfo, MT2063_REG_FIF_OV,
+				  &val);
+		*pValue = val & 0x1f;
+	}
+	break;
+
+	/*  Get current used DNC output */
+	case MT2063_DNC_OUTPUT_ENABLE:
+	{
+		if ((pInfo->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
+			if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
+				*pValue =
+				    (u32) MT2063_DNC_NONE;
+			else
+				*pValue =
+				    (u32) MT2063_DNC_2;
+		} else {	/* DNC1 is on */
+
+			if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
+				*pValue =
+				    (u32) MT2063_DNC_1;
+			else
+				*pValue =
+				    (u32) MT2063_DNC_BOTH;
+		}
+	}
+	break;
+
+	/*  Get VGA Gain Code */
+		case MT2063_VGAGC:
+		*pValue = ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x0C) >> 2);
+		break;
+
+		/*  Get VGA bias current */
+	case MT2063_VGAOI:
+		*pValue = (pInfo->reg[MT2063_REG_RSVD_31] & 0x07);
+		break;
+
+		/*  Get TAGC setting */
+	case MT2063_TAGC:
+		*pValue = (pInfo->reg[MT2063_REG_RSVD_1E] & 0x03);
+		break;
+
+		/*  Get AMP Gain Code */
+	case MT2063_AMPGC:
+		*pValue = (pInfo->reg[MT2063_REG_TEMP_SEL] & 0x03);
+		break;
+
+		/*  Avoid DECT Frequencies  */
+	case MT2063_AVOID_DECT:
+		*pValue = pInfo->AS_Data.avoidDECT;
+		break;
+
+		/*  Cleartune filter selection: 0 - by IC (default), 1 - by software  */
+	case MT2063_CTFILT_SW:
+		*pValue = pInfo->ctfilt_sw;
+		break;
+
+	case MT2063_EOP:
+	default:
+		status |= -ERANGE;
+	}
 	return (status);
 }
 
@@ -2566,22 +2501,17 @@ static u32 MT2063_GetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_GetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 * val)
+static u32 MT2063_GetReg(struct mt2063_state *pInfo, u8 reg, u8 * val)
 {
 	u32 status = 0;	/* Status to be returned        */
 
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return -ENODEV;
-
 	if (val == NULL)
 		return -EINVAL;
 
 	if (reg >= MT2063_REG_END_REGS)
 		return -ERANGE;
 
-	status = MT2063_ReadSub(pInfo->hUserData, pInfo->address, reg,
-			   &pInfo->reg[reg], 1);
+	status = MT2063_ReadSub(pInfo, reg, &pInfo->reg[reg], 1);
 
 	return (status);
 }
@@ -2623,7 +2553,7 @@ static u32 MT2063_GetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 * val)
 **    PD2 Target  |  40 |  33 |  42 |  42 | 33  | 42
 **
 **
-**  Parameters:     pInfo       - ptr to MT2063_Info_t structure
+**  Parameters:     pInfo       - ptr to mt2063_state structure
 **                  Mode        - desired reciever mode
 **
 **  Usage:          status = MT2063_SetReceiverMode(hMT2063, Mode);
@@ -2669,7 +2599,7 @@ static u32 MT2063_GetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 * val)
 **                                        removed GCUAUTO / BYPATNDN/UP
 **
 ******************************************************************************/
-static u32 MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
+static u32 MT2063_SetReceiverMode(struct mt2063_state *pInfo,
 				      enum MT2063_RCVR_MODES Mode)
 {
 	u32 status = 0;	/* Status to be returned        */
@@ -2818,7 +2748,7 @@ static u32 MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ******************************************************************************/
-static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
+static u32 MT2063_ReInit(struct mt2063_state *pInfo)
 {
 	u8 all_resets = 0xF0;	/* reset/load bits */
 	u32 status = 0;	/* Status to be returned */
@@ -2885,13 +2815,8 @@ static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
 		0x00
 	};
 
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return -ENODEV;
-
 	/*  Read the Part/Rev code from the tuner */
-	status = MT2063_ReadSub(pInfo->hUserData, pInfo->address,
-				MT2063_REG_PART_REV, pInfo->reg, 1);
+	status = MT2063_ReadSub(pInfo, MT2063_REG_PART_REV, pInfo->reg, 1);
 	if (status < 0)
 		return status;
 
@@ -2902,7 +2827,7 @@ static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 
 	/*  Check the 2nd byte of the Part/Rev code from the tuner */
-	status = MT2063_ReadSub(pInfo->hUserData, pInfo->address,
+	status = MT2063_ReadSub(pInfo,
 			        MT2063_REG_RSVD_3B,
 			        &pInfo->reg[MT2063_REG_RSVD_3B], 1);
 
@@ -2911,9 +2836,7 @@ static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 
 	/*  Reset the tuner  */
-	status = MT2063_WriteSub(pInfo->hUserData,
-				 pInfo->address,
-				 MT2063_REG_LO2CQ_3, &all_resets, 1);
+	status = MT2063_WriteSub(pInfo, MT2063_REG_LO2CQ_3, &all_resets, 1);
 	if (status < 0)
 		return status;
 
@@ -2940,8 +2863,7 @@ static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
 	while (status >= 0 && *def) {
 		u8 reg = *def++;
 		u8 val = *def++;
-		status = MT2063_WriteSub(pInfo->hUserData, pInfo->address, reg,
-					 &val, 1);
+		status = MT2063_WriteSub(pInfo, reg, &val, 1);
 	}
 	if (status < 0)
 		return status;
@@ -2951,8 +2873,7 @@ static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
 	maxReads = 10;
 	while (status >= 0 && (FCRUN != 0) && (maxReads-- > 0)) {
 		msleep(2);
-		status = MT2063_ReadSub(pInfo->hUserData,
-					 pInfo->address,
+		status = MT2063_ReadSub(pInfo,
 					 MT2063_REG_XO_STATUS,
 					 &pInfo->
 					 reg[MT2063_REG_XO_STATUS], 1);
@@ -2962,15 +2883,14 @@ static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
 	if (FCRUN != 0)
 		return -ENODEV;
 
-	status = MT2063_ReadSub(pInfo->hUserData, pInfo->address,
+	status = MT2063_ReadSub(pInfo,
 			   MT2063_REG_FIFFC,
 			   &pInfo->reg[MT2063_REG_FIFFC], 1);
 	if (status < 0)
 		return status;
 
 	/* Read back all the registers from the tuner */
-	status = MT2063_ReadSub(pInfo->hUserData,
-				pInfo->address,
+	status = MT2063_ReadSub(pInfo,
 				MT2063_REG_PART_REV,
 				pInfo->reg, MT2063_REG_END_REGS);
 	if (status < 0)
@@ -3039,13 +2959,13 @@ static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
 	 */
 
 	pInfo->reg[MT2063_REG_CTUNE_CTRL] = 0x0A;
-	status = MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+	status = MT2063_WriteSub(pInfo,
 				 MT2063_REG_CTUNE_CTRL,
 				 &pInfo->reg[MT2063_REG_CTUNE_CTRL], 1);
 	if (status < 0)
 		return status;
 	/*  Read the ClearTune filter calibration value  */
-	status = MT2063_ReadSub(pInfo->hUserData, pInfo->address,
+	status = MT2063_ReadSub(pInfo,
 			        MT2063_REG_FIFFC,
 			        &pInfo->reg[MT2063_REG_FIFFC], 1);
 	if (status < 0)
@@ -3054,7 +2974,7 @@ static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
 	fcu_osc = pInfo->reg[MT2063_REG_FIFFC];
 
 	pInfo->reg[MT2063_REG_CTUNE_CTRL] = 0x00;
-	status = MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+	status = MT2063_WriteSub(pInfo,
 				 MT2063_REG_CTUNE_CTRL,
 				 &pInfo->reg[MT2063_REG_CTUNE_CTRL], 1);
 	if (status < 0)
@@ -3150,17 +3070,13 @@ static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
+static u32 MT2063_SetParam(struct mt2063_state *pInfo,
 		           enum MT2063_Param param,
 			   enum MT2063_DNC_Output_Enable nValue)
 {
 	u32 status = 0;	/* Status to be returned        */
 	u8 val = 0;
 
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return -ENODEV;
-
 	switch (param) {
 		/*  crystal frequency                     */
 	case MT2063_SRO_FREQ:
@@ -3191,13 +3107,11 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 
 			/* Buffer the queue for restoration later and get actual LO2 values. */
 			status |=
-			    MT2063_ReadSub(pInfo->hUserData,
-					   pInfo->address,
+			    MT2063_ReadSub(pInfo,
 					   MT2063_REG_LO2CQ_1,
 					   &(tempLO2CQ[0]), 3);
 			status |=
-			    MT2063_ReadSub(pInfo->hUserData,
-					   pInfo->address,
+			    MT2063_ReadSub(pInfo,
 					   MT2063_REG_LO2C_1,
 					   &(tempLO2C[0]), 3);
 
@@ -3211,8 +3125,7 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 			    (tempLO2CQ[2] != tempLO2C[2])) {
 				/* put actual LO2 value into queue (with 0 in one-shot bits) */
 				status |=
-				    MT2063_WriteSub(pInfo->hUserData,
-						    pInfo->address,
+				    MT2063_WriteSub(pInfo,
 						    MT2063_REG_LO2CQ_1,
 						    &(tempLO2C[0]), 3);
 
@@ -3239,8 +3152,7 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 			pInfo->reg[MT2063_REG_LO1CQ_2] =
 			    (u8) (FracN);
 			status |=
-			    MT2063_WriteSub(pInfo->hUserData,
-					    pInfo->address,
+			    MT2063_WriteSub(pInfo,
 					    MT2063_REG_LO1CQ_1,
 					    &pInfo->
 					    reg[MT2063_REG_LO1CQ_1], 2);
@@ -3248,8 +3160,7 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 			/* set the one-shot bit to load the pair of LO values */
 			tmpOneShot = tempLO2CQ[2] | 0xE0;
 			status |=
-			    MT2063_WriteSub(pInfo->hUserData,
-					    pInfo->address,
+			    MT2063_WriteSub(pInfo,
 					    MT2063_REG_LO2CQ_3,
 					    &tmpOneShot, 1);
 
@@ -3257,8 +3168,7 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 			if (restore) {
 				/* put actual LO2 value into queue (0 in one-shot bits) */
 				status |=
-				    MT2063_WriteSub(pInfo->hUserData,
-						    pInfo->address,
+				    MT2063_WriteSub(pInfo,
 						    MT2063_REG_LO2CQ_1,
 						    &(tempLO2CQ[0]), 3);
 
@@ -3271,7 +3181,7 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 				    tempLO2CQ[2];
 			}
 
-			MT2063_GetParam(pInfo->hUserData,
+			MT2063_GetParam(pInfo,
 					MT2063_LO1_FREQ,
 					&pInfo->AS_Data.f_LO1);
 		}
@@ -3311,13 +3221,11 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 
 			/* Buffer the queue for restoration later and get actual LO2 values. */
 			status |=
-			    MT2063_ReadSub(pInfo->hUserData,
-					   pInfo->address,
+			    MT2063_ReadSub(pInfo,
 					   MT2063_REG_LO1CQ_1,
 					   &(tempLO1CQ[0]), 2);
 			status |=
-			    MT2063_ReadSub(pInfo->hUserData,
-					   pInfo->address,
+			    MT2063_ReadSub(pInfo,
 					   MT2063_REG_LO1C_1,
 					   &(tempLO1C[0]), 2);
 
@@ -3326,8 +3234,7 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 			    || (tempLO1CQ[1] != tempLO1C[1])) {
 				/* put actual LO1 value into queue */
 				status |=
-				    MT2063_WriteSub(pInfo->hUserData,
-						    pInfo->address,
+				    MT2063_WriteSub(pInfo,
 						    MT2063_REG_LO1CQ_1,
 						    &(tempLO1C[0]), 2);
 
@@ -3353,8 +3260,7 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 			pInfo->reg[MT2063_REG_LO2CQ_3] =
 			    (u8) ((FracN2 & 0x0F));
 			status |=
-			    MT2063_WriteSub(pInfo->hUserData,
-					    pInfo->address,
+			    MT2063_WriteSub(pInfo,
 					    MT2063_REG_LO1CQ_1,
 					    &pInfo->
 					    reg[MT2063_REG_LO1CQ_1], 3);
@@ -3363,8 +3269,7 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 			tmpOneShot =
 			    pInfo->reg[MT2063_REG_LO2CQ_3] | 0xE0;
 			status |=
-			    MT2063_WriteSub(pInfo->hUserData,
-					    pInfo->address,
+			    MT2063_WriteSub(pInfo,
 					    MT2063_REG_LO2CQ_3,
 					    &tmpOneShot, 1);
 
@@ -3372,8 +3277,7 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 			if (restore) {
 				/* put previous LO1 queue value back into queue */
 				status |=
-				    MT2063_WriteSub(pInfo->hUserData,
-						    pInfo->address,
+				    MT2063_WriteSub(pInfo,
 						    MT2063_REG_LO1CQ_1,
 						    &(tempLO1CQ[0]), 2);
 
@@ -3384,7 +3288,7 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 				    tempLO1CQ[1];
 			}
 
-			MT2063_GetParam(pInfo->hUserData,
+			MT2063_GetParam(pInfo,
 					MT2063_LO2_FREQ,
 					&pInfo->AS_Data.f_LO2);
 		}
@@ -3769,25 +3673,22 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_ClearPowerMaskBits(struct MT2063_Info_t *pInfo, enum MT2063_Mask_Bits Bits)
+static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *pInfo, enum MT2063_Mask_Bits Bits)
 {
 	u32 status = 0;	/* Status to be returned        */
 
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return -ENODEV;
 	Bits = (enum MT2063_Mask_Bits)(Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
 	if ((Bits & 0xFF00) != 0) {
 		pInfo->reg[MT2063_REG_PWR_2] &= ~(u8) (Bits >> 8);
 		status |=
-		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+		    MT2063_WriteSub(pInfo,
 				    MT2063_REG_PWR_2,
 				    &pInfo->reg[MT2063_REG_PWR_2], 1);
 	}
 	if ((Bits & 0xFF) != 0) {
 		pInfo->reg[MT2063_REG_PWR_1] &= ~(u8) (Bits & 0xFF);
 		status |=
-		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+		    MT2063_WriteSub(pInfo,
 				    MT2063_REG_PWR_1,
 				    &pInfo->reg[MT2063_REG_PWR_1], 1);
 	}
@@ -3823,20 +3724,17 @@ static u32 MT2063_ClearPowerMaskBits(struct MT2063_Info_t *pInfo, enum MT2063_Ma
 **                              correct wakeup of the LNA
 **
 ****************************************************************************/
-static u32 MT2063_SoftwareShutdown(struct MT2063_Info_t *pInfo, u8 Shutdown)
+static u32 MT2063_SoftwareShutdown(struct mt2063_state *pInfo, u8 Shutdown)
 {
 	u32 status = 0;	/* Status to be returned        */
 
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return -ENODEV;
 	if (Shutdown == 1)
 		pInfo->reg[MT2063_REG_PWR_1] |= 0x04;	/* Turn the bit on */
 	else
 		pInfo->reg[MT2063_REG_PWR_1] &= ~0x04;	/* Turn off the bit */
 
 	status |=
-	    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+	    MT2063_WriteSub(pInfo,
 			    MT2063_REG_PWR_1,
 			    &pInfo->reg[MT2063_REG_PWR_1], 1);
 
@@ -3844,14 +3742,14 @@ static u32 MT2063_SoftwareShutdown(struct MT2063_Info_t *pInfo, u8 Shutdown)
 		pInfo->reg[MT2063_REG_BYP_CTRL] =
 		    (pInfo->reg[MT2063_REG_BYP_CTRL] & 0x9F) | 0x40;
 		status |=
-		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+		    MT2063_WriteSub(pInfo,
 				    MT2063_REG_BYP_CTRL,
 				    &pInfo->reg[MT2063_REG_BYP_CTRL],
 				    1);
 		pInfo->reg[MT2063_REG_BYP_CTRL] =
 		    (pInfo->reg[MT2063_REG_BYP_CTRL] & 0x9F);
 		status |=
-		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
+		    MT2063_WriteSub(pInfo,
 				    MT2063_REG_BYP_CTRL,
 				    &pInfo->reg[MT2063_REG_BYP_CTRL],
 				    1);
@@ -3888,18 +3786,14 @@ static u32 MT2063_SoftwareShutdown(struct MT2063_Info_t *pInfo, u8 Shutdown)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_SetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 val)
+static u32 MT2063_SetReg(struct mt2063_state *pInfo, u8 reg, u8 val)
 {
 	u32 status = 0;	/* Status to be returned        */
 
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return -ENODEV;
-
 	if (reg >= MT2063_REG_END_REGS)
 		status |= -ERANGE;
 
-	status = MT2063_WriteSub(pInfo->hUserData, pInfo->address, reg, &val,
+	status = MT2063_WriteSub(pInfo, reg, &val,
 			         1);
 	if (status >= 0)
 		pInfo->reg[reg] = val;
@@ -4063,7 +3957,7 @@ static u32 MT2063_CalcLO2Mult(u32 * Div,
 **                                        cross-over frequency values.
 **
 ****************************************************************************/
-static u32 FindClearTuneFilter(struct MT2063_Info_t *pInfo, u32 f_in)
+static u32 FindClearTuneFilter(struct mt2063_state *pInfo, u32 f_in)
 {
 	u32 RFBand;
 	u32 idx;		/*  index loop                      */
@@ -4122,7 +4016,7 @@ static u32 FindClearTuneFilter(struct MT2063_Info_t *pInfo, u32 f_in)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-static u32 MT2063_Tune(struct MT2063_Info_t *pInfo, u32 f_in)
+static u32 MT2063_Tune(struct mt2063_state *pInfo, u32 f_in)
 {				/* RF input center frequency   */
 
 	u32 status = 0;	/*  status of operation             */
@@ -4140,10 +4034,6 @@ static u32 MT2063_Tune(struct MT2063_Info_t *pInfo, u32 f_in)
 	u8 val;
 	u32 RFBand;
 
-	/*  Verify that the handle passed points to a valid tuner         */
-	if (MT2063_IsValidHandle(pInfo) == 0)
-		return -ENODEV;
-
 	/*  Check the input and output frequency ranges                   */
 	if ((f_in < MT2063_MIN_FIN_FREQ) || (f_in > MT2063_MAX_FIN_FREQ))
 		return -EINVAL;
@@ -4185,7 +4075,7 @@ static u32 MT2063_Tune(struct MT2063_Info_t *pInfo, u32 f_in)
 	 */
 	if (status >= 0) {
 		status |=
-		    MT2063_ReadSub(pInfo->hUserData, pInfo->address,
+		    MT2063_ReadSub(pInfo,
 				   MT2063_REG_FIFFC,
 				   &pInfo->reg[MT2063_REG_FIFFC], 1);
 		fiffc = pInfo->reg[MT2063_REG_FIFFC];
@@ -4288,10 +4178,10 @@ static u32 MT2063_Tune(struct MT2063_Info_t *pInfo, u32 f_in)
 			 ** IMPORTANT: There is a required order for writing
 			 **            (0x05 must follow all the others).
 			 */
-			status |= MT2063_WriteSub(pInfo->hUserData, pInfo->address, MT2063_REG_LO1CQ_1, &pInfo->reg[MT2063_REG_LO1CQ_1], 5);	/* 0x01 - 0x05 */
+			status |= MT2063_WriteSub(pInfo, MT2063_REG_LO1CQ_1, &pInfo->reg[MT2063_REG_LO1CQ_1], 5);	/* 0x01 - 0x05 */
 			if (pInfo->tuner_id == MT2063_B0) {
 				/* Re-write the one-shot bits to trigger the tune operation */
-				status |= MT2063_WriteSub(pInfo->hUserData, pInfo->address, MT2063_REG_LO2CQ_3, &pInfo->reg[MT2063_REG_LO2CQ_3], 1);	/* 0x05 */
+				status |= MT2063_WriteSub(pInfo, MT2063_REG_LO2CQ_3, &pInfo->reg[MT2063_REG_LO2CQ_3], 1);	/* 0x05 */
 			}
 			/* Write out the FIFF offset only if it's changing */
 			if (pInfo->reg[MT2063_REG_FIFF_OFFSET] !=
@@ -4299,8 +4189,7 @@ static u32 MT2063_Tune(struct MT2063_Info_t *pInfo, u32 f_in)
 				pInfo->reg[MT2063_REG_FIFF_OFFSET] =
 				    (u8) fiffof;
 				status |=
-				    MT2063_WriteSub(pInfo->hUserData,
-						    pInfo->address,
+				    MT2063_WriteSub(pInfo,
 						    MT2063_REG_FIFF_OFFSET,
 						    &pInfo->
 						    reg[MT2063_REG_FIFF_OFFSET],
@@ -4316,7 +4205,7 @@ static u32 MT2063_Tune(struct MT2063_Info_t *pInfo, u32 f_in)
 			status |= MT2063_GetLocked(pInfo);
 		}
 		/*
-		 **  If we locked OK, assign calculated data to MT2063_Info_t structure
+		 **  If we locked OK, assign calculated data to mt2063_state structure
 		 */
 		if (status >= 0) {
 			pInfo->f_IF1_actual = pInfo->AS_Data.f_LO1 - f_in;
@@ -4461,9 +4350,9 @@ static int mt2063_init(struct dvb_frontend *fe)
 	u32 status = -EINVAL;
 	struct mt2063_state *state = fe->tuner_priv;
 
-	status = MT2063_Open(0xC0, &(state->MT2063_ht), fe);
-	status |= MT2063_SoftwareShutdown(state->MT2063_ht, 1);
-	status |= MT2063_ClearPowerMaskBits(state->MT2063_ht, MT2063_ALL_SD);
+	status = MT2063_Open(fe);
+	status |= MT2063_SoftwareShutdown(state, 1);
+	status |= MT2063_ClearPowerMaskBits(state, MT2063_ALL_SD);
 
 	if (0 != status) {
 		printk("%s %d error status = 0x%x!!\n", __func__, __LINE__,
@@ -4484,9 +4373,9 @@ static int mt2063_get_status(struct dvb_frontend *fe, u32 * status)
 }
 
 static int mt2063_get_state(struct dvb_frontend *fe,
-			    enum tuner_param param, struct tuner_state *state)
+			    enum tuner_param param, struct tuner_state *tunstate)
 {
-	struct mt2063_state *mt2063State = fe->tuner_priv;
+	struct mt2063_state *state = fe->tuner_priv;
 
 	switch (param) {
 	case DVBFE_TUNER_FREQUENCY:
@@ -4500,21 +4389,19 @@ static int mt2063_get_state(struct dvb_frontend *fe,
 		//get bandwidth
 		break;
 	case DVBFE_TUNER_REFCLOCK:
-		state->refclock =
-		    (u32)
-		    MT2063_GetLocked((void *) (mt2063State->MT2063_ht));
+		tunstate->refclock = (u32) MT2063_GetLocked(state);
 		break;
 	default:
 		break;
 	}
 
-	return (int)state->refclock;
+	return (int)tunstate->refclock;
 }
 
 static int mt2063_set_state(struct dvb_frontend *fe,
-			    enum tuner_param param, struct tuner_state *state)
+			    enum tuner_param param, struct tuner_state *tunstate)
 {
-	struct mt2063_state *mt2063State = fe->tuner_priv;
+	struct mt2063_state *state = fe->tuner_priv;
 	u32 status = 0;
 
 	switch (param) {
@@ -4522,11 +4409,11 @@ static int mt2063_set_state(struct dvb_frontend *fe,
 		//set frequency
 
 		status =
-		    MT_Tune_atv((void *) (mt2063State->MT2063_ht),
-				state->frequency, state->bandwidth,
-				mt2063State->tv_type);
+		    MT_Tune_atv(state,
+				tunstate->frequency, tunstate->bandwidth,
+				state->tv_type);
 
-		mt2063State->frequency = state->frequency;
+		state->frequency = tunstate->frequency;
 		break;
 	case DVBFE_TUNER_TUNERSTEP:
 		break;
@@ -4534,20 +4421,20 @@ static int mt2063_set_state(struct dvb_frontend *fe,
 		break;
 	case DVBFE_TUNER_BANDWIDTH:
 		//set bandwidth
-		mt2063State->bandwidth = state->bandwidth;
+		state->bandwidth = tunstate->bandwidth;
 		break;
 	case DVBFE_TUNER_REFCLOCK:
 
 		break;
 	case DVBFE_TUNER_OPEN:
-		status = MT2063_Open(MT2063_I2C, &(mt2063State->MT2063_ht), fe);
+		status = MT2063_Open(fe);
 		break;
 	case DVBFE_TUNER_SOFTWARE_SHUTDOWN:
-		status = MT2063_SoftwareShutdown(mt2063State->MT2063_ht, 1);
+		status = MT2063_SoftwareShutdown(state, 1);
 		break;
 	case DVBFE_TUNER_CLEAR_POWER_MASKBITS:
 		status =
-		    MT2063_ClearPowerMaskBits(mt2063State->MT2063_ht,
+		    MT2063_ClearPowerMaskBits(state,
 					      MT2063_ALL_SD);
 		break;
 	default:
-- 
1.7.7.5

