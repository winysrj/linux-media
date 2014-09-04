Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55613 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbaIDChC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 20/37] it913x: refactor code largely
Date: Thu,  4 Sep 2014 05:36:28 +0300
Message-Id: <1409798205-25645-20-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor code largely in order to satisfy me. Try to keep order of
register read/write same as windows driver does as it makes
comparing sniffs easier.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c | 356 +++++++++++++++++++++++-------------------
 1 file changed, 194 insertions(+), 162 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 924f18d..098e9d5 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -1,5 +1,5 @@
 /*
- * ITE Tech IT9137 silicon tuner driver
+ * ITE IT913X silicon tuner driver
  *
  *  Copyright (C) 2011 Malcolm Priestley (tvboxspy@gmail.com)
  *  IT9137 Copyright (C) ITE Tech Inc.
@@ -29,79 +29,120 @@ struct it913x_dev {
 	struct dvb_frontend *fe;
 	u8 chip_ver:2;
 	u8 role:2;
-	u16 tun_xtal;
-	u8 tun_fdiv;
-	u8 tun_clk_mode;
-	u32 tun_fn_min;
+	u16 xtal;
+	u8 fdiv;
+	u8 clk_mode;
+	u32 fn_min;
+	bool active;
 };
 
 static int it913x_init(struct dvb_frontend *fe)
 {
 	struct it913x_dev *dev = fe->tuner_priv;
 	int ret, i;
-	unsigned int reg;
-	u8 val, nv_val;
-	u8 nv[] = {48, 32, 24, 16, 12, 8, 6, 4, 2};
-	u8 b[2];
+	unsigned int utmp;
+	u8 iqik_m_cal, nv_val, buf[2];
+	static const u8 nv[] = {48, 32, 24, 16, 12, 8, 6, 4, 2};
 
-	ret = regmap_read(dev->regmap, 0x80ec86, &reg);
-	switch (reg) {
+	dev_dbg(&dev->client->dev, "role %u\n", dev->role);
+
+	ret = regmap_write(dev->regmap, 0x80ec4c, 0x68);
+	if (ret)
+		goto err;
+
+	usleep_range(10000, 100000);
+
+	ret = regmap_read(dev->regmap, 0x80ec86, &utmp);
+	if (ret)
+		goto err;
+
+	switch (utmp) {
 	case 0:
-		dev->tun_clk_mode = reg;
-		dev->tun_xtal = 2000;
-		dev->tun_fdiv = 3;
-		val = 16;
+		/* 12.000 MHz */
+		dev->clk_mode = utmp;
+		dev->xtal = 2000;
+		dev->fdiv = 3;
+		iqik_m_cal = 16;
 		break;
 	case 1:
-	default: /* I/O error too */
-		dev->tun_clk_mode = reg;
-		dev->tun_xtal = 640;
-		dev->tun_fdiv = 1;
-		val = 6;
+		/* 20.480 MHz */
+		dev->clk_mode = utmp;
+		dev->xtal = 640;
+		dev->fdiv = 1;
+		iqik_m_cal = 6;
 		break;
+	default:
+		dev_err(&dev->client->dev, "unknown clock identifier %d\n", utmp);
+		goto err;
 	}
 
-	ret = regmap_read(dev->regmap, 0x80ed03,  &reg);
+	ret = regmap_read(dev->regmap, 0x80ed03,  &utmp);
+	if (ret)
+		goto err;
 
-	if (reg < 0)
-		return -ENODEV;
-	else if (reg < ARRAY_SIZE(nv))
-		nv_val = nv[reg];
+	else if (utmp < ARRAY_SIZE(nv))
+		nv_val = nv[utmp];
 	else
 		nv_val = 2;
 
 	for (i = 0; i < 50; i++) {
-		ret = regmap_bulk_read(dev->regmap, 0x80ed23, &b[0], sizeof(b));
-		reg = (b[1] << 8) + b[0];
-		if (reg > 0)
-			break;
+		ret = regmap_bulk_read(dev->regmap, 0x80ed23, buf, 2);
 		if (ret)
-			return -ENODEV;
+			goto err;
+
+		utmp = (buf[1] << 8) | (buf[0] << 0);
+		if (utmp)
+			break;
+
 		udelay(2000);
 	}
-	dev->tun_fn_min = dev->tun_xtal * reg;
-	dev->tun_fn_min /= (dev->tun_fdiv * nv_val);
-	dev_dbg(&dev->client->dev, "Tuner fn_min %d\n", dev->tun_fn_min);
 
-	if (dev->chip_ver > 1)
-		msleep(50);
-	else {
+	dev_dbg(&dev->client->dev, "loop count %d, utmp %d\n", i, utmp);
+
+	dev->fn_min = dev->xtal * utmp;
+	dev->fn_min /= (dev->fdiv * nv_val);
+	dev->fn_min *= 1000;
+	dev_dbg(&dev->client->dev, "fn_min %u\n", dev->fn_min);
+
+	if (dev->chip_ver == 1) {
 		for (i = 0; i < 50; i++) {
-			ret = regmap_read(dev->regmap, 0x80ec82, &reg);
-			if (ret < 0)
-				return -ENODEV;
-			if (reg > 0)
+			ret = regmap_read(dev->regmap, 0x80ec82, &utmp);
+			if (ret)
+				goto err;
+
+			if (utmp)
 				break;
+
 			udelay(2000);
 		}
+
+		dev_dbg(&dev->client->dev, "loop count %d\n", i);
+	} else {
+		msleep(50);
 	}
 
-	/* Power Up Tuner - common all versions */
-	ret = regmap_write(dev->regmap, 0x80ec40, 0x1);
-	ret |= regmap_write(dev->regmap, 0x80ec57, 0x0);
-	ret |= regmap_write(dev->regmap, 0x80ec58, 0x0);
+	ret = regmap_write(dev->regmap, 0x80ed81, iqik_m_cal);
+	if (ret)
+		goto err;
+
+	ret = regmap_write(dev->regmap, 0x80ec57, 0x00);
+	if (ret)
+		goto err;
+
+	ret = regmap_write(dev->regmap, 0x80ec58, 0x00);
+	if (ret)
+		goto err;
+
+	ret = regmap_write(dev->regmap, 0x80ec40, 0x01);
+	if (ret)
+		goto err;
+
+	dev->active = true;
 
-	return regmap_write(dev->regmap, 0x80ed81, val);
+	return 0;
+err:
+	dev_dbg(&dev->client->dev, "failed %d\n", ret);
+	return ret;
 }
 
 static int it913x_sleep(struct dvb_frontend *fe)
@@ -109,7 +150,9 @@ static int it913x_sleep(struct dvb_frontend *fe)
 	struct it913x_dev *dev = fe->tuner_priv;
 	int ret, len;
 
-	dev_dbg(&dev->client->dev, "role=%u\n", dev->role);
+	dev_dbg(&dev->client->dev, "role %u\n", dev->role);
+
+	dev->active = false;
 
 	ret  = regmap_bulk_write(dev->regmap, 0x80ec40, "\x00", 1);
 	if (ret)
@@ -124,7 +167,7 @@ static int it913x_sleep(struct dvb_frontend *fe)
 	else
 		len = 15;
 
-	dev_dbg(&dev->client->dev, "role=%u len=%d\n", dev->role, len);
+	dev_dbg(&dev->client->dev, "role %u, len %d\n", dev->role, len);
 
 	ret = regmap_bulk_write(dev->regmap, 0x80ec02,
 			"\x3f\x1f\x3f\x3e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00",
@@ -160,164 +203,159 @@ err:
 	return ret;
 }
 
-static int it9137_set_params(struct dvb_frontend *fe)
+static int it913x_set_params(struct dvb_frontend *fe)
 {
 	struct it913x_dev *dev = fe->tuner_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	u32 bandwidth = p->bandwidth_hz;
-	u32 frequency_m = p->frequency;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
-	unsigned int reg;
-	u32 frequency = frequency_m / 1000;
-	u32 freq, temp_f, tmp;
-	u16 iqik_m_cal;
-	u16 n_div;
-	u8 n;
-	u8 l_band;
-	u8 lna_band;
-	u8 bw;
-
-	dev_dbg(&dev->client->dev, "Tuner Frequency %d Bandwidth %d\n",
-			frequency, bandwidth);
-
-	if (frequency >= 51000 && frequency <= 440000) {
-		l_band = 0;
-		lna_band = 0;
-	} else if (frequency > 440000 && frequency <= 484000) {
-		l_band = 1;
-		lna_band = 1;
-	} else if (frequency > 484000 && frequency <= 533000) {
-		l_band = 1;
-		lna_band = 2;
-	} else if (frequency > 533000 && frequency <= 587000) {
-		l_band = 1;
-		lna_band = 3;
-	} else if (frequency > 587000 && frequency <= 645000) {
-		l_band = 1;
-		lna_band = 4;
-	} else if (frequency > 645000 && frequency <= 710000) {
-		l_band = 1;
-		lna_band = 5;
-	} else if (frequency > 710000 && frequency <= 782000) {
-		l_band = 1;
-		lna_band = 6;
-	} else if (frequency > 782000 && frequency <= 860000) {
-		l_band = 1;
-		lna_band = 7;
-	} else if (frequency > 1450000 && frequency <= 1492000) {
-		l_band = 1;
-		lna_band = 0;
-	} else if (frequency > 1660000 && frequency <= 1685000) {
-		l_band = 1;
-		lna_band = 1;
-	} else
-		return -EINVAL;
+	unsigned int utmp;
+	u32 pre_lo_freq, t_cal_freq;
+	u16 iqik_m_cal, n_div;
+	u8 u8tmp, n, l_band, lna_band;
 
-	ret = regmap_write(dev->regmap, 0x80ee06, lna_band);
-	if (ret)
-		goto err;
-
-	switch (bandwidth) {
-	case 5000000:
-		bw = 0;
-		break;
-	case 6000000:
-		bw = 2;
-		break;
-	case 7000000:
-		bw = 4;
-		break;
-	default:
-	case 8000000:
-		bw = 6;
-		break;
-	}
-
-	ret = regmap_write(dev->regmap, 0x80ec56, bw);
-	if (ret)
-		goto err;
+	dev_dbg(&dev->client->dev, "role=%u, frequency %u, bandwidth_hz %u\n",
+			dev->role, c->frequency, c->bandwidth_hz);
 
-	ret = regmap_write(dev->regmap, 0x80ec4c, 0xa0 | (l_band << 3));
-	if (ret)
+	if (!dev->active) {
+		ret = -EINVAL;
 		goto err;
+	}
 
-	if (frequency > 53000 && frequency <= 74000) {
+	if (c->frequency <=         74000000) {
 		n_div = 48;
 		n = 0;
-	} else if (frequency > 74000 && frequency <= 111000) {
+	} else if (c->frequency <= 111000000) {
 		n_div = 32;
 		n = 1;
-	} else if (frequency > 111000 && frequency <= 148000) {
+	} else if (c->frequency <= 148000000) {
 		n_div = 24;
 		n = 2;
-	} else if (frequency > 148000 && frequency <= 222000) {
+	} else if (c->frequency <= 222000000) {
 		n_div = 16;
 		n = 3;
-	} else if (frequency > 222000 && frequency <= 296000) {
+	} else if (c->frequency <= 296000000) {
 		n_div = 12;
 		n = 4;
-	} else if (frequency > 296000 && frequency <= 445000) {
+	} else if (c->frequency <= 445000000) {
 		n_div = 8;
 		n = 5;
-	} else if (frequency > 445000 && frequency <= dev->tun_fn_min) {
+	} else if (c->frequency <= dev->fn_min) {
 		n_div = 6;
 		n = 6;
-	} else if (frequency > dev->tun_fn_min && frequency <= 950000) {
+	} else if (c->frequency <= 950000000) {
 		n_div = 4;
 		n = 7;
-	} else if (frequency > 1450000 && frequency <= 1680000) {
+	} else {
 		n_div = 2;
 		n = 0;
-	} else
-		return -EINVAL;
+	}
+
+	ret = regmap_read(dev->regmap, 0x80ed81, &utmp);
+	if (ret)
+		goto err;
 
-	ret = regmap_read(dev->regmap, 0x80ed81, &reg);
-	iqik_m_cal = (u16)reg * n_div;
+	iqik_m_cal = utmp * n_div;
 
-	if (reg < 0x20) {
-		if (dev->tun_clk_mode == 0)
+	if (utmp < 0x20) {
+		if (dev->clk_mode == 0)
 			iqik_m_cal = (iqik_m_cal * 9) >> 5;
 		else
 			iqik_m_cal >>= 1;
 	} else {
 		iqik_m_cal = 0x40 - iqik_m_cal;
-		if (dev->tun_clk_mode == 0)
+		if (dev->clk_mode == 0)
 			iqik_m_cal = ~((iqik_m_cal * 9) >> 5);
 		else
 			iqik_m_cal = ~(iqik_m_cal >> 1);
 	}
 
-	temp_f = frequency * (u32)n_div * (u32)dev->tun_fdiv;
-	freq = temp_f / dev->tun_xtal;
-	tmp = freq * dev->tun_xtal;
+	t_cal_freq = (c->frequency / 1000) * n_div * dev->fdiv;
+	pre_lo_freq = t_cal_freq / dev->xtal;
+	utmp = pre_lo_freq * dev->xtal;
 
-	if ((temp_f - tmp) >= (dev->tun_xtal >> 1))
-		freq++;
+	if ((t_cal_freq - utmp) >= (dev->xtal >> 1))
+		pre_lo_freq++;
 
-	freq += (u32) n << 13;
+	pre_lo_freq += (u32) n << 13;
 	/* Frequency OMEGA_IQIK_M_CAL_MID*/
-	temp_f = freq + (u32)iqik_m_cal;
+	t_cal_freq = pre_lo_freq + (u32)iqik_m_cal;
+	dev_dbg(&dev->client->dev, "t_cal_freq %u, pre_lo_freq %u\n",
+			t_cal_freq, pre_lo_freq);
 
-	ret = regmap_write(dev->regmap, 0x80ec4d, temp_f & 0xff);
+	if (c->frequency <=         440000000) {
+		l_band = 0;
+		lna_band = 0;
+	} else if (c->frequency <=  484000000) {
+		l_band = 1;
+		lna_band = 1;
+	} else if (c->frequency <=  533000000) {
+		l_band = 1;
+		lna_band = 2;
+	} else if (c->frequency <=  587000000) {
+		l_band = 1;
+		lna_band = 3;
+	} else if (c->frequency <=  645000000) {
+		l_band = 1;
+		lna_band = 4;
+	} else if (c->frequency <=  710000000) {
+		l_band = 1;
+		lna_band = 5;
+	} else if (c->frequency <=  782000000) {
+		l_band = 1;
+		lna_band = 6;
+	} else if (c->frequency <=  860000000) {
+		l_band = 1;
+		lna_band = 7;
+	} else if (c->frequency <= 1492000000) {
+		l_band = 1;
+		lna_band = 0;
+	} else if (c->frequency <= 1685000000) {
+		l_band = 1;
+		lna_band = 1;
+	} else {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* XXX: latest windows driver does not set that at all */
+	ret = regmap_write(dev->regmap, 0x80ee06, lna_band);
 	if (ret)
 		goto err;
 
-	ret = regmap_write(dev->regmap, 0x80ec4e, (temp_f >> 8) & 0xff);
+	if (c->bandwidth_hz <=      5000000)
+		u8tmp = 0;
+	else if (c->bandwidth_hz <= 6000000)
+		u8tmp = 2;
+	else if (c->bandwidth_hz <= 7000000)
+		u8tmp = 4;
+	else
+		u8tmp = 6;       /* 8000000 */
+
+	ret = regmap_write(dev->regmap, 0x80ec56, u8tmp);
+	if (ret)
+		goto err;
+
+	/* XXX: latest windows driver sets different value (a8 != 68) */
+	ret = regmap_write(dev->regmap, 0x80ec4c, 0xa0 | (l_band << 3));
 	if (ret)
 		goto err;
 
-	dev_dbg(&dev->client->dev, "High Frequency = %04x\n", temp_f);
+	ret = regmap_write(dev->regmap, 0x80ec4d, (t_cal_freq >> 0) & 0xff);
+	if (ret)
+		goto err;
 
-	/* Lower frequency */
-	ret = regmap_write(dev->regmap, 0x80011e, freq & 0xff);
+	ret = regmap_write(dev->regmap, 0x80ec4e, (t_cal_freq >> 8) & 0xff);
 	if (ret)
 		goto err;
 
-	ret = regmap_write(dev->regmap, 0x80011f, (freq >> 8) & 0xff);
+	ret = regmap_write(dev->regmap, 0x80011e, (pre_lo_freq >> 0) & 0xff);
+	if (ret)
+		goto err;
+
+	ret = regmap_write(dev->regmap, 0x80011f, (pre_lo_freq >> 8) & 0xff);
 	if (ret)
 		goto err;
 
-	dev_dbg(&dev->client->dev, "low Frequency = %04x\n", freq);
 	return 0;
 err:
 	dev_dbg(&dev->client->dev, "failed %d\n", ret);
@@ -326,14 +364,14 @@ err:
 
 static const struct dvb_tuner_ops it913x_tuner_ops = {
 	.info = {
-		.name           = "ITE Tech IT913X",
+		.name           = "ITE IT913X",
 		.frequency_min  = 174000000,
 		.frequency_max  = 862000000,
 	},
 
 	.init = it913x_init,
 	.sleep = it913x_sleep,
-	.set_params = it9137_set_params,
+	.set_params = it913x_set_params,
 };
 
 static int it913x_probe(struct i2c_client *client,
@@ -366,11 +404,6 @@ static int it913x_probe(struct i2c_client *client,
 		goto err_kfree;
 	}
 
-	/* tuner RF initial */
-	ret = regmap_write(dev->regmap, 0x80ec4c, 0x68);
-	if (ret)
-		goto err_regmap_exit;
-
 	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
@@ -385,11 +418,10 @@ static int it913x_probe(struct i2c_client *client,
 
 	dev_info(&dev->client->dev, "ITE IT913X %s successfully attached\n",
 			chip_ver_str);
-	dev_dbg(&dev->client->dev, "chip_ver=%u role=%u\n", dev->chip_ver, dev->role);
+	dev_dbg(&dev->client->dev, "chip_ver %u, role %u\n",
+			dev->chip_ver, dev->role);
 	return 0;
 
-err_regmap_exit:
-	regmap_exit(dev->regmap);
 err_kfree:
 	kfree(dev);
 err:
@@ -430,6 +462,6 @@ static struct i2c_driver it913x_driver = {
 
 module_i2c_driver(it913x_driver);
 
-MODULE_DESCRIPTION("ITE Tech IT913X silicon tuner driver");
+MODULE_DESCRIPTION("ITE IT913X silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_LICENSE("GPL");
-- 
http://palosaari.fi/

