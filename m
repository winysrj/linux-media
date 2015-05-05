Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45551 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbbEEV67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:58:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/21] fc2580: remove obsolete media attach
Date: Wed,  6 May 2015 00:58:25 +0300
Message-Id: <1430863122-9888-4-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All users are using driver via I2C client binding so lets remove
unneeded media binding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc2580.c | 72 -------------------------------------------
 drivers/media/tuners/fc2580.h | 26 ----------------
 2 files changed, 98 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index d01fba8..48e4dae 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -466,17 +466,6 @@ static int fc2580_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static int fc2580_release(struct dvb_frontend *fe)
-{
-	struct fc2580_priv *priv = fe->tuner_priv;
-
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-
-	kfree(fe->tuner_priv);
-
-	return 0;
-}
-
 static const struct dvb_tuner_ops fc2580_tuner_ops = {
 	.info = {
 		.name           = "FCI FC2580",
@@ -484,8 +473,6 @@ static const struct dvb_tuner_ops fc2580_tuner_ops = {
 		.frequency_max  = 862000000,
 	},
 
-	.release = fc2580_release,
-
 	.init = fc2580_init,
 	.sleep = fc2580_sleep,
 	.set_params = fc2580_set_params,
@@ -493,64 +480,6 @@ static const struct dvb_tuner_ops fc2580_tuner_ops = {
 	.get_if_frequency = fc2580_get_if_frequency,
 };
 
-struct dvb_frontend *fc2580_attach(struct dvb_frontend *fe,
-		struct i2c_adapter *i2c, const struct fc2580_config *cfg)
-{
-	struct fc2580_priv *priv;
-	int ret;
-	u8 chip_id;
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
-	priv = kzalloc(sizeof(struct fc2580_priv), GFP_KERNEL);
-	if (!priv) {
-		ret = -ENOMEM;
-		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
-		goto err;
-	}
-
-	priv->clk = cfg->clock;
-	priv->i2c = i2c;
-	priv->i2c_addr = cfg->i2c_addr;
-
-	/* check if the tuner is there */
-	ret = fc2580_rd_reg(priv, 0x01, &chip_id);
-	if (ret < 0)
-		goto err;
-
-	dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
-
-	switch (chip_id) {
-	case 0x56:
-	case 0x5a:
-		break;
-	default:
-		goto err;
-	}
-
-	dev_info(&priv->i2c->dev,
-			"%s: FCI FC2580 successfully identified\n",
-			KBUILD_MODNAME);
-
-	fe->tuner_priv = priv;
-	memcpy(&fe->ops.tuner_ops, &fc2580_tuner_ops,
-			sizeof(struct dvb_tuner_ops));
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	return fe;
-err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
-	kfree(priv);
-	return NULL;
-}
-EXPORT_SYMBOL(fc2580_attach);
-
 static int fc2580_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -592,7 +521,6 @@ static int fc2580_probe(struct i2c_client *client,
 	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &fc2580_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
-	fe->ops.tuner_ops.release = NULL;
 	i2c_set_clientdata(client, dev);
 
 	dev_info(&client->dev, "FCI FC2580 successfully identified\n");
diff --git a/drivers/media/tuners/fc2580.h b/drivers/media/tuners/fc2580.h
index 5679e44..61ee0e8 100644
--- a/drivers/media/tuners/fc2580.h
+++ b/drivers/media/tuners/fc2580.h
@@ -21,7 +21,6 @@
 #ifndef FC2580_H
 #define FC2580_H
 
-#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 /*
@@ -39,29 +38,4 @@ struct fc2580_platform_data {
 	struct dvb_frontend *dvb_frontend;
 };
 
-struct fc2580_config {
-	/*
-	 * I2C address
-	 * 0x56, ...
-	 */
-	u8 i2c_addr;
-
-	/*
-	 * clock
-	 */
-	u32 clock;
-};
-
-#if IS_REACHABLE(CONFIG_MEDIA_TUNER_FC2580)
-extern struct dvb_frontend *fc2580_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct fc2580_config *cfg);
-#else
-static inline struct dvb_frontend *fc2580_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct fc2580_config *cfg)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif
-
 #endif
-- 
http://palosaari.fi/

