Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52296 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbaCNAOt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 20:14:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/17] e4000: rename some variables
Date: Fri, 14 Mar 2014 02:14:28 +0200
Message-Id: <1394756071-22410-15-git-send-email-crope@iki.fi>
In-Reply-To: <1394756071-22410-1-git-send-email-crope@iki.fi>
References: <1394756071-22410-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename some variables.
Change error status checks from (ret < 0) to (ret).
No actual functionality changes.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c      | 332 +++++++++++++++++++-------------------
 drivers/media/tuners/e4000_priv.h |   2 +-
 2 files changed, 167 insertions(+), 167 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index f382b90..3b52550 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -23,110 +23,110 @@
 
 static int e4000_init(struct dvb_frontend *fe)
 {
-	struct e4000_priv *priv = fe->tuner_priv;
+	struct e4000 *s = fe->tuner_priv;
 	int ret;
 
-	dev_dbg(&priv->client->dev, "%s:\n", __func__);
+	dev_dbg(&s->client->dev, "%s:\n", __func__);
 
 	/* dummy I2C to ensure I2C wakes up */
-	ret = regmap_write(priv->regmap, 0x02, 0x40);
+	ret = regmap_write(s->regmap, 0x02, 0x40);
 
 	/* reset */
-	ret = regmap_write(priv->regmap, 0x00, 0x01);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x00, 0x01);
+	if (ret)
 		goto err;
 
 	/* disable output clock */
-	ret = regmap_write(priv->regmap, 0x06, 0x00);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x06, 0x00);
+	if (ret)
 		goto err;
 
-	ret = regmap_write(priv->regmap, 0x7a, 0x96);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x7a, 0x96);
+	if (ret)
 		goto err;
 
 	/* configure gains */
-	ret = regmap_bulk_write(priv->regmap, 0x7e, "\x01\xfe", 2);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x7e, "\x01\xfe", 2);
+	if (ret)
 		goto err;
 
-	ret = regmap_write(priv->regmap, 0x82, 0x00);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x82, 0x00);
+	if (ret)
 		goto err;
 
-	ret = regmap_write(priv->regmap, 0x24, 0x05);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x24, 0x05);
+	if (ret)
 		goto err;
 
-	ret = regmap_bulk_write(priv->regmap, 0x87, "\x20\x01", 2);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x87, "\x20\x01", 2);
+	if (ret)
 		goto err;
 
-	ret = regmap_bulk_write(priv->regmap, 0x9f, "\x7f\x07", 2);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x9f, "\x7f\x07", 2);
+	if (ret)
 		goto err;
 
 	/* DC offset control */
-	ret = regmap_write(priv->regmap, 0x2d, 0x1f);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x2d, 0x1f);
+	if (ret)
 		goto err;
 
-	ret = regmap_bulk_write(priv->regmap, 0x70, "\x01\x01", 2);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x70, "\x01\x01", 2);
+	if (ret)
 		goto err;
 
 	/* gain control */
-	ret = regmap_write(priv->regmap, 0x1a, 0x17);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x1a, 0x17);
+	if (ret)
 		goto err;
 
-	ret = regmap_write(priv->regmap, 0x1f, 0x1a);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x1f, 0x1a);
+	if (ret)
 		goto err;
 
-	priv->active = true;
+	s->active = true;
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int e4000_sleep(struct dvb_frontend *fe)
 {
-	struct e4000_priv *priv = fe->tuner_priv;
+	struct e4000 *s = fe->tuner_priv;
 	int ret;
 
-	dev_dbg(&priv->client->dev, "%s:\n", __func__);
+	dev_dbg(&s->client->dev, "%s:\n", __func__);
 
-	priv->active = false;
+	s->active = false;
 
-	ret = regmap_write(priv->regmap, 0x00, 0x00);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x00, 0x00);
+	if (ret)
 		goto err;
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int e4000_set_params(struct dvb_frontend *fe)
 {
-	struct e4000_priv *priv = fe->tuner_priv;
+	struct e4000 *s = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, sigma_delta;
 	u64 f_vco;
 	u8 buf[5], i_data[4], q_data[4];
 
-	dev_dbg(&priv->client->dev,
+	dev_dbg(&s->client->dev,
 			"%s: delivery_system=%d frequency=%u bandwidth_hz=%u\n",
 			__func__, c->delivery_system, c->frequency,
 			c->bandwidth_hz);
 
 	/* gain control manual */
-	ret = regmap_write(priv->regmap, 0x1a, 0x00);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x1a, 0x00);
+	if (ret)
 		goto err;
 
 	/* PLL */
@@ -141,19 +141,19 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	}
 
 	f_vco = 1ull * c->frequency * e4000_pll_lut[i].mul;
-	sigma_delta = div_u64(0x10000ULL * (f_vco % priv->clock), priv->clock);
-	buf[0] = div_u64(f_vco, priv->clock);
+	sigma_delta = div_u64(0x10000ULL * (f_vco % s->clock), s->clock);
+	buf[0] = div_u64(f_vco, s->clock);
 	buf[1] = (sigma_delta >> 0) & 0xff;
 	buf[2] = (sigma_delta >> 8) & 0xff;
 	buf[3] = 0x00;
 	buf[4] = e4000_pll_lut[i].div;
 
-	dev_dbg(&priv->client->dev,
+	dev_dbg(&s->client->dev,
 			"%s: f_vco=%llu pll div=%d sigma_delta=%04x\n",
 			__func__, f_vco, buf[0], sigma_delta);
 
-	ret = regmap_bulk_write(priv->regmap, 0x09, buf, 5);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x09, buf, 5);
+	if (ret)
 		goto err;
 
 	/* LNA filter (RF filter) */
@@ -167,8 +167,8 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = regmap_write(priv->regmap, 0x10, e400_lna_filter_lut[i].val);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x10, e400_lna_filter_lut[i].val);
+	if (ret)
 		goto err;
 
 	/* IF filters */
@@ -185,8 +185,8 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	buf[0] = e4000_if_filter_lut[i].reg11_val;
 	buf[1] = e4000_if_filter_lut[i].reg12_val;
 
-	ret = regmap_bulk_write(priv->regmap, 0x11, buf, 2);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x11, buf, 2);
+	if (ret)
 		goto err;
 
 	/* frequency band */
@@ -200,34 +200,34 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = regmap_write(priv->regmap, 0x07, e4000_band_lut[i].reg07_val);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x07, e4000_band_lut[i].reg07_val);
+	if (ret)
 		goto err;
 
-	ret = regmap_write(priv->regmap, 0x78, e4000_band_lut[i].reg78_val);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x78, e4000_band_lut[i].reg78_val);
+	if (ret)
 		goto err;
 
 	/* DC offset */
 	for (i = 0; i < 4; i++) {
 		if (i == 0)
-			ret = regmap_bulk_write(priv->regmap, 0x15, "\x00\x7e\x24", 3);
+			ret = regmap_bulk_write(s->regmap, 0x15, "\x00\x7e\x24", 3);
 		else if (i == 1)
-			ret = regmap_bulk_write(priv->regmap, 0x15, "\x00\x7f", 2);
+			ret = regmap_bulk_write(s->regmap, 0x15, "\x00\x7f", 2);
 		else if (i == 2)
-			ret = regmap_bulk_write(priv->regmap, 0x15, "\x01", 1);
+			ret = regmap_bulk_write(s->regmap, 0x15, "\x01", 1);
 		else
-			ret = regmap_bulk_write(priv->regmap, 0x16, "\x7e", 1);
+			ret = regmap_bulk_write(s->regmap, 0x16, "\x7e", 1);
 
-		if (ret < 0)
+		if (ret)
 			goto err;
 
-		ret = regmap_write(priv->regmap, 0x29, 0x01);
-		if (ret < 0)
+		ret = regmap_write(s->regmap, 0x29, 0x01);
+		if (ret)
 			goto err;
 
-		ret = regmap_bulk_read(priv->regmap, 0x2a, buf, 3);
-		if (ret < 0)
+		ret = regmap_bulk_read(s->regmap, 0x2a, buf, 3);
+		if (ret)
 			goto err;
 
 		i_data[i] = (((buf[2] >> 0) & 0x3) << 6) | (buf[0] & 0x3f);
@@ -237,30 +237,30 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	swap(q_data[2], q_data[3]);
 	swap(i_data[2], i_data[3]);
 
-	ret = regmap_bulk_write(priv->regmap, 0x50, q_data, 4);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x50, q_data, 4);
+	if (ret)
 		goto err;
 
-	ret = regmap_bulk_write(priv->regmap, 0x60, i_data, 4);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x60, i_data, 4);
+	if (ret)
 		goto err;
 
 	/* gain control auto */
-	ret = regmap_write(priv->regmap, 0x1a, 0x17);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x1a, 0x17);
+	if (ret)
 		goto err;
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-	struct e4000_priv *priv = fe->tuner_priv;
+	struct e4000 *s = fe->tuner_priv;
 
-	dev_dbg(&priv->client->dev, "%s:\n", __func__);
+	dev_dbg(&s->client->dev, "%s:\n", __func__);
 
 	*frequency = 0; /* Zero-IF */
 
@@ -269,143 +269,143 @@ static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static int e4000_set_lna_gain(struct dvb_frontend *fe)
 {
-	struct e4000_priv *priv = fe->tuner_priv;
+	struct e4000 *s = fe->tuner_priv;
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&priv->client->dev, "%s: lna auto=%d->%d val=%d->%d\n",
-			__func__, priv->lna_gain_auto->cur.val,
-			priv->lna_gain_auto->val, priv->lna_gain->cur.val,
-			priv->lna_gain->val);
+	dev_dbg(&s->client->dev, "%s: lna auto=%d->%d val=%d->%d\n",
+			__func__, s->lna_gain_auto->cur.val,
+			s->lna_gain_auto->val, s->lna_gain->cur.val,
+			s->lna_gain->val);
 
-	if (priv->lna_gain_auto->val && priv->if_gain_auto->cur.val)
+	if (s->lna_gain_auto->val && s->if_gain_auto->cur.val)
 		u8tmp = 0x17;
-	else if (priv->lna_gain_auto->val)
+	else if (s->lna_gain_auto->val)
 		u8tmp = 0x19;
-	else if (priv->if_gain_auto->cur.val)
+	else if (s->if_gain_auto->cur.val)
 		u8tmp = 0x16;
 	else
 		u8tmp = 0x10;
 
-	ret = regmap_write(priv->regmap, 0x1a, u8tmp);
+	ret = regmap_write(s->regmap, 0x1a, u8tmp);
 	if (ret)
 		goto err;
 
-	if (priv->lna_gain_auto->val == false) {
-		ret = regmap_write(priv->regmap, 0x14, priv->lna_gain->val);
+	if (s->lna_gain_auto->val == false) {
+		ret = regmap_write(s->regmap, 0x14, s->lna_gain->val);
 		if (ret)
 			goto err;
 	}
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int e4000_set_mixer_gain(struct dvb_frontend *fe)
 {
-	struct e4000_priv *priv = fe->tuner_priv;
+	struct e4000 *s = fe->tuner_priv;
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&priv->client->dev, "%s: mixer auto=%d->%d val=%d->%d\n",
-			__func__, priv->mixer_gain_auto->cur.val,
-			priv->mixer_gain_auto->val, priv->mixer_gain->cur.val,
-			priv->mixer_gain->val);
+	dev_dbg(&s->client->dev, "%s: mixer auto=%d->%d val=%d->%d\n",
+			__func__, s->mixer_gain_auto->cur.val,
+			s->mixer_gain_auto->val, s->mixer_gain->cur.val,
+			s->mixer_gain->val);
 
-	if (priv->mixer_gain_auto->val)
+	if (s->mixer_gain_auto->val)
 		u8tmp = 0x15;
 	else
 		u8tmp = 0x14;
 
-	ret = regmap_write(priv->regmap, 0x20, u8tmp);
+	ret = regmap_write(s->regmap, 0x20, u8tmp);
 	if (ret)
 		goto err;
 
-	if (priv->mixer_gain_auto->val == false) {
-		ret = regmap_write(priv->regmap, 0x15, priv->mixer_gain->val);
+	if (s->mixer_gain_auto->val == false) {
+		ret = regmap_write(s->regmap, 0x15, s->mixer_gain->val);
 		if (ret)
 			goto err;
 	}
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int e4000_set_if_gain(struct dvb_frontend *fe)
 {
-	struct e4000_priv *priv = fe->tuner_priv;
+	struct e4000 *s = fe->tuner_priv;
 	int ret;
 	u8 buf[2];
 	u8 u8tmp;
 
-	dev_dbg(&priv->client->dev, "%s: if auto=%d->%d val=%d->%d\n",
-			__func__, priv->if_gain_auto->cur.val,
-			priv->if_gain_auto->val, priv->if_gain->cur.val,
-			priv->if_gain->val);
+	dev_dbg(&s->client->dev, "%s: if auto=%d->%d val=%d->%d\n",
+			__func__, s->if_gain_auto->cur.val,
+			s->if_gain_auto->val, s->if_gain->cur.val,
+			s->if_gain->val);
 
-	if (priv->if_gain_auto->val && priv->lna_gain_auto->cur.val)
+	if (s->if_gain_auto->val && s->lna_gain_auto->cur.val)
 		u8tmp = 0x17;
-	else if (priv->lna_gain_auto->cur.val)
+	else if (s->lna_gain_auto->cur.val)
 		u8tmp = 0x19;
-	else if (priv->if_gain_auto->val)
+	else if (s->if_gain_auto->val)
 		u8tmp = 0x16;
 	else
 		u8tmp = 0x10;
 
-	ret = regmap_write(priv->regmap, 0x1a, u8tmp);
+	ret = regmap_write(s->regmap, 0x1a, u8tmp);
 	if (ret)
 		goto err;
 
-	if (priv->if_gain_auto->val == false) {
-		buf[0] = e4000_if_gain_lut[priv->if_gain->val].reg16_val;
-		buf[1] = e4000_if_gain_lut[priv->if_gain->val].reg17_val;
-		ret = regmap_bulk_write(priv->regmap, 0x16, buf, 2);
+	if (s->if_gain_auto->val == false) {
+		buf[0] = e4000_if_gain_lut[s->if_gain->val].reg16_val;
+		buf[1] = e4000_if_gain_lut[s->if_gain->val].reg17_val;
+		ret = regmap_bulk_write(s->regmap, 0x16, buf, 2);
 		if (ret)
 			goto err;
 	}
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int e4000_pll_lock(struct dvb_frontend *fe)
 {
-	struct e4000_priv *priv = fe->tuner_priv;
+	struct e4000 *s = fe->tuner_priv;
 	int ret;
 	unsigned int utmp;
 
-	ret = regmap_read(priv->regmap, 0x07, &utmp);
-	if (ret < 0)
+	ret = regmap_read(s->regmap, 0x07, &utmp);
+	if (ret)
 		goto err;
 
-	priv->pll_lock->val = (utmp & 0x01);
+	s->pll_lock->val = (utmp & 0x01);
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct e4000_priv *priv = container_of(ctrl->handler, struct e4000_priv, hdl);
+	struct e4000 *s = container_of(ctrl->handler, struct e4000, hdl);
 	int ret;
 
-	if (priv->active == false)
+	if (s->active == false)
 		return 0;
 
 	switch (ctrl->id) {
 	case  V4L2_CID_RF_TUNER_PLL_LOCK:
-		ret = e4000_pll_lock(priv->fe);
+		ret = e4000_pll_lock(s->fe);
 		break;
 	default:
-		dev_dbg(&priv->client->dev, "%s: unknown ctrl: id=%d name=%s\n",
+		dev_dbg(&s->client->dev, "%s: unknown ctrl: id=%d name=%s\n",
 				__func__, ctrl->id, ctrl->name);
 		ret = -EINVAL;
 	}
@@ -415,34 +415,34 @@ static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 
 static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct e4000_priv *priv = container_of(ctrl->handler, struct e4000_priv, hdl);
-	struct dvb_frontend *fe = priv->fe;
+	struct e4000 *s = container_of(ctrl->handler, struct e4000, hdl);
+	struct dvb_frontend *fe = s->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	if (priv->active == false)
+	if (s->active == false)
 		return 0;
 
 	switch (ctrl->id) {
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
 	case V4L2_CID_RF_TUNER_BANDWIDTH:
-		c->bandwidth_hz = priv->bandwidth->val;
-		ret = e4000_set_params(priv->fe);
+		c->bandwidth_hz = s->bandwidth->val;
+		ret = e4000_set_params(s->fe);
 		break;
 	case  V4L2_CID_RF_TUNER_LNA_GAIN_AUTO:
 	case  V4L2_CID_RF_TUNER_LNA_GAIN:
-		ret = e4000_set_lna_gain(priv->fe);
+		ret = e4000_set_lna_gain(s->fe);
 		break;
 	case  V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO:
 	case  V4L2_CID_RF_TUNER_MIXER_GAIN:
-		ret = e4000_set_mixer_gain(priv->fe);
+		ret = e4000_set_mixer_gain(s->fe);
 		break;
 	case  V4L2_CID_RF_TUNER_IF_GAIN_AUTO:
 	case  V4L2_CID_RF_TUNER_IF_GAIN:
-		ret = e4000_set_if_gain(priv->fe);
+		ret = e4000_set_if_gain(s->fe);
 		break;
 	default:
-		dev_dbg(&priv->client->dev, "%s: unknown ctrl: id=%d name=%s\n",
+		dev_dbg(&s->client->dev, "%s: unknown ctrl: id=%d name=%s\n",
 				__func__, ctrl->id, ctrl->name);
 		ret = -EINVAL;
 	}
@@ -478,7 +478,7 @@ static int e4000_probe(struct i2c_client *client,
 {
 	struct e4000_config *cfg = client->dev.platform_data;
 	struct dvb_frontend *fe = cfg->fe;
-	struct e4000_priv *priv;
+	struct e4000 *s;
 	int ret;
 	unsigned int utmp;
 	static const struct regmap_config regmap_config = {
@@ -487,28 +487,28 @@ static int e4000_probe(struct i2c_client *client,
 		.max_register = 0xff,
 	};
 
-	priv = kzalloc(sizeof(struct e4000_priv), GFP_KERNEL);
-	if (!priv) {
+	s = kzalloc(sizeof(struct e4000), GFP_KERNEL);
+	if (!s) {
 		ret = -ENOMEM;
 		dev_err(&client->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
 		goto err;
 	}
 
-	priv->clock = cfg->clock;
-	priv->client = client;
-	priv->fe = cfg->fe;
-	priv->regmap = devm_regmap_init_i2c(client, &regmap_config);
-	if (IS_ERR(priv->regmap)) {
-		ret = PTR_ERR(priv->regmap);
+	s->clock = cfg->clock;
+	s->client = client;
+	s->fe = cfg->fe;
+	s->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(s->regmap)) {
+		ret = PTR_ERR(s->regmap);
 		goto err;
 	}
 
 	/* check if the tuner is there */
-	ret = regmap_read(priv->regmap, 0x02, &utmp);
-	if (ret < 0)
+	ret = regmap_read(s->regmap, 0x02, &utmp);
+	if (ret)
 		goto err;
 
-	dev_dbg(&priv->client->dev, "%s: chip id=%02x\n", __func__, utmp);
+	dev_dbg(&s->client->dev, "%s: chip id=%02x\n", __func__, utmp);
 
 	if (utmp != 0x40) {
 		ret = -ENODEV;
@@ -516,59 +516,59 @@ static int e4000_probe(struct i2c_client *client,
 	}
 
 	/* put sleep as chip seems to be in normal mode by default */
-	ret = regmap_write(priv->regmap, 0x00, 0x00);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x00, 0x00);
+	if (ret)
 		goto err;
 
 	/* Register controls */
-	v4l2_ctrl_handler_init(&priv->hdl, 9);
-	priv->bandwidth_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_handler_init(&s->hdl, 9);
+	s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
-	priv->bandwidth = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	s->bandwidth = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_BANDWIDTH, 4300000, 11000000, 100000, 4300000);
-	v4l2_ctrl_auto_cluster(2, &priv->bandwidth_auto, 0, false);
-	priv->lna_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
+	s->lna_gain_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_LNA_GAIN_AUTO, 0, 1, 1, 1);
-	priv->lna_gain = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	s->lna_gain = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_LNA_GAIN, 0, 15, 1, 10);
-	v4l2_ctrl_auto_cluster(2, &priv->lna_gain_auto, 0, false);
-	priv->mixer_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &s->lna_gain_auto, 0, false);
+	s->mixer_gain_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO, 0, 1, 1, 1);
-	priv->mixer_gain = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_MIXER_GAIN, 0, 1, 1, 1);
-	v4l2_ctrl_auto_cluster(2, &priv->mixer_gain_auto, 0, false);
-	priv->if_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &s->mixer_gain_auto, 0, false);
+	s->if_gain_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_IF_GAIN_AUTO, 0, 1, 1, 1);
-	priv->if_gain = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	s->if_gain = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_IF_GAIN, 0, 54, 1, 0);
-	v4l2_ctrl_auto_cluster(2, &priv->if_gain_auto, 0, false);
-	priv->pll_lock = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &s->if_gain_auto, 0, false);
+	s->pll_lock = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_PLL_LOCK,  0, 1, 1, 0);
-	if (priv->hdl.error) {
-		ret = priv->hdl.error;
-		dev_err(&priv->client->dev, "Could not initialize controls\n");
-		v4l2_ctrl_handler_free(&priv->hdl);
+	if (s->hdl.error) {
+		ret = s->hdl.error;
+		dev_err(&s->client->dev, "Could not initialize controls\n");
+		v4l2_ctrl_handler_free(&s->hdl);
 		goto err;
 	}
 
-	priv->sd.ctrl_handler = &priv->hdl;
+	s->sd.ctrl_handler = &s->hdl;
 
-	dev_info(&priv->client->dev,
+	dev_info(&s->client->dev,
 			"%s: Elonics E4000 successfully identified\n",
 			KBUILD_MODNAME);
 
-	fe->tuner_priv = priv;
+	fe->tuner_priv = s;
 	memcpy(&fe->ops.tuner_ops, &e4000_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
 
-	v4l2_set_subdevdata(&priv->sd, client);
-	i2c_set_clientdata(client, &priv->sd);
+	v4l2_set_subdevdata(&s->sd, client);
+	i2c_set_clientdata(client, &s->sd);
 
 	return 0;
 err:
 	if (ret) {
 		dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
-		kfree(priv);
+		kfree(s);
 	}
 
 	return ret;
@@ -577,15 +577,15 @@ err:
 static int e4000_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	struct e4000_priv *priv = container_of(sd, struct e4000_priv, sd);
-	struct dvb_frontend *fe = priv->fe;
+	struct e4000 *s = container_of(sd, struct e4000, sd);
+	struct dvb_frontend *fe = s->fe;
 
 	dev_dbg(&client->dev, "%s:\n", __func__);
 
-	v4l2_ctrl_handler_free(&priv->hdl);
+	v4l2_ctrl_handler_free(&s->hdl);
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
-	kfree(priv);
+	kfree(s);
 
 	return 0;
 }
diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
index e772b00..cb00704 100644
--- a/drivers/media/tuners/e4000_priv.h
+++ b/drivers/media/tuners/e4000_priv.h
@@ -26,7 +26,7 @@
 #include <media/v4l2-subdev.h>
 #include <linux/regmap.h>
 
-struct e4000_priv {
+struct e4000 {
 	struct i2c_client *client;
 	struct regmap *regmap;
 	u32 clock;
-- 
1.8.5.3

