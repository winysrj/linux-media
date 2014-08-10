Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaHJArl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:41 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 15/18] [media] au0828: move the code that sets DTV on a separate function
Date: Sat,  9 Aug 2014 21:47:21 -0300
Message-Id: <1407631644-11990-16-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we'll be adding a code to resume tuner operation, we
need to move the code that actually sets DTV on a separate
function, to be called by the resume code.

No functional changes, just code got moved.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 79 ++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 34 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index af137046bfe5..3293fd8df59b 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -59,6 +59,7 @@ struct xc5000_priv {
 	u32 freq_hz, freq_offset;
 	u32 bandwidth;
 	u8  video_standard;
+	unsigned int mode;
 	u8  rf_mode;
 	u8  radio_input;
 
@@ -712,9 +713,50 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	}
 }
 
+static int xc5000_tune_digital(struct dvb_frontend *fe)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	int ret;
+	u32 bw = fe->dtv_property_cache.bandwidth_hz;
+
+	ret = xc_set_signal_source(priv, priv->rf_mode);
+	if (ret != 0) {
+		printk(KERN_ERR
+			"xc5000: xc_set_signal_source(%d) failed\n",
+			priv->rf_mode);
+		return -EREMOTEIO;
+	}
+
+	ret = xc_set_tv_standard(priv,
+		xc5000_standard[priv->video_standard].video_mode,
+		xc5000_standard[priv->video_standard].audio_mode, 0);
+	if (ret != 0) {
+		printk(KERN_ERR "xc5000: xc_set_tv_standard failed\n");
+		return -EREMOTEIO;
+	}
+
+	ret = xc_set_IF_frequency(priv, priv->if_khz);
+	if (ret != 0) {
+		printk(KERN_ERR "xc5000: xc_Set_IF_frequency(%d) failed\n",
+		       priv->if_khz);
+		return -EIO;
+	}
+
+	xc_write_reg(priv, XREG_OUTPUT_AMP, 0x8a);
+
+	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_DIGITAL);
+
+	if (debug)
+		xc_debug_dump(priv);
+
+	priv->bandwidth = bw;
+
+	return 0;
+}
+
 static int xc5000_set_params(struct dvb_frontend *fe)
 {
-	int ret, b;
+	int b;
 	struct xc5000_priv *priv = fe->tuner_priv;
 	u32 bw = fe->dtv_property_cache.bandwidth_hz;
 	u32 freq = fe->dtv_property_cache.frequency;
@@ -794,43 +836,12 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 	}
 
 	priv->freq_hz = freq - priv->freq_offset;
+	priv->mode = V4L2_TUNER_DIGITAL_TV;
 
 	dprintk(1, "%s() frequency=%d (compensated to %d)\n",
 		__func__, freq, priv->freq_hz);
 
-	ret = xc_set_signal_source(priv, priv->rf_mode);
-	if (ret != 0) {
-		printk(KERN_ERR
-			"xc5000: xc_set_signal_source(%d) failed\n",
-			priv->rf_mode);
-		return -EREMOTEIO;
-	}
-
-	ret = xc_set_tv_standard(priv,
-		xc5000_standard[priv->video_standard].video_mode,
-		xc5000_standard[priv->video_standard].audio_mode, 0);
-	if (ret != 0) {
-		printk(KERN_ERR "xc5000: xc_set_tv_standard failed\n");
-		return -EREMOTEIO;
-	}
-
-	ret = xc_set_IF_frequency(priv, priv->if_khz);
-	if (ret != 0) {
-		printk(KERN_ERR "xc5000: xc_Set_IF_frequency(%d) failed\n",
-		       priv->if_khz);
-		return -EIO;
-	}
-
-	xc_write_reg(priv, XREG_OUTPUT_AMP, 0x8a);
-
-	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_DIGITAL);
-
-	if (debug)
-		xc_debug_dump(priv);
-
-	priv->bandwidth = bw;
-
-	return 0;
+	return xc5000_tune_digital(fe);
 }
 
 static int xc5000_is_firmware_loaded(struct dvb_frontend *fe)
-- 
1.9.3

