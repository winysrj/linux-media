Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34616 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbbCXVNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 17:13:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/8] em28xx: switch PCTV 461e to ts2020 driver
Date: Tue, 24 Mar 2015 23:12:08 +0200
Message-Id: <1427231533-4277-4-git-send-email-crope@iki.fi>
In-Reply-To: <1427231533-4277-1-git-send-email-crope@iki.fi>
References: <1427231533-4277-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change ts2022 driver to ts2020 driver as ts2020 driver now supports
both models.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/Kconfig      |  2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c | 13 ++++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index f5d7198..e382210 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -55,7 +55,7 @@ config VIDEO_EM28XX_DVB
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
-	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TS2020 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DRX39XYJ if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 6bfe81d..a5b22c5 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -54,7 +54,7 @@
 #include "qt1010.h"
 #include "mb86a20s.h"
 #include "m88ds3103.h"
-#include "m88ts2022.h"
+#include "ts2020.h"
 #include "si2168.h"
 #include "si2157.h"
 
@@ -1492,8 +1492,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			struct i2c_adapter *i2c_adapter;
 			struct i2c_client *client;
 			struct i2c_board_info info;
-			struct m88ts2022_config m88ts2022_config = {
-				.clock = 27000000,
+			struct ts2020_config ts2020_config = {
 			};
 			memset(&info, 0, sizeof(struct i2c_board_info));
 
@@ -1508,11 +1507,11 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			}
 
 			/* attach tuner */
-			m88ts2022_config.fe = dvb->fe[0];
-			strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
+			ts2020_config.fe = dvb->fe[0];
+			strlcpy(info.type, "ts2022", I2C_NAME_SIZE);
 			info.addr = 0x60;
-			info.platform_data = &m88ts2022_config;
-			request_module("m88ts2022");
+			info.platform_data = &ts2020_config;
+			request_module("ts2020");
 			client = i2c_new_device(i2c_adapter, &info);
 			if (client == NULL || client->dev.driver == NULL) {
 				dvb_frontend_detach(dvb->fe[0]);
-- 
http://palosaari.fi/

