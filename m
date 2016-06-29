Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40926 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbcF2XkA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:40:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/5] m88ds3103: use Hz instead of kHz on calculations
Date: Thu, 30 Jun 2016 02:39:47 +0300
Message-Id: <1467243588-26204-4-git-send-email-crope@iki.fi>
In-Reply-To: <1467243588-26204-1-git-send-email-crope@iki.fi>
References: <1467243588-26204-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was some calculations where was kHz used in order to keep
calculation withing 32-bit. Convert all to Hz and use 64-bit
division helpers where needed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c      | 50 ++++++++++++++--------------
 drivers/media/dvb-frontends/m88ds3103_priv.h |  3 +-
 2 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index fae9251..5158bf3 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -307,7 +307,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	u8 u8tmp, u8tmp1 = 0, u8tmp2 = 0; /* silence compiler warning */
 	u8 buf[3];
 	u16 u16tmp;
-	u32 tuner_frequency, target_mclk;
+	u32 tuner_frequency_khz, target_mclk;
 	s32 s32tmp;
 
 	dev_dbg(&client->dev,
@@ -344,7 +344,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	}
 
 	if (fe->ops.tuner_ops.get_frequency) {
-		ret = fe->ops.tuner_ops.get_frequency(fe, &tuner_frequency);
+		ret = fe->ops.tuner_ops.get_frequency(fe, &tuner_frequency_khz);
 		if (ret)
 			goto err;
 	} else {
@@ -353,20 +353,20 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		 * actual frequency used. Carrier offset calculation is not
 		 * valid.
 		 */
-		tuner_frequency = c->frequency;
+		tuner_frequency_khz = c->frequency;
 	}
 
 	/* select M88RS6000 demod main mclk and ts mclk from tuner die. */
 	if (dev->chip_id == M88RS6000_CHIP_ID) {
 		if (c->symbol_rate > 45010000)
-			dev->mclk_khz = 110250;
+			dev->mclk = 110250000;
 		else
-			dev->mclk_khz = 96000;
+			dev->mclk = 96000000;
 
 		if (c->delivery_system == SYS_DVBS)
-			target_mclk = 96000;
+			target_mclk = 96000000;
 		else
-			target_mclk = 144000;
+			target_mclk = 144000000;
 
 		/* Enable demod clock path */
 		ret = regmap_write(dev->regmap, 0x06, 0x00);
@@ -375,7 +375,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		usleep_range(10000, 20000);
 	} else {
 	/* set M88DS3103 mclk and ts mclk. */
-		dev->mclk_khz = 96000;
+		dev->mclk = 96000000;
 
 		switch (dev->cfg->ts_mode) {
 		case M88DS3103_TS_SERIAL:
@@ -385,14 +385,14 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		case M88DS3103_TS_PARALLEL:
 		case M88DS3103_TS_CI:
 			if (c->delivery_system == SYS_DVBS)
-				target_mclk = 96000;
+				target_mclk = 96000000;
 			else {
 				if (c->symbol_rate < 18000000)
-					target_mclk = 96000;
+					target_mclk = 96000000;
 				else if (c->symbol_rate < 28000000)
-					target_mclk = 144000;
+					target_mclk = 144000000;
 				else
-					target_mclk = 192000;
+					target_mclk = 192000000;
 			}
 			break;
 		default:
@@ -402,15 +402,15 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		}
 
 		switch (target_mclk) {
-		case 96000:
+		case 96000000:
 			u8tmp1 = 0x02; /* 0b10 */
 			u8tmp2 = 0x01; /* 0b01 */
 			break;
-		case 144000:
+		case 144000000:
 			u8tmp1 = 0x00; /* 0b00 */
 			u8tmp2 = 0x01; /* 0b01 */
 			break;
-		case 192000:
+		case 192000000:
 			u8tmp1 = 0x03; /* 0b11 */
 			u8tmp2 = 0x00; /* 0b00 */
 			break;
@@ -464,8 +464,8 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	}
 
 	if (dev->chip_id == M88RS6000_CHIP_ID) {
-		if ((c->delivery_system == SYS_DVBS2)
-			&& ((c->symbol_rate / 1000) <= 5000)) {
+		if (c->delivery_system == SYS_DVBS2 &&
+		    c->symbol_rate <= 5000000) {
 			ret = regmap_write(dev->regmap, 0xc0, 0x04);
 			if (ret)
 				goto err;
@@ -532,7 +532,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		u8tmp2 = DIV_ROUND_UP(u16tmp, 2) - 1;
 	}
 
-	dev_dbg(&client->dev, "target_mclk=%d ts_clk=%d ts_clk_divide_ratio=%u\n",
+	dev_dbg(&client->dev, "target_mclk=%u ts_clk=%u ts_clk_divide_ratio=%u\n",
 		target_mclk, dev->cfg->ts_clk, u16tmp);
 
 	/* u8tmp1[5:2] => fe[3:0], u8tmp1[1:0] => ea[7:6] */
@@ -569,7 +569,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	u16tmp = DIV_ROUND_CLOSEST((c->symbol_rate / 1000) << 15, dev->mclk_khz / 2);
+	u16tmp = DIV_ROUND_CLOSEST_ULL((u64)c->symbol_rate * 0x10000, dev->mclk);
 	buf[0] = (u16tmp >> 0) & 0xff;
 	buf[1] = (u16tmp >> 8) & 0xff;
 	ret = regmap_bulk_write(dev->regmap, 0x61, buf, 2);
@@ -589,10 +589,11 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		goto err;
 
 	dev_dbg(&client->dev, "carrier offset=%d\n",
-		(tuner_frequency - c->frequency));
+		(tuner_frequency_khz - c->frequency));
 
-	s32tmp = 0x10000 * (tuner_frequency - c->frequency);
-	s32tmp = DIV_ROUND_CLOSEST(s32tmp, dev->mclk_khz);
+	/* Use 32-bit calc as there is no s64 version of DIV_ROUND_CLOSEST() */
+	s32tmp = 0x10000 * (tuner_frequency_khz - c->frequency);
+	s32tmp = DIV_ROUND_CLOSEST(s32tmp, dev->mclk / 1000);
 	buf[0] = (s32tmp >> 0) & 0xff;
 	buf[1] = (s32tmp >> 8) & 0xff;
 	ret = regmap_bulk_write(dev->regmap, 0x5e, buf, 2);
@@ -937,8 +938,7 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe,
 	if (ret)
 		goto err;
 
-	c->symbol_rate = 1ull * ((buf[1] << 8) | (buf[0] << 0)) *
-			dev->mclk_khz * 1000 / 0x10000;
+	c->symbol_rate = DIV_ROUND_CLOSEST_ULL((u64)(buf[1] << 8 | buf[0] << 0) * dev->mclk, 0x10000);
 
 	return 0;
 err:
@@ -1381,7 +1381,7 @@ static int m88ds3103_probe(struct i2c_client *client,
 	dev->config.clock = pdata->clk;
 	dev->config.i2c_wr_max = pdata->i2c_wr_max;
 	dev->config.ts_mode = pdata->ts_mode;
-	dev->config.ts_clk = pdata->ts_clk;
+	dev->config.ts_clk = pdata->ts_clk * 1000;
 	dev->config.ts_clk_pol = pdata->ts_clk_pol;
 	dev->config.spec_inv = pdata->spec_inv;
 	dev->config.agc_inv = pdata->agc_inv;
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index d78e467..07f20c2 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -27,7 +27,6 @@
 
 #define M88DS3103_FIRMWARE "dvb-demod-m88ds3103.fw"
 #define M88RS6000_FIRMWARE "dvb-demod-m88rs6000.fw"
-#define M88DS3103_MCLK_KHZ 96000
 #define M88RS6000_CHIP_ID 0x74
 #define M88DS3103_CHIP_ID 0x70
 
@@ -46,7 +45,7 @@ struct m88ds3103_dev {
 	/* auto detect chip id to do different config */
 	u8 chip_id;
 	/* main mclk is calculated for M88RS6000 dynamically */
-	s32 mclk_khz;
+	s32 mclk;
 	u64 post_bit_error;
 	u64 post_bit_count;
 };
-- 
http://palosaari.fi/

