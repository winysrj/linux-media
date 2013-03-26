Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:42930 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab3CZRiA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 13:38:00 -0400
Received: by mail-bk0-f53.google.com with SMTP id e19so1411763bku.40
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2013 10:37:59 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v3 5/5] em28xx: write output frame resolution to regs 0x34+0x35 for em25xx family bridges
Date: Tue, 26 Mar 2013 18:38:40 +0100
Message-Id: <1364319520-6628-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364319520-6628-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364319520-6628-1-git-send-email-fschaefer.oss@googlemail.com>
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
 drivers/media/usb/em28xx/em28xx-reg.h  |    9 ++++++++-
 2 Dateien geändert, 15 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 575a46a..a802128 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -767,6 +767,13 @@ static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
 	em28xx_write_regs(dev, EM28XX_R1E_CWIDTH, &cwidth, 1);
 	em28xx_write_regs(dev, EM28XX_R1F_CHEIGHT, &cheight, 1);
 	em28xx_write_regs(dev, EM28XX_R1B_OFLOW, &overflow, 1);
+
+	/* FIXME: function/meaning of these registers ? */
+	/* FIXME: align width+height to multiples of 4 ?! */
+	if (dev->is_em25xx) {
+		em28xx_write_reg(dev, 0x34, width >> 4);
+		em28xx_write_reg(dev, 0x35, height >> 4);
+	}
 }
 
 static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 1b0ecd6..622871d 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -48,7 +48,7 @@
 #define EM28XX_CHIPCFG2_TS_PACKETSIZE_752	0x03
 
 
-	/* GPIO/GPO registers */
+/* GPIO/GPO registers */
 #define EM2880_R04_GPO	0x04    /* em2880-em2883 only */
 #define EM28XX_R08_GPIO	0x08	/* em2820 or upper */
 
@@ -167,6 +167,13 @@
 
 #define EM28XX_R34_VBI_START_H	0x34
 #define EM28XX_R35_VBI_START_V	0x35
+/*
+ * NOTE: the EM276x (and EM25xx, EM277x/8x ?) (camera bridges) use these
+ * registers for a different unknown purpose.
+ *   => register 0x34 is set to capture width / 16
+ *   => register 0x35 is set to capture height / 16
+ */
+
 #define EM28XX_R36_VBI_WIDTH	0x36
 #define EM28XX_R37_VBI_HEIGHT	0x37
 
-- 
1.7.10.4

