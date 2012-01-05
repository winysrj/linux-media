Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328Ab2AEBBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:12 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511CM9016410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:12 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 32/47] [media] mt2063: Fix comments
Date: Wed,  4 Jan 2012 23:00:43 -0200
Message-Id: <1325725258-27934-33-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  959 +++++++++++++---------------------
 1 files changed, 370 insertions(+), 589 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 4f634ad..181deac 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -1,3 +1,22 @@
+/*
+ * Driver for mt2063 Micronas tuner
+ *
+ * Copyright (c) 2011 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This driver came from a driver originally written by Henry, made available
+ * by Terratec, at:
+ *	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -89,8 +108,8 @@ struct MT2063_AvoidSpursData_t {
 };
 
 /*
- *  Parameter for function MT2063_SetPowerMask that specifies the power down
- *  of various sections of the MT2063.
+ * Parameter for function MT2063_SetPowerMask that specifies the power down
+ * of various sections of the MT2063.
  */
 enum MT2063_Mask_Bits {
 	MT2063_REG_SD = 0x0040,		/* Shutdown regulator                 */
@@ -134,9 +153,9 @@ enum MT2063_DNC_Output_Enable {
 };
 
 /*
-**  Two-wire serial bus subaddresses of the tuner registers.
-**  Also known as the tuner's register addresses.
-*/
+ *  Two-wire serial bus subaddresses of the tuner registers.
+ *  Also known as the tuner's register addresses.
+ */
 enum MT2063_Register_Offsets {
 	MT2063_REG_PART_REV = 0,	/*  0x00: Part/Rev Code         */
 	MT2063_REG_LO1CQ_1,		/*  0x01: LO1C Queued Byte 1    */
@@ -320,8 +339,7 @@ static u32 mt2063_read(struct mt2063_state *state,
 static int MT2063_Sleep(struct dvb_frontend *fe)
 {
 	/*
-	 **  ToDo:  Add code here to implement a OS blocking
-	 **         for a period of "nMinDelayTime" milliseconds.
+	 *  ToDo:  Add code here to implement a OS blocking
 	 */
 	msleep(10);
 
@@ -391,23 +409,14 @@ static struct MT2063_ExclZone_t *RemoveNode(struct MT2063_AvoidSpursData_t
 	return pNext;
 }
 
-/*****************************************************************************
-**
-**  Name: MT_AddExclZone
-**
-**  Description:    Add (and merge) an exclusion zone into the list.
-**                  If the range (f_min, f_max) is totally outside the
-**                  1st IF BW, ignore the entry.
-**                  If the range (f_min, f_max) is negative, ignore the entry.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   103   01-31-2005    DAD    Ver 1.14: In MT_AddExclZone(), if the range
-**                              (f_min, f_max) < 0, ignore the entry.
-**
-*****************************************************************************/
+/*
+ * MT_AddExclZone()
+ *
+ * Add (and merge) an exclusion zone into the list.
+ * If the range (f_min, f_max) is totally outside the
+ * 1st IF BW, ignore the entry.
+ * If the range (f_min, f_max) is negative, ignore the entry.
+ */
 static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
 			       u32 f_min, u32 f_max)
 {
@@ -420,11 +429,11 @@ static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
 	    && (f_min < (pAS_Info->f_if1_Center + (pAS_Info->f_if1_bw / 2)))
 	    && (f_min < f_max)) {
 		/*
-		 **                1           2          3        4         5          6
-		 **
-		 **   New entry:  |---|    |--|        |--|       |-|      |---|         |--|
-		 **                     or          or        or       or        or
-		 **   Existing:  |--|          |--|      |--|    |---|      |-|      |--|
+		 *                1        2         3      4       5        6
+		 *
+		 *   New entry:  |---|    |--|      |--|    |-|    |---|    |--|
+		 *                or       or        or     or      or
+		 *   Existing:  |--|      |--|      |--|    |---|  |-|      |--|
 		 */
 
 		/*  Check for our place in the list  */
@@ -450,18 +459,16 @@ static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
 		while ((pNext != NULL) && (pNext->min_ < pNode->max_)) {
 			if (pNext->max_ > pNode->max_)
 				pNode->max_ = pNext->max_;
-			pNext = RemoveNode(pAS_Info, pNode, pNext);	/*  Remove pNext, return ptr to pNext->next  */
+			/*  Remove pNext, return ptr to pNext->next  */
+			pNext = RemoveNode(pAS_Info, pNode, pNext);
 		}
 	}
 }
 
 /*
-**  Reset all exclusion zones.
-**  Add zones to protect the PLL FracN regions near zero
-**
-**   N/A I 06-17-2008    RSK    Ver 1.19: Refactoring avoidance of DECT
-**                              frequencies into MT_ResetExclZones().
-*/
+ *  Reset all exclusion zones.
+ *  Add zones to protect the PLL FracN regions near zero
+ */
 static void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 	u32 center;
@@ -525,32 +532,21 @@ static void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info)
 	}
 }
 
-/*****************************************************************************
-**
-**  Name: MT_ChooseFirstIF
-**
-**  Description:    Choose the best available 1st IF
-**                  If f_Desired is not excluded, choose that first.
-**                  Otherwise, return the value closest to f_Center that is
-**                  not excluded
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   117   03-29-2007    RSK    Ver 1.15: Re-wrote to match search order from
-**                              tuner DLL.
-**   147   07-27-2007    RSK    Ver 1.17: Corrected calculation (-) to (+)
-**                              Added logic to force f_Center within 1/2 f_Step.
-**
-*****************************************************************************/
+/*
+ * MT_ChooseFirstIF - Choose the best available 1st IF
+ *                    If f_Desired is not excluded, choose that first.
+ *                    Otherwise, return the value closest to f_Center that is
+ *                    not excluded
+ */
 static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 	/*
-	 ** Update "f_Desired" to be the nearest "combinational-multiple" of "f_LO1_Step".
-	 ** The resulting number, F_LO1 must be a multiple of f_LO1_Step.  And F_LO1 is the arithmetic sum
-	 ** of f_in + f_Center.  Neither f_in, nor f_Center must be a multiple of f_LO1_Step.
-	 ** However, the sum must be.
+	 * Update "f_Desired" to be the nearest "combinational-multiple" of
+	 * "f_LO1_Step".
+	 * The resulting number, F_LO1 must be a multiple of f_LO1_Step.
+	 * And F_LO1 is the arithmetic sum of f_in + f_Center.
+	 * Neither f_in, nor f_Center must be a multiple of f_LO1_Step.
+	 * However, the sum must be.
 	 */
 	const u32 f_Desired =
 	    pAS_Info->f_LO1_Step *
@@ -575,7 +571,10 @@ static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 	if (pAS_Info->nZones == 0)
 		return f_Desired;
 
-	/*  f_Center needs to be an integer multiple of f_Step away from f_Desired */
+	/*
+	 *  f_Center needs to be an integer multiple of f_Step away
+	 *  from f_Desired
+	 */
 	if (pAS_Info->f_if1_Center > f_Desired)
 		f_Center =
 		    f_Desired +
@@ -589,7 +588,10 @@ static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 		    ((f_Desired - pAS_Info->f_if1_Center +
 		      f_Step / 2) / f_Step);
 
-	/*  Take MT_ExclZones, center around f_Center and change the resolution to f_Step  */
+	/*
+	 * Take MT_ExclZones, center around f_Center and change the
+	 * resolution to f_Step
+	 */
 	while (pNode != NULL) {
 		/*  floor function  */
 		tmpMin =
@@ -618,13 +620,13 @@ static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 	}
 
 	/*
-	 **  If the desired is okay, return with it
+	 *  If the desired is okay, return with it
 	 */
 	if (bDesiredExcluded == 0)
 		return f_Desired;
 
 	/*
-	 **  If the desired is excluded and the center is okay, return with it
+	 *  If the desired is excluded and the center is okay, return with it
 	 */
 	if (bZeroExcluded == 0)
 		return f_Center;
@@ -644,30 +646,14 @@ static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 	return f_Center + (bestDiff * f_Step);
 }
 
-/****************************************************************************
-**
-**  Name: gcd
-**
-**  Description:    Uses Euclid's algorithm
-**
-**  Parameters:     u, v     - unsigned values whose GCD is desired.
-**
-**  Global:         None
-**
-**  Returns:        greatest common divisor of u and v, if either value
-**                  is 0, the other value is returned as the result.
-**
-**  Dependencies:   None.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   N/A   06-01-2004    JWS    Original
-**   N/A   08-03-2004    DAD    Changed to Euclid's since it can handle
-**                              unsigned numbers.
-**
-****************************************************************************/
+/**
+ * gcd() - Uses Euclid's algorithm
+ *
+ * @u, @v:	Unsigned values whose GCD is desired.
+ *
+ * Returns THE greatest common divisor of u and v, if either value is 0,
+ * the other value is returned as the result.
+ */
 static u32 MT2063_gcd(u32 u, u32 v)
 {
 	u32 r;
@@ -681,39 +667,25 @@ static u32 MT2063_gcd(u32 u, u32 v)
 	return u;
 }
 
-/****************************************************************************
-**
-**  Name: IsSpurInBand
-**
-**  Description:    Checks to see if a spur will be present within the IF's
-**                  bandwidth. (fIFOut +/- fIFBW, -fIFOut +/- fIFBW)
-**
-**                    ma   mb                                     mc   md
-**                  <--+-+-+-------------------+-------------------+-+-+-->
-**                     |   ^                   0                   ^   |
-**                     ^   b=-fIFOut+fIFBW/2      -b=+fIFOut-fIFBW/2   ^
-**                     a=-fIFOut-fIFBW/2              -a=+fIFOut+fIFBW/2
-**
-**                  Note that some equations are doubled to prevent round-off
-**                  problems when calculating fIFBW/2
-**
-**  Parameters:     pAS_Info - Avoid Spurs information block
-**                  fm       - If spur, amount f_IF1 has to move negative
-**                  fp       - If spur, amount f_IF1 has to move positive
-**
-**  Global:         None
-**
-**  Returns:        1 if an LO spur would be present, otherwise 0.
-**
-**  Dependencies:   None.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   N/A   11-28-2002    DAD    Implemented algorithm from applied patent
-**
-****************************************************************************/
+/**
+ * IsSpurInBand() - Checks to see if a spur will be present within the IF's
+ *                  bandwidth. (fIFOut +/- fIFBW, -fIFOut +/- fIFBW)
+ *
+ *                    ma   mb                                     mc   md
+ *                  <--+-+-+-------------------+-------------------+-+-+-->
+ *                     |   ^                   0                   ^   |
+ *                     ^   b=-fIFOut+fIFBW/2      -b=+fIFOut-fIFBW/2   ^
+ *                     a=-fIFOut-fIFBW/2              -a=+fIFOut+fIFBW/2
+ *
+ *                  Note that some equations are doubled to prevent round-off
+ *                  problems when calculating fIFBW/2
+ *
+ * @pAS_Info:	Avoid Spurs information block
+ * @fm:		If spur, amount f_IF1 has to move negative
+ * @fp:		If spur, amount f_IF1 has to move positive
+ *
+ *  Returns 1 if an LO spur would be present, otherwise 0.
+ */
 static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 			u32 *fm, u32 * fp)
 {
@@ -814,22 +786,12 @@ static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 	return 0;
 }
 
-/*****************************************************************************
-**
-**  Name: MT_AvoidSpurs
-**
-**  Description:    Main entry point to avoid spurs.
-**                  Checks for existing spurs in present LO1, LO2 freqs
-**                  and if present, chooses spur-free LO1, LO2 combination
-**                  that tunes the same input/output frequencies.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   096   04-06-2005    DAD    Ver 1.11: Fix divide by 0 error if maxH==0.
-**
-*****************************************************************************/
+/*
+ * MT_AvoidSpurs() - Main entry point to avoid spurs.
+ *                   Checks for existing spurs in present LO1, LO2 freqs
+ *                   and if present, chooses spur-free LO1, LO2 combination
+ *                   that tunes the same input/output frequencies.
+ */
 static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 	u32 status = 0;
@@ -841,15 +803,15 @@ static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
 		return 0;
 
 	/*
-	 **  Avoid LO Generated Spurs
-	 **
-	 **  Make sure that have no LO-related spurs within the IF output
-	 **  bandwidth.
-	 **
-	 **  If there is an LO spur in this band, start at the current IF1 frequency
-	 **  and work out until we find a spur-free frequency or run up against the
-	 **  1st IF SAW band edge.  Use temporary copies of fLO1 and fLO2 so that they
-	 **  will be unchanged if a spur-free setting is not found.
+	 * Avoid LO Generated Spurs
+	 *
+	 * Make sure that have no LO-related spurs within the IF output
+	 * bandwidth.
+	 *
+	 * If there is an LO spur in this band, start at the current IF1 frequency
+	 * and work out until we find a spur-free frequency or run up against the
+	 * 1st IF SAW band edge.  Use temporary copies of fLO1 and fLO2 so that they
+	 * will be unchanged if a spur-free setting is not found.
 	 */
 	pAS_Info->bSpurPresent = IsSpurInBand(pAS_Info, &fm, &fp);
 	if (pAS_Info->bSpurPresent) {
@@ -887,15 +849,15 @@ static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
 
 			pAS_Info->bSpurPresent = IsSpurInBand(pAS_Info, &fm, &fp);
 		/*
-		 **  Continue while the new 1st IF is still within the 1st IF bandwidth
-		 **  and there is a spur in the band (again)
+		 *  Continue while the new 1st IF is still within the 1st IF bandwidth
+		 *  and there is a spur in the band (again)
 		 */
 		} while ((2 * delta_IF1 + pAS_Info->f_out_bw <= pAS_Info->f_if1_bw) && pAS_Info->bSpurPresent);
 
 		/*
-		 ** Use the LO-spur free values found.  If the search went all the way to
-		 ** the 1st IF band edge and always found spurs, just leave the original
-		 ** choice.  It's as "good" as any other.
+		 * Use the LO-spur free values found.  If the search went all
+		 * the way to the 1st IF band edge and always found spurs, just
+		 * leave the original choice.  It's as "good" as any other.
 		 */
 		if (pAS_Info->bSpurPresent == 1) {
 			status |= MT2063_SPUR_PRESENT_ERR;
@@ -912,7 +874,6 @@ static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
 	return status;
 }
 
-
 /*
  * Constants used by the tuning algorithm
  */
@@ -936,35 +897,29 @@ static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
 #define MT2063_MAX_UPC_FREQ    (2750000000UL)	/* Maximum LO1 frequency (in Hz) */
 
 /*
-**  Define the supported Part/Rev codes for the MT2063
-*/
+ *  Define the supported Part/Rev codes for the MT2063
+ */
 #define MT2063_B0       (0x9B)
 #define MT2063_B1       (0x9C)
 #define MT2063_B2       (0x9D)
 #define MT2063_B3       (0x9E)
 
 /*
-**  Constants for setting receiver modes.
-**  (6 modes defined at this time, enumerated by MT2063_RCVR_MODES)
-**  (DNC1GC & DNC2GC are the values, which are used, when the specific
-**   DNC Output is selected, the other is always off)
-**
-**   If PAL-L or L' is received, set:
-**       MT2063_SetParam(hMT2063,MT2063_TAGC,1);
-**
-**                --------------+----------------------------------------------
-**                 Mode 0 :     | MT2063_CABLE_QAM
-**                 Mode 1 :     | MT2063_CABLE_ANALOG
-**                 Mode 2 :     | MT2063_OFFAIR_COFDM
-**                 Mode 3 :     | MT2063_OFFAIR_COFDM_SAWLESS
-**                 Mode 4 :     | MT2063_OFFAIR_ANALOG
-**                 Mode 5 :     | MT2063_OFFAIR_8VSB
-**                --------------+----+----+----+----+-----+-----+--------------
-**                 Mode         |  0 |  1 |  2 |  3 |  4  |  5  |
-**                --------------+----+----+----+----+-----+-----+
-**
-**
-*/
+ *  Constants for setting receiver modes.
+ *  (6 modes defined at this time, enumerated by MT2063_RCVR_MODES)
+ *  (DNC1GC & DNC2GC are the values, which are used, when the specific
+ *   DNC Output is selected, the other is always off)
+ *
+ *                enum MT2063_RCVR_MODES
+ * -------------+----------------------------------------------
+ * Mode 0 :     | MT2063_CABLE_QAM
+ * Mode 1 :     | MT2063_CABLE_ANALOG
+ * Mode 2 :     | MT2063_OFFAIR_COFDM
+ * Mode 3 :     | MT2063_OFFAIR_COFDM_SAWLESS
+ * Mode 4 :     | MT2063_OFFAIR_ANALOG
+ * Mode 5 :     | MT2063_OFFAIR_8VSB
+ * --------------+----------------------------------------------
+ */
 static const u8 RFAGCEN[] = { 0, 0, 0, 0, 0, 0 };
 static const u8 LNARIN[] = { 0, 0, 3, 3, 3, 3 };
 static const u8 FIFFQEN[] = { 1, 1, 1, 1, 1, 1 };
@@ -1053,117 +1008,109 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 	/* selects, which DNC output is used */
 	switch (nValue) {
 	case MT2063_DNC_NONE:
-		{
-			val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
-			if (state->reg[MT2063_REG_DNC_GAIN] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_DNC_GAIN,
-						  val);
+		val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
+		if (state->reg[MT2063_REG_DNC_GAIN] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_DNC_GAIN,
+					  val);
 
-			val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
-			if (state->reg[MT2063_REG_VGA_GAIN] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_VGA_GAIN,
-						  val);
+		val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
+		if (state->reg[MT2063_REG_VGA_GAIN] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_VGA_GAIN,
+					  val);
 
-			val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
-			if (state->reg[MT2063_REG_RSVD_20] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_RSVD_20,
-						  val);
+		val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
+		if (state->reg[MT2063_REG_RSVD_20] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_RSVD_20,
+					  val);
 
-			break;
-		}
+		break;
 	case MT2063_DNC_1:
-		{
-			val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
-			if (state->reg[MT2063_REG_DNC_GAIN] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_DNC_GAIN,
-						  val);
+		val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
+		if (state->reg[MT2063_REG_DNC_GAIN] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_DNC_GAIN,
+					  val);
 
-			val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
-			if (state->reg[MT2063_REG_VGA_GAIN] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_VGA_GAIN,
-						  val);
+		val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
+		if (state->reg[MT2063_REG_VGA_GAIN] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_VGA_GAIN,
+					  val);
 
-			val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
-			if (state->reg[MT2063_REG_RSVD_20] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_RSVD_20,
-						  val);
+		val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
+		if (state->reg[MT2063_REG_RSVD_20] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_RSVD_20,
+					  val);
 
-			break;
-		}
+		break;
 	case MT2063_DNC_2:
-		{
-			val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
-			if (state->reg[MT2063_REG_DNC_GAIN] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_DNC_GAIN,
-						  val);
+		val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
+		if (state->reg[MT2063_REG_DNC_GAIN] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_DNC_GAIN,
+					  val);
 
-			val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
-			if (state->reg[MT2063_REG_VGA_GAIN] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_VGA_GAIN,
-						  val);
+		val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
+		if (state->reg[MT2063_REG_VGA_GAIN] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_VGA_GAIN,
+					  val);
 
-			val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
-			if (state->reg[MT2063_REG_RSVD_20] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_RSVD_20,
-						  val);
+		val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
+		if (state->reg[MT2063_REG_RSVD_20] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_RSVD_20,
+					  val);
 
-			break;
-		}
+		break;
 	case MT2063_DNC_BOTH:
-		{
-			val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
-			if (state->reg[MT2063_REG_DNC_GAIN] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_DNC_GAIN,
-						  val);
+		val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
+		if (state->reg[MT2063_REG_DNC_GAIN] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_DNC_GAIN,
+					  val);
 
-			val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
-			if (state->reg[MT2063_REG_VGA_GAIN] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_VGA_GAIN,
-						  val);
+		val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
+		if (state->reg[MT2063_REG_VGA_GAIN] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_VGA_GAIN,
+					  val);
 
-			val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
-			if (state->reg[MT2063_REG_RSVD_20] !=
-			    val)
-				status |=
-				    mt2063_setreg(state,
-						  MT2063_REG_RSVD_20,
-						  val);
+		val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
+		if (state->reg[MT2063_REG_RSVD_20] !=
+		    val)
+			status |=
+			    mt2063_setreg(state,
+					  MT2063_REG_RSVD_20,
+					  val);
 
-			break;
-		}
+		break;
 	default:
 		break;
 	}
@@ -1171,89 +1118,47 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 	return status;
 }
 
-/******************************************************************************
-**
-**  Name: MT2063_SetReceiverMode
-**
-**  Description:    Set the MT2063 receiver mode
-**
-**   --------------+----------------------------------------------
-**    Mode 0 :     | MT2063_CABLE_QAM
-**    Mode 1 :     | MT2063_CABLE_ANALOG
-**    Mode 2 :     | MT2063_OFFAIR_COFDM
-**    Mode 3 :     | MT2063_OFFAIR_COFDM_SAWLESS
-**    Mode 4 :     | MT2063_OFFAIR_ANALOG
-**    Mode 5 :     | MT2063_OFFAIR_8VSB
-**   --------------+----+----+----+----+-----+--------------------
-**  (DNC1GC & DNC2GC are the values, which are used, when the specific
-**   DNC Output is selected, the other is always off)
-**
-**                |<----------   Mode  -------------->|
-**    Reg Field   |  0  |  1  |  2  |  3  |  4  |  5  |
-**    ------------+-----+-----+-----+-----+-----+-----+
-**    RFAGCen     | OFF | OFF | OFF | OFF | OFF | OFF
-**    LNARin      |   0 |   0 |   3 |   3 |  3  |  3
-**    FIFFQen     |   1 |   1 |   1 |   1 |  1  |  1
-**    FIFFq       |   0 |   0 |   0 |   0 |  0  |  0
-**    DNC1gc      |   0 |   0 |   0 |   0 |  0  |  0
-**    DNC2gc      |   0 |   0 |   0 |   0 |  0  |  0
-**    GCU Auto    |   1 |   1 |   1 |   1 |  1  |  1
-**    LNA max Atn |  31 |  31 |  31 |  31 | 31  | 31
-**    LNA Target  |  44 |  43 |  43 |  43 | 43  | 43
-**    ign  RF Ovl |   0 |   0 |   0 |   0 |  0  |  0
-**    RF  max Atn |  31 |  31 |  31 |  31 | 31  | 31
-**    PD1 Target  |  36 |  36 |  38 |  38 | 36  | 38
-**    ign FIF Ovl |   0 |   0 |   0 |   0 |  0  |  0
-**    FIF max Atn |   5 |   5 |   5 |   5 |  5  |  5
-**    PD2 Target  |  40 |  33 |  42 |  42 | 33  | 42
-**
-**
-**  Parameters:     state       - ptr to mt2063_state structure
-**                  Mode        - desired reciever mode
-**
-**  Usage:          status = MT2063_SetReceiverMode(hMT2063, Mode);
-**
-**  Returns:        status:
-**                      MT_OK             - No errors
-**                      MT_COMM_ERR       - Serial bus communications error
-**
-**  Dependencies:   mt2063_setreg - Write a byte of data to a HW register.
-**                  Assumes that the tuner cache is valid.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**   N/A   01-10-2007    PINZ   Added additional GCU Settings, FIFF Calib will be triggered
-**   155   10-01-2007    DAD    Ver 1.06: Add receiver mode for SECAM positive
-**                                        modulation
-**                                        (MT2063_ANALOG_TV_POS_NO_RFAGC_MODE)
-**   N/A   10-22-2007    PINZ   Ver 1.07: Changed some Registers at init to have
-**                                        the same settings as with MT Launcher
-**   N/A   10-30-2007    PINZ             Add SetParam VGAGC & VGAOI
-**                                        Add SetParam DNC_OUTPUT_ENABLE
-**                                        Removed VGAGC from receiver mode,
-**                                        default now 1
-**   N/A   10-31-2007    PINZ   Ver 1.08: Add SetParam TAGC, removed from rcvr-mode
-**                                        Add SetParam AMPGC, removed from rcvr-mode
-**                                        Corrected names of GCU values
-**                                        reorganized receiver modes, removed,
-**                                        (MT2063_ANALOG_TV_POS_NO_RFAGC_MODE)
-**                                        Actualized Receiver-Mode values
-**   N/A   11-12-2007    PINZ   Ver 1.09: Actualized Receiver-Mode values
-**   N/A   11-27-2007    PINZ             Improved buffered writing
-**         01-03-2008    PINZ   Ver 1.10: Added a trigger of BYPATNUP for
-**                                        correct wakeup of the LNA after shutdown
-**                                        Set AFCsd = 1 as default
-**                                        Changed CAP1sel default
-**         01-14-2008    PINZ   Ver 1.11: Updated gain settings
-**         04-18-2008    PINZ   Ver 1.15: Add SetParam LNARIN & PDxTGT
-**                                        Split SetParam up to ACLNA / ACLNA_MAX
-**                                        removed ACLNA_INRC/DECR (+RF & FIF)
-**                                        removed GCUAUTO / BYPATNDN/UP
-**
-******************************************************************************/
+/*
+ * MT2063_SetReceiverMode() - Set the MT2063 receiver mode
+**
+ *                 enum MT2063_RCVR_MODES
+ * --------------+----------------------------------------------
+ *  Mode 0 :     | MT2063_CABLE_QAM
+ *  Mode 1 :     | MT2063_CABLE_ANALOG
+ *  Mode 2 :     | MT2063_OFFAIR_COFDM
+ *  Mode 3 :     | MT2063_OFFAIR_COFDM_SAWLESS
+ *  Mode 4 :     | MT2063_OFFAIR_ANALOG
+ *  Mode 5 :     | MT2063_OFFAIR_8VSB
+ * --------------+----------------------------------------------
+ *  (DNC1GC & DNC2GC are the values, which are used, when the specific
+ *   DNC Output is selected, the other is always off)
+ *
+ *                |<----------   Mode  -------------->|
+ *    Reg Field   |  0  |  1  |  2  |  3  |  4  |  5  |
+ *    ------------+-----+-----+-----+-----+-----+-----+
+ *    RFAGCen     | OFF | OFF | OFF | OFF | OFF | OFF
+ *    LNARin      |   0 |   0 |   3 |   3 |  3  |  3
+ *    FIFFQen     |   1 |   1 |   1 |   1 |  1  |  1
+ *    FIFFq       |   0 |   0 |   0 |   0 |  0  |  0
+ *    DNC1gc      |   0 |   0 |   0 |   0 |  0  |  0
+ *    DNC2gc      |   0 |   0 |   0 |   0 |  0  |  0
+ *    GCU Auto    |   1 |   1 |   1 |   1 |  1  |  1
+ *    LNA max Atn |  31 |  31 |  31 |  31 | 31  | 31
+ *    LNA Target  |  44 |  43 |  43 |  43 | 43  | 43
+ *    ign  RF Ovl |   0 |   0 |   0 |   0 |  0  |  0
+ *    RF  max Atn |  31 |  31 |  31 |  31 | 31  | 31
+ *    PD1 Target  |  36 |  36 |  38 |  38 | 36  | 38
+ *    ign FIF Ovl |   0 |   0 |   0 |   0 |  0  |  0
+ *    FIF max Atn |   5 |   5 |   5 |   5 |  5  |  5
+ *    PD2 Target  |  40 |  33 |  42 |  42 | 33  | 42
+ *
+ *
+ * @state:	ptr to mt2063_state structure
+ * @Mode:	desired reciever mode
+ *
+ * Note: Register cache must be valid for it to work
+ */
+
 static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 				  enum MT2063_RCVR_MODES Mode)
 {
@@ -1382,37 +1287,19 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 	return status;
 }
 
-/****************************************************************************
-**
-**  Name: MT2063_ClearPowerMaskBits
-**
-**  Description:    Clears the power-down mask bits for various sections of
-**                  the MT2063
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**                  Bits        - Mask bits to be cleared.
-**
-**                  See definition of MT2063_Mask_Bits type for description
-**                  of each of the power bits.
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_COMM_ERR      - Serial bus communications error
-**
-**  Dependencies:   USERS MUST CALL MT2063_Open() FIRST!
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-****************************************************************************/
+/*
+ * MT2063_ClearPowerMaskBits () - Clears the power-down mask bits for various
+ *				  sections of the MT2063
+ *
+ * @Bits:		Mask bits to be cleared.
+ *
+ * See definition of MT2063_Mask_Bits type for description
+ * of each of the power bits.
+ */
 static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state,
 				     enum MT2063_Mask_Bits Bits)
 {
-	u32 status = 0;	/* Status to be returned        */
+	u32 status = 0;
 
 	Bits = (enum MT2063_Mask_Bits)(Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
 	if ((Bits & 0xFF00) != 0) {
@@ -1433,42 +1320,19 @@ static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state,
 	return status;
 }
 
-/****************************************************************************
-**
-**  Name: MT2063_SoftwareShutdown
-**
-**  Description:    Enables or disables software shutdown function.  When
-**                  Shutdown==1, any section whose power mask is set will be
-**                  shutdown.
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**                  Shutdown    - 1 = shutdown the masked sections, otherwise
-**                                power all sections on
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_COMM_ERR      - Serial bus communications error
-**
-**  Dependencies:   USERS MUST CALL MT2063_Open() FIRST!
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**         01-03-2008    PINZ   Ver 1.xx: Added a trigger of BYPATNUP for
-**                              correct wakeup of the LNA
-**
-****************************************************************************/
+/*
+ * MT2063_SoftwareShutdown() - Enables or disables software shutdown function.
+ *			       When Shutdown is 1, any section whose power
+ *			       mask is set will be shutdown.
+ */
 static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
 {
-	u32 status;	/* Status to be returned        */
+	u32 status;
 
 	if (Shutdown == 1)
-		state->reg[MT2063_REG_PWR_1] |= 0x04;	/* Turn the bit on */
+		state->reg[MT2063_REG_PWR_1] |= 0x04;
 	else
-		state->reg[MT2063_REG_PWR_1] &= ~0x04;	/* Turn off the bit */
+		state->reg[MT2063_REG_PWR_1] &= ~0x04;
 
 	status = mt2063_write(state,
 			    MT2063_REG_PWR_1,
@@ -1500,36 +1364,24 @@ static u32 MT2063_Round_fLO(u32 f_LO, u32 f_LO_Step, u32 f_ref)
 	    + f_LO_Step * (((f_LO % f_ref) + (f_LO_Step / 2)) / f_LO_Step);
 }
 
-/****************************************************************************
-**
-**  Name: fLO_FractionalTerm
-**
-**  Description:    Calculates the portion contributed by FracN / denom.
-**
-**                  This function preserves maximum precision without
-**                  risk of overflow.  It accurately calculates
-**                  f_ref * num / denom to within 1 HZ with fixed math.
-**
-**  Parameters:     num       - Fractional portion of the multiplier
-**                  denom     - denominator portion of the ratio
-**                              This routine successfully handles denom values
-**                              up to and including 2^18.
-**                  f_Ref     - SRO frequency.  This calculation handles
-**                              f_ref as two separate 14-bit fields.
-**                              Therefore, a maximum value of 2^28-1
-**                              may safely be used for f_ref.  This is
-**                              the genesis of the magic number "14" and the
-**                              magic mask value of 0x03FFF.
-**
-**  Returns:        f_ref * num / denom
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-****************************************************************************/
+/**
+ * fLO_FractionalTerm() - Calculates the portion contributed by FracN / denom.
+ *                        This function preserves maximum precision without
+ *                        risk of overflow.  It accurately calculates
+ *                        f_ref * num / denom to within 1 HZ with fixed math.
+ *
+ * @num :	Fractional portion of the multiplier
+ * @denom:	denominator portion of the ratio
+ * @f_Ref:	SRO frequency.
+ *
+ * This calculation handles f_ref as two separate 14-bit fields.
+ * Therefore, a maximum value of 2^28-1 may safely be used for f_ref.
+ * This is the genesis of the magic number "14" and the magic mask value of
+ * 0x03FFF.
+ *
+ * This routine successfully handles denom values up to and including 2^18.
+ *  Returns:        f_ref * num / denom
+ */
 static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num, u32 denom)
 {
 	u32 t1 = (f_ref >> 14) * num;
@@ -1540,33 +1392,23 @@ static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num, u32 denom)
 	return (term1 << 14) + term2;
 }
 
-/****************************************************************************
-**
-**  Name: CalcLO1Mult
-**
-**  Description:    Calculates Integer divider value and the numerator
-**                  value for a FracN PLL.
-**
-**                  This function assumes that the f_LO and f_Ref are
-**                  evenly divisible by f_LO_Step.
-**
-**  Parameters:     Div       - OUTPUT: Whole number portion of the multiplier
-**                  FracN     - OUTPUT: Fractional portion of the multiplier
-**                  f_LO      - desired LO frequency.
-**                  f_LO_Step - Minimum step size for the LO (in Hz).
-**                  f_Ref     - SRO frequency.
-**                  f_Avoid   - Range of PLL frequencies to avoid near
-**                              integer multiples of f_Ref (in Hz).
-**
-**  Returns:        Recalculated LO frequency.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-****************************************************************************/
+/*
+ * CalcLO1Mult()- Calculates Integer divider value and the numerator
+ *                value for a FracN PLL.
+ *
+ *                This function assumes that the f_LO and f_Ref are
+ *                evenly divisible by f_LO_Step.
+ *
+ * @Div:	OUTPUT: Whole number portion of the multiplier
+ * @FracN:	OUTPUT: Fractional portion of the multiplier
+ * @f_LO:	desired LO frequency.
+ * @f_LO_Step:	Minimum step size for the LO (in Hz).
+ * @f_Ref:	SRO frequency.
+ * @f_Avoid:	Range of PLL frequencies to avoid near integer multiples
+ *		of f_Ref (in Hz).
+ *
+ * Returns:        Recalculated LO frequency.
+ */
 static u32 MT2063_CalcLO1Mult(u32 *Div,
 			      u32 *FracN,
 			      u32 f_LO,
@@ -1583,33 +1425,23 @@ static u32 MT2063_CalcLO1Mult(u32 *Div,
 	return (f_Ref * (*Div)) + MT2063_fLO_FractionalTerm(f_Ref, *FracN, 64);
 }
 
-/****************************************************************************
-**
-**  Name: CalcLO2Mult
-**
-**  Description:    Calculates Integer divider value and the numerator
-**                  value for a FracN PLL.
-**
-**                  This function assumes that the f_LO and f_Ref are
-**                  evenly divisible by f_LO_Step.
-**
-**  Parameters:     Div       - OUTPUT: Whole number portion of the multiplier
-**                  FracN     - OUTPUT: Fractional portion of the multiplier
-**                  f_LO      - desired LO frequency.
-**                  f_LO_Step - Minimum step size for the LO (in Hz).
-**                  f_Ref     - SRO frequency.
-**                  f_Avoid   - Range of PLL frequencies to avoid near
-**                              integer multiples of f_Ref (in Hz).
-**
-**  Returns:        Recalculated LO frequency.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-****************************************************************************/
+/**
+ * CalcLO2Mult() - Calculates Integer divider value and the numerator
+ *                 value for a FracN PLL.
+ *
+ *                  This function assumes that the f_LO and f_Ref are
+ *                  evenly divisible by f_LO_Step.
+ *
+ * @Div:	OUTPUT: Whole number portion of the multiplier
+ * @FracN:	OUTPUT: Fractional portion of the multiplier
+ * @f_LO:	desired LO frequency.
+ * @f_LO_Step:	Minimum step size for the LO (in Hz).
+ * @f_Ref:	SRO frequency.
+ * @f_Avoid:	Range of PLL frequencies to avoid near
+ *		integer multiples of f_Ref (in Hz).
+ *
+ * Returns: Recalculated LO frequency.
+ */
 static u32 MT2063_CalcLO2Mult(u32 *Div,
 			      u32 *FracN,
 			      u32 f_LO,
@@ -1627,28 +1459,15 @@ static u32 MT2063_CalcLO2Mult(u32 *Div,
 							    8191);
 }
 
-/****************************************************************************
-**
-**  Name: FindClearTuneFilter
-**
-**  Description:    Calculate the corrrect ClearTune filter to be used for
-**                  a given input frequency.
-**
-**  Parameters:     state       - ptr to tuner data structure
-**                  f_in        - RF input center frequency (in Hz).
-**
-**  Returns:        ClearTune filter number (0-31)
-**
-**  Dependencies:   MUST CALL MT2064_Open BEFORE FindClearTuneFilter!
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**         04-10-2008   PINZ    Ver 1.14: Use software-controlled ClearTune
-**                                        cross-over frequency values.
-**
-****************************************************************************/
+/*
+ * FindClearTuneFilter() - Calculate the corrrect ClearTune filter to be
+ *			   used for a given input frequency.
+ *
+ * @state:	ptr to tuner data structure
+ * @f_in:	RF input center frequency (in Hz).
+ *
+ * Returns: ClearTune filter number (0-31)
+ */
 static u32 FindClearTuneFilter(struct mt2063_state *state, u32 f_in)
 {
 	u32 RFBand;
@@ -1667,51 +1486,13 @@ static u32 FindClearTuneFilter(struct mt2063_state *state, u32 f_in)
 	return RFBand;
 }
 
-/****************************************************************************
-**
-**  Name: MT2063_Tune
-**
-**  Description:    Change the tuner's tuned frequency to RFin.
-**
-**  Parameters:     h           - Open handle to the tuner (from MT2063_Open).
-**                  f_in        - RF input center frequency (in Hz).
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_UPC_UNLOCK    - Upconverter PLL unlocked
-**                      MT_DNC_UNLOCK    - Downconverter PLL unlocked
-**                      MT_COMM_ERR      - Serial bus communications error
-**                      MT_SPUR_CNT_MASK - Count of avoided LO spurs
-**                      MT_SPUR_PRESENT  - LO spur possible in output
-**                      MT_FIN_RANGE     - Input freq out of range
-**                      MT_FOUT_RANGE    - Output freq out of range
-**                      MT_UPC_RANGE     - Upconverter freq out of range
-**                      MT_DNC_RANGE     - Downconverter freq out of range
-**
-**  Dependencies:   MUST CALL MT2063_Open BEFORE MT2063_Tune!
-**
-**                  MT_ReadSub       - Read data from the two-wire serial bus
-**                  MT_WriteSub      - Write data to the two-wire serial bus
-**                  MT_Sleep         - Delay execution for x milliseconds
-**                  MT2063_GetLocked - Checks to see if LO1 and LO2 are locked
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**         04-10-2008   PINZ    Ver 1.05: Use software-controlled ClearTune
-**                                        cross-over frequency values.
-**   175 I 16-06-2008   PINZ    Ver 1.16: Add control to avoid US DECT freqs.
-**   175 I 06-19-2008    RSK    Ver 1.17: Refactor DECT control to SpurAvoid.
-**         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
-**
-****************************************************************************/
+/*
+ * MT2063_Tune() - Change the tuner's tuned frequency to RFin.
+ */
 static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 {				/* RF input center frequency   */
 
-	u32 status = 0;	/*  status of operation             */
+	u32 status = 0;
 	u32 LO1;		/*  1st LO register value           */
 	u32 Num1;		/*  Numerator for LO1 reg. value    */
 	u32 f_IF1;		/*  1st IF requested                */
@@ -1735,7 +1516,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 		return -EINVAL;
 
 	/*
-	 **  Save original LO1 and LO2 register values
+	 * Save original LO1 and LO2 register values
 	 */
 	ofLO1 = state->AS_Data.f_LO1;
 	ofLO2 = state->AS_Data.f_LO2;
@@ -1743,7 +1524,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	ofout = state->AS_Data.f_out;
 
 	/*
-	 **  Find and set RF Band setting
+	 * Find and set RF Band setting
 	 */
 	if (state->ctfilt_sw == 1) {
 		val = (state->reg[MT2063_REG_CTUNE_CTRL] | 0x08);
@@ -1763,7 +1544,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	}
 
 	/*
-	 **  Read the FIFF Center Frequency from the tuner
+	 * Read the FIFF Center Frequency from the tuner
 	 */
 	if (status >= 0) {
 		status |=
@@ -1773,7 +1554,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 		fiffc = state->reg[MT2063_REG_FIFFC];
 	}
 	/*
-	 **  Assign in the requested values
+	 * Assign in the requested values
 	 */
 	state->AS_Data.f_in = f_in;
 	/*  Request a 1st IF such that LO1 is on a step size */
@@ -1783,8 +1564,8 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 			     state->AS_Data.f_ref) - f_in;
 
 	/*
-	 **  Calculate frequency settings.  f_IF1_FREQ + f_in is the
-	 **  desired LO1 frequency
+	 * Calculate frequency settings.  f_IF1_FREQ + f_in is the
+	 * desired LO1 frequency
 	 */
 	MT2063_ResetExclZones(&state->AS_Data);
 
@@ -1799,14 +1580,14 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 			     state->AS_Data.f_LO2_Step, state->AS_Data.f_ref);
 
 	/*
-	 ** Check for any LO spurs in the output bandwidth and adjust
-	 ** the LO settings to avoid them if needed
+	 * Check for any LO spurs in the output bandwidth and adjust
+	 * the LO settings to avoid them if needed
 	 */
 	status |= MT2063_AvoidSpurs(&state->AS_Data);
 	/*
-	 ** MT_AvoidSpurs spurs may have changed the LO1 & LO2 values.
-	 ** Recalculate the LO frequencies and the values to be placed
-	 ** in the tuning registers.
+	 * MT_AvoidSpurs spurs may have changed the LO1 & LO2 values.
+	 * Recalculate the LO frequencies and the values to be placed
+	 * in the tuning registers.
 	 */
 	state->AS_Data.f_LO1 =
 	    MT2063_CalcLO1Mult(&LO1, &Num1, state->AS_Data.f_LO1,
@@ -1819,7 +1600,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 			       state->AS_Data.f_LO2_Step, state->AS_Data.f_ref);
 
 	/*
-	 **  Check the upconverter and downconverter frequency ranges
+	 *  Check the upconverter and downconverter frequency ranges
 	 */
 	if ((state->AS_Data.f_LO1 < MT2063_MIN_UPC_FREQ)
 	    || (state->AS_Data.f_LO1 > MT2063_MAX_UPC_FREQ))
@@ -1832,19 +1613,19 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 		LO2LK = 0x40;
 
 	/*
-	 **  If we have the same LO frequencies and we're already locked,
-	 **  then skip re-programming the LO registers.
+	 *  If we have the same LO frequencies and we're already locked,
+	 *  then skip re-programming the LO registers.
 	 */
 	if ((ofLO1 != state->AS_Data.f_LO1)
 	    || (ofLO2 != state->AS_Data.f_LO2)
 	    || ((state->reg[MT2063_REG_LO_STATUS] & (LO1LK | LO2LK)) !=
 		(LO1LK | LO2LK))) {
 		/*
-		 **  Calculate the FIFFOF register value
-		 **
-		 **            IF1_Actual
-		 **  FIFFOF = ------------ - 8 * FIFFC - 4992
-		 **             f_ref/64
+		 * Calculate the FIFFOF register value
+		 *
+		 *           IF1_Actual
+		 * FIFFOF = ------------ - 8 * FIFFC - 4992
+		 *            f_ref/64
 		 */
 		fiffof =
 		    (state->AS_Data.f_LO1 -
@@ -1854,8 +1635,8 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 			fiffof = 0xFF;
 
 		/*
-		 **  Place all of the calculated values into the local tuner
-		 **  register fields.
+		 * Place all of the calculated values into the local tuner
+		 * register fields.
 		 */
 		if (status >= 0) {
 			state->reg[MT2063_REG_LO1CQ_1] = (u8) (LO1 & 0xFF);	/* DIV1q */
@@ -1866,9 +1647,9 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 			state->reg[MT2063_REG_LO2CQ_3] = (u8) (0xE0 | (Num2 & 0x000F));	/* NUM2q (lo) */
 
 			/*
-			 ** Now write out the computed register values
-			 ** IMPORTANT: There is a required order for writing
-			 **            (0x05 must follow all the others).
+			 * Now write out the computed register values
+			 * IMPORTANT: There is a required order for writing
+			 *            (0x05 must follow all the others).
 			 */
 			status |= mt2063_write(state, MT2063_REG_LO1CQ_1, &state->reg[MT2063_REG_LO1CQ_1], 5);	/* 0x01 - 0x05 */
 			if (state->tuner_id == MT2063_B0) {
@@ -1890,7 +1671,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 		}
 
 		/*
-		 **  Check for LO's locking
+		 * Check for LO's locking
 		 */
 
 		if (status < 0)
@@ -2173,7 +1954,7 @@ static int mt2063_get_status(struct dvb_frontend *fe, u32 *tuner_status)
 	if (status < 0)
 		return status;
 	if (status)
-	    *tuner_status = TUNER_STATUS_LOCKED;
+		*tuner_status = TUNER_STATUS_LOCKED;
 
 	return 0;
 }
@@ -2273,7 +2054,7 @@ static int mt2063_set_analog_params(struct dvb_frontend *fe,
 /*
  * As defined on EN 300 429, the DVB-C roll-off factor is 0.15.
  * So, the amount of the needed bandwith is given by:
- * 	Bw = Symbol_rate * (1 + 0.15)
+ *	Bw = Symbol_rate * (1 + 0.15)
  * As such, the maximum symbol rate supported by 6 MHz is given by:
  *	max_symbol_rate = 6 MHz / 1.15 = 5217391 Bauds
  */
@@ -2346,7 +2127,7 @@ static int mt2063_set_params(struct dvb_frontend *fe,
 	status = MT2063_Tune(state, (params->frequency + (pict2chanb_vsb + (ch_bw / 2))));
 
 	if (status < 0)
-	    return status;
+		return status;
 
 	state->frequency = params->frequency;
 	return 0;
@@ -2445,6 +2226,6 @@ EXPORT_SYMBOL_GPL(tuner_MT2063_ClearPowerMaskBits);
 
 MODULE_PARM_DESC(verbose, "Set Verbosity level");
 
-MODULE_AUTHOR("Henry");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
 MODULE_DESCRIPTION("MT2063 Silicon tuner");
 MODULE_LICENSE("GPL");
-- 
1.7.7.5

