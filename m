Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43086 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbbERFJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 01:09:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 8/8] m88ds3103: wrap media attach to driver I2C probe
Date: Mon, 18 May 2015 08:08:51 +0300
Message-Id: <1431925731-7499-8-git-send-email-crope@iki.fi>
In-Reply-To: <1431925731-7499-1-git-send-email-crope@iki.fi>
References: <1431925731-7499-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add wrapper from m88ds3103_attach() to m88ds3103_probe() via driver
core in order to provide proper I2C client for legacy media attach
binding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 129 +++++++++-----------------------
 drivers/media/dvb-frontends/m88ds3103.h |  12 +--
 2 files changed, 43 insertions(+), 98 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index d837dd2..01b9ded 100644
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
@@ -1401,98 +1401,42 @@ static int m88ds3103_deselect(struct i2c_adapter *adap, void *mux_priv,
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
-	int ret;
-	struct m88ds3103_priv *priv;
-	u8 chip_id, u8tmp;
-
-	/* allocate memory for the internal priv */
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		ret = -ENOMEM;
-		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
-		goto err;
-	}
-
-	priv->cfg = cfg;
-	priv->i2c = i2c;
-	mutex_init(&priv->i2c_mutex);
-
-	/* 0x00: chip id[6:0], 0x01: chip ver[7:0], 0x02: chip ver[15:8] */
-	ret = m88ds3103_rd_reg(priv, 0x00, &chip_id);
-	if (ret)
-		goto err;
-
-	chip_id >>= 1;
-	dev_info(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
-
-	switch (chip_id) {
-	case M88RS6000_CHIP_ID:
-	case M88DS3103_CHIP_ID:
-		break;
-	default:
-		goto err;
-	}
-	priv->chip_id = chip_id;
-
-	switch (priv->cfg->clock_out) {
-	case M88DS3103_CLOCK_OUT_DISABLED:
-		u8tmp = 0x80;
-		break;
-	case M88DS3103_CLOCK_OUT_ENABLED:
-		u8tmp = 0x00;
-		break;
-	case M88DS3103_CLOCK_OUT_ENABLED_DIV2:
-		u8tmp = 0x10;
-		break;
-	default:
-		goto err;
-	}
-
-	/* 0x29 register is defined differently for m88rs6000. */
-	/* set internal tuner address to 0x21 */
-	if (chip_id == M88RS6000_CHIP_ID)
-		u8tmp = 0x00;
-
-	ret = m88ds3103_wr_reg(priv, 0x29, u8tmp);
-	if (ret)
-		goto err;
-
-	/* sleep */
-	ret = m88ds3103_wr_reg_mask(priv, 0x08, 0x00, 0x01);
-	if (ret)
-		goto err;
-
-	ret = m88ds3103_wr_reg_mask(priv, 0x04, 0x01, 0x01);
-	if (ret)
-		goto err;
-
-	ret = m88ds3103_wr_reg_mask(priv, 0x23, 0x10, 0x10);
-	if (ret)
-		goto err;
-
-	/* create mux i2c adapter for tuner */
-	priv->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, priv, 0, 0, 0,
-			m88ds3103_select, m88ds3103_deselect);
-	if (priv->i2c_adapter == NULL)
-		goto err;
-
-	*tuner_i2c_adapter = priv->i2c_adapter;
-
-	/* create dvb_frontend */
-	memcpy(&priv->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
-	if (priv->chip_id == M88RS6000_CHIP_ID)
-		strncpy(priv->fe.ops.info.name,
-			"Montage M88RS6000", sizeof(priv->fe.ops.info.name));
-	priv->fe.demodulator_priv = priv;
-
-	return &priv->fe;
-err:
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
-	kfree(priv);
-	return NULL;
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
 }
 EXPORT_SYMBOL(m88ds3103_attach);
 
@@ -1654,7 +1598,8 @@ static int m88ds3103_probe(struct i2c_client *client,
 	if (dev->chip_id == M88RS6000_CHIP_ID)
 		strncpy(dev->fe.ops.info.name,
 			"Montage M88RS6000", sizeof(dev->fe.ops.info.name));
-	dev->fe.ops.release = NULL;
+	if (!pdata->attach_in_use)
+		dev->fe.ops.release = NULL;
 	dev->fe.demodulator_priv = dev;
 	i2c_set_clientdata(client, dev);
 
diff --git a/drivers/media/dvb-frontends/m88ds3103.h b/drivers/media/dvb-frontends/m88ds3103.h
index ddcd10a..3811468 100644
--- a/drivers/media/dvb-frontends/m88ds3103.h
+++ b/drivers/media/dvb-frontends/m88ds3103.h
@@ -68,8 +68,14 @@ struct m88ds3103_platform_data {
 
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
+
+/* private: For legacy media attach wrapper. Do not set value. */
+	u8 attach_in_use:1;
 };
 
+/*
+ * Do not add new m88ds3103_attach() users! Use I2C bindings instead.
+ */
 struct m88ds3103_config {
 	/*
 	 * I2C address
@@ -164,12 +170,6 @@ struct m88ds3103_config {
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
-- 
http://palosaari.fi/

