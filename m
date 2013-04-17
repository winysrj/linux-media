Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab3DQAm4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:56 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0guH1021077
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 20/31] [media] r820t: proper initialize the PLL register
Date: Tue, 16 Apr 2013 21:42:31 -0300
Message-Id: <1366159362-3773-21-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rtl-sdr library, from where this driver was initially
based, doesn't use half PLL clock, but this is used on
the Realtek Kernel driver. So, also do the same here.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 43 ++++++++++++++++++++++++++++---------------
 drivers/media/tuners/r820t.h |  3 +++
 2 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 279be4f..07d0323 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -522,10 +522,12 @@ static int r820t_set_mux(struct r820t_priv *priv, u32 freq)
 	return rc;
 }
 
-static int r820t_set_pll(struct r820t_priv *priv, u32 freq)
+static int r820t_set_pll(struct r820t_priv *priv, enum v4l2_tuner_type type,
+			 u32 freq)
 {
 	u64 tmp64, vco_freq;
 	int rc, i;
+	unsigned sleep_time = 10000;
 	u32 vco_fra;		/* VCO contribution by SDM (kHz) */
 	u32 vco_min  = 1770000;
 	u32 vco_max  = vco_min * 2;
@@ -535,17 +537,34 @@ static int r820t_set_pll(struct r820t_priv *priv, u32 freq)
 	u8 mix_div = 2;
 	u8 div_buf = 0;
 	u8 div_num = 0;
+	u8 refdiv2 = 0;
 	u8 ni, si, nint, vco_fine_tune, val;
 	u8 data[5];
 
-	freq = freq / 1000;	/* Frequency in kHz */
-
+	/* Frequency in kHz */
+	freq = freq / 1000;
 	pll_ref = priv->cfg->xtal / 1000;
 
-	tuner_dbg("set r820t pll for frequency %d kHz = %d\n", freq, pll_ref);
+	if ((priv->cfg->rafael_chip == CHIP_R620D) ||
+	   (priv->cfg->rafael_chip == CHIP_R828D) ||
+	   (priv->cfg->rafael_chip == CHIP_R828)) {
+		/* ref set refdiv2, reffreq = Xtal/2 on ATV application */
+		if (type != V4L2_TUNER_DIGITAL_TV) {
+			pll_ref /= 2;
+			refdiv2 = 0x10;
+			sleep_time = 20000;
+		}
+	} else {
+		if (priv->cfg->xtal > 24000000) {
+			pll_ref /= 2;
+			refdiv2 = 0x10;
+		}
+	}
 
-	/* FIXME: this seems to be a hack - probably it can be removed */
-	rc = r820t_write_reg_mask(priv, 0x10, 0x00, 0x00);
+	tuner_dbg("set r820t pll for frequency %d kHz = %d%s\n",
+		  freq, pll_ref, refdiv2 ? " / 2" : "");
+
+	rc = r820t_write_reg_mask(priv, 0x10, refdiv2, 0x10);
 	if (rc < 0)
 		return rc;
 
@@ -598,8 +617,6 @@ static int r820t_set_pll(struct r820t_priv *priv, u32 freq)
 	do_div(tmp64, 1000);
 	vco_fra  = (u16)(tmp64);
 
-	pll_ref /= 1000;
-
 	/* boundary spur prevention */
 	if (vco_fra < pll_ref / 64) {
 		vco_fra = 0;
@@ -653,11 +670,7 @@ static int r820t_set_pll(struct r820t_priv *priv, u32 freq)
 		return rc;
 
 	for (i = 0; i < 2; i++) {
-		/*
-		 * FIXME: Rafael chips R620D, R828D and R828 seems to
-		 * need 20 ms for analog TV
-		 */
-		usleep_range(10000, 11000);
+		usleep_range(sleep_time, sleep_time + 1000);
 
 		/* Check if PLL has locked */
 		rc = r820t_read(priv, 0x00, data, 3);
@@ -1040,7 +1053,7 @@ static int r820t_set_tv_standard(struct r820t_priv *priv,
 			if (rc < 0)
 				return rc;
 
-			rc = r820t_set_pll(priv, filt_cal_lo);
+			rc = r820t_set_pll(priv, type, filt_cal_lo);
 			if (rc < 0 || !priv->has_lock)
 				return rc;
 
@@ -1244,7 +1257,7 @@ static int generic_set_freq(struct dvb_frontend *fe,
 	if (rc < 0)
 		goto err;
 
-	rc = r820t_set_pll(priv, lo_freq);
+	rc = r820t_set_pll(priv, type, lo_freq);
 	if (rc < 0 || !priv->has_lock)
 		goto err;
 
diff --git a/drivers/media/tuners/r820t.h b/drivers/media/tuners/r820t.h
index 949575a..4c0823b 100644
--- a/drivers/media/tuners/r820t.h
+++ b/drivers/media/tuners/r820t.h
@@ -26,6 +26,9 @@
 
 enum r820t_chip {
 	CHIP_R820T,
+	CHIP_R620D,
+	CHIP_R828D,
+	CHIP_R828,
 	CHIP_R828S,
 	CHIP_R820C,
 };
-- 
1.8.1.4

