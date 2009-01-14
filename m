Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:50136 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbZANPjy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 10:39:54 -0500
Message-ID: <496E0751.1020008@scram.de>
Date: Wed, 14 Jan 2009 16:40:01 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] Add MC44S803 support to AF9015 driver.
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/media/dvb/dvb-usb/Kconfig  |    1 +
 drivers/media/dvb/dvb-usb/af9015.c |   40 ++++++++++++++++++++++++-----------
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 49f7b20..bbddc9f 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -297,5 +297,6 @@ config DVB_USB_AF9015
 	select MEDIA_TUNER_QT1010   if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMIZE
+	select MEDIA_TUNER_MC44S803 if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the Afatech AF9015 based DVB-T USB2.0 receiver
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index e1e9aa5..099ef0a 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -27,9 +27,7 @@
 #include "qt1010.h"
 #include "tda18271.h"
 #include "mxl5005s.h"
-#if 0
-#include "mc44s80x.h"
-#endif
+#include "mc44s803.h"
 
 static int dvb_usb_af9015_debug;
 module_param_named(debug, dvb_usb_af9015_debug, int, 0644);
@@ -283,6 +281,21 @@ Due to that the only way to select correct tuner is use demodulator I2C-gate.
 			req.data = &msg[i+1].buf[0];
 			ret = af9015_ctrl_msg(d, &req);
 			i += 2;
+		} else if (msg[i].flags & I2C_M_RD) {
+			ret = -EINVAL;
+			if (msg[i].addr ==
+				af9015_af9013_config[0].demod_address)
+				goto error;
+			else
+				req.cmd = READ_I2C;
+			req.i2c_addr = msg[i].addr;
+			req.addr = 0;
+			req.mbox = 0;
+			req.addr_len = 0;
+			req.data_len = msg[i].len;
+			req.data = &msg[i].buf[0];
+			ret = af9015_ctrl_msg(d, &req);
+			i += 1;
 		} else {
 			if (msg[i].addr ==
 				af9015_af9013_config[0].demod_address)
@@ -929,7 +942,6 @@ static int af9015_read_config(struct usb_device *udev)
 		switch (val) {
 		case AF9013_TUNER_ENV77H11D5:
 		case AF9013_TUNER_MT2060:
-		case AF9013_TUNER_MC44S803:
 		case AF9013_TUNER_QT1010:
 		case AF9013_TUNER_UNKNOWN:
 		case AF9013_TUNER_MT2060_2:
@@ -942,6 +954,10 @@ static int af9015_read_config(struct usb_device *udev)
 		case AF9013_TUNER_MXL5005R:
 			af9015_af9013_config[i].rf_spec_inv = 0;
 			break;
+		case AF9013_TUNER_MC44S803:
+			af9015_af9013_config[i].gpio[1] = AF9013_GPIO_LO;
+			af9015_af9013_config[i].rf_spec_inv = 1;
+			break;
 		default:
 			warn("tuner id:%d not supported, please report!", val);
 			return -ENODEV;
@@ -1086,6 +1102,11 @@ static struct mt2060_config af9015_mt2060_config = {
 	.clock_out = 0,
 };
 
+static struct mc44s803_config af9015_mc44s803_config = {
+	.i2c_address = 0xc0,
+	.dig_out = 1,
+};
+
 static struct qt1010_config af9015_qt1010_config = {
 	.i2c_address = 0xc4,
 };
@@ -1173,15 +1194,8 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 			DVB_PLL_TDA665X) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MC44S803:
-#if 0
-		ret = dvb_attach(mc44s80x_attach, adap->fe, i2c_adap)
-			== NULL ? -ENODEV : 0;
-#else
-		ret = -ENODEV;
-		info("Freescale MC44S803 tuner found but no driver for that" \
-			"tuner. Look at the Linuxtv.org for tuner driver" \
-			"status.");
-#endif
+		ret = dvb_attach(mc44s803_attach, adap->fe, i2c_adap,
+			&af9015_mc44s803_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_UNKNOWN:
 	default:
-- 
1.5.6.5

