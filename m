Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34522 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307AbaLBOcF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 09:32:05 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Benjamin Larsson <benjamin@southpole.se>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] rtl2832: convert driver to I2C binding
Date: Tue,  2 Dec 2014 16:31:21 +0200
Message-Id: <1417530683-5063-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert that driver to I2C driver model.
Legacy DVB binding is left also for later removal...

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 108 +++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/rtl2832.h      |  10 +++
 drivers/media/dvb-frontends/rtl2832_priv.h |   1 +
 3 files changed, 119 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 9026e1a..53b446a 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1183,6 +1183,114 @@ static struct dvb_frontend_ops rtl2832_ops = {
 	.i2c_gate_ctrl = rtl2832_i2c_gate_ctrl,
 };
 
+static int rtl2832_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct rtl2832_platform_data *pdata = client->dev.platform_data;
+	const struct rtl2832_config *config = pdata->config;
+	struct i2c_adapter *i2c = client->adapter;
+	struct rtl2832_priv *priv;
+	int ret;
+	u8 tmp;
+
+	dev_dbg(&client->dev, "\n");
+
+	/* Caller really need to provide pointer for frontend we create. */
+	if (pdata->dvb_frontend == NULL) {
+		dev_err(&client->dev, "frontend pointer not defined\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* allocate memory for the internal state */
+	priv = kzalloc(sizeof(struct rtl2832_priv), GFP_KERNEL);
+	if (priv == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* setup the priv */
+	priv->client = client;
+	priv->i2c = i2c;
+	priv->tuner = config->tuner;
+	priv->sleeping = true;
+	memcpy(&priv->cfg, config, sizeof(struct rtl2832_config));
+	INIT_DELAYED_WORK(&priv->i2c_gate_work, rtl2832_i2c_gate_work);
+
+	/* create muxed i2c adapter for demod itself */
+	priv->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, priv, 0, 0, 0,
+			rtl2832_select, NULL);
+	if (priv->i2c_adapter == NULL) {
+		ret = -ENODEV;
+		goto err_kfree;
+	}
+
+	/* check if the demod is there */
+	ret = rtl2832_rd_reg(priv, 0x00, 0x0, &tmp);
+	if (ret)
+		goto err_i2c_del_mux_adapter;
+
+	/* create muxed i2c adapter for demod tuner bus */
+	priv->i2c_adapter_tuner = i2c_add_mux_adapter(i2c, &i2c->dev, priv,
+			0, 1, 0, rtl2832_select, rtl2832_deselect);
+	if (priv->i2c_adapter_tuner == NULL) {
+		ret = -ENODEV;
+		goto err_i2c_del_mux_adapter;
+	}
+
+	/* create dvb_frontend */
+	memcpy(&priv->fe.ops, &rtl2832_ops, sizeof(struct dvb_frontend_ops));
+	priv->fe.ops.release = NULL;
+	priv->fe.demodulator_priv = priv;
+	i2c_set_clientdata(client, priv);
+	*pdata->dvb_frontend = &priv->fe;
+
+	dev_info(&client->dev, "Realtek RTL2832 successfully attached\n");
+	return 0;
+err_i2c_del_mux_adapter:
+	i2c_del_mux_adapter(priv->i2c_adapter);
+err_kfree:
+	kfree(priv);
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int rtl2832_remove(struct i2c_client *client)
+{
+	struct rtl2832_priv *priv = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	cancel_delayed_work_sync(&priv->i2c_gate_work);
+
+	i2c_del_mux_adapter(priv->i2c_adapter_tuner);
+
+	i2c_del_mux_adapter(priv->i2c_adapter);
+
+	kfree(priv);
+
+	return 0;
+}
+
+static const struct i2c_device_id rtl2832_id_table[] = {
+	{"rtl2832", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, rtl2832_id_table);
+
+static struct i2c_driver rtl2832_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "rtl2832",
+	},
+	.probe		= rtl2832_probe,
+	.remove		= rtl2832_remove,
+	.id_table	= rtl2832_id_table,
+};
+
+module_i2c_driver(rtl2832_driver);
+
 MODULE_AUTHOR("Thomas Mair <mair.thomas86@gmail.com>");
 MODULE_DESCRIPTION("Realtek RTL2832 DVB-T demodulator driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 5254c1d..cfd69d8 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -50,6 +50,16 @@ struct rtl2832_config {
 	u8 tuner;
 };
 
+struct rtl2832_platform_data {
+	const struct rtl2832_config *config;
+
+	/*
+	 * frontend
+	 * returned by driver
+	 */
+	struct dvb_frontend **dvb_frontend;
+};
+
 #if IS_ENABLED(CONFIG_DVB_RTL2832)
 struct dvb_frontend *rtl2832_attach(
 	const struct rtl2832_config *cfg,
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index ae469f0..05b2b62 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -26,6 +26,7 @@
 #include <linux/i2c-mux.h>
 
 struct rtl2832_priv {
+	struct i2c_client *client;
 	struct i2c_adapter *i2c;
 	struct i2c_adapter *i2c_adapter;
 	struct i2c_adapter *i2c_adapter_tuner;
-- 
http://palosaari.fi/

