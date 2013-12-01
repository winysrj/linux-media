Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:45570 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3LAVGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Dec 2013 16:06:21 -0500
Received: by mail-ea0-f180.google.com with SMTP id f15so8209108eak.25
        for <linux-media@vger.kernel.org>; Sun, 01 Dec 2013 13:06:20 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/7] em28xx: add support for GPO controlled analog capturing LEDs
Date: Sun,  1 Dec 2013 22:06:51 +0100
Message-Id: <1385932017-2276-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices are equipped with a capturing status LED that needs to be
switched on/off explicitly via a GPO port.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |   69 +++++++++++++++++---------------
 drivers/media/usb/em28xx/em28xx.h      |    9 +++++
 2 Dateien geändert, 46 Zeilen hinzugefügt(+), 32 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index fc157af..31d6ab2 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -608,46 +608,51 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 	    dev->chip_id == CHIP_ID_EM2884 ||
 	    dev->chip_id == CHIP_ID_EM28174) {
 		/* The Transport Stream Enable Register moved in em2874 */
-		if (!start) {
-			rc = em28xx_write_reg_bits(dev, EM2874_R5F_TS_ENABLE,
-						   0x00,
-						   EM2874_TS1_CAPTURE_ENABLE);
-			return rc;
-		}
-
-		/* Enable Transport Stream */
 		rc = em28xx_write_reg_bits(dev, EM2874_R5F_TS_ENABLE,
-					   EM2874_TS1_CAPTURE_ENABLE,
+					   start ?
+					       EM2874_TS1_CAPTURE_ENABLE : 0x00,
 					   EM2874_TS1_CAPTURE_ENABLE);
-		return rc;
-	}
-
+	} else {
+		/* FIXME: which is the best order? */
+		/* video registers are sampled by VREF */
+		rc = em28xx_write_reg_bits(dev, EM28XX_R0C_USBSUSP,
+					   start ? 0x10 : 0x00, 0x10);
+		if (rc < 0)
+			return rc;
 
-	/* FIXME: which is the best order? */
-	/* video registers are sampled by VREF */
-	rc = em28xx_write_reg_bits(dev, EM28XX_R0C_USBSUSP,
-				   start ? 0x10 : 0x00, 0x10);
-	if (rc < 0)
-		return rc;
+		if (start) {
+			if (dev->board.is_webcam)
+				rc = em28xx_write_reg(dev, 0x13, 0x0c);
 
-	if (!start) {
-		/* disable video capture */
-		rc = em28xx_write_reg(dev, EM28XX_R12_VINENABLE, 0x27);
-		return rc;
-	}
+			/* Enable video capture */
+			rc = em28xx_write_reg(dev, 0x48, 0x00);
 
-	if (dev->board.is_webcam)
-		rc = em28xx_write_reg(dev, 0x13, 0x0c);
+			if (dev->mode == EM28XX_ANALOG_MODE)
+				rc = em28xx_write_reg(dev,
+						    EM28XX_R12_VINENABLE, 0x67);
+			else
+				rc = em28xx_write_reg(dev,
+						    EM28XX_R12_VINENABLE, 0x37);
 
-	/* enable video capture */
-	rc = em28xx_write_reg(dev, 0x48, 0x00);
+			msleep(6);
+		} else {
+			/* disable video capture */
+			rc = em28xx_write_reg(dev, EM28XX_R12_VINENABLE, 0x27);
+		}
+	}
 
-	if (dev->mode == EM28XX_ANALOG_MODE)
-		rc = em28xx_write_reg(dev, EM28XX_R12_VINENABLE, 0x67);
-	else
-		rc = em28xx_write_reg(dev, EM28XX_R12_VINENABLE, 0x37);
+	if (rc < 0)
+		return rc;
 
-	msleep(6);
+	/* Switch (explicitly controlled) analog capturing LED on/off */
+	if ((dev->mode == EM28XX_ANALOG_MODE)
+	    && dev->board.analog_capturing_led) {
+		struct em28xx_led *led = dev->board.analog_capturing_led;
+		em28xx_write_reg_bits(dev, led->gpio_reg,
+				      (!start ^ led->inverted) ?
+				      ~led->gpio_mask : led->gpio_mask,
+				      led->gpio_mask);
+	}
 
 	return rc;
 }
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index f8726ad..8003c2f 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -374,6 +374,12 @@ enum em28xx_adecoder {
 	EM28XX_TVAUDIO,
 };
 
+struct em28xx_led {
+	u8 gpio_reg;
+	u8 gpio_mask;
+	bool inverted;
+};
+
 struct em28xx_board {
 	char *name;
 	int vchannels;
@@ -410,6 +416,9 @@ struct em28xx_board {
 	struct em28xx_input       input[MAX_EM28XX_INPUT];
 	struct em28xx_input	  radio;
 	char			  *ir_codes;
+
+	/* LEDs that need to be controlled explicitly */
+	struct em28xx_led	  *analog_capturing_led;
 };
 
 struct em28xx_eeprom {
-- 
1.7.10.4

