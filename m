Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54615 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045AbaIDChB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/37] it913x: convert to I2C driver
Date: Thu,  4 Sep 2014 05:36:20 +0300
Message-Id: <1409798205-25645-12-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert driver from DVB proprietary model to kernel I2C model.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c      | 133 ++++++++++++++++++++-----------------
 drivers/media/tuners/it913x.h      |  33 ++++-----
 drivers/media/tuners/it913x_priv.h |   1 -
 3 files changed, 90 insertions(+), 77 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 4627925..72fefb7 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -23,10 +23,9 @@
 #include "it913x_priv.h"
 
 struct it913x_state {
-	struct i2c_adapter *i2c_adap;
-	u8 i2c_addr;
+	struct i2c_client *client;
+	struct dvb_frontend *fe;
 	u8 chip_ver;
-	u8 tuner_type;
 	u8 firmware_ver;
 	u16 tun_xtal;
 	u8 tun_fdiv;
@@ -41,9 +40,9 @@ static int it913x_rd_regs(struct it913x_state *state,
 	int ret;
 	u8 b[3];
 	struct i2c_msg msg[2] = {
-		{ .addr = state->i2c_addr, .flags = 0,
+		{ .addr = state->client->addr, .flags = 0,
 			.buf = b, .len = sizeof(b) },
-		{ .addr = state->i2c_addr, .flags = I2C_M_RD,
+		{ .addr = state->client->addr, .flags = I2C_M_RD,
 			.buf = data, .len = count }
 	};
 
@@ -52,7 +51,7 @@ static int it913x_rd_regs(struct it913x_state *state,
 	b[2] = (u8) reg & 0xff;
 	b[0] |= 0x80; /* All reads from demodulator */
 
-	ret = i2c_transfer(state->i2c_adap, msg, 2);
+	ret = i2c_transfer(state->client->adapter, msg, 2);
 
 	return ret;
 }
@@ -73,7 +72,7 @@ static int it913x_wr_regs(struct it913x_state *state,
 {
 	u8 b[256];
 	struct i2c_msg msg[1] = {
-		{ .addr = state->i2c_addr, .flags = 0,
+		{ .addr = state->client->addr, .flags = 0,
 		  .buf = b, .len = 3 + count }
 	};
 	int ret;
@@ -86,7 +85,7 @@ static int it913x_wr_regs(struct it913x_state *state,
 	if (pro == PRO_DMOD)
 		b[0] |= 0x80;
 
-	ret = i2c_transfer(state->i2c_adap, msg, 1);
+	ret = i2c_transfer(state->client->adapter, msg, 1);
 
 	if (ret < 0)
 		return -EIO;
@@ -191,8 +190,7 @@ static int it913x_init(struct dvb_frontend *fe)
 	}
 	state->tun_fn_min = state->tun_xtal * reg;
 	state->tun_fn_min /= (state->tun_fdiv * nv_val);
-	dev_dbg(&state->i2c_adap->dev, "%s: Tuner fn_min %d\n", __func__,
-			state->tun_fn_min);
+	dev_dbg(&state->client->dev, "Tuner fn_min %d\n", state->tun_fn_min);
 
 	if (state->chip_ver > 1)
 		msleep(50);
@@ -237,8 +235,8 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	else
 		set_tuner = set_it9137_template;
 
-	dev_dbg(&state->i2c_adap->dev, "%s: Tuner Frequency %d Bandwidth %d\n",
-			__func__, frequency, bandwidth);
+	dev_dbg(&state->client->dev, "Tuner Frequency %d Bandwidth %d\n",
+			frequency, bandwidth);
 
 	if (frequency >= 51000 && frequency <= 440000) {
 		l_band = 0;
@@ -353,15 +351,13 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	set_tuner[3].reg[0] =  temp_f & 0xff;
 	set_tuner[4].reg[0] =  (temp_f >> 8) & 0xff;
 
-	dev_dbg(&state->i2c_adap->dev, "%s: High Frequency = %04x\n",
-			__func__, temp_f);
+	dev_dbg(&state->client->dev, "High Frequency = %04x\n", temp_f);
 
 	/* Lower frequency */
 	set_tuner[5].reg[0] =  freq & 0xff;
 	set_tuner[6].reg[0] =  (freq >> 8) & 0xff;
 
-	dev_dbg(&state->i2c_adap->dev, "%s: low Frequency = %04x\n",
-			__func__, freq);
+	dev_dbg(&state->client->dev, "low Frequency = %04x\n", freq);
 
 	ret = it913x_script_loader(state, set_tuner);
 
@@ -382,12 +378,6 @@ static int it913x_sleep(struct dvb_frontend *fe)
 		return it913x_script_loader(state, it9137_tuner_off);
 }
 
-static int it913x_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	return 0;
-}
-
 static const struct dvb_tuner_ops it913x_tuner_ops = {
 	.info = {
 		.name           = "ITE Tech IT913X",
@@ -395,68 +385,91 @@ static const struct dvb_tuner_ops it913x_tuner_ops = {
 		.frequency_max  = 862000000,
 	},
 
-	.release = it913x_release,
-
 	.init = it913x_init,
 	.sleep = it913x_sleep,
 	.set_params = it9137_set_params,
 };
 
-struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
-		struct i2c_adapter *i2c_adap, u8 i2c_addr, u8 config)
+static int it913x_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
 {
-	struct it913x_state *state = NULL;
+	struct it913x_config *cfg = client->dev.platform_data;
+	struct dvb_frontend *fe = cfg->fe;
+	struct it913x_state *state;
 	int ret;
+	char *chip_ver_str;
 
-	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct it913x_state), GFP_KERNEL);
-	if (state == NULL)
-		return NULL;
-
-	state->i2c_adap = i2c_adap;
-	state->i2c_addr = i2c_addr;
-
-	switch (config) {
-	case AF9033_TUNER_IT9135_38:
-	case AF9033_TUNER_IT9135_51:
-	case AF9033_TUNER_IT9135_52:
-		state->chip_ver = 0x01;
-		break;
-	case AF9033_TUNER_IT9135_60:
-	case AF9033_TUNER_IT9135_61:
-	case AF9033_TUNER_IT9135_62:
-		state->chip_ver = 0x02;
-		break;
-	default:
-		dev_dbg(&i2c_adap->dev,
-				"%s: invalid config=%02x\n", __func__, config);
-		goto error;
+	if (state == NULL) {
+		ret = -ENOMEM;
+		dev_err(&client->dev, "kzalloc() failed\n");
+		goto err;
 	}
 
-	state->tuner_type = config;
+	state->client = client;
+	state->fe = cfg->fe;
+	state->chip_ver = cfg->chip_ver;
 	state->firmware_ver = 1;
 
 	/* tuner RF initial */
 	ret = it913x_wr_reg(state, PRO_DMOD, 0xec4c, 0x68);
 	if (ret < 0)
-		goto error;
+		goto err;
 
 	fe->tuner_priv = state;
 	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
+	i2c_set_clientdata(client, state);
+
+	if (state->chip_ver == 1)
+		chip_ver_str = "AX";
+	else if (state->chip_ver == 2)
+		chip_ver_str = "BX";
+	else
+		chip_ver_str = "??";
+
+	dev_info(&state->client->dev, "ITE IT913X %s successfully attached\n",
+			chip_ver_str);
+	dev_dbg(&state->client->dev, "chip_ver=%02x\n", state->chip_ver);
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed %d\n", ret);
+	kfree(state);
 
-	dev_info(&i2c_adap->dev,
-			"%s: ITE Tech IT913X successfully attached\n",
-			KBUILD_MODNAME);
-	dev_dbg(&i2c_adap->dev, "%s: config=%02x chip_ver=%02x\n",
-			__func__, config, state->chip_ver);
+	return ret;
+}
 
-	return fe;
-error:
+static int it913x_remove(struct i2c_client *client)
+{
+	struct it913x_state *state = i2c_get_clientdata(client);
+	struct dvb_frontend *fe = state->fe;
+
+	dev_dbg(&client->dev, "\n");
+
+	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
+	fe->tuner_priv = NULL;
 	kfree(state);
-	return NULL;
+
+	return 0;
 }
-EXPORT_SYMBOL(it913x_attach);
+
+static const struct i2c_device_id it913x_id_table[] = {
+	{"it913x", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, it913x_id_table);
+
+static struct i2c_driver it913x_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "it913x",
+	},
+	.probe		= it913x_probe,
+	.remove		= it913x_remove,
+	.id_table	= it913x_id_table,
+};
+
+module_i2c_driver(it913x_driver);
 
 MODULE_DESCRIPTION("ITE Tech IT913X silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/tuners/it913x.h b/drivers/media/tuners/it913x.h
index 12dd36b..9789c4d 100644
--- a/drivers/media/tuners/it913x.h
+++ b/drivers/media/tuners/it913x.h
@@ -25,21 +25,22 @@
 
 #include "dvb_frontend.h"
 
-#if defined(CONFIG_MEDIA_TUNER_IT913X) || \
-	(defined(CONFIG_MEDIA_TUNER_IT913X_MODULE) && defined(MODULE))
-extern struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c_adap,
-	u8 i2c_addr,
-	u8 config);
-#else
-static inline struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c_adap,
-	u8 i2c_addr,
-	u8 config)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif
+/*
+ * I2C address
+ * 0x38, 0x3a, 0x3c, 0x3e
+ */
+struct it913x_config {
+	/*
+	 * pointer to DVB frontend
+	 */
+	struct dvb_frontend *fe;
+
+	/*
+	 * chip version
+	 * 1 = IT9135 AX
+	 * 2 = IT9135 BX
+	 */
+	u8 chip_ver:2;
+};
 
 #endif
diff --git a/drivers/media/tuners/it913x_priv.h b/drivers/media/tuners/it913x_priv.h
index 781c98e..d624efd 100644
--- a/drivers/media/tuners/it913x_priv.h
+++ b/drivers/media/tuners/it913x_priv.h
@@ -24,7 +24,6 @@
 #define IT913X_PRIV_H
 
 #include "it913x.h"
-#include "af9033.h"
 
 #define PRO_LINK		0x0
 #define PRO_DMOD		0x1
-- 
http://palosaari.fi/

