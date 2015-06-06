Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46857 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbbFFL7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 07:59:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/8] ts2020: register I2C driver from legacy media attach
Date: Sat,  6 Jun 2015 14:58:43 +0300
Message-Id: <1433591928-30915-3-git-send-email-crope@iki.fi>
In-Reply-To: <1433591928-30915-1-git-send-email-crope@iki.fi>
References: <1433591928-30915-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Register driver using I2C bindings internally when legacy media
attach is used. That is done by registering driver using I2C binding
from legacy attach. That way we can get valid I2C client, which is
needed for proper dev_() logging and regmap for example even legacy
binding is used.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/ts2020.c | 73 ++++++++++++------------------------
 drivers/media/dvb-frontends/ts2020.h |  7 +++-
 2 files changed, 30 insertions(+), 50 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 590f7e1..7b2f301 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -26,6 +26,7 @@
 #define FREQ_OFFSET_LOW_SYM_RATE 3000
 
 struct ts2020_priv {
+	struct i2c_client *client;
 	struct dvb_frontend *fe;
 	/* i2c details */
 	int i2c_address;
@@ -47,8 +48,12 @@ struct ts2020_reg_val {
 
 static int ts2020_release(struct dvb_frontend *fe)
 {
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
+	struct ts2020_priv *priv = fe->tuner_priv;
+	struct i2c_client *client = priv->client;
+
+	dev_dbg(&client->dev, "\n");
+
+	i2c_unregister_device(client);
 	return 0;
 }
 
@@ -410,50 +415,22 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
 					const struct ts2020_config *config,
 					struct i2c_adapter *i2c)
 {
-	struct ts2020_priv *priv = NULL;
-	u8 buf;
-
-	priv = kzalloc(sizeof(struct ts2020_priv), GFP_KERNEL);
-	if (priv == NULL)
+	struct i2c_client *client;
+	struct i2c_board_info board_info;
+	struct ts2020_config pdata;
+
+	memcpy(&pdata, config, sizeof(pdata));
+	pdata.fe = fe;
+	pdata.attach_in_use = true;
+
+	memset(&board_info, 0, sizeof(board_info));
+	strlcpy(board_info.type, "ts2020", I2C_NAME_SIZE);
+	board_info.addr = config->tuner_address;
+	board_info.platform_data = &pdata;
+	client = i2c_new_device(i2c, &board_info);
+	if (!client || !client->dev.driver)
 		return NULL;
 
-	priv->i2c_address = config->tuner_address;
-	priv->i2c = i2c;
-	priv->clk_out = config->clk_out;
-	priv->clk_out_div = config->clk_out_div;
-	priv->frequency_div = config->frequency_div;
-	priv->fe = fe;
-	fe->tuner_priv = priv;
-
-	if (!priv->frequency_div)
-		priv->frequency_div = 1060000;
-
-	/* Wake Up the tuner */
-	if ((0x03 & ts2020_readreg(fe, 0x00)) == 0x00) {
-		ts2020_writereg(fe, 0x00, 0x01);
-		msleep(2);
-	}
-
-	ts2020_writereg(fe, 0x00, 0x03);
-	msleep(2);
-
-	/* Check the tuner version */
-	buf = ts2020_readreg(fe, 0x00);
-	if ((buf == 0x01) || (buf == 0x41) || (buf == 0x81)) {
-		printk(KERN_INFO "%s: Find tuner TS2020!\n", __func__);
-		priv->tuner = TS2020_M88TS2020;
-	} else if ((buf == 0x83) || (buf == 0xc3)) {
-		printk(KERN_INFO "%s: Find tuner TS2022!\n", __func__);
-		priv->tuner = TS2020_M88TS2022;
-	} else {
-		printk(KERN_ERR "%s: Read tuner reg[0] = %d\n", __func__, buf);
-		kfree(priv);
-		return NULL;
-	}
-
-	memcpy(&fe->ops.tuner_ops, &ts2020_tuner_ops,
-				sizeof(struct dvb_tuner_ops));
-
 	return fe;
 }
 EXPORT_SYMBOL(ts2020_attach);
@@ -482,6 +459,7 @@ static int ts2020_probe(struct i2c_client *client,
 	dev->frequency_div = pdata->frequency_div;
 	dev->fe = fe;
 	fe->tuner_priv = dev;
+	dev->client = client;
 
 	/* check if the tuner is there */
 	ret = ts2020_readreg(fe, 0x00);
@@ -574,7 +552,8 @@ static int ts2020_probe(struct i2c_client *client,
 
 	memcpy(&fe->ops.tuner_ops, &ts2020_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
-	fe->ops.tuner_ops.release = NULL;
+	if (!pdata->attach_in_use)
+		fe->ops.tuner_ops.release = NULL;
 
 	i2c_set_clientdata(client, dev);
 	return 0;
@@ -587,14 +566,10 @@ err:
 static int ts2020_remove(struct i2c_client *client)
 {
 	struct ts2020_priv *dev = i2c_get_clientdata(client);
-	struct dvb_frontend *fe = dev->fe;
 
 	dev_dbg(&client->dev, "\n");
 
-	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
-	fe->tuner_priv = NULL;
 	kfree(dev);
-
 	return 0;
 }
 
diff --git a/drivers/media/dvb-frontends/ts2020.h b/drivers/media/dvb-frontends/ts2020.h
index 1714af9..f40bbcf 100644
--- a/drivers/media/dvb-frontends/ts2020.h
+++ b/drivers/media/dvb-frontends/ts2020.h
@@ -52,10 +52,15 @@ struct ts2020_config {
 	 * pointer to DVB frontend
 	 */
 	struct dvb_frontend *fe;
+
+	/*
+	 * driver private, do not set value
+	 */
+	u8 attach_in_use:1;
 };
 
+/* Do not add new ts2020_attach() users! Use I2C bindings instead. */
 #if IS_REACHABLE(CONFIG_DVB_TS2020)
-
 extern struct dvb_frontend *ts2020_attach(
 	struct dvb_frontend *fe,
 	const struct ts2020_config *config,
-- 
http://palosaari.fi/

