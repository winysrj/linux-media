Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52534 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaBIJcJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 04:32:09 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [REVIEW PATCH 86/86] e4000: convert to Regmap API
Date: Sun,  9 Feb 2014 10:49:31 +0200
Message-Id: <1391935771-18670-87-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That comes possible after driver was converted to kernel I2C model
(I2C binding & proper I2C client with no gate control hack). All
nasty low level I2C routines are now covered by regmap.

Also some variable renaming and minor functionality changes.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig      |   1 +
 drivers/media/tuners/e4000.c      | 442 ++++++++++++++++----------------------
 drivers/media/tuners/e4000_priv.h |   4 +-
 3 files changed, 184 insertions(+), 263 deletions(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index ba2e365..a128488 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -204,6 +204,7 @@ config MEDIA_TUNER_TDA18212
 config MEDIA_TUNER_E4000
 	tristate "Elonics E4000 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Elonics E4000 silicon tuner driver.
diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index e3e3b7e..0d516ad 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -21,203 +21,112 @@
 #include "e4000_priv.h"
 #include <linux/math64.h>
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
-
-/* write multiple registers */
-static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
-{
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = priv->client->addr,
-			.flags = 0,
-			.len = 1 + len,
-			.buf = buf,
-		}
-	};
-
-	if (1 + len > sizeof(buf)) {
-		dev_warn(&priv->client->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
-		return -EINVAL;
-	}
-
-	buf[0] = reg;
-	memcpy(&buf[1], val, len);
-
-	ret = i2c_transfer(priv->client->adapter, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&priv->client->dev,
-				"%s: i2c wr failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-	return ret;
-}
-
-/* read multiple registers */
-static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
-{
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[2] = {
-		{
-			.addr = priv->client->addr,
-			.flags = 0,
-			.len = 1,
-			.buf = &reg,
-		}, {
-			.addr = priv->client->addr,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = buf,
-		}
-	};
-
-	if (len > sizeof(buf)) {
-		dev_warn(&priv->client->dev,
-			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
-		return -EINVAL;
-	}
-
-	ret = i2c_transfer(priv->client->adapter, msg, 2);
-	if (ret == 2) {
-		memcpy(val, buf, len);
-		ret = 0;
-	} else {
-		dev_warn(&priv->client->dev,
-				"%s: i2c rd failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* write single register */
-static int e4000_wr_reg(struct e4000_priv *priv, u8 reg, u8 val)
-{
-	return e4000_wr_regs(priv, reg, &val, 1);
-}
-
-/* read single register */
-static int e4000_rd_reg(struct e4000_priv *priv, u8 reg, u8 *val)
-{
-	return e4000_rd_regs(priv, reg, val, 1);
-}
-
 static int e4000_init(struct dvb_frontend *fe)
 {
-	struct e4000_priv *priv = fe->tuner_priv;
+	struct e4000 *s = fe->tuner_priv;
 	int ret;
 
-	dev_dbg(&priv->client->dev, "%s:\n", __func__);
+	dev_dbg(&s->client->dev, "%s:\n", __func__);
 
 	/* dummy I2C to ensure I2C wakes up */
-	ret = e4000_wr_reg(priv, 0x02, 0x40);
+	ret = regmap_write(s->regmap, 0x02, 0x40);
 
 	/* reset */
-	ret = e4000_wr_reg(priv, 0x00, 0x01);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x00, 0x01);
+	if (ret)
 		goto err;
 
 	/* disable output clock */
-	ret = e4000_wr_reg(priv, 0x06, 0x00);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x06, 0x00);
+	if (ret)
 		goto err;
 
-	ret = e4000_wr_reg(priv, 0x7a, 0x96);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x7a, 0x96);
+	if (ret)
 		goto err;
 
 	/* configure gains */
-	ret = e4000_wr_regs(priv, 0x7e, "\x01\xfe", 2);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x7e, "\x01\xfe", 2);
+	if (ret)
 		goto err;
 
-	ret = e4000_wr_reg(priv, 0x82, 0x00);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x82, 0x00);
+	if (ret)
 		goto err;
 
-	ret = e4000_wr_reg(priv, 0x24, 0x05);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x24, 0x05);
+	if (ret)
 		goto err;
 
-	ret = e4000_wr_regs(priv, 0x87, "\x20\x01", 2);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x87, "\x20\x01", 2);
+	if (ret)
 		goto err;
 
-	ret = e4000_wr_regs(priv, 0x9f, "\x7f\x07", 2);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x9f, "\x7f\x07", 2);
+	if (ret)
 		goto err;
 
 	/* DC offset control */
-	ret = e4000_wr_reg(priv, 0x2d, 0x1f);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x2d, 0x1f);
+	if (ret)
 		goto err;
 
-	ret = e4000_wr_regs(priv, 0x70, "\x01\x01", 2);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x70, "\x01\x01", 2);
+	if (ret)
 		goto err;
 
 	/* gain control */
-	ret = e4000_wr_reg(priv, 0x1a, 0x17);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x1a, 0x17);
+	if (ret)
 		goto err;
 
-	ret = e4000_wr_reg(priv, 0x1f, 0x1a);
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
 
-	ret = e4000_wr_reg(priv, 0x00, 0x00);
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
-	ret = e4000_wr_reg(priv, 0x1a, 0x00);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x1a, 0x00);
+	if (ret)
 		goto err;
 
 	/* PLL */
@@ -232,19 +141,19 @@ static int e4000_set_params(struct dvb_frontend *fe)
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
 
-	ret = e4000_wr_regs(priv, 0x09, buf, 5);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x09, buf, 5);
+	if (ret)
 		goto err;
 
 	/* LNA filter (RF filter) */
@@ -258,8 +167,8 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = e4000_wr_reg(priv, 0x10, e400_lna_filter_lut[i].val);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x10, e400_lna_filter_lut[i].val);
+	if (ret)
 		goto err;
 
 	/* IF filters */
@@ -276,8 +185,8 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	buf[0] = e4000_if_filter_lut[i].reg11_val;
 	buf[1] = e4000_if_filter_lut[i].reg12_val;
 
-	ret = e4000_wr_regs(priv, 0x11, buf, 2);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x11, buf, 2);
+	if (ret)
 		goto err;
 
 	/* frequency band */
@@ -291,34 +200,34 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = e4000_wr_reg(priv, 0x07, e4000_band_lut[i].reg07_val);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x07, e4000_band_lut[i].reg07_val);
+	if (ret)
 		goto err;
 
-	ret = e4000_wr_reg(priv, 0x78, e4000_band_lut[i].reg78_val);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x78, e4000_band_lut[i].reg78_val);
+	if (ret)
 		goto err;
 
 	/* DC offset */
 	for (i = 0; i < 4; i++) {
 		if (i == 0)
-			ret = e4000_wr_regs(priv, 0x15, "\x00\x7e\x24", 3);
+			ret = regmap_bulk_write(s->regmap, 0x15, "\x00\x7e\x24", 3);
 		else if (i == 1)
-			ret = e4000_wr_regs(priv, 0x15, "\x00\x7f", 2);
+			ret = regmap_bulk_write(s->regmap, 0x15, "\x00\x7f", 2);
 		else if (i == 2)
-			ret = e4000_wr_regs(priv, 0x15, "\x01", 1);
+			ret = regmap_bulk_write(s->regmap, 0x15, "\x01", 1);
 		else
-			ret = e4000_wr_regs(priv, 0x16, "\x7e", 1);
+			ret = regmap_bulk_write(s->regmap, 0x16, "\x7e", 1);
 
-		if (ret < 0)
+		if (ret)
 			goto err;
 
-		ret = e4000_wr_reg(priv, 0x29, 0x01);
-		if (ret < 0)
+		ret = regmap_write(s->regmap, 0x29, 0x01);
+		if (ret)
 			goto err;
 
-		ret = e4000_rd_regs(priv, 0x2a, buf, 3);
-		if (ret < 0)
+		ret = regmap_bulk_read(s->regmap, 0x2a, buf, 3);
+		if (ret)
 			goto err;
 
 		i_data[i] = (((buf[2] >> 0) & 0x3) << 6) | (buf[0] & 0x3f);
@@ -328,30 +237,30 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	swap(q_data[2], q_data[3]);
 	swap(i_data[2], i_data[3]);
 
-	ret = e4000_wr_regs(priv, 0x50, q_data, 4);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x50, q_data, 4);
+	if (ret)
 		goto err;
 
-	ret = e4000_wr_regs(priv, 0x60, i_data, 4);
-	if (ret < 0)
+	ret = regmap_bulk_write(s->regmap, 0x60, i_data, 4);
+	if (ret)
 		goto err;
 
 	/* gain control auto */
-	ret = e4000_wr_reg(priv, 0x1a, 0x17);
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
 
@@ -360,143 +269,144 @@ static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
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
 
-	ret = e4000_wr_reg(priv, 0x1a, u8tmp);
+	ret = regmap_write(s->regmap, 0x1a, u8tmp);
 	if (ret)
 		goto err;
 
-	if (priv->lna_gain_auto->val == false) {
-		ret = e4000_wr_reg(priv, 0x14, priv->lna_gain->val);
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
 
-	ret = e4000_wr_reg(priv, 0x20, u8tmp);
+	ret = regmap_write(s->regmap, 0x20, u8tmp);
 	if (ret)
 		goto err;
 
-	if (priv->mixer_gain_auto->val == false) {
-		ret = e4000_wr_reg(priv, 0x15, priv->mixer_gain->val);
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
 
-	ret = e4000_wr_reg(priv, 0x1a, u8tmp);
+	ret = regmap_write(s->regmap, 0x1a, u8tmp);
 	if (ret)
 		goto err;
 
-	if (priv->if_gain_auto->val == false) {
-		buf[0] = e4000_if_gain_lut[priv->if_gain->val].reg16_val;
-		buf[1] = e4000_if_gain_lut[priv->if_gain->val].reg17_val;
-		ret = e4000_wr_regs(priv, 0x16, buf, 2);
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
-	u8 u8tmp;
-
-	if (priv->active == false)
-		return 0;
+	unsigned int utmp;
 
-	ret = e4000_rd_reg(priv, 0x07, &u8tmp);
+	ret = regmap_read(s->regmap, 0x07, &utmp);
 	if (ret)
 		goto err;
 
-	priv->pll_lock->val = (u8tmp & 0x01);
+	s->pll_lock->val = (utmp & 0x01);
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct e4000_priv *priv =
-			container_of(ctrl->handler, struct e4000_priv, hdl);
+	struct e4000 *s = container_of(ctrl->handler, struct e4000, hdl);
 	int ret;
 
+	if (s->active == false)
+		return 0;
+
 	switch (ctrl->id) {
 	case  V4L2_CID_PLL_LOCK:
-		ret = e4000_pll_lock(priv->fe);
+		ret = e4000_pll_lock(s->fe);
 		break;
 	default:
+		dev_dbg(&s->client->dev, "%s: unknown ctrl: id=%d name=%s\n",
+				__func__, ctrl->id, ctrl->name);
 		ret = -EINVAL;
 	}
 
@@ -505,36 +415,35 @@ static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 
 static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct e4000_priv *priv =
-			container_of(ctrl->handler, struct e4000_priv, hdl);
-	struct dvb_frontend *fe = priv->fe;
+	struct e4000 *s = container_of(ctrl->handler, struct e4000, hdl);
+	struct dvb_frontend *fe = s->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	dev_dbg(&priv->client->dev,
-			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
-			__func__, ctrl->id, ctrl->name, ctrl->val,
-			ctrl->minimum, ctrl->maximum, ctrl->step);
+	if (s->active == false)
+		return 0;
 
 	switch (ctrl->id) {
 	case V4L2_CID_BANDWIDTH_AUTO:
 	case V4L2_CID_BANDWIDTH:
-		c->bandwidth_hz = priv->bandwidth->val;
-		ret = e4000_set_params(priv->fe);
+		c->bandwidth_hz = s->bandwidth->val;
+		ret = e4000_set_params(s->fe);
 		break;
 	case  V4L2_CID_LNA_GAIN_AUTO:
 	case  V4L2_CID_LNA_GAIN:
-		ret = e4000_set_lna_gain(priv->fe);
+		ret = e4000_set_lna_gain(s->fe);
 		break;
 	case  V4L2_CID_MIXER_GAIN_AUTO:
 	case  V4L2_CID_MIXER_GAIN:
-		ret = e4000_set_mixer_gain(priv->fe);
+		ret = e4000_set_mixer_gain(s->fe);
 		break;
 	case  V4L2_CID_IF_GAIN_AUTO:
 	case  V4L2_CID_IF_GAIN:
-		ret = e4000_set_if_gain(priv->fe);
+		ret = e4000_set_if_gain(s->fe);
 		break;
 	default:
+		dev_dbg(&s->client->dev, "%s: unknown ctrl: id=%d name=%s\n",
+				__func__, ctrl->id, ctrl->name);
 		ret = -EINVAL;
 	}
 
@@ -562,8 +471,8 @@ static const struct dvb_tuner_ops e4000_tuner_ops = {
 
 struct v4l2_ctrl_handler *e4000_get_ctrl_handler(struct dvb_frontend *fe)
 {
-	struct e4000_priv *priv = fe->tuner_priv;
-	return &priv->hdl;
+	struct e4000 *s = fe->tuner_priv;
+	return &s->hdl;
 }
 EXPORT_SYMBOL(e4000_get_ctrl_handler);
 
@@ -572,82 +481,91 @@ static int e4000_probe(struct i2c_client *client,
 {
 	struct e4000_config *cfg = client->dev.platform_data;
 	struct dvb_frontend *fe = cfg->fe;
-	struct e4000_priv *priv;
+	struct e4000 *s;
 	int ret;
-	u8 chip_id;
+	unsigned int utmp;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0xff,
+	};
 
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
+	s->clock = cfg->clock;
+	s->client = client;
+	s->fe = cfg->fe;
+	s->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(s->regmap)) {
+		ret = PTR_ERR(s->regmap);
+		goto err;
+	}
 
 	/* check if the tuner is there */
-	ret = e4000_rd_reg(priv, 0x02, &chip_id);
-	if (ret < 0)
+	ret = regmap_read(s->regmap, 0x02, &utmp);
+	if (ret)
 		goto err;
 
-	dev_dbg(&priv->client->dev,
-			"%s: chip_id=%02x\n", __func__, chip_id);
+	dev_dbg(&s->client->dev, "%s: chip id=%02x\n", __func__, utmp);
 
-	if (chip_id != 0x40) {
+	if (utmp != 0x40) {
 		ret = -ENODEV;
 		goto err;
 	}
 
 	/* put sleep as chip seems to be in normal mode by default */
-	ret = e4000_wr_reg(priv, 0x00, 0x00);
-	if (ret < 0)
+	ret = regmap_write(s->regmap, 0x00, 0x00);
+	if (ret)
 		goto err;
 
 	/* Register controls */
-	v4l2_ctrl_handler_init(&priv->hdl, 9);
-	priv->bandwidth_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_handler_init(&s->hdl, 9);
+	s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
-	priv->bandwidth = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	s->bandwidth = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_BANDWIDTH, 4300000, 11000000, 100000, 4300000);
-	v4l2_ctrl_auto_cluster(2, &priv->bandwidth_auto, 0, false);
-	priv->lna_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
+	s->lna_gain_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_LNA_GAIN_AUTO, 0, 1, 1, 1);
-	priv->lna_gain = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	s->lna_gain = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_LNA_GAIN, 0, 15, 1, 10);
-	v4l2_ctrl_auto_cluster(2, &priv->lna_gain_auto, 0, false);
-	priv->mixer_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &s->lna_gain_auto, 0, false);
+	s->mixer_gain_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_MIXER_GAIN_AUTO, 0, 1, 1, 1);
-	priv->mixer_gain = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_MIXER_GAIN, 0, 1, 1, 1);
-	v4l2_ctrl_auto_cluster(2, &priv->mixer_gain_auto, 0, false);
-	priv->if_gain_auto = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &s->mixer_gain_auto, 0, false);
+	s->if_gain_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_IF_GAIN_AUTO, 0, 1, 1, 1);
-	priv->if_gain = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	s->if_gain = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_IF_GAIN, 0, 54, 1, 0);
-	v4l2_ctrl_auto_cluster(2, &priv->if_gain_auto, 0, false);
-	priv->pll_lock = v4l2_ctrl_new_std(&priv->hdl, &e4000_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &s->if_gain_auto, 0, false);
+	s->pll_lock = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
 			V4L2_CID_PLL_LOCK,  0, 1, 1, 0);
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
 
-	dev_info(&priv->client->dev,
+	dev_info(&s->client->dev,
 			"%s: Elonics E4000 successfully identified\n",
 			KBUILD_MODNAME);
 
-	fe->tuner_priv = priv;
+	fe->tuner_priv = s;
 	memcpy(&fe->ops.tuner_ops, &e4000_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
-	i2c_set_clientdata(client, priv);
+	i2c_set_clientdata(client, s);
 err:
 	if (ret) {
 		dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
-		kfree(priv);
+		kfree(s);
 	}
 
 	return ret;
@@ -655,15 +573,15 @@ err:
 
 static int e4000_remove(struct i2c_client *client)
 {
-	struct e4000_priv *priv = i2c_get_clientdata(client);
-	struct dvb_frontend *fe = priv->fe;
+	struct e4000 *s = i2c_get_clientdata(client);
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
index d41dbcc..ee36de1 100644
--- a/drivers/media/tuners/e4000_priv.h
+++ b/drivers/media/tuners/e4000_priv.h
@@ -23,9 +23,11 @@
 
 #include "e4000.h"
 #include <media/v4l2-ctrls.h>
+#include <linux/regmap.h>
 
-struct e4000_priv {
+struct e4000 {
 	struct i2c_client *client;
+	struct regmap *regmap;
 	u32 clock;
 	struct dvb_frontend *fe;
 	bool active;
-- 
1.8.5.3

