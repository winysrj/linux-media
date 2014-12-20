Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:54748 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaLTX5o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 18:57:44 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC][PATCH] mn88472: add support for the mn88473 demod
Date: Sun, 21 Dec 2014 00:57:33 +0100
Message-Id: <1419119853-29452-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Factor out the bw_val data to a table and load data from it
depending on the configured demod.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/dvb-frontends/mn88472.h        | 30 +++++++++++++
 drivers/staging/media/mn88472/mn88472.c      | 66 ++++++++++++++--------------
 drivers/staging/media/mn88472/mn88472_priv.h |  1 +
 3 files changed, 64 insertions(+), 33 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88472.h b/drivers/media/dvb-frontends/mn88472.h
index f0fdc7e..0016f7b 100644
--- a/drivers/media/dvb-frontends/mn88472.h
+++ b/drivers/media/dvb-frontends/mn88472.h
@@ -29,6 +29,35 @@ enum ts_mode {
 	PARALLEL_TS_MODE,
 };
 
+enum model {
+	MODEL_MN88472,
+	MODEL_MN88473,
+	MODEL_MAX,
+};
+
+enum bw_modes {
+	BW_5MHZ,
+	BW_6MHZ,
+	BW_7MHZ,
+	BW_8MHZ,
+	BW_MODE_MAX,
+};
+
+/* close to y=freq*4.5714285 */
+static u32 ad_frequency_factor[BW_MODE_MAX] = {
+	0x15CC5B6,	/* 5MHz */
+	0x1A286DC,	/* 6MHz */
+	0x1E84800,	/* 7MHz */
+	0x22E0925,	/* 8MHz */
+};
+
+static u8 bw_param[MODEL_MAX][BW_MODE_MAX][2] = {
+	{ { 0x1b, 0xa9 }, { 0x00, 0x00 } },	/* 5MHz */
+	{ { 0x15, 0x6b }, { 0x1c, 0x29 } },	/* 6MHz */
+	{ { 0x0f, 0x2c }, { 0x17, 0x0a } },	/* 7MHz */
+	{ { 0x08, 0xee }, { 0x11, 0xec } },	/* 8MHz */
+};
+
 struct mn88472_config {
 	/*
 	 * Max num of bytes given I2C adapter could write at once.
@@ -53,6 +82,7 @@ struct mn88472_config {
 	u32 xtal;
 	int ts_mode;
 	int ts_clock;
+	int model;
 };
 
 #endif
diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index 8b35639..77ed941 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -28,10 +28,10 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88472_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i;
+	int ret, i, bw;
 	u64 tmp;
-	u8 delivery_system_val, if_val[3], bw_val[7], bw_val2;
+	u8 delivery_system_val, if_val[3], ad_val[3], bw_val2;
 
 	dev_dbg(&client->dev, "%s:\n", __func__);
 	dev_dbg(&client->dev,
@@ -59,35 +59,20 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	switch (c->delivery_system) {
-	case SYS_DVBT:
-	case SYS_DVBT2:
-		if (c->bandwidth_hz <= 5000000) {
-			memcpy(bw_val, "\xe5\x99\x9a\x1b\xa9\x1b\xa9", 7);
-			bw_val2 = 0x03;
-		} else if (c->bandwidth_hz <= 6000000) {
-			/* IF 3570000 Hz, BW 6000000 Hz */
-			memcpy(bw_val, "\xbf\x55\x55\x15\x6b\x15\x6b", 7);
-			bw_val2 = 0x02;
-		} else if (c->bandwidth_hz <= 7000000) {
-			/* IF 4570000 Hz, BW 7000000 Hz */
-			memcpy(bw_val, "\xa4\x00\x00\x0f\x2c\x0f\x2c", 7);
-			bw_val2 = 0x01;
-		} else if (c->bandwidth_hz <= 8000000) {
-			/* IF 4570000 Hz, BW 8000000 Hz */
-			memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
-			bw_val2 = 0x00;
-		} else {
-			ret = -EINVAL;
-			goto err;
-		}
-		break;
-	case SYS_DVBC_ANNEX_A:
-		/* IF 5070000 Hz, BW 8000000 Hz */
-		memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
+	/* bw related parameters */
+	if (c->bandwidth_hz <= 5000000) {
+		bw = BW_5MHZ;
+		bw_val2 = 0x03;
+	} else if (c->bandwidth_hz <= 6000000) {
+		bw = BW_6MHZ;
+		bw_val2 = 0x02;
+	} else if (c->bandwidth_hz <= 7000000) {
+		bw = BW_7MHZ;
+		bw_val2 = 0x01;
+	} else if (c->bandwidth_hz <= 8000000) {
+		bw = BW_8MHZ;
 		bw_val2 = 0x00;
-		break;
-	default:
+	} else {
 		ret = -EINVAL;
 		goto err;
 	}
@@ -114,6 +99,14 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 	if_val[1] = ((tmp >>  8) & 0xff);
 	if_val[2] = ((tmp >>  0) & 0xff);
 
+	/* Calculate A/D frequency registers (Xtal * ad_freq_fac) */
+	tmp =  div_u64(dev->xtal * (u64)(1<<24) +
+		     ((dev->xtal * (u64)(1<<24))/ 2),
+		       ad_frequency_factor[bw] );
+	ad_val[0] = ((tmp >> 16) & 0xff);
+	ad_val[1] = ((tmp >>  8) & 0xff);
+	ad_val[2] = ((tmp >>  0) & 0xff);
+
 	ret = regmap_write(dev->regmap[2], 0xfb, 0x13);
 	ret = regmap_write(dev->regmap[2], 0xef, 0x13);
 	ret = regmap_write(dev->regmap[2], 0xf9, 0x13);
@@ -142,12 +135,19 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	for (i = 0; i < sizeof(bw_val); i++) {
-		ret = regmap_write(dev->regmap[2], 0x13 + i, bw_val[i]);
+	for (i = 0; i < sizeof(ad_val); i++) {
+		ret = regmap_write(dev->regmap[2], 0x13 + i, ad_val[i]);
 		if (ret)
 			goto err;
 	}
 
+	ret = regmap_write(dev->regmap[2], 0x16, bw_param[dev->model][bw][0]);
+	ret = regmap_write(dev->regmap[2], 0x17, bw_param[dev->model][bw][1]);
+	ret = regmap_write(dev->regmap[2], 0x18, bw_param[dev->model][bw][0]);
+	ret = regmap_write(dev->regmap[2], 0x19, bw_param[dev->model][bw][1]);
+	if (ret)
+		goto err;
+
 	switch (c->delivery_system) {
 	case SYS_DVBT:
 		ret = regmap_write(dev->regmap[0], 0x07, 0x26);
diff --git a/drivers/staging/media/mn88472/mn88472_priv.h b/drivers/staging/media/mn88472/mn88472_priv.h
index 9ba8c8b..c5d40c2 100644
--- a/drivers/staging/media/mn88472/mn88472_priv.h
+++ b/drivers/staging/media/mn88472/mn88472_priv.h
@@ -34,6 +34,7 @@ struct mn88472_dev {
 	u32 xtal;
 	int ts_mode;
 	int ts_clock;
+	int model;
 };
 
 #endif
-- 
1.9.1

