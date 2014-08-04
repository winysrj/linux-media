Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38518 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaHDE3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Aug 2014 00:29:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/9] tda18212: clean logging
Date: Mon,  4 Aug 2014 07:29:28 +0300
Message-Id: <1407126571-21629-6-git-send-email-crope@iki.fi>
In-Reply-To: <1407126571-21629-1-git-send-email-crope@iki.fi>
References: <1407126571-21629-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to print module name nor function name as those
are done by kernel logging system when dev_xxx logging is used and
driver is proper I2C driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tda18212.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index 659787b..5d1d785 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -47,8 +47,8 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 
 	if (1 + len > sizeof(buf)) {
 		dev_warn(&priv->client->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
+				"i2c wr reg=%04x: len=%d is too big!\n",
+				reg, len);
 		return -EINVAL;
 	}
 
@@ -59,8 +59,9 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->client->dev, "%s: i2c wr failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&priv->client->dev,
+				"i2c wr failed=%d reg=%02x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -88,8 +89,8 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 
 	if (len > sizeof(buf)) {
 		dev_warn(&priv->client->dev,
-			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
+				"i2c rd reg=%04x: len=%d is too big!\n",
+				reg, len);
 		return -EINVAL;
 	}
 
@@ -98,8 +99,9 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&priv->client->dev, "%s: i2c rd failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&priv->client->dev,
+				"i2c rd failed=%d reg=%02x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -167,8 +169,8 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 	};
 
 	dev_dbg(&priv->client->dev,
-			"%s: delivery_system=%d frequency=%d bandwidth_hz=%d\n",
-			__func__, c->delivery_system, c->frequency,
+			"delivery_system=%d frequency=%d bandwidth_hz=%d\n",
+			c->delivery_system, c->frequency,
 			c->bandwidth_hz);
 
 	if (fe->ops.i2c_gate_ctrl)
@@ -266,7 +268,7 @@ exit:
 	return ret;
 
 error:
-	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&priv->client->dev, "failed=%d\n", ret);
 	goto exit;
 }
 
@@ -305,7 +307,7 @@ static int tda18212_probe(struct i2c_client *client,
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
 		ret = -ENOMEM;
-		dev_err(&client->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		dev_err(&client->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
@@ -317,7 +319,7 @@ static int tda18212_probe(struct i2c_client *client,
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
 
 	ret = tda18212_rd_reg(priv, 0x00, &chip_id);
-	dev_dbg(&priv->client->dev, "%s: chip_id=%02x\n", __func__, chip_id);
+	dev_dbg(&priv->client->dev, "chip_id=%02x\n", chip_id);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
@@ -338,8 +340,7 @@ static int tda18212_probe(struct i2c_client *client,
 	}
 
 	dev_info(&priv->client->dev,
-			"%s: NXP TDA18212HN/%s successfully identified\n",
-			KBUILD_MODNAME, version);
+			"NXP TDA18212HN/%s successfully identified\n", version);
 
 	fe->tuner_priv = priv;
 	memcpy(&fe->ops.tuner_ops, &tda18212_tuner_ops,
@@ -348,7 +349,7 @@ static int tda18212_probe(struct i2c_client *client,
 
 	return 0;
 err:
-	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	kfree(priv);
 	return ret;
 }
@@ -358,7 +359,7 @@ static int tda18212_remove(struct i2c_client *client)
 	struct tda18212_priv *priv = i2c_get_clientdata(client);
 	struct dvb_frontend *fe = priv->cfg.fe;
 
-	dev_dbg(&client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
-- 
http://palosaari.fi/

