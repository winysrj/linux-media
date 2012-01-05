Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302Ab2AEBBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:10 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05119NY002491
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 20/47] [media] mt2063: Simplify device init logic
Date: Wed,  4 Jan 2012 23:00:31 -0200
Message-Id: <1325725258-27934-21-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  575 ++++++++++++++--------------------
 1 files changed, 242 insertions(+), 333 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 1011635..c5e95dd 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -11,7 +11,6 @@ module_param(verbose, int, 0644);
 /* Internal structures and types */
 
 /* FIXME: we probably don't need these new FE get/set property types for tuner */
-#define DVBFE_TUNER_OPEN			99
 #define DVBFE_TUNER_SOFTWARE_SHUTDOWN		100
 #define DVBFE_TUNER_CLEAR_POWER_MASKBITS	101
 
@@ -387,7 +386,6 @@ struct mt2063_state {
 	struct dvb_tuner_ops ops;
 	struct dvb_frontend *frontend;
 	struct tuner_state status;
-	bool MT2063_init;
 
 	enum MTTune_atv_standard tv_type;
 	u32 frequency;
@@ -408,7 +406,6 @@ struct mt2063_state {
 /* Prototypes */
 static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
                         u32 f_min, u32 f_max);
-static u32 MT2063_ReInit(struct mt2063_state *state);
 static u32 MT2063_GetReg(struct mt2063_state *state, u8 reg, u8 * val);
 static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param, u32 * pValue);
 static u32 MT2063_SetReg(struct mt2063_state *state, u8 reg, u8 val);
@@ -1347,51 +1344,6 @@ static u32 MT2063_CalcLO2Mult(u32 * Div, u32 * FracN, u32 f_LO,
 static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num,
 					 u32 denom);
 
-/******************************************************************************
-**
-**  Name: MT2063_Open
-**
-**  Description:    Initialize the tuner's register values.
-**
-**  Parameters:     MT2063_Addr  - Serial bus address of the tuner.
-**                  hMT2063      - Tuner handle passed back.
-**                  hUserData    - User-defined data, if needed for the
-**                                 MT_ReadSub() & MT_WriteSub functions.
-**
-**  Returns:        status:
-**                      MT_OK             - No errors
-**                      MT_TUNER_ID_ERR   - Tuner Part/Rev code mismatch
-**                      MT_TUNER_INIT_ERR - Tuner initialization failed
-**                      MT_COMM_ERR       - Serial bus communications error
-**                      MT_ARG_NULL       - Null pointer argument passed
-**                      MT_TUNER_CNT_ERR  - Too many tuners open
-**
-**  Dependencies:   MT_ReadSub  - Read byte(s) of data from the two-wire bus
-**                  MT_WriteSub - Write byte(s) of data to the two-wire bus
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-******************************************************************************/
-static u32 MT2063_Open(struct dvb_frontend *fe)
-{
-	u32 status;	/*  Status to be returned.  */
-	struct mt2063_state *state = fe->tuner_priv;
-
-	state->rcvr_mode = MT2063_CABLE_QAM;
-	if (state->MT2063_init != false) {
-		status = MT2063_ReInit(state);
-		if (status < 0)
-			return status;
-	}
-
-	state->MT2063_init = true;
-	return 0;
-}
-
 /****************************************************************************
 **
 **  Name: MT2063_GetLocked
@@ -2146,279 +2098,6 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 	return (status);
 }
 
-/******************************************************************************
-**
-**  Name: MT2063_ReInit
-**
-**  Description:    Initialize the tuner's register values.
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_TUNER_ID_ERR   - Tuner Part/Rev code mismatch
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_COMM_ERR      - Serial bus communications error
-**
-**  Dependencies:   MT_ReadSub  - Read byte(s) of data from the two-wire bus
-**                  MT_WriteSub - Write byte(s) of data to the two-wire bus
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**   148   09-04-2007    RSK    Ver 1.02: Corrected logic of Reg 3B Reference
-**   153   09-07-2007    RSK    Ver 1.03: Lock Time improvements
-**   N/A   10-31-2007    PINZ   Ver 1.08: Changed values suitable to rcvr-mode 0
-**   N/A   11-12-2007    PINZ   Ver 1.09: Changed values suitable to rcvr-mode 0
-**   N/A   01-03-2007    PINZ   Ver 1.10: Added AFCsd = 1 into defaults
-**   N/A   01-04-2007    PINZ   Ver 1.10: Changed CAP1sel default
-**         01-14-2008    PINZ   Ver 1.11: Updated gain settings
-**         03-18-2008    PINZ   Ver 1.13: Added Support for B3
-**   175 I 06-19-2008    RSK    Ver 1.17: Refactor DECT control to SpurAvoid.
-**         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
-**
-******************************************************************************/
-static u32 MT2063_ReInit(struct mt2063_state *state)
-{
-	u8 all_resets = 0xF0;	/* reset/load bits */
-	u32 status = 0;	/* Status to be returned */
-	u8 *def = NULL;
-	u32 FCRUN;
-	s32 maxReads;
-	u32 fcu_osc;
-	u32 i;
-	u8 MT2063B0_defaults[] = {	/* Reg,  Value */
-		0x19, 0x05,
-		0x1B, 0x1D,
-		0x1C, 0x1F,
-		0x1D, 0x0F,
-		0x1E, 0x3F,
-		0x1F, 0x0F,
-		0x20, 0x3F,
-		0x22, 0x21,
-		0x23, 0x3F,
-		0x24, 0x20,
-		0x25, 0x3F,
-		0x27, 0xEE,
-		0x2C, 0x27,	/*  bit at 0x20 is cleared below  */
-		0x30, 0x03,
-		0x2C, 0x07,	/*  bit at 0x20 is cleared here   */
-		0x2D, 0x87,
-		0x2E, 0xAA,
-		0x28, 0xE1,	/*  Set the FIFCrst bit here      */
-		0x28, 0xE0,	/*  Clear the FIFCrst bit here    */
-		0x00
-	};
-	/* writing 0x05 0xf0 sw-resets all registers, so we write only needed changes */
-	u8 MT2063B1_defaults[] = {	/* Reg,  Value */
-		0x05, 0xF0,
-		0x11, 0x10,	/* New Enable AFCsd */
-		0x19, 0x05,
-		0x1A, 0x6C,
-		0x1B, 0x24,
-		0x1C, 0x28,
-		0x1D, 0x8F,
-		0x1E, 0x14,
-		0x1F, 0x8F,
-		0x20, 0x57,
-		0x22, 0x21,	/* New - ver 1.03 */
-		0x23, 0x3C,	/* New - ver 1.10 */
-		0x24, 0x20,	/* New - ver 1.03 */
-		0x2C, 0x24,	/*  bit at 0x20 is cleared below  */
-		0x2D, 0x87,	/*  FIFFQ=0  */
-		0x2F, 0xF3,
-		0x30, 0x0C,	/* New - ver 1.11 */
-		0x31, 0x1B,	/* New - ver 1.11 */
-		0x2C, 0x04,	/*  bit at 0x20 is cleared here  */
-		0x28, 0xE1,	/*  Set the FIFCrst bit here      */
-		0x28, 0xE0,	/*  Clear the FIFCrst bit here    */
-		0x00
-	};
-	/* writing 0x05 0xf0 sw-resets all registers, so we write only needed changes */
-	u8 MT2063B3_defaults[] = {	/* Reg,  Value */
-		0x05, 0xF0,
-		0x19, 0x3D,
-		0x2C, 0x24,	/*  bit at 0x20 is cleared below  */
-		0x2C, 0x04,	/*  bit at 0x20 is cleared here  */
-		0x28, 0xE1,	/*  Set the FIFCrst bit here      */
-		0x28, 0xE0,	/*  Clear the FIFCrst bit here    */
-		0x00
-	};
-
-	/*  Read the Part/Rev code from the tuner */
-	status = mt2063_read(state, MT2063_REG_PART_REV, state->reg, 1);
-	if (status < 0)
-		return status;
-
-	/* Check the part/rev code */
-	if (((state->reg[MT2063_REG_PART_REV] != MT2063_B0)	/*  MT2063 B0  */
-	    &&(state->reg[MT2063_REG_PART_REV] != MT2063_B1)	/*  MT2063 B1  */
-	    &&(state->reg[MT2063_REG_PART_REV] != MT2063_B3)))	/*  MT2063 B3  */
-		return -ENODEV;	/*  Wrong tuner Part/Rev code */
-
-	/*  Check the 2nd byte of the Part/Rev code from the tuner */
-	status = mt2063_read(state,
-			        MT2063_REG_RSVD_3B,
-			        &state->reg[MT2063_REG_RSVD_3B], 1);
-
-	if (status >= 0
-	    &&((state->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00))	/* b7 != 0 ==> NOT MT2063 */
-		return -ENODEV;	/*  Wrong tuner Part/Rev code */
-
-	/*  Reset the tuner  */
-	status = mt2063_write(state, MT2063_REG_LO2CQ_3, &all_resets, 1);
-	if (status < 0)
-		return status;
-
-	/* change all of the default values that vary from the HW reset values */
-	/*  def = (state->reg[PART_REV] == MT2063_B0) ? MT2063B0_defaults : MT2063B1_defaults; */
-	switch (state->reg[MT2063_REG_PART_REV]) {
-	case MT2063_B3:
-		def = MT2063B3_defaults;
-		break;
-
-	case MT2063_B1:
-		def = MT2063B1_defaults;
-		break;
-
-	case MT2063_B0:
-		def = MT2063B0_defaults;
-		break;
-
-	default:
-		return -ENODEV;
-		break;
-	}
-
-	while (status >= 0 && *def) {
-		u8 reg = *def++;
-		u8 val = *def++;
-		status = mt2063_write(state, reg, &val, 1);
-	}
-	if (status < 0)
-		return status;
-
-	/*  Wait for FIFF location to complete.  */
-	FCRUN = 1;
-	maxReads = 10;
-	while (status >= 0 && (FCRUN != 0) && (maxReads-- > 0)) {
-		msleep(2);
-		status = mt2063_read(state,
-					 MT2063_REG_XO_STATUS,
-					 &state->
-					 reg[MT2063_REG_XO_STATUS], 1);
-		FCRUN = (state->reg[MT2063_REG_XO_STATUS] & 0x40) >> 6;
-	}
-
-	if (FCRUN != 0)
-		return -ENODEV;
-
-	status = mt2063_read(state,
-			   MT2063_REG_FIFFC,
-			   &state->reg[MT2063_REG_FIFFC], 1);
-	if (status < 0)
-		return status;
-
-	/* Read back all the registers from the tuner */
-	status = mt2063_read(state,
-				MT2063_REG_PART_REV,
-				state->reg, MT2063_REG_END_REGS);
-	if (status < 0)
-		return status;
-
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
-
-	state->CTFiltMax[0] = 69230000;
-	state->CTFiltMax[1] = 105770000;
-	state->CTFiltMax[2] = 140350000;
-	state->CTFiltMax[3] = 177110000;
-	state->CTFiltMax[4] = 212860000;
-	state->CTFiltMax[5] = 241130000;
-	state->CTFiltMax[6] = 274370000;
-	state->CTFiltMax[7] = 309820000;
-	state->CTFiltMax[8] = 342450000;
-	state->CTFiltMax[9] = 378870000;
-	state->CTFiltMax[10] = 416210000;
-	state->CTFiltMax[11] = 456500000;
-	state->CTFiltMax[12] = 495790000;
-	state->CTFiltMax[13] = 534530000;
-	state->CTFiltMax[14] = 572610000;
-	state->CTFiltMax[15] = 598970000;
-	state->CTFiltMax[16] = 635910000;
-	state->CTFiltMax[17] = 672130000;
-	state->CTFiltMax[18] = 714840000;
-	state->CTFiltMax[19] = 739660000;
-	state->CTFiltMax[20] = 770410000;
-	state->CTFiltMax[21] = 814660000;
-	state->CTFiltMax[22] = 846950000;
-	state->CTFiltMax[23] = 867820000;
-	state->CTFiltMax[24] = 915980000;
-	state->CTFiltMax[25] = 947450000;
-	state->CTFiltMax[26] = 983110000;
-	state->CTFiltMax[27] = 1021630000;
-	state->CTFiltMax[28] = 1061870000;
-	state->CTFiltMax[29] = 1098330000;
-	state->CTFiltMax[30] = 1138990000;
-
-	/*
-	 **   Fetch the FCU osc value and use it and the fRef value to
-	 **   scale all of the Band Max values
-	 */
-
-	state->reg[MT2063_REG_CTUNE_CTRL] = 0x0A;
-	status = mt2063_write(state,
-				 MT2063_REG_CTUNE_CTRL,
-				 &state->reg[MT2063_REG_CTUNE_CTRL], 1);
-	if (status < 0)
-		return status;
-	/*  Read the ClearTune filter calibration value  */
-	status = mt2063_read(state,
-			        MT2063_REG_FIFFC,
-			        &state->reg[MT2063_REG_FIFFC], 1);
-	if (status < 0)
-		return status;
-
-	fcu_osc = state->reg[MT2063_REG_FIFFC];
-
-	state->reg[MT2063_REG_CTUNE_CTRL] = 0x00;
-	status = mt2063_write(state,
-				 MT2063_REG_CTUNE_CTRL,
-				 &state->reg[MT2063_REG_CTUNE_CTRL], 1);
-	if (status < 0)
-		return status;
-
-	/*  Adjust each of the values in the ClearTune filter cross-over table  */
-	for (i = 0; i < 31; i++)
-		state->CTFiltMax[i] =(state->CTFiltMax[i] / 768) * (fcu_osc + 640);
-
-	return (status);
-}
-
 /****************************************************************************
 **
 **  Name: MT2063_SetParam
@@ -3777,21 +3456,255 @@ static u32 MT_Tune_atv(void *h, u32 f_in, u32 bw_in,
 	return (u32) status;
 }
 
+static const u8 MT2063B0_defaults[] = {
+	/* Reg,  Value */
+	0x19, 0x05,
+	0x1B, 0x1D,
+	0x1C, 0x1F,
+	0x1D, 0x0F,
+	0x1E, 0x3F,
+	0x1F, 0x0F,
+	0x20, 0x3F,
+	0x22, 0x21,
+	0x23, 0x3F,
+	0x24, 0x20,
+	0x25, 0x3F,
+	0x27, 0xEE,
+	0x2C, 0x27,	/*  bit at 0x20 is cleared below  */
+	0x30, 0x03,
+	0x2C, 0x07,	/*  bit at 0x20 is cleared here   */
+	0x2D, 0x87,
+	0x2E, 0xAA,
+	0x28, 0xE1,	/*  Set the FIFCrst bit here      */
+	0x28, 0xE0,	/*  Clear the FIFCrst bit here    */
+	0x00
+};
+
+/* writing 0x05 0xf0 sw-resets all registers, so we write only needed changes */
+static const u8 MT2063B1_defaults[] = {
+	/* Reg,  Value */
+	0x05, 0xF0,
+	0x11, 0x10,	/* New Enable AFCsd */
+	0x19, 0x05,
+	0x1A, 0x6C,
+	0x1B, 0x24,
+	0x1C, 0x28,
+	0x1D, 0x8F,
+	0x1E, 0x14,
+	0x1F, 0x8F,
+	0x20, 0x57,
+	0x22, 0x21,	/* New - ver 1.03 */
+	0x23, 0x3C,	/* New - ver 1.10 */
+	0x24, 0x20,	/* New - ver 1.03 */
+	0x2C, 0x24,	/*  bit at 0x20 is cleared below  */
+	0x2D, 0x87,	/*  FIFFQ=0  */
+	0x2F, 0xF3,
+	0x30, 0x0C,	/* New - ver 1.11 */
+	0x31, 0x1B,	/* New - ver 1.11 */
+	0x2C, 0x04,	/*  bit at 0x20 is cleared here  */
+	0x28, 0xE1,	/*  Set the FIFCrst bit here      */
+	0x28, 0xE0,	/*  Clear the FIFCrst bit here    */
+	0x00
+};
+
+/* writing 0x05 0xf0 sw-resets all registers, so we write only needed changes */
+static const u8 MT2063B3_defaults[] = {
+	/* Reg,  Value */
+	0x05, 0xF0,
+	0x19, 0x3D,
+	0x2C, 0x24,	/*  bit at 0x20 is cleared below  */
+	0x2C, 0x04,	/*  bit at 0x20 is cleared here  */
+	0x28, 0xE1,	/*  Set the FIFCrst bit here      */
+	0x28, 0xE0,	/*  Clear the FIFCrst bit here    */
+	0x00
+};
+
 static int mt2063_init(struct dvb_frontend *fe)
 {
-	u32 status = -EINVAL;
+	u32 status;
 	struct mt2063_state *state = fe->tuner_priv;
+	u8 all_resets = 0xF0;	/* reset/load bits */
+	const u8 *def = NULL;
+	u32 FCRUN;
+	s32 maxReads;
+	u32 fcu_osc;
+	u32 i;
+
+	state->rcvr_mode = MT2063_CABLE_QAM;
+
+	/*  Read the Part/Rev code from the tuner */
+	status = mt2063_read(state, MT2063_REG_PART_REV, state->reg, 1);
+	if (status < 0)
+		return status;
+
+	/* Check the part/rev code */
+	if (((state->reg[MT2063_REG_PART_REV] != MT2063_B0)	/*  MT2063 B0  */
+	    &&(state->reg[MT2063_REG_PART_REV] != MT2063_B1)	/*  MT2063 B1  */
+	    &&(state->reg[MT2063_REG_PART_REV] != MT2063_B3)))	/*  MT2063 B3  */
+		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 
-	status = MT2063_Open(fe);
-	status |= MT2063_SoftwareShutdown(state, 1);
-	status |= MT2063_ClearPowerMaskBits(state, MT2063_ALL_SD);
+	/*  Check the 2nd byte of the Part/Rev code from the tuner */
+	status = mt2063_read(state, MT2063_REG_RSVD_3B,
+			     &state->reg[MT2063_REG_RSVD_3B], 1);
 
-	if (0 != status) {
-		printk("%s %d error status = 0x%x!!\n", __func__, __LINE__,
-		       status);
-		return -1;
+	/* b7 != 0 ==> NOT MT2063 */
+	if (status < 0 ||((state->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00))
+		return -ENODEV;	/*  Wrong tuner Part/Rev code */
+
+	/*  Reset the tuner  */
+	status = mt2063_write(state, MT2063_REG_LO2CQ_3, &all_resets, 1);
+	if (status < 0)
+		return status;
+
+	/* change all of the default values that vary from the HW reset values */
+	/*  def = (state->reg[PART_REV] == MT2063_B0) ? MT2063B0_defaults : MT2063B1_defaults; */
+	switch (state->reg[MT2063_REG_PART_REV]) {
+	case MT2063_B3:
+		def = MT2063B3_defaults;
+		break;
+
+	case MT2063_B1:
+		def = MT2063B1_defaults;
+		break;
+
+	case MT2063_B0:
+		def = MT2063B0_defaults;
+		break;
+
+	default:
+		return -ENODEV;
+		break;
 	}
 
+	while (status >= 0 && *def) {
+		u8 reg = *def++;
+		u8 val = *def++;
+		status = mt2063_write(state, reg, &val, 1);
+	}
+	if (status < 0)
+		return status;
+
+	/*  Wait for FIFF location to complete.  */
+	FCRUN = 1;
+	maxReads = 10;
+	while (status >= 0 && (FCRUN != 0) && (maxReads-- > 0)) {
+		msleep(2);
+		status = mt2063_read(state,
+					 MT2063_REG_XO_STATUS,
+					 &state->
+					 reg[MT2063_REG_XO_STATUS], 1);
+		FCRUN = (state->reg[MT2063_REG_XO_STATUS] & 0x40) >> 6;
+	}
+
+	if (FCRUN != 0 || status < 0)
+		return -ENODEV;
+
+	status = mt2063_read(state,
+			   MT2063_REG_FIFFC,
+			   &state->reg[MT2063_REG_FIFFC], 1);
+	if (status < 0)
+		return status;
+
+	/* Read back all the registers from the tuner */
+	status = mt2063_read(state,
+				MT2063_REG_PART_REV,
+				state->reg, MT2063_REG_END_REGS);
+	if (status < 0)
+		return status;
+
+	/*  Initialize the tuner state.  */
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
+
+	/*
+	 **   Fetch the FCU osc value and use it and the fRef value to
+	 **   scale all of the Band Max values
+	 */
+
+	state->reg[MT2063_REG_CTUNE_CTRL] = 0x0A;
+	status = mt2063_write(state, MT2063_REG_CTUNE_CTRL,
+			      &state->reg[MT2063_REG_CTUNE_CTRL], 1);
+	if (status < 0)
+		return status;
+
+	/*  Read the ClearTune filter calibration value  */
+	status = mt2063_read(state, MT2063_REG_FIFFC,
+			     &state->reg[MT2063_REG_FIFFC], 1);
+	if (status < 0)
+		return status;
+
+	fcu_osc = state->reg[MT2063_REG_FIFFC];
+
+	state->reg[MT2063_REG_CTUNE_CTRL] = 0x00;
+	status = mt2063_write(state, MT2063_REG_CTUNE_CTRL,
+			      &state->reg[MT2063_REG_CTUNE_CTRL], 1);
+	if (status < 0)
+		return status;
+
+	/*  Adjust each of the values in the ClearTune filter cross-over table  */
+	for (i = 0; i < 31; i++)
+		state->CTFiltMax[i] =(state->CTFiltMax[i] / 768) * (fcu_osc + 640);
+
+	status = MT2063_SoftwareShutdown(state, 1);
+	if (status < 0)
+		return status;
+	status = MT2063_ClearPowerMaskBits(state, MT2063_ALL_SD);
+	if (status < 0)
+		return status;
+
 	return 0;
 }
 
@@ -3858,9 +3771,6 @@ static int mt2063_set_state(struct dvb_frontend *fe,
 	case DVBFE_TUNER_REFCLOCK:
 
 		break;
-	case DVBFE_TUNER_OPEN:
-		status = MT2063_Open(fe);
-		break;
 	case DVBFE_TUNER_SOFTWARE_SHUTDOWN:
 		status = MT2063_SoftwareShutdown(state, 1);
 		break;
@@ -3916,7 +3826,6 @@ struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 	state->i2c = i2c;
 	state->frontend = fe;
 	state->reference = config->refclock / 1000;	/* kHz */
-	state->MT2063_init = false;
 	fe->tuner_priv = state;
 	fe->ops.tuner_ops = mt2063_ops;
 
-- 
1.7.7.5

