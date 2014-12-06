Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:38563 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaLFAZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 19:25:43 -0500
Received: from localhost.localdomain (92-244-23-216.customers.ownit.se [92.244.23.216])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 339EF61BB2
	for <linux-media@vger.kernel.org>; Sat,  6 Dec 2014 01:25:34 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] mn88472: add ts mode and ts clock to driver
Date: Sat,  6 Dec 2014 01:25:33 +0100
Message-Id: <1417825533-13081-3-git-send-email-benjamin@southpole.se>
In-Reply-To: <1417825533-13081-1-git-send-email-benjamin@southpole.se>
References: <1417825533-13081-1-git-send-email-benjamin@southpole.se>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/dvb-frontends/mn88472.h        | 12 +++++++++++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c      |  2 ++
 drivers/staging/media/mn88472/mn88472.c      | 30 ++++++++++++++++++++++++++--
 drivers/staging/media/mn88472/mn88472_priv.h |  2 ++
 4 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88472.h b/drivers/media/dvb-frontends/mn88472.h
index e4e0b80..095294d 100644
--- a/drivers/media/dvb-frontends/mn88472.h
+++ b/drivers/media/dvb-frontends/mn88472.h
@@ -19,6 +19,16 @@
 
 #include <linux/dvb/frontend.h>
 
+enum ts_clock {
+	VARIABLE_TS_CLOCK,
+	FIXED_TS_CLOCK,
+};
+
+enum ts_mode {
+	SERIAL_TS_MODE,
+	PARALLEL_TS_MODE,
+};
+
 struct mn88472_config {
 	/*
 	 * Max num of bytes given I2C adapter could write at once.
@@ -39,6 +49,8 @@ struct mn88472_config {
 	 * Hz
 	 */
 	u32 xtal;
+	int ts_mode;
+	int ts_clock;
 };
 
 #endif
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 9ec4223..663583b 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -869,6 +869,8 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			mn88472_config.i2c_wr_max = 22,
 			strlcpy(info.type, "mn88472", I2C_NAME_SIZE);
 			mn88472_config.xtal = 20500000;
+			mn88472_config.ts_mode = SERIAL_TS_MODE;
+			mn88472_config.ts_clock = VARIABLE_TS_CLOCK;
 			info.addr = 0x18;
 			info.platform_data = &mn88472_config;
 			request_module(info.type);
diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index a9d5f0a..c6895ee 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -188,8 +188,32 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 
 	ret = regmap_write(dev->regmap[0], 0x46, 0x00);
 	ret = regmap_write(dev->regmap[0], 0xae, 0x00);
-	ret = regmap_write(dev->regmap[2], 0x08, 0x1d);
-	ret = regmap_write(dev->regmap[0], 0xd9, 0xe3);
+
+	switch (dev->ts_mode) {
+	case SERIAL_TS_MODE:
+		ret = regmap_write(dev->regmap[2], 0x08, 0x1d);
+		break;
+	case PARALLEL_TS_MODE:
+		ret = regmap_write(dev->regmap[2], 0x08, 0x00);
+		break;
+	default:
+		dev_dbg(&client->dev, "ts_mode error: %d\n", dev->ts_mode);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	switch (dev->ts_clock) {
+	case VARIABLE_TS_CLOCK:
+		ret = regmap_write(dev->regmap[0], 0xd9, 0xe3);
+		break;
+	case FIXED_TS_CLOCK:
+		ret = regmap_write(dev->regmap[0], 0xd9, 0xe1);
+		break;
+	default:
+		dev_dbg(&client->dev, "ts_clock error: %d\n", dev->ts_clock);
+		ret = -EINVAL;
+		goto err;
+	}
 
 	/* Reset demod */
 	ret = regmap_write(dev->regmap[2], 0xf8, 0x9f);
@@ -406,6 +430,8 @@ static int mn88472_probe(struct i2c_client *client,
 
 	dev->i2c_wr_max = config->i2c_wr_max;
 	dev->xtal = config->xtal;
+	dev->ts_mode = config->ts_mode;
+	dev->ts_clock = config->ts_clock;
 	dev->client[0] = client;
 	dev->regmap[0] = regmap_init_i2c(dev->client[0], &regmap_config);
 	if (IS_ERR(dev->regmap[0])) {
diff --git a/drivers/staging/media/mn88472/mn88472_priv.h b/drivers/staging/media/mn88472/mn88472_priv.h
index b12b731..9ba8c8b 100644
--- a/drivers/staging/media/mn88472/mn88472_priv.h
+++ b/drivers/staging/media/mn88472/mn88472_priv.h
@@ -32,6 +32,8 @@ struct mn88472_dev {
 	fe_delivery_system_t delivery_system;
 	bool warm; /* FW running */
 	u32 xtal;
+	int ts_mode;
+	int ts_clock;
 };
 
 #endif
-- 
1.9.1

