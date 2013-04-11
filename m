Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:57431 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3DKTz7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 15:55:59 -0400
Received: by mail-ea0-f180.google.com with SMTP id d10so861888eaj.25
        for <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 12:55:58 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: improve em2710/em2820 distinction
Date: Thu, 11 Apr 2013 21:56:47 +0200
Message-Id: <1365710207-4974-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chip id 18 is used by the em2710 and em2820.
The current code assumes that if the device is a camera, the chip is an em2710 
and an em2820 otherwise.
But it turned out that the em2820 is also used in camera devices.
"Silvercrest 1.3 MPix" webcams for example are available with both chips.
Fortunately both variants are using different generic USD IDs which give us a
hint about the used chip.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   16 ++++++++--------
 1 Datei geändert, 8 Zeilen hinzugefügt(+), 8 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 2da17af..bec604f 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2909,6 +2909,14 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			break;
 		case CHIP_ID_EM2820:
 			chip_name = "em2710/2820";
+			if (dev->udev->descriptor.idVendor == 0xeb1a) {
+				__le16 idProd = dev->udev->descriptor.idProduct;
+				if (le16_to_cpu(idProd) == 0x2710)
+					chip_name = "em2710";
+				else if (le16_to_cpu(idProd) == 0x2820)
+					chip_name = "em2820";
+			}
+			/* NOTE: the em2820 is used in webcams, too ! */
 			break;
 		case CHIP_ID_EM2840:
 			chip_name = "em2840";
@@ -2974,14 +2982,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 	em28xx_pre_card_setup(dev);
 
-	if (dev->chip_id == CHIP_ID_EM2820) {
-		if (dev->board.is_webcam)
-			chip_name = "em2710";
-		else
-			chip_name = "em2820";
-		snprintf(dev->name, sizeof(dev->name), "%s #%d", chip_name, dev->devno);
-	}
-
 	if (!dev->board.is_em2800) {
 		/* Resets I2C speed */
 		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
-- 
1.7.10.4

