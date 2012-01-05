Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282Ab2AEBBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:07 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05117nV029444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 17/47] [media] mt2063: Remove the code for more than one adjacent mt2063 tuners
Date: Wed,  4 Jan 2012 23:00:28 -0200
Message-Id: <1325725258-27934-18-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Such code is disabled via ifdef's. Also, they're ugly and rely
on some static structures. Just remove. If ever needed, the git
log can be used to recover it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  328 +---------------------------------
 1 files changed, 1 insertions(+), 327 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 93015ff..534e970 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -35,11 +35,6 @@ module_param(verbose, int, 0644);
 /*  Info: Downconverter frequency is out of range (may be reason for MT_DPC_UNLOCK) */
 #define MT2063_DNC_RANGE                    (0x08000000)
 
-#define MAX_UDATA         (4294967295)	/*  max value storable in u32   */
-
-#define MT2063_TUNER_CNT               (1)	/*  total num of MicroTuner tuners  */
-#define MT2063_I2C (0xC0)
-
 /*
  *  Data Types
  */
@@ -810,8 +805,6 @@ static int MT2063_Sleep(struct dvb_frontend *fe)
 **
 *****************************************************************************/
 
-/*  Version of this module                         */
-#define MT2063_SPUR_VERSION 10201	/*  Version 01.21 */
 
 /*  Implement ceiling, floor functions.  */
 #define ceil(n, d) (((n) < 0) ? (-((-(n))/(d))) : (n)/(d) + ((n)%(d) != 0))
@@ -824,53 +817,15 @@ struct MT2063_FIFZone_t {
 	s32 max_;
 };
 
-#if MT2063_TUNER_CNT > 1
-static struct MT2063_AvoidSpursData_t *TunerList[MT2063_TUNER_CNT];
-static u32 TunerCount = 0;
-#endif
 
 static u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
-#if MT2063_TUNER_CNT == 1
 	pAS_Info->nAS_Algorithm = 1;
 	return 0;
-#else
-	u32 index;
-
-	pAS_Info->nAS_Algorithm = 2;
-
-	/*
-	 **  Check to see if tuner is already registered
-	 */
-	for (index = 0; index < TunerCount; index++) {
-		if (TunerList[index] == pAS_Info) {
-			return 0;	/* Already here - no problem  */
-		}
-	}
-
-	/*
-	 ** Add tuner to list - if there is room.
-	 */
-	if (TunerCount < MT2063_TUNER_CNT) {
-		TunerList[TunerCount] = pAS_Info;
-		TunerCount++;
-		return 0;
-	} else
-		return -ENODEV;
-#endif
 }
 
 static void MT2063_UnRegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
-#if MT2063_TUNER_CNT > 1
-	u32 index;
-
-	for (index = 0; index < TunerCount; index++) {
-		if (TunerList[index] == pAS_Info) {
-			TunerList[index] = TunerList[--TunerCount];
-		}
-	}
-#endif
 }
 
 /*
@@ -883,10 +838,6 @@ static void MT2063_UnRegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 static void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 	u32 center;
-#if MT2063_TUNER_CNT > 1
-	u32 index;
-	struct MT2063_AvoidSpursData_t *adj;
-#endif
 
 	pAS_Info->nZones = 0;	/*  this clears the used list  */
 	pAS_Info->usedZones = NULL;	/*  reset ptr                  */
@@ -945,38 +896,6 @@ static void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info)
 		MT2063_AddExclZone(pAS_Info, 1882820000 - pAS_Info->f_in, 1884220000 - pAS_Info->f_in);	/* Ctr = 1883.52  */
 		MT2063_AddExclZone(pAS_Info, 1881092000 - pAS_Info->f_in, 1882492000 - pAS_Info->f_in);	/* Ctr = 1881.792 */
 	}
-#if MT2063_TUNER_CNT > 1
-	/*
-	 ** Iterate through all adjacent tuners and exclude frequencies related to them
-	 */
-	for (index = 0; index < TunerCount; ++index) {
-		adj = TunerList[index];
-		if (pAS_Info == adj)	/* skip over our own data, don't process it */
-			continue;
-
-		/*
-		 **  Add 1st IF exclusion zone covering adjacent tuner's LO2
-		 **  at "adjfLO2 + f_out" +/- m_MinLOSpacing
-		 */
-		if (adj->f_LO2 != 0)
-			MT2063_AddExclZone(pAS_Info,
-					   (adj->f_LO2 + pAS_Info->f_out) -
-					   pAS_Info->f_min_LO_Separation,
-					   (adj->f_LO2 + pAS_Info->f_out) +
-					   pAS_Info->f_min_LO_Separation);
-
-		/*
-		 **  Add 1st IF exclusion zone covering adjacent tuner's LO1
-		 **  at "adjfLO1 - f_in" +/- m_MinLOSpacing
-		 */
-		if (adj->f_LO1 != 0)
-			MT2063_AddExclZone(pAS_Info,
-					   (adj->f_LO1 - pAS_Info->f_in) -
-					   pAS_Info->f_min_LO_Separation,
-					   (adj->f_LO1 - pAS_Info->f_in) +
-					   pAS_Info->f_min_LO_Separation);
-	}
-#endif
 }
 
 static struct MT2063_ExclZone_t *InsertNode(struct MT2063_AvoidSpursData_t
@@ -1285,215 +1204,6 @@ static u32 MT2063_umax(u32 a, u32 b)
 	return (a >= b) ? a : b;
 }
 
-#if MT2063_TUNER_CNT > 1
-static s32 RoundAwayFromZero(s32 n, s32 d)
-{
-	return (n < 0) ? floor(n, d) : ceil(n, d);
-}
-
-/****************************************************************************
-**
-**  Name: IsSpurInAdjTunerBand
-**
-**  Description:    Checks to see if a spur will be present within the IF's
-**                  bandwidth or near the zero IF.
-**                  (fIFOut +/- fIFBW/2, -fIFOut +/- fIFBW/2)
-**                                  and
-**                  (0 +/- fZIFBW/2)
-**
-**                    ma   mb               me   mf               mc   md
-**                  <--+-+-+-----------------+-+-+-----------------+-+-+-->
-**                     |   ^                   0                   ^   |
-**                     ^   b=-fIFOut+fIFBW/2      -b=+fIFOut-fIFBW/2   ^
-**                     a=-fIFOut-fIFBW/2              -a=+fIFOut+fIFBW/2
-**
-**                  Note that some equations are doubled to prevent round-off
-**                  problems when calculating fIFBW/2
-**
-**                  The spur frequencies are computed as:
-**
-**                     fSpur = n * f1 - m * f2 - fOffset
-**
-**  Parameters:     f1      - The 1st local oscillator (LO) frequency
-**                            of the tuner whose output we are examining
-**                  f2      - The 1st local oscillator (LO) frequency
-**                            of the adjacent tuner
-**                  fOffset - The 2nd local oscillator of the tuner whose
-**                            output we are examining
-**                  fIFOut  - Output IF center frequency
-**                  fIFBW   - Output IF Bandwidth
-**                  nMaxH   - max # of LO harmonics to search
-**                  fp      - If spur, positive distance to spur-free band edge (returned)
-**                  fm      - If spur, negative distance to spur-free band edge (returned)
-**
-**  Returns:        1 if an LO spur would be present, otherwise 0.
-**
-**  Dependencies:   None.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   N/A   01-21-2005    JWS    Original, adapted from MT_DoubleConversion.
-**   115   03-23-2007    DAD    Fix declaration of spur due to truncation
-**                              errors.
-**   137   06-18-2007    DAD    Ver 1.16: Fix possible divide-by-0 error for
-**                              multi-tuners that have
-**                              (delta IF1) > (f_out-f_outbw/2).
-**   177 S 02-26-2008    RSK    Ver 1.18: Corrected calculation using LO1 > MAX/2
-**                              Type casts added to preserve correct sign.
-**
-****************************************************************************/
-static u32 IsSpurInAdjTunerBand(u32 bIsMyOutput,
-				    u32 f1,
-				    u32 f2,
-				    u32 fOffset,
-				    u32 fIFOut,
-				    u32 fIFBW,
-				    u32 fZIFBW,
-				    u32 nMaxH, u32 * fp, u32 * fm)
-{
-	u32 bSpurFound = 0;
-
-	const u32 fHalf_IFBW = fIFBW / 2;
-	const u32 fHalf_ZIFBW = fZIFBW / 2;
-
-	/* Calculate a scale factor for all frequencies, so that our
-	   calculations all stay within 31 bits */
-	const u32 f_Scale =
-	    ((f1 +
-	      (fOffset + fIFOut +
-	       fHalf_IFBW) / nMaxH) / (MAX_UDATA / 2 / nMaxH)) + 1;
-
-	/*
-	 **  After this scaling, _f1, _f2, and _f3 are guaranteed to fit into
-	 **  signed data types (smaller than MAX_UDATA/2)
-	 */
-	const s32 _f1 = (s32) (f1 / f_Scale);
-	const s32 _f2 = (s32) (f2 / f_Scale);
-	const s32 _f3 = (s32) (fOffset / f_Scale);
-
-	const s32 c = (s32) (fIFOut - fHalf_IFBW) / (s32) f_Scale;
-	const s32 d = (s32) ((fIFOut + fHalf_IFBW) / f_Scale);
-	const s32 f = (s32) (fHalf_ZIFBW / f_Scale);
-
-	s32 ma, mb, mc, md, me, mf;
-
-	s32 fp_ = 0;
-	s32 fm_ = 0;
-	s32 n;
-
-	/*
-	 **  If the other tuner does not have an LO frequency defined,
-	 **  assume that we cannot interfere with it
-	 */
-	if (f2 == 0)
-		return 0;
-
-	/* Check out all multiples of f1 from -nMaxH to +nMaxH */
-	for (n = -(s32) nMaxH; n <= (s32) nMaxH; ++n) {
-		const s32 nf1 = n * _f1;
-		md = (_f3 + d - nf1) / _f2;
-
-		/* If # f2 harmonics > nMaxH, then no spurs present */
-		if (md <= -(s32) nMaxH)
-			break;
-
-		ma = (_f3 - d - nf1) / _f2;
-		if ((ma == md) || (ma >= (s32) (nMaxH)))
-			continue;
-
-		mc = (_f3 + c - nf1) / _f2;
-		if (mc != md) {
-			const s32 m = (n < 0) ? md : mc;
-			const s32 fspur = (nf1 + m * _f2 - _f3);
-			const s32 den = (bIsMyOutput ? n - 1 : n);
-			if (den == 0) {
-				fp_ = (d - fspur) * f_Scale;
-				fm_ = (fspur - c) * f_Scale;
-			} else {
-				fp_ =
-				    (s32) RoundAwayFromZero((d - fspur) *
-								f_Scale, den);
-				fm_ =
-				    (s32) RoundAwayFromZero((fspur - c) *
-								f_Scale, den);
-			}
-			if (((u32) abs(fm_) >= f_Scale)
-			    && ((u32) abs(fp_) >= f_Scale)) {
-				bSpurFound = 1;
-				break;
-			}
-		}
-
-		/* Location of Zero-IF-spur to be checked */
-		mf = (_f3 + f - nf1) / _f2;
-		me = (_f3 - f - nf1) / _f2;
-		if (me != mf) {
-			const s32 m = (n < 0) ? mf : me;
-			const s32 fspur = (nf1 + m * _f2 - _f3);
-			const s32 den = (bIsMyOutput ? n - 1 : n);
-			if (den == 0) {
-				fp_ = (d - fspur) * f_Scale;
-				fm_ = (fspur - c) * f_Scale;
-			} else {
-				fp_ =
-				    (s32) RoundAwayFromZero((f - fspur) *
-								f_Scale, den);
-				fm_ =
-				    (s32) RoundAwayFromZero((fspur + f) *
-								f_Scale, den);
-			}
-			if (((u32) abs(fm_) >= f_Scale)
-			    && ((u32) abs(fp_) >= f_Scale)) {
-				bSpurFound = 1;
-				break;
-			}
-		}
-
-		mb = (_f3 - c - nf1) / _f2;
-		if (ma != mb) {
-			const s32 m = (n < 0) ? mb : ma;
-			const s32 fspur = (nf1 + m * _f2 - _f3);
-			const s32 den = (bIsMyOutput ? n - 1 : n);
-			if (den == 0) {
-				fp_ = (d - fspur) * f_Scale;
-				fm_ = (fspur - c) * f_Scale;
-			} else {
-				fp_ =
-				    (s32) RoundAwayFromZero((-c - fspur) *
-								f_Scale, den);
-				fm_ =
-				    (s32) RoundAwayFromZero((fspur + d) *
-								f_Scale, den);
-			}
-			if (((u32) abs(fm_) >= f_Scale)
-			    && ((u32) abs(fp_) >= f_Scale)) {
-				bSpurFound = 1;
-				break;
-			}
-		}
-	}
-
-	/*
-	 **  Verify that fm & fp are both positive
-	 **  Add one to ensure next 1st IF choice is not right on the edge
-	 */
-	if (fp_ < 0) {
-		*fp = -fm_ + 1;
-		*fm = -fp_ + 1;
-	} else if (fp_ > 0) {
-		*fp = fp_ + 1;
-		*fm = fm_ + 1;
-	} else {
-		*fp = 1;
-		*fm = abs(fm_) + 1;
-	}
-
-	return bSpurFound;
-}
-#endif
-
 /****************************************************************************
 **
 **  Name: IsSpurInBand
@@ -1539,16 +1249,11 @@ static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 	const u32 d = pAS_Info->f_out + pAS_Info->f_out_bw / 2;
 	const u32 c = d - pAS_Info->f_out_bw;
 	const u32 f = pAS_Info->f_zif_bw / 2;
-	const u32 f_Scale = (f_LO1 / (MAX_UDATA / 2 / pAS_Info->maxH1)) + 1;
+	const u32 f_Scale = (f_LO1 / (UINT_MAX / 2 / pAS_Info->maxH1)) + 1;
 	s32 f_nsLO1, f_nsLO2;
 	s32 f_Spur;
 	u32 ma, mb, mc, md, me, mf;
 	u32 lo_gcd, gd_Scale, gc_Scale, gf_Scale, hgds, hgfs, hgcs;
-#if MT2063_TUNER_CNT > 1
-	u32 index;
-
-	struct MT2063_AvoidSpursData_t *adj;
-#endif
 	*fm = 0;
 
 	/*
@@ -1628,37 +1333,6 @@ static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 		}
 	}
 
-#if MT2063_TUNER_CNT > 1
-	/*  If no spur found, see if there are more tuners on the same board  */
-	for (index = 0; index < TunerCount; ++index) {
-		adj = TunerList[index];
-		if (pAS_Info == adj)	/* skip over our own data, don't process it */
-			continue;
-
-		/*  Look for LO-related spurs from the adjacent tuner generated into my IF output  */
-		if (IsSpurInAdjTunerBand(1,	/*  check my IF output                     */
-					 pAS_Info->f_LO1,	/*  my fLO1                                */
-					 adj->f_LO1,	/*  the other tuner's fLO1                 */
-					 pAS_Info->f_LO2,	/*  my fLO2                                */
-					 pAS_Info->f_out,	/*  my fOut                                */
-					 pAS_Info->f_out_bw,	/*  my output IF bandwidth                 */
-					 pAS_Info->f_zif_bw,	/*  my Zero-IF bandwidth                   */
-					 pAS_Info->maxH2, fp,	/*  minimum amount to move LO's positive   */
-					 fm))	/*  miminum amount to move LO's negative   */
-			return 1;
-		/*  Look for LO-related spurs from my tuner generated into the adjacent tuner's IF output  */
-		if (IsSpurInAdjTunerBand(0,	/*  check his IF output                    */
-					 pAS_Info->f_LO1,	/*  my fLO1                                */
-					 adj->f_LO1,	/*  the other tuner's fLO1                 */
-					 adj->f_LO2,	/*  the other tuner's fLO2                 */
-					 adj->f_out,	/*  the other tuner's fOut                 */
-					 adj->f_out_bw,	/*  the other tuner's output IF bandwidth  */
-					 pAS_Info->f_zif_bw,	/*  the other tuner's Zero-IF bandwidth    */
-					 adj->maxH2, fp,	/*  minimum amount to move LO's positive   */
-					 fm))	/*  miminum amount to move LO's negative   */
-			return 1;
-	}
-#endif
 	/*  No spurs found  */
 	return 0;
 }
-- 
1.7.7.5

