Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41768 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbbCXVNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 17:13:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Nibble Max <nibble.max@gmail.com>
Subject: [PATCH 6/8] dvbsky: switch ts2022 to ts2020 driver
Date: Tue, 24 Mar 2015 23:12:11 +0200
Message-Id: <1427231533-4277-7-git-send-email-crope@iki.fi>
In-Reply-To: <1427231533-4277-1-git-send-email-crope@iki.fi>
References: <1427231533-4277-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change ts2022 driver to ts2020 driver. ts2020 driver supports
both tuner chip models.

Cc: Nibble Max <nibble.max@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Kconfig  |  2 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 26 +++++++++++---------------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 0982e73..9facc92 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -146,7 +146,7 @@ config DVB_USB_DVBSKY
 	depends on DVB_USB_V2
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
-	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TS2020 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_SP2 if MEDIA_SUBDRV_AUTOSELECT
 	help
diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 9b5add4..cdf59bc 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -20,7 +20,7 @@
 
 #include "dvb_usb.h"
 #include "m88ds3103.h"
-#include "m88ts2022.h"
+#include "ts2020.h"
 #include "sp2.h"
 #include "si2168.h"
 #include "si2157.h"
@@ -315,9 +315,7 @@ static int dvbsky_s960_attach(struct dvb_usb_adapter *adap)
 	struct i2c_adapter *i2c_adapter;
 	struct i2c_client *client;
 	struct i2c_board_info info;
-	struct m88ts2022_config m88ts2022_config = {
-			.clock = 27000000,
-		};
+	struct ts2020_config ts2020_config = {};
 	memset(&info, 0, sizeof(struct i2c_board_info));
 
 	/* attach demod */
@@ -332,11 +330,11 @@ static int dvbsky_s960_attach(struct dvb_usb_adapter *adap)
 	}
 
 	/* attach tuner */
-	m88ts2022_config.fe = adap->fe[0];
-	strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
+	ts2020_config.fe = adap->fe[0];
+	strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
 	info.addr = 0x60;
-	info.platform_data = &m88ts2022_config;
-	request_module("m88ts2022");
+	info.platform_data = &ts2020_config;
+	request_module("ts2020");
 	client = i2c_new_device(i2c_adapter, &info);
 	if (client == NULL || client->dev.driver == NULL) {
 		dvb_frontend_detach(adap->fe[0]);
@@ -439,9 +437,7 @@ static int dvbsky_s960c_attach(struct dvb_usb_adapter *adap)
 	struct i2c_client *client_tuner, *client_ci;
 	struct i2c_board_info info;
 	struct sp2_config sp2_config;
-	struct m88ts2022_config m88ts2022_config = {
-			.clock = 27000000,
-		};
+	struct ts2020_config ts2020_config = {};
 	memset(&info, 0, sizeof(struct i2c_board_info));
 
 	/* attach demod */
@@ -456,11 +452,11 @@ static int dvbsky_s960c_attach(struct dvb_usb_adapter *adap)
 	}
 
 	/* attach tuner */
-	m88ts2022_config.fe = adap->fe[0];
-	strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
+	ts2020_config.fe = adap->fe[0];
+	strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
 	info.addr = 0x60;
-	info.platform_data = &m88ts2022_config;
-	request_module("m88ts2022");
+	info.platform_data = &ts2020_config;
+	request_module("ts2020");
 	client_tuner = i2c_new_device(i2c_adapter, &info);
 	if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
 		ret = -ENODEV;
-- 
http://palosaari.fi/

