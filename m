Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57287 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535AbaICKKx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 06:10:53 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] m88ts2022: clean up logging
Date: Wed,  3 Sep 2014 13:10:34 +0300
Message-Id: <1409739036-5091-2-git-send-email-crope@iki.fi>
In-Reply-To: <1409739036-5091-1-git-send-email-crope@iki.fi>
References: <1409739036-5091-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to print module name nor function name as those
are done by kernel logging system when dev_xxx logging is used and
driver is proper I2C driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/m88ts2022.c | 51 +++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index 94f0d3b..4d7f7e1 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -46,8 +46,8 @@ static int m88ts2022_wr_regs(struct m88ts2022_dev *dev,
 		ret = 0;
 	} else {
 		dev_warn(&dev->client->dev,
-				"%s: i2c wr failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+				"i2c wr failed=%d reg=%02x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -85,8 +85,8 @@ static int m88ts2022_rd_regs(struct m88ts2022_dev *dev, u8 reg,
 		ret = 0;
 	} else {
 		dev_warn(&dev->client->dev,
-				"%s: i2c rd failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+				"i2c rd failed=%d reg=%02x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -141,8 +141,8 @@ static int m88ts2022_cmd(struct dvb_frontend *fe,
 
 	for (i = 0; i < 2; i++) {
 		dev_dbg(&dev->client->dev,
-				"%s: i=%d op=%02x reg=%02x mask=%02x val=%02x\n",
-				__func__, i, op, reg, mask, val);
+				"i=%d op=%02x reg=%02x mask=%02x val=%02x\n",
+				i, op, reg, mask, val);
 
 		for (i = 0; i < ARRAY_SIZE(reg_vals); i++) {
 			ret = m88ts2022_wr_reg(dev, reg_vals[i].reg,
@@ -178,8 +178,8 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	u16 u16tmp;
 
 	dev_dbg(&dev->client->dev,
-			"%s: frequency=%d symbol_rate=%d rolloff=%d\n",
-			__func__, c->frequency, c->symbol_rate, c->rolloff);
+			"frequency=%d symbol_rate=%d rolloff=%d\n",
+			c->frequency, c->symbol_rate, c->rolloff);
 	/*
 	 * Integer-N PLL synthesizer
 	 * kHz is used for all calculations to keep calculations within 32-bit
@@ -228,10 +228,9 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 		goto err;
 
 	dev_dbg(&dev->client->dev,
-			"%s: frequency=%u offset=%d f_vco_khz=%u pll_n=%u div_ref=%u div_out=%u\n",
-			__func__, dev->frequency_khz,
-			dev->frequency_khz - c->frequency, f_vco_khz, pll_n,
-			div_ref, div_out);
+			"frequency=%u offset=%d f_vco_khz=%u pll_n=%u div_ref=%u div_out=%u\n",
+			dev->frequency_khz, dev->frequency_khz - c->frequency,
+			f_vco_khz, pll_n, div_ref, div_out);
 
 	ret = m88ts2022_cmd(fe, 0x10, 5, 0x15, 0x40, 0x00, NULL);
 	if (ret)
@@ -371,7 +370,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 		goto err;
 err:
 	if (ret)
-		dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -395,7 +394,7 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 		{0x12, 0xa0},
 	};
 
-	dev_dbg(&dev->client->dev, "%s:\n", __func__);
+	dev_dbg(&dev->client->dev, "\n");
 
 	ret = m88ts2022_wr_reg(dev, 0x00, 0x01);
 	if (ret)
@@ -442,7 +441,7 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 	}
 err:
 	if (ret)
-		dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -451,14 +450,14 @@ static int m88ts2022_sleep(struct dvb_frontend *fe)
 	struct m88ts2022_dev *dev = fe->tuner_priv;
 	int ret;
 
-	dev_dbg(&dev->client->dev, "%s:\n", __func__);
+	dev_dbg(&dev->client->dev, "\n");
 
 	ret = m88ts2022_wr_reg(dev, 0x00, 0x00);
 	if (ret)
 		goto err;
 err:
 	if (ret)
-		dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -466,7 +465,7 @@ static int m88ts2022_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct m88ts2022_dev *dev = fe->tuner_priv;
 
-	dev_dbg(&dev->client->dev, "%s:\n", __func__);
+	dev_dbg(&dev->client->dev, "\n");
 
 	*frequency = dev->frequency_khz;
 	return 0;
@@ -476,7 +475,7 @@ static int m88ts2022_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct m88ts2022_dev *dev = fe->tuner_priv;
 
-	dev_dbg(&dev->client->dev, "%s:\n", __func__);
+	dev_dbg(&dev->client->dev, "\n");
 
 	*frequency = 0; /* Zero-IF */
 	return 0;
@@ -520,7 +519,7 @@ static int m88ts2022_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 	*strength = (u16tmp - 59000) * 0xffff / (61500 - 59000);
 err:
 	if (ret)
-		dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -552,7 +551,7 @@ static int m88ts2022_probe(struct i2c_client *client,
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		ret = -ENOMEM;
-		dev_err(&client->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		dev_err(&client->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
@@ -582,7 +581,7 @@ static int m88ts2022_probe(struct i2c_client *client,
 	if (ret)
 		goto err;
 
-	dev_dbg(&dev->client->dev, "%s: chip_id=%02x\n", __func__, chip_id);
+	dev_dbg(&dev->client->dev, "chip_id=%02x\n", chip_id);
 
 	switch (chip_id) {
 	case 0xc3:
@@ -627,9 +626,7 @@ static int m88ts2022_probe(struct i2c_client *client,
 	if (ret)
 		goto err;
 
-	dev_info(&dev->client->dev,
-			"%s: Montage M88TS2022 successfully identified\n",
-			KBUILD_MODNAME);
+	dev_info(&dev->client->dev, "Montage M88TS2022 successfully identified\n");
 
 	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &m88ts2022_tuner_ops,
@@ -638,7 +635,7 @@ static int m88ts2022_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, dev);
 	return 0;
 err:
-	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	kfree(dev);
 	return ret;
 }
@@ -648,7 +645,7 @@ static int m88ts2022_remove(struct i2c_client *client)
 	struct m88ts2022_dev *dev = i2c_get_clientdata(client);
 	struct dvb_frontend *fe = dev->cfg.fe;
 
-	dev_dbg(&client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
-- 
http://palosaari.fi/

