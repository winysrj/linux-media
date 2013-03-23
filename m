Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43686 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3CWR0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 13:26:31 -0400
Received: by mail-ee0-f42.google.com with SMTP id b47so2625637eek.15
        for <linux-media@vger.kernel.org>; Sat, 23 Mar 2013 10:26:29 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 4/5] em28xx: make em28xx_set_outfmt() working with EM25xx family bridges
Date: Sat, 23 Mar 2013 18:27:11 +0100
Message-Id: <1364059632-29070-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com>
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

