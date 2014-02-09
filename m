Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37891 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaBIJYQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 04:24:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 84/86] e4000: get rid of DVB i2c_gate_ctrl()
Date: Sun,  9 Feb 2014 10:49:29 +0200
Message-Id: <1391935771-18670-85-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gate control is now implemented by rtl2832 I2C adapter so we do not
need proprietary DVB i2c_gate_ctrl() anymore.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c | 106 +++++++++----------------------------------
 1 file changed, 21 insertions(+), 85 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 662e19a1..e3e3b7e 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -119,9 +119,6 @@ static int e4000_init(struct dvb_frontend *fe)
 
 	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
 	/* dummy I2C to ensure I2C wakes up */
 	ret = e4000_wr_reg(priv, 0x02, 0x40);
 
@@ -178,17 +175,11 @@ static int e4000_init(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
 	priv->active = true;
-
-	return 0;
 err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+	if (ret)
+		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 
-	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -201,22 +192,13 @@ static int e4000_sleep(struct dvb_frontend *fe)
 
 	priv->active = false;
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
 	ret = e4000_wr_reg(priv, 0x00, 0x00);
 	if (ret < 0)
 		goto err;
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	return 0;
 err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+	if (ret)
+		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 
-	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -233,9 +215,6 @@ static int e4000_set_params(struct dvb_frontend *fe)
 			__func__, c->delivery_system, c->frequency,
 			c->bandwidth_hz);
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
 	/* gain control manual */
 	ret = e4000_wr_reg(priv, 0x1a, 0x00);
 	if (ret < 0)
@@ -361,16 +340,10 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	ret = e4000_wr_reg(priv, 0x1a, 0x17);
 	if (ret < 0)
 		goto err;
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	return 0;
 err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+	if (ret)
+		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 
-	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -390,14 +363,12 @@ static int e4000_set_lna_gain(struct dvb_frontend *fe)
 	struct e4000_priv *priv = fe->tuner_priv;
 	int ret;
 	u8 u8tmp;
+
 	dev_dbg(&priv->client->dev, "%s: lna auto=%d->%d val=%d->%d\n",
 			__func__, priv->lna_gain_auto->cur.val,
 			priv->lna_gain_auto->val, priv->lna_gain->cur.val,
 			priv->lna_gain->val);
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
 	if (priv->lna_gain_auto->val && priv->if_gain_auto->cur.val)
 		u8tmp = 0x17;
 	else if (priv->lna_gain_auto->val)
@@ -416,16 +387,10 @@ static int e4000_set_lna_gain(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 	}
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	return 0;
 err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+	if (ret)
+		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 
-	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -434,14 +399,12 @@ static int e4000_set_mixer_gain(struct dvb_frontend *fe)
 	struct e4000_priv *priv = fe->tuner_priv;
 	int ret;
 	u8 u8tmp;
+
 	dev_dbg(&priv->client->dev, "%s: mixer auto=%d->%d val=%d->%d\n",
 			__func__, priv->mixer_gain_auto->cur.val,
 			priv->mixer_gain_auto->val, priv->mixer_gain->cur.val,
 			priv->mixer_gain->val);
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
 	if (priv->mixer_gain_auto->val)
 		u8tmp = 0x15;
 	else
@@ -456,16 +419,10 @@ static int e4000_set_mixer_gain(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 	}
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	return 0;
 err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+	if (ret)
+		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 
-	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -475,14 +432,12 @@ static int e4000_set_if_gain(struct dvb_frontend *fe)
 	int ret;
 	u8 buf[2];
 	u8 u8tmp;
+
 	dev_dbg(&priv->client->dev, "%s: if auto=%d->%d val=%d->%d\n",
 			__func__, priv->if_gain_auto->cur.val,
 			priv->if_gain_auto->val, priv->if_gain->cur.val,
 			priv->if_gain->val);
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
 	if (priv->if_gain_auto->val && priv->lna_gain_auto->cur.val)
 		u8tmp = 0x17;
 	else if (priv->lna_gain_auto->cur.val)
@@ -503,16 +458,10 @@ static int e4000_set_if_gain(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 	}
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	return 0;
 err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+	if (ret)
+		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 
-	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -525,18 +474,12 @@ static int e4000_pll_lock(struct dvb_frontend *fe)
 	if (priv->active == false)
 		return 0;
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
 	ret = e4000_rd_reg(priv, 0x07, &u8tmp);
 	if (ret)
 		goto err;
 
 	priv->pll_lock->val = (u8tmp & 0x01);
 err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
 	if (ret)
 		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
 
@@ -567,6 +510,7 @@ static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct dvb_frontend *fe = priv->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
+
 	dev_dbg(&priv->client->dev,
 			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
 			__func__, ctrl->id, ctrl->name, ctrl->val,
@@ -632,9 +576,6 @@ static int e4000_probe(struct i2c_client *client,
 	int ret;
 	u8 chip_id;
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
 	priv = kzalloc(sizeof(struct e4000_priv), GFP_KERNEL);
 	if (!priv) {
 		ret = -ENOMEM;
@@ -702,19 +643,13 @@ static int e4000_probe(struct i2c_client *client,
 	fe->tuner_priv = priv;
 	memcpy(&fe->ops.tuner_ops, &e4000_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
 	i2c_set_clientdata(client, priv);
-
-	return 0;
 err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+	if (ret) {
+		dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
+		kfree(priv);
+	}
 
-	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
-	kfree(priv);
 	return ret;
 }
 
@@ -724,6 +659,7 @@ static int e4000_remove(struct i2c_client *client)
 	struct dvb_frontend *fe = priv->fe;
 
 	dev_dbg(&client->dev, "%s:\n", __func__);
+
 	v4l2_ctrl_handler_free(&priv->hdl);
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
-- 
1.8.5.3

