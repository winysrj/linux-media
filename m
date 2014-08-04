Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58702 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaHDE3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Aug 2014 00:29:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/9] tda18212: convert driver to I2C binding
Date: Mon,  4 Aug 2014 07:29:27 +0300
Message-Id: <1407126571-21629-5-git-send-email-crope@iki.fi>
In-Reply-To: <1407126571-21629-1-git-send-email-crope@iki.fi>
References: <1407126571-21629-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert driver from DVB proprietary model to common I2C model.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tda18212.c | 129 ++++++++++++++++++++++++----------------
 drivers/media/tuners/tda18212.h |  14 -----
 2 files changed, 79 insertions(+), 64 deletions(-)

diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index 15b09f8..659787b 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -24,8 +24,8 @@
 #define MAX_XFER_SIZE  64
 
 struct tda18212_priv {
-	struct tda18212_config *cfg;
-	struct i2c_adapter *i2c;
+	struct tda18212_config cfg;
+	struct i2c_client *client;
 
 	u32 if_frequency;
 };
@@ -38,7 +38,7 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg->i2c_address,
+			.addr = priv->client->addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -46,7 +46,7 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	};
 
 	if (1 + len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&priv->client->dev,
 			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
 			 KBUILD_MODNAME, reg, len);
 		return -EINVAL;
@@ -55,12 +55,12 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(priv->i2c, msg, 1);
+	ret = i2c_transfer(priv->client->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&priv->client->dev, "%s: i2c wr failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -74,12 +74,12 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->cfg->i2c_address,
+			.addr = priv->client->addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = priv->cfg->i2c_address,
+			.addr = priv->client->addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = buf,
@@ -87,19 +87,19 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	};
 
 	if (len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&priv->client->dev,
 			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
 			 KBUILD_MODNAME, reg, len);
 		return -EINVAL;
 	}
 
-	ret = i2c_transfer(priv->i2c, msg, 2);
+	ret = i2c_transfer(priv->client->adapter, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&priv->client->dev, "%s: i2c rd failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -166,7 +166,7 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 		[ATSC_QAM] = { 0x7d, 0x20, 0x63 },
 	};
 
-	dev_dbg(&priv->i2c->dev,
+	dev_dbg(&priv->client->dev,
 			"%s: delivery_system=%d frequency=%d bandwidth_hz=%d\n",
 			__func__, c->delivery_system, c->frequency,
 			c->bandwidth_hz);
@@ -176,25 +176,25 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 
 	switch (c->delivery_system) {
 	case SYS_ATSC:
-		if_khz = priv->cfg->if_atsc_vsb;
+		if_khz = priv->cfg.if_atsc_vsb;
 		i = ATSC_VSB;
 		break;
 	case SYS_DVBC_ANNEX_B:
-		if_khz = priv->cfg->if_atsc_qam;
+		if_khz = priv->cfg.if_atsc_qam;
 		i = ATSC_QAM;
 		break;
 	case SYS_DVBT:
 		switch (c->bandwidth_hz) {
 		case 6000000:
-			if_khz = priv->cfg->if_dvbt_6;
+			if_khz = priv->cfg.if_dvbt_6;
 			i = DVBT_6;
 			break;
 		case 7000000:
-			if_khz = priv->cfg->if_dvbt_7;
+			if_khz = priv->cfg.if_dvbt_7;
 			i = DVBT_7;
 			break;
 		case 8000000:
-			if_khz = priv->cfg->if_dvbt_8;
+			if_khz = priv->cfg.if_dvbt_8;
 			i = DVBT_8;
 			break;
 		default:
@@ -205,15 +205,15 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 	case SYS_DVBT2:
 		switch (c->bandwidth_hz) {
 		case 6000000:
-			if_khz = priv->cfg->if_dvbt2_6;
+			if_khz = priv->cfg.if_dvbt2_6;
 			i = DVBT2_6;
 			break;
 		case 7000000:
-			if_khz = priv->cfg->if_dvbt2_7;
+			if_khz = priv->cfg.if_dvbt2_7;
 			i = DVBT2_7;
 			break;
 		case 8000000:
-			if_khz = priv->cfg->if_dvbt2_8;
+			if_khz = priv->cfg.if_dvbt2_8;
 			i = DVBT2_8;
 			break;
 		default:
@@ -223,7 +223,7 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 		break;
 	case SYS_DVBC_ANNEX_A:
 	case SYS_DVBC_ANNEX_C:
-		if_khz = priv->cfg->if_dvbc;
+		if_khz = priv->cfg.if_dvbc;
 		i = DVBC_8;
 		break;
 	default:
@@ -266,7 +266,7 @@ exit:
 	return ret;
 
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	goto exit;
 }
 
@@ -279,13 +279,6 @@ static int tda18212_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static int tda18212_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static const struct dvb_tuner_ops tda18212_tuner_ops = {
 	.info = {
 		.name           = "NXP TDA18212",
@@ -295,34 +288,36 @@ static const struct dvb_tuner_ops tda18212_tuner_ops = {
 		.frequency_step =      1000,
 	},
 
-	.release       = tda18212_release,
-
 	.set_params    = tda18212_set_params,
 	.get_if_frequency = tda18212_get_if_frequency,
 };
 
-struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, struct tda18212_config *cfg)
+static int tda18212_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
 {
-	struct tda18212_priv *priv = NULL;
+	struct tda18212_config *cfg = client->dev.platform_data;
+	struct dvb_frontend *fe = cfg->fe;
+	struct tda18212_priv *priv;
 	int ret;
 	u8 chip_id = chip_id;
 	char *version;
 
-	priv = kzalloc(sizeof(struct tda18212_priv), GFP_KERNEL);
-	if (priv == NULL)
-		return NULL;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		dev_err(&client->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		goto err;
+	}
 
-	priv->cfg = cfg;
-	priv->i2c = i2c;
-	fe->tuner_priv = priv;
+	memcpy(&priv->cfg, cfg, sizeof(struct tda18212_config));
+	priv->client = client;
 
+	/* check if the tuner is there */
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
 
-	/* check if the tuner is there */
 	ret = tda18212_rd_reg(priv, 0x00, &chip_id);
-	dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
+	dev_dbg(&priv->client->dev, "%s: chip_id=%02x\n", __func__, chip_id);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
@@ -338,23 +333,57 @@ struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
 		version = "S"; /* slave */
 		break;
 	default:
+		ret = -ENODEV;
 		goto err;
 	}
 
-	dev_info(&priv->i2c->dev,
+	dev_info(&priv->client->dev,
 			"%s: NXP TDA18212HN/%s successfully identified\n",
 			KBUILD_MODNAME, version);
 
+	fe->tuner_priv = priv;
 	memcpy(&fe->ops.tuner_ops, &tda18212_tuner_ops,
-		sizeof(struct dvb_tuner_ops));
+			sizeof(struct dvb_tuner_ops));
+	i2c_set_clientdata(client, priv);
 
-	return fe;
+	return 0;
 err:
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
 	kfree(priv);
-	return NULL;
+	return ret;
 }
-EXPORT_SYMBOL(tda18212_attach);
+
+static int tda18212_remove(struct i2c_client *client)
+{
+	struct tda18212_priv *priv = i2c_get_clientdata(client);
+	struct dvb_frontend *fe = priv->cfg.fe;
+
+	dev_dbg(&client->dev, "%s:\n", __func__);
+
+	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
+	fe->tuner_priv = NULL;
+	kfree(priv);
+
+	return 0;
+}
+
+static const struct i2c_device_id tda18212_id[] = {
+	{"tda18212", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, tda18212_id);
+
+static struct i2c_driver tda18212_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "tda18212",
+	},
+	.probe		= tda18212_probe,
+	.remove		= tda18212_remove,
+	.id_table	= tda18212_id,
+};
+
+module_i2c_driver(tda18212_driver);
 
 MODULE_DESCRIPTION("NXP TDA18212HN silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/tuners/tda18212.h b/drivers/media/tuners/tda18212.h
index 265559a..e58c909 100644
--- a/drivers/media/tuners/tda18212.h
+++ b/drivers/media/tuners/tda18212.h
@@ -25,8 +25,6 @@
 #include "dvb_frontend.h"
 
 struct tda18212_config {
-	u8 i2c_address;
-
 	u16 if_dvbt_6;
 	u16 if_dvbt_7;
 	u16 if_dvbt_8;
@@ -44,16 +42,4 @@ struct tda18212_config {
 	struct dvb_frontend *fe;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA18212)
-extern struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, struct tda18212_config *cfg);
-#else
-static inline struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, struct tda18212_config *cfg)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif
-
 #endif
-- 
http://palosaari.fi/

