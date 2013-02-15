Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44834 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3BOSiB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 13:38:01 -0500
Received: by mail-ee0-f54.google.com with SMTP id c41so2099189eek.13
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 10:38:00 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 3/4] em28xx: introduce #defines for the image quality default settings
Date: Fri, 15 Feb 2013 19:38:31 +0100
Message-Id: <1360953512-4133-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360953512-4133-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360953512-4133-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The image quality default values will be used in at least two different places
and by using #defines we make sure that they are always consistent.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |   12 ++++++------
 drivers/media/usb/em28xx/em28xx-reg.h  |   23 +++++++++++++++++------
 2 Dateien geändert, 23 Zeilen hinzugefügt(+), 12 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 26d2499..b2dcb3d 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -607,12 +607,12 @@ EXPORT_SYMBOL_GPL(em28xx_audio_setup);
 
 int em28xx_colorlevels_set_default(struct em28xx *dev)
 {
-	em28xx_write_reg(dev, EM28XX_R20_YGAIN, 0x10);	/* contrast */
-	em28xx_write_reg(dev, EM28XX_R21_YOFFSET, 0x00);	/* brightness */
-	em28xx_write_reg(dev, EM28XX_R22_UVGAIN, 0x10);	/* saturation */
-	em28xx_write_reg(dev, EM28XX_R23_UOFFSET, 0x00);
-	em28xx_write_reg(dev, EM28XX_R24_VOFFSET, 0x00);
-	em28xx_write_reg(dev, EM28XX_R25_SHARPNESS, 0x00);
+	em28xx_write_reg(dev, EM28XX_R20_YGAIN, CONTRAST_DEFAULT);
+	em28xx_write_reg(dev, EM28XX_R21_YOFFSET, BRIGHTNESS_DEFAULT);
+	em28xx_write_reg(dev, EM28XX_R22_UVGAIN, SATURATION_DEFAULT);
+	em28xx_write_reg(dev, EM28XX_R23_UOFFSET, BLUE_BALANCE_DEFAULT);
+	em28xx_write_reg(dev, EM28XX_R24_VOFFSET, RED_BALANCE_DEFAULT);
+	em28xx_write_reg(dev, EM28XX_R25_SHARPNESS, SHARPNESS_DEFAULT);
 
 	em28xx_write_reg(dev, EM28XX_R14_GAMMA, 0x20);
 	em28xx_write_reg(dev, EM28XX_R15_RGAIN, 0x20);
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 0a3cb04..1e369ba 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -120,12 +120,23 @@
 #define EM28XX_R1E_CWIDTH	0x1e
 #define EM28XX_R1F_CHEIGHT	0x1f
 
-#define EM28XX_R20_YGAIN	0x20
-#define EM28XX_R21_YOFFSET	0x21
-#define EM28XX_R22_UVGAIN	0x22
-#define EM28XX_R23_UOFFSET	0x23
-#define EM28XX_R24_VOFFSET	0x24
-#define EM28XX_R25_SHARPNESS	0x25
+#define EM28XX_R20_YGAIN	0x20 /* contrast [0:4]   */
+#define   CONTRAST_DEFAULT	0x10
+
+#define EM28XX_R21_YOFFSET	0x21 /* brightness       */	/* signed */
+#define   BRIGHTNESS_DEFAULT	0x00
+
+#define EM28XX_R22_UVGAIN	0x22 /* saturation [0:4] */
+#define   SATURATION_DEFAULT	0x10
+
+#define EM28XX_R23_UOFFSET	0x23 /* blue balance     */	/* signed */
+#define   BLUE_BALANCE_DEFAULT	0x00
+
+#define EM28XX_R24_VOFFSET	0x24 /* red balance      */	/* signed */
+#define   RED_BALANCE_DEFAULT	0x00
+
+#define EM28XX_R25_SHARPNESS	0x25 /* sharpness [0:4]  */
+#define   SHARPNESS_DEFAULT	0x00
 
 #define EM28XX_R26_COMPR	0x26
 #define EM28XX_R27_OUTFMT	0x27
-- 
1.7.10.4

