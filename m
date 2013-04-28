Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab3D1Pr6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 11:47:58 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3SFlwje013727
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 11:47:58 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/9] [media] drxk_hard: don't re-implement log10
Date: Sun, 28 Apr 2013 12:47:43 -0300
Message-Id: <1367164071-11468-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
References: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Log10 routine is already defined at dvb_math.h and provides a good
enough approximation for 100 x log10(). So, instead of reinventing
the wheel, use the already existing function.

While here, don't use CamelCase on the function name.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 104 +++-----------------------------
 1 file changed, 8 insertions(+), 96 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index ec24d71..41b6375 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -34,6 +34,7 @@
 #include "dvb_frontend.h"
 #include "drxk.h"
 #include "drxk_hard.h"
+#include "dvb_math.h"
 
 static int PowerDownDVBT(struct drxk_state *state, bool setPowerMode);
 static int PowerDownQAM(struct drxk_state *state);
@@ -201,98 +202,9 @@ static inline u32 Frac28a(u32 a, u32 c)
 	return Q1;
 }
 
-static u32 Log10Times100(u32 x)
+static inline u32 log10times100(u32 value)
 {
-	static const u8 scale = 15;
-	static const u8 indexWidth = 5;
-	u8 i = 0;
-	u32 y = 0;
-	u32 d = 0;
-	u32 k = 0;
-	u32 r = 0;
-	/*
-	   log2lut[n] = (1<<scale) * 200 * log2(1.0 + ((1.0/(1<<INDEXWIDTH)) * n))
-	   0 <= n < ((1<<INDEXWIDTH)+1)
-	 */
-
-	static const u32 log2lut[] = {
-		0,		/* 0.000000 */
-		290941,		/* 290941.300628 */
-		573196,		/* 573196.476418 */
-		847269,		/* 847269.179851 */
-		1113620,	/* 1113620.489452 */
-		1372674,	/* 1372673.576986 */
-		1624818,	/* 1624817.752104 */
-		1870412,	/* 1870411.981536 */
-		2109788,	/* 2109787.962654 */
-		2343253,	/* 2343252.817465 */
-		2571091,	/* 2571091.461923 */
-		2793569,	/* 2793568.696416 */
-		3010931,	/* 3010931.055901 */
-		3223408,	/* 3223408.452106 */
-		3431216,	/* 3431215.635215 */
-		3634553,	/* 3634553.498355 */
-		3833610,	/* 3833610.244726 */
-		4028562,	/* 4028562.434393 */
-		4219576,	/* 4219575.925308 */
-		4406807,	/* 4406806.721144 */
-		4590402,	/* 4590401.736809 */
-		4770499,	/* 4770499.491025 */
-		4947231,	/* 4947230.734179 */
-		5120719,	/* 5120719.018555 */
-		5291081,	/* 5291081.217197 */
-		5458428,	/* 5458427.996830 */
-		5622864,	/* 5622864.249668 */
-		5784489,	/* 5784489.488298 */
-		5943398,	/* 5943398.207380 */
-		6099680,	/* 6099680.215452 */
-		6253421,	/* 6253420.939751 */
-		6404702,	/* 6404701.706649 */
-		6553600,	/* 6553600.000000 */
-	};
-
-
-	if (x == 0)
-		return 0;
-
-	/* Scale x (normalize) */
-	/* computing y in log(x/y) = log(x) - log(y) */
-	if ((x & ((0xffffffff) << (scale + 1))) == 0) {
-		for (k = scale; k > 0; k--) {
-			if (x & (((u32) 1) << scale))
-				break;
-			x <<= 1;
-		}
-	} else {
-		for (k = scale; k < 31; k++) {
-			if ((x & (((u32) (-1)) << (scale + 1))) == 0)
-				break;
-			x >>= 1;
-		}
-	}
-	/*
-	   Now x has binary point between bit[scale] and bit[scale-1]
-	   and 1.0 <= x < 2.0 */
-
-	/* correction for divison: log(x) = log(x/y)+log(y) */
-	y = k * ((((u32) 1) << scale) * 200);
-
-	/* remove integer part */
-	x &= ((((u32) 1) << scale) - 1);
-	/* get index */
-	i = (u8) (x >> (scale - indexWidth));
-	/* compute delta (x - a) */
-	d = x & ((((u32) 1) << (scale - indexWidth)) - 1);
-	/* compute log, multiplication (d* (..)) must be within range ! */
-	y += log2lut[i] +
-	    ((d * (log2lut[i + 1] - log2lut[i])) >> (scale - indexWidth));
-	/* Conver to log10() */
-	y /= 108853;		/* (log2(10) << scale) */
-	r = (y >> 1);
-	/* rounding */
-	if (y & ((u32) 1))
-		r++;
-	return r;
+	return (100L * intlog10(value)) >> 24;
 }
 
 /****************************************************************************/
@@ -2530,8 +2442,8 @@ static int GetQAMSignalToNoise(struct drxk_state *state,
 	}
 
 	if (qamSlErrPower > 0) {
-		qamSlMer = Log10Times100(qamSlSigPower) -
-			Log10Times100((u32) qamSlErrPower);
+		qamSlMer = log10times100(qamSlSigPower) -
+			log10times100((u32) qamSlErrPower);
 	}
 	*pSignalToNoise = qamSlMer;
 
@@ -2620,12 +2532,12 @@ static int GetDVBTSignalToNoise(struct drxk_state *state,
 			*/
 
 		/* log(x) x = 9bits * 9bits->18 bits  */
-		a = Log10Times100(EqRegTdTpsPwrOfs *
+		a = log10times100(EqRegTdTpsPwrOfs *
 					EqRegTdTpsPwrOfs);
 		/* log(x) x = 16bits * 7bits->23 bits  */
-		b = Log10Times100(EqRegTdReqSmbCnt * tpsCnt);
+		b = log10times100(EqRegTdReqSmbCnt * tpsCnt);
 		/* log(x) x = (16bits + 16bits) << 15 ->32 bits  */
-		c = Log10Times100(SqrErrIQ);
+		c = log10times100(SqrErrIQ);
 
 		iMER = a + b - c;
 	}
-- 
1.8.1.4

