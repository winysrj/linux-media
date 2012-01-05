Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab2AEBBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:08 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05117MY016642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:08 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 19/47] [media] mt2063: Simplify some functions
Date: Wed,  4 Jan 2012 23:00:30 -0200
Message-Id: <1325725258-27934-20-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  150 +++-------------------------------
 1 files changed, 12 insertions(+), 138 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 0ae6c15..1011635 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -75,7 +75,6 @@ struct MT2063_ExclZone_t {
  *  Structure of data needed for Spur Avoidance
  */
 struct MT2063_AvoidSpursData_t {
-	u32 nAS_Algorithm;
 	u32 f_ref;
 	u32 f_in;
 	u32 f_LO1;
@@ -410,7 +409,6 @@ struct mt2063_state {
 static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
                         u32 f_min, u32 f_max);
 static u32 MT2063_ReInit(struct mt2063_state *state);
-static u32 MT2063_Close(struct mt2063_state *state);
 static u32 MT2063_GetReg(struct mt2063_state *state, u8 reg, u8 * val);
 static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param, u32 * pValue);
 static u32 MT2063_SetReg(struct mt2063_state *state, u8 reg, u8 val);
@@ -606,29 +604,9 @@ static u32 mt2063_read(struct mt2063_state *state,
 	return (status);
 }
 
-/*****************************************************************************
-**
-**  Name: MT_Sleep
-**
-**  Description:    Delay execution for "nMinDelayTime" milliseconds
-**
-**  Parameters:     hUserData     - User-specific I/O parameter that was
-**                                  passed to tuner's Open function.
-**                  nMinDelayTime - Delay time in milliseconds
-**
-**  Returns:        None.
-**
-**  Notes:          This is a callback function that is called from the
-**                  the tuning algorithm.  You MUST provide code that
-**                  blocks execution for the specified period of time.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   N/A   03-25-2004    DAD    Original
-**
-*****************************************************************************/
+/*
+ * FIXME: Is this really needed?
+ */
 static int MT2063_Sleep(struct dvb_frontend *fe)
 {
 	/*
@@ -640,78 +618,19 @@ static int MT2063_Sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-//end of mt2063_userdef.c
-//=================================================================
-//#################################################################
-//=================================================================
-
-//context of mt2063_spuravoid.c <Henry> ======================================
-//#################################################################
-//=================================================================
-
-/*****************************************************************************
-**
-**  Name: mt_spuravoid.c
-**
-**  Description:    Microtune spur avoidance software module.
-**                  Supports Microtune tuner drivers.
-**
-**  CVS ID:         $Id: mt_spuravoid.c,v 1.3 2008/06/26 15:39:52 software Exp $
-**  CVS Source:     $Source: /export/home/cvsroot/software/tuners/MT2063/mt_spuravoid.c,v $
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   082   03-25-2005    JWS    Original multi-tuner support - requires
-**                              MTxxxx_CNT declarations
-**   096   04-06-2005    DAD    Ver 1.11: Fix divide by 0 error if maxH==0.
-**   094   04-06-2005    JWS    Ver 1.11 Added uceil and ufloor to get rid
-**                              of compiler warnings
-**   N/A   04-07-2005    DAD    Ver 1.13: Merged single- and multi-tuner spur
-**                              avoidance into a single module.
-**   103   01-31-2005    DAD    Ver 1.14: In MT_AddExclZone(), if the range
-**                              (f_min, f_max) < 0, ignore the entry.
-**   115   03-23-2007    DAD    Fix declaration of spur due to truncation
-**                              errors.
-**   117   03-29-2007    RSK    Ver 1.15: Re-wrote to match search order from
-**                              tuner DLL.
-**   137   06-18-2007    DAD    Ver 1.16: Fix possible divide-by-0 error for
-**                              multi-tuners that have
-**                              (delta IF1) > (f_out-f_outbw/2).
-**   147   07-27-2007    RSK    Ver 1.17: Corrected calculation (-) to (+)
-**                              Added logic to force f_Center within 1/2 f_Step.
-**   177 S 02-26-2008    RSK    Ver 1.18: Corrected calculation using LO1 > MAX/2
-**                              Type casts added to preserve correct sign.
-**   N/A I 06-17-2008    RSK    Ver 1.19: Refactoring avoidance of DECT
-**                              frequencies into MT_ResetExclZones().
-**   N/A I 06-20-2008    RSK    Ver 1.21: New VERSION number for ver checking.
-**
-*****************************************************************************/
-
+/*
+ * Microtune spur avoidance
+ */
 
 /*  Implement ceiling, floor functions.  */
 #define ceil(n, d) (((n) < 0) ? (-((-(n))/(d))) : (n)/(d) + ((n)%(d) != 0))
-#define uceil(n, d) ((n)/(d) + ((n)%(d) != 0))
 #define floor(n, d) (((n) < 0) ? (-((-(n))/(d))) - ((n)%(d) != 0) : (n)/(d))
-#define ufloor(n, d) ((n)/(d))
 
 struct MT2063_FIFZone_t {
 	s32 min_;
 	s32 max_;
 };
 
-
-static u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
-{
-	pAS_Info->nAS_Algorithm = 1;
-	return 0;
-}
-
-static void MT2063_UnRegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
-{
-}
-
 /*
 **  Reset all exclusion zones.
 **  Add zones to protect the PLL FracN regions near zero
@@ -1153,7 +1072,7 @@ static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 	gf_Scale = MT2063_umax((u32) MT2063_gcd(lo_gcd, f), f_Scale);
 	hgfs = gf_Scale / 2;
 
-	n0 = uceil(f_LO2 - d, f_LO1 - f_LO2);
+	n0 = DIV_ROUND_UP(f_LO2 - d, f_LO1 - f_LO2);
 
 	/*  Check out all multiples of LO1 from n0 to m_maxLOSpurHarmonic  */
 	for (n = n0; n <= pAS_Info->maxH1; ++n) {
@@ -1462,54 +1381,14 @@ static u32 MT2063_Open(struct dvb_frontend *fe)
 	u32 status;	/*  Status to be returned.  */
 	struct mt2063_state *state = fe->tuner_priv;
 
-	/*  Default tuner handle to NULL.  If successful, it will be reassigned  */
-
-	if (state->MT2063_init == false)
-		state->rcvr_mode = MT2063_CABLE_QAM;
-
-	status = MT2063_RegisterTuner(&state->AS_Data);
-	if (status >= 0) {
-		state->rcvr_mode = MT2063_CABLE_QAM;
+	state->rcvr_mode = MT2063_CABLE_QAM;
+	if (state->MT2063_init != false) {
 		status = MT2063_ReInit(state);
+		if (status < 0)
+			return status;
 	}
 
-	if (status < 0)
-		/*  MT2063_Close handles the un-registration of the tuner  */
-		MT2063_Close(state);
-	else {
-		state->MT2063_init = true;
-	}
-
-	return (status);
-}
-
-/******************************************************************************
-**
-**  Name: MT2063_Close
-**
-**  Description:    Release the handle to the tuner.
-**
-**  Parameters:     hMT2063      - Handle to the MT2063 tuner
-**
-**  Returns:        status:
-**                      MT_OK         - No errors
-**                      MT_INV_HANDLE - Invalid tuner handle
-**
-**  Dependencies:   mt_errordef.h - definition of error codes
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-******************************************************************************/
-static u32 MT2063_Close(struct mt2063_state *state)
-{
-	/* Unregister tuner with SpurAvoidance routines (if needed) */
-	MT2063_UnRegisterTuner(&state->AS_Data);
-	/* Now remove the tuner from our own list of tuners */
-
+	state->MT2063_init = true;
 	return 0;
 }
 
@@ -1815,11 +1694,6 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 		*pValue = state->AS_Data.f_min_LO_Separation;
 		break;
 
-		/*  ID of avoid-spurs algorithm in use    */
-	case MT2063_AS_ALG:
-		*pValue = state->AS_Data.nAS_Algorithm;
-		break;
-
 		/*  max # of intra-tuner harmonics        */
 	case MT2063_MAX_HARM1:
 		*pValue = state->AS_Data.maxH1;
-- 
1.7.7.5

