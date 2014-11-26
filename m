Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:35042 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaKZVv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 16:51:59 -0500
Received: from localhost.localdomain (92-244-23-216.customers.ownit.se [92.244.23.216])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 7A69A121855
	for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 22:51:47 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] mn88472: calculate the IF register values
Date: Wed, 26 Nov 2014 22:51:46 +0100
Message-Id: <1417038707-6297-1-git-send-email-benjamin@southpole.se>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add xtal as a configuration parameter so it can be used
in the IF register value calculation.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/dvb-frontends/mn88472.h        |  6 ++++++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c      |  1 +
 drivers/staging/media/mn88472/mn88472.c      | 23 ++++++++---------------
 drivers/staging/media/mn88472/mn88472_priv.h |  1 +
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88472.h b/drivers/media/dvb-frontends/mn88472.h
index da4558b..e4e0b80 100644
--- a/drivers/media/dvb-frontends/mn88472.h
+++ b/drivers/media/dvb-frontends/mn88472.h
@@ -33,6 +33,12 @@ struct mn88472_config {
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
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 896a225..73580f8 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -852,6 +852,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			mn88472_config.fe = &adap->fe[1];
 			mn88472_config.i2c_wr_max = 22,
 			strlcpy(info.type, "mn88472", I2C_NAME_SIZE);
+			mn88472_config.xtal = 20500000;
 			info.addr = 0x18;
 			info.platform_data = &mn88472_config;
 			request_module(info.type);
diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index 52de8f8..f648b58 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -30,6 +30,7 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u32 if_frequency = 0;
+	u64 tmp;
 	u8 delivery_system_val, if_val[3], bw_val[7], bw_val2;
 
 	dev_dbg(&client->dev,
@@ -62,17 +63,14 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 	case SYS_DVBT2:
 		if (c->bandwidth_hz <= 6000000) {
 			/* IF 3570000 Hz, BW 6000000 Hz */
-			memcpy(if_val, "\x2c\x94\xdb", 3);
 			memcpy(bw_val, "\xbf\x55\x55\x15\x6b\x15\x6b", 7);
 			bw_val2 = 0x02;
 		} else if (c->bandwidth_hz <= 7000000) {
 			/* IF 4570000 Hz, BW 7000000 Hz */
-			memcpy(if_val, "\x39\x11\xbc", 3);
 			memcpy(bw_val, "\xa4\x00\x00\x0f\x2c\x0f\x2c", 7);
 			bw_val2 = 0x01;
 		} else if (c->bandwidth_hz <= 8000000) {
 			/* IF 4570000 Hz, BW 8000000 Hz */
-			memcpy(if_val, "\x39\x11\xbc", 3);
 			memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
 			bw_val2 = 0x00;
 		} else {
@@ -82,7 +80,6 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 		break;
 	case SYS_DVBC_ANNEX_A:
 		/* IF 5070000 Hz, BW 8000000 Hz */
-		memcpy(if_val, "\x3f\x50\x2c", 3);
 		memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
 		bw_val2 = 0x00;
 		break;
@@ -106,17 +103,12 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 		dev_dbg(&client->dev, "get_if_frequency=%d\n", if_frequency);
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
 
 	ret = regmap_write(dev->regmap[2], 0xfb, 0x13);
 	ret = regmap_write(dev->regmap[2], 0xef, 0x13);
@@ -411,6 +403,7 @@ static int mn88472_probe(struct i2c_client *client,
 	}
 
 	dev->i2c_wr_max = config->i2c_wr_max;
+	dev->xtal = config->xtal;
 	dev->client[0] = client;
 	dev->regmap[0] = regmap_init_i2c(dev->client[0], &regmap_config);
 	if (IS_ERR(dev->regmap[0])) {
diff --git a/drivers/staging/media/mn88472/mn88472_priv.h b/drivers/staging/media/mn88472/mn88472_priv.h
index 1095949..b12b731 100644
--- a/drivers/staging/media/mn88472/mn88472_priv.h
+++ b/drivers/staging/media/mn88472/mn88472_priv.h
@@ -31,6 +31,7 @@ struct mn88472_dev {
 	u16 i2c_wr_max;
 	fe_delivery_system_t delivery_system;
 	bool warm; /* FW running */
+	u32 xtal;
 };
 
 #endif
-- 
2.1.0

