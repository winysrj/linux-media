Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48827 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbbEEWBa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 18:01:30 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] e4000: various small changes
Date: Wed,  6 May 2015 01:01:20 +0300
Message-Id: <1430863280-10266-4-git-send-email-crope@iki.fi>
In-Reply-To: <1430863280-10266-1-git-send-email-crope@iki.fi>
References: <1430863280-10266-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename device state from 's' to 'dev'.
Move single include to driver private header.
Change error handling type of each function to one I tend use nowadays.
Define I2C client pointer for each function and use it.
Do not clean tuner ops during driver remove - not needed.
Rename some other variables.

All are rather cosmetic changes.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c      | 350 +++++++++++++++++++-------------------
 drivers/media/tuners/e4000.h      |   1 -
 drivers/media/tuners/e4000_priv.h |   5 +-
 3 files changed, 177 insertions(+), 179 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index d27d2e7..6e2c025 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -19,110 +19,112 @@
  */
 
 #include "e4000_priv.h"
-#include <linux/math64.h>
 
 static int e4000_init(struct dvb_frontend *fe)
 {
-	struct e4000 *s = fe->tuner_priv;
+	struct e4000_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 
-	dev_dbg(&s->client->dev, "\n");
+	dev_dbg(&client->dev, "\n");
 
 	/* reset */
-	ret = regmap_write(s->regmap, 0x00, 0x01);
+	ret = regmap_write(dev->regmap, 0x00, 0x01);
 	if (ret)
 		goto err;
 
 	/* disable output clock */
-	ret = regmap_write(s->regmap, 0x06, 0x00);
+	ret = regmap_write(dev->regmap, 0x06, 0x00);
 	if (ret)
 		goto err;
 
-	ret = regmap_write(s->regmap, 0x7a, 0x96);
+	ret = regmap_write(dev->regmap, 0x7a, 0x96);
 	if (ret)
 		goto err;
 
 	/* configure gains */
-	ret = regmap_bulk_write(s->regmap, 0x7e, "\x01\xfe", 2);
+	ret = regmap_bulk_write(dev->regmap, 0x7e, "\x01\xfe", 2);
 	if (ret)
 		goto err;
 
-	ret = regmap_write(s->regmap, 0x82, 0x00);
+	ret = regmap_write(dev->regmap, 0x82, 0x00);
 	if (ret)
 		goto err;
 
-	ret = regmap_write(s->regmap, 0x24, 0x05);
+	ret = regmap_write(dev->regmap, 0x24, 0x05);
 	if (ret)
 		goto err;
 
-	ret = regmap_bulk_write(s->regmap, 0x87, "\x20\x01", 2);
+	ret = regmap_bulk_write(dev->regmap, 0x87, "\x20\x01", 2);
 	if (ret)
 		goto err;
 
-	ret = regmap_bulk_write(s->regmap, 0x9f, "\x7f\x07", 2);
+	ret = regmap_bulk_write(dev->regmap, 0x9f, "\x7f\x07", 2);
 	if (ret)
 		goto err;
 
 	/* DC offset control */
-	ret = regmap_write(s->regmap, 0x2d, 0x1f);
+	ret = regmap_write(dev->regmap, 0x2d, 0x1f);
 	if (ret)
 		goto err;
 
-	ret = regmap_bulk_write(s->regmap, 0x70, "\x01\x01", 2);
+	ret = regmap_bulk_write(dev->regmap, 0x70, "\x01\x01", 2);
 	if (ret)
 		goto err;
 
 	/* gain control */
-	ret = regmap_write(s->regmap, 0x1a, 0x17);
+	ret = regmap_write(dev->regmap, 0x1a, 0x17);
 	if (ret)
 		goto err;
 
-	ret = regmap_write(s->regmap, 0x1f, 0x1a);
+	ret = regmap_write(dev->regmap, 0x1f, 0x1a);
 	if (ret)
 		goto err;
 
-	s->active = true;
-err:
-	if (ret)
-		dev_dbg(&s->client->dev, "failed=%d\n", ret);
+	dev->active = true;
 
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int e4000_sleep(struct dvb_frontend *fe)
 {
-	struct e4000 *s = fe->tuner_priv;
+	struct e4000_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 
-	dev_dbg(&s->client->dev, "\n");
+	dev_dbg(&client->dev, "\n");
 
-	s->active = false;
+	dev->active = false;
 
-	ret = regmap_write(s->regmap, 0x00, 0x00);
+	ret = regmap_write(dev->regmap, 0x00, 0x00);
 	if (ret)
 		goto err;
-err:
-	if (ret)
-		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int e4000_set_params(struct dvb_frontend *fe)
 {
-	struct e4000 *s = fe->tuner_priv;
+	struct e4000_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	unsigned int div_n, k, k_cw, div_out;
 	u64 f_vco;
 	u8 buf[5], i_data[4], q_data[4];
 
-	dev_dbg(&s->client->dev,
-			"delivery_system=%d frequency=%u bandwidth_hz=%u\n",
-			c->delivery_system, c->frequency, c->bandwidth_hz);
+	dev_dbg(&client->dev,
+		"delivery_system=%d frequency=%u bandwidth_hz=%u\n",
+		c->delivery_system, c->frequency, c->bandwidth_hz);
 
 	/* gain control manual */
-	ret = regmap_write(s->regmap, 0x1a, 0x00);
+	ret = regmap_write(dev->regmap, 0x1a, 0x00);
 	if (ret)
 		goto err;
 
@@ -151,14 +153,14 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	#define F_REF s->clock
+	#define F_REF dev->clk
 	div_out = e4000_pll_lut[i].div_out;
 	f_vco = (u64) c->frequency * div_out;
 	/* calculate PLL integer and fractional control word */
 	div_n = div_u64_rem(f_vco, F_REF, &k);
 	k_cw = div_u64((u64) k * 0x10000, F_REF);
 
-	dev_dbg(&s->client->dev,
+	dev_dbg(&client->dev,
 		"frequency=%u f_vco=%llu F_REF=%u div_n=%u k=%u k_cw=%04x div_out=%u\n",
 		c->frequency, f_vco, F_REF, div_n, k, k_cw, div_out);
 
@@ -167,7 +169,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	buf[2] = (k_cw >> 8) & 0xff;
 	buf[3] = 0x00;
 	buf[4] = e4000_pll_lut[i].div_out_reg;
-	ret = regmap_bulk_write(s->regmap, 0x09, buf, 5);
+	ret = regmap_bulk_write(dev->regmap, 0x09, buf, 5);
 	if (ret)
 		goto err;
 
@@ -182,7 +184,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = regmap_write(s->regmap, 0x10, e400_lna_filter_lut[i].val);
+	ret = regmap_write(dev->regmap, 0x10, e400_lna_filter_lut[i].val);
 	if (ret)
 		goto err;
 
@@ -200,7 +202,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	buf[0] = e4000_if_filter_lut[i].reg11_val;
 	buf[1] = e4000_if_filter_lut[i].reg12_val;
 
-	ret = regmap_bulk_write(s->regmap, 0x11, buf, 2);
+	ret = regmap_bulk_write(dev->regmap, 0x11, buf, 2);
 	if (ret)
 		goto err;
 
@@ -215,33 +217,33 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = regmap_write(s->regmap, 0x07, e4000_band_lut[i].reg07_val);
+	ret = regmap_write(dev->regmap, 0x07, e4000_band_lut[i].reg07_val);
 	if (ret)
 		goto err;
 
-	ret = regmap_write(s->regmap, 0x78, e4000_band_lut[i].reg78_val);
+	ret = regmap_write(dev->regmap, 0x78, e4000_band_lut[i].reg78_val);
 	if (ret)
 		goto err;
 
 	/* DC offset */
 	for (i = 0; i < 4; i++) {
 		if (i == 0)
-			ret = regmap_bulk_write(s->regmap, 0x15, "\x00\x7e\x24", 3);
+			ret = regmap_bulk_write(dev->regmap, 0x15, "\x00\x7e\x24", 3);
 		else if (i == 1)
-			ret = regmap_bulk_write(s->regmap, 0x15, "\x00\x7f", 2);
+			ret = regmap_bulk_write(dev->regmap, 0x15, "\x00\x7f", 2);
 		else if (i == 2)
-			ret = regmap_bulk_write(s->regmap, 0x15, "\x01", 1);
+			ret = regmap_bulk_write(dev->regmap, 0x15, "\x01", 1);
 		else
-			ret = regmap_bulk_write(s->regmap, 0x16, "\x7e", 1);
+			ret = regmap_bulk_write(dev->regmap, 0x16, "\x7e", 1);
 
 		if (ret)
 			goto err;
 
-		ret = regmap_write(s->regmap, 0x29, 0x01);
+		ret = regmap_write(dev->regmap, 0x29, 0x01);
 		if (ret)
 			goto err;
 
-		ret = regmap_bulk_read(s->regmap, 0x2a, buf, 3);
+		ret = regmap_bulk_read(dev->regmap, 0x2a, buf, 3);
 		if (ret)
 			goto err;
 
@@ -252,30 +254,31 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	swap(q_data[2], q_data[3]);
 	swap(i_data[2], i_data[3]);
 
-	ret = regmap_bulk_write(s->regmap, 0x50, q_data, 4);
+	ret = regmap_bulk_write(dev->regmap, 0x50, q_data, 4);
 	if (ret)
 		goto err;
 
-	ret = regmap_bulk_write(s->regmap, 0x60, i_data, 4);
+	ret = regmap_bulk_write(dev->regmap, 0x60, i_data, 4);
 	if (ret)
 		goto err;
 
 	/* gain control auto */
-	ret = regmap_write(s->regmap, 0x1a, 0x17);
+	ret = regmap_write(dev->regmap, 0x1a, 0x17);
 	if (ret)
 		goto err;
-err:
-	if (ret)
-		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-	struct e4000 *s = fe->tuner_priv;
+	struct e4000_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 
-	dev_dbg(&s->client->dev, "\n");
+	dev_dbg(&client->dev, "\n");
 
 	*frequency = 0; /* Zero-IF */
 
@@ -285,141 +288,146 @@ static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 #if IS_ENABLED(CONFIG_VIDEO_V4L2)
 static int e4000_set_lna_gain(struct dvb_frontend *fe)
 {
-	struct e4000 *s = fe->tuner_priv;
+	struct e4000_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&s->client->dev, "lna auto=%d->%d val=%d->%d\n",
-			s->lna_gain_auto->cur.val, s->lna_gain_auto->val,
-			s->lna_gain->cur.val, s->lna_gain->val);
+	dev_dbg(&client->dev, "lna auto=%d->%d val=%d->%d\n",
+		dev->lna_gain_auto->cur.val, dev->lna_gain_auto->val,
+		dev->lna_gain->cur.val, dev->lna_gain->val);
 
-	if (s->lna_gain_auto->val && s->if_gain_auto->cur.val)
+	if (dev->lna_gain_auto->val && dev->if_gain_auto->cur.val)
 		u8tmp = 0x17;
-	else if (s->lna_gain_auto->val)
+	else if (dev->lna_gain_auto->val)
 		u8tmp = 0x19;
-	else if (s->if_gain_auto->cur.val)
+	else if (dev->if_gain_auto->cur.val)
 		u8tmp = 0x16;
 	else
 		u8tmp = 0x10;
 
-	ret = regmap_write(s->regmap, 0x1a, u8tmp);
+	ret = regmap_write(dev->regmap, 0x1a, u8tmp);
 	if (ret)
 		goto err;
 
-	if (s->lna_gain_auto->val == false) {
-		ret = regmap_write(s->regmap, 0x14, s->lna_gain->val);
+	if (dev->lna_gain_auto->val == false) {
+		ret = regmap_write(dev->regmap, 0x14, dev->lna_gain->val);
 		if (ret)
 			goto err;
 	}
-err:
-	if (ret)
-		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int e4000_set_mixer_gain(struct dvb_frontend *fe)
 {
-	struct e4000 *s = fe->tuner_priv;
+	struct e4000_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&s->client->dev, "mixer auto=%d->%d val=%d->%d\n",
-			s->mixer_gain_auto->cur.val, s->mixer_gain_auto->val,
-			s->mixer_gain->cur.val, s->mixer_gain->val);
+	dev_dbg(&client->dev, "mixer auto=%d->%d val=%d->%d\n",
+		dev->mixer_gain_auto->cur.val, dev->mixer_gain_auto->val,
+		dev->mixer_gain->cur.val, dev->mixer_gain->val);
 
-	if (s->mixer_gain_auto->val)
+	if (dev->mixer_gain_auto->val)
 		u8tmp = 0x15;
 	else
 		u8tmp = 0x14;
 
-	ret = regmap_write(s->regmap, 0x20, u8tmp);
+	ret = regmap_write(dev->regmap, 0x20, u8tmp);
 	if (ret)
 		goto err;
 
-	if (s->mixer_gain_auto->val == false) {
-		ret = regmap_write(s->regmap, 0x15, s->mixer_gain->val);
+	if (dev->mixer_gain_auto->val == false) {
+		ret = regmap_write(dev->regmap, 0x15, dev->mixer_gain->val);
 		if (ret)
 			goto err;
 	}
-err:
-	if (ret)
-		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int e4000_set_if_gain(struct dvb_frontend *fe)
 {
-	struct e4000 *s = fe->tuner_priv;
+	struct e4000_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[2];
 	u8 u8tmp;
 
-	dev_dbg(&s->client->dev, "if auto=%d->%d val=%d->%d\n",
-			s->if_gain_auto->cur.val, s->if_gain_auto->val,
-			s->if_gain->cur.val, s->if_gain->val);
+	dev_dbg(&client->dev, "if auto=%d->%d val=%d->%d\n",
+		dev->if_gain_auto->cur.val, dev->if_gain_auto->val,
+		dev->if_gain->cur.val, dev->if_gain->val);
 
-	if (s->if_gain_auto->val && s->lna_gain_auto->cur.val)
+	if (dev->if_gain_auto->val && dev->lna_gain_auto->cur.val)
 		u8tmp = 0x17;
-	else if (s->lna_gain_auto->cur.val)
+	else if (dev->lna_gain_auto->cur.val)
 		u8tmp = 0x19;
-	else if (s->if_gain_auto->val)
+	else if (dev->if_gain_auto->val)
 		u8tmp = 0x16;
 	else
 		u8tmp = 0x10;
 
-	ret = regmap_write(s->regmap, 0x1a, u8tmp);
+	ret = regmap_write(dev->regmap, 0x1a, u8tmp);
 	if (ret)
 		goto err;
 
-	if (s->if_gain_auto->val == false) {
-		buf[0] = e4000_if_gain_lut[s->if_gain->val].reg16_val;
-		buf[1] = e4000_if_gain_lut[s->if_gain->val].reg17_val;
-		ret = regmap_bulk_write(s->regmap, 0x16, buf, 2);
+	if (dev->if_gain_auto->val == false) {
+		buf[0] = e4000_if_gain_lut[dev->if_gain->val].reg16_val;
+		buf[1] = e4000_if_gain_lut[dev->if_gain->val].reg17_val;
+		ret = regmap_bulk_write(dev->regmap, 0x16, buf, 2);
 		if (ret)
 			goto err;
 	}
-err:
-	if (ret)
-		dev_dbg(&s->client->dev, "failed=%d\n", ret);
 
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int e4000_pll_lock(struct dvb_frontend *fe)
 {
-	struct e4000 *s = fe->tuner_priv;
+	struct e4000_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
-	unsigned int utmp;
+	unsigned int uitmp;
 
-	ret = regmap_read(s->regmap, 0x07, &utmp);
+	ret = regmap_read(dev->regmap, 0x07, &uitmp);
 	if (ret)
 		goto err;
 
-	s->pll_lock->val = (utmp & 0x01);
-err:
-	if (ret)
-		dev_dbg(&s->client->dev, "failed=%d\n", ret);
+	dev->pll_lock->val = (uitmp & 0x01);
 
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct e4000 *s = container_of(ctrl->handler, struct e4000, hdl);
+	struct e4000_dev *dev = container_of(ctrl->handler, struct e4000_dev, hdl);
+	struct i2c_client *client = dev->client;
 	int ret;
 
-	if (!s->active)
+	if (!dev->active)
 		return 0;
 
 	switch (ctrl->id) {
 	case  V4L2_CID_RF_TUNER_PLL_LOCK:
-		ret = e4000_pll_lock(s->fe);
+		ret = e4000_pll_lock(dev->fe);
 		break;
 	default:
-		dev_dbg(&s->client->dev, "unknown ctrl: id=%d name=%s\n",
-				ctrl->id, ctrl->name);
+		dev_dbg(&client->dev, "unknown ctrl: id=%d name=%s\n",
+			ctrl->id, ctrl->name);
 		ret = -EINVAL;
 	}
 
@@ -428,35 +436,35 @@ static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 
 static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct e4000 *s = container_of(ctrl->handler, struct e4000, hdl);
-	struct dvb_frontend *fe = s->fe;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct e4000_dev *dev = container_of(ctrl->handler, struct e4000_dev, hdl);
+	struct i2c_client *client = dev->client;
+	struct dtv_frontend_properties *c = &dev->fe->dtv_property_cache;
 	int ret;
 
-	if (!s->active)
+	if (!dev->active)
 		return 0;
 
 	switch (ctrl->id) {
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
 	case V4L2_CID_RF_TUNER_BANDWIDTH:
-		c->bandwidth_hz = s->bandwidth->val;
-		ret = e4000_set_params(s->fe);
+		c->bandwidth_hz = dev->bandwidth->val;
+		ret = e4000_set_params(dev->fe);
 		break;
 	case  V4L2_CID_RF_TUNER_LNA_GAIN_AUTO:
 	case  V4L2_CID_RF_TUNER_LNA_GAIN:
-		ret = e4000_set_lna_gain(s->fe);
+		ret = e4000_set_lna_gain(dev->fe);
 		break;
 	case  V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO:
 	case  V4L2_CID_RF_TUNER_MIXER_GAIN:
-		ret = e4000_set_mixer_gain(s->fe);
+		ret = e4000_set_mixer_gain(dev->fe);
 		break;
 	case  V4L2_CID_RF_TUNER_IF_GAIN_AUTO:
 	case  V4L2_CID_RF_TUNER_IF_GAIN:
-		ret = e4000_set_if_gain(s->fe);
+		ret = e4000_set_if_gain(dev->fe);
 		break;
 	default:
-		dev_dbg(&s->client->dev, "unknown ctrl: id=%d name=%s\n",
-				ctrl->id, ctrl->name);
+		dev_dbg(&client->dev, "unknown ctrl: id=%d name=%s\n",
+			ctrl->id, ctrl->name);
 		ret = -EINVAL;
 	}
 
@@ -488,129 +496,119 @@ static const struct dvb_tuner_ops e4000_tuner_ops = {
  * subdev itself, just to avoid reinventing the wheel.
  */
 static int e4000_probe(struct i2c_client *client,
-		const struct i2c_device_id *id)
+		       const struct i2c_device_id *id)
 {
+	struct e4000_dev *dev;
 	struct e4000_config *cfg = client->dev.platform_data;
 	struct dvb_frontend *fe = cfg->fe;
-	struct e4000 *s;
 	int ret;
-	unsigned int utmp;
+	unsigned int uitmp;
 	static const struct regmap_config regmap_config = {
 		.reg_bits = 8,
 		.val_bits = 8,
-		.max_register = 0xff,
 	};
 
-	s = kzalloc(sizeof(struct e4000), GFP_KERNEL);
-	if (!s) {
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
 		ret = -ENOMEM;
-		dev_err(&client->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
-	s->clock = cfg->clock;
-	s->client = client;
-	s->fe = cfg->fe;
-	s->regmap = devm_regmap_init_i2c(client, &regmap_config);
-	if (IS_ERR(s->regmap)) {
-		ret = PTR_ERR(s->regmap);
-		goto err;
+	dev->clk = cfg->clock;
+	dev->client = client;
+	dev->fe = cfg->fe;
+	dev->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err_kfree;
 	}
 
 	/* check if the tuner is there */
-	ret = regmap_read(s->regmap, 0x02, &utmp);
+	ret = regmap_read(dev->regmap, 0x02, &uitmp);
 	if (ret)
-		goto err;
+		goto err_kfree;
 
-	dev_dbg(&s->client->dev, "chip id=%02x\n", utmp);
+	dev_dbg(&client->dev, "chip id=%02x\n", uitmp);
 
-	if (utmp != 0x40) {
+	if (uitmp != 0x40) {
 		ret = -ENODEV;
-		goto err;
+		goto err_kfree;
 	}
 
 	/* put sleep as chip seems to be in normal mode by default */
-	ret = regmap_write(s->regmap, 0x00, 0x00);
+	ret = regmap_write(dev->regmap, 0x00, 0x00);
 	if (ret)
-		goto err;
+		goto err_kfree;
 
 #if IS_ENABLED(CONFIG_VIDEO_V4L2)
 	/* Register controls */
-	v4l2_ctrl_handler_init(&s->hdl, 9);
-	s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_handler_init(&dev->hdl, 9);
+	dev->bandwidth_auto = v4l2_ctrl_new_std(&dev->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
-	s->bandwidth = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
+	dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_BANDWIDTH, 4300000, 11000000, 100000, 4300000);
-	v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
-	s->lna_gain_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
+	dev->lna_gain_auto = v4l2_ctrl_new_std(&dev->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_LNA_GAIN_AUTO, 0, 1, 1, 1);
-	s->lna_gain = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
+	dev->lna_gain = v4l2_ctrl_new_std(&dev->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_LNA_GAIN, 0, 15, 1, 10);
-	v4l2_ctrl_auto_cluster(2, &s->lna_gain_auto, 0, false);
-	s->mixer_gain_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &dev->lna_gain_auto, 0, false);
+	dev->mixer_gain_auto = v4l2_ctrl_new_std(&dev->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO, 0, 1, 1, 1);
-	s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
+	dev->mixer_gain = v4l2_ctrl_new_std(&dev->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_MIXER_GAIN, 0, 1, 1, 1);
-	v4l2_ctrl_auto_cluster(2, &s->mixer_gain_auto, 0, false);
-	s->if_gain_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &dev->mixer_gain_auto, 0, false);
+	dev->if_gain_auto = v4l2_ctrl_new_std(&dev->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_IF_GAIN_AUTO, 0, 1, 1, 1);
-	s->if_gain = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
+	dev->if_gain = v4l2_ctrl_new_std(&dev->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_IF_GAIN, 0, 54, 1, 0);
-	v4l2_ctrl_auto_cluster(2, &s->if_gain_auto, 0, false);
-	s->pll_lock = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &dev->if_gain_auto, 0, false);
+	dev->pll_lock = v4l2_ctrl_new_std(&dev->hdl, &e4000_ctrl_ops,
 			V4L2_CID_RF_TUNER_PLL_LOCK,  0, 1, 1, 0);
-	if (s->hdl.error) {
-		ret = s->hdl.error;
-		dev_err(&s->client->dev, "Could not initialize controls\n");
-		v4l2_ctrl_handler_free(&s->hdl);
-		goto err;
+	if (dev->hdl.error) {
+		ret = dev->hdl.error;
+		dev_err(&client->dev, "Could not initialize controls\n");
+		v4l2_ctrl_handler_free(&dev->hdl);
+		goto err_kfree;
 	}
 
-	s->sd.ctrl_handler = &s->hdl;
+	dev->sd.ctrl_handler = &dev->hdl;
 #endif
-
-	dev_info(&s->client->dev, "Elonics E4000 successfully identified\n");
-
-	fe->tuner_priv = s;
+	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &e4000_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
+	v4l2_set_subdevdata(&dev->sd, client);
+	i2c_set_clientdata(client, &dev->sd);
 
-	v4l2_set_subdevdata(&s->sd, client);
-	i2c_set_clientdata(client, &s->sd);
-
+	dev_info(&client->dev, "Elonics E4000 successfully identified\n");
 	return 0;
+err_kfree:
+	kfree(dev);
 err:
-	if (ret) {
-		dev_dbg(&client->dev, "failed=%d\n", ret);
-		kfree(s);
-	}
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int e4000_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	struct e4000 *s = container_of(sd, struct e4000, sd);
-	struct dvb_frontend *fe = s->fe;
+	struct e4000_dev *dev = container_of(sd, struct e4000_dev, sd);
 
 	dev_dbg(&client->dev, "\n");
 
 #if IS_ENABLED(CONFIG_VIDEO_V4L2)
-	v4l2_ctrl_handler_free(&s->hdl);
+	v4l2_ctrl_handler_free(&dev->hdl);
 #endif
-	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
-	fe->tuner_priv = NULL;
-	kfree(s);
+	kfree(dev);
 
 	return 0;
 }
 
-static const struct i2c_device_id e4000_id[] = {
+static const struct i2c_device_id e4000_id_table[] = {
 	{"e4000", 0},
 	{}
 };
-MODULE_DEVICE_TABLE(i2c, e4000_id);
+MODULE_DEVICE_TABLE(i2c, e4000_id_table);
 
 static struct i2c_driver e4000_driver = {
 	.driver = {
@@ -620,7 +618,7 @@ static struct i2c_driver e4000_driver = {
 	},
 	.probe		= e4000_probe,
 	.remove		= e4000_remove,
-	.id_table	= e4000_id,
+	.id_table	= e4000_id_table,
 };
 
 module_i2c_driver(e4000_driver);
diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
index e74b8b2..aa9340c 100644
--- a/drivers/media/tuners/e4000.h
+++ b/drivers/media/tuners/e4000.h
@@ -21,7 +21,6 @@
 #ifndef E4000_H
 #define E4000_H
 
-#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 /*
diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
index 6214fc0..8e991df 100644
--- a/drivers/media/tuners/e4000_priv.h
+++ b/drivers/media/tuners/e4000_priv.h
@@ -22,14 +22,15 @@
 #define E4000_PRIV_H
 
 #include "e4000.h"
+#include <linux/math64.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
 #include <linux/regmap.h>
 
-struct e4000 {
+struct e4000_dev {
 	struct i2c_client *client;
 	struct regmap *regmap;
-	u32 clock;
+	u32 clk;
 	struct dvb_frontend *fe;
 	struct v4l2_subdev sd;
 	bool active;
-- 
http://palosaari.fi/

