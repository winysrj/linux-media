Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:42438 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3CWR0d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 13:26:33 -0400
Received: by mail-ea0-f172.google.com with SMTP id z7so91300eaf.31
        for <linux-media@vger.kernel.org>; Sat, 23 Mar 2013 10:26:31 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 5/5] em28xx: write output frame resolution to regs 0x34+0x35 for em25xx family bridges
Date: Sat, 23 Mar 2013 18:27:12 +0100
Message-Id: <1364059632-29070-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Windows driver writes the output resolution to registers 0x34 (width / 16)
and 0x35 (height / 16) always.
We don't know yet what these registers are used for.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |    7 +++++++
 drivers/media/usb/em28xx/em28xx-reg.h  |    6 ++++++
 2 Dateien geändert, 13 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 7b9f76b..0ce6b0f 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -766,6 +766,13 @@ static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
 	em28xx_write_regs(dev, EM28XX_R1E_CWIDTH, &cwidth, 1);
 	em28xx_write_regs(dev, EM28XX_R1F_CHEIGHT, &cheight, 1);
 	em28xx_write_regs(dev, EM28XX_R1B_OFLOW, &overflow, 1);
+
+	if (dev->is_em25xx) {
+		em28xx_write_reg(dev, 0x34, width >> 4);
+		em28xx_write_reg(dev, 0x35, height >> 4);
+	}
+	/* FIXME: function/meaning of these registers ? */
+	/* FIXME: align width+height to multiples of 4 ?! */
 }
 
 static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 1b0ecd6..e08982a 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -167,6 +167,12 @@
 
 #define EM28XX_R34_VBI_START_H	0x34
 #define EM28XX_R35_VBI_START_V	0x35
+/* NOTE: the EM276x (and EM25xx, EM277x/8x ?) (camera bridges) use these
+ * registers for a different unknown purpose.
+ *   => register 0x34 is set to capture width / 16
+ *   => register 0x35 is set to capture height / 16
+ */
+
 #define EM28XX_R36_VBI_WIDTH	0x36
 #define EM28XX_R37_VBI_HEIGHT	0x37
 
-- 
1.7.10.4

