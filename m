Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab2AEBBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:08 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q051184G002479
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:08 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 23/47] [media] mt2063: Remove several unused parameters
Date: Wed,  4 Jan 2012 23:00:34 -0200
Message-Id: <1325725258-27934-24-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  364 +---------------------------------
 1 files changed, 2 insertions(+), 362 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 8662007..a43a859 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -124,18 +124,6 @@ enum MT2063_Mask_Bits {
  *  specifies the tuning algorithm parameter to be read/written.
  */
 enum MT2063_Param {
-	/*  tuner address                                  set by MT2063_Open() */
-	MT2063_IC_ADDR,
-
-	/*  max number of MT2063 tuners     set by MT_TUNER_CNT in mt_userdef.h */
-	MT2063_MAX_OPEN,
-
-	/*  current number of open MT2063 tuners           set by MT2063_Open() */
-	MT2063_NUM_OPEN,
-
-	/*  crystal frequency                            (default: 16000000 Hz) */
-	MT2063_SRO_FREQ,
-
 	/*  min tuning step size                            (default: 50000 Hz) */
 	MT2063_STEPSIZE,
 
@@ -145,66 +133,15 @@ enum MT2063_Param {
 	/*  LO1 Frequency                                  set by MT2063_Tune() */
 	MT2063_LO1_FREQ,
 
-	/*  LO1 minimum step size                          (default: 250000 Hz) */
-	MT2063_LO1_STEPSIZE,
-
-	/*  LO1 FracN keep-out region                      (default: 999999 Hz) */
-	MT2063_LO1_FRACN_AVOID_PARAM,
-
-	/*  Current 1st IF in use                          set by MT2063_Tune() */
-	MT2063_IF1_ACTUAL,
-
-	/*  Requested 1st IF                               set by MT2063_Tune() */
-	MT2063_IF1_REQUEST,
-
-	/*  Center of 1st IF SAW filter                (default: 1218000000 Hz) */
-	MT2063_IF1_CENTER,
-
-	/*  Bandwidth of 1st IF SAW filter               (default: 20000000 Hz) */
-	MT2063_IF1_BW,
-
-	/*  zero-IF bandwidth                             (default: 2000000 Hz) */
-	MT2063_ZIF_BW,
-
 	/*  LO2 Frequency                                  set by MT2063_Tune() */
 	MT2063_LO2_FREQ,
 
-	/*  LO2 minimum step size                           (default: 50000 Hz) */
-	MT2063_LO2_STEPSIZE,
-
-	/*  LO2 FracN keep-out region                      (default: 374999 Hz) */
-	MT2063_LO2_FRACN_AVOID,
-
 	/*  output center frequency                        set by MT2063_Tune() */
 	MT2063_OUTPUT_FREQ,
 
 	/*  output bandwidth                               set by MT2063_Tune() */
 	MT2063_OUTPUT_BW,
 
-	/*  min inter-tuner LO separation                 (default: 1000000 Hz) */
-	MT2063_LO_SEPARATION,
-
-	/*  ID of avoid-spurs algorithm in use            compile-time constant */
-	MT2063_AS_ALG,
-
-	/*  max # of intra-tuner harmonics                       (default: 15)  */
-	MT2063_MAX_HARM1,
-
-	/*  max # of inter-tuner harmonics                        (default: 7)  */
-	MT2063_MAX_HARM2,
-
-	/*  # of 1st IF exclusion zones used               set by MT2063_Tune() */
-	MT2063_EXCL_ZONES,
-
-	/*  # of spurs found/avoided                       set by MT2063_Tune() */
-	MT2063_NUM_SPURS,
-
-	/*  >0 spurs avoided                               set by MT2063_Tune() */
-	MT2063_SPUR_AVOIDED,
-
-	/*  >0 spurs in output (mathematically)            set by MT2063_Tune() */
-	MT2063_SPUR_PRESENT,
-
 	/* Receiver Mode for some parameters. 1 is DVB-T                        */
 	MT2063_RCVR_MODE,
 
@@ -247,24 +184,6 @@ enum MT2063_Param {
 	/*  Selects, which DNC is activ                                         */
 	MT2063_DNC_OUTPUT_ENABLE,
 
-	/*  VGA gain code                                                       */
-	MT2063_VGAGC,
-
-	/*  VGA bias current                                                    */
-	MT2063_VGAOI,
-
-	/*  TAGC, determins the speed of the AGC                                */
-	MT2063_TAGC,
-
-	/*  AMP gain code                                                       */
-	MT2063_AMPGC,
-
-	/* Control setting to avoid DECT freqs         (default: MT_AVOID_BOTH) */
-	MT2063_AVOID_DECT,
-
-	/* Cleartune filter selection: 0 - by IC (default), 1 - by software     */
-	MT2063_CTFILT_SW,
-
 	MT2063_EOP		/*  last entry in enumerated list         */
 };
 
@@ -1184,16 +1103,10 @@ static u32 MT2063_AvoidSpurs(void *h, struct MT2063_AvoidSpursData_t * pAS_Info)
 	return (status);
 }
 
-//end of mt2063_spuravoid.c
-//=================================================================
-//#################################################################
-//=================================================================
-
 /*
 **  The expected version of MT_AvoidSpursData_t
 **  If the version is different, an updated file is needed from Microtune
 */
-/* Expecting version 1.21 of the Spur Avoidance API */
 
 typedef enum {
 	MT2063_SET_ATTEN,
@@ -1201,10 +1114,9 @@ typedef enum {
 	MT2063_DECR_ATTEN
 } MT2063_ATTEN_CNTL_MODE;
 
-//#define TUNER_MT2063_OPTIMIZATION
 /*
-** Constants used by the tuning algorithm
-*/
+ * Constants used by the tuning algorithm
+ */
 #define MT2063_REF_FREQ          (16000000UL)	/* Reference oscillator Frequency (in Hz) */
 #define MT2063_IF1_BW            (22000000UL)	/* The IF1 filter bandwidth (in Hz) */
 #define MT2063_TUNE_STEP_SIZE       (50000UL)	/* Tune in steps of 50 kHz */
@@ -1233,16 +1145,6 @@ typedef enum {
 #define MT2063_B3       (0x9E)
 
 /*
-**  The number of Tuner Registers
-*/
-static const u32 MT2063_Num_Registers = MT2063_REG_END_REGS;
-
-#define USE_GLOBAL_TUNER			0
-
-static u32 nMT2063MaxTuners = 1;
-static u32 nMT2063OpenTuners = 0;
-
-/*
 **  Constants for setting receiver modes.
 **  (6 modes defined at this time, enumerated by MT2063_RCVR_MODES)
 **  (DNC1GC & DNC2GC are the values, which are used, when the specific
@@ -1372,8 +1274,6 @@ static u32 MT2063_GetLocked(struct mt2063_state *state)
 **                  param                     Description
 **                  ----------------------    --------------------------------
 **                  MT2063_IC_ADDR            Serial Bus address of this tuner
-**                  MT2063_MAX_OPEN           Max # of MT2063's allowed open
-**                  MT2063_NUM_OPEN           # of MT2063's open
 **                  MT2063_SRO_FREQ           crystal frequency
 **                  MT2063_STEPSIZE           minimum tuning step size
 **                  MT2063_INPUT_FREQ         input center frequency
@@ -1457,31 +1357,6 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 		return -EINVAL;
 
 	switch (param) {
-		/*  Serial Bus address of this tuner      */
-	case MT2063_IC_ADDR:
-		*pValue = state->config->tuner_address;
-		break;
-
-		/*  Max # of MT2063's allowed to be open  */
-	case MT2063_MAX_OPEN:
-		*pValue = nMT2063MaxTuners;
-		break;
-
-		/*  # of MT2063's open                    */
-	case MT2063_NUM_OPEN:
-		*pValue = nMT2063OpenTuners;
-		break;
-
-		/*  crystal frequency                     */
-	case MT2063_SRO_FREQ:
-		*pValue = state->AS_Data.f_ref;
-		break;
-
-		/*  minimum tuning step size              */
-	case MT2063_STEPSIZE:
-		*pValue = state->AS_Data.f_LO2_Step;
-		break;
-
 		/*  input center frequency                */
 	case MT2063_INPUT_FREQ:
 		*pValue = state->AS_Data.f_in;
@@ -1506,31 +1381,6 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 		*pValue = state->AS_Data.f_LO1;
 		break;
 
-		/*  LO1 minimum step size                 */
-	case MT2063_LO1_STEPSIZE:
-		*pValue = state->AS_Data.f_LO1_Step;
-		break;
-
-		/*  LO1 FracN keep-out region             */
-	case MT2063_LO1_FRACN_AVOID_PARAM:
-		*pValue = state->AS_Data.f_LO1_FracN_Avoid;
-		break;
-
-		/*  Current 1st IF in use                 */
-	case MT2063_IF1_ACTUAL:
-		*pValue = state->f_IF1_actual;
-		break;
-
-		/*  Requested 1st IF                      */
-	case MT2063_IF1_REQUEST:
-		*pValue = state->AS_Data.f_if1_Request;
-		break;
-
-		/*  Center of 1st IF SAW filter           */
-	case MT2063_IF1_CENTER:
-		*pValue = state->AS_Data.f_if1_Center;
-		break;
-
 		/*  Bandwidth of 1st IF SAW filter        */
 	case MT2063_IF1_BW:
 		*pValue = state->AS_Data.f_if1_bw;
@@ -1568,11 +1418,6 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 		*pValue = state->AS_Data.f_LO2;
 		break;
 
-		/*  LO2 minimum step size                 */
-	case MT2063_LO2_STEPSIZE:
-		*pValue = state->AS_Data.f_LO2_Step;
-		break;
-
 		/*  LO2 FracN keep-out region             */
 	case MT2063_LO2_FRACN_AVOID:
 		*pValue = state->AS_Data.f_LO2_FracN_Avoid;
@@ -1588,41 +1433,6 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 		*pValue = state->AS_Data.f_out_bw - 750000;
 		break;
 
-		/*  min inter-tuner LO separation         */
-	case MT2063_LO_SEPARATION:
-		*pValue = state->AS_Data.f_min_LO_Separation;
-		break;
-
-		/*  max # of intra-tuner harmonics        */
-	case MT2063_MAX_HARM1:
-		*pValue = state->AS_Data.maxH1;
-		break;
-
-		/*  max # of inter-tuner harmonics        */
-	case MT2063_MAX_HARM2:
-		*pValue = state->AS_Data.maxH2;
-		break;
-
-		/*  # of 1st IF exclusion zones           */
-	case MT2063_EXCL_ZONES:
-		*pValue = state->AS_Data.nZones;
-		break;
-
-		/*  # of spurs found/avoided              */
-	case MT2063_NUM_SPURS:
-		*pValue = state->AS_Data.nSpursFound;
-		break;
-
-		/*  >0 spurs avoided                      */
-	case MT2063_SPUR_AVOIDED:
-		*pValue = state->AS_Data.bSpurAvoided;
-		break;
-
-		/*  >0 spurs in output (mathematically)   */
-	case MT2063_SPUR_PRESENT:
-		*pValue = state->AS_Data.bSpurPresent;
-		break;
-
 		/*  Predefined receiver setup combination */
 	case MT2063_RCVR_MODE:
 		*pValue = state->rcvr_mode;
@@ -1766,37 +1576,6 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 	}
 	break;
 
-	/*  Get VGA Gain Code */
-		case MT2063_VGAGC:
-		*pValue = ((state->reg[MT2063_REG_VGA_GAIN] & 0x0C) >> 2);
-		break;
-
-		/*  Get VGA bias current */
-	case MT2063_VGAOI:
-		*pValue = (state->reg[MT2063_REG_RSVD_31] & 0x07);
-		break;
-
-		/*  Get TAGC setting */
-	case MT2063_TAGC:
-		*pValue = (state->reg[MT2063_REG_RSVD_1E] & 0x03);
-		break;
-
-		/*  Get AMP Gain Code */
-	case MT2063_AMPGC:
-		*pValue = (state->reg[MT2063_REG_TEMP_SEL] & 0x03);
-		break;
-
-		/*  Avoid DECT Frequencies  */
-	case MT2063_AVOID_DECT:
-		*pValue = state->AS_Data.avoidDECT;
-		break;
-
-		/*  Cleartune filter selection: 0 - by IC (default), 1 - by software  */
-	case MT2063_CTFILT_SW:
-		*pValue = state->ctfilt_sw;
-		break;
-
-	case MT2063_EOP:
 	default:
 		status |= -ERANGE;
 	}
@@ -2136,22 +1915,6 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 	u8 val = 0;
 
 	switch (param) {
-		/*  crystal frequency                     */
-	case MT2063_SRO_FREQ:
-		state->AS_Data.f_ref = nValue;
-		state->AS_Data.f_LO1_FracN_Avoid = 0;
-		state->AS_Data.f_LO2_FracN_Avoid = nValue / 80 - 1;
-		state->AS_Data.f_LO1_Step = nValue / 64;
-		state->AS_Data.f_if1_Center =
-		    (state->AS_Data.f_ref / 8) *
-		    (state->reg[MT2063_REG_FIFFC] + 640);
-		break;
-
-		/*  minimum tuning step size              */
-	case MT2063_STEPSIZE:
-		state->AS_Data.f_LO2_Step = nValue;
-		break;
-
 		/*  LO1 frequency                         */
 	case MT2063_LO1_FREQ:
 		{
@@ -2245,21 +2008,6 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 		}
 		break;
 
-		/*  LO1 minimum step size                 */
-	case MT2063_LO1_STEPSIZE:
-		state->AS_Data.f_LO1_Step = nValue;
-		break;
-
-		/*  LO1 FracN keep-out region             */
-	case MT2063_LO1_FRACN_AVOID_PARAM:
-		state->AS_Data.f_LO1_FracN_Avoid = nValue;
-		break;
-
-		/*  Requested 1st IF                      */
-	case MT2063_IF1_REQUEST:
-		state->AS_Data.f_if1_Request = nValue;
-		break;
-
 		/*  zero-IF bandwidth                     */
 	case MT2063_ZIF_BW:
 		state->AS_Data.f_zif_bw = nValue;
@@ -2352,11 +2100,6 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 		}
 		break;
 
-		/*  LO2 minimum step size                 */
-	case MT2063_LO2_STEPSIZE:
-		state->AS_Data.f_LO2_Step = nValue;
-		break;
-
 		/*  LO2 FracN keep-out region             */
 	case MT2063_LO2_FRACN_AVOID:
 		state->AS_Data.f_LO2_FracN_Avoid = nValue;
@@ -2372,21 +2115,6 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 		state->AS_Data.f_out_bw = nValue + 750000;
 		break;
 
-		/*  min inter-tuner LO separation         */
-	case MT2063_LO_SEPARATION:
-		state->AS_Data.f_min_LO_Separation = nValue;
-		break;
-
-		/*  max # of intra-tuner harmonics        */
-	case MT2063_MAX_HARM1:
-		state->AS_Data.maxH1 = nValue;
-		break;
-
-		/*  max # of inter-tuner harmonics        */
-	case MT2063_MAX_HARM2:
-		state->AS_Data.maxH2 = nValue;
-		break;
-
 	case MT2063_RCVR_MODE:
 		status |=
 		    MT2063_SetReceiverMode(state,
@@ -2610,94 +2338,6 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 		}
 		break;
 
-	case MT2063_VGAGC:
-		/* Set VGA gain code */
-		val =
-		    (state->
-		     reg[MT2063_REG_VGA_GAIN] & (u8) ~ 0x0C) |
-		    ((nValue & 0x03) << 2);
-		if (state->reg[MT2063_REG_VGA_GAIN] != val) {
-			status |=
-			    MT2063_SetReg(state, MT2063_REG_VGA_GAIN,
-					  val);
-		}
-		break;
-
-	case MT2063_VGAOI:
-		/* Set VGA bias current */
-		val =
-		    (state->
-		     reg[MT2063_REG_RSVD_31] & (u8) ~ 0x07) |
-		    (nValue & 0x07);
-		if (state->reg[MT2063_REG_RSVD_31] != val) {
-			status |=
-			    MT2063_SetReg(state, MT2063_REG_RSVD_31,
-					  val);
-		}
-		break;
-
-	case MT2063_TAGC:
-		/* Set TAGC */
-		val =
-		    (state->
-		     reg[MT2063_REG_RSVD_1E] & (u8) ~ 0x03) |
-		    (nValue & 0x03);
-		if (state->reg[MT2063_REG_RSVD_1E] != val) {
-			status |=
-			    MT2063_SetReg(state, MT2063_REG_RSVD_1E,
-					  val);
-		}
-		break;
-
-	case MT2063_AMPGC:
-		/* Set Amp gain code */
-		val =
-		    (state->
-		     reg[MT2063_REG_TEMP_SEL] & (u8) ~ 0x03) |
-		    (nValue & 0x03);
-		if (state->reg[MT2063_REG_TEMP_SEL] != val) {
-			status |=
-			    MT2063_SetReg(state, MT2063_REG_TEMP_SEL,
-					  val);
-		}
-		break;
-
-		/*  Avoid DECT Frequencies                */
-	case MT2063_AVOID_DECT:
-		{
-			enum MT2063_DECT_Avoid_Type newAvoidSetting =
-			    (enum MT2063_DECT_Avoid_Type)nValue;
-			if ((newAvoidSetting >=
-			     MT2063_NO_DECT_AVOIDANCE)
-			    && (newAvoidSetting <= MT2063_AVOID_BOTH)) {
-				state->AS_Data.avoidDECT =
-				    newAvoidSetting;
-			}
-		}
-		break;
-
-		/*  Cleartune filter selection: 0 - by IC (default), 1 - by software  */
-	case MT2063_CTFILT_SW:
-		state->ctfilt_sw = (nValue & 0x01);
-		break;
-
-		/*  These parameters are read-only  */
-	case MT2063_IC_ADDR:
-	case MT2063_MAX_OPEN:
-	case MT2063_NUM_OPEN:
-	case MT2063_INPUT_FREQ:
-	case MT2063_IF1_ACTUAL:
-	case MT2063_IF1_CENTER:
-	case MT2063_IF1_BW:
-	case MT2063_AS_ALG:
-	case MT2063_EXCL_ZONES:
-	case MT2063_SPUR_AVOIDED:
-	case MT2063_NUM_SPURS:
-	case MT2063_SPUR_PRESENT:
-	case MT2063_ACLNA:
-	case MT2063_ACRF:
-	case MT2063_ACFIF:
-	case MT2063_EOP:
 	default:
 		status |= -ERANGE;
 	}
-- 
1.7.7.5

