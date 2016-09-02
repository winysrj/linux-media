Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60869 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753239AbcIBWht (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 18:37:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/9] cxd2820r: improve IF frequency setting
Date: Sat,  3 Sep 2016 01:37:16 +0300
Message-Id: <1472855844-8665-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use 64-bit calculation.

Return error if tuner does not provide get_if_frequency() callback.
All currently used tuners has it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r_c.c    | 26 +++++++++++------------
 drivers/media/dvb-frontends/cxd2820r_priv.h |  2 ++
 drivers/media/dvb-frontends/cxd2820r_t.c    | 27 ++++++++++++-----------
 drivers/media/dvb-frontends/cxd2820r_t2.c   | 33 ++++++++++++++---------------
 4 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index a674a63..957ec94 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -26,10 +26,9 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
+	unsigned int utmp;
 	u8 buf[2];
-	u32 if_freq;
-	u16 if_ctl;
-	u64 num;
+	u32 if_frequency;
 	struct reg_val_mask tab[] = {
 		{ 0x00080, 0x01, 0xff },
 		{ 0x00081, 0x05, 0xff },
@@ -69,20 +68,19 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 
 	/* program IF frequency */
 	if (fe->ops.tuner_ops.get_if_frequency) {
-		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_freq);
+		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
 		if (ret)
 			goto error;
-	} else
-		if_freq = 0;
-
-	dev_dbg(&priv->i2c->dev, "%s: if_freq=%d\n", __func__, if_freq);
-
-	num = if_freq / 1000; /* Hz => kHz */
-	num *= 0x4000;
-	if_ctl = 0x4000 - DIV_ROUND_CLOSEST_ULL(num, 41000);
-	buf[0] = (if_ctl >> 8) & 0x3f;
-	buf[1] = (if_ctl >> 0) & 0xff;
+		dev_dbg(&priv->i2c->dev, "%s: if_frequency=%u\n", __func__,
+			if_frequency);
+	} else {
+		ret = -EINVAL;
+		goto error;
+	}
 
+	utmp = 0x4000 - DIV_ROUND_CLOSEST_ULL((u64)if_frequency * 0x4000, CXD2820R_CLK);
+	buf[0] = (utmp >> 8) & 0xff;
+	buf[1] = (utmp >> 0) & 0xff;
 	ret = cxd2820r_wr_regs(priv, 0x10042, buf, 2);
 	if (ret)
 		goto error;
diff --git a/drivers/media/dvb-frontends/cxd2820r_priv.h b/drivers/media/dvb-frontends/cxd2820r_priv.h
index e31c48e..acfae17 100644
--- a/drivers/media/dvb-frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb-frontends/cxd2820r_priv.h
@@ -34,6 +34,8 @@ struct reg_val_mask {
 	u8  mask;
 };
 
+#define CXD2820R_CLK 41000000
+
 struct cxd2820r_priv {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index 75ce7d8..67cc33b 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -26,8 +26,8 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, bw_i;
-	u32 if_freq, if_ctl;
-	u64 num;
+	unsigned int utmp;
+	u32 if_frequency;
 	u8 buf[3], bw_param;
 	u8 bw_params1[][5] = {
 		{ 0x17, 0xea, 0xaa, 0xaa, 0xaa }, /* 6 MHz */
@@ -93,21 +93,20 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 
 	/* program IF frequency */
 	if (fe->ops.tuner_ops.get_if_frequency) {
-		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_freq);
+		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
 		if (ret)
 			goto error;
-	} else
-		if_freq = 0;
-
-	dev_dbg(&priv->i2c->dev, "%s: if_freq=%d\n", __func__, if_freq);
-
-	num = if_freq / 1000; /* Hz => kHz */
-	num *= 0x1000000;
-	if_ctl = DIV_ROUND_CLOSEST_ULL(num, 41000);
-	buf[0] = ((if_ctl >> 16) & 0xff);
-	buf[1] = ((if_ctl >>  8) & 0xff);
-	buf[2] = ((if_ctl >>  0) & 0xff);
+		dev_dbg(&priv->i2c->dev, "%s: if_frequency=%u\n", __func__,
+			if_frequency);
+	} else {
+		ret = -EINVAL;
+		goto error;
+	}
 
+	utmp = DIV_ROUND_CLOSEST_ULL((u64)if_frequency * 0x1000000, CXD2820R_CLK);
+	buf[0] = (utmp >> 16) & 0xff;
+	buf[1] = (utmp >>  8) & 0xff;
+	buf[2] = (utmp >>  0) & 0xff;
 	ret = cxd2820r_wr_regs(priv, 0x000b6, buf, 3);
 	if (ret)
 		goto error;
diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index 7044756..14c9a26 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -26,8 +26,8 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret, i, bw_i;
-	u32 if_freq, if_ctl;
-	u64 num;
+	unsigned int utmp;
+	u32 if_frequency;
 	u8 buf[3], bw_param;
 	u8 bw_params1[][5] = {
 		{ 0x1c, 0xb3, 0x33, 0x33, 0x33 }, /* 5 MHz */
@@ -110,20 +110,23 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 
 	/* program IF frequency */
 	if (fe->ops.tuner_ops.get_if_frequency) {
-		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_freq);
+		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
 		if (ret)
 			goto error;
-	} else
-		if_freq = 0;
-
-	dev_dbg(&priv->i2c->dev, "%s: if_freq=%d\n", __func__, if_freq);
+		dev_dbg(&priv->i2c->dev, "%s: if_frequency=%u\n", __func__,
+			if_frequency);
+	} else {
+		ret = -EINVAL;
+		goto error;
+	}
 
-	num = if_freq / 1000; /* Hz => kHz */
-	num *= 0x1000000;
-	if_ctl = DIV_ROUND_CLOSEST_ULL(num, 41000);
-	buf[0] = ((if_ctl >> 16) & 0xff);
-	buf[1] = ((if_ctl >>  8) & 0xff);
-	buf[2] = ((if_ctl >>  0) & 0xff);
+	utmp = DIV_ROUND_CLOSEST_ULL((u64)if_frequency * 0x1000000, CXD2820R_CLK);
+	buf[0] = (utmp >> 16) & 0xff;
+	buf[1] = (utmp >>  8) & 0xff;
+	buf[2] = (utmp >>  0) & 0xff;
+	ret = cxd2820r_wr_regs(priv, 0x020b6, buf, 3);
+	if (ret)
+		goto error;
 
 	/* PLP filtering */
 	if (c->stream_id > 255) {
@@ -142,10 +145,6 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 			goto error;
 	}
 
-	ret = cxd2820r_wr_regs(priv, 0x020b6, buf, 3);
-	if (ret)
-		goto error;
-
 	ret = cxd2820r_wr_regs(priv, 0x0209f, bw_params1[bw_i], 5);
 	if (ret)
 		goto error;
-- 
http://palosaari.fi/

