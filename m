Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54524 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbbC2WgA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2015 18:36:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] dw2102: switch ts2022 to ts2020 driver
Date: Mon, 30 Mar 2015 01:35:27 +0300
Message-Id: <1427668527-22798-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change ts2022 driver to ts2020 driver. ts2020 driver supports
both tuner chip models.

That affects TechnoTrend TT-connect S2-4600 DVB-S/S2 device, which
Olli just added.

Cc: Olli Salonen <olli.salonen@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb/Kconfig  |  1 -
 drivers/media/usb/dvb-usb/dw2102.c | 14 ++++++--------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index def1e06..128eee6 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -279,7 +279,6 @@ config DVB_USB_DW2102
 	select DVB_STV0900 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_M88RS2000 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
-	select MEDIA_TUNER_TS2022 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the DvbWorld, TeVii, Prof, TechnoTrend
 	  DVB-S/S2 USB2.0 receivers.
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 9dc3619..f1f357f 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -33,7 +33,7 @@
 #include "tda18271.h"
 #include "cxd2820r.h"
 #include "m88ds3103.h"
-#include "m88ts2022.h"
+#include "ts2020.h"
 
 /* Max transfer size done by I2C transfer functions */
 #define MAX_XFER_SIZE  64
@@ -1487,9 +1487,7 @@ static int tt_s2_4600_frontend_attach(struct dvb_usb_adapter *adap)
 	struct i2c_adapter *i2c_adapter;
 	struct i2c_client *client;
 	struct i2c_board_info info;
-	struct m88ts2022_config m88ts2022_config = {
-		.clock = 27000000,
-	};
+	struct ts2020_config ts2020_config = {};
 
 	if (dvb_usb_generic_rw(d, obuf, 3, ibuf, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
@@ -1531,11 +1529,11 @@ static int tt_s2_4600_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 
 	/* attach tuner */
-	m88ts2022_config.fe = adap->fe_adap[0].fe;
-	strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
+	ts2020_config.fe = adap->fe_adap[0].fe;
+	strlcpy(info.type, "ts2022", I2C_NAME_SIZE);
 	info.addr = 0x60;
-	info.platform_data = &m88ts2022_config;
-	request_module("m88ts2022");
+	info.platform_data = &ts2020_config;
+	request_module("ts2020");
 	client = i2c_new_device(i2c_adapter, &info);
 
 	if (client == NULL || client->dev.driver == NULL) {
-- 
http://palosaari.fi/

