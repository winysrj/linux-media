Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39169 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaLNI3s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:29:48 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/18] rtl2830: convert driver to kernel I2C model
Date: Sun, 14 Dec 2014 10:28:26 +0200
Message-Id: <1418545723-9536-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert driver to kernel I2C model. Old DVB proprietary model is
still left there also.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig        |   2 +-
 drivers/media/dvb-frontends/rtl2830.c      | 167 +++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/rtl2830.h      |  31 ++++++
 drivers/media/dvb-frontends/rtl2830_priv.h |   2 +
 4 files changed, 201 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 6c75418..e8827fc 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -443,7 +443,7 @@ config DVB_CXD2820R
 
 config DVB_RTL2830
 	tristate "Realtek RTL2830 DVB-T"
-	depends on DVB_CORE && I2C
+	depends on DVB_CORE && I2C && I2C_MUX
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 50e8b63..ec4a19c 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -767,6 +767,173 @@ static struct dvb_frontend_ops rtl2830_ops = {
 	.read_signal_strength = rtl2830_read_signal_strength,
 };
 
+/*
+ * I2C gate/repeater logic
+ * We must use unlocked i2c_transfer() here because I2C lock is already taken
+ * by tuner driver. Gate is closed automatically after single I2C xfer.
+ */
+static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
+{
+	struct i2c_client *client = mux_priv;
+	struct rtl2830_priv *priv = i2c_get_clientdata(client);
+	struct i2c_msg select_reg_page_msg[1] = {
+		{
+			.addr = priv->cfg.i2c_addr,
+			.flags = 0,
+			.len = 2,
+			.buf = "\x00\x01",
+		}
+	};
+	struct i2c_msg gate_open_msg[1] = {
+		{
+			.addr = priv->cfg.i2c_addr,
+			.flags = 0,
+			.len = 2,
+			.buf = "\x01\x08",
+		}
+	};
+	int ret;
+
+	/* select register page */
+	ret = __i2c_transfer(adap, select_reg_page_msg, 1);
+	if (ret != 1) {
+		dev_warn(&client->dev, "i2c write failed %d\n", ret);
+		if (ret >= 0)
+			ret = -EREMOTEIO;
+		goto err;
+	}
+
+	priv->page = 1;
+
+	/* open tuner I2C repeater for 1 xfer, closes automatically */
+	ret = __i2c_transfer(adap, gate_open_msg, 1);
+	if (ret != 1) {
+		dev_warn(&client->dev, "i2c write failed %d\n", ret);
+		if (ret >= 0)
+			ret = -EREMOTEIO;
+		goto err;
+	}
+
+	return 0;
+
+err:
+	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static struct dvb_frontend *rtl2830_get_dvb_frontend(struct i2c_client *client)
+{
+	struct rtl2830_priv *priv = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	return &priv->fe;
+}
+
+static struct i2c_adapter *rtl2830_get_i2c_adapter(struct i2c_client *client)
+{
+	struct rtl2830_priv *priv = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	return priv->adapter;
+}
+
+static int rtl2830_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct rtl2830_platform_data *pdata = client->dev.platform_data;
+	struct i2c_adapter *i2c = client->adapter;
+	struct rtl2830_priv *priv;
+	int ret;
+	u8 u8tmp;
+
+	dev_dbg(&client->dev, "\n");
+
+	if (pdata == NULL) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* allocate memory for the internal state */
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* setup the state */
+	i2c_set_clientdata(client, priv);
+	priv->i2c = i2c;
+	priv->sleeping = true;
+	priv->cfg.i2c_addr = client->addr;
+	priv->cfg.xtal = pdata->clk;
+	priv->cfg.spec_inv = pdata->spec_inv;
+	priv->cfg.vtop = pdata->vtop;
+	priv->cfg.krf = pdata->krf;
+	priv->cfg.agc_targ_val = pdata->agc_targ_val;
+
+	/* check if the demod is there */
+	ret = rtl2830_rd_reg(priv, 0x000, &u8tmp);
+	if (ret)
+		goto err_kfree;
+
+	/* create muxed i2c adapter for tuner */
+	priv->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
+			client, 0, 0, 0, rtl2830_select, NULL);
+	if (priv->adapter == NULL) {
+		ret = -ENODEV;
+		goto err_kfree;
+	}
+
+	/* create dvb frontend */
+	memcpy(&priv->fe.ops, &rtl2830_ops, sizeof(priv->fe.ops));
+	priv->fe.ops.release = NULL;
+	priv->fe.demodulator_priv = priv;
+
+	/* setup callbacks */
+	pdata->get_dvb_frontend = rtl2830_get_dvb_frontend;
+	pdata->get_i2c_adapter = rtl2830_get_i2c_adapter;
+
+	dev_info(&client->dev, "Realtek RTL2830 successfully attached\n");
+	return 0;
+
+err_kfree:
+	kfree(priv);
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int rtl2830_remove(struct i2c_client *client)
+{
+	struct rtl2830_priv *priv = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	i2c_del_mux_adapter(priv->adapter);
+	kfree(priv);
+	return 0;
+}
+
+static const struct i2c_device_id rtl2830_id_table[] = {
+	{"rtl2830", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, rtl2830_id_table);
+
+static struct i2c_driver rtl2830_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "rtl2830",
+	},
+	.probe		= rtl2830_probe,
+	.remove		= rtl2830_remove,
+	.id_table	= rtl2830_id_table,
+};
+
+module_i2c_driver(rtl2830_driver);
+
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Realtek RTL2830 DVB-T demodulator driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/rtl2830.h b/drivers/media/dvb-frontends/rtl2830.h
index 3313847..b925ea5 100644
--- a/drivers/media/dvb-frontends/rtl2830.h
+++ b/drivers/media/dvb-frontends/rtl2830.h
@@ -24,6 +24,37 @@
 #include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
+struct rtl2830_platform_data {
+	/*
+	 * Clock frequency.
+	 * Hz
+	 * 4000000, 16000000, 25000000, 28800000
+	 */
+	u32 clk;
+
+	/*
+	 * Spectrum inversion.
+	 */
+	bool spec_inv;
+
+	/*
+	 */
+	u8 vtop;
+
+	/*
+	 */
+	u8 krf;
+
+	/*
+	 */
+	u8 agc_targ_val;
+
+	/*
+	 */
+	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
+	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
+};
+
 struct rtl2830_config {
 	/*
 	 * Demodulator I2C address.
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index fab10ec..1a78351 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -24,8 +24,10 @@
 #include "dvb_frontend.h"
 #include "dvb_math.h"
 #include "rtl2830.h"
+#include <linux/i2c-mux.h>
 
 struct rtl2830_priv {
+	struct i2c_adapter *adapter;
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
 	struct rtl2830_config cfg;
-- 
http://palosaari.fi/

