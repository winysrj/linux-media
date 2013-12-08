Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35097 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760037Ab3LHWb4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:56 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 17/18] m88ts2022: convert to Kernel I2C driver model
Date: Mon,  9 Dec 2013 00:31:34 +0200
Message-Id: <1386541895-8634-18-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert driver from proprietary DVB driver model to standard I2C
driver model.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/m88ts2022.c      | 121 ++++++++++++++++++++--------------
 drivers/media/tuners/m88ts2022.h      |  24 ++-----
 drivers/media/tuners/m88ts2022_priv.h |   4 +-
 drivers/media/usb/em28xx/em28xx-dvb.c |  25 +++----
 4 files changed, 90 insertions(+), 84 deletions(-)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index b11e740..1155603 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -32,7 +32,7 @@ static int m88ts2022_wr_regs(struct m88ts2022_priv *priv,
 	u8 buf[MAX_WR_XFER_LEN];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg->i2c_addr,
+			.addr = priv->client->addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -45,11 +45,11 @@ static int m88ts2022_wr_regs(struct m88ts2022_priv *priv,
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(priv->i2c, msg, 1);
+	ret = i2c_transfer(priv->client->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&priv->client->dev,
 				"%s: i2c wr failed=%d reg=%02x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -68,12 +68,12 @@ static int m88ts2022_rd_regs(struct m88ts2022_priv *priv, u8 reg,
 	u8 buf[MAX_RD_XFER_LEN];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->cfg->i2c_addr,
+			.addr = priv->client->addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = priv->cfg->i2c_addr,
+			.addr = priv->client->addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = buf,
@@ -83,12 +83,12 @@ static int m88ts2022_rd_regs(struct m88ts2022_priv *priv, u8 reg,
 	if (WARN_ON(len > MAX_RD_LEN))
 		return -EINVAL;
 
-	ret = i2c_transfer(priv->i2c, msg, 2);
+	ret = i2c_transfer(priv->client->adapter, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&priv->client->dev,
 				"%s: i2c rd failed=%d reg=%02x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -144,7 +144,7 @@ static int m88ts2022_cmd(struct dvb_frontend *fe,
 	};
 
 	for (i = 0; i < 2; i++) {
-		dev_dbg(&priv->i2c->dev,
+		dev_dbg(&priv->client->dev,
 				"%s: i=%d op=%02x reg=%02x mask=%02x val=%02x\n",
 				__func__, i, op, reg, mask, val);
 
@@ -180,14 +180,14 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	unsigned int f_ref_khz, f_vco_khz, div_ref, div_out, pll_n, gdiv28;
 	u8 buf[3], u8tmp, cap_code, lpf_gm, lpf_mxdiv, div_max, div_min;
 	u16 u16tmp;
-	dev_dbg(&priv->i2c->dev,
+	dev_dbg(&priv->client->dev,
 			"%s: frequency=%d symbol_rate=%d rolloff=%d\n",
 			__func__, c->frequency, c->symbol_rate, c->rolloff);
 	/*
 	 * Integer-N PLL synthesizer
 	 * kHz is used for all calculations to keep calculations within 32-bit
 	 */
-	f_ref_khz = DIV_ROUND_CLOSEST(priv->cfg->clock, 1000);
+	f_ref_khz = DIV_ROUND_CLOSEST(priv->cfg.clock, 1000);
 	div_ref = DIV_ROUND_CLOSEST(f_ref_khz, 2000);
 
 	if (c->symbol_rate < 5000000)
@@ -230,7 +230,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dev_dbg(&priv->i2c->dev,
+	dev_dbg(&priv->client->dev,
 			"%s: frequency=%u offset=%d f_vco_khz=%u pll_n=%u div_ref=%u div_out=%u\n",
 			__func__, priv->frequency_khz,
 			priv->frequency_khz - c->frequency, f_vco_khz, pll_n,
@@ -374,7 +374,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 		goto err;
 err:
 	if (ret)
-		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -397,7 +397,7 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 		{0x24, 0x02},
 		{0x12, 0xa0},
 	};
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	ret = m88ts2022_wr_reg(priv, 0x00, 0x01);
 	if (ret)
@@ -407,13 +407,13 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	switch (priv->cfg->clock_out) {
+	switch (priv->cfg.clock_out) {
 	case M88TS2022_CLOCK_OUT_DISABLED:
 		u8tmp = 0x60;
 		break;
 	case M88TS2022_CLOCK_OUT_ENABLED:
 		u8tmp = 0x70;
-		ret = m88ts2022_wr_reg(priv, 0x05, priv->cfg->clock_out_div);
+		ret = m88ts2022_wr_reg(priv, 0x05, priv->cfg.clock_out_div);
 		if (ret)
 			goto err;
 		break;
@@ -428,7 +428,7 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	if (priv->cfg->loop_through)
+	if (priv->cfg.loop_through)
 		u8tmp = 0xec;
 	else
 		u8tmp = 0x6c;
@@ -444,7 +444,7 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 	}
 err:
 	if (ret)
-		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -452,21 +452,21 @@ static int m88ts2022_sleep(struct dvb_frontend *fe)
 {
 	struct m88ts2022_priv *priv = fe->tuner_priv;
 	int ret;
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	ret = m88ts2022_wr_reg(priv, 0x00, 0x00);
 	if (ret)
 		goto err;
 err:
 	if (ret)
-		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int m88ts2022_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct m88ts2022_priv *priv = fe->tuner_priv;
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	*frequency = priv->frequency_khz;
 	return 0;
@@ -475,7 +475,7 @@ static int m88ts2022_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static int m88ts2022_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct m88ts2022_priv *priv = fe->tuner_priv;
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	*frequency = 0; /* Zero-IF */
 	return 0;
@@ -519,19 +519,10 @@ static int m88ts2022_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 	*strength = (u16tmp - 59000) * 0xffff / (61500 - 59000);
 err:
 	if (ret)
-		dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
-static int m88ts2022_release(struct dvb_frontend *fe)
-{
-	struct m88ts2022_priv *priv = fe->tuner_priv;
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-
-	kfree(fe->tuner_priv);
-	return 0;
-}
-
 static const struct dvb_tuner_ops m88ts2022_tuner_ops = {
 	.info = {
 		.name          = "Montage M88TS2022",
@@ -539,8 +530,6 @@ static const struct dvb_tuner_ops m88ts2022_tuner_ops = {
 		.frequency_max = 2150000,
 	},
 
-	.release = m88ts2022_release,
-
 	.init = m88ts2022_init,
 	.sleep = m88ts2022_sleep,
 	.set_params = m88ts2022_set_params,
@@ -550,9 +539,11 @@ static const struct dvb_tuner_ops m88ts2022_tuner_ops = {
 	.get_rf_strength = m88ts2022_get_rf_strength,
 };
 
-struct dvb_frontend *m88ts2022_attach(struct dvb_frontend *fe,
-		struct i2c_adapter *i2c, const struct m88ts2022_config *cfg)
+static int m88ts2022_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
 {
+	struct m88ts2022_config *cfg = client->dev.platform_data;
+	struct dvb_frontend *fe = cfg->fe;
 	struct m88ts2022_priv *priv;
 	int ret;
 	u8 chip_id, u8tmp;
@@ -560,13 +551,12 @@ struct dvb_frontend *m88ts2022_attach(struct dvb_frontend *fe,
 	priv = kzalloc(sizeof(struct m88ts2022_priv), GFP_KERNEL);
 	if (!priv) {
 		ret = -ENOMEM;
-		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		dev_err(&client->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
 		goto err;
 	}
 
-	priv->cfg = cfg;
-	priv->i2c = i2c;
-	priv->fe = fe;
+	memcpy(&priv->cfg, cfg, sizeof(struct m88ts2022_config));
+	priv->client = client;
 
 	/* check if the tuner is there */
 	ret = m88ts2022_rd_reg(priv, 0x00, &u8tmp);
@@ -591,7 +581,7 @@ struct dvb_frontend *m88ts2022_attach(struct dvb_frontend *fe,
 	if (ret)
 		goto err;
 
-	dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
+	dev_dbg(&priv->client->dev, "%s: chip_id=%02x\n", __func__, chip_id);
 
 	switch (chip_id) {
 	case 0xc3:
@@ -601,13 +591,13 @@ struct dvb_frontend *m88ts2022_attach(struct dvb_frontend *fe,
 		goto err;
 	}
 
-	switch (priv->cfg->clock_out) {
+	switch (priv->cfg.clock_out) {
 	case M88TS2022_CLOCK_OUT_DISABLED:
 		u8tmp = 0x60;
 		break;
 	case M88TS2022_CLOCK_OUT_ENABLED:
 		u8tmp = 0x70;
-		ret = m88ts2022_wr_reg(priv, 0x05, priv->cfg->clock_out_div);
+		ret = m88ts2022_wr_reg(priv, 0x05, priv->cfg.clock_out_div);
 		if (ret)
 			goto err;
 		break;
@@ -622,7 +612,7 @@ struct dvb_frontend *m88ts2022_attach(struct dvb_frontend *fe,
 	if (ret)
 		goto err;
 
-	if (priv->cfg->loop_through)
+	if (priv->cfg.loop_through)
 		u8tmp = 0xec;
 	else
 		u8tmp = 0x6c;
@@ -636,23 +626,52 @@ struct dvb_frontend *m88ts2022_attach(struct dvb_frontend *fe,
 	if (ret)
 		goto err;
 
-	dev_info(&priv->i2c->dev,
+	dev_info(&priv->client->dev,
 			"%s: Montage M88TS2022 successfully identified\n",
 			KBUILD_MODNAME);
 
 	fe->tuner_priv = priv;
 	memcpy(&fe->ops.tuner_ops, &m88ts2022_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
+
+	i2c_set_clientdata(client, priv);
+	return 0;
 err:
-	if (ret) {
-		dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
-		kfree(priv);
-		return NULL;
-	}
+	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
+	kfree(priv);
+	return ret;
+}
+
+static int m88ts2022_remove(struct i2c_client *client)
+{
+	struct m88ts2022_priv *priv = i2c_get_clientdata(client);
+	struct dvb_frontend *fe = priv->cfg.fe;
+	dev_dbg(&client->dev, "%s:\n", __func__);
 
-	return fe;
+	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
+	fe->tuner_priv = NULL;
+	kfree(priv);
+
+	return 0;
 }
-EXPORT_SYMBOL(m88ts2022_attach);
+
+static const struct i2c_device_id m88ts2022_id[] = {
+	{"m88ts2022", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, m88ts2022_id);
+
+static struct i2c_driver m88ts2022_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "m88ts2022",
+	},
+	.probe		= m88ts2022_probe,
+	.remove		= m88ts2022_remove,
+	.id_table	= m88ts2022_id,
+};
+
+module_i2c_driver(m88ts2022_driver);
 
 MODULE_DESCRIPTION("Montage M88TS2022 silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/tuners/m88ts2022.h b/drivers/media/tuners/m88ts2022.h
index fa1112c..1943b83 100644
--- a/drivers/media/tuners/m88ts2022.h
+++ b/drivers/media/tuners/m88ts2022.h
@@ -25,12 +25,6 @@
 
 struct m88ts2022_config {
 	/*
-	 * I2C address
-	 * 0x60, ...
-	 */
-	u8 i2c_addr;
-
-	/*
 	 * clock
 	 * 16000000 - 32000000
 	 */
@@ -54,19 +48,11 @@ struct m88ts2022_config {
 	 * 1 - 31
 	 */
 	u8 clock_out_div:5;
-};
 
-#if defined(CONFIG_MEDIA_TUNER_M88TS2022) || \
-	(defined(CONFIG_MEDIA_TUNER_M88TS2022_MODULE) && defined(MODULE))
-extern struct dvb_frontend *m88ts2022_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct m88ts2022_config *cfg);
-#else
-static inline struct dvb_frontend *m88ts2022_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct m88ts2022_config *cfg)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif
+	/*
+	 * pointer to DVB frontend
+	 */
+	struct dvb_frontend *fe;
+};
 
 #endif
diff --git a/drivers/media/tuners/m88ts2022_priv.h b/drivers/media/tuners/m88ts2022_priv.h
index 190299a..a1fbb18 100644
--- a/drivers/media/tuners/m88ts2022_priv.h
+++ b/drivers/media/tuners/m88ts2022_priv.h
@@ -24,8 +24,8 @@
 #include "m88ts2022.h"
 
 struct m88ts2022_priv {
-	const struct m88ts2022_config *cfg;
-	struct i2c_adapter *i2c;
+	struct m88ts2022_config cfg;
+	struct i2c_client *client;
 	struct dvb_frontend *fe;
 	u32 frequency_khz;
 };
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 4f8f687..ddc0e60 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -89,6 +89,7 @@ struct em28xx_dvb {
 	struct semaphore      pll_mutex;
 	bool			dont_attach_fe1;
 	int			lna_gpio;
+	struct i2c_client	*i2c_client_tuner;
 };
 
 
@@ -819,11 +820,6 @@ static const struct m88ds3103_config pctv_461e_m88ds3103_config = {
 	.agc = 0x99,
 };
 
-static const struct m88ts2022_config em28xx_m88ts2022_config = {
-	.i2c_addr = 0x60,
-	.clock = 27000000,
-};
-
 /* ------------------------------------------------------------------ */
 
 static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
@@ -1349,6 +1345,11 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		{
 			/* demod I2C adapter */
 			struct i2c_adapter *i2c_adapter;
+			struct i2c_board_info info;
+			struct m88ts2022_config m88ts2022_config = {
+				.clock = 27000000,
+			};
+			memset(&info, 0, sizeof(struct i2c_board_info));
 
 			/* attach demod */
 			dvb->fe[0] = dvb_attach(m88ds3103_attach,
@@ -1361,13 +1362,12 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			}
 
 			/* attach tuner */
-			if (!dvb_attach(m88ts2022_attach, dvb->fe[0],
-					i2c_adapter,
-					&em28xx_m88ts2022_config)) {
-				dvb_frontend_detach(dvb->fe[0]);
-				result = -ENODEV;
-				goto out_free;
-			}
+			m88ts2022_config.fe = dvb->fe[0];
+			strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
+			info.addr = 0x60;
+			info.platform_data = &m88ts2022_config;
+			request_module("m88ts2022");
+			dvb->i2c_client_tuner = i2c_new_device(i2c_adapter, &info);
 
 			/* delegate signal strength measurement to tuner */
 			dvb->fe[0]->ops.read_signal_strength =
@@ -1445,6 +1445,7 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 				prevent_sleep(&dvb->fe[1]->ops);
 		}
 
+		i2c_release_client(dvb->i2c_client_tuner);
 		em28xx_unregister_dvb(dvb);
 		kfree(dvb);
 		dev->dvb = NULL;
-- 
1.8.4.2

