Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48300 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161081AbbEUVYK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 17:24:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/8] a8293: implement I2C client bindings
Date: Fri, 22 May 2015 00:23:52 +0300
Message-Id: <1432243438-12225-2-git-send-email-crope@iki.fi>
In-Reply-To: <1432243438-12225-1-git-send-email-crope@iki.fi>
References: <1432243438-12225-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement I2C client bindings.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/a8293.c | 87 +++++++++++++++++++++++++++++++++++--
 drivers/media/dvb-frontends/a8293.h | 15 +++++++
 2 files changed, 99 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/a8293.c b/drivers/media/dvb-frontends/a8293.c
index 780da58..3f0cf9e 100644
--- a/drivers/media/dvb-frontends/a8293.c
+++ b/drivers/media/dvb-frontends/a8293.c
@@ -22,8 +22,9 @@
 #include "a8293.h"
 
 struct a8293_priv {
+	u8 i2c_addr;
 	struct i2c_adapter *i2c;
-	const struct a8293_config *cfg;
+	struct i2c_client *client;
 	u8 reg[2];
 };
 
@@ -32,7 +33,7 @@ static int a8293_i2c(struct a8293_priv *priv, u8 *val, int len, bool rd)
 	int ret;
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg->i2c_addr,
+			.addr = priv->i2c_addr,
 			.len = len,
 			.buf = val,
 		}
@@ -128,7 +129,7 @@ struct dvb_frontend *a8293_attach(struct dvb_frontend *fe,
 
 	/* setup the priv */
 	priv->i2c = i2c;
-	priv->cfg = cfg;
+	priv->i2c_addr = cfg->i2c_addr;
 	fe->sec_priv = priv;
 
 	/* check if the SEC is there */
@@ -164,6 +165,86 @@ err:
 }
 EXPORT_SYMBOL(a8293_attach);
 
+static int a8293_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct a8293_priv *dev;
+	struct a8293_platform_data *pdata = client->dev.platform_data;
+	struct dvb_frontend *fe = pdata->dvb_frontend;
+	int ret;
+	u8 buf[2];
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	dev->client = client;
+	dev->i2c = client->adapter;
+	dev->i2c_addr = client->addr;
+
+	/* check if the SEC is there */
+	ret = a8293_rd(dev, buf, 2);
+	if (ret)
+		goto err_kfree;
+
+	/* ENB=0 */
+	dev->reg[0] = 0x10;
+	ret = a8293_wr(dev, &dev->reg[0], 1);
+	if (ret)
+		goto err_kfree;
+
+	/* TMODE=0, TGATE=1 */
+	dev->reg[1] = 0x82;
+	ret = a8293_wr(dev, &dev->reg[1], 1);
+	if (ret)
+		goto err_kfree;
+
+	/* override frontend ops */
+	fe->ops.set_voltage = a8293_set_voltage;
+
+	fe->sec_priv = dev;
+	i2c_set_clientdata(client, dev);
+
+	dev_info(&client->dev, "Allegro A8293 SEC successfully attached\n");
+	return 0;
+err_kfree:
+	kfree(dev);
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int a8293_remove(struct i2c_client *client)
+{
+	struct a8293_dev *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	kfree(dev);
+	return 0;
+}
+
+static const struct i2c_device_id a8293_id_table[] = {
+	{"a8293", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, a8293_id_table);
+
+static struct i2c_driver a8293_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "a8293",
+		.suppress_bind_attrs = true,
+	},
+	.probe		= a8293_probe,
+	.remove		= a8293_remove,
+	.id_table	= a8293_id_table,
+};
+
+module_i2c_driver(a8293_driver);
+
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Allegro A8293 SEC driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/a8293.h b/drivers/media/dvb-frontends/a8293.h
index 5f04119..aff3653 100644
--- a/drivers/media/dvb-frontends/a8293.h
+++ b/drivers/media/dvb-frontends/a8293.h
@@ -21,8 +21,23 @@
 #ifndef A8293_H
 #define A8293_H
 
+#include "dvb_frontend.h"
 #include <linux/kconfig.h>
 
+/*
+ * I2C address
+ * 0x08, 0x09, 0x0a, 0x0b
+ */
+
+/**
+ * struct a8293_platform_data - Platform data for the a8293 driver
+ * @dvb_frontend: DVB frontend.
+ */
+struct a8293_platform_data {
+	struct dvb_frontend *dvb_frontend;
+};
+
+
 struct a8293_config {
 	u8 i2c_addr;
 };
-- 
http://palosaari.fi/

