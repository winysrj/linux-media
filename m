Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39306 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3CCTkV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 14:40:21 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so3510713eei.35
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 11:40:20 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/5] em28xx: add chip id of the em2765
Date: Sun,  3 Mar 2013 20:40:58 +0100
Message-Id: <1362339661-3446-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362339661-3446-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362339661-3446-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This chip can be found in the SpeedLink VAD Laplace webcam (1ae7:9003 and 1ae7:9004).

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   13 ++++++++++++-
 drivers/media/usb/em28xx/em28xx-reg.h   |    1 +
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 3 Dateien geändert, 14 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 75d4aef..e4d14e7 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3015,6 +3015,12 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
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
@@ -3106,7 +3112,12 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	if (dev->board.is_em2800) {
 		dev->i2c_algo_type = EM28XX_I2C_ALGO_EM2800;
 	} else {
-		dev->i2c_algo_type = EM28XX_I2C_ALGO_EM28XX;
+		if (dev->is_em25xx)
+			/* Use i2c bus B */
+			dev->i2c_algo_type = EM28XX_I2C_ALGO_EM25XX_BUS_B;
+			/* FIXME: really do this always ? */
+		else
+			dev->i2c_algo_type = EM28XX_I2C_ALGO_EM28XX;
 
 		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
 		if (retval < 0) {
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 1e369ba..d765d59 100644
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
index b7c8134..131fdaa 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -469,6 +469,7 @@ struct em28xx {
 	int model;		/* index in the device_data struct */
 	int devno;		/* marks the number of this device */
 	enum em28xx_chip_id chip_id;
+	unsigned int is_em25xx:1;	/* em25xx/em276x/7x/8x family bridge */
 
 	unsigned char disconnected:1;	/* device has been diconnected */
 
-- 
1.7.10.4

