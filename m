Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36058 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752448AbcKLKey (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 05:34:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/9] af9033: use 64-bit div macro where possible
Date: Sat, 12 Nov 2016 12:33:55 +0200
Message-Id: <1478946841-2807-3-git-send-email-crope@iki.fi>
In-Reply-To: <1478946841-2807-1-git-send-email-crope@iki.fi>
References: <1478946841-2807-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace Booth's binary division algo with 64-bit multiply and division.
Fix related IF calculations.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c      | 103 +++++++++---------------------
 drivers/media/dvb-frontends/af9033_priv.h |   1 +
 2 files changed, 32 insertions(+), 72 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 5b806e8..e9ff0f6 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -79,40 +79,14 @@ static int af9033_wr_reg_val_tab(struct af9033_dev *dev,
 	return ret;
 }
 
-static u32 af9033_div(struct af9033_dev *dev, u32 a, u32 b, u32 x)
-{
-	u32 r = 0, c = 0, i;
-
-	dev_dbg(&dev->client->dev, "a=%d b=%d x=%d\n", a, b, x);
-
-	if (a > b) {
-		c = a / b;
-		a = a - c * b;
-	}
-
-	for (i = 0; i < x; i++) {
-		if (a >= b) {
-			r += 1;
-			a -= b;
-		}
-		a <<= 1;
-		r <<= 1;
-	}
-	r = (c << (u32)x) + r;
-
-	dev_dbg(&dev->client->dev, "a=%d b=%d x=%d r=%d r=%x\n", a, b, x, r, r);
-
-	return r;
-}
-
 static int af9033_init(struct dvb_frontend *fe)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, len;
+	unsigned int utmp;
 	const struct reg_val *init;
 	u8 buf[4];
-	u32 adc_cw, clock_cw;
 	struct reg_val_mask tab[] = {
 		{ 0x80fb24, 0x00, 0x08 },
 		{ 0x80004c, 0x00, 0xff },
@@ -143,19 +117,18 @@ static int af9033_init(struct dvb_frontend *fe)
 	};
 
 	/* program clock control */
-	clock_cw = af9033_div(dev, dev->cfg.clock, 1000000ul, 19ul);
-	buf[0] = (clock_cw >>  0) & 0xff;
-	buf[1] = (clock_cw >>  8) & 0xff;
-	buf[2] = (clock_cw >> 16) & 0xff;
-	buf[3] = (clock_cw >> 24) & 0xff;
-
-	dev_dbg(&dev->client->dev, "clock=%d clock_cw=%08x\n",
-			dev->cfg.clock, clock_cw);
-
+	utmp = div_u64((u64)dev->cfg.clock * 0x80000, 1000000);
+	buf[0] = (utmp >>  0) & 0xff;
+	buf[1] = (utmp >>  8) & 0xff;
+	buf[2] = (utmp >> 16) & 0xff;
+	buf[3] = (utmp >> 24) & 0xff;
 	ret = regmap_bulk_write(dev->regmap, 0x800025, buf, 4);
 	if (ret)
 		goto err;
 
+	dev_dbg(&dev->client->dev, "clk=%u clk_cw=%08x\n",
+		dev->cfg.clock, utmp);
+
 	/* program ADC control */
 	for (i = 0; i < ARRAY_SIZE(clock_adc_lut); i++) {
 		if (clock_adc_lut[i].clock == dev->cfg.clock)
@@ -168,18 +141,17 @@ static int af9033_init(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	adc_cw = af9033_div(dev, clock_adc_lut[i].adc, 1000000ul, 19ul);
-	buf[0] = (adc_cw >>  0) & 0xff;
-	buf[1] = (adc_cw >>  8) & 0xff;
-	buf[2] = (adc_cw >> 16) & 0xff;
-
-	dev_dbg(&dev->client->dev, "adc=%d adc_cw=%06x\n",
-			clock_adc_lut[i].adc, adc_cw);
-
+	utmp = div_u64((u64)clock_adc_lut[i].adc * 0x80000, 1000000);
+	buf[0] = (utmp >>  0) & 0xff;
+	buf[1] = (utmp >>  8) & 0xff;
+	buf[2] = (utmp >> 16) & 0xff;
 	ret = regmap_bulk_write(dev->regmap, 0x80f1cd, buf, 3);
 	if (ret)
 		goto err;
 
+	dev_dbg(&dev->client->dev, "adc=%u adc_cw=%06x\n",
+		clock_adc_lut[i].adc, utmp);
+
 	/* program register table */
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
 		ret = regmap_update_bits(dev->regmap, tab[i].reg, tab[i].mask,
@@ -397,9 +369,10 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i, spec_inv, sampling_freq;
+	int ret, i;
+	unsigned int utmp, adc_freq;
 	u8 tmp, buf[3], bandwidth_reg_val;
-	u32 if_frequency, freq_cw, adc_freq;
+	u32 if_frequency;
 
 	dev_dbg(&dev->client->dev, "frequency=%d bandwidth_hz=%d\n",
 			c->frequency, c->bandwidth_hz);
@@ -449,8 +422,6 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 
 	/* program frequency control */
 	if (c->bandwidth_hz != dev->bandwidth_hz) {
-		spec_inv = dev->cfg.spec_inv ? -1 : 1;
-
 		for (i = 0; i < ARRAY_SIZE(clock_adc_lut); i++) {
 			if (clock_adc_lut[i].clock == dev->cfg.clock)
 				break;
@@ -464,42 +435,30 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		}
 		adc_freq = clock_adc_lut[i].adc;
 
+		if (dev->cfg.adc_multiplier == AF9033_ADC_MULTIPLIER_2X)
+			adc_freq = 2 * adc_freq;
+
 		/* get used IF frequency */
 		if (fe->ops.tuner_ops.get_if_frequency)
 			fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
 		else
 			if_frequency = 0;
 
-		sampling_freq = if_frequency;
+		utmp = DIV_ROUND_CLOSEST_ULL((u64)if_frequency * 0x800000,
+					     adc_freq);
 
-		while (sampling_freq > (adc_freq / 2))
-			sampling_freq -= adc_freq;
-
-		if (sampling_freq >= 0)
-			spec_inv *= -1;
-		else
-			sampling_freq *= -1;
-
-		freq_cw = af9033_div(dev, sampling_freq, adc_freq, 23ul);
-
-		if (spec_inv == -1)
-			freq_cw = 0x800000 - freq_cw;
-
-		if (dev->cfg.adc_multiplier == AF9033_ADC_MULTIPLIER_2X)
-			freq_cw /= 2;
-
-		buf[0] = (freq_cw >>  0) & 0xff;
-		buf[1] = (freq_cw >>  8) & 0xff;
-		buf[2] = (freq_cw >> 16) & 0x7f;
-
-		/* FIXME: there seems to be calculation error here... */
-		if (if_frequency == 0)
-			buf[2] = 0;
+		if (!dev->cfg.spec_inv && if_frequency)
+			utmp = 0x800000 - utmp;
 
+		buf[0] = (utmp >>  0) & 0xff;
+		buf[1] = (utmp >>  8) & 0xff;
+		buf[2] = (utmp >> 16) & 0xff;
 		ret = regmap_bulk_write(dev->regmap, 0x800029, buf, 3);
 		if (ret)
 			goto err;
 
+		dev_dbg(&dev->client->dev, "if_frequency_cw=%06x\n", utmp);
+
 		dev->bandwidth_hz = c->bandwidth_hz;
 	}
 
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index 701c508..28d14dc 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -26,6 +26,7 @@
 #include "af9033.h"
 #include <linux/math64.h>
 #include <linux/regmap.h>
+#include <linux/kernel.h>
 
 struct reg_val {
 	u32 reg;
-- 
http://palosaari.fi/

