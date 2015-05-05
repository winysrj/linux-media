Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35060 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbbEEV67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:58:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/21] fc2580: implement I2C client bindings
Date: Wed,  6 May 2015 00:58:22 +0300
Message-Id: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add I2C client bindings to driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc2580.c      | 101 +++++++++++++++++++++++++++++++++----
 drivers/media/tuners/fc2580.h      |  15 ++++++
 drivers/media/tuners/fc2580_priv.h |   4 +-
 3 files changed, 110 insertions(+), 10 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index f0c9c42..d01fba8 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -47,7 +47,7 @@ static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg->i2c_addr,
+			.addr = priv->i2c_addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -82,12 +82,12 @@ static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->cfg->i2c_addr,
+			.addr = priv->i2c_addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = priv->cfg->i2c_addr,
+			.addr = priv->i2c_addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = buf,
@@ -182,10 +182,10 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
-	if (f_vco >= 2UL * 76 * priv->cfg->clock) {
+	if (f_vco >= 2UL * 76 * priv->clk) {
 		r_val = 1;
 		r18_val = 0x00;
-	} else if (f_vco >= 1UL * 76 * priv->cfg->clock) {
+	} else if (f_vco >= 1UL * 76 * priv->clk) {
 		r_val = 2;
 		r18_val = 0x10;
 	} else {
@@ -193,7 +193,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 		r18_val = 0x20;
 	}
 
-	f_ref = 2UL * priv->cfg->clock / r_val;
+	f_ref = 2UL * priv->clk / r_val;
 	n_val = div_u64_rem(f_vco, f_ref, &k_val);
 	k_val_reg = div_u64(1ULL * k_val * (1 << 20), f_ref);
 
@@ -213,7 +213,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
-	if (priv->cfg->clock >= 28000000) {
+	if (priv->clk >= 28000000) {
 		ret = fc2580_wr_reg(priv, 0x4b, 0x22);
 		if (ret < 0)
 			goto err;
@@ -348,7 +348,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x37, div_u64(1ULL * priv->cfg->clock *
+	ret = fc2580_wr_reg(priv, 0x37, div_u64(1ULL * priv->clk *
 			fc2580_if_filter_lut[i].mul, 1000000000));
 	if (ret < 0)
 		goto err;
@@ -510,8 +510,9 @@ struct dvb_frontend *fc2580_attach(struct dvb_frontend *fe,
 		goto err;
 	}
 
-	priv->cfg = cfg;
+	priv->clk = cfg->clock;
 	priv->i2c = i2c;
+	priv->i2c_addr = cfg->i2c_addr;
 
 	/* check if the tuner is there */
 	ret = fc2580_rd_reg(priv, 0x01, &chip_id);
@@ -550,6 +551,88 @@ err:
 }
 EXPORT_SYMBOL(fc2580_attach);
 
+static int fc2580_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct fc2580_priv *dev;
+	struct fc2580_platform_data *pdata = client->dev.platform_data;
+	struct dvb_frontend *fe = pdata->dvb_frontend;
+	int ret;
+	u8 chip_id;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	if (pdata->clk)
+		dev->clk = pdata->clk;
+	else
+		dev->clk = 16384000; /* internal clock */
+	dev->client = client;
+	dev->i2c = client->adapter;
+	dev->i2c_addr = client->addr;
+
+	/* check if the tuner is there */
+	ret = fc2580_rd_reg(dev, 0x01, &chip_id);
+	if (ret < 0)
+		goto err_kfree;
+
+	dev_dbg(&client->dev, "chip_id=%02x\n", chip_id);
+
+	switch (chip_id) {
+	case 0x56:
+	case 0x5a:
+		break;
+	default:
+		goto err_kfree;
+	}
+
+	fe->tuner_priv = dev;
+	memcpy(&fe->ops.tuner_ops, &fc2580_tuner_ops,
+			sizeof(struct dvb_tuner_ops));
+	fe->ops.tuner_ops.release = NULL;
+	i2c_set_clientdata(client, dev);
+
+	dev_info(&client->dev, "FCI FC2580 successfully identified\n");
+	return 0;
+err_kfree:
+	kfree(dev);
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int fc2580_remove(struct i2c_client *client)
+{
+	struct fc2580_priv *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	kfree(dev);
+	return 0;
+}
+
+static const struct i2c_device_id fc2580_id_table[] = {
+	{"fc2580", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, fc2580_id_table);
+
+static struct i2c_driver fc2580_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "fc2580",
+		.suppress_bind_attrs = true,
+	},
+	.probe		= fc2580_probe,
+	.remove		= fc2580_remove,
+	.id_table	= fc2580_id_table,
+};
+
+module_i2c_driver(fc2580_driver);
+
 MODULE_DESCRIPTION("FCI FC2580 silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/fc2580.h b/drivers/media/tuners/fc2580.h
index b1ce677..5679e44 100644
--- a/drivers/media/tuners/fc2580.h
+++ b/drivers/media/tuners/fc2580.h
@@ -24,6 +24,21 @@
 #include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
+/*
+ * I2C address
+ * 0x56, ...
+ */
+
+/**
+ * struct fc2580_platform_data - Platform data for the fc2580 driver
+ * @clk: Clock frequency (0 = internal clock).
+ * @dvb_frontend: DVB frontend.
+ */
+struct fc2580_platform_data {
+	u32 clk;
+	struct dvb_frontend *dvb_frontend;
+};
+
 struct fc2580_config {
 	/*
 	 * I2C address
diff --git a/drivers/media/tuners/fc2580_priv.h b/drivers/media/tuners/fc2580_priv.h
index 646c994..a22ffc6 100644
--- a/drivers/media/tuners/fc2580_priv.h
+++ b/drivers/media/tuners/fc2580_priv.h
@@ -128,8 +128,10 @@ static const struct fc2580_freq_regs fc2580_freq_regs_lut[] = {
 };
 
 struct fc2580_priv {
-	const struct fc2580_config *cfg;
+	u32 clk;
+	struct i2c_client *client;
 	struct i2c_adapter *i2c;
+	u8 i2c_addr;
 };
 
 #endif
-- 
http://palosaari.fi/

