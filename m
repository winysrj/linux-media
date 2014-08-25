Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52575 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638AbaHYRMQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:12:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/12] e4000: logging changes
Date: Mon, 25 Aug 2014 20:11:55 +0300
Message-Id: <1408986718-3881-9-git-send-email-crope@iki.fi>
In-Reply-To: <1408986718-3881-1-git-send-email-crope@iki.fi>
References: <1408986718-3881-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove function name from debug logs. Logging system could add it
automatically.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c | 71 ++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 39 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 90d9334..92fde76 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -26,7 +26,7 @@ static int e4000_init(struct dvb_frontend *fe)
 	struct e4000 *s = fe->tuner_priv;
 	int ret;
 
-	dev_dbg(&s->client->dev, "%s:\n", __func__);
+	dev_dbg(&s->client->dev, "\n");
 
 	/* dummy I2C to ensure I2C wakes up */
 	ret = regmap_write(s->regmap, 0x02, 0x40);
@@ -87,7 +87,7 @@ static int e4000_init(struct dvb_frontend *fe)
 	s->active = true;
 err:
 	if (ret)
-		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -97,7 +97,7 @@ static int e4000_sleep(struct dvb_frontend *fe)
 	struct e4000 *s = fe->tuner_priv;
 	int ret;
 
-	dev_dbg(&s->client->dev, "%s:\n", __func__);
+	dev_dbg(&s->client->dev, "\n");
 
 	s->active = false;
 
@@ -106,7 +106,7 @@ static int e4000_sleep(struct dvb_frontend *fe)
 		goto err;
 err:
 	if (ret)
-		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -121,9 +121,8 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	u8 buf[5], i_data[4], q_data[4];
 
 	dev_dbg(&s->client->dev,
-			"%s: delivery_system=%d frequency=%u bandwidth_hz=%u\n",
-			__func__, c->delivery_system, c->frequency,
-			c->bandwidth_hz);
+			"delivery_system=%d frequency=%u bandwidth_hz=%u\n",
+			c->delivery_system, c->frequency, c->bandwidth_hz);
 
 	/* gain control manual */
 	ret = regmap_write(s->regmap, 0x1a, 0x00);
@@ -150,9 +149,8 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	buf[3] = 0x00;
 	buf[4] = e4000_pll_lut[i].div;
 
-	dev_dbg(&s->client->dev,
-			"%s: f_vco=%llu pll div=%d sigma_delta=%04x\n",
-			__func__, f_vco, buf[0], sigma_delta);
+	dev_dbg(&s->client->dev, "f_vco=%llu pll div=%d sigma_delta=%04x\n",
+			f_vco, buf[0], sigma_delta);
 
 	ret = regmap_bulk_write(s->regmap, 0x09, buf, 5);
 	if (ret)
@@ -253,7 +251,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 err:
 	if (ret)
-		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -262,7 +260,7 @@ static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct e4000 *s = fe->tuner_priv;
 
-	dev_dbg(&s->client->dev, "%s:\n", __func__);
+	dev_dbg(&s->client->dev, "\n");
 
 	*frequency = 0; /* Zero-IF */
 
@@ -276,10 +274,9 @@ static int e4000_set_lna_gain(struct dvb_frontend *fe)
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&s->client->dev, "%s: lna auto=%d->%d val=%d->%d\n",
-			__func__, s->lna_gain_auto->cur.val,
-			s->lna_gain_auto->val, s->lna_gain->cur.val,
-			s->lna_gain->val);
+	dev_dbg(&s->client->dev, "lna auto=%d->%d val=%d->%d\n",
+			s->lna_gain_auto->cur.val, s->lna_gain_auto->val,
+			s->lna_gain->cur.val, s->lna_gain->val);
 
 	if (s->lna_gain_auto->val && s->if_gain_auto->cur.val)
 		u8tmp = 0x17;
@@ -301,7 +298,7 @@ static int e4000_set_lna_gain(struct dvb_frontend *fe)
 	}
 err:
 	if (ret)
-		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -312,10 +309,9 @@ static int e4000_set_mixer_gain(struct dvb_frontend *fe)
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&s->client->dev, "%s: mixer auto=%d->%d val=%d->%d\n",
-			__func__, s->mixer_gain_auto->cur.val,
-			s->mixer_gain_auto->val, s->mixer_gain->cur.val,
-			s->mixer_gain->val);
+	dev_dbg(&s->client->dev, "mixer auto=%d->%d val=%d->%d\n",
+			s->mixer_gain_auto->cur.val, s->mixer_gain_auto->val,
+			s->mixer_gain->cur.val, s->mixer_gain->val);
 
 	if (s->mixer_gain_auto->val)
 		u8tmp = 0x15;
@@ -333,7 +329,7 @@ static int e4000_set_mixer_gain(struct dvb_frontend *fe)
 	}
 err:
 	if (ret)
-		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -345,10 +341,9 @@ static int e4000_set_if_gain(struct dvb_frontend *fe)
 	u8 buf[2];
 	u8 u8tmp;
 
-	dev_dbg(&s->client->dev, "%s: if auto=%d->%d val=%d->%d\n",
-			__func__, s->if_gain_auto->cur.val,
-			s->if_gain_auto->val, s->if_gain->cur.val,
-			s->if_gain->val);
+	dev_dbg(&s->client->dev, "if auto=%d->%d val=%d->%d\n",
+			s->if_gain_auto->cur.val, s->if_gain_auto->val,
+			s->if_gain->cur.val, s->if_gain->val);
 
 	if (s->if_gain_auto->val && s->lna_gain_auto->cur.val)
 		u8tmp = 0x17;
@@ -372,7 +367,7 @@ static int e4000_set_if_gain(struct dvb_frontend *fe)
 	}
 err:
 	if (ret)
-		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -390,7 +385,7 @@ static int e4000_pll_lock(struct dvb_frontend *fe)
 	s->pll_lock->val = (utmp & 0x01);
 err:
 	if (ret)
-		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -408,8 +403,8 @@ static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 		ret = e4000_pll_lock(s->fe);
 		break;
 	default:
-		dev_dbg(&s->client->dev, "%s: unknown ctrl: id=%d name=%s\n",
-				__func__, ctrl->id, ctrl->name);
+		dev_dbg(&s->client->dev, "unknown ctrl: id=%d name=%s\n",
+				ctrl->id, ctrl->name);
 		ret = -EINVAL;
 	}
 
@@ -445,8 +440,8 @@ static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = e4000_set_if_gain(s->fe);
 		break;
 	default:
-		dev_dbg(&s->client->dev, "%s: unknown ctrl: id=%d name=%s\n",
-				__func__, ctrl->id, ctrl->name);
+		dev_dbg(&s->client->dev, "unknown ctrl: id=%d name=%s\n",
+				ctrl->id, ctrl->name);
 		ret = -EINVAL;
 	}
 
@@ -494,7 +489,7 @@ static int e4000_probe(struct i2c_client *client,
 	s = kzalloc(sizeof(struct e4000), GFP_KERNEL);
 	if (!s) {
 		ret = -ENOMEM;
-		dev_err(&client->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		dev_err(&client->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
@@ -512,7 +507,7 @@ static int e4000_probe(struct i2c_client *client,
 	if (ret)
 		goto err;
 
-	dev_dbg(&s->client->dev, "%s: chip id=%02x\n", __func__, utmp);
+	dev_dbg(&s->client->dev, "chip id=%02x\n", utmp);
 
 	if (utmp != 0x40) {
 		ret = -ENODEV;
@@ -559,9 +554,7 @@ static int e4000_probe(struct i2c_client *client,
 	s->sd.ctrl_handler = &s->hdl;
 #endif
 
-	dev_info(&s->client->dev,
-			"%s: Elonics E4000 successfully identified\n",
-			KBUILD_MODNAME);
+	dev_info(&s->client->dev, "Elonics E4000 successfully identified\n");
 
 	fe->tuner_priv = s;
 	memcpy(&fe->ops.tuner_ops, &e4000_tuner_ops,
@@ -573,7 +566,7 @@ static int e4000_probe(struct i2c_client *client,
 	return 0;
 err:
 	if (ret) {
-		dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&client->dev, "failed=%d\n", ret);
 		kfree(s);
 	}
 
@@ -586,7 +579,7 @@ static int e4000_remove(struct i2c_client *client)
 	struct e4000 *s = container_of(sd, struct e4000, sd);
 	struct dvb_frontend *fe = s->fe;
 
-	dev_dbg(&client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 #if IS_ENABLED(CONFIG_VIDEO_V4L2)
 	v4l2_ctrl_handler_free(&s->hdl);
-- 
http://palosaari.fi/

