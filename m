Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52560 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbaA0ARN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 19:17:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Jean Delvare <khali@linux-fr.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 1/3] e4000: convert DVB tuner to I2C driver model
Date: Mon, 27 Jan 2014 02:16:50 +0200
Message-Id: <1390781812-20226-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver conversion from proprietary DVB tuner model to more
general I2C driver model.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c            | 115 ++++++++++++++++++++------------
 drivers/media/tuners/e4000.h            |  21 ++----
 drivers/media/tuners/e4000_priv.h       |   5 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |  41 +++++++++---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   1 +
 5 files changed, 111 insertions(+), 72 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 40c1da7..0153169 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -31,7 +31,7 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg->i2c_addr,
+			.addr = priv->client->addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -39,7 +39,7 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 	};
 
 	if (1 + len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&priv->client->dev,
 			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
 			 KBUILD_MODNAME, reg, len);
 		return -EINVAL;
@@ -48,11 +48,11 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
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
@@ -67,12 +67,12 @@ static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 	u8 buf[MAX_XFER_SIZE];
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
@@ -80,18 +80,18 @@ static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
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
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&priv->client->dev,
 				"%s: i2c rd failed=%d reg=%02x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -117,7 +117,7 @@ static int e4000_init(struct dvb_frontend *fe)
 	struct e4000_priv *priv = fe->tuner_priv;
 	int ret;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
@@ -186,7 +186,7 @@ err:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -195,7 +195,7 @@ static int e4000_sleep(struct dvb_frontend *fe)
 	struct e4000_priv *priv = fe->tuner_priv;
 	int ret;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
@@ -212,7 +212,7 @@ err:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -224,7 +224,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	unsigned int f_vco;
 	u8 buf[5], i_data[4], q_data[4];
 
-	dev_dbg(&priv->i2c->dev,
+	dev_dbg(&priv->client->dev,
 			"%s: delivery_system=%d frequency=%d bandwidth_hz=%d\n",
 			__func__, c->delivery_system, c->frequency,
 			c->bandwidth_hz);
@@ -253,14 +253,15 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	 * or more.
 	 */
 	f_vco = c->frequency * e4000_pll_lut[i].mul;
-	sigma_delta = div_u64(0x10000ULL * (f_vco % priv->cfg->clock), priv->cfg->clock);
-	buf[0] = f_vco / priv->cfg->clock;
+	sigma_delta = div_u64(0x10000ULL * (f_vco % priv->clock), priv->clock);
+	buf[0] = f_vco / priv->clock;
 	buf[1] = (sigma_delta >> 0) & 0xff;
 	buf[2] = (sigma_delta >> 8) & 0xff;
 	buf[3] = 0x00;
 	buf[4] = e4000_pll_lut[i].div;
 
-	dev_dbg(&priv->i2c->dev, "%s: f_vco=%u pll div=%d sigma_delta=%04x\n",
+	dev_dbg(&priv->client->dev,
+			"%s: f_vco=%u pll div=%d sigma_delta=%04x\n",
 			__func__, f_vco, buf[0], sigma_delta);
 
 	ret = e4000_wr_regs(priv, 0x09, buf, 5);
@@ -369,7 +370,7 @@ err:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -377,24 +378,13 @@ static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct e4000_priv *priv = fe->tuner_priv;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	*frequency = 0; /* Zero-IF */
 
 	return 0;
 }
 
-static int e4000_release(struct dvb_frontend *fe)
-{
-	struct e4000_priv *priv = fe->tuner_priv;
-
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-
-	kfree(fe->tuner_priv);
-
-	return 0;
-}
-
 static const struct dvb_tuner_ops e4000_tuner_ops = {
 	.info = {
 		.name           = "Elonics E4000",
@@ -402,8 +392,6 @@ static const struct dvb_tuner_ops e4000_tuner_ops = {
 		.frequency_max  = 862000000,
 	},
 
-	.release = e4000_release,
-
 	.init = e4000_init,
 	.sleep = e4000_sleep,
 	.set_params = e4000_set_params,
@@ -411,9 +399,11 @@ static const struct dvb_tuner_ops e4000_tuner_ops = {
 	.get_if_frequency = e4000_get_if_frequency,
 };
 
-struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
-		struct i2c_adapter *i2c, const struct e4000_config *cfg)
+static int e4000_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
 {
+	struct e4000_config *cfg = client->dev.platform_data;
+	struct dvb_frontend *fe = cfg->fe;
 	struct e4000_priv *priv;
 	int ret;
 	u8 chip_id;
@@ -424,29 +414,33 @@ struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
 	priv = kzalloc(sizeof(struct e4000_priv), GFP_KERNEL);
 	if (!priv) {
 		ret = -ENOMEM;
-		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		dev_err(&client->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
 		goto err;
 	}
 
-	priv->cfg = cfg;
-	priv->i2c = i2c;
+	priv->clock = cfg->clock;
+	priv->client = client;
+	priv->fe = cfg->fe;
 
 	/* check if the tuner is there */
 	ret = e4000_rd_reg(priv, 0x02, &chip_id);
 	if (ret < 0)
 		goto err;
 
-	dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
+	dev_dbg(&priv->client->dev,
+			"%s: chip_id=%02x\n", __func__, chip_id);
 
-	if (chip_id != 0x40)
+	if (chip_id != 0x40) {
+		ret = -ENODEV;
 		goto err;
+	}
 
 	/* put sleep as chip seems to be in normal mode by default */
 	ret = e4000_wr_reg(priv, 0x00, 0x00);
 	if (ret < 0)
 		goto err;
 
-	dev_info(&priv->i2c->dev,
+	dev_info(&priv->client->dev,
 			"%s: Elonics E4000 successfully identified\n",
 			KBUILD_MODNAME);
 
@@ -457,16 +451,49 @@ struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
-	return fe;
+	i2c_set_clientdata(client, priv);
+
+	return 0;
 err:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
 	kfree(priv);
-	return NULL;
+	return ret;
 }
-EXPORT_SYMBOL(e4000_attach);
+
+static int e4000_remove(struct i2c_client *client)
+{
+	struct e4000_priv *priv = i2c_get_clientdata(client);
+	struct dvb_frontend *fe = priv->fe;
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
+static const struct i2c_device_id e4000_id[] = {
+	{"e4000", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, e4000_id);
+
+static struct i2c_driver e4000_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "e4000",
+	},
+	.probe		= e4000_probe,
+	.remove		= e4000_remove,
+	.id_table	= e4000_id,
+};
+
+module_i2c_driver(e4000_driver);
 
 MODULE_DESCRIPTION("Elonics E4000 silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
index 25ee7c0..e74b8b2 100644
--- a/drivers/media/tuners/e4000.h
+++ b/drivers/media/tuners/e4000.h
@@ -24,12 +24,15 @@
 #include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
+/*
+ * I2C address
+ * 0x64, 0x65, 0x66, 0x67
+ */
 struct e4000_config {
 	/*
-	 * I2C address
-	 * 0x64, 0x65, 0x66, 0x67
+	 * frontend
 	 */
-	u8 i2c_addr;
+	struct dvb_frontend *fe;
 
 	/*
 	 * clock
@@ -37,16 +40,4 @@ struct e4000_config {
 	u32 clock;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_E4000)
-extern struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
-		struct i2c_adapter *i2c, const struct e4000_config *cfg);
-#else
-static inline struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
-		struct i2c_adapter *i2c, const struct e4000_config *cfg)
-{
-	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif
-
 #endif
diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
index a385505..8f45a30 100644
--- a/drivers/media/tuners/e4000_priv.h
+++ b/drivers/media/tuners/e4000_priv.h
@@ -24,8 +24,9 @@
 #include "e4000.h"
 
 struct e4000_priv {
-	const struct e4000_config *cfg;
-	struct i2c_adapter *i2c;
+	struct i2c_client *client;
+	u32 clock;
+	struct dvb_frontend *fe;
 };
 
 struct e4000_pll {
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 77f1fc9..76cf0de 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -857,11 +857,6 @@ err:
 	return ret;
 }
 
-static const struct e4000_config rtl2832u_e4000_config = {
-	.i2c_addr = 0x64,
-	.clock = 28800000,
-};
-
 static const struct fc2580_config rtl2832u_fc2580_config = {
 	.i2c_addr = 0x56,
 	.clock = 16384000,
@@ -895,10 +890,13 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	int ret;
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct dvb_frontend *fe;
+	struct dvb_frontend *fe = NULL;
+	struct i2c_board_info info;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
+	memset(&info, 0, sizeof(struct i2c_board_info));
+
 	switch (priv->tuner) {
 	case TUNER_RTL2832_FC0012:
 		fe = dvb_attach(fc0012_attach, adap->fe[0],
@@ -918,9 +916,19 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 		return 0;
-	case TUNER_RTL2832_E4000:
-		fe = dvb_attach(e4000_attach, adap->fe[0], &d->i2c_adap,
-				&rtl2832u_e4000_config);
+	case TUNER_RTL2832_E4000: {
+			struct e4000_config e4000_config = {
+				.fe = adap->fe[0],
+				.clock = 28800000,
+			};
+
+			strlcpy(info.type, "e4000", I2C_NAME_SIZE);
+			info.addr = 0x64;
+			info.platform_data = &e4000_config;
+
+			request_module("e4000");
+			priv->client = i2c_new_device(&d->i2c_adap, &info);
+		}
 		break;
 	case TUNER_RTL2832_FC2580:
 		fe = dvb_attach(fc2580_attach, adap->fe[0], &d->i2c_adap,
@@ -969,12 +977,11 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 		break;
 	default:
-		fe = NULL;
 		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
 				priv->tuner);
 	}
 
-	if (fe == NULL) {
+	if (fe == NULL && priv->client == NULL) {
 		ret = -ENODEV;
 		goto err;
 	}
@@ -1019,6 +1026,17 @@ err:
 	return ret;
 }
 
+static void rtl28xxu_exit(struct dvb_usb_device *d)
+{
+	struct rtl28xxu_priv *priv = d->priv;
+
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	i2c_release_client(priv->client);
+
+	return;
+}
+
 static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	int ret;
@@ -1381,6 +1399,7 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 	.frontend_attach = rtl2832u_frontend_attach,
 	.tuner_attach = rtl2832u_tuner_attach,
 	.init = rtl28xxu_init,
+	.exit = rtl28xxu_exit,
 	.get_rc_config = rtl2832u_get_rc_config,
 
 	.num_adapters = 1,
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 2142bcb..367aca1 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -56,6 +56,7 @@ struct rtl28xxu_priv {
 	char *tuner_name;
 	u8 page; /* integrated demod active register page */
 	bool rc_active;
+	struct i2c_client *client;
 };
 
 enum rtl28xxu_chip_id {
-- 
1.8.5.3

