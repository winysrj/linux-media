Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab3DQAnA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:43:00 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0h0wm021084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:43:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 26/31] [media] r820t: fix PLL calculus
Date: Tue, 16 Apr 2013 21:42:37 -0300
Message-Id: <1366159362-3773-27-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a few errors at the PLL calculus, causing the device
to use wrong values.
While here, change the calculus to use 32 bits, as there's no
need for 64 bits there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index b679a3f..f5a5fb0 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -36,7 +36,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/bitrev.h>
-#include <asm/div64.h>
 
 #include "tuner-i2c.h"
 #include "r820t.h"
@@ -540,7 +539,7 @@ static int r820t_set_mux(struct r820t_priv *priv, u32 freq)
 static int r820t_set_pll(struct r820t_priv *priv, enum v4l2_tuner_type type,
 			 u32 freq)
 {
-	u64 tmp64, vco_freq;
+	u32 vco_freq;
 	int rc, i;
 	unsigned sleep_time = 10000;
 	u32 vco_fra;		/* VCO contribution by SDM (kHz) */
@@ -576,9 +575,6 @@ static int r820t_set_pll(struct r820t_priv *priv, enum v4l2_tuner_type type,
 		}
 	}
 
-	tuner_dbg("set r820t pll for frequency %d kHz = %d%s\n",
-		  freq, pll_ref, refdiv2 ? " / 2" : "");
-
 	rc = r820t_write_reg_mask(priv, 0x10, refdiv2, 0x10);
 	if (rc < 0)
 		return rc;
@@ -622,15 +618,9 @@ static int r820t_set_pll(struct r820t_priv *priv, enum v4l2_tuner_type type,
 	if (rc < 0)
 		return rc;
 
-	vco_freq = (u64)(freq * (u64)mix_div);
-
-	tmp64 = vco_freq;
-	do_div(tmp64, 2 * pll_ref);
-	nint = (u8)tmp64;
-
-	tmp64 = vco_freq - ((u64)2) * pll_ref * nint;
-	do_div(tmp64, 1000);
-	vco_fra  = (u16)(tmp64);
+	vco_freq = freq * mix_div;
+	nint = vco_freq / (2 * pll_ref);
+	vco_fra = vco_freq - 2 * pll_ref * nint;
 
 	/* boundary spur prevention */
 	if (vco_fra < pll_ref / 64) {
@@ -677,10 +667,13 @@ static int r820t_set_pll(struct r820t_priv *priv, enum v4l2_tuner_type type,
 		n_sdm = n_sdm << 1;
 	}
 
-	rc = r820t_write_reg_mask(priv, 0x16, sdm >> 8, 0x08);
+	tuner_dbg("freq %d kHz, pll ref %d%s, sdm=0x%04x\n",
+		  freq, pll_ref, refdiv2 ? " / 2" : "", sdm);
+
+	rc = r820t_write_reg(priv, 0x16, sdm >> 8);
 	if (rc < 0)
 		return rc;
-	rc = r820t_write_reg_mask(priv, 0x15, sdm & 0xff, 0x08);
+	rc = r820t_write_reg(priv, 0x15, sdm & 0xff);
 	if (rc < 0)
 		return rc;
 
@@ -1068,7 +1061,7 @@ static int r820t_set_tv_standard(struct r820t_priv *priv,
 			if (rc < 0)
 				return rc;
 
-			rc = r820t_set_pll(priv, type, filt_cal_lo);
+			rc = r820t_set_pll(priv, type, filt_cal_lo * 1000);
 			if (rc < 0 || !priv->has_lock)
 				return rc;
 
-- 
1.8.1.4

