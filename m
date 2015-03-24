Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54547 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbbCXVNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 17:13:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>,
	Nibble Max <nibble.max@gmail.com>
Subject: [PATCH 4/8] cx23885: switch ts2022 to ts2020 driver
Date: Tue, 24 Mar 2015 23:12:09 +0200
Message-Id: <1427231533-4277-5-git-send-email-crope@iki.fi>
In-Reply-To: <1427231533-4277-1-git-send-email-crope@iki.fi>
References: <1427231533-4277-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change ts2022 driver to ts2020 driver. ts2020 driver supports
both chip models.

Cc: Olli Salonen <olli.salonen@iki.fi>
Cc: Nibble Max <nibble.max@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/cx23885/Kconfig       |  1 -
 drivers/media/pci/cx23885/cx23885-dvb.c | 30 +++++++++++++-----------------
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
index 74d774e..2e1b88c 100644
--- a/drivers/media/pci/cx23885/Kconfig
+++ b/drivers/media/pci/cx23885/Kconfig
@@ -40,7 +40,6 @@ config VIDEO_CX23885
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
-	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88RS6000T if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TUNER_DIB0070 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 45fbe1e..745caab 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -73,7 +73,6 @@
 #include "si2157.h"
 #include "sp2.h"
 #include "m88ds3103.h"
-#include "m88ts2022.h"
 #include "m88rs6000t.h"
 
 static unsigned int debug;
@@ -1187,7 +1186,7 @@ static int dvb_register(struct cx23885_tsport *port)
 	struct vb2_dvb_frontend *fe0, *fe1 = NULL;
 	struct si2168_config si2168_config;
 	struct si2157_config si2157_config;
-	struct m88ts2022_config m88ts2022_config;
+	struct ts2020_config ts2020_config;
 	struct i2c_board_info info;
 	struct i2c_adapter *adapter;
 	struct i2c_client *client_demod = NULL, *client_tuner = NULL;
@@ -1856,13 +1855,12 @@ static int dvb_register(struct cx23885_tsport *port)
 				break;
 
 			/* attach tuner */
-			memset(&m88ts2022_config, 0, sizeof(m88ts2022_config));
-			m88ts2022_config.fe = fe0->dvb.frontend;
-			m88ts2022_config.clock = 27000000;
+			memset(&ts2020_config, 0, sizeof(ts2020_config));
+			ts2020_config.fe = fe0->dvb.frontend;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
+			strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
 			info.addr = 0x60;
-			info.platform_data = &m88ts2022_config;
+			info.platform_data = &ts2020_config;
 			request_module(info.type);
 			client_tuner = i2c_new_device(adapter, &info);
 			if (client_tuner == NULL ||
@@ -1986,13 +1984,12 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 
 		/* attach tuner */
-		memset(&m88ts2022_config, 0, sizeof(m88ts2022_config));
-		m88ts2022_config.fe = fe0->dvb.frontend;
-		m88ts2022_config.clock = 27000000;
+		memset(&ts2020_config, 0, sizeof(ts2020_config));
+		ts2020_config.fe = fe0->dvb.frontend;
 		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
+		strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
 		info.addr = 0x60;
-		info.platform_data = &m88ts2022_config;
+		info.platform_data = &ts2020_config;
 		request_module(info.type);
 		client_tuner = i2c_new_device(adapter, &info);
 		if (client_tuner == NULL || client_tuner->dev.driver == NULL)
@@ -2032,13 +2029,12 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 
 		/* attach tuner */
-		memset(&m88ts2022_config, 0, sizeof(m88ts2022_config));
-		m88ts2022_config.fe = fe0->dvb.frontend;
-		m88ts2022_config.clock = 27000000;
+		memset(&ts2020_config, 0, sizeof(ts2020_config));
+		ts2020_config.fe = fe0->dvb.frontend;
 		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
+		strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
 		info.addr = 0x60;
-		info.platform_data = &m88ts2022_config;
+		info.platform_data = &ts2020_config;
 		request_module(info.type);
 		client_tuner = i2c_new_device(adapter, &info);
 		if (client_tuner == NULL || client_tuner->dev.driver == NULL)
-- 
http://palosaari.fi/

