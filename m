Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39853 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbbG0LWq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 07:22:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/6] mt2060: add i2c bindings
Date: Mon, 27 Jul 2015 14:22:05 +0300
Message-Id: <1437996130-23735-2-git-send-email-crope@iki.fi>
In-Reply-To: <1437996130-23735-1-git-send-email-crope@iki.fi>
References: <1437996130-23735-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add proper i2c driver model bindings.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/mt2060.c      | 83 ++++++++++++++++++++++++++++++++++++++
 drivers/media/tuners/mt2060.h      | 20 +++++++++
 drivers/media/tuners/mt2060_priv.h |  2 +
 3 files changed, 105 insertions(+)

diff --git a/drivers/media/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
index b87b254..aa8280a 100644
--- a/drivers/media/tuners/mt2060.c
+++ b/drivers/media/tuners/mt2060.c
@@ -397,6 +397,89 @@ struct dvb_frontend * mt2060_attach(struct dvb_frontend *fe, struct i2c_adapter
 }
 EXPORT_SYMBOL(mt2060_attach);
 
+static int mt2060_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct mt2060_platform_data *pdata = client->dev.platform_data;
+	struct dvb_frontend *fe;
+	struct mt2060_priv *dev;
+	int ret;
+	u8 chip_id;
+
+	dev_dbg(&client->dev, "\n");
+
+	if (!pdata) {
+		dev_err(&client->dev, "Cannot proceed without platform data\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	dev = devm_kzalloc(&client->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	fe = pdata->dvb_frontend;
+	dev->config.i2c_address = client->addr;
+	dev->config.clock_out = pdata->clock_out;
+	dev->cfg = &dev->config;
+	dev->i2c = client->adapter;
+	dev->if1_freq = pdata->if1 ? pdata->if1 : 1220;
+	dev->client = client;
+
+	ret = mt2060_readreg(dev, REG_PART_REV, &chip_id);
+	if (ret) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	dev_dbg(&client->dev, "chip id=%02x\n", chip_id);
+
+	if (chip_id != PART_REV) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	dev_info(&client->dev, "Microtune MT2060 successfully identified\n");
+	memcpy(&fe->ops.tuner_ops, &mt2060_tuner_ops, sizeof(fe->ops.tuner_ops));
+	fe->ops.tuner_ops.release = NULL;
+	fe->tuner_priv = dev;
+	i2c_set_clientdata(client, dev);
+
+	mt2060_calibrate(dev);
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int mt2060_remove(struct i2c_client *client)
+{
+	dev_dbg(&client->dev, "\n");
+
+	return 0;
+}
+
+static const struct i2c_device_id mt2060_id_table[] = {
+	{"mt2060", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, mt2060_id_table);
+
+static struct i2c_driver mt2060_driver = {
+	.driver = {
+		.name = "mt2060",
+		.suppress_bind_attrs = true,
+	},
+	.probe		= mt2060_probe,
+	.remove		= mt2060_remove,
+	.id_table	= mt2060_id_table,
+};
+
+module_i2c_driver(mt2060_driver);
+
 MODULE_AUTHOR("Olivier DANET");
 MODULE_DESCRIPTION("Microtune MT2060 silicon tuner driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/mt2060.h b/drivers/media/tuners/mt2060.h
index 6efed35..05c0d55 100644
--- a/drivers/media/tuners/mt2060.h
+++ b/drivers/media/tuners/mt2060.h
@@ -25,6 +25,26 @@
 struct dvb_frontend;
 struct i2c_adapter;
 
+/*
+ * I2C address
+ * 0x60, ...
+ */
+
+/**
+ * struct mt2060_platform_data - Platform data for the mt2060 driver
+ * @clock_out: Clock output setting. 0 = off, 1 = CLK/4, 2 = CLK/2, 3 = CLK/1.
+ * @if1: First IF used [MHz]. 0 defaults to 1220.
+ * @dvb_frontend: DVB frontend.
+ */
+
+struct mt2060_platform_data {
+	u8 clock_out;
+	u16 if1;
+	struct dvb_frontend *dvb_frontend;
+};
+
+
+/* configuration struct for mt2060_attach() */
 struct mt2060_config {
 	u8 i2c_address;
 	u8 clock_out; /* 0 = off, 1 = CLK/4, 2 = CLK/2, 3 = CLK/1 */
diff --git a/drivers/media/tuners/mt2060_priv.h b/drivers/media/tuners/mt2060_priv.h
index 2b60de6..dfc4a06 100644
--- a/drivers/media/tuners/mt2060_priv.h
+++ b/drivers/media/tuners/mt2060_priv.h
@@ -95,6 +95,8 @@
 struct mt2060_priv {
 	struct mt2060_config *cfg;
 	struct i2c_adapter   *i2c;
+	struct i2c_client *client;
+	struct mt2060_config config;
 
 	u32 frequency;
 	u16 if1_freq;
-- 
http://palosaari.fi/

