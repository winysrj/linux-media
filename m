Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab2AEBBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:10 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05119lp029462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/47] [media] mt2063: Use standard Linux types, instead of redefining them
Date: Wed,  4 Jan 2012 23:00:17 -0200
Message-Id: <1325725258-27934-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  666 +++++++++++++++++-----------------
 drivers/media/common/tuners/mt2063.h |  158 ++++-----
 2 files changed, 406 insertions(+), 418 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index cd3b206..c8f0bfa 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -16,8 +16,8 @@ module_param(verbose, int, 0644);
 /*****************/
 /* From drivers/media/common/tuners/mt2063_cfg.h */
 
-static unsigned int mt2063_setTune(struct dvb_frontend *fe, UData_t f_in,
-				   UData_t bw_in,
+static unsigned int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
+				   u32 bw_in,
 				   enum MTTune_atv_standard tv_type)
 {
 	//return (int)MT_Tune_atv(h, f_in, bw_in, tv_type);
@@ -233,11 +233,11 @@ static int mt2063_read_regs(struct mt2063_state *state, u8 reg1, u8 * b, u8 len)
 **   N/A   03-25-2004    DAD    Original
 **
 *****************************************************************************/
-UData_t MT2063_WriteSub(Handle_t hUserData,
-			UData_t addr,
-			U8Data subAddress, U8Data * pData, UData_t cnt)
+u32 MT2063_WriteSub(void *hUserData,
+			u32 addr,
+			u8 subAddress, u8 * pData, u32 cnt)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct dvb_frontend *fe = hUserData;
 	struct mt2063_state *state = fe->tuner_priv;
 	/*
@@ -300,9 +300,9 @@ UData_t MT2063_WriteSub(Handle_t hUserData,
 **   N/A   03-25-2004    DAD    Original
 **
 *****************************************************************************/
-UData_t MT2063_ReadSub(Handle_t hUserData,
-		       UData_t addr,
-		       U8Data subAddress, U8Data * pData, UData_t cnt)
+u32 MT2063_ReadSub(void *hUserData,
+		       u32 addr,
+		       u8 subAddress, u8 * pData, u32 cnt)
 {
 	/*
 	 **  ToDo:  Add code here to implement a serial-bus read
@@ -310,10 +310,10 @@ UData_t MT2063_ReadSub(Handle_t hUserData,
 	 **         return MT_OK.
 	 */
 /*  return status;  */
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct dvb_frontend *fe = hUserData;
 	struct mt2063_state *state = fe->tuner_priv;
-	UData_t i = 0;
+	u32 i = 0;
 //#if !TUNER_CONTROL_BY_DRXK_DRIVER
 	fe->ops.i2c_gate_ctrl(fe, 1);	//I2C bypass drxk3926 close i2c bridge
 //#endif
@@ -355,7 +355,7 @@ UData_t MT2063_ReadSub(Handle_t hUserData,
 **   N/A   03-25-2004    DAD    Original
 **
 *****************************************************************************/
-void MT2063_Sleep(Handle_t hUserData, UData_t nMinDelayTime)
+void MT2063_Sleep(void *hUserData, u32 nMinDelayTime)
 {
 	/*
 	 **  ToDo:  Add code here to implement a OS blocking
@@ -396,9 +396,9 @@ void MT2063_Sleep(Handle_t hUserData, UData_t nMinDelayTime)
 **                              better describes what this function does.
 **
 *****************************************************************************/
-UData_t MT2060_TunerGain(Handle_t hUserData, SData_t * pMeas)
+u32 MT2060_TunerGain(void *hUserData, s32 * pMeas)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 
 	/*
 	 **  ToDo:  Add code here to return the gain / power level measured
@@ -476,22 +476,22 @@ UData_t MT2060_TunerGain(Handle_t hUserData, SData_t * pMeas)
 #define ufloor(n, d) ((n)/(d))
 
 struct MT2063_FIFZone_t {
-	SData_t min_;
-	SData_t max_;
+	s32 min_;
+	s32 max_;
 };
 
 #if MT2063_TUNER_CNT > 1
 static struct MT2063_AvoidSpursData_t *TunerList[MT2063_TUNER_CNT];
-static UData_t TunerCount = 0;
+static u32 TunerCount = 0;
 #endif
 
-UData_t MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
+u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 #if MT2063_TUNER_CNT == 1
 	pAS_Info->nAS_Algorithm = 1;
 	return MT2063_OK;
 #else
-	UData_t index;
+	u32 index;
 
 	pAS_Info->nAS_Algorithm = 2;
 
@@ -522,7 +522,7 @@ void MT2063_UnRegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 	pAS_Info;
 #else
 
-	UData_t index;
+	u32 index;
 
 	for (index = 0; index < TunerCount; index++) {
 		if (TunerList[index] == pAS_Info) {
@@ -541,9 +541,9 @@ void MT2063_UnRegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 */
 void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
-	UData_t center;
+	u32 center;
 #if MT2063_TUNER_CNT > 1
-	UData_t index;
+	u32 index;
 	struct MT2063_AvoidSpursData_t *adj;
 #endif
 
@@ -706,7 +706,7 @@ static struct MT2063_ExclZone_t *RemoveNode(struct MT2063_AvoidSpursData_t
 **
 *****************************************************************************/
 void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
-			UData_t f_min, UData_t f_max)
+			u32 f_min, u32 f_max)
 {
 	struct MT2063_ExclZone_t *pNode = pAS_Info->usedZones;
 	struct MT2063_ExclZone_t *pPrev = NULL;
@@ -771,7 +771,7 @@ void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
 **                              Added logic to force f_Center within 1/2 f_Step.
 **
 *****************************************************************************/
-UData_t MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
+u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 	/*
 	 ** Update "f_Desired" to be the nearest "combinational-multiple" of "f_LO1_Step".
@@ -779,23 +779,23 @@ UData_t MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 	 ** of f_in + f_Center.  Neither f_in, nor f_Center must be a multiple of f_LO1_Step.
 	 ** However, the sum must be.
 	 */
-	const UData_t f_Desired =
+	const u32 f_Desired =
 	    pAS_Info->f_LO1_Step *
 	    ((pAS_Info->f_if1_Request + pAS_Info->f_in +
 	      pAS_Info->f_LO1_Step / 2) / pAS_Info->f_LO1_Step) -
 	    pAS_Info->f_in;
-	const UData_t f_Step =
+	const u32 f_Step =
 	    (pAS_Info->f_LO1_Step >
 	     pAS_Info->f_LO2_Step) ? pAS_Info->f_LO1_Step : pAS_Info->
 	    f_LO2_Step;
-	UData_t f_Center;
-
-	SData_t i;
-	SData_t j = 0;
-	UData_t bDesiredExcluded = 0;
-	UData_t bZeroExcluded = 0;
-	SData_t tmpMin, tmpMax;
-	SData_t bestDiff;
+	u32 f_Center;
+
+	s32 i;
+	s32 j = 0;
+	u32 bDesiredExcluded = 0;
+	u32 bZeroExcluded = 0;
+	s32 tmpMin, tmpMax;
+	s32 bestDiff;
 	struct MT2063_ExclZone_t *pNode = pAS_Info->usedZones;
 	struct MT2063_FIFZone_t zones[MT2063_MAX_ZONES];
 
@@ -817,18 +817,18 @@ UData_t MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 		      f_Step / 2) / f_Step);
 
 	//assert;
-	//if (!abs((SData_t) f_Center - (SData_t) pAS_Info->f_if1_Center) <= (SData_t) (f_Step/2))
+	//if (!abs((s32) f_Center - (s32) pAS_Info->f_if1_Center) <= (s32) (f_Step/2))
 	//          return 0;
 
 	/*  Take MT_ExclZones, center around f_Center and change the resolution to f_Step  */
 	while (pNode != NULL) {
 		/*  floor function  */
 		tmpMin =
-		    floor((SData_t) (pNode->min_ - f_Center), (SData_t) f_Step);
+		    floor((s32) (pNode->min_ - f_Center), (s32) f_Step);
 
 		/*  ceil function  */
 		tmpMax =
-		    ceil((SData_t) (pNode->max_ - f_Center), (SData_t) f_Step);
+		    ceil((s32) (pNode->max_ - f_Center), (s32) f_Step);
 
 		if ((pNode->min_ < f_Desired) && (pNode->max_ > f_Desired))
 			bDesiredExcluded = 1;
@@ -874,7 +874,7 @@ UData_t MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 	}
 
 	if (bestDiff < 0)
-		return f_Center - ((UData_t) (-bestDiff) * f_Step);
+		return f_Center - ((u32) (-bestDiff) * f_Step);
 
 	return f_Center + (bestDiff * f_Step);
 }
@@ -903,9 +903,9 @@ UData_t MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 **                              unsigned numbers.
 **
 ****************************************************************************/
-static UData_t MT2063_gcd(UData_t u, UData_t v)
+static u32 MT2063_gcd(u32 u, u32 v)
 {
-	UData_t r;
+	u32 r;
 
 	while (v != 0) {
 		r = u % v;
@@ -939,13 +939,13 @@ static UData_t MT2063_gcd(UData_t u, UData_t v)
 **   N/A   06-02-2004    JWS    Original
 **
 ****************************************************************************/
-static UData_t MT2063_umax(UData_t a, UData_t b)
+static u32 MT2063_umax(u32 a, u32 b)
 {
 	return (a >= b) ? a : b;
 }
 
 #if MT2063_TUNER_CNT > 1
-static SData_t RoundAwayFromZero(SData_t n, SData_t d)
+static s32 RoundAwayFromZero(s32 n, s32 d)
 {
 	return (n < 0) ? floor(n, d) : ceil(n, d);
 }
@@ -1003,23 +1003,23 @@ static SData_t RoundAwayFromZero(SData_t n, SData_t d)
 **                              Type casts added to preserve correct sign.
 **
 ****************************************************************************/
-static UData_t IsSpurInAdjTunerBand(UData_t bIsMyOutput,
-				    UData_t f1,
-				    UData_t f2,
-				    UData_t fOffset,
-				    UData_t fIFOut,
-				    UData_t fIFBW,
-				    UData_t fZIFBW,
-				    UData_t nMaxH, UData_t * fp, UData_t * fm)
+static u32 IsSpurInAdjTunerBand(u32 bIsMyOutput,
+				    u32 f1,
+				    u32 f2,
+				    u32 fOffset,
+				    u32 fIFOut,
+				    u32 fIFBW,
+				    u32 fZIFBW,
+				    u32 nMaxH, u32 * fp, u32 * fm)
 {
-	UData_t bSpurFound = 0;
+	u32 bSpurFound = 0;
 
-	const UData_t fHalf_IFBW = fIFBW / 2;
-	const UData_t fHalf_ZIFBW = fZIFBW / 2;
+	const u32 fHalf_IFBW = fIFBW / 2;
+	const u32 fHalf_ZIFBW = fZIFBW / 2;
 
 	/* Calculate a scale factor for all frequencies, so that our
 	   calculations all stay within 31 bits */
-	const UData_t f_Scale =
+	const u32 f_Scale =
 	    ((f1 +
 	      (fOffset + fIFOut +
 	       fHalf_IFBW) / nMaxH) / (MAX_UDATA / 2 / nMaxH)) + 1;
@@ -1028,19 +1028,19 @@ static UData_t IsSpurInAdjTunerBand(UData_t bIsMyOutput,
 	 **  After this scaling, _f1, _f2, and _f3 are guaranteed to fit into
 	 **  signed data types (smaller than MAX_UDATA/2)
 	 */
-	const SData_t _f1 = (SData_t) (f1 / f_Scale);
-	const SData_t _f2 = (SData_t) (f2 / f_Scale);
-	const SData_t _f3 = (SData_t) (fOffset / f_Scale);
+	const s32 _f1 = (s32) (f1 / f_Scale);
+	const s32 _f2 = (s32) (f2 / f_Scale);
+	const s32 _f3 = (s32) (fOffset / f_Scale);
 
-	const SData_t c = (SData_t) (fIFOut - fHalf_IFBW) / (SData_t) f_Scale;
-	const SData_t d = (SData_t) ((fIFOut + fHalf_IFBW) / f_Scale);
-	const SData_t f = (SData_t) (fHalf_ZIFBW / f_Scale);
+	const s32 c = (s32) (fIFOut - fHalf_IFBW) / (s32) f_Scale;
+	const s32 d = (s32) ((fIFOut + fHalf_IFBW) / f_Scale);
+	const s32 f = (s32) (fHalf_ZIFBW / f_Scale);
 
-	SData_t ma, mb, mc, md, me, mf;
+	s32 ma, mb, mc, md, me, mf;
 
-	SData_t fp_ = 0;
-	SData_t fm_ = 0;
-	SData_t n;
+	s32 fp_ = 0;
+	s32 fm_ = 0;
+	s32 n;
 
 	/*
 	 **  If the other tuner does not have an LO frequency defined,
@@ -1050,36 +1050,36 @@ static UData_t IsSpurInAdjTunerBand(UData_t bIsMyOutput,
 		return 0;
 
 	/* Check out all multiples of f1 from -nMaxH to +nMaxH */
-	for (n = -(SData_t) nMaxH; n <= (SData_t) nMaxH; ++n) {
-		const SData_t nf1 = n * _f1;
+	for (n = -(s32) nMaxH; n <= (s32) nMaxH; ++n) {
+		const s32 nf1 = n * _f1;
 		md = (_f3 + d - nf1) / _f2;
 
 		/* If # f2 harmonics > nMaxH, then no spurs present */
-		if (md <= -(SData_t) nMaxH)
+		if (md <= -(s32) nMaxH)
 			break;
 
 		ma = (_f3 - d - nf1) / _f2;
-		if ((ma == md) || (ma >= (SData_t) (nMaxH)))
+		if ((ma == md) || (ma >= (s32) (nMaxH)))
 			continue;
 
 		mc = (_f3 + c - nf1) / _f2;
 		if (mc != md) {
-			const SData_t m = (n < 0) ? md : mc;
-			const SData_t fspur = (nf1 + m * _f2 - _f3);
-			const SData_t den = (bIsMyOutput ? n - 1 : n);
+			const s32 m = (n < 0) ? md : mc;
+			const s32 fspur = (nf1 + m * _f2 - _f3);
+			const s32 den = (bIsMyOutput ? n - 1 : n);
 			if (den == 0) {
 				fp_ = (d - fspur) * f_Scale;
 				fm_ = (fspur - c) * f_Scale;
 			} else {
 				fp_ =
-				    (SData_t) RoundAwayFromZero((d - fspur) *
+				    (s32) RoundAwayFromZero((d - fspur) *
 								f_Scale, den);
 				fm_ =
-				    (SData_t) RoundAwayFromZero((fspur - c) *
+				    (s32) RoundAwayFromZero((fspur - c) *
 								f_Scale, den);
 			}
-			if (((UData_t) abs(fm_) >= f_Scale)
-			    && ((UData_t) abs(fp_) >= f_Scale)) {
+			if (((u32) abs(fm_) >= f_Scale)
+			    && ((u32) abs(fp_) >= f_Scale)) {
 				bSpurFound = 1;
 				break;
 			}
@@ -1089,22 +1089,22 @@ static UData_t IsSpurInAdjTunerBand(UData_t bIsMyOutput,
 		mf = (_f3 + f - nf1) / _f2;
 		me = (_f3 - f - nf1) / _f2;
 		if (me != mf) {
-			const SData_t m = (n < 0) ? mf : me;
-			const SData_t fspur = (nf1 + m * _f2 - _f3);
-			const SData_t den = (bIsMyOutput ? n - 1 : n);
+			const s32 m = (n < 0) ? mf : me;
+			const s32 fspur = (nf1 + m * _f2 - _f3);
+			const s32 den = (bIsMyOutput ? n - 1 : n);
 			if (den == 0) {
 				fp_ = (d - fspur) * f_Scale;
 				fm_ = (fspur - c) * f_Scale;
 			} else {
 				fp_ =
-				    (SData_t) RoundAwayFromZero((f - fspur) *
+				    (s32) RoundAwayFromZero((f - fspur) *
 								f_Scale, den);
 				fm_ =
-				    (SData_t) RoundAwayFromZero((fspur + f) *
+				    (s32) RoundAwayFromZero((fspur + f) *
 								f_Scale, den);
 			}
-			if (((UData_t) abs(fm_) >= f_Scale)
-			    && ((UData_t) abs(fp_) >= f_Scale)) {
+			if (((u32) abs(fm_) >= f_Scale)
+			    && ((u32) abs(fp_) >= f_Scale)) {
 				bSpurFound = 1;
 				break;
 			}
@@ -1112,22 +1112,22 @@ static UData_t IsSpurInAdjTunerBand(UData_t bIsMyOutput,
 
 		mb = (_f3 - c - nf1) / _f2;
 		if (ma != mb) {
-			const SData_t m = (n < 0) ? mb : ma;
-			const SData_t fspur = (nf1 + m * _f2 - _f3);
-			const SData_t den = (bIsMyOutput ? n - 1 : n);
+			const s32 m = (n < 0) ? mb : ma;
+			const s32 fspur = (nf1 + m * _f2 - _f3);
+			const s32 den = (bIsMyOutput ? n - 1 : n);
 			if (den == 0) {
 				fp_ = (d - fspur) * f_Scale;
 				fm_ = (fspur - c) * f_Scale;
 			} else {
 				fp_ =
-				    (SData_t) RoundAwayFromZero((-c - fspur) *
+				    (s32) RoundAwayFromZero((-c - fspur) *
 								f_Scale, den);
 				fm_ =
-				    (SData_t) RoundAwayFromZero((fspur + d) *
+				    (s32) RoundAwayFromZero((fspur + d) *
 								f_Scale, den);
 			}
-			if (((UData_t) abs(fm_) >= f_Scale)
-			    && ((UData_t) abs(fp_) >= f_Scale)) {
+			if (((u32) abs(fm_) >= f_Scale)
+			    && ((u32) abs(fp_) >= f_Scale)) {
 				bSpurFound = 1;
 				break;
 			}
@@ -1186,25 +1186,25 @@ static UData_t IsSpurInAdjTunerBand(UData_t bIsMyOutput,
 **   N/A   11-28-2002    DAD    Implemented algorithm from applied patent
 **
 ****************************************************************************/
-static UData_t IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
-			    UData_t * fm, UData_t * fp)
+static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
+			    u32 * fm, u32 * fp)
 {
 	/*
 	 **  Calculate LO frequency settings.
 	 */
-	UData_t n, n0;
-	const UData_t f_LO1 = pAS_Info->f_LO1;
-	const UData_t f_LO2 = pAS_Info->f_LO2;
-	const UData_t d = pAS_Info->f_out + pAS_Info->f_out_bw / 2;
-	const UData_t c = d - pAS_Info->f_out_bw;
-	const UData_t f = pAS_Info->f_zif_bw / 2;
-	const UData_t f_Scale = (f_LO1 / (MAX_UDATA / 2 / pAS_Info->maxH1)) + 1;
-	SData_t f_nsLO1, f_nsLO2;
-	SData_t f_Spur;
-	UData_t ma, mb, mc, md, me, mf;
-	UData_t lo_gcd, gd_Scale, gc_Scale, gf_Scale, hgds, hgfs, hgcs;
+	u32 n, n0;
+	const u32 f_LO1 = pAS_Info->f_LO1;
+	const u32 f_LO2 = pAS_Info->f_LO2;
+	const u32 d = pAS_Info->f_out + pAS_Info->f_out_bw / 2;
+	const u32 c = d - pAS_Info->f_out_bw;
+	const u32 f = pAS_Info->f_zif_bw / 2;
+	const u32 f_Scale = (f_LO1 / (MAX_UDATA / 2 / pAS_Info->maxH1)) + 1;
+	s32 f_nsLO1, f_nsLO2;
+	s32 f_Spur;
+	u32 ma, mb, mc, md, me, mf;
+	u32 lo_gcd, gd_Scale, gc_Scale, gf_Scale, hgds, hgfs, hgcs;
 #if MT2063_TUNER_CNT > 1
-	UData_t index;
+	u32 index;
 
 	struct MT2063_AvoidSpursData_t *adj;
 #endif
@@ -1216,11 +1216,11 @@ static UData_t IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 	 ** gcd-based scale factor or f_Scale.
 	 */
 	lo_gcd = MT2063_gcd(f_LO1, f_LO2);
-	gd_Scale = MT2063_umax((UData_t) MT2063_gcd(lo_gcd, d), f_Scale);
+	gd_Scale = MT2063_umax((u32) MT2063_gcd(lo_gcd, d), f_Scale);
 	hgds = gd_Scale / 2;
-	gc_Scale = MT2063_umax((UData_t) MT2063_gcd(lo_gcd, c), f_Scale);
+	gc_Scale = MT2063_umax((u32) MT2063_gcd(lo_gcd, c), f_Scale);
 	hgcs = gc_Scale / 2;
-	gf_Scale = MT2063_umax((UData_t) MT2063_gcd(lo_gcd, f), f_Scale);
+	gf_Scale = MT2063_umax((u32) MT2063_gcd(lo_gcd, f), f_Scale);
 	hgfs = gf_Scale / 2;
 
 	n0 = uceil(f_LO2 - d, f_LO1 - f_LO2);
@@ -1244,14 +1244,14 @@ static UData_t IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 		mc = (n * ((f_LO1 + hgcs) / gc_Scale) -
 		      ((c + hgcs) / gc_Scale)) / ((f_LO2 + hgcs) / gc_Scale);
 		if (mc != md) {
-			f_nsLO1 = (SData_t) (n * (f_LO1 / gc_Scale));
-			f_nsLO2 = (SData_t) (mc * (f_LO2 / gc_Scale));
+			f_nsLO1 = (s32) (n * (f_LO1 / gc_Scale));
+			f_nsLO2 = (s32) (mc * (f_LO2 / gc_Scale));
 			f_Spur =
 			    (gc_Scale * (f_nsLO1 - f_nsLO2)) +
 			    n * (f_LO1 % gc_Scale) - mc * (f_LO2 % gc_Scale);
 
-			*fp = ((f_Spur - (SData_t) c) / (mc - n)) + 1;
-			*fm = (((SData_t) d - f_Spur) / (mc - n)) + 1;
+			*fp = ((f_Spur - (s32) c) / (mc - n)) + 1;
+			*fm = (((s32) d - f_Spur) / (mc - n)) + 1;
 			return 1;
 		}
 
@@ -1267,8 +1267,8 @@ static UData_t IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 			    (gf_Scale * (f_nsLO1 - f_nsLO2)) +
 			    n * (f_LO1 % gf_Scale) - me * (f_LO2 % gf_Scale);
 
-			*fp = ((f_Spur + (SData_t) f) / (me - n)) + 1;
-			*fm = (((SData_t) f - f_Spur) / (me - n)) + 1;
+			*fp = ((f_Spur + (s32) f) / (me - n)) + 1;
+			*fm = (((s32) f - f_Spur) / (me - n)) + 1;
 			return 1;
 		}
 
@@ -1281,8 +1281,8 @@ static UData_t IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 			    (gc_Scale * (f_nsLO1 - f_nsLO2)) +
 			    n * (f_LO1 % gc_Scale) - ma * (f_LO2 % gc_Scale);
 
-			*fp = (((SData_t) d + f_Spur) / (ma - n)) + 1;
-			*fm = (-(f_Spur + (SData_t) c) / (ma - n)) + 1;
+			*fp = (((s32) d + f_Spur) / (ma - n)) + 1;
+			*fm = (-(f_Spur + (s32) c) / (ma - n)) + 1;
 			return 1;
 		}
 	}
@@ -1338,10 +1338,10 @@ static UData_t IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 **   096   04-06-2005    DAD    Ver 1.11: Fix divide by 0 error if maxH==0.
 **
 *****************************************************************************/
-UData_t MT2063_AvoidSpurs(Handle_t h, struct MT2063_AvoidSpursData_t * pAS_Info)
+u32 MT2063_AvoidSpurs(void *h, struct MT2063_AvoidSpursData_t * pAS_Info)
 {
-	UData_t status = MT2063_OK;
-	UData_t fm, fp;		/*  restricted range on LO's        */
+	u32 status = MT2063_OK;
+	u32 fm, fp;		/*  restricted range on LO's        */
 	pAS_Info->bSpurAvoided = 0;
 	pAS_Info->nSpursFound = 0;
 
@@ -1361,11 +1361,11 @@ UData_t MT2063_AvoidSpurs(Handle_t h, struct MT2063_AvoidSpursData_t * pAS_Info)
 	 */
 	pAS_Info->bSpurPresent = IsSpurInBand(pAS_Info, &fm, &fp);
 	if (pAS_Info->bSpurPresent) {
-		UData_t zfIF1 = pAS_Info->f_LO1 - pAS_Info->f_in;	/*  current attempt at a 1st IF  */
-		UData_t zfLO1 = pAS_Info->f_LO1;	/*  current attempt at an LO1 freq  */
-		UData_t zfLO2 = pAS_Info->f_LO2;	/*  current attempt at an LO2 freq  */
-		UData_t delta_IF1;
-		UData_t new_IF1;
+		u32 zfIF1 = pAS_Info->f_LO1 - pAS_Info->f_in;	/*  current attempt at a 1st IF  */
+		u32 zfLO1 = pAS_Info->f_LO1;	/*  current attempt at an LO1 freq  */
+		u32 zfLO2 = pAS_Info->f_LO2;	/*  current attempt at an LO2 freq  */
+		u32 delta_IF1;
+		u32 new_IF1;
 
 		/*
 		 **  Spur was found, attempt to find a spur-free 1st IF
@@ -1422,7 +1422,7 @@ UData_t MT2063_AvoidSpurs(Handle_t h, struct MT2063_AvoidSpursData_t * pAS_Info)
 	return (status);
 }
 
-UData_t MT2063_AvoidSpursVersion(void)
+u32 MT2063_AvoidSpursVersion(void)
 {
 	return (MT2063_SPUR_VERSION);
 }
@@ -1489,14 +1489,14 @@ typedef enum {
 /*
 **  The number of Tuner Registers
 */
-static const UData_t MT2063_Num_Registers = MT2063_REG_END_REGS;
+static const u32 MT2063_Num_Registers = MT2063_REG_END_REGS;
 
 #define USE_GLOBAL_TUNER			0
 
-static UData_t nMT2063MaxTuners = MT2063_CNT;
+static u32 nMT2063MaxTuners = MT2063_CNT;
 static struct MT2063_Info_t MT2063_Info[MT2063_CNT];
 static struct MT2063_Info_t *MT2063_Avail[MT2063_CNT];
-static UData_t nMT2063OpenTuners = 0;
+static u32 nMT2063OpenTuners = 0;
 
 /*
 **  Constants for setting receiver modes.
@@ -1520,32 +1520,32 @@ static UData_t nMT2063OpenTuners = 0;
 **
 **
 */
-static const U8Data RFAGCEN[] = { 0, 0, 0, 0, 0, 0 };
-static const U8Data LNARIN[] = { 0, 0, 3, 3, 3, 3 };
-static const U8Data FIFFQEN[] = { 1, 1, 1, 1, 1, 1 };
-static const U8Data FIFFQ[] = { 0, 0, 0, 0, 0, 0 };
-static const U8Data DNC1GC[] = { 0, 0, 0, 0, 0, 0 };
-static const U8Data DNC2GC[] = { 0, 0, 0, 0, 0, 0 };
-static const U8Data ACLNAMAX[] = { 31, 31, 31, 31, 31, 31 };
-static const U8Data LNATGT[] = { 44, 43, 43, 43, 43, 43 };
-static const U8Data RFOVDIS[] = { 0, 0, 0, 0, 0, 0 };
-static const U8Data ACRFMAX[] = { 31, 31, 31, 31, 31, 31 };
-static const U8Data PD1TGT[] = { 36, 36, 38, 38, 36, 38 };
-static const U8Data FIFOVDIS[] = { 0, 0, 0, 0, 0, 0 };
-static const U8Data ACFIFMAX[] = { 29, 29, 29, 29, 29, 29 };
-static const U8Data PD2TGT[] = { 40, 33, 38, 42, 30, 38 };
+static const u8 RFAGCEN[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 LNARIN[] = { 0, 0, 3, 3, 3, 3 };
+static const u8 FIFFQEN[] = { 1, 1, 1, 1, 1, 1 };
+static const u8 FIFFQ[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 DNC1GC[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 DNC2GC[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 ACLNAMAX[] = { 31, 31, 31, 31, 31, 31 };
+static const u8 LNATGT[] = { 44, 43, 43, 43, 43, 43 };
+static const u8 RFOVDIS[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 ACRFMAX[] = { 31, 31, 31, 31, 31, 31 };
+static const u8 PD1TGT[] = { 36, 36, 38, 38, 36, 38 };
+static const u8 FIFOVDIS[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 ACFIFMAX[] = { 29, 29, 29, 29, 29, 29 };
+static const u8 PD2TGT[] = { 40, 33, 38, 42, 30, 38 };
 
 /*
 **  Local Function Prototypes - not available for external access.
 */
 
 /*  Forward declaration(s):  */
-static UData_t MT2063_CalcLO1Mult(UData_t * Div, UData_t * FracN, UData_t f_LO,
-				  UData_t f_LO_Step, UData_t f_Ref);
-static UData_t MT2063_CalcLO2Mult(UData_t * Div, UData_t * FracN, UData_t f_LO,
-				  UData_t f_LO_Step, UData_t f_Ref);
-static UData_t MT2063_fLO_FractionalTerm(UData_t f_ref, UData_t num,
-					 UData_t denom);
+static u32 MT2063_CalcLO1Mult(u32 * Div, u32 * FracN, u32 f_LO,
+				  u32 f_LO_Step, u32 f_Ref);
+static u32 MT2063_CalcLO2Mult(u32 * Div, u32 * FracN, u32 f_LO,
+				  u32 f_LO_Step, u32 f_Ref);
+static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num,
+					 u32 denom);
 
 /******************************************************************************
 **
@@ -1576,10 +1576,10 @@ static UData_t MT2063_fLO_FractionalTerm(UData_t f_ref, UData_t num,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-UData_t MT2063_Open(UData_t MT2063_Addr, Handle_t * hMT2063, Handle_t hUserData)
+u32 MT2063_Open(u32 MT2063_Addr, void ** hMT2063, void *hUserData)
 {
-	UData_t status = MT2063_OK;	/*  Status to be returned.  */
-	SData_t i;
+	u32 status = MT2063_OK;	/*  Status to be returned.  */
+	s32 i;
 	struct MT2063_Info_t *pInfo = NULL;
 	struct dvb_frontend *fe = (struct dvb_frontend *)hUserData;
 	struct mt2063_state *state = fe->tuner_priv;
@@ -1636,7 +1636,7 @@ UData_t MT2063_Open(UData_t MT2063_Addr, Handle_t * hMT2063, Handle_t hUserData)
 		nMT2063OpenTuners++;
 	}
 #else
-	if (state->MT2063_init == FALSE) {
+	if (state->MT2063_init == false) {
 		pInfo = kzalloc(sizeof(struct MT2063_Info_t), GFP_KERNEL);
 		if (pInfo == NULL) {
 			return MT2063_TUNER_OPEN_ERR;
@@ -1655,19 +1655,19 @@ UData_t MT2063_Open(UData_t MT2063_Addr, Handle_t * hMT2063, Handle_t hUserData)
 	}
 
 	if (MT2063_NO_ERROR(status)) {
-		pInfo->handle = (Handle_t) pInfo;
+		pInfo->handle = (void *) pInfo;
 
 		pInfo->hUserData = hUserData;
 		pInfo->address = MT2063_Addr;
 		pInfo->rcvr_mode = MT2063_CABLE_QAM;
-		status |= MT2063_ReInit((Handle_t) pInfo);
+		status |= MT2063_ReInit((void *) pInfo);
 	}
 
 	if (MT2063_IS_ERROR(status))
 		/*  MT2063_Close handles the un-registration of the tuner  */
-		MT2063_Close((Handle_t) pInfo);
+		MT2063_Close((void *) pInfo);
 	else {
-		state->MT2063_init = TRUE;
+		state->MT2063_init = true;
 		*hMT2063 = pInfo->handle;
 
 	}
@@ -1675,7 +1675,7 @@ UData_t MT2063_Open(UData_t MT2063_Addr, Handle_t * hMT2063, Handle_t hUserData)
 	return (status);
 }
 
-static UData_t MT2063_IsValidHandle(struct MT2063_Info_t *handle)
+static u32 MT2063_IsValidHandle(struct MT2063_Info_t *handle)
 {
 	return ((handle != NULL) && (handle->handle == handle)) ? 1 : 0;
 }
@@ -1701,7 +1701,7 @@ static UData_t MT2063_IsValidHandle(struct MT2063_Info_t *handle)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-UData_t MT2063_Close(Handle_t hMT2063)
+u32 MT2063_Close(void *hMT2063)
 {
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)hMT2063;
 
@@ -1753,13 +1753,13 @@ UData_t MT2063_Close(Handle_t hMT2063)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-UData_t MT2063_GetGPIO(Handle_t h, enum MT2063_GPIO_ID gpio_id,
-		       enum MT2063_GPIO_Attr attr, UData_t * value)
+u32 MT2063_GetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
+		       enum MT2063_GPIO_Attr attr, u32 * value)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
-	U8Data regno;
-	SData_t shift;
-	static U8Data GPIOreg[3] =
+	u32 status = MT2063_OK;	/* Status to be returned        */
+	u8 regno;
+	s32 shift;
+	static u8 GPIOreg[3] =
 	    { MT2063_REG_RF_STATUS, MT2063_REG_FIF_OV, MT2063_REG_RF_OV };
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
@@ -1807,15 +1807,15 @@ UData_t MT2063_GetGPIO(Handle_t h, enum MT2063_GPIO_ID gpio_id,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-UData_t MT2063_GetLocked(Handle_t h)
+u32 MT2063_GetLocked(void *h)
 {
-	const UData_t nMaxWait = 100;	/*  wait a maximum of 100 msec   */
-	const UData_t nPollRate = 2;	/*  poll status bits every 2 ms */
-	const UData_t nMaxLoops = nMaxWait / nPollRate;
-	const U8Data LO1LK = 0x80;
-	U8Data LO2LK = 0x08;
-	UData_t status = MT2063_OK;	/* Status to be returned        */
-	UData_t nDelays = 0;
+	const u32 nMaxWait = 100;	/*  wait a maximum of 100 msec   */
+	const u32 nPollRate = 2;	/*  poll status bits every 2 ms */
+	const u32 nMaxLoops = nMaxWait / nPollRate;
+	const u8 LO1LK = 0x80;
+	u8 LO2LK = 0x08;
+	u32 status = MT2063_OK;	/* Status to be returned        */
+	u32 nDelays = 0;
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	if (MT2063_IsValidHandle(pInfo) == 0)
@@ -1942,12 +1942,12 @@ UData_t MT2063_GetLocked(Handle_t h)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-UData_t MT2063_GetParam(Handle_t h, enum MT2063_Param param, UData_t * pValue)
+u32 MT2063_GetParam(void *h, enum MT2063_Param param, u32 * pValue)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-	UData_t Div;
-	UData_t Num;
+	u32 Div;
+	u32 Num;
 
 	if (pValue == NULL)
 		status |= MT2063_ARG_NULL;
@@ -2139,9 +2139,9 @@ UData_t MT2063_GetParam(Handle_t h, enum MT2063_Param param, UData_t * pValue)
 		case MT2063_PD1:
 		case MT2063_PD2:
 			{
-				U8Data mask = (param == MT2063_PD1 ? 0x01 : 0x03);	/* PD1 vs PD2 */
-				U8Data orig = (pInfo->reg[MT2063_REG_BYP_CTRL]);
-				U8Data reg = (orig & 0xF1) | mask;	/* Only set 3 bits (not 5) */
+				u8 mask = (param == MT2063_PD1 ? 0x01 : 0x03);	/* PD1 vs PD2 */
+				u8 orig = (pInfo->reg[MT2063_REG_BYP_CTRL]);
+				u8 reg = (orig & 0xF1) | mask;	/* Only set 3 bits (not 5) */
 				int i;
 
 				*pValue = 0;
@@ -2193,7 +2193,7 @@ UData_t MT2063_GetParam(Handle_t h, enum MT2063_Param param, UData_t * pValue)
 			/*  Get LNA attenuator code                */
 		case MT2063_ACLNA:
 			{
-				U8Data val;
+				u8 val;
 				status |=
 				    MT2063_GetReg(pInfo, MT2063_REG_XO_STATUS,
 						  &val);
@@ -2204,7 +2204,7 @@ UData_t MT2063_GetParam(Handle_t h, enum MT2063_Param param, UData_t * pValue)
 			/*  Get RF attenuator code                */
 		case MT2063_ACRF:
 			{
-				U8Data val;
+				u8 val;
 				status |=
 				    MT2063_GetReg(pInfo, MT2063_REG_RF_STATUS,
 						  &val);
@@ -2215,7 +2215,7 @@ UData_t MT2063_GetParam(Handle_t h, enum MT2063_Param param, UData_t * pValue)
 			/*  Get FIF attenuator code               */
 		case MT2063_ACFIF:
 			{
-				U8Data val;
+				u8 val;
 				status |=
 				    MT2063_GetReg(pInfo, MT2063_REG_FIF_STATUS,
 						  &val);
@@ -2226,7 +2226,7 @@ UData_t MT2063_GetParam(Handle_t h, enum MT2063_Param param, UData_t * pValue)
 			/*  Get LNA attenuator limit              */
 		case MT2063_ACLNA_MAX:
 			{
-				U8Data val;
+				u8 val;
 				status |=
 				    MT2063_GetReg(pInfo, MT2063_REG_LNA_OV,
 						  &val);
@@ -2237,7 +2237,7 @@ UData_t MT2063_GetParam(Handle_t h, enum MT2063_Param param, UData_t * pValue)
 			/*  Get RF attenuator limit               */
 		case MT2063_ACRF_MAX:
 			{
-				U8Data val;
+				u8 val;
 				status |=
 				    MT2063_GetReg(pInfo, MT2063_REG_RF_OV,
 						  &val);
@@ -2248,7 +2248,7 @@ UData_t MT2063_GetParam(Handle_t h, enum MT2063_Param param, UData_t * pValue)
 			/*  Get FIF attenuator limit               */
 		case MT2063_ACFIF_MAX:
 			{
-				U8Data val;
+				u8 val;
 				status |=
 				    MT2063_GetReg(pInfo, MT2063_REG_FIF_OV,
 						  &val);
@@ -2262,18 +2262,18 @@ UData_t MT2063_GetParam(Handle_t h, enum MT2063_Param param, UData_t * pValue)
 				if ((pInfo->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
 					if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
 						*pValue =
-						    (UData_t) MT2063_DNC_NONE;
+						    (u32) MT2063_DNC_NONE;
 					else
 						*pValue =
-						    (UData_t) MT2063_DNC_2;
+						    (u32) MT2063_DNC_2;
 				} else {	/* DNC1 is on */
 
 					if ((pInfo->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
 						*pValue =
-						    (UData_t) MT2063_DNC_1;
+						    (u32) MT2063_DNC_1;
 					else
 						*pValue =
-						    (UData_t) MT2063_DNC_BOTH;
+						    (u32) MT2063_DNC_BOTH;
 				}
 			}
 			break;
@@ -2346,9 +2346,9 @@ UData_t MT2063_GetParam(Handle_t h, enum MT2063_Param param, UData_t * pValue)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-UData_t MT2063_GetReg(Handle_t h, U8Data reg, U8Data * val)
+u32 MT2063_GetReg(void *h, u8 reg, u8 * val)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
@@ -2418,9 +2418,9 @@ UData_t MT2063_GetReg(Handle_t h, U8Data reg, U8Data * val)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-UData_t MT2063_GetTemp(Handle_t h, enum MT2063_Temperature * value)
+u32 MT2063_GetTemp(void *h, enum MT2063_Temperature * value)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	if (MT2063_IsValidHandle(pInfo) == 0)
@@ -2489,9 +2489,9 @@ UData_t MT2063_GetTemp(Handle_t h, enum MT2063_Temperature * value)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-UData_t MT2063_GetUserData(Handle_t h, Handle_t * hUserData)
+u32 MT2063_GetUserData(void *h, void ** hUserData)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
@@ -2590,12 +2590,12 @@ UData_t MT2063_GetUserData(Handle_t h, Handle_t * hUserData)
 **                                        removed GCUAUTO / BYPATNDN/UP
 **
 ******************************************************************************/
-static UData_t MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
+static u32 MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 				      enum MT2063_RCVR_MODES Mode)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
-	U8Data val;
-	UData_t longval;
+	u32 status = MT2063_OK;	/* Status to be returned        */
+	u8 val;
+	u32 longval;
 
 	if (Mode >= MT2063_NUM_RCVR_MODES)
 		status = MT2063_ARG_RANGE;
@@ -2604,7 +2604,7 @@ static UData_t MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 	if (MT2063_NO_ERROR(status)) {
 		val =
 		    (pInfo->
-		     reg[MT2063_REG_PD1_TGT] & (U8Data) ~ 0x40) | (RFAGCEN[Mode]
+		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x40) | (RFAGCEN[Mode]
 								   ? 0x40 :
 								   0x00);
 		if (pInfo->reg[MT2063_REG_PD1_TGT] != val) {
@@ -2621,19 +2621,19 @@ static UData_t MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 	if (MT2063_NO_ERROR(status)) {
 		val =
 		    (pInfo->
-		     reg[MT2063_REG_FIFF_CTRL2] & (U8Data) ~ 0xF0) |
+		     reg[MT2063_REG_FIFF_CTRL2] & (u8) ~ 0xF0) |
 		    (FIFFQEN[Mode] << 7) | (FIFFQ[Mode] << 4);
 		if (pInfo->reg[MT2063_REG_FIFF_CTRL2] != val) {
 			status |=
 			    MT2063_SetReg(pInfo, MT2063_REG_FIFF_CTRL2, val);
 			/* trigger FIFF calibration, needed after changing FIFFQ */
 			val =
-			    (pInfo->reg[MT2063_REG_FIFF_CTRL] | (U8Data) 0x01);
+			    (pInfo->reg[MT2063_REG_FIFF_CTRL] | (u8) 0x01);
 			status |=
 			    MT2063_SetReg(pInfo, MT2063_REG_FIFF_CTRL, val);
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_FIFF_CTRL] & (U8Data) ~ 0x01);
+			     reg[MT2063_REG_FIFF_CTRL] & (u8) ~ 0x01);
 			status |=
 			    MT2063_SetReg(pInfo, MT2063_REG_FIFF_CTRL, val);
 		}
@@ -2680,7 +2680,7 @@ static UData_t MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 	if (MT2063_NO_ERROR(status)) {
 		val =
 		    (pInfo->
-		     reg[MT2063_REG_LNA_TGT] & (U8Data) ~ 0x80) | (RFOVDIS[Mode]
+		     reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x80) | (RFOVDIS[Mode]
 								   ? 0x80 :
 								   0x00);
 		if (pInfo->reg[MT2063_REG_LNA_TGT] != val) {
@@ -2692,7 +2692,7 @@ static UData_t MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 	if (MT2063_NO_ERROR(status)) {
 		val =
 		    (pInfo->
-		     reg[MT2063_REG_PD1_TGT] & (U8Data) ~ 0x80) |
+		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x80) |
 		    (FIFOVDIS[Mode] ? 0x80 : 0x00);
 		if (pInfo->reg[MT2063_REG_PD1_TGT] != val) {
 			status |= MT2063_SetReg(pInfo, MT2063_REG_PD1_TGT, val);
@@ -2739,14 +2739,14 @@ static UData_t MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ******************************************************************************/
-UData_t MT2063_ReInit(Handle_t h)
+u32 MT2063_ReInit(void *h)
 {
-	U8Data all_resets = 0xF0;	/* reset/load bits */
-	UData_t status = MT2063_OK;	/* Status to be returned */
+	u8 all_resets = 0xF0;	/* reset/load bits */
+	u32 status = MT2063_OK;	/* Status to be returned */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-	U8Data *def;
+	u8 *def;
 
-	U8Data MT2063B0_defaults[] = {	/* Reg,  Value */
+	u8 MT2063B0_defaults[] = {	/* Reg,  Value */
 		0x19, 0x05,
 		0x1B, 0x1D,
 		0x1C, 0x1F,
@@ -2770,7 +2770,7 @@ UData_t MT2063_ReInit(Handle_t h)
 	};
 
 	/* writing 0x05 0xf0 sw-resets all registers, so we write only needed changes */
-	U8Data MT2063B1_defaults[] = {	/* Reg,  Value */
+	u8 MT2063B1_defaults[] = {	/* Reg,  Value */
 		0x05, 0xF0,
 		0x11, 0x10,	/* New Enable AFCsd */
 		0x19, 0x05,
@@ -2796,7 +2796,7 @@ UData_t MT2063_ReInit(Handle_t h)
 	};
 
 	/* writing 0x05 0xf0 sw-resets all registers, so we write only needed changes */
-	U8Data MT2063B3_defaults[] = {	/* Reg,  Value */
+	u8 MT2063B3_defaults[] = {	/* Reg,  Value */
 		0x05, 0xF0,
 		0x19, 0x3D,
 		0x2C, 0x24,	/*  bit at 0x20 is cleared below  */
@@ -2861,8 +2861,8 @@ UData_t MT2063_ReInit(Handle_t h)
 	}
 
 	while (MT2063_NO_ERROR(status) && *def) {
-		U8Data reg = *def++;
-		U8Data val = *def++;
+		u8 reg = *def++;
+		u8 val = *def++;
 		status |=
 		    MT2063_WriteSub(pInfo->hUserData, pInfo->address, reg, &val,
 				    1);
@@ -2870,8 +2870,8 @@ UData_t MT2063_ReInit(Handle_t h)
 
 	/*  Wait for FIFF location to complete.  */
 	if (MT2063_NO_ERROR(status)) {
-		UData_t FCRUN = 1;
-		SData_t maxReads = 10;
+		u32 FCRUN = 1;
+		s32 maxReads = 10;
 		while (MT2063_NO_ERROR(status) && (FCRUN != 0)
 		       && (maxReads-- > 0)) {
 			MT2063_Sleep(pInfo->hUserData, 2);
@@ -2907,7 +2907,7 @@ UData_t MT2063_ReInit(Handle_t h)
 		pInfo->AS_Data.f_ref = MT2063_REF_FREQ;
 		pInfo->AS_Data.f_if1_Center =
 		    (pInfo->AS_Data.f_ref / 8) *
-		    ((UData_t) pInfo->reg[MT2063_REG_FIFFC] + 640);
+		    ((u32) pInfo->reg[MT2063_REG_FIFFC] + 640);
 		pInfo->AS_Data.f_if1_bw = MT2063_IF1_BW;
 		pInfo->AS_Data.f_out = 43750000UL;
 		pInfo->AS_Data.f_out_bw = 6750000UL;
@@ -2969,8 +2969,8 @@ UData_t MT2063_ReInit(Handle_t h)
 	 **   scale all of the Band Max values
 	 */
 	if (MT2063_NO_ERROR(status)) {
-		UData_t fcu_osc;
-		UData_t i;
+		u32 fcu_osc;
+		u32 i;
 
 		pInfo->reg[MT2063_REG_CTUNE_CTRL] = 0x0A;
 		status |=
@@ -3028,13 +3028,13 @@ UData_t MT2063_ReInit(Handle_t h)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-UData_t MT2063_SetGPIO(Handle_t h, enum MT2063_GPIO_ID gpio_id,
-		       enum MT2063_GPIO_Attr attr, UData_t value)
+u32 MT2063_SetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
+		       enum MT2063_GPIO_Attr attr, u32 value)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
-	U8Data regno;
-	SData_t shift;
-	static U8Data GPIOreg[3] = { 0x15, 0x19, 0x18 };
+	u32 status = MT2063_OK;	/* Status to be returned        */
+	u8 regno;
+	s32 shift;
+	static u8 GPIOreg[3] = { 0x15, 0x19, 0x18 };
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	if (MT2063_IsValidHandle(pInfo) == 0)
@@ -3138,10 +3138,10 @@ UData_t MT2063_SetGPIO(Handle_t h, enum MT2063_GPIO_ID gpio_id,
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
+u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
-	U8Data val = 0;
+	u32 status = MT2063_OK;	/* Status to be returned        */
+	u8 val = 0;
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
@@ -3171,11 +3171,11 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 			{
 				/* Note: LO1 and LO2 are BOTH written at toggle of LDLOos  */
 				/* Capture the Divider and Numerator portions of other LO  */
-				U8Data tempLO2CQ[3];
-				U8Data tempLO2C[3];
-				U8Data tmpOneShot;
-				UData_t Div, FracN;
-				U8Data restore = 0;
+				u8 tempLO2CQ[3];
+				u8 tempLO2C[3];
+				u8 tmpOneShot;
+				u32 Div, FracN;
+				u8 restore = 0;
 
 				/* Buffer the queue for restoration later and get actual LO2 values. */
 				status |=
@@ -3223,9 +3223,9 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 						       64,
 						       pInfo->AS_Data.f_ref);
 				pInfo->reg[MT2063_REG_LO1CQ_1] =
-				    (U8Data) (Div & 0x00FF);
+				    (u8) (Div & 0x00FF);
 				pInfo->reg[MT2063_REG_LO1CQ_2] =
-				    (U8Data) (FracN);
+				    (u8) (FracN);
 				status |=
 				    MT2063_WriteSub(pInfo->hUserData,
 						    pInfo->address,
@@ -3290,12 +3290,12 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 			{
 				/* Note: LO1 and LO2 are BOTH written at toggle of LDLOos  */
 				/* Capture the Divider and Numerator portions of other LO  */
-				U8Data tempLO1CQ[2];
-				U8Data tempLO1C[2];
-				UData_t Div2;
-				UData_t FracN2;
-				U8Data tmpOneShot;
-				U8Data restore = 0;
+				u8 tempLO1CQ[2];
+				u8 tempLO1C[2];
+				u32 Div2;
+				u32 FracN2;
+				u8 tmpOneShot;
+				u8 restore = 0;
 
 				/* Buffer the queue for restoration later and get actual LO2 values. */
 				status |=
@@ -3334,12 +3334,12 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 						       8191,
 						       pInfo->AS_Data.f_ref);
 				pInfo->reg[MT2063_REG_LO2CQ_1] =
-				    (U8Data) ((Div2 << 1) |
+				    (u8) ((Div2 << 1) |
 					      ((FracN2 >> 12) & 0x01)) & 0xFF;
 				pInfo->reg[MT2063_REG_LO2CQ_2] =
-				    (U8Data) ((FracN2 >> 4) & 0xFF);
+				    (u8) ((FracN2 >> 4) & 0xFF);
 				pInfo->reg[MT2063_REG_LO2CQ_3] =
-				    (U8Data) ((FracN2 & 0x0F));
+				    (u8) ((FracN2 & 0x0F));
 				status |=
 				    MT2063_WriteSub(pInfo->hUserData,
 						    pInfo->address,
@@ -3424,7 +3424,7 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 		case MT2063_LNA_RIN:
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_CTRL_2C] & (U8Data) ~ 0x03) |
+			     reg[MT2063_REG_CTRL_2C] & (u8) ~ 0x03) |
 			    (nValue & 0x03);
 			if (pInfo->reg[MT2063_REG_CTRL_2C] != val) {
 				status |=
@@ -3437,7 +3437,7 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 		case MT2063_LNA_TGT:
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_LNA_TGT] & (U8Data) ~ 0x3F) |
+			     reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x3F) |
 			    (nValue & 0x3F);
 			if (pInfo->reg[MT2063_REG_LNA_TGT] != val) {
 				status |=
@@ -3450,7 +3450,7 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 		case MT2063_PD1_TGT:
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_PD1_TGT] & (U8Data) ~ 0x3F) |
+			     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x3F) |
 			    (nValue & 0x3F);
 			if (pInfo->reg[MT2063_REG_PD1_TGT] != val) {
 				status |=
@@ -3463,7 +3463,7 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 		case MT2063_PD2_TGT:
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_PD2_TGT] & (U8Data) ~ 0x3F) |
+			     reg[MT2063_REG_PD2_TGT] & (u8) ~ 0x3F) |
 			    (nValue & 0x3F);
 			if (pInfo->reg[MT2063_REG_PD2_TGT] != val) {
 				status |=
@@ -3476,7 +3476,7 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 		case MT2063_ACLNA_MAX:
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_LNA_OV] & (U8Data) ~ 0x1F) | (nValue
+			     reg[MT2063_REG_LNA_OV] & (u8) ~ 0x1F) | (nValue
 									  &
 									  0x1F);
 			if (pInfo->reg[MT2063_REG_LNA_OV] != val) {
@@ -3490,7 +3490,7 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 		case MT2063_ACRF_MAX:
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_RF_OV] & (U8Data) ~ 0x1F) | (nValue
+			     reg[MT2063_REG_RF_OV] & (u8) ~ 0x1F) | (nValue
 									 &
 									 0x1F);
 			if (pInfo->reg[MT2063_REG_RF_OV] != val) {
@@ -3506,7 +3506,7 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 				nValue = 5;
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_FIF_OV] & (U8Data) ~ 0x1F) | (nValue
+			     reg[MT2063_REG_FIF_OV] & (u8) ~ 0x1F) | (nValue
 									  &
 									  0x1F);
 			if (pInfo->reg[MT2063_REG_FIF_OV] != val) {
@@ -3640,7 +3640,7 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 			/* Set VGA gain code */
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_VGA_GAIN] & (U8Data) ~ 0x0C) |
+			     reg[MT2063_REG_VGA_GAIN] & (u8) ~ 0x0C) |
 			    ((nValue & 0x03) << 2);
 			if (pInfo->reg[MT2063_REG_VGA_GAIN] != val) {
 				status |=
@@ -3653,7 +3653,7 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 			/* Set VGA bias current */
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_RSVD_31] & (U8Data) ~ 0x07) |
+			     reg[MT2063_REG_RSVD_31] & (u8) ~ 0x07) |
 			    (nValue & 0x07);
 			if (pInfo->reg[MT2063_REG_RSVD_31] != val) {
 				status |=
@@ -3666,7 +3666,7 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 			/* Set TAGC */
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_RSVD_1E] & (U8Data) ~ 0x03) |
+			     reg[MT2063_REG_RSVD_1E] & (u8) ~ 0x03) |
 			    (nValue & 0x03);
 			if (pInfo->reg[MT2063_REG_RSVD_1E] != val) {
 				status |=
@@ -3679,7 +3679,7 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 			/* Set Amp gain code */
 			val =
 			    (pInfo->
-			     reg[MT2063_REG_TEMP_SEL] & (U8Data) ~ 0x03) |
+			     reg[MT2063_REG_TEMP_SEL] & (u8) ~ 0x03) |
 			    (nValue & 0x03);
 			if (pInfo->reg[MT2063_REG_TEMP_SEL] != val) {
 				status |=
@@ -3758,9 +3758,9 @@ UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-UData_t MT2063_SetPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits Bits)
+u32 MT2063_SetPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
@@ -3770,14 +3770,14 @@ UData_t MT2063_SetPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits Bits)
 		Bits = (enum MT2063_Mask_Bits)(Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
 		if ((Bits & 0xFF00) != 0) {
 			pInfo->reg[MT2063_REG_PWR_2] |=
-			    (U8Data) ((Bits & 0xFF00) >> 8);
+			    (u8) ((Bits & 0xFF00) >> 8);
 			status |=
 			    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
 					    MT2063_REG_PWR_2,
 					    &pInfo->reg[MT2063_REG_PWR_2], 1);
 		}
 		if ((Bits & 0xFF) != 0) {
-			pInfo->reg[MT2063_REG_PWR_1] |= ((U8Data) Bits & 0xFF);
+			pInfo->reg[MT2063_REG_PWR_1] |= ((u8) Bits & 0xFF);
 			status |=
 			    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
 					    MT2063_REG_PWR_1,
@@ -3815,9 +3815,9 @@ UData_t MT2063_SetPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits Bits)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-UData_t MT2063_ClearPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits Bits)
+u32 MT2063_ClearPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
@@ -3826,14 +3826,14 @@ UData_t MT2063_ClearPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits Bits)
 	else {
 		Bits = (enum MT2063_Mask_Bits)(Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
 		if ((Bits & 0xFF00) != 0) {
-			pInfo->reg[MT2063_REG_PWR_2] &= ~(U8Data) (Bits >> 8);
+			pInfo->reg[MT2063_REG_PWR_2] &= ~(u8) (Bits >> 8);
 			status |=
 			    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
 					    MT2063_REG_PWR_2,
 					    &pInfo->reg[MT2063_REG_PWR_2], 1);
 		}
 		if ((Bits & 0xFF) != 0) {
-			pInfo->reg[MT2063_REG_PWR_1] &= ~(U8Data) (Bits & 0xFF);
+			pInfo->reg[MT2063_REG_PWR_1] &= ~(u8) (Bits & 0xFF);
 			status |=
 			    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
 					    MT2063_REG_PWR_1,
@@ -3871,9 +3871,9 @@ UData_t MT2063_ClearPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits Bits)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-UData_t MT2063_GetPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits * Bits)
+u32 MT2063_GetPowerMaskBits(void *h, enum MT2063_Mask_Bits * Bits)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
@@ -3892,7 +3892,7 @@ UData_t MT2063_GetPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits * Bits)
 		if (MT2063_NO_ERROR(status)) {
 			*Bits =
 			    (enum
-			     MT2063_Mask_Bits)(((SData_t) pInfo->
+			     MT2063_Mask_Bits)(((s32) pInfo->
 						reg[MT2063_REG_PWR_2] << 8) +
 					       pInfo->reg[MT2063_REG_PWR_1]);
 			*Bits = (enum MT2063_Mask_Bits)(*Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
@@ -3926,9 +3926,9 @@ UData_t MT2063_GetPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits * Bits)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-UData_t MT2063_EnableExternalShutdown(Handle_t h, U8Data Enabled)
+u32 MT2063_EnableExternalShutdown(void *h, u8 Enabled)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
@@ -3977,9 +3977,9 @@ UData_t MT2063_EnableExternalShutdown(Handle_t h, U8Data Enabled)
 **                              correct wakeup of the LNA
 **
 ****************************************************************************/
-UData_t MT2063_SoftwareShutdown(Handle_t h, U8Data Shutdown)
+u32 MT2063_SoftwareShutdown(void *h, u8 Shutdown)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
@@ -4049,9 +4049,9 @@ UData_t MT2063_SoftwareShutdown(Handle_t h, U8Data Shutdown)
 **   189 S 05-13-2008    RSK    Ver 1.16: Correct location for ExtSRO control.
 **
 ****************************************************************************/
-UData_t MT2063_SetExtSRO(Handle_t h, enum MT2063_Ext_SRO Ext_SRO_Setting)
+u32 MT2063_SetExtSRO(void *h, enum MT2063_Ext_SRO Ext_SRO_Setting)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
@@ -4060,7 +4060,7 @@ UData_t MT2063_SetExtSRO(Handle_t h, enum MT2063_Ext_SRO Ext_SRO_Setting)
 	else {
 		pInfo->reg[MT2063_REG_CTRL_2C] =
 		    (pInfo->
-		     reg[MT2063_REG_CTRL_2C] & 0x3F) | ((U8Data) Ext_SRO_Setting
+		     reg[MT2063_REG_CTRL_2C] & 0x3F) | ((u8) Ext_SRO_Setting
 							<< 6);
 		status =
 		    MT2063_WriteSub(pInfo->hUserData, pInfo->address,
@@ -4099,9 +4099,9 @@ UData_t MT2063_SetExtSRO(Handle_t h, enum MT2063_Ext_SRO Ext_SRO_Setting)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-UData_t MT2063_SetReg(Handle_t h, U8Data reg, U8Data val)
+u32 MT2063_SetReg(void *h, u8 reg, u8 val)
 {
-	UData_t status = MT2063_OK;	/* Status to be returned        */
+	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
@@ -4122,7 +4122,7 @@ UData_t MT2063_SetReg(Handle_t h, U8Data reg, U8Data val)
 	return (status);
 }
 
-static UData_t MT2063_Round_fLO(UData_t f_LO, UData_t f_LO_Step, UData_t f_ref)
+static u32 MT2063_Round_fLO(u32 f_LO, u32 f_LO_Step, u32 f_ref)
 {
 	return f_ref * (f_LO / f_ref)
 	    + f_LO_Step * (((f_LO % f_ref) + (f_LO_Step / 2)) / f_LO_Step);
@@ -4158,13 +4158,13 @@ static UData_t MT2063_Round_fLO(UData_t f_LO, UData_t f_LO_Step, UData_t f_ref)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static UData_t MT2063_fLO_FractionalTerm(UData_t f_ref,
-					 UData_t num, UData_t denom)
+static u32 MT2063_fLO_FractionalTerm(u32 f_ref,
+					 u32 num, u32 denom)
 {
-	UData_t t1 = (f_ref >> 14) * num;
-	UData_t term1 = t1 / denom;
-	UData_t loss = t1 % denom;
-	UData_t term2 =
+	u32 t1 = (f_ref >> 14) * num;
+	u32 term1 = t1 / denom;
+	u32 loss = t1 % denom;
+	u32 term2 =
 	    (((f_ref & 0x00003FFF) * num + (loss << 14)) + (denom / 2)) / denom;
 	return ((term1 << 14) + term2);
 }
@@ -4196,10 +4196,10 @@ static UData_t MT2063_fLO_FractionalTerm(UData_t f_ref,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static UData_t MT2063_CalcLO1Mult(UData_t * Div,
-				  UData_t * FracN,
-				  UData_t f_LO,
-				  UData_t f_LO_Step, UData_t f_Ref)
+static u32 MT2063_CalcLO1Mult(u32 * Div,
+				  u32 * FracN,
+				  u32 f_LO,
+				  u32 f_LO_Step, u32 f_Ref)
 {
 	/*  Calculate the whole number portion of the divider */
 	*Div = f_LO / f_Ref;
@@ -4239,10 +4239,10 @@ static UData_t MT2063_CalcLO1Mult(UData_t * Div,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static UData_t MT2063_CalcLO2Mult(UData_t * Div,
-				  UData_t * FracN,
-				  UData_t f_LO,
-				  UData_t f_LO_Step, UData_t f_Ref)
+static u32 MT2063_CalcLO2Mult(u32 * Div,
+				  u32 * FracN,
+				  u32 f_LO,
+				  u32 f_LO_Step, u32 f_Ref)
 {
 	/*  Calculate the whole number portion of the divider */
 	*Div = f_LO / f_Ref;
@@ -4278,10 +4278,10 @@ static UData_t MT2063_CalcLO2Mult(UData_t * Div,
 **                                        cross-over frequency values.
 **
 ****************************************************************************/
-static UData_t FindClearTuneFilter(struct MT2063_Info_t *pInfo, UData_t f_in)
+static u32 FindClearTuneFilter(struct MT2063_Info_t *pInfo, u32 f_in)
 {
-	UData_t RFBand;
-	UData_t idx;		/*  index loop                      */
+	u32 RFBand;
+	u32 idx;		/*  index loop                      */
 
 	/*
 	 **  Find RF Band setting
@@ -4337,24 +4337,24 @@ static UData_t FindClearTuneFilter(struct MT2063_Info_t *pInfo, UData_t f_in)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-UData_t MT2063_Tune(Handle_t h, UData_t f_in)
+u32 MT2063_Tune(void *h, u32 f_in)
 {				/* RF input center frequency   */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
-	UData_t status = MT2063_OK;	/*  status of operation             */
-	UData_t LO1;		/*  1st LO register value           */
-	UData_t Num1;		/*  Numerator for LO1 reg. value    */
-	UData_t f_IF1;		/*  1st IF requested                */
-	UData_t LO2;		/*  2nd LO register value           */
-	UData_t Num2;		/*  Numerator for LO2 reg. value    */
-	UData_t ofLO1, ofLO2;	/*  last time's LO frequencies      */
-	UData_t ofin, ofout;	/*  last time's I/O frequencies     */
-	U8Data fiffc = 0x80;	/*  FIFF center freq from tuner     */
-	UData_t fiffof;		/*  Offset from FIFF center freq    */
-	const U8Data LO1LK = 0x80;	/*  Mask for LO1 Lock bit           */
-	U8Data LO2LK = 0x08;	/*  Mask for LO2 Lock bit           */
-	U8Data val;
-	UData_t RFBand;
+	u32 status = MT2063_OK;	/*  status of operation             */
+	u32 LO1;		/*  1st LO register value           */
+	u32 Num1;		/*  Numerator for LO1 reg. value    */
+	u32 f_IF1;		/*  1st IF requested                */
+	u32 LO2;		/*  2nd LO register value           */
+	u32 Num2;		/*  Numerator for LO2 reg. value    */
+	u32 ofLO1, ofLO2;	/*  last time's LO frequencies      */
+	u32 ofin, ofout;	/*  last time's I/O frequencies     */
+	u8 fiffc = 0x80;	/*  FIFF center freq from tuner     */
+	u32 fiffof;		/*  Offset from FIFF center freq    */
+	const u8 LO1LK = 0x80;	/*  Mask for LO1 Lock bit           */
+	u8 LO2LK = 0x08;	/*  Mask for LO2 Lock bit           */
+	u8 val;
+	u32 RFBand;
 
 	/*  Verify that the handle passed points to a valid tuner         */
 	if (MT2063_IsValidHandle(pInfo) == 0)
@@ -4388,7 +4388,7 @@ UData_t MT2063_Tune(Handle_t h, UData_t f_in)
 		val = pInfo->reg[MT2063_REG_CTUNE_OV];
 		RFBand = FindClearTuneFilter(pInfo, f_in);
 		pInfo->reg[MT2063_REG_CTUNE_OV] =
-		    (U8Data) ((pInfo->reg[MT2063_REG_CTUNE_OV] & ~0x1F)
+		    (u8) ((pInfo->reg[MT2063_REG_CTUNE_OV] & ~0x1F)
 			      | RFBand);
 		if (pInfo->reg[MT2063_REG_CTUNE_OV] != val) {
 			status |=
@@ -4482,7 +4482,7 @@ UData_t MT2063_Tune(Handle_t h, UData_t f_in)
 		 */
 		fiffof =
 		    (pInfo->AS_Data.f_LO1 -
-		     f_in) / (pInfo->AS_Data.f_ref / 64) - 8 * (UData_t) fiffc -
+		     f_in) / (pInfo->AS_Data.f_ref / 64) - 8 * (u32) fiffc -
 		    4992;
 		if (fiffof > 0xFF)
 			fiffof = 0xFF;
@@ -4492,12 +4492,12 @@ UData_t MT2063_Tune(Handle_t h, UData_t f_in)
 		 **  register fields.
 		 */
 		if (MT2063_NO_ERROR(status)) {
-			pInfo->reg[MT2063_REG_LO1CQ_1] = (U8Data) (LO1 & 0xFF);	/* DIV1q */
-			pInfo->reg[MT2063_REG_LO1CQ_2] = (U8Data) (Num1 & 0x3F);	/* NUM1q */
-			pInfo->reg[MT2063_REG_LO2CQ_1] = (U8Data) (((LO2 & 0x7F) << 1)	/* DIV2q */
+			pInfo->reg[MT2063_REG_LO1CQ_1] = (u8) (LO1 & 0xFF);	/* DIV1q */
+			pInfo->reg[MT2063_REG_LO1CQ_2] = (u8) (Num1 & 0x3F);	/* NUM1q */
+			pInfo->reg[MT2063_REG_LO2CQ_1] = (u8) (((LO2 & 0x7F) << 1)	/* DIV2q */
 								   |(Num2 >> 12));	/* NUM2q (hi) */
-			pInfo->reg[MT2063_REG_LO2CQ_2] = (U8Data) ((Num2 & 0x0FF0) >> 4);	/* NUM2q (mid) */
-			pInfo->reg[MT2063_REG_LO2CQ_3] = (U8Data) (0xE0 | (Num2 & 0x000F));	/* NUM2q (lo) */
+			pInfo->reg[MT2063_REG_LO2CQ_2] = (u8) ((Num2 & 0x0FF0) >> 4);	/* NUM2q (mid) */
+			pInfo->reg[MT2063_REG_LO2CQ_3] = (u8) (0xE0 | (Num2 & 0x000F));	/* NUM2q (lo) */
 
 			/*
 			 ** Now write out the computed register values
@@ -4511,9 +4511,9 @@ UData_t MT2063_Tune(Handle_t h, UData_t f_in)
 			}
 			/* Write out the FIFF offset only if it's changing */
 			if (pInfo->reg[MT2063_REG_FIFF_OFFSET] !=
-			    (U8Data) fiffof) {
+			    (u8) fiffof) {
 				pInfo->reg[MT2063_REG_FIFF_OFFSET] =
-				    (U8Data) fiffof;
+				    (u8) fiffof;
 				status |=
 				    MT2063_WriteSub(pInfo->hUserData,
 						    pInfo->address,
@@ -4542,25 +4542,25 @@ UData_t MT2063_Tune(Handle_t h, UData_t f_in)
 	return (status);
 }
 
-UData_t MT_Tune_atv(Handle_t h, UData_t f_in, UData_t bw_in,
+u32 MT_Tune_atv(void *h, u32 f_in, u32 bw_in,
 		    enum MTTune_atv_standard tv_type)
 {
 
-	UData_t status = MT2063_OK;
+	u32 status = MT2063_OK;
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 	struct dvb_frontend *fe = (struct dvb_frontend *)pInfo->hUserData;
 	struct mt2063_state *state = fe->tuner_priv;
 
-	SData_t pict_car = 0;
-	SData_t pict2chanb_vsb = 0;
-	SData_t pict2chanb_snd = 0;
-	SData_t pict2snd1 = 0;
-	SData_t pict2snd2 = 0;
-	SData_t ch_bw = 0;
+	s32 pict_car = 0;
+	s32 pict2chanb_vsb = 0;
+	s32 pict2chanb_snd = 0;
+	s32 pict2snd1 = 0;
+	s32 pict2snd2 = 0;
+	s32 ch_bw = 0;
 
-	SData_t if_mid = 0;
-	SData_t rcvr_mode = 0;
-	UData_t mode_get = 0;
+	s32 if_mid = 0;
+	s32 rcvr_mode = 0;
+	u32 mode_get = 0;
 
 	switch (tv_type) {
 	case MTTUNEA_PAL_B:{
@@ -4672,12 +4672,12 @@ UData_t MT_Tune_atv(Handle_t h, UData_t f_in, UData_t bw_in,
 	status |= MT2063_Tune(h, (f_in + (pict2chanb_vsb + (ch_bw / 2))));
 	status |= MT2063_GetParam(h, MT2063_RCVR_MODE, &mode_get);
 
-	return (UData_t) status;
+	return (u32) status;
 }
 
 static int mt2063_init(struct dvb_frontend *fe)
 {
-	UData_t status = MT2063_ERROR;
+	u32 status = MT2063_ERROR;
 	struct mt2063_state *state = fe->tuner_priv;
 
 	status = MT2063_Open(0xC0, &(state->MT2063_ht), fe);
@@ -4726,8 +4726,8 @@ static int mt2063_get_state(struct dvb_frontend *fe,
 		break;
 	case DVBFE_TUNER_REFCLOCK:
 		state->refclock =
-		    (u32_t)
-		    MT2063_GetLocked((Handle_t) (mt2063State->MT2063_ht));
+		    (u32)
+		    MT2063_GetLocked((void *) (mt2063State->MT2063_ht));
 		break;
 	default:
 		break;
@@ -4740,14 +4740,14 @@ static int mt2063_set_state(struct dvb_frontend *fe,
 			    enum tuner_param param, struct tuner_state *state)
 {
 	struct mt2063_state *mt2063State = fe->tuner_priv;
-	UData_t status = MT2063_OK;
+	u32 status = MT2063_OK;
 
 	switch (param) {
 	case DVBFE_TUNER_FREQUENCY:
 		//set frequency
 
 		status =
-		    MT_Tune_atv((Handle_t) (mt2063State->MT2063_ht),
+		    MT_Tune_atv((void *) (mt2063State->MT2063_ht),
 				state->frequency, state->bandwidth,
 				mt2063State->tv_type);
 
@@ -4822,7 +4822,7 @@ struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 	state->i2c = i2c;
 	state->frontend = fe;
 	state->reference = config->refclock / 1000;	/* kHz */
-	state->MT2063_init = FALSE;
+	state->MT2063_init = false;
 	fe->tuner_priv = state;
 	fe->ops.tuner_ops = mt2063_ops;
 
diff --git a/drivers/media/common/tuners/mt2063.h b/drivers/media/common/tuners/mt2063.h
index 80af9af..7fb5b74 100644
--- a/drivers/media/common/tuners/mt2063.h
+++ b/drivers/media/common/tuners/mt2063.h
@@ -3,13 +3,6 @@
 
 #include "dvb_frontend.h"
 
-enum Bool_t {
-  FALSE = 0,
-  TRUE
-};
-
-typedef unsigned long  u32_t;
-
 #define DVBFE_TUNER_OPEN			99
 #define DVBFE_TUNER_SOFTWARE_SHUTDOWN		100
 #define DVBFE_TUNER_CLEAR_POWER_MASKBITS	101
@@ -90,12 +83,7 @@ typedef unsigned long  u32_t;
  */
 #define MT2060_CNT 10
 
-typedef unsigned char U8Data;	/*  type corresponds to 8 bits      */
-typedef unsigned int UData_t;	/*  type must be at least 32 bits   */
-typedef int SData_t;		/*  type must be at least 32 bits   */
-typedef void *Handle_t;		/*  memory pointer type             */
-
-#define MAX_UDATA         (4294967295)	/*  max value storable in UData_t   */
+#define MAX_UDATA         (4294967295)	/*  max value storable in u32   */
 
 /*
  * Define an MTxxxx_CNT macro for each type of tuner that will be built
@@ -115,19 +103,19 @@ typedef void *Handle_t;		/*  memory pointer type             */
 #endif
 #define MT2063_I2C (0xC0)
 
-UData_t MT2063_WriteSub(Handle_t hUserData,
-			UData_t addr,
-			U8Data subAddress, U8Data * pData, UData_t cnt);
+u32 MT2063_WriteSub(void *hUserData,
+			u32 addr,
+			u8 subAddress, u8 * pData, u32 cnt);
 
-UData_t MT2063_ReadSub(Handle_t hUserData,
-		       UData_t addr,
-		       U8Data subAddress, U8Data * pData, UData_t cnt);
+u32 MT2063_ReadSub(void *hUserData,
+		       u32 addr,
+		       u8 subAddress, u8 * pData, u32 cnt);
 
-void MT2063_Sleep(Handle_t hUserData, UData_t nMinDelayTime);
+void MT2063_Sleep(void *hUserData, u32 nMinDelayTime);
 
 #if defined(MT2060_CNT)
 #if MT2060_CNT > 0
-UData_t MT2060_TunerGain(Handle_t hUserData, SData_t * pMeas);
+u32 MT2060_TunerGain(void *hUserData, s32 * pMeas);
 #endif
 #endif
 
@@ -163,8 +151,8 @@ enum MT2063_DECT_Avoid_Type {
 struct MT2063_ExclZone_t;
 
 struct MT2063_ExclZone_t {
-	UData_t min_;
-	UData_t max_;
+	u32 min_;
+	u32 max_;
 	struct MT2063_ExclZone_t *next_;
 };
 
@@ -172,48 +160,48 @@ struct MT2063_ExclZone_t {
  *  Structure of data needed for Spur Avoidance
  */
 struct MT2063_AvoidSpursData_t {
-	UData_t nAS_Algorithm;
-	UData_t f_ref;
-	UData_t f_in;
-	UData_t f_LO1;
-	UData_t f_if1_Center;
-	UData_t f_if1_Request;
-	UData_t f_if1_bw;
-	UData_t f_LO2;
-	UData_t f_out;
-	UData_t f_out_bw;
-	UData_t f_LO1_Step;
-	UData_t f_LO2_Step;
-	UData_t f_LO1_FracN_Avoid;
-	UData_t f_LO2_FracN_Avoid;
-	UData_t f_zif_bw;
-	UData_t f_min_LO_Separation;
-	UData_t maxH1;
-	UData_t maxH2;
+	u32 nAS_Algorithm;
+	u32 f_ref;
+	u32 f_in;
+	u32 f_LO1;
+	u32 f_if1_Center;
+	u32 f_if1_Request;
+	u32 f_if1_bw;
+	u32 f_LO2;
+	u32 f_out;
+	u32 f_out_bw;
+	u32 f_LO1_Step;
+	u32 f_LO2_Step;
+	u32 f_LO1_FracN_Avoid;
+	u32 f_LO2_FracN_Avoid;
+	u32 f_zif_bw;
+	u32 f_min_LO_Separation;
+	u32 maxH1;
+	u32 maxH2;
 	enum MT2063_DECT_Avoid_Type avoidDECT;
-	UData_t bSpurPresent;
-	UData_t bSpurAvoided;
-	UData_t nSpursFound;
-	UData_t nZones;
+	u32 bSpurPresent;
+	u32 bSpurAvoided;
+	u32 nSpursFound;
+	u32 nZones;
 	struct MT2063_ExclZone_t *freeZones;
 	struct MT2063_ExclZone_t *usedZones;
 	struct MT2063_ExclZone_t MT2063_ExclZones[MT2063_MAX_ZONES];
 };
 
-UData_t MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info);
+u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info);
 
 void MT2063_UnRegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info);
 
 void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info);
 
 void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
-			UData_t f_min, UData_t f_max);
+			u32 f_min, u32 f_max);
 
-UData_t MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info);
+u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info);
 
-UData_t MT2063_AvoidSpurs(Handle_t h, struct MT2063_AvoidSpursData_t *pAS_Info);
+u32 MT2063_AvoidSpurs(void *h, struct MT2063_AvoidSpursData_t *pAS_Info);
 
-UData_t MT2063_AvoidSpursVersion(void);
+u32 MT2063_AvoidSpursVersion(void);
 
 
 /*
@@ -531,18 +519,18 @@ enum MT2063_Register_Offsets {
 };
 
 struct MT2063_Info_t {
-	Handle_t handle;
-	Handle_t hUserData;
-	UData_t address;
-	UData_t version;
-	UData_t tuner_id;
+	void *handle;
+	void *hUserData;
+	u32 address;
+	u32 version;
+	u32 tuner_id;
 	struct MT2063_AvoidSpursData_t AS_Data;
-	UData_t f_IF1_actual;
-	UData_t rcvr_mode;
-	UData_t ctfilt_sw;
-	UData_t CTFiltMax[31];
-	UData_t num_regs;
-	U8Data reg[MT2063_REG_END_REGS];
+	u32 f_IF1_actual;
+	u32 rcvr_mode;
+	u32 ctfilt_sw;
+	u32 CTFiltMax[31];
+	u32 num_regs;
+	u8 reg[MT2063_REG_END_REGS];
 };
 typedef struct MT2063_Info_t *pMT2063_Info_t;
 
@@ -562,48 +550,48 @@ enum MTTune_atv_standard {
 
 /* ====== Functions which are declared in MT2063.c File ======= */
 
-UData_t MT2063_Open(UData_t MT2063_Addr,
-		    Handle_t * hMT2063, Handle_t hUserData);
+u32 MT2063_Open(u32 MT2063_Addr,
+		    void ** hMT2063, void *hUserData);
 
-UData_t MT2063_Close(Handle_t hMT2063);
+u32 MT2063_Close(void *hMT2063);
 
-UData_t MT2063_Tune(Handle_t h, UData_t f_in);	/* RF input center frequency   */
+u32 MT2063_Tune(void *h, u32 f_in);	/* RF input center frequency   */
 
-UData_t MT2063_GetGPIO(Handle_t h, enum MT2063_GPIO_ID gpio_id,
-		       enum MT2063_GPIO_Attr attr, UData_t * value);
+u32 MT2063_GetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
+		       enum MT2063_GPIO_Attr attr, u32 * value);
 
-UData_t MT2063_GetLocked(Handle_t h);
+u32 MT2063_GetLocked(void *h);
 
-UData_t MT2063_GetParam(Handle_t h, enum MT2063_Param param, UData_t * pValue);
+u32 MT2063_GetParam(void *h, enum MT2063_Param param, u32 * pValue);
 
-UData_t MT2063_GetReg(Handle_t h, U8Data reg, U8Data * val);
+u32 MT2063_GetReg(void *h, u8 reg, u8 * val);
 
-UData_t MT2063_GetTemp(Handle_t h, enum MT2063_Temperature *value);
+u32 MT2063_GetTemp(void *h, enum MT2063_Temperature *value);
 
-UData_t MT2063_GetUserData(Handle_t h, Handle_t * hUserData);
+u32 MT2063_GetUserData(void *h, void ** hUserData);
 
-UData_t MT2063_ReInit(Handle_t h);
+u32 MT2063_ReInit(void *h);
 
-UData_t MT2063_SetGPIO(Handle_t h, enum MT2063_GPIO_ID gpio_id,
-		       enum MT2063_GPIO_Attr attr, UData_t value);
+u32 MT2063_SetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
+		       enum MT2063_GPIO_Attr attr, u32 value);
 
-UData_t MT2063_SetParam(Handle_t h, enum MT2063_Param param, UData_t nValue);
+u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue);
 
-UData_t MT2063_SetPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits Bits);
+u32 MT2063_SetPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits);
 
-UData_t MT2063_ClearPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits Bits);
+u32 MT2063_ClearPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits);
 
-UData_t MT2063_GetPowerMaskBits(Handle_t h, enum MT2063_Mask_Bits *Bits);
+u32 MT2063_GetPowerMaskBits(void *h, enum MT2063_Mask_Bits *Bits);
 
-UData_t MT2063_EnableExternalShutdown(Handle_t h, U8Data Enabled);
+u32 MT2063_EnableExternalShutdown(void *h, u8 Enabled);
 
-UData_t MT2063_SoftwareShutdown(Handle_t h, U8Data Shutdown);
+u32 MT2063_SoftwareShutdown(void *h, u8 Shutdown);
 
-UData_t MT2063_SetExtSRO(Handle_t h, enum MT2063_Ext_SRO Ext_SRO_Setting);
+u32 MT2063_SetExtSRO(void *h, enum MT2063_Ext_SRO Ext_SRO_Setting);
 
-UData_t MT2063_SetReg(Handle_t h, U8Data reg, U8Data val);
+u32 MT2063_SetReg(void *h, u8 reg, u8 val);
 
-UData_t MT_Tune_atv(Handle_t h, UData_t f_in, UData_t bw_in,
+u32 MT_Tune_atv(void *h, u32 f_in, u32 bw_in,
 		    enum MTTune_atv_standard tv_type);
 
 struct mt2063_config {
@@ -619,7 +607,7 @@ struct mt2063_state {
 	struct dvb_frontend *frontend;
 	struct tuner_state status;
 	const struct MT2063_Info_t *MT2063_ht;
-	enum Bool_t MT2063_init;
+	bool MT2063_init;
 
 	enum MTTune_atv_standard tv_type;
 	u32 frequency;
-- 
1.7.7.5

