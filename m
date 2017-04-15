Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36710 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753432AbdDOKFo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Apr 2017 06:05:44 -0400
Received: by mail-wm0-f66.google.com with SMTP id q125so1908646wmd.3
        for <linux-media@vger.kernel.org>; Sat, 15 Apr 2017 03:05:43 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/5] em28xx: shed some light on video input formats
Date: Sat, 15 Apr 2017 12:05:03 +0200
Message-Id: <20170415100504.3076-4-fschaefer.oss@googlemail.com>
In-Reply-To: <20170415100504.3076-1-fschaefer.oss@googlemail.com>
References: <20170415100504.3076-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CbYCrY has been identified by looking into the tvp5150 driver and the
saa7115 datasheet.
YUV formats have been verified with em2765 + ov2640 (VAD Laplace webcam).
RGB8 formats have been verified with em2710/em2820 + mt9v011 (Silvercrest
webcam 1.3mpix).
I also did some cross-checking with these two camera devices and 0x08-0x0b
are at least 16 bits per pixel formats on em2710/em2820, too, and
0x0c-0x0f are at least 8 bits per pixel formats on em2765, too.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c | 10 ++++------
 drivers/media/usb/em28xx/em28xx-reg.h    | 18 ++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-video.c  |  2 +-
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index d43f630050bb..95eaa55356a9 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -364,8 +364,7 @@ int em28xx_init_camera(struct em28xx *dev)
 		    v4l2_i2c_new_subdev_board(&v4l2->v4l2_dev, adap,
 					      &mt9v011_info, NULL))
 			return -ENODEV;
-		/* probably means GRGB 16 bit bayer */
-		v4l2->vinmode = 0x0d;
+		v4l2->vinmode = EM28XX_VINMODE_RGB8_GRBG;
 		v4l2->vinctl = 0x00;
 
 		break;
@@ -376,8 +375,7 @@ int em28xx_init_camera(struct em28xx *dev)
 
 		em28xx_initialize_mt9m001(dev);
 
-		/* probably means BGGR 16 bit bayer */
-		v4l2->vinmode = 0x0c;
+		v4l2->vinmode = EM28XX_VINMODE_RGB8_BGGR;
 		v4l2->vinctl = 0x00;
 
 		break;
@@ -389,7 +387,7 @@ int em28xx_init_camera(struct em28xx *dev)
 		em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk);
 		em28xx_initialize_mt9m111(dev);
 
-		v4l2->vinmode = 0x0a;
+		v4l2->vinmode = EM28XX_VINMODE_YUV422_UYVY;
 		v4l2->vinctl = 0x00;
 
 		break;
@@ -430,7 +428,7 @@ int em28xx_init_camera(struct em28xx *dev)
 		/* NOTE: for UXGA=1600x1200 switch to 12MHz */
 		dev->board.xclk = EM28XX_XCLK_FREQUENCY_24MHZ;
 		em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk);
-		v4l2->vinmode = 0x08;
+		v4l2->vinmode = EM28XX_VINMODE_YUV422_YUYV;
 		v4l2->vinctl = 0x00;
 
 		break;
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index afe7a66d7dc8..747525ca7ed5 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -93,6 +93,24 @@
 #define EM28XX_XCLK_FREQUENCY_24MHZ	0x0b
 
 #define EM28XX_R10_VINMODE	0x10
+	  /* used by all non-camera devices: */
+#define   EM28XX_VINMODE_YUV422_CbYCrY  0x10
+	  /* used by camera devices: */
+#define   EM28XX_VINMODE_YUV422_YUYV    0x08
+#define   EM28XX_VINMODE_YUV422_YVYU    0x09
+#define   EM28XX_VINMODE_YUV422_UYVY    0x0a
+#define   EM28XX_VINMODE_YUV422_VYUY    0x0b
+#define   EM28XX_VINMODE_RGB8_BGGR      0x0c
+#define   EM28XX_VINMODE_RGB8_GRBG      0x0d
+#define   EM28XX_VINMODE_RGB8_GBRG      0x0e
+#define   EM28XX_VINMODE_RGB8_RGGB      0x0f
+	  /*
+	   * apparently:
+	   *   bit 0: swap component 1+2 with 3+4
+	   *                 => e.g.: YUYV => YVYU, BGGR => GRBG
+	   *   bit 1: swap component 1 with 2 and 3 with 4
+	   *                 => e.g.: YUYV => UYVY, BGGR => GBRG
+	   */
 
 #define EM28XX_R11_VINCTRL	0x11
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3cbc3d4270a3..aaa83f9e5c1a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2459,7 +2459,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/*
 	 * Default format, used for tvp5150 or saa711x output formats
 	 */
-	v4l2->vinmode = 0x10;
+	v4l2->vinmode = EM28XX_VINMODE_YUV422_CbYCrY;
 	v4l2->vinctl  = EM28XX_VINCTRL_INTERLACED |
 			EM28XX_VINCTRL_CCIR656_ENABLE;
 
-- 
2.12.2
