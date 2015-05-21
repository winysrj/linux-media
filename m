Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42751 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161017AbbEUVYK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 17:24:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/8] tda10071: implement I2C client bindings
Date: Fri, 22 May 2015 00:23:51 +0300
Message-Id: <1432243438-12225-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement I2C client bindings.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c      | 95 +++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/tda10071.h      | 29 +++++++++
 drivers/media/dvb-frontends/tda10071_priv.h |  1 +
 3 files changed, 125 insertions(+)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 4a19b85..3132854 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -1313,6 +1313,101 @@ static struct dvb_frontend_ops tda10071_ops = {
 	.set_voltage = tda10071_set_voltage,
 };
 
+static struct dvb_frontend *tda10071_get_dvb_frontend(struct i2c_client *client)
+{
+	struct tda10071_priv *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	return &dev->fe;
+}
+
+static int tda10071_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct tda10071_priv *dev;
+	struct tda10071_platform_data *pdata = client->dev.platform_data;
+	int ret;
+	u8 u8tmp;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	dev->client = client;
+	dev->i2c = client->adapter;
+	dev->cfg.demod_i2c_addr = client->addr;
+	dev->cfg.i2c_wr_max = pdata->i2c_wr_max;
+	dev->cfg.ts_mode = pdata->ts_mode;
+	dev->cfg.spec_inv = pdata->spec_inv;
+	dev->cfg.xtal = pdata->clk;
+	dev->cfg.pll_multiplier = pdata->pll_multiplier;
+	dev->cfg.tuner_i2c_addr = pdata->tuner_i2c_addr;
+
+	/* chip ID */
+	ret = tda10071_rd_reg(dev, 0xff, &u8tmp);
+	if (ret || u8tmp != 0x0f)
+		goto err_kfree;
+
+	/* chip type */
+	ret = tda10071_rd_reg(dev, 0xdd, &u8tmp);
+	if (ret || u8tmp != 0x00)
+		goto err_kfree;
+
+	/* chip version */
+	ret = tda10071_rd_reg(dev, 0xfe, &u8tmp);
+	if (ret || u8tmp != 0x01)
+		goto err_kfree;
+
+	/* create dvb_frontend */
+	memcpy(&dev->fe.ops, &tda10071_ops, sizeof(struct dvb_frontend_ops));
+	dev->fe.ops.release = NULL;
+	dev->fe.demodulator_priv = dev;
+	i2c_set_clientdata(client, dev);
+
+	/* setup callbacks */
+	pdata->get_dvb_frontend = tda10071_get_dvb_frontend;
+
+	dev_info(&client->dev, "NXP TDA10071 successfully identified\n");
+	return 0;
+err_kfree:
+	kfree(dev);
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int tda10071_remove(struct i2c_client *client)
+{
+	struct tda10071_dev *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	kfree(dev);
+	return 0;
+}
+
+static const struct i2c_device_id tda10071_id_table[] = {
+	{"tda10071_cx24118", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, tda10071_id_table);
+
+static struct i2c_driver tda10071_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "tda10071",
+		.suppress_bind_attrs = true,
+	},
+	.probe		= tda10071_probe,
+	.remove		= tda10071_remove,
+	.id_table	= tda10071_id_table,
+};
+
+module_i2c_driver(tda10071_driver);
+
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("NXP TDA10071 DVB-S/S2 demodulator driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
index da89f42..0ffbfa5 100644
--- a/drivers/media/dvb-frontends/tda10071.h
+++ b/drivers/media/dvb-frontends/tda10071.h
@@ -24,6 +24,35 @@
 #include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
+/*
+ * I2C address
+ * 0x55,
+ */
+
+/**
+ * struct tda10071_platform_data - Platform data for the tda10071 driver
+ * @clk: Clock frequency.
+ * @i2c_wr_max: Max bytes I2C adapter can write at once.
+ * @ts_mode: TS mode.
+ * @spec_inv: Input spectrum inversion.
+ * @pll_multiplier: PLL multiplier.
+ * @tuner_i2c_addr: CX24118A tuner I2C address (0x14, 0x54, ...).
+ * @get_dvb_frontend: Get DVB frontend.
+ */
+
+struct tda10071_platform_data {
+	u32 clk;
+	u16 i2c_wr_max;
+#define TDA10071_TS_SERIAL        0
+#define TDA10071_TS_PARALLEL      1
+	u8 ts_mode;
+	bool spec_inv;
+	u8 pll_multiplier;
+	u8 tuner_i2c_addr;
+
+	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
+};
+
 struct tda10071_config {
 	/* Demodulator I2C address.
 	 * Default: none, must set
diff --git a/drivers/media/dvb-frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
index 03f839c..7ec69ac 100644
--- a/drivers/media/dvb-frontends/tda10071_priv.h
+++ b/drivers/media/dvb-frontends/tda10071_priv.h
@@ -28,6 +28,7 @@
 struct tda10071_priv {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
+	struct i2c_client *client;
 	struct tda10071_config cfg;
 
 	u8 meas_count[2];
-- 
http://palosaari.fi/

