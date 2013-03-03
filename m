Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:65386 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3CCTkZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 14:40:25 -0500
Received: by mail-ea0-f170.google.com with SMTP id a11so638217eaa.15
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 11:40:24 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/5] em28xx: make em28xx_set_outfmt() working with EM25xx family bridges
Date: Sun,  3 Mar 2013 20:41:00 +0100
Message-Id: <1362339661-3446-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362339661-3446-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362339661-3446-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Streaming doesn't work with the EM2765 if bit 5 of the output format register
0x27 is set.
It's actually not clear if really has to be set for the other chips, but for
now let's keep it to avoid regressions and add a comment to the code.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |   20 +++++++++++++++-----
 1 Datei geändert, 15 Zeilen hinzugefügt(+), 5 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index b2dcb3d..7b9f76b 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -697,12 +697,22 @@ int em28xx_vbi_supported(struct em28xx *dev)
 int em28xx_set_outfmt(struct em28xx *dev)
 {
 	int ret;
-	u8 vinctrl;
-
-	ret = em28xx_write_reg_bits(dev, EM28XX_R27_OUTFMT,
-				dev->format->reg | 0x20, 0xff);
+	u8 fmt, vinctrl;
+
+	fmt = dev->format->reg;
+	if (!dev->is_em25xx)
+		fmt |= 0x20;
+	/* NOTE: it's not clear if this is really needed !
+	 * The datasheets say bit 5 is a reserved bit and devices seem to work
+	 * fine without it. But the Windows driver sets it for em2710/50+em28xx
+	 * devices and we've always been setting it, too.
+	 *
+	 * em2765 (em25xx, em276x/7x/8x ?) devices do NOT work with this bit set,
+	 * it's likely used for an additional (compressed ?) format there.
+	 */
+	ret = em28xx_write_reg(dev, EM28XX_R27_OUTFMT, fmt);
 	if (ret < 0)
-			return ret;
+		return ret;
 
 	ret = em28xx_write_reg(dev, EM28XX_R10_VINMODE, dev->vinmode);
 	if (ret < 0)
-- 
1.7.10.4

