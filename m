Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38859 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbbGIEG4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:06:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/12] a8293: use i2c_master_send / i2c_master_recv for I2C I/O
Date: Thu,  9 Jul 2015 07:06:23 +0300
Message-Id: <1436414792-9716-3-git-send-email-crope@iki.fi>
In-Reply-To: <1436414792-9716-1-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As driver is now proper I2C client driver, we could use correct
functions for I2C I/O. Also rename state from priv to dev. Fix
logging too.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/a8293.c | 80 +++++++++----------------------------
 1 file changed, 18 insertions(+), 62 deletions(-)

diff --git a/drivers/media/dvb-frontends/a8293.c b/drivers/media/dvb-frontends/a8293.c
index 522b0d1..d99ea4d 100644
--- a/drivers/media/dvb-frontends/a8293.c
+++ b/drivers/media/dvb-frontends/a8293.c
@@ -20,94 +20,53 @@
 
 #include "a8293.h"
 
-struct a8293_priv {
-	u8 i2c_addr;
-	struct i2c_adapter *i2c;
+struct a8293_dev {
 	struct i2c_client *client;
 	u8 reg[2];
 };
 
-static int a8293_i2c(struct a8293_priv *priv, u8 *val, int len, bool rd)
-{
-	int ret;
-	struct i2c_msg msg[1] = {
-		{
-			.addr = priv->i2c_addr,
-			.len = len,
-			.buf = val,
-		}
-	};
-
-	if (rd)
-		msg[0].flags = I2C_M_RD;
-	else
-		msg[0].flags = 0;
-
-	ret = i2c_transfer(priv->i2c, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c failed=%d rd=%d\n",
-				KBUILD_MODNAME, ret, rd);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-static int a8293_wr(struct a8293_priv *priv, u8 *val, int len)
-{
-	return a8293_i2c(priv, val, len, 0);
-}
-
-static int a8293_rd(struct a8293_priv *priv, u8 *val, int len)
-{
-	return a8293_i2c(priv, val, len, 1);
-}
-
 static int a8293_set_voltage(struct dvb_frontend *fe,
 	enum fe_sec_voltage fe_sec_voltage)
 {
-	struct a8293_priv *priv = fe->sec_priv;
+	struct a8293_dev *dev = fe->sec_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 
-	dev_dbg(&priv->i2c->dev, "%s: fe_sec_voltage=%d\n", __func__,
-			fe_sec_voltage);
+	dev_dbg(&client->dev, "fe_sec_voltage=%d\n", fe_sec_voltage);
 
 	switch (fe_sec_voltage) {
 	case SEC_VOLTAGE_OFF:
 		/* ENB=0 */
-		priv->reg[0] = 0x10;
+		dev->reg[0] = 0x10;
 		break;
 	case SEC_VOLTAGE_13:
 		/* VSEL0=1, VSEL1=0, VSEL2=0, VSEL3=0, ENB=1*/
-		priv->reg[0] = 0x31;
+		dev->reg[0] = 0x31;
 		break;
 	case SEC_VOLTAGE_18:
 		/* VSEL0=0, VSEL1=0, VSEL2=0, VSEL3=1, ENB=1*/
-		priv->reg[0] = 0x38;
+		dev->reg[0] = 0x38;
 		break;
 	default:
 		ret = -EINVAL;
 		goto err;
 	}
 
-	ret = a8293_wr(priv, &priv->reg[0], 1);
-	if (ret)
+	ret = i2c_master_send(client, &dev->reg[0], 1);
+	if (ret < 0)
 		goto err;
 
 	usleep_range(1500, 50000);
-
-	return ret;
+	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int a8293_probe(struct i2c_client *client,
 		       const struct i2c_device_id *id)
 {
-	struct a8293_priv *dev;
+	struct a8293_dev *dev;
 	struct a8293_platform_data *pdata = client->dev.platform_data;
 	struct dvb_frontend *fe = pdata->dvb_frontend;
 	int ret;
@@ -120,29 +79,26 @@ static int a8293_probe(struct i2c_client *client,
 	}
 
 	dev->client = client;
-	dev->i2c = client->adapter;
-	dev->i2c_addr = client->addr;
 
 	/* check if the SEC is there */
-	ret = a8293_rd(dev, buf, 2);
-	if (ret)
+	ret = i2c_master_recv(client, buf, 2);
+	if (ret < 0)
 		goto err_kfree;
 
 	/* ENB=0 */
 	dev->reg[0] = 0x10;
-	ret = a8293_wr(dev, &dev->reg[0], 1);
-	if (ret)
+	ret = i2c_master_send(client, &dev->reg[0], 1);
+	if (ret < 0)
 		goto err_kfree;
 
 	/* TMODE=0, TGATE=1 */
 	dev->reg[1] = 0x82;
-	ret = a8293_wr(dev, &dev->reg[1], 1);
-	if (ret)
+	ret = i2c_master_send(client, &dev->reg[1], 1);
+	if (ret < 0)
 		goto err_kfree;
 
 	/* override frontend ops */
 	fe->ops.set_voltage = a8293_set_voltage;
-
 	fe->sec_priv = dev;
 	i2c_set_clientdata(client, dev);
 
-- 
http://palosaari.fi/

