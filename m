Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbbFXKtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 06:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/7] [media] si470x: cleanup define namespace
Date: Wed, 24 Jun 2015 07:49:05 -0300
Message-Id: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some architectures already use CHIPID defines:

	drivers/media/radio/si470x/radio-si470x.h:57:0: warning: "CHIPID" redefined [enabled by default]
	drivers/media/radio/si470x/radio-si470x.h:57:0: warning: "CHIPID" redefined [enabled by default]
	drivers/media/radio/si470x/radio-si470x.h:57:0: warning: "CHIPID" redefined [enabled by default]

So, use SI_foo namespace to avoid conflicts.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 49fe8453e218..471d6a8ae8a4 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -384,14 +384,14 @@ static int si470x_i2c_probe(struct i2c_client *client,
 		goto err_radio;
 	}
 	dev_info(&client->dev, "DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
-			radio->registers[DEVICEID], radio->registers[CHIPID]);
-	if ((radio->registers[CHIPID] & CHIPID_FIRMWARE) < RADIO_FW_VERSION) {
+			radio->registers[DEVICEID], radio->registers[SI_CHIPID]);
+	if ((radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE) < RADIO_FW_VERSION) {
 		dev_warn(&client->dev,
 			"This driver is known to work with "
 			"firmware version %hu,\n", RADIO_FW_VERSION);
 		dev_warn(&client->dev,
 			"but the device has firmware version %hu.\n",
-			radio->registers[CHIPID] & CHIPID_FIRMWARE);
+			radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE);
 		version_warning = 1;
 	}
 
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 57f0bc3b60e7..091d793f6583 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -686,14 +686,14 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 		goto err_ctrl;
 	}
 	dev_info(&intf->dev, "DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
-			radio->registers[DEVICEID], radio->registers[CHIPID]);
-	if ((radio->registers[CHIPID] & CHIPID_FIRMWARE) < RADIO_FW_VERSION) {
+			radio->registers[DEVICEID], radio->registers[SI_CHIPID]);
+	if ((radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE) < RADIO_FW_VERSION) {
 		dev_warn(&intf->dev,
 			"This driver is known to work with "
 			"firmware version %hu,\n", RADIO_FW_VERSION);
 		dev_warn(&intf->dev,
 			"but the device has firmware version %hu.\n",
-			radio->registers[CHIPID] & CHIPID_FIRMWARE);
+			radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE);
 		version_warning = 1;
 	}
 
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 4b7660470e2f..6c0ca900702e 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -54,10 +54,10 @@
 #define DEVICEID_PN		0xf000	/* bits 15..12: Part Number */
 #define DEVICEID_MFGID		0x0fff	/* bits 11..00: Manufacturer ID */
 
-#define CHIPID			1	/* Chip ID */
-#define CHIPID_REV		0xfc00	/* bits 15..10: Chip Version */
-#define CHIPID_DEV		0x0200	/* bits 09..09: Device */
-#define CHIPID_FIRMWARE		0x01ff	/* bits 08..00: Firmware Version */
+#define SI_CHIPID		1	/* Chip ID */
+#define SI_CHIPID_REV		0xfc00	/* bits 15..10: Chip Version */
+#define SI_CHIPID_DEV		0x0200	/* bits 09..09: Device */
+#define SI_CHIPID_FIRMWARE	0x01ff	/* bits 08..00: Firmware Version */
 
 #define POWERCFG		2	/* Power Configuration */
 #define POWERCFG_DSMUTE		0x8000	/* bits 15..15: Softmute Disable */
-- 
2.4.3

