Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51448 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbbEEV67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:58:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/21] tua9001: add I2C bindings
Date: Wed,  6 May 2015 00:58:30 +0300
Message-Id: <1430863122-9888-9-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add I2C bindings.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tua9001.c      | 100 +++++++++++++++++++++++++++++++++++-
 drivers/media/tuners/tua9001.h      |  13 +++++
 drivers/media/tuners/tua9001_priv.h |   4 +-
 3 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
index 83a6240..55cac20 100644
--- a/drivers/media/tuners/tua9001.c
+++ b/drivers/media/tuners/tua9001.c
@@ -28,7 +28,7 @@ static int tua9001_wr_reg(struct tua9001_priv *priv, u8 reg, u16 val)
 	u8 buf[3] = { reg, (val >> 8) & 0xff, (val >> 0) & 0xff };
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg->i2c_addr,
+			.addr = priv->i2c_addr,
 			.flags = 0,
 			.len = sizeof(buf),
 			.buf = buf,
@@ -253,7 +253,7 @@ struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
 	if (priv == NULL)
 		return NULL;
 
-	priv->cfg = cfg;
+	priv->i2c_addr = cfg->i2c_addr;
 	priv->i2c = i2c;
 
 	if (fe->callback) {
@@ -289,6 +289,102 @@ err:
 }
 EXPORT_SYMBOL(tua9001_attach);
 
+static int tua9001_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct tua9001_priv *dev;
+	struct tua9001_platform_data *pdata = client->dev.platform_data;
+	struct dvb_frontend *fe = pdata->dvb_frontend;
+	int ret;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	dev->client = client;
+	dev->i2c_addr = client->addr;
+	dev->i2c = client->adapter;
+	dev->fe = pdata->dvb_frontend;
+
+	if (fe->callback) {
+		ret = fe->callback(client->adapter,
+				   DVB_FRONTEND_COMPONENT_TUNER,
+				   TUA9001_CMD_CEN, 1);
+		if (ret)
+			goto err_kfree;
+
+		ret = fe->callback(client->adapter,
+				   DVB_FRONTEND_COMPONENT_TUNER,
+				   TUA9001_CMD_RXEN, 0);
+		if (ret)
+			goto err_kfree;
+
+		ret = fe->callback(client->adapter,
+				   DVB_FRONTEND_COMPONENT_TUNER,
+				   TUA9001_CMD_RESETN, 1);
+		if (ret)
+			goto err_kfree;
+	}
+
+	fe->tuner_priv = dev;
+	memcpy(&fe->ops.tuner_ops, &tua9001_tuner_ops,
+			sizeof(struct dvb_tuner_ops));
+	fe->ops.tuner_ops.release = NULL;
+	i2c_set_clientdata(client, dev);
+
+	dev_info(&client->dev, "Infineon TUA 9001 successfully attached\n");
+	return 0;
+err_kfree:
+	kfree(dev);
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int tua9001_remove(struct i2c_client *client)
+{
+	struct tua9001_priv *dev = i2c_get_clientdata(client);
+	struct dvb_frontend *fe = dev->fe;
+	int ret;
+
+	dev_dbg(&client->dev, "\n");
+
+	if (fe->callback) {
+		ret = fe->callback(client->adapter,
+				   DVB_FRONTEND_COMPONENT_TUNER,
+				   TUA9001_CMD_CEN, 0);
+		if (ret)
+			goto err_kfree;
+	}
+	kfree(dev);
+	return 0;
+err_kfree:
+	kfree(dev);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static const struct i2c_device_id tua9001_id_table[] = {
+	{"tua9001", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, tua9001_id_table);
+
+static struct i2c_driver tua9001_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "tua9001",
+		.suppress_bind_attrs = true,
+	},
+	.probe		= tua9001_probe,
+	.remove		= tua9001_remove,
+	.id_table	= tua9001_id_table,
+};
+
+module_i2c_driver(tua9001_driver);
+
 MODULE_DESCRIPTION("Infineon TUA 9001 silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/tua9001.h b/drivers/media/tuners/tua9001.h
index 2c3375c..0b4fc8d 100644
--- a/drivers/media/tuners/tua9001.h
+++ b/drivers/media/tuners/tua9001.h
@@ -24,6 +24,19 @@
 #include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
+/*
+ * I2C address
+ * 0x60,
+ */
+
+/**
+ * struct tua9001_platform_data - Platform data for the tua9001 driver
+ * @dvb_frontend: DVB frontend.
+ */
+struct tua9001_platform_data {
+	struct dvb_frontend *dvb_frontend;
+};
+
 struct tua9001_config {
 	/*
 	 * I2C address
diff --git a/drivers/media/tuners/tua9001_priv.h b/drivers/media/tuners/tua9001_priv.h
index 73cc1ce..3282a1a 100644
--- a/drivers/media/tuners/tua9001_priv.h
+++ b/drivers/media/tuners/tua9001_priv.h
@@ -27,8 +27,10 @@ struct reg_val {
 };
 
 struct tua9001_priv {
-	struct tua9001_config *cfg;
+	struct i2c_client *client;
 	struct i2c_adapter *i2c;
+	u8 i2c_addr;
+	struct dvb_frontend *fe;
 };
 
 #endif
-- 
http://palosaari.fi/

