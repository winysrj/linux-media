Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40964 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbbEUTXN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 15:23:13 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 5/5] m88ds3103: add I2C client binding
Date: Thu, 21 May 2015 22:22:52 +0300
Message-Id: <1432236172-13964-6-git-send-email-crope@iki.fi>
In-Reply-To: <1432236172-13964-1-git-send-email-crope@iki.fi>
References: <1432236172-13964-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement I2C client device binding.
Wrap media attach to driver I2C probe.
Add wrapper from m88ds3103_attach() to m88ds3103_probe() via driver
core in order to provide proper I2C client for legacy media attach
binding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c      | 268 +++++++++++++++++++--------
 drivers/media/dvb-frontends/m88ds3103.h      |  63 ++++++-
 drivers/media/dvb-frontends/m88ds3103_priv.h |   2 +
 3 files changed, 245 insertions(+), 88 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index e45641f..01b9ded 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1357,9 +1357,9 @@ static int m88ds3103_get_tune_settings(struct dvb_frontend *fe,
 static void m88ds3103_release(struct dvb_frontend *fe)
 {
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 
-	i2c_del_mux_adapter(priv->i2c_adapter);
-	kfree(priv);
+	i2c_unregister_device(client);
 }
 
 static int m88ds3103_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
@@ -1401,43 +1401,158 @@ static int m88ds3103_deselect(struct i2c_adapter *adap, void *mux_priv,
 	return 0;
 }
 
+/*
+ * XXX: That is wrapper to m88ds3103_probe() via driver core in order to provide
+ * proper I2C client for legacy media attach binding.
+ * New users must use I2C client binding directly!
+ */
 struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
 		struct i2c_adapter *i2c, struct i2c_adapter **tuner_i2c_adapter)
 {
+	struct i2c_client *client;
+	struct i2c_board_info board_info;
+	struct m88ds3103_platform_data pdata;
+
+	pdata.clk = cfg->clock;
+	pdata.i2c_wr_max = cfg->i2c_wr_max;
+	pdata.ts_mode = cfg->ts_mode;
+	pdata.ts_clk = cfg->ts_clk;
+	pdata.ts_clk_pol = cfg->ts_clk_pol;
+	pdata.spec_inv = cfg->spec_inv;
+	pdata.agc = cfg->agc;
+	pdata.agc_inv = cfg->agc_inv;
+	pdata.clk_out = cfg->clock_out;
+	pdata.envelope_mode = cfg->envelope_mode;
+	pdata.lnb_hv_pol = cfg->lnb_hv_pol;
+	pdata.lnb_en_pol = cfg->lnb_en_pol;
+	pdata.attach_in_use = true;
+
+	memset(&board_info, 0, sizeof(board_info));
+	strlcpy(board_info.type, "m88ds3103", I2C_NAME_SIZE);
+	board_info.addr = cfg->i2c_addr;
+	board_info.platform_data = &pdata;
+	client = i2c_new_device(i2c, &board_info);
+	if (!client || !client->dev.driver)
+		return NULL;
+
+	*tuner_i2c_adapter = pdata.get_i2c_adapter(client);
+	return pdata.get_dvb_frontend(client);
+}
+EXPORT_SYMBOL(m88ds3103_attach);
+
+static struct dvb_frontend_ops m88ds3103_ops = {
+	.delsys = { SYS_DVBS, SYS_DVBS2 },
+	.info = {
+		.name = "Montage M88DS3103",
+		.frequency_min =  950000,
+		.frequency_max = 2150000,
+		.frequency_tolerance = 5000,
+		.symbol_rate_min =  1000000,
+		.symbol_rate_max = 45000000,
+		.caps = FE_CAN_INVERSION_AUTO |
+			FE_CAN_FEC_1_2 |
+			FE_CAN_FEC_2_3 |
+			FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_4_5 |
+			FE_CAN_FEC_5_6 |
+			FE_CAN_FEC_6_7 |
+			FE_CAN_FEC_7_8 |
+			FE_CAN_FEC_8_9 |
+			FE_CAN_FEC_AUTO |
+			FE_CAN_QPSK |
+			FE_CAN_RECOVER |
+			FE_CAN_2G_MODULATION
+	},
+
+	.release = m88ds3103_release,
+
+	.get_tune_settings = m88ds3103_get_tune_settings,
+
+	.init = m88ds3103_init,
+	.sleep = m88ds3103_sleep,
+
+	.set_frontend = m88ds3103_set_frontend,
+	.get_frontend = m88ds3103_get_frontend,
+
+	.read_status = m88ds3103_read_status,
+	.read_snr = m88ds3103_read_snr,
+	.read_ber = m88ds3103_read_ber,
+
+	.diseqc_send_master_cmd = m88ds3103_diseqc_send_master_cmd,
+	.diseqc_send_burst = m88ds3103_diseqc_send_burst,
+
+	.set_tone = m88ds3103_set_tone,
+	.set_voltage = m88ds3103_set_voltage,
+};
+
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
 	int ret;
-	struct m88ds3103_priv *priv;
 	u8 chip_id, u8tmp;
 
-	/* allocate memory for the internal priv */
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
 		ret = -ENOMEM;
-		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
 		goto err;
 	}
 
-	priv->cfg = cfg;
-	priv->i2c = i2c;
-	mutex_init(&priv->i2c_mutex);
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
 
 	/* 0x00: chip id[6:0], 0x01: chip ver[7:0], 0x02: chip ver[15:8] */
-	ret = m88ds3103_rd_reg(priv, 0x00, &chip_id);
+	ret = m88ds3103_rd_reg(dev, 0x00, &chip_id);
 	if (ret)
-		goto err;
+		goto err_kfree;
 
 	chip_id >>= 1;
-	dev_info(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
+	dev_dbg(&client->dev, "chip_id=%02x\n", chip_id);
 
 	switch (chip_id) {
 	case M88RS6000_CHIP_ID:
 	case M88DS3103_CHIP_ID:
 		break;
 	default:
-		goto err;
+		goto err_kfree;
 	}
-	priv->chip_id = chip_id;
+	dev->chip_id = chip_id;
 
-	switch (priv->cfg->clock_out) {
+	switch (dev->cfg->clock_out) {
 	case M88DS3103_CLOCK_OUT_DISABLED:
 		u8tmp = 0x80;
 		break;
@@ -1448,7 +1563,7 @@ struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
 		u8tmp = 0x10;
 		break;
 	default:
-		goto err;
+		goto err_kfree;
 	}
 
 	/* 0x29 register is defined differently for m88rs6000. */
@@ -1456,91 +1571,80 @@ struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
 	if (chip_id == M88RS6000_CHIP_ID)
 		u8tmp = 0x00;
 
-	ret = m88ds3103_wr_reg(priv, 0x29, u8tmp);
+	ret = m88ds3103_wr_reg(dev, 0x29, u8tmp);
 	if (ret)
-		goto err;
+		goto err_kfree;
 
 	/* sleep */
-	ret = m88ds3103_wr_reg_mask(priv, 0x08, 0x00, 0x01);
+	ret = m88ds3103_wr_reg_mask(dev, 0x08, 0x00, 0x01);
 	if (ret)
-		goto err;
-
-	ret = m88ds3103_wr_reg_mask(priv, 0x04, 0x01, 0x01);
+		goto err_kfree;
+	ret = m88ds3103_wr_reg_mask(dev, 0x04, 0x01, 0x01);
 	if (ret)
-		goto err;
-
-	ret = m88ds3103_wr_reg_mask(priv, 0x23, 0x10, 0x10);
+		goto err_kfree;
+	ret = m88ds3103_wr_reg_mask(dev, 0x23, 0x10, 0x10);
 	if (ret)
-		goto err;
+		goto err_kfree;
 
 	/* create mux i2c adapter for tuner */
-	priv->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, priv, 0, 0, 0,
-			m88ds3103_select, m88ds3103_deselect);
-	if (priv->i2c_adapter == NULL)
-		goto err;
-
-	*tuner_i2c_adapter = priv->i2c_adapter;
+	dev->i2c_adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
+					       dev, 0, 0, 0, m88ds3103_select,
+					       m88ds3103_deselect);
+	if (dev->i2c_adapter == NULL)
+		goto err_kfree;
 
 	/* create dvb_frontend */
-	memcpy(&priv->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
-	if (priv->chip_id == M88RS6000_CHIP_ID)
-		strncpy(priv->fe.ops.info.name,
-			"Montage M88RS6000", sizeof(priv->fe.ops.info.name));
-	priv->fe.demodulator_priv = priv;
-
-	return &priv->fe;
+	memcpy(&dev->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
+	if (dev->chip_id == M88RS6000_CHIP_ID)
+		strncpy(dev->fe.ops.info.name,
+			"Montage M88RS6000", sizeof(dev->fe.ops.info.name));
+	if (!pdata->attach_in_use)
+		dev->fe.ops.release = NULL;
+	dev->fe.demodulator_priv = dev;
+	i2c_set_clientdata(client, dev);
+
+	/* setup callbacks */
+	pdata->get_dvb_frontend = m88ds3103_get_dvb_frontend;
+	pdata->get_i2c_adapter = m88ds3103_get_i2c_adapter;
+	return 0;
+err_kfree:
+	kfree(dev);
 err:
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
-	kfree(priv);
-	return NULL;
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
 }
-EXPORT_SYMBOL(m88ds3103_attach);
-
-static struct dvb_frontend_ops m88ds3103_ops = {
-	.delsys = { SYS_DVBS, SYS_DVBS2 },
-	.info = {
-		.name = "Montage M88DS3103",
-		.frequency_min =  950000,
-		.frequency_max = 2150000,
-		.frequency_tolerance = 5000,
-		.symbol_rate_min =  1000000,
-		.symbol_rate_max = 45000000,
-		.caps = FE_CAN_INVERSION_AUTO |
-			FE_CAN_FEC_1_2 |
-			FE_CAN_FEC_2_3 |
-			FE_CAN_FEC_3_4 |
-			FE_CAN_FEC_4_5 |
-			FE_CAN_FEC_5_6 |
-			FE_CAN_FEC_6_7 |
-			FE_CAN_FEC_7_8 |
-			FE_CAN_FEC_8_9 |
-			FE_CAN_FEC_AUTO |
-			FE_CAN_QPSK |
-			FE_CAN_RECOVER |
-			FE_CAN_2G_MODULATION
-	},
 
-	.release = m88ds3103_release,
+static int m88ds3103_remove(struct i2c_client *client)
+{
+	struct m88ds3103_priv *dev = i2c_get_clientdata(client);
 
-	.get_tune_settings = m88ds3103_get_tune_settings,
+	dev_dbg(&client->dev, "\n");
 
-	.init = m88ds3103_init,
-	.sleep = m88ds3103_sleep,
+	i2c_del_mux_adapter(dev->i2c_adapter);
 
-	.set_frontend = m88ds3103_set_frontend,
-	.get_frontend = m88ds3103_get_frontend,
-
-	.read_status = m88ds3103_read_status,
-	.read_snr = m88ds3103_read_snr,
-	.read_ber = m88ds3103_read_ber,
+	kfree(dev);
+	return 0;
+}
 
-	.diseqc_send_master_cmd = m88ds3103_diseqc_send_master_cmd,
-	.diseqc_send_burst = m88ds3103_diseqc_send_burst,
+static const struct i2c_device_id m88ds3103_id_table[] = {
+	{"m88ds3103", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, m88ds3103_id_table);
 
-	.set_tone = m88ds3103_set_tone,
-	.set_voltage = m88ds3103_set_voltage,
+static struct i2c_driver m88ds3103_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "m88ds3103",
+		.suppress_bind_attrs = true,
+	},
+	.probe		= m88ds3103_probe,
+	.remove		= m88ds3103_remove,
+	.id_table	= m88ds3103_id_table,
 };
 
+module_i2c_driver(m88ds3103_driver);
+
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Montage M88DS3103 DVB-S/S2 demodulator driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/m88ds3103.h b/drivers/media/dvb-frontends/m88ds3103.h
index 9b3b496..3811468 100644
--- a/drivers/media/dvb-frontends/m88ds3103.h
+++ b/drivers/media/dvb-frontends/m88ds3103.h
@@ -19,6 +19,63 @@
 
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
+
+/* private: For legacy media attach wrapper. Do not set value. */
+	u8 attach_in_use:1;
+};
+
+/*
+ * Do not add new m88ds3103_attach() users! Use I2C bindings instead.
+ */
 struct m88ds3103_config {
 	/*
 	 * I2C address
@@ -113,12 +170,6 @@ struct m88ds3103_config {
 	u8 lnb_en_pol:1;
 };
 
-/*
- * Driver implements own I2C-adapter for tuner I2C access. That's since chip
- * has I2C-gate control which closes gate automatically after I2C transfer.
- * Using own I2C adapter we can workaround that.
- */
-
 #if defined(CONFIG_DVB_M88DS3103) || \
 		(defined(CONFIG_DVB_M88DS3103_MODULE) && defined(MODULE))
 extern struct dvb_frontend *m88ds3103_attach(
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

