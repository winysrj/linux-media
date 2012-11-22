Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34671 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758514Ab2KVXDw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 18:03:52 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] fc2580: write some registers conditionally
Date: Fri, 23 Nov 2012 01:03:12 +0200
Message-Id: <1353625392-4974-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was a bad idea, as comment also says, to write some "don't care"
registers as 0xff value. Fix it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc2580.c | 61 +++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index aff39ae..81f38aa 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -35,8 +35,6 @@
  * Currently it blind writes bunch of static registers from the
  * fc2580_freq_regs_lut[] when fc2580_set_params() is called. Add some
  * logic to reduce unneeded register writes.
- * There is also don't-care registers, initialized with value 0xff, and those
- * are also written to the chip currently (yes, not wise).
  */
 
 /* write multiple registers */
@@ -111,6 +109,17 @@ static int fc2580_rd_reg(struct fc2580_priv *priv, u8 reg, u8 *val)
 	return fc2580_rd_regs(priv, reg, val, 1);
 }
 
+/* write single register conditionally only when value differs from 0xff
+ * XXX: This is special routine meant only for writing fc2580_freq_regs_lut[]
+ * values. Do not use for the other purposes. */
+static int fc2580_wr_reg_ff(struct fc2580_priv *priv, u8 reg, u8 val)
+{
+	if (val == 0xff)
+		return 0;
+	else
+		return fc2580_wr_regs(priv, reg, &val, 1);
+}
+
 static int fc2580_set_params(struct dvb_frontend *fe)
 {
 	struct fc2580_priv *priv = fe->tuner_priv;
@@ -213,99 +222,99 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	if (i == ARRAY_SIZE(fc2580_freq_regs_lut))
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x25, fc2580_freq_regs_lut[i].r25_val);
+	ret = fc2580_wr_reg_ff(priv, 0x25, fc2580_freq_regs_lut[i].r25_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x27, fc2580_freq_regs_lut[i].r27_val);
+	ret = fc2580_wr_reg_ff(priv, 0x27, fc2580_freq_regs_lut[i].r27_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x28, fc2580_freq_regs_lut[i].r28_val);
+	ret = fc2580_wr_reg_ff(priv, 0x28, fc2580_freq_regs_lut[i].r28_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x29, fc2580_freq_regs_lut[i].r29_val);
+	ret = fc2580_wr_reg_ff(priv, 0x29, fc2580_freq_regs_lut[i].r29_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x2b, fc2580_freq_regs_lut[i].r2b_val);
+	ret = fc2580_wr_reg_ff(priv, 0x2b, fc2580_freq_regs_lut[i].r2b_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x2c, fc2580_freq_regs_lut[i].r2c_val);
+	ret = fc2580_wr_reg_ff(priv, 0x2c, fc2580_freq_regs_lut[i].r2c_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x2d, fc2580_freq_regs_lut[i].r2d_val);
+	ret = fc2580_wr_reg_ff(priv, 0x2d, fc2580_freq_regs_lut[i].r2d_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x30, fc2580_freq_regs_lut[i].r30_val);
+	ret = fc2580_wr_reg_ff(priv, 0x30, fc2580_freq_regs_lut[i].r30_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x44, fc2580_freq_regs_lut[i].r44_val);
+	ret = fc2580_wr_reg_ff(priv, 0x44, fc2580_freq_regs_lut[i].r44_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x50, fc2580_freq_regs_lut[i].r50_val);
+	ret = fc2580_wr_reg_ff(priv, 0x50, fc2580_freq_regs_lut[i].r50_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x53, fc2580_freq_regs_lut[i].r53_val);
+	ret = fc2580_wr_reg_ff(priv, 0x53, fc2580_freq_regs_lut[i].r53_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x5f, fc2580_freq_regs_lut[i].r5f_val);
+	ret = fc2580_wr_reg_ff(priv, 0x5f, fc2580_freq_regs_lut[i].r5f_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x61, fc2580_freq_regs_lut[i].r61_val);
+	ret = fc2580_wr_reg_ff(priv, 0x61, fc2580_freq_regs_lut[i].r61_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x62, fc2580_freq_regs_lut[i].r62_val);
+	ret = fc2580_wr_reg_ff(priv, 0x62, fc2580_freq_regs_lut[i].r62_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x63, fc2580_freq_regs_lut[i].r63_val);
+	ret = fc2580_wr_reg_ff(priv, 0x63, fc2580_freq_regs_lut[i].r63_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x67, fc2580_freq_regs_lut[i].r67_val);
+	ret = fc2580_wr_reg_ff(priv, 0x67, fc2580_freq_regs_lut[i].r67_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x68, fc2580_freq_regs_lut[i].r68_val);
+	ret = fc2580_wr_reg_ff(priv, 0x68, fc2580_freq_regs_lut[i].r68_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x69, fc2580_freq_regs_lut[i].r69_val);
+	ret = fc2580_wr_reg_ff(priv, 0x69, fc2580_freq_regs_lut[i].r69_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x6a, fc2580_freq_regs_lut[i].r6a_val);
+	ret = fc2580_wr_reg_ff(priv, 0x6a, fc2580_freq_regs_lut[i].r6a_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x6b, fc2580_freq_regs_lut[i].r6b_val);
+	ret = fc2580_wr_reg_ff(priv, 0x6b, fc2580_freq_regs_lut[i].r6b_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x6c, fc2580_freq_regs_lut[i].r6c_val);
+	ret = fc2580_wr_reg_ff(priv, 0x6c, fc2580_freq_regs_lut[i].r6c_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x6d, fc2580_freq_regs_lut[i].r6d_val);
+	ret = fc2580_wr_reg_ff(priv, 0x6d, fc2580_freq_regs_lut[i].r6d_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x6e, fc2580_freq_regs_lut[i].r6e_val);
+	ret = fc2580_wr_reg_ff(priv, 0x6e, fc2580_freq_regs_lut[i].r6e_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x6f, fc2580_freq_regs_lut[i].r6f_val);
+	ret = fc2580_wr_reg_ff(priv, 0x6f, fc2580_freq_regs_lut[i].r6f_val);
 	if (ret < 0)
 		goto err;
 
-- 
1.7.11.7

