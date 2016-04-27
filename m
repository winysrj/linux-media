Return-path: <linux-media-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:46290 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbcD0HIc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 03:08:32 -0400
From: zengzhaoxiu@163.com
To: linux-kernel@vger.kernel.org
Cc: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] media: tuner: mt2063: use lib gcd
Date: Wed, 27 Apr 2016 15:07:08 +0800
Message-Id: <1461740828-23472-1-git-send-email-zengzhaoxiu@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>

This patch removes the local MT2063_gcd function, uses lib gcd instead

Signed-off-by: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
---
 drivers/media/tuners/mt2063.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 6457ac9..7f0b9d5 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/videodev2.h>
+#include <linux/gcd.h>
 
 #include "mt2063.h"
 
@@ -665,27 +666,6 @@ static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 }
 
 /**
- * gcd() - Uses Euclid's algorithm
- *
- * @u, @v:	Unsigned values whose GCD is desired.
- *
- * Returns THE greatest common divisor of u and v, if either value is 0,
- * the other value is returned as the result.
- */
-static u32 MT2063_gcd(u32 u, u32 v)
-{
-	u32 r;
-
-	while (v != 0) {
-		r = u % v;
-		u = v;
-		v = r;
-	}
-
-	return u;
-}
-
-/**
  * IsSpurInBand() - Checks to see if a spur will be present within the IF's
  *                  bandwidth. (fIFOut +/- fIFBW, -fIFOut +/- fIFBW)
  *
@@ -731,12 +711,12 @@ static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 	 ** of f_LO1, f_LO2 and the edge value.  Use the larger of this
 	 ** gcd-based scale factor or f_Scale.
 	 */
-	lo_gcd = MT2063_gcd(f_LO1, f_LO2);
-	gd_Scale = max((u32) MT2063_gcd(lo_gcd, d), f_Scale);
+	lo_gcd = gcd(f_LO1, f_LO2);
+	gd_Scale = max((u32) gcd(lo_gcd, d), f_Scale);
 	hgds = gd_Scale / 2;
-	gc_Scale = max((u32) MT2063_gcd(lo_gcd, c), f_Scale);
+	gc_Scale = max((u32) gcd(lo_gcd, c), f_Scale);
 	hgcs = gc_Scale / 2;
-	gf_Scale = max((u32) MT2063_gcd(lo_gcd, f), f_Scale);
+	gf_Scale = max((u32) gcd(lo_gcd, f), f_Scale);
 	hgfs = gf_Scale / 2;
 
 	n0 = DIV_ROUND_UP(f_LO2 - d, f_LO1 - f_LO2);
-- 
2.5.0


