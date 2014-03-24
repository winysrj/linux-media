Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:34910 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaCXT2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:28:06 -0400
Received: by mail-ee0-f42.google.com with SMTP id d17so4856082eek.29
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:28:05 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 4/5] em28xx: remove function em28xx_compression_disable() and its call
Date: Mon, 24 Mar 2014 20:28:36 +0100
Message-Id: <1395689316-2397-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx_compression_disable() is a single line function which is called only one
time and this call also isn't needed.
Register 0x26 is always configured as part of the scaler configuration, which
in turn is always done when the resolution changes. And the initial resolution
setting is applied at first device open.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 5 ++---
 drivers/media/usb/em28xx/em28xx.h       | 6 ------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 0856e5d..a2133d5 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -274,7 +274,7 @@ static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
 
 static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
 {
-	u8 mode;
+	u8 mode = 0x00;
 	/* the em2800 scaler only supports scaling down to 50% */
 
 	if (dev->board.is_em2800) {
@@ -293,7 +293,7 @@ static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
 		   to work correctly */
 		mode = (h || v) ? 0x30 : 0x00;
 	}
-	return em28xx_write_reg_bits(dev, EM28XX_R26_COMPR, mode, 0x30);
+	return em28xx_write_reg(dev, EM28XX_R26_COMPR, mode);
 }
 
 /* FIXME: this only function read values from dev */
@@ -2376,7 +2376,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 			 (EM28XX_XCLK_AUDIO_UNMUTE | val));
 
 	em28xx_set_outfmt(dev);
-	em28xx_compression_disable(dev);
 
 	/* Add image controls */
 	/* NOTE: at this point, the subdevices are already registered, so bridge
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e95f4eb..dd6190c 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -793,12 +793,6 @@ int em28xx_init_camera(struct em28xx *dev);
 	printk(KERN_WARNING "%s: "fmt,\
 			dev->name , ##arg); } while (0)
 
-static inline int em28xx_compression_disable(struct em28xx *dev)
-{
-	/* side effect of disabling scaler and mixer */
-	return em28xx_write_reg(dev, EM28XX_R26_COMPR, 0x00);
-}
-
 /*FIXME: maxw should be dependent of alt mode */
 static inline unsigned int norm_maxw(struct em28xx *dev)
 {
-- 
1.8.4.5

