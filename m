Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35262 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3CWR02 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 13:26:28 -0400
Received: by mail-ee0-f51.google.com with SMTP id d17so2630191eek.24
        for <linux-media@vger.kernel.org>; Sat, 23 Mar 2013 10:26:27 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 2/5] em28xx: add chip id of the em2765
Date: Sat, 23 Mar 2013 18:27:09 +0100
Message-Id: <1364059632-29070-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This chip can be found in the SpeedLink VAD Laplace webcam (1ae7:9003 and 1ae7:9004).

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   11 ++++++++++-
 drivers/media/usb/em28xx/em28xx-reg.h   |    1 +
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 3 Dateien geändert, 12 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 033b6cb..37c2173 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3041,6 +3041,12 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		case CHIP_ID_EM2750:
 			chip_name = "em2750";
 			break;
+		case CHIP_ID_EM2765:
+			chip_name = "em2765";
+			dev->wait_after_write = 0;
+			dev->is_em25xx = 1;
+			dev->eeprom_addrwidth_16bit = 1;
+			break;
 		case CHIP_ID_EM2820:
 			chip_name = "em2710/2820";
 			break;
@@ -3151,7 +3157,10 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 	/* register i2c bus 1 */
 	if (dev->def_i2c_bus) {
-		retval = em28xx_i2c_register(dev, 1, EM28XX_I2C_ALGO_EM28XX);
+		if (dev->is_em25xx)
+			retval = em28xx_i2c_register(dev, 1, EM28XX_I2C_ALGO_EM25XX_BUS_B);
+		else
+			retval = em28xx_i2c_register(dev, 1, EM28XX_I2C_ALGO_EM28XX);
 		if (retval < 0) {
 			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
 				__func__, retval);
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 8fd3c7f..1b0ecd6 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -219,6 +219,7 @@ enum em28xx_chip_id {
 	CHIP_ID_EM2860 = 34,
 	CHIP_ID_EM2870 = 35,
 	CHIP_ID_EM2883 = 36,
+	CHIP_ID_EM2765 = 54,
 	CHIP_ID_EM2874 = 65,
 	CHIP_ID_EM2884 = 68,
 	CHIP_ID_EM28174 = 113,
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index aeee896..7be008f 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -482,6 +482,7 @@ struct em28xx {
 	int model;		/* index in the device_data struct */
 	int devno;		/* marks the number of this device */
 	enum em28xx_chip_id chip_id;
+	unsigned int is_em25xx:1;	/* em25xx/em276x/7x/8x family bridge */
 
 	unsigned char disconnected:1;	/* device has been diconnected */
 
-- 
1.7.10.4

