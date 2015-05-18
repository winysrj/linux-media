Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40619 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbbERFJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 01:09:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/8] m88ds3103: add I2C client binding
Date: Mon, 18 May 2015 08:08:50 +0300
Message-Id: <1431925731-7499-7-git-send-email-crope@iki.fi>
In-Reply-To: <1431925731-7499-1-git-send-email-crope@iki.fi>
References: <1431925731-7499-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement I2C client device binding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c      | 159 +++++++++++++++++++++++++++
 drivers/media/dvb-frontends/m88ds3103.h      |  51 +++++++++
 drivers/media/dvb-frontends/m88ds3103_priv.h |   2 +
 3 files changed, 212 insertions(+)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index e45641f..d837dd2 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1541,6 +1541,165 @@ static struct dvb_frontend_ops m88ds3103_ops = {
 	.set_voltage = m88ds3103_set_voltage,
 };
 
+static struct dvb_frontend *m88ds3103_get_dvb_frontend(struct i2c_client *client)
+{
+	struct m88ds3103_priv *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	return &dev->fe;
+}
+
+static struct i2c_adapter *m88ds3103_get_i2c_adapter(struct i2c_client *client)
+{
+	struct m88ds3103_priv *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	return dev->i2c_adapter;
+}
+
+static int m88ds3103_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct m88ds3103_priv *dev;
+	struct m88ds3103_platform_data *pdata = client->dev.platform_data;
+	int ret;
+	u8 chip_id, u8tmp;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	dev->client = client;
+	dev->i2c = client->adapter;
+	dev->config.i2c_addr = client->addr;
+	dev->config.clock = pdata->clk;
+	dev->config.i2c_wr_max = pdata->i2c_wr_max;
+	dev->config.ts_mode = pdata->ts_mode;
+	dev->config.ts_clk = pdata->ts_clk;
+	dev->config.ts_clk_pol = pdata->ts_clk_pol;
+	dev->config.spec_inv = pdata->spec_inv;
+	dev->config.agc_inv = pdata->agc_inv;
+	dev->config.clock_out = pdata->clk_out;
+	dev->config.envelope_mode = pdata->envelope_mode;
+	dev->config.agc = pdata->agc;
+	dev->config.lnb_hv_pol = pdata->lnb_hv_pol;
+	dev->config.lnb_en_pol = pdata->lnb_en_pol;
+	dev->cfg = &dev->config;
+	mutex_init(&dev->i2c_mutex);
+
+	/* 0x00: chip id[6:0], 0x01: chip ver[7:0], 0x02: chip ver[15:8] */
+	ret = m88ds3103_rd_reg(dev, 0x00, &chip_id);
+	if (ret)
+		goto err_kfree;
+
+	chip_id >>= 1;
+	dev_dbg(&client->dev, "chip_id=%02x\n", chip_id);
+
+	switch (chip_id) {
+	case M88RS6000_CHIP_ID:
+	case M88DS3103_CHIP_ID:
+		break;
+	default:
+		goto err_kfree;
+	}
+	dev->chip_id = chip_id;
+
+	switch (dev->cfg->clock_out) {
+	case M88DS3103_CLOCK_OUT_DISABLED:
+		u8tmp = 0x80;
+		break;
+	case M88DS3103_CLOCK_OUT_ENABLED:
+		u8tmp = 0x00;
+		break;
+	case M88DS3103_CLOCK_OUT_ENABLED_DIV2:
+		u8tmp = 0x10;
+		break;
+	default:
+		goto err_kfree;
+	}
+
+	/* 0x29 register is defined differently for m88rs6000. */
+	/* set internal tuner address to 0x21 */
+	if (chip_id == M88RS6000_CHIP_ID)
+		u8tmp = 0x00;
+
+	ret = m88ds3103_wr_reg(dev, 0x29, u8tmp);
+	if (ret)
+		goto err_kfree;
+
+	/* sleep */
+	ret = m88ds3103_wr_reg_mask(dev, 0x08, 0x00, 0x01);
+	if (ret)
+		goto err_kfree;
+	ret = m88ds3103_wr_reg_mask(dev, 0x04, 0x01, 0x01);
+	if (ret)
+		goto err_kfree;
+	ret = m88ds3103_wr_reg_mask(dev, 0x23, 0x10, 0x10);
+	if (ret)
+		goto err_kfree;
+
+	/* create mux i2c adapter for tuner */
+	dev->i2c_adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
+					       dev, 0, 0, 0, m88ds3103_select,
+					       m88ds3103_deselect);
+	if (dev->i2c_adapter == NULL)
+		goto err_kfree;
+
+	/* create dvb_frontend */
+	memcpy(&dev->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
+	if (dev->chip_id == M88RS6000_CHIP_ID)
+		strncpy(dev->fe.ops.info.name,
+			"Montage M88RS6000", sizeof(dev->fe.ops.info.name));
+	dev->fe.ops.release = NULL;
+	dev->fe.demodulator_priv = dev;
+	i2c_set_clientdata(client, dev);
+
+	/* setup callbacks */
+	pdata->get_dvb_frontend = m88ds3103_get_dvb_frontend;
+	pdata->get_i2c_adapter = m88ds3103_get_i2c_adapter;
+	return 0;
+err_kfree:
+	kfree(dev);
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int m88ds3103_remove(struct i2c_client *client)
+{
+	struct m88ds3103_priv *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	i2c_del_mux_adapter(dev->i2c_adapter);
+
+	kfree(dev);
+	return 0;
+}
+
+static const struct i2c_device_id m88ds3103_id_table[] = {
+	{"m88ds3103", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, m88ds3103_id_table);
+
+static struct i2c_driver m88ds3103_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "m88ds3103",
+		.suppress_bind_attrs = true,
+	},
+	.probe		= m88ds3103_probe,
+	.remove		= m88ds3103_remove,
+	.id_table	= m88ds3103_id_table,
+};
+
+module_i2c_driver(m88ds3103_driver);
+
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Montage M88DS3103 DVB-S/S2 demodulator driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/m88ds3103.h b/drivers/media/dvb-frontends/m88ds3103.h
index 9b3b496..ddcd10a 100644
--- a/drivers/media/dvb-frontends/m88ds3103.h
+++ b/drivers/media/dvb-frontends/m88ds3103.h
@@ -19,6 +19,57 @@
 
 #include <linux/dvb/frontend.h>
 
+/*
+ * I2C address
+ * 0x68,
+ */
+
+/**
+ * struct m88ds3103_platform_data - Platform data for the m88ds3103 driver
+ * @clk: Clock frequency.
+ * @i2c_wr_max: Max bytes I2C adapter can write at once.
+ * @ts_mode: TS mode.
+ * @ts_clk: TS clock (KHz).
+ * @ts_clk_pol: TS clk polarity. 1-active at falling edge; 0-active at rising
+ *  edge.
+ * @spec_inv: Input spectrum inversion.
+ * @agc: AGC configuration.
+ * @agc_inv: AGC polarity.
+ * @clk_out: Clock output.
+ * @envelope_mode: DiSEqC envelope mode.
+ * @lnb_hv_pol: LNB H/V pin polarity. 0: pin high set to VOLTAGE_18, pin low to
+ *  set VOLTAGE_13. 1: pin high set to VOLTAGE_13, pin low to set VOLTAGE_18.
+ * @lnb_en_pol: LNB enable pin polarity. 0: pin high to disable, pin low to
+ *  enable. 1: pin high to enable, pin low to disable.
+ * @get_dvb_frontend: Get DVB frontend.
+ * @get_i2c_adapter: Get I2C adapter.
+ */
+
+struct m88ds3103_platform_data {
+	u32 clk;
+	u16 i2c_wr_max;
+#define M88DS3103_TS_SERIAL             0 /* TS output pin D0, normal */
+#define M88DS3103_TS_SERIAL_D7          1 /* TS output pin D7 */
+#define M88DS3103_TS_PARALLEL           2 /* TS Parallel mode */
+#define M88DS3103_TS_CI                 3 /* TS CI Mode */
+	u8 ts_mode:2;
+	u32 ts_clk;
+	u8 ts_clk_pol:1;
+	u8 spec_inv:1;
+	u8 agc;
+	u8 agc_inv:1;
+#define M88DS3103_CLOCK_OUT_DISABLED        0
+#define M88DS3103_CLOCK_OUT_ENABLED         1
+#define M88DS3103_CLOCK_OUT_ENABLED_DIV2    2
+	u8 clk_out:2;
+	u8 envelope_mode:1;
+	u8 lnb_hv_pol:1;
+	u8 lnb_en_pol:1;
+
+	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
+	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
+};
+
 struct m88ds3103_config {
 	/*
 	 * I2C address
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index 78e58e3..6217d92 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -32,8 +32,10 @@
 
 struct m88ds3103_priv {
 	struct i2c_adapter *i2c;
+	struct i2c_client *client;
 	/* mutex needed due to own tuner I2C adapter */
 	struct mutex i2c_mutex;
+	struct m88ds3103_config config;
 	const struct m88ds3103_config *cfg;
 	struct dvb_frontend fe;
 	fe_delivery_system_t delivery_system;
-- 
http://palosaari.fi/

