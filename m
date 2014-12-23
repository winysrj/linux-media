Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52955 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbaLWUu2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:28 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/66] rtl2830: get rid of legacy DVB driver binding
Date: Tue, 23 Dec 2014 22:49:00 +0200
Message-Id: <1419367799-14263-7-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove legacy DVB binding as all users are using I2C binding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c      | 101 -----------------------------
 drivers/media/dvb-frontends/rtl2830.h      |  63 ------------------
 drivers/media/dvb-frontends/rtl2830_priv.h |   9 +++
 3 files changed, 9 insertions(+), 164 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index ec4a19c..541e244 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -631,104 +631,6 @@ err:
 	return ret;
 }
 
-static struct dvb_frontend_ops rtl2830_ops;
-
-static u32 rtl2830_tuner_i2c_func(struct i2c_adapter *adapter)
-{
-	return I2C_FUNC_I2C;
-}
-
-static int rtl2830_tuner_i2c_xfer(struct i2c_adapter *i2c_adap,
-	struct i2c_msg msg[], int num)
-{
-	struct rtl2830_priv *priv = i2c_get_adapdata(i2c_adap);
-	int ret;
-
-	/* open i2c-gate */
-	ret = rtl2830_wr_reg_mask(priv, 0x101, 0x08, 0x08);
-	if (ret)
-		goto err;
-
-	ret = i2c_transfer(priv->i2c, msg, num);
-	if (ret < 0)
-		dev_warn(&priv->i2c->dev, "%s: tuner i2c failed=%d\n",
-			KBUILD_MODNAME, ret);
-
-	return ret;
-err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-static struct i2c_algorithm rtl2830_tuner_i2c_algo = {
-	.master_xfer   = rtl2830_tuner_i2c_xfer,
-	.functionality = rtl2830_tuner_i2c_func,
-};
-
-struct i2c_adapter *rtl2830_get_tuner_i2c_adapter(struct dvb_frontend *fe)
-{
-	struct rtl2830_priv *priv = fe->demodulator_priv;
-	return &priv->tuner_i2c_adapter;
-}
-EXPORT_SYMBOL(rtl2830_get_tuner_i2c_adapter);
-
-static void rtl2830_release(struct dvb_frontend *fe)
-{
-	struct rtl2830_priv *priv = fe->demodulator_priv;
-
-	i2c_del_adapter(&priv->tuner_i2c_adapter);
-	kfree(priv);
-}
-
-struct dvb_frontend *rtl2830_attach(const struct rtl2830_config *cfg,
-	struct i2c_adapter *i2c)
-{
-	struct rtl2830_priv *priv = NULL;
-	int ret = 0;
-	u8 tmp;
-
-	/* allocate memory for the internal state */
-	priv = kzalloc(sizeof(struct rtl2830_priv), GFP_KERNEL);
-	if (priv == NULL)
-		goto err;
-
-	/* setup the priv */
-	priv->i2c = i2c;
-	memcpy(&priv->cfg, cfg, sizeof(struct rtl2830_config));
-
-	/* check if the demod is there */
-	ret = rtl2830_rd_reg(priv, 0x000, &tmp);
-	if (ret)
-		goto err;
-
-	/* create dvb_frontend */
-	memcpy(&priv->fe.ops, &rtl2830_ops, sizeof(struct dvb_frontend_ops));
-	priv->fe.demodulator_priv = priv;
-
-	/* create tuner i2c adapter */
-	strlcpy(priv->tuner_i2c_adapter.name, "RTL2830 tuner I2C adapter",
-		sizeof(priv->tuner_i2c_adapter.name));
-	priv->tuner_i2c_adapter.algo = &rtl2830_tuner_i2c_algo;
-	priv->tuner_i2c_adapter.algo_data = NULL;
-	priv->tuner_i2c_adapter.dev.parent = &i2c->dev;
-	i2c_set_adapdata(&priv->tuner_i2c_adapter, priv);
-	if (i2c_add_adapter(&priv->tuner_i2c_adapter) < 0) {
-		dev_err(&i2c->dev,
-				"%s: tuner i2c bus could not be initialized\n",
-				KBUILD_MODNAME);
-		goto err;
-	}
-
-	priv->sleeping = true;
-
-	return &priv->fe;
-err:
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
-	kfree(priv);
-	return NULL;
-}
-EXPORT_SYMBOL(rtl2830_attach);
-
 static struct dvb_frontend_ops rtl2830_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
@@ -750,8 +652,6 @@ static struct dvb_frontend_ops rtl2830_ops = {
 			FE_CAN_MUTE_TS
 	},
 
-	.release = rtl2830_release,
-
 	.init = rtl2830_init,
 	.sleep = rtl2830_sleep,
 
@@ -888,7 +788,6 @@ static int rtl2830_probe(struct i2c_client *client,
 
 	/* create dvb frontend */
 	memcpy(&priv->fe.ops, &rtl2830_ops, sizeof(priv->fe.ops));
-	priv->fe.ops.release = NULL;
 	priv->fe.demodulator_priv = priv;
 
 	/* setup callbacks */
diff --git a/drivers/media/dvb-frontends/rtl2830.h b/drivers/media/dvb-frontends/rtl2830.h
index b925ea5..1d7784d 100644
--- a/drivers/media/dvb-frontends/rtl2830.h
+++ b/drivers/media/dvb-frontends/rtl2830.h
@@ -55,67 +55,4 @@ struct rtl2830_platform_data {
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
 };
 
-struct rtl2830_config {
-	/*
-	 * Demodulator I2C address.
-	 */
-	u8 i2c_addr;
-
-	/*
-	 * Xtal frequency.
-	 * Hz
-	 * 4000000, 16000000, 25000000, 28800000
-	 */
-	u32 xtal;
-
-	/*
-	 * TS output mode.
-	 */
-	u8 ts_mode;
-
-	/*
-	 * Spectrum inversion.
-	 */
-	bool spec_inv;
-
-	/*
-	 */
-	u8 vtop;
-
-	/*
-	 */
-	u8 krf;
-
-	/*
-	 */
-	u8 agc_targ_val;
-};
-
-#if IS_ENABLED(CONFIG_DVB_RTL2830)
-extern struct dvb_frontend *rtl2830_attach(
-	const struct rtl2830_config *config,
-	struct i2c_adapter *i2c
-);
-
-extern struct i2c_adapter *rtl2830_get_tuner_i2c_adapter(
-	struct dvb_frontend *fe
-);
-#else
-static inline struct dvb_frontend *rtl2830_attach(
-	const struct rtl2830_config *config,
-	struct i2c_adapter *i2c
-)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-
-static inline struct i2c_adapter *rtl2830_get_tuner_i2c_adapter(
-	struct dvb_frontend *fe
-)
-{
-	return NULL;
-}
-#endif
-
 #endif /* RTL2830_H */
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index 1a78351..545907a 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -26,6 +26,15 @@
 #include "rtl2830.h"
 #include <linux/i2c-mux.h>
 
+struct rtl2830_config {
+	u8 i2c_addr;
+	u32 xtal;
+	bool spec_inv;
+	u8 vtop;
+	u8 krf;
+	u8 agc_targ_val;
+};
+
 struct rtl2830_priv {
 	struct i2c_adapter *adapter;
 	struct i2c_adapter *i2c;
-- 
http://palosaari.fi/

