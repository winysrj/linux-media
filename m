Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:65433 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3ATN0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jan 2013 08:26:20 -0500
Received: by mail-ea0-f172.google.com with SMTP id f13so2146244eaa.31
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2013 05:26:19 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: overhaul em28xx_capture_area_set()
Date: Sun, 20 Jan 2013 14:26:47 +0100
Message-Id: <1358688407-5146-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- move the bit shifting of width+height values inside the function
- fix the debug message format and output values
- add comment about the size limit (e.g. EM277x supports >2MPix)
- make void, because error checking is incomplete and we never check the
  returned value (we would continue anyway)

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |   22 ++++++++++++----------
 1 Datei geändert, 12 Zeilen hinzugefügt(+), 10 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 210859a..f516a63 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -733,22 +733,24 @@ static int em28xx_accumulator_set(struct em28xx *dev, u8 xmin, u8 xmax,
 	return em28xx_write_regs(dev, EM28XX_R2B_YMAX, &ymax, 1);
 }
 
-static int em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
+static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
 				   u16 width, u16 height)
 {
-	u8 cwidth = width;
-	u8 cheight = height;
-	u8 overflow = (height >> 7 & 0x02) | (width >> 8 & 0x01);
+	u8 cwidth = width >> 2;
+	u8 cheight = height >> 2;
+	u8 overflow = (height >> 9 & 0x02) | (width >> 10 & 0x01);
+	/* NOTE: size limit: 2047x1023 = 2MPix */
 
-	em28xx_coredbg("em28xx Area Set: (%d,%d)\n",
-			(width | (overflow & 2) << 7),
-			(height | (overflow & 1) << 8));
+	em28xx_coredbg("capture area set to (%d,%d): %dx%d\n",
+		       hstart, vstart,
+		       ((overflow & 2) << 9 | cwidth << 2),
+		       ((overflow & 1) << 10 | cheight << 2));
 
 	em28xx_write_regs(dev, EM28XX_R1C_HSTART, &hstart, 1);
 	em28xx_write_regs(dev, EM28XX_R1D_VSTART, &vstart, 1);
 	em28xx_write_regs(dev, EM28XX_R1E_CWIDTH, &cwidth, 1);
 	em28xx_write_regs(dev, EM28XX_R1F_CHEIGHT, &cheight, 1);
-	return em28xx_write_regs(dev, EM28XX_R1B_OFLOW, &overflow, 1);
+	em28xx_write_regs(dev, EM28XX_R1B_OFLOW, &overflow, 1);
 }
 
 static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
@@ -801,9 +803,9 @@ int em28xx_resolution_set(struct em28xx *dev)
 	   it out, we end up with the same format as the rest of the VBI
 	   region */
 	if (em28xx_vbi_supported(dev) == 1)
-		em28xx_capture_area_set(dev, 0, 2, width >> 2, height >> 2);
+		em28xx_capture_area_set(dev, 0, 2, width, height);
 	else
-		em28xx_capture_area_set(dev, 0, 0, width >> 2, height >> 2);
+		em28xx_capture_area_set(dev, 0, 0, width, height);
 
 	return em28xx_scaler_set(dev, dev->hscale, dev->vscale);
 }
-- 
1.7.10.4

