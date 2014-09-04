Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55757 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757084AbaIDChE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:04 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 27/37] af9033: remove I2C addr from config
Date: Thu,  4 Sep 2014 05:36:35 +0300
Message-Id: <1409798205-25645-27-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C driver address is passed as a i2c_new_device() parameter when
device is created. Thus no need to keep it in config struct.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.h  |  9 ++++-----
 drivers/media/usb/dvb-usb-v2/af9035.c | 29 ++++++++++++++---------------
 drivers/media/usb/dvb-usb-v2/af9035.h |  1 +
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index 1b968d0..6ad22b6 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -24,13 +24,12 @@
 
 #include <linux/kconfig.h>
 
+/*
+ * I2C address (TODO: are these in 8-bit format?)
+ * 0x38, 0x3a, 0x3c, 0x3e
+ */
 struct af9033_config {
 	/*
-	 * I2C address
-	 */
-	u8 i2c_addr;
-
-	/*
 	 * clock Hz
 	 * 12000000, 22000000, 24000000, 34000000, 32000000, 28000000, 26000000,
 	 * 30000000, 36000000, 20480000, 16384000
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index ec62133..b491707 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -330,15 +330,15 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 		if (msg[0].len > 40 || msg[1].len > 40) {
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
-		} else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
-			   (msg[0].addr == state->af9033_config[1].i2c_addr) ||
+		} else if ((msg[0].addr == state->af9033_i2c_addr[0]) ||
+			   (msg[0].addr == state->af9033_i2c_addr[1]) ||
 			   (state->chip_type == 0x9135)) {
 			/* demod access via firmware interface */
 			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
 
-			if (msg[0].addr == state->af9033_config[1].i2c_addr ||
-			    msg[0].addr == (state->af9033_config[1].i2c_addr >> 1))
+			if (msg[0].addr == state->af9033_i2c_addr[1] ||
+			    msg[0].addr == (state->af9033_i2c_addr[1] >> 1))
 				reg |= 0x100000;
 
 			ret = af9035_rd_regs(d, reg, &msg[1].buf[0],
@@ -362,15 +362,15 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 		if (msg[0].len > 40) {
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
-		} else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
-			   (msg[0].addr == state->af9033_config[1].i2c_addr) ||
+		} else if ((msg[0].addr == state->af9033_i2c_addr[0]) ||
+			   (msg[0].addr == state->af9033_i2c_addr[1]) ||
 			   (state->chip_type == 0x9135)) {
 			/* demod access via firmware interface */
 			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
 
-			if (msg[0].addr == state->af9033_config[1].i2c_addr ||
-			    msg[0].addr == (state->af9033_config[1].i2c_addr >> 1))
+			if (msg[0].addr == state->af9033_i2c_addr[1] ||
+			    msg[0].addr == (state->af9033_i2c_addr[1] >> 1))
 				reg |= 0x100000;
 
 			ret = af9035_wr_regs(d, reg, &msg[0].buf[3],
@@ -736,8 +736,8 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	u16 tmp16, addr;
 
 	/* demod I2C "address" */
-	state->af9033_config[0].i2c_addr = 0x38;
-	state->af9033_config[1].i2c_addr = 0x3a;
+	state->af9033_i2c_addr[0] = 0x38;
+	state->af9033_i2c_addr[1] = 0x3a;
 	state->af9033_config[0].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 	state->af9033_config[1].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 	state->af9033_config[0].ts_mode = AF9033_TS_MODE_USB;
@@ -789,7 +789,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 			goto err;
 
 		if (tmp)
-			state->af9033_config[1].i2c_addr = tmp;
+			state->af9033_i2c_addr[1] = tmp;
 
 		dev_dbg(&d->udev->dev, "%s: 2nd demod I2C addr=%02x\n",
 				__func__, tmp);
@@ -1092,8 +1092,7 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 
 	state->af9033_config[adap->id].fe = &adap->fe[0];
 	state->af9033_config[adap->id].ops = &state->ops;
-	ret = af9035_add_i2c_dev(d, "af9033",
-			state->af9033_config[adap->id].i2c_addr,
+	ret = af9035_add_i2c_dev(d, "af9033", state->af9033_i2c_addr[adap->id],
 			&state->af9033_config[adap->id]);
 	if (ret)
 		goto err;
@@ -1348,7 +1347,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		}
 
 		ret = af9035_add_i2c_dev(d, "it913x",
-				state->af9033_config[adap->id].i2c_addr >> 1,
+				state->af9033_i2c_addr[adap->id] >> 1,
 				&it913x_config);
 		if (ret)
 			goto err;
@@ -1373,7 +1372,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		}
 
 		ret = af9035_add_i2c_dev(d, "it913x",
-				state->af9033_config[adap->id].i2c_addr >> 1,
+				state->af9033_i2c_addr[adap->id] >> 1,
 				&it913x_config);
 		if (ret)
 			goto err;
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 2196077..edb3871 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -61,6 +61,7 @@ struct state {
 	u16 chip_type;
 	u8 dual_mode:1;
 	u16 eeprom_addr;
+	u8 af9033_i2c_addr[2];
 	struct af9033_config af9033_config[2];
 	struct af9033_ops ops;
 	#define AF9035_I2C_CLIENT_MAX 4
-- 
http://palosaari.fi/

