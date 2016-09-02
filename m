Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60782 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752621AbcIBWhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 18:37:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/9] cxd2820r: add I2C driver bindings
Date: Sat,  3 Sep 2016 01:37:21 +0300
Message-Id: <1472855844-8665-6-git-send-email-crope@iki.fi>
In-Reply-To: <1472855844-8665-1-git-send-email-crope@iki.fi>
References: <1472855844-8665-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add I2C driver bindings in order to support proper I2C driver
registration with driver core.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r.h      |  26 ++++
 drivers/media/dvb-frontends/cxd2820r_c.c    |   6 +-
 drivers/media/dvb-frontends/cxd2820r_core.c | 190 ++++++++++++++++++++++------
 drivers/media/dvb-frontends/cxd2820r_priv.h |   7 +-
 drivers/media/dvb-frontends/cxd2820r_t.c    |   6 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c   |   8 +-
 6 files changed, 191 insertions(+), 52 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r.h b/drivers/media/dvb-frontends/cxd2820r.h
index 56d4276..d77afe0 100644
--- a/drivers/media/dvb-frontends/cxd2820r.h
+++ b/drivers/media/dvb-frontends/cxd2820r.h
@@ -37,6 +37,32 @@
 #define CXD2820R_TS_PARALLEL      0x30
 #define CXD2820R_TS_PARALLEL_MSB  0x70
 
+/*
+ * I2C address: 0x6c, 0x6d
+ */
+
+/**
+ * struct cxd2820r_platform_data - Platform data for the cxd2820r driver
+ * @ts_mode: TS mode.
+ * @ts_clk_inv: TS clock inverted.
+ * @if_agc_polarity: IF AGC polarity.
+ * @spec_inv: Input spectrum inverted.
+ * @gpio_chip_base: GPIO.
+ * @get_dvb_frontend: Get DVB frontend.
+ */
+
+struct cxd2820r_platform_data {
+	u8 ts_mode;
+	bool ts_clk_inv;
+	bool if_agc_polarity;
+	bool spec_inv;
+	int **gpio_chip_base;
+
+	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
+/* private: For legacy media attach wrapper. Do not set value. */
+	bool attach_in_use;
+};
+
 struct cxd2820r_config {
 	/* Demodulator I2C address.
 	 * Driver determines DVB-C slave I2C address automatically from master
diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index 82df944..0d036e1 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -42,9 +42,9 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 		{ 0x10059, 0x50, 0xff },
 		{ 0x10087, 0x0c, 0x3c },
 		{ 0x1008b, 0x07, 0xff },
-		{ 0x1001f, priv->cfg.if_agc_polarity << 7, 0x80 },
-		{ 0x10070, priv->cfg.ts_mode, 0xff },
-		{ 0x10071, !priv->cfg.ts_clock_inv << 4, 0x10 },
+		{ 0x1001f, priv->if_agc_polarity << 7, 0x80 },
+		{ 0x10070, priv->ts_mode, 0xff },
+		{ 0x10071, !priv->ts_clk_inv << 4, 0x10 },
 	};
 
 	dev_dbg(&priv->i2c->dev, "%s: frequency=%d symbol_rate=%d\n", __func__,
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 66da821..cf5eed4 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -49,7 +49,7 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(priv->i2c, msg, 1);
+	ret = i2c_transfer(priv->client[0]->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
@@ -87,7 +87,7 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		return -EINVAL;
 	}
 
-	ret = i2c_transfer(priv->i2c, msg, 2);
+	ret = i2c_transfer(priv->client[0]->adapter, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
 		ret = 0;
@@ -112,9 +112,9 @@ int cxd2820r_wr_regs(struct cxd2820r_priv *priv, u32 reginfo, u8 *val,
 
 	/* select I2C */
 	if (i2c)
-		i2c_addr = priv->cfg.i2c_address | (1 << 1); /* DVB-C */
+		i2c_addr = priv->client[1]->addr; /* DVB-C */
 	else
-		i2c_addr = priv->cfg.i2c_address; /* DVB-T/T2 */
+		i2c_addr = priv->client[0]->addr; /* DVB-T/T2 */
 
 	/* switch bank if needed */
 	if (bank != priv->bank[i2c]) {
@@ -138,9 +138,9 @@ int cxd2820r_rd_regs(struct cxd2820r_priv *priv, u32 reginfo, u8 *val,
 
 	/* select I2C */
 	if (i2c)
-		i2c_addr = priv->cfg.i2c_address | (1 << 1); /* DVB-C */
+		i2c_addr = priv->client[1]->addr; /* DVB-C */
 	else
-		i2c_addr = priv->cfg.i2c_address; /* DVB-T/T2 */
+		i2c_addr = priv->client[0]->addr; /* DVB-T/T2 */
 
 	/* switch bank if needed */
 	if (bank != priv->bank[i2c]) {
@@ -537,16 +537,12 @@ static int cxd2820r_get_frontend_algo(struct dvb_frontend *fe)
 static void cxd2820r_release(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 
 	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
 
-#ifdef CONFIG_GPIOLIB
-	/* remove GPIOs */
-	if (priv->gpio_chip.label)
-		gpiochip_remove(&priv->gpio_chip);
+	i2c_unregister_device(client);
 
-#endif
-	kfree(priv);
 	return;
 }
 
@@ -646,49 +642,113 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
 	.read_signal_strength	= cxd2820r_read_signal_strength,
 };
 
-struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
-		struct i2c_adapter *i2c, int *gpio_chip_base
-)
+/*
+ * XXX: That is wrapper to cxd2820r_probe() via driver core in order to provide
+ * proper I2C client for legacy media attach binding.
+ * New users must use I2C client binding directly!
+ */
+struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *config,
+				     struct i2c_adapter *adapter,
+				     int *gpio_chip_base)
 {
+	struct i2c_client *client;
+	struct i2c_board_info board_info;
+	struct cxd2820r_platform_data pdata;
+
+	pdata.ts_mode = config->ts_mode;
+	pdata.ts_clk_inv = config->ts_clock_inv;
+	pdata.if_agc_polarity = config->if_agc_polarity;
+	pdata.spec_inv = config->spec_inv;
+	pdata.gpio_chip_base = &gpio_chip_base;
+	pdata.attach_in_use = true;
+
+	memset(&board_info, 0, sizeof(board_info));
+	strlcpy(board_info.type, "cxd2820r", I2C_NAME_SIZE);
+	board_info.addr = config->i2c_address;
+	board_info.platform_data = &pdata;
+	client = i2c_new_device(adapter, &board_info);
+	if (!client || !client->dev.driver)
+		return NULL;
+
+	return pdata.get_dvb_frontend(client);
+}
+EXPORT_SYMBOL(cxd2820r_attach);
+
+static struct dvb_frontend *cxd2820r_get_dvb_frontend(struct i2c_client *client)
+{
+	struct cxd2820r_priv *priv = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	return &priv->fe;
+}
+
+static int cxd2820r_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
+{
+	struct cxd2820r_platform_data *pdata = client->dev.platform_data;
 	struct cxd2820r_priv *priv;
-	int ret;
-	u8 tmp;
+	int ret, *gpio_chip_base;
+	u8 u8tmp;
 
-	priv = kzalloc(sizeof(struct cxd2820r_priv), GFP_KERNEL);
+	dev_dbg(&client->dev, "\n");
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
 		ret = -ENOMEM;
-		dev_err(&i2c->dev, "%s: kzalloc() failed\n",
-				KBUILD_MODNAME);
-		goto error;
+		goto err;
 	}
 
-	priv->i2c = i2c;
-	memcpy(&priv->cfg, cfg, sizeof(struct cxd2820r_config));
-	memcpy(&priv->fe.ops, &cxd2820r_ops, sizeof(struct dvb_frontend_ops));
-	priv->fe.demodulator_priv = priv;
+	priv->client[0] = client;
+	priv->i2c = client->adapter;
+	priv->ts_mode = pdata->ts_mode;
+	priv->ts_clk_inv = pdata->ts_clk_inv;
+	priv->if_agc_polarity = pdata->if_agc_polarity;
+	priv->spec_inv = pdata->spec_inv;
+	priv->bank[0] = 0xff;
+	priv->bank[1] = 0xff;
+	gpio_chip_base = *pdata->gpio_chip_base;
+
+	/* Check demod answers with correct chip id */
+	ret = cxd2820r_rd_reg(priv, 0x000fd, &u8tmp);
+	if (ret)
+		goto err_kfree;
 
-	priv->bank[0] = priv->bank[1] = 0xff;
-	ret = cxd2820r_rd_reg(priv, 0x000fd, &tmp);
-	dev_dbg(&priv->i2c->dev, "%s: chip id=%02x\n", __func__, tmp);
-	if (ret || tmp != 0xe1)
-		goto error;
+	dev_dbg(&client->dev, "chip_id=%02x\n", u8tmp);
+
+	if (u8tmp != 0xe1) {
+		ret = -ENODEV;
+		goto err_kfree;
+	}
+
+	/*
+	 * Chip has two I2C addresses for different register banks. We register
+	 * one dummy I2C client in in order to get own I2C client for each
+	 * register bank.
+	 */
+	priv->client[1] = i2c_new_dummy(client->adapter, client->addr | (1 << 1));
+	if (!priv->client[1]) {
+		ret = -ENODEV;
+		dev_err(&client->dev, "I2C registration failed\n");
+		if (ret)
+			goto err_kfree;
+	}
 
 	if (gpio_chip_base) {
 #ifdef CONFIG_GPIOLIB
-		/* add GPIOs */
+		/* Add GPIOs */
 		priv->gpio_chip.label = KBUILD_MODNAME;
 		priv->gpio_chip.parent = &priv->i2c->dev;
 		priv->gpio_chip.owner = THIS_MODULE;
-		priv->gpio_chip.direction_output =
-				cxd2820r_gpio_direction_output;
+		priv->gpio_chip.direction_output = cxd2820r_gpio_direction_output;
 		priv->gpio_chip.set = cxd2820r_gpio_set;
 		priv->gpio_chip.get = cxd2820r_gpio_get;
-		priv->gpio_chip.base = -1; /* dynamic allocation */
+		priv->gpio_chip.base = -1; /* Dynamic allocation */
 		priv->gpio_chip.ngpio = GPIO_COUNT;
 		priv->gpio_chip.can_sleep = 1;
 		ret = gpiochip_add_data(&priv->gpio_chip, priv);
 		if (ret)
-			goto error;
+			goto err_client_1_i2c_unregister_device;
 
 		dev_dbg(&priv->i2c->dev, "%s: gpio_chip.base=%d\n", __func__,
 				priv->gpio_chip.base);
@@ -705,17 +765,65 @@ struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 		gpio[2] = 0;
 		ret = cxd2820r_gpio(&priv->fe, gpio);
 		if (ret)
-			goto error;
+			goto err_client_1_i2c_unregister_device;
 #endif
 	}
 
-	return &priv->fe;
-error:
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
+	/* Create dvb frontend */
+	memcpy(&priv->fe.ops, &cxd2820r_ops, sizeof(priv->fe.ops));
+	if (!pdata->attach_in_use)
+		priv->fe.ops.release = NULL;
+	priv->fe.demodulator_priv = priv;
+	i2c_set_clientdata(client, priv);
+
+	/* Setup callbacks */
+	pdata->get_dvb_frontend = cxd2820r_get_dvb_frontend;
+
+	dev_info(&client->dev, "Sony CXD2820R successfully identified\n");
+
+	return 0;
+err_client_1_i2c_unregister_device:
+	i2c_unregister_device(priv->client[1]);
+err_kfree:
 	kfree(priv);
-	return NULL;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
 }
-EXPORT_SYMBOL(cxd2820r_attach);
+
+static int cxd2820r_remove(struct i2c_client *client)
+{
+	struct cxd2820r_priv *priv = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+#ifdef CONFIG_GPIOLIB
+	if (priv->gpio_chip.label)
+		gpiochip_remove(&priv->gpio_chip);
+#endif
+	i2c_unregister_device(priv->client[1]);
+	kfree(priv);
+
+	return 0;
+}
+
+static const struct i2c_device_id cxd2820r_id_table[] = {
+	{"cxd2820r", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, cxd2820r_id_table);
+
+static struct i2c_driver cxd2820r_driver = {
+	.driver = {
+		.name                = "cxd2820r",
+		.suppress_bind_attrs = true,
+	},
+	.probe    = cxd2820r_probe,
+	.remove   = cxd2820r_remove,
+	.id_table = cxd2820r_id_table,
+};
+
+module_i2c_driver(cxd2820r_driver);
 
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Sony CXD2820R demodulator driver");
diff --git a/drivers/media/dvb-frontends/cxd2820r_priv.h b/drivers/media/dvb-frontends/cxd2820r_priv.h
index 66b19dd..f711fbd 100644
--- a/drivers/media/dvb-frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb-frontends/cxd2820r_priv.h
@@ -38,9 +38,14 @@ struct reg_val_mask {
 #define CXD2820R_CLK 41000000
 
 struct cxd2820r_priv {
+	struct i2c_client *client[2];
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
-	struct cxd2820r_config cfg;
+	u8 ts_mode;
+	bool ts_clk_inv;
+	bool if_agc_polarity;
+	bool spec_inv;
+
 	u64 post_bit_error_prev_dvbv3;
 	u64 post_bit_error;
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index ddd8e46..e328fe2 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -45,9 +45,9 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 		{ 0x00085, 0x07, 0xff },
 		{ 0x00088, 0x01, 0xff },
 
-		{ 0x00070, priv->cfg.ts_mode, 0xff },
-		{ 0x00071, !priv->cfg.ts_clock_inv << 4, 0x10 },
-		{ 0x000cb, priv->cfg.if_agc_polarity << 6, 0x40 },
+		{ 0x00070, priv->ts_mode, 0xff },
+		{ 0x00071, !priv->ts_clk_inv << 4, 0x10 },
+		{ 0x000cb, priv->if_agc_polarity << 6, 0x40 },
 		{ 0x000a5, 0x00, 0x01 },
 		{ 0x00082, 0x20, 0x60 },
 		{ 0x000c2, 0xc3, 0xff },
diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index e09f152..3a2c198 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -45,10 +45,10 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 		{ 0x0207f, 0x2a, 0xff },
 		{ 0x02082, 0x0a, 0xff },
 		{ 0x02083, 0x0a, 0xff },
-		{ 0x020cb, priv->cfg.if_agc_polarity << 6, 0x40 },
-		{ 0x02070, priv->cfg.ts_mode, 0xff },
-		{ 0x02071, !priv->cfg.ts_clock_inv << 6, 0x40 },
-		{ 0x020b5, priv->cfg.spec_inv << 4, 0x10 },
+		{ 0x020cb, priv->if_agc_polarity << 6, 0x40 },
+		{ 0x02070, priv->ts_mode, 0xff },
+		{ 0x02071, !priv->ts_clk_inv << 6, 0x40 },
+		{ 0x020b5, priv->spec_inv << 4, 0x10 },
 		{ 0x02567, 0x07, 0x0f },
 		{ 0x02569, 0x03, 0x03 },
 		{ 0x02595, 0x1a, 0xff },
-- 
http://palosaari.fi/

