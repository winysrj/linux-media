Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34266 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624AbaLWUub (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:31 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 25/66] rtl2832: remove exported resources
Date: Tue, 23 Dec 2014 22:49:18 +0200
Message-Id: <1419367799-14263-25-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exported resources are not needed anymore as all users are using
callbacks carried via platform data. Due to that we will remove
those.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 138 ----------------------------------
 drivers/media/dvb-frontends/rtl2832.h |  60 ---------------
 2 files changed, 198 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 4e77ef2..7047320 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -886,19 +886,6 @@ err:
 	return ret;
 }
 
-static struct dvb_frontend_ops rtl2832_ops;
-
-static void rtl2832_release(struct dvb_frontend *fe)
-{
-	struct rtl2832_priv *priv = fe->demodulator_priv;
-
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-	cancel_delayed_work_sync(&priv->i2c_gate_work);
-	i2c_del_mux_adapter(priv->i2c_adapter_tuner);
-	i2c_del_mux_adapter(priv->i2c_adapter);
-	kfree(priv);
-}
-
 /*
  * Delay mechanism to avoid unneeded I2C gate open / close. Gate close is
  * delayed here a little bit in order to see if there is sequence of I2C
@@ -1022,126 +1009,6 @@ static int rtl2832_deselect(struct i2c_adapter *adap, void *mux_priv,
 	return 0;
 }
 
-int rtl2832_enable_external_ts_if(struct dvb_frontend *fe)
-{
-	struct rtl2832_priv *priv = fe->demodulator_priv;
-	int ret;
-
-	dev_dbg(&priv->i2c->dev, "%s: setting PIP mode\n", __func__);
-
-	ret = rtl2832_wr_regs(priv, 0x0c, 1, "\x5f\xff", 2);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_wr_demod_reg(priv, DVBT_PIP_ON, 0x1);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_wr_reg(priv, 0xbc, 0, 0x18);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_wr_reg(priv, 0x22, 0, 0x01);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_wr_reg(priv, 0x26, 0, 0x1f);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_wr_reg(priv, 0x27, 0, 0xff);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_wr_regs(priv, 0x92, 1, "\x7f\xf7\xff", 3);
-	if (ret)
-		goto err;
-
-	/* soft reset */
-	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x1);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x0);
-	if (ret)
-		goto err;
-
-	return 0;
-err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-
-}
-EXPORT_SYMBOL(rtl2832_enable_external_ts_if);
-
-struct i2c_adapter *rtl2832_get_i2c_adapter(struct dvb_frontend *fe)
-{
-	struct rtl2832_priv *priv = fe->demodulator_priv;
-	return priv->i2c_adapter_tuner;
-}
-EXPORT_SYMBOL(rtl2832_get_i2c_adapter);
-
-struct i2c_adapter *rtl2832_get_private_i2c_adapter(struct dvb_frontend *fe)
-{
-	struct rtl2832_priv *priv = fe->demodulator_priv;
-	return priv->i2c_adapter;
-}
-EXPORT_SYMBOL(rtl2832_get_private_i2c_adapter);
-
-struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
-	struct i2c_adapter *i2c)
-{
-	struct rtl2832_priv *priv = NULL;
-	int ret = 0;
-	u8 tmp;
-
-	dev_dbg(&i2c->dev, "%s:\n", __func__);
-
-	/* allocate memory for the internal state */
-	priv = kzalloc(sizeof(struct rtl2832_priv), GFP_KERNEL);
-	if (priv == NULL)
-		goto err;
-
-	/* setup the priv */
-	priv->i2c = i2c;
-	priv->tuner = cfg->tuner;
-	memcpy(&priv->cfg, cfg, sizeof(struct rtl2832_config));
-	INIT_DELAYED_WORK(&priv->i2c_gate_work, rtl2832_i2c_gate_work);
-
-	/* create muxed i2c adapter for demod itself */
-	priv->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, priv, 0, 0, 0,
-			rtl2832_select, NULL);
-	if (priv->i2c_adapter == NULL)
-		goto err;
-
-	/* check if the demod is there */
-	ret = rtl2832_rd_reg(priv, 0x00, 0x0, &tmp);
-	if (ret)
-		goto err;
-
-	/* create muxed i2c adapter for demod tuner bus */
-	priv->i2c_adapter_tuner = i2c_add_mux_adapter(i2c, &i2c->dev, priv,
-			0, 1, 0, rtl2832_select, rtl2832_deselect);
-	if (priv->i2c_adapter_tuner == NULL)
-		goto err;
-
-	/* create dvb_frontend */
-	memcpy(&priv->fe.ops, &rtl2832_ops, sizeof(struct dvb_frontend_ops));
-	priv->fe.demodulator_priv = priv;
-
-	/* TODO implement sleep mode */
-	priv->sleeping = true;
-
-	return &priv->fe;
-err:
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
-	if (priv && priv->i2c_adapter)
-		i2c_del_mux_adapter(priv->i2c_adapter);
-	kfree(priv);
-	return NULL;
-}
-EXPORT_SYMBOL(rtl2832_attach);
-
 static struct dvb_frontend_ops rtl2832_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
@@ -1166,8 +1033,6 @@ static struct dvb_frontend_ops rtl2832_ops = {
 			FE_CAN_MUTE_TS
 	 },
 
-	.release = rtl2832_release,
-
 	.init = rtl2832_init,
 	.sleep = rtl2832_sleep,
 
@@ -1312,11 +1177,8 @@ static int rtl2832_probe(struct i2c_client *client,
 
 	/* create dvb_frontend */
 	memcpy(&priv->fe.ops, &rtl2832_ops, sizeof(struct dvb_frontend_ops));
-	priv->fe.ops.release = NULL;
 	priv->fe.demodulator_priv = priv;
 	i2c_set_clientdata(client, priv);
-	if (pdata->dvb_frontend)
-		*pdata->dvb_frontend = &priv->fe;
 
 	/* setup callbacks */
 	pdata->get_dvb_frontend = rtl2832_get_dvb_frontend;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index dbc4d3c..983d5a1 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -21,7 +21,6 @@
 #ifndef RTL2832_H
 #define RTL2832_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct rtl2832_config {
@@ -54,12 +53,6 @@ struct rtl2832_platform_data {
 	const struct rtl2832_config *config;
 
 	/*
-	 * frontend
-	 * returned by driver
-	 */
-	struct dvb_frontend **dvb_frontend;
-
-	/*
 	 */
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
@@ -67,57 +60,4 @@ struct rtl2832_platform_data {
 	int (*enable_slave_ts)(struct i2c_client *);
 };
 
-#if IS_ENABLED(CONFIG_DVB_RTL2832)
-struct dvb_frontend *rtl2832_attach(
-	const struct rtl2832_config *cfg,
-	struct i2c_adapter *i2c
-);
-
-extern struct i2c_adapter *rtl2832_get_i2c_adapter(
-	struct dvb_frontend *fe
-);
-
-extern struct i2c_adapter *rtl2832_get_private_i2c_adapter(
-	struct dvb_frontend *fe
-);
-
-extern int rtl2832_enable_external_ts_if(
-	struct dvb_frontend *fe
-);
-
-#else
-
-static inline struct dvb_frontend *rtl2832_attach(
-	const struct rtl2832_config *config,
-	struct i2c_adapter *i2c
-)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-
-static inline struct i2c_adapter *rtl2832_get_i2c_adapter(
-	struct dvb_frontend *fe
-)
-{
-	return NULL;
-}
-
-static inline struct i2c_adapter *rtl2832_get_private_i2c_adapter(
-	struct dvb_frontend *fe
-)
-{
-	return NULL;
-}
-
-static inline int rtl2832_enable_external_ts_if(
-	struct dvb_frontend *fe
-)
-{
-	return -ENODEV;
-}
-
-#endif
-
-
 #endif /* RTL2832_H */
-- 
http://palosaari.fi/

