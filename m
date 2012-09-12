Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39762 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758186Ab2ILC1v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 22:27:51 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Thomas Mair <mair.thomas86@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 8/8] rtl2832: use dev_foo() logging
Date: Wed, 12 Sep 2012 05:27:11 +0300
Message-Id: <1347416831-1413-8-git-send-email-crope@iki.fi>
In-Reply-To: <1347416831-1413-1-git-send-email-crope@iki.fi>
References: <1347416831-1413-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 64 +++++++++++++++---------------
 drivers/media/dvb-frontends/rtl2832.h      |  2 +-
 drivers/media/dvb-frontends/rtl2832_priv.h | 15 -------
 3 files changed, 33 insertions(+), 48 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 8f8a5b0..aaf0c29 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -179,7 +179,8 @@ static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		warn("i2c wr failed=%d reg=%02x len=%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -207,10 +208,11 @@ static int rtl2832_rd(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		warn("i2c rd failed=%d reg=%02x len=%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
-}
-return ret;
+	}
+	return ret;
 }
 
 /* write multiple registers */
@@ -219,7 +221,6 @@ static int rtl2832_wr_regs(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val,
 {
 	int ret;
 
-
 	/* switch bank if needed */
 	if (page != priv->page) {
 		ret = rtl2832_wr(priv, 0x00, &page, 1);
@@ -299,7 +300,7 @@ int rtl2832_rd_demod_reg(struct rtl2832_priv *priv, int reg, u32 *val)
 	return ret;
 
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 
 }
@@ -351,7 +352,7 @@ int rtl2832_wr_demod_reg(struct rtl2832_priv *priv, int reg, u32 val)
 	return ret;
 
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 
 }
@@ -361,7 +362,7 @@ static int rtl2832_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	int ret;
 	struct rtl2832_priv *priv = fe->demodulator_priv;
 
-	dbg("%s: enable=%d", __func__, enable);
+	dev_dbg(&priv->i2c->dev, "%s: enable=%d\n", __func__, enable);
 
 	/* gate already open or close */
 	if (priv->i2c_gate_state == enable)
@@ -375,7 +376,7 @@ static int rtl2832_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -434,7 +435,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
 		{DVBT_SPEC_INV,			0x0},
 	};
 
-	dbg("%s", __func__);
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 
 	en_bbin = (priv->cfg.if_dvbt == 0 ? 0x1 : 0x0);
 
@@ -455,7 +456,8 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	}
 
 	/* load tuner specific settings */
-	dbg("%s: load settings for tuner=%02x", __func__, priv->cfg.tuner);
+	dev_dbg(&priv->i2c->dev, "%s: load settings for tuner=%02x\n",
+			__func__, priv->cfg.tuner);
 	switch (priv->cfg.tuner) {
 	case RTL2832_TUNER_FC0012:
 	case RTL2832_TUNER_FC0013:
@@ -491,7 +493,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	return ret;
 
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -499,7 +501,7 @@ static int rtl2832_sleep(struct dvb_frontend *fe)
 {
 	struct rtl2832_priv *priv = fe->demodulator_priv;
 
-	dbg("%s", __func__);
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 	priv->sleeping = true;
 	return 0;
 }
@@ -507,7 +509,9 @@ static int rtl2832_sleep(struct dvb_frontend *fe)
 int rtl2832_get_tune_settings(struct dvb_frontend *fe,
 	struct dvb_frontend_tune_settings *s)
 {
-	dbg("%s", __func__);
+	struct rtl2832_priv *priv = fe->demodulator_priv;
+
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 	s->min_delay_ms = 1000;
 	s->step_size = fe->ops.info.frequency_stepsize * 2;
 	s->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
@@ -521,8 +525,6 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	int ret, i, j;
 	u64 bw_mode, num, num2;
 	u32 resamp_ratio, cfreq_off_ratio;
-
-
 	static u8 bw_params[3][32] = {
 	/* 6 MHz bandwidth */
 		{
@@ -550,15 +552,14 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	};
 
 
-	dbg("%s: frequency=%d bandwidth_hz=%d inversion=%d", __func__,
-		c->frequency, c->bandwidth_hz, c->inversion);
-
+	dev_dbg(&priv->i2c->dev, "%s: frequency=%d bandwidth_hz=%d " \
+			"inversion=%d\n", __func__, c->frequency,
+			c->bandwidth_hz, c->inversion);
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
 
-
 	switch (c->bandwidth_hz) {
 	case 6000000:
 		i = 0;
@@ -573,7 +574,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 		bw_mode = 64000000;
 		break;
 	default:
-		dbg("invalid bandwidth");
+		dev_dbg(&priv->i2c->dev, "%s: invalid bandwidth\n", __func__);
 		return -EINVAL;
 	}
 
@@ -620,7 +621,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	info("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -642,7 +643,7 @@ static int rtl2832_get_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dbg("%s: TPS=%*ph", __func__, 3, buf);
+	dev_dbg(&priv->i2c->dev, "%s: TPS=%*ph\n", __func__, 3, buf);
 
 	switch ((buf[0] >> 2) & 3) {
 	case 0:
@@ -732,7 +733,7 @@ static int rtl2832_get_frontend(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -743,8 +744,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	u32 tmp;
 	*status = 0;
 
-
-	dbg("%s", __func__);
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 	if (priv->sleeping)
 		return 0;
 
@@ -764,7 +764,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return ret;
 err:
-	info("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -810,7 +810,7 @@ static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -828,7 +828,7 @@ static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 	return 0;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -838,7 +838,7 @@ static void rtl2832_release(struct dvb_frontend *fe)
 {
 	struct rtl2832_priv *priv = fe->demodulator_priv;
 
-	dbg("%s", __func__);
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 	kfree(priv);
 }
 
@@ -849,7 +849,7 @@ struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
 	int ret = 0;
 	u8 tmp;
 
-	dbg("%s", __func__);
+	dev_dbg(&i2c->dev, "%s:\n", __func__);
 
 	/* allocate memory for the internal state */
 	priv = kzalloc(sizeof(struct rtl2832_priv), GFP_KERNEL);
@@ -875,7 +875,7 @@ struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
 
 	return &priv->fe;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
 	kfree(priv);
 	return NULL;
 }
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index f7cb09a..c4a6118 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -65,7 +65,7 @@ static inline struct dvb_frontend *rtl2832_attach(
 	struct i2c_adapter *i2c
 )
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 75af963..5e68955 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -24,21 +24,6 @@
 #include "dvb_frontend.h"
 #include "rtl2832.h"
 
-#define LOG_PREFIX "rtl2832"
-
-#undef dbg
-#define dbg(f, arg...) \
-do { \
-	if (rtl2832_debug)  \
-		printk(KERN_INFO     LOG_PREFIX": " f "\n" , ## arg); \
-} while (0)
-#undef err
-#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
-#undef info
-#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
-#undef warn
-#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
-
 struct rtl2832_priv {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
-- 
1.7.11.4

