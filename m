Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab2AEBBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:08 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q051181u016364
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:08 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 24/47] [media] mt2063: simplify lockstatus logic
Date: Wed,  4 Jan 2012 23:00:35 -0200
Message-Id: <1325725258-27934-25-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  137 +++++++++++-----------------------
 1 files changed, 43 insertions(+), 94 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index a43a859..3c0b3f1 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -8,13 +8,7 @@
 static unsigned int verbose;
 module_param(verbose, int, 0644);
 
-/* Internal structures and types */
-
-/* FIXME: Those two error codes need conversion*/
-/*  Error:  Upconverter PLL is not locked  */
-#define MT2063_UPC_UNLOCK                   (0x80000002)
-/*  Error:  Downconverter PLL is not locked  */
-#define MT2063_DNC_UNLOCK                   (0x80000004)
+/* positive error codes used internally */
 
 /*  Info: Unavoidable LO-related spur may be present in the output  */
 #define MT2063_SPUR_PRESENT_ERR             (0x00800000)
@@ -30,10 +24,6 @@ module_param(verbose, int, 0644);
 #define MT2063_DNC_RANGE                    (0x08000000)
 
 /*
- *  Data Types
- */
-
-/*
  *  Constant defining the version of the following structure
  *  and therefore the API for this code.
  *
@@ -362,29 +352,6 @@ unsigned int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
 	return err;
 }
 
-unsigned int mt2063_lockStatus(struct dvb_frontend *fe)
-{
-	struct dvb_frontend_ops *frontend_ops = &fe->ops;
-	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state t_state;
-	int err = 0;
-
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
-	if (tuner_ops->get_state) {
-		if ((err =
-		     tuner_ops->get_state(fe, DVBFE_TUNER_REFCLOCK,
-					  &t_state)) < 0) {
-			printk("%s: Invalid parameter\n", __func__);
-			return err;
-		}
-	}
-	return err;
-}
-
-
 unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
 {
 	struct mt2063_state *state = fe->tuner_priv;
@@ -1193,39 +1160,21 @@ static u32 MT2063_CalcLO2Mult(u32 * Div, u32 * FracN, u32 f_LO,
 static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num,
 					 u32 denom);
 
-/****************************************************************************
-**
-**  Name: MT2063_GetLocked
-**
-**  Description:    Checks to see if LO1 and LO2 are locked.
-**
-**  Parameters:     h            - Open handle to the tuner (from MT2063_Open).
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_UPC_UNLOCK    - Upconverter PLL unlocked
-**                      MT_DNC_UNLOCK    - Downconverter PLL unlocked
-**                      MT_COMM_ERR      - Serial bus communications error
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**
-**  Dependencies:   MT_ReadSub    - Read byte(s) of data from the serial bus
-**                  MT_Sleep      - Delay execution for x milliseconds
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-****************************************************************************/
-static u32 MT2063_GetLocked(struct mt2063_state *state)
+/**
+ * mt2063_lockStatus - Checks to see if LO1 and LO2 are locked
+ *
+ * @state:	struct mt2063_state pointer
+ *
+ * This function returns 0, if no lock, 1 if locked and a value < 1 if error
+ */
+unsigned int mt2063_lockStatus(struct mt2063_state *state)
 {
 	const u32 nMaxWait = 100;	/*  wait a maximum of 100 msec   */
 	const u32 nPollRate = 2;	/*  poll status bits every 2 ms */
 	const u32 nMaxLoops = nMaxWait / nPollRate;
 	const u8 LO1LK = 0x80;
 	u8 LO2LK = 0x08;
-	u32 status = 0;	/* Status to be returned        */
+	u32 status;
 	u32 nDelays = 0;
 
 	/*  LO2 Lock bit was in a different place for B0 version  */
@@ -1233,28 +1182,24 @@ static u32 MT2063_GetLocked(struct mt2063_state *state)
 		LO2LK = 0x40;
 
 	do {
-		status |=
-		    mt2063_read(state,
-				   MT2063_REG_LO_STATUS,
-				   &state->reg[MT2063_REG_LO_STATUS], 1);
+		status = mt2063_read(state, MT2063_REG_LO_STATUS,
+				     &state->reg[MT2063_REG_LO_STATUS], 1);
 
 		if (status < 0)
-			return (status);
+			return status;
 
 		if ((state->reg[MT2063_REG_LO_STATUS] & (LO1LK | LO2LK)) ==
 		    (LO1LK | LO2LK)) {
-			return (status);
+			return TUNER_STATUS_LOCKED | TUNER_STATUS_STEREO;
 		}
 		msleep(nPollRate);	/*  Wait between retries  */
 	}
 	while (++nDelays < nMaxLoops);
 
-	if ((state->reg[MT2063_REG_LO_STATUS] & LO1LK) == 0x00)
-		status |= MT2063_UPC_UNLOCK;
-	if ((state->reg[MT2063_REG_LO_STATUS] & LO2LK) == 0x00)
-		status |= MT2063_DNC_UNLOCK;
-
-	return (status);
+	/*
+	 * Got no lock or partial lock
+	 */
+	return 0;
 }
 
 /****************************************************************************
@@ -2424,15 +2369,14 @@ static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state, enum MT2063_Mas
 ****************************************************************************/
 static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
 {
-	u32 status = 0;	/* Status to be returned        */
+	u32 status;	/* Status to be returned        */
 
 	if (Shutdown == 1)
 		state->reg[MT2063_REG_PWR_1] |= 0x04;	/* Turn the bit on */
 	else
 		state->reg[MT2063_REG_PWR_1] &= ~0x04;	/* Turn off the bit */
 
-	status |=
-	    mt2063_write(state,
+	status = mt2063_write(state,
 			    MT2063_REG_PWR_1,
 			    &state->reg[MT2063_REG_PWR_1], 1);
 
@@ -2453,7 +2397,7 @@ static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
 				    1);
 	}
 
-	return (status);
+	return status;
 }
 
 /****************************************************************************
@@ -2486,17 +2430,18 @@ static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
 ****************************************************************************/
 static u32 MT2063_SetReg(struct mt2063_state *state, u8 reg, u8 val)
 {
-	u32 status = 0;	/* Status to be returned        */
+	u32 status;
 
 	if (reg >= MT2063_REG_END_REGS)
-		status |= -ERANGE;
+		return -ERANGE;
 
-	status = mt2063_write(state, reg, &val,
-			         1);
-	if (status >= 0)
-		state->reg[reg] = val;
+	status = mt2063_write(state, reg, &val, 1);
+	if (status < 0)
+		return status;
 
-	return (status);
+	state->reg[reg] = val;
+
+	return 0;
 }
 
 static u32 MT2063_Round_fLO(u32 f_LO, u32 f_LO_Step, u32 f_ref)
@@ -2670,7 +2615,7 @@ static u32 FindClearTuneFilter(struct mt2063_state *state, u32 f_in)
 			break;
 		}
 	}
-	return (RFBand);
+	return RFBand;
 }
 
 /****************************************************************************
@@ -2899,18 +2844,22 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 		 **  Check for LO's locking
 		 */
 
-		if (status >= 0) {
-			status |= MT2063_GetLocked(state);
-		}
+		if (status < 0)
+			return status;
+
+		status = mt2063_lockStatus(state);
+		if (status < 0)
+			return status;
+		if (!status)
+			return -EINVAL;		/* Couldn't lock */
+
 		/*
-		 **  If we locked OK, assign calculated data to mt2063_state structure
+		 * If we locked OK, assign calculated data to mt2063_state structure
 		 */
-		if (status >= 0) {
-			state->f_IF1_actual = state->AS_Data.f_LO1 - f_in;
-		}
+		state->f_IF1_actual = state->AS_Data.f_LO1 - f_in;
 	}
 
-	return (status);
+	return status;
 }
 
 static u32 MT_Tune_atv(void *h, u32 f_in, u32 bw_in,
@@ -3321,7 +3270,7 @@ static int mt2063_get_state(struct dvb_frontend *fe,
 		//get bandwidth
 		break;
 	case DVBFE_TUNER_REFCLOCK:
-		tunstate->refclock = (u32) MT2063_GetLocked(state);
+		tunstate->refclock = mt2063_lockStatus(state);
 		break;
 	default:
 		break;
-- 
1.7.7.5

