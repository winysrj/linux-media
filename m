Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:42227 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbbALXXe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 18:23:34 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] mn88473: calculate the IF register values
Date: Tue, 13 Jan 2015 00:23:25 +0100
Message-Id: <1421105006-22437-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add xtal as a configuration parameter so it can be used
in the IF register value calculation. If not set in the
configuration then use a default value.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/dvb-frontends/mn88473.h        |  6 ++++++
 drivers/staging/media/mn88473/mn88473.c      | 26 +++++++++++---------------
 drivers/staging/media/mn88473/mn88473_priv.h |  1 +
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88473.h b/drivers/media/dvb-frontends/mn88473.h
index a373ec9..c717ebed 100644
--- a/drivers/media/dvb-frontends/mn88473.h
+++ b/drivers/media/dvb-frontends/mn88473.h
@@ -33,6 +33,12 @@ struct mn88473_config {
 	 * DVB frontend.
 	 */
 	struct dvb_frontend **fe;
+
+	/*
+	 * Xtal frequency.
+	 * Hz
+	 */
+	u32 xtal;
 };
 
 #endif
diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
index 1659335..b65e519 100644
--- a/drivers/staging/media/mn88473/mn88473.c
+++ b/drivers/staging/media/mn88473/mn88473.c
@@ -30,6 +30,7 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u32 if_frequency;
+	u64 tmp;
 	u8 delivery_system_val, if_val[3], bw_val[7];
 
 	dev_dbg(&client->dev,
@@ -63,15 +64,12 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	case SYS_DVBT2:
 		if (c->bandwidth_hz <= 6000000) {
 			/* IF 3570000 Hz, BW 6000000 Hz */
-			memcpy(if_val, "\x24\x8e\x8a", 3);
 			memcpy(bw_val, "\xe9\x55\x55\x1c\x29\x1c\x29", 7);
 		} else if (c->bandwidth_hz <= 7000000) {
 			/* IF 4570000 Hz, BW 7000000 Hz */
-			memcpy(if_val, "\x2e\xcb\xfb", 3);
 			memcpy(bw_val, "\xc8\x00\x00\x17\x0a\x17\x0a", 7);
 		} else if (c->bandwidth_hz <= 8000000) {
 			/* IF 4570000 Hz, BW 8000000 Hz */
-			memcpy(if_val, "\x2e\xcb\xfb", 3);
 			memcpy(bw_val, "\xaf\x00\x00\x11\xec\x11\xec", 7);
 		} else {
 			ret = -EINVAL;
@@ -80,7 +78,6 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 		break;
 	case SYS_DVBC_ANNEX_A:
 		/* IF 5070000 Hz, BW 8000000 Hz */
-		memcpy(if_val, "\x33\xea\xb3", 3);
 		memcpy(bw_val, "\xaf\x00\x00\x11\xec\x11\xec", 7);
 		break;
 	default:
@@ -105,17 +102,12 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 		if_frequency = 0;
 	}
 
-	switch (if_frequency) {
-	case 3570000:
-	case 4570000:
-	case 5070000:
-		break;
-	default:
-		dev_err(&client->dev, "IF frequency %d not supported\n",
-				if_frequency);
-		ret = -EINVAL;
-		goto err;
-	}
+	/* Calculate IF registers ( (1<<24)*IF / Xtal ) */
+	tmp =  div_u64(if_frequency * (u64)(1<<24) + (dev->xtal / 2),
+				   dev->xtal);
+	if_val[0] = ((tmp >> 16) & 0xff);
+	if_val[1] = ((tmp >>  8) & 0xff);
+	if_val[2] = ((tmp >>  0) & 0xff);
 
 	ret = regmap_write(dev->regmap[2], 0x05, 0x00);
 	ret = regmap_write(dev->regmap[2], 0xfb, 0x13);
@@ -352,6 +344,10 @@ static int mn88473_probe(struct i2c_client *client,
 	}
 
 	dev->i2c_wr_max = config->i2c_wr_max;
+	if (!config->xtal)
+		dev->xtal = 25000000;
+	else
+		dev->xtal = config->xtal;
 	dev->client[0] = client;
 	dev->regmap[0] = regmap_init_i2c(dev->client[0], &regmap_config);
 	if (IS_ERR(dev->regmap[0])) {
diff --git a/drivers/staging/media/mn88473/mn88473_priv.h b/drivers/staging/media/mn88473/mn88473_priv.h
index 78af112..ef6f013 100644
--- a/drivers/staging/media/mn88473/mn88473_priv.h
+++ b/drivers/staging/media/mn88473/mn88473_priv.h
@@ -31,6 +31,7 @@ struct mn88473_dev {
 	u16 i2c_wr_max;
 	fe_delivery_system_t delivery_system;
 	bool warm; /* FW running */
+	u32 xtal;
 };
 
 #endif
-- 
2.1.0

