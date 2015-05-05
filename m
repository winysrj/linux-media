Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50244 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbbEEV7A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/21] tua9001: remove media attach
Date: Wed,  6 May 2015 00:58:33 +0300
Message-Id: <1430863122-9888-12-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We are using I2C client binding now, so remove old media attach.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tua9001.c | 88 ++----------------------------------------
 drivers/media/tuners/tua9001.h | 20 ----------
 2 files changed, 4 insertions(+), 104 deletions(-)

diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
index 55cac20..87e8518 100644
--- a/drivers/media/tuners/tua9001.c
+++ b/drivers/media/tuners/tua9001.c
@@ -47,23 +47,6 @@ static int tua9001_wr_reg(struct tua9001_priv *priv, u8 reg, u16 val)
 	return ret;
 }
 
-static int tua9001_release(struct dvb_frontend *fe)
-{
-	struct tua9001_priv *priv = fe->tuner_priv;
-	int ret = 0;
-
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-
-	if (fe->callback)
-		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
-				TUA9001_CMD_CEN, 0);
-
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-
-	return ret;
-}
-
 static int tua9001_init(struct dvb_frontend *fe)
 {
 	struct tua9001_priv *priv = fe->tuner_priv;
@@ -96,18 +79,11 @@ static int tua9001_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c-gate */
-
 	for (i = 0; i < ARRAY_SIZE(data); i++) {
 		ret = tua9001_wr_reg(priv, data[i].reg, data[i].val);
 		if (ret < 0)
-			goto err_i2c_gate_ctrl;
+			goto err;
 	}
-
-err_i2c_gate_ctrl:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c-gate */
 err:
 	if (ret < 0)
 		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
@@ -181,32 +157,25 @@ static int tua9001_set_params(struct dvb_frontend *fe)
 	data[1].reg = 0x1f;
 	data[1].val = frequency;
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c-gate */
-
 	if (fe->callback) {
 		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
 				TUA9001_CMD_RXEN, 0);
 		if (ret < 0)
-			goto err_i2c_gate_ctrl;
+			goto err;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(data); i++) {
 		ret = tua9001_wr_reg(priv, data[i].reg, data[i].val);
 		if (ret < 0)
-			goto err_i2c_gate_ctrl;
+			goto err;
 	}
 
 	if (fe->callback) {
 		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
 				TUA9001_CMD_RXEN, 1);
 		if (ret < 0)
-			goto err_i2c_gate_ctrl;
+			goto err;
 	}
-
-err_i2c_gate_ctrl:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c-gate */
 err:
 	if (ret < 0)
 		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
@@ -234,8 +203,6 @@ static const struct dvb_tuner_ops tua9001_tuner_ops = {
 		.frequency_step = 0,
 	},
 
-	.release = tua9001_release,
-
 	.init = tua9001_init,
 	.sleep = tua9001_sleep,
 	.set_params = tua9001_set_params,
@@ -243,52 +210,6 @@ static const struct dvb_tuner_ops tua9001_tuner_ops = {
 	.get_if_frequency = tua9001_get_if_frequency,
 };
 
-struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
-		struct i2c_adapter *i2c, struct tua9001_config *cfg)
-{
-	struct tua9001_priv *priv = NULL;
-	int ret;
-
-	priv = kzalloc(sizeof(struct tua9001_priv), GFP_KERNEL);
-	if (priv == NULL)
-		return NULL;
-
-	priv->i2c_addr = cfg->i2c_addr;
-	priv->i2c = i2c;
-
-	if (fe->callback) {
-		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
-				TUA9001_CMD_CEN, 1);
-		if (ret < 0)
-			goto err;
-
-		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
-				TUA9001_CMD_RXEN, 0);
-		if (ret < 0)
-			goto err;
-
-		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
-				TUA9001_CMD_RESETN, 1);
-		if (ret < 0)
-			goto err;
-	}
-
-	dev_info(&priv->i2c->dev,
-			"%s: Infineon TUA 9001 successfully attached\n",
-			KBUILD_MODNAME);
-
-	memcpy(&fe->ops.tuner_ops, &tua9001_tuner_ops,
-			sizeof(struct dvb_tuner_ops));
-
-	fe->tuner_priv = priv;
-	return fe;
-err:
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
-	kfree(priv);
-	return NULL;
-}
-EXPORT_SYMBOL(tua9001_attach);
-
 static int tua9001_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -331,7 +252,6 @@ static int tua9001_probe(struct i2c_client *client,
 	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &tua9001_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
-	fe->ops.tuner_ops.release = NULL;
 	i2c_set_clientdata(client, dev);
 
 	dev_info(&client->dev, "Infineon TUA 9001 successfully attached\n");
diff --git a/drivers/media/tuners/tua9001.h b/drivers/media/tuners/tua9001.h
index 0b4fc8d..5328ab2 100644
--- a/drivers/media/tuners/tua9001.h
+++ b/drivers/media/tuners/tua9001.h
@@ -21,7 +21,6 @@
 #ifndef TUA9001_H
 #define TUA9001_H
 
-#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 /*
@@ -37,13 +36,6 @@ struct tua9001_platform_data {
 	struct dvb_frontend *dvb_frontend;
 };
 
-struct tua9001_config {
-	/*
-	 * I2C address
-	 */
-	u8 i2c_addr;
-};
-
 /*
  * TUA9001 I/O PINs:
  *
@@ -64,16 +56,4 @@ struct tua9001_config {
 #define TUA9001_CMD_RESETN  1
 #define TUA9001_CMD_RXEN    2
 
-#if IS_REACHABLE(CONFIG_MEDIA_TUNER_TUA9001)
-extern struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
-		struct i2c_adapter *i2c, struct tua9001_config *cfg);
-#else
-static inline struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
-		struct i2c_adapter *i2c, struct tua9001_config *cfg)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif
-
 #endif
-- 
http://palosaari.fi/

