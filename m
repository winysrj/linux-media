Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab2AEBBJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:09 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q051191E016653
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 29/47] [media] mt2063: Cleanup some function prototypes
Date: Wed,  4 Jan 2012 23:00:40 -0200
Message-Id: <1325725258-27934-30-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No functional changes here.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   44 ++++++++++++---------------------
 1 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 0f4bf96..d13b78b 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -420,7 +420,7 @@ static struct MT2063_ExclZone_t *RemoveNode(struct MT2063_AvoidSpursData_t
 **
 *****************************************************************************/
 static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
-			u32 f_min, u32 f_max)
+			       u32 f_min, u32 f_max)
 {
 	struct MT2063_ExclZone_t *pNode = pAS_Info->usedZones;
 	struct MT2063_ExclZone_t *pPrev = NULL;
@@ -734,7 +734,7 @@ static u32 MT2063_gcd(u32 u, u32 v)
 **
 ****************************************************************************/
 static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
-			    u32 * fm, u32 * fp)
+			u32 *fm, u32 * fp)
 {
 	/*
 	 **  Calculate LO frequency settings.
@@ -849,7 +849,7 @@ static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 **   096   04-06-2005    DAD    Ver 1.11: Fix divide by 0 error if maxH==0.
 **
 *****************************************************************************/
-static u32 MT2063_AvoidSpurs(void *h, struct MT2063_AvoidSpursData_t * pAS_Info)
+static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 	u32 status = 0;
 	u32 fm, fp;		/*  restricted range on LO's        */
@@ -1011,18 +1011,6 @@ static const u8 FIFOVDIS[] = { 0, 0, 0, 0, 0, 0 };
 static const u8 ACFIFMAX[] = { 29, 29, 29, 29, 29, 29 };
 static const u8 PD2TGT[] = { 40, 33, 38, 42, 30, 38 };
 
-/*
-**  Local Function Prototypes - not available for external access.
-*/
-
-/*  Forward declaration(s):  */
-static u32 MT2063_CalcLO1Mult(u32 * Div, u32 * FracN, u32 f_LO,
-				  u32 f_LO_Step, u32 f_Ref);
-static u32 MT2063_CalcLO2Mult(u32 * Div, u32 * FracN, u32 f_LO,
-				  u32 f_LO_Step, u32 f_Ref);
-static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num,
-					 u32 denom);
-
 /**
  * mt2063_lockStatus - Checks to see if LO1 and LO2 are locked
  *
@@ -1300,7 +1288,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 **
 ******************************************************************************/
 static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
-				      enum MT2063_RCVR_MODES Mode)
+				  enum MT2063_RCVR_MODES Mode)
 {
 	u32 status = 0;	/* Status to be returned        */
 	u8 val;
@@ -1464,7 +1452,8 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state, enum MT2063_Mask_Bits Bits)
+static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state,
+				     enum MT2063_Mask_Bits Bits)
 {
 	u32 status = 0;	/* Status to be returned        */
 
@@ -1584,8 +1573,7 @@ static u32 MT2063_Round_fLO(u32 f_LO, u32 f_LO_Step, u32 f_ref)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_fLO_FractionalTerm(u32 f_ref,
-					 u32 num, u32 denom)
+static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num, u32 denom)
 {
 	u32 t1 = (f_ref >> 14) * num;
 	u32 term1 = t1 / denom;
@@ -1623,9 +1611,9 @@ static u32 MT2063_fLO_FractionalTerm(u32 f_ref,
 **
 ****************************************************************************/
 static u32 MT2063_CalcLO1Mult(u32 * Div,
-				  u32 * FracN,
-				  u32 f_LO,
-				  u32 f_LO_Step, u32 f_Ref)
+			      u32 * FracN,
+			      u32 f_LO,
+			      u32 f_LO_Step, u32 f_Ref)
 {
 	/*  Calculate the whole number portion of the divider */
 	*Div = f_LO / f_Ref;
@@ -1666,9 +1654,9 @@ static u32 MT2063_CalcLO1Mult(u32 * Div,
 **
 ****************************************************************************/
 static u32 MT2063_CalcLO2Mult(u32 * Div,
-				  u32 * FracN,
-				  u32 f_LO,
-				  u32 f_LO_Step, u32 f_Ref)
+			      u32 * FracN,
+			      u32 f_LO,
+			      u32 f_LO_Step, u32 f_Ref)
 {
 	/*  Calculate the whole number portion of the divider */
 	*Div = f_LO / f_Ref;
@@ -1857,7 +1845,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	 ** Check for any LO spurs in the output bandwidth and adjust
 	 ** the LO settings to avoid them if needed
 	 */
-	status |= MT2063_AvoidSpurs(state, &state->AS_Data);
+	status |= MT2063_AvoidSpurs(&state->AS_Data);
 	/*
 	 ** MT_AvoidSpurs spurs may have changed the LO1 & LO2 values.
 	 ** Recalculate the LO frequencies and the values to be placed
@@ -1967,7 +1955,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 }
 
 int mt2063_setTune(struct dvb_frontend *fe, u32 f_in, u32 bw_in,
-			    enum MTTune_atv_standard tv_type)
+		   enum MTTune_atv_standard tv_type)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 	u32 status = 0;
@@ -2349,7 +2337,7 @@ static int mt2063_get_status(struct dvb_frontend *fe, u32 * status)
 {
 	int rc = 0;
 
-	//get tuner lock status
+	/* FIXME: add get tuner lock status */
 
 	return rc;
 }
-- 
1.7.7.5

