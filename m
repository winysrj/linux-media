Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63766 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaCXTdD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:03 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so4788058eek.37
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:02 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 09/19] em28xx: move vinmode and vinctrl data from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:15 +0100
Message-Id: <1395689605-2705-10-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c | 16 ++++++++--------
 drivers/media/usb/em28xx/em28xx-video.c  | 10 +++++-----
 drivers/media/usb/em28xx/em28xx.h        |  6 +++---
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index c2672b4..3a88867 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -372,8 +372,8 @@ int em28xx_init_camera(struct em28xx *dev)
 			break;
 		}
 		/* probably means GRGB 16 bit bayer */
-		dev->vinmode = 0x0d;
-		dev->vinctl = 0x00;
+		v4l2->vinmode = 0x0d;
+		v4l2->vinctl = 0x00;
 
 		break;
 	}
@@ -384,8 +384,8 @@ int em28xx_init_camera(struct em28xx *dev)
 		em28xx_initialize_mt9m001(dev);
 
 		/* probably means BGGR 16 bit bayer */
-		dev->vinmode = 0x0c;
-		dev->vinctl = 0x00;
+		v4l2->vinmode = 0x0c;
+		v4l2->vinctl = 0x00;
 
 		break;
 	case EM28XX_MT9M111:
@@ -396,8 +396,8 @@ int em28xx_init_camera(struct em28xx *dev)
 		em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk);
 		em28xx_initialize_mt9m111(dev);
 
-		dev->vinmode = 0x0a;
-		dev->vinctl = 0x00;
+		v4l2->vinmode = 0x0a;
+		v4l2->vinctl = 0x00;
 
 		break;
 	case EM28XX_OV2640:
@@ -438,8 +438,8 @@ int em28xx_init_camera(struct em28xx *dev)
 		/* NOTE: for UXGA=1600x1200 switch to 12MHz */
 		dev->board.xclk = EM28XX_XCLK_FREQUENCY_24MHZ;
 		em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk);
-		dev->vinmode = 0x08;
-		dev->vinctl = 0x00;
+		v4l2->vinmode = 0x08;
+		v4l2->vinctl = 0x00;
 
 		break;
 	}
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index ecc4411..0676aa4 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -236,11 +236,11 @@ static int em28xx_set_outfmt(struct em28xx *dev)
 	if (ret < 0)
 		return ret;
 
-	ret = em28xx_write_reg(dev, EM28XX_R10_VINMODE, dev->vinmode);
+	ret = em28xx_write_reg(dev, EM28XX_R10_VINMODE, v4l2->vinmode);
 	if (ret < 0)
 		return ret;
 
-	vinctrl = dev->vinctl;
+	vinctrl = v4l2->vinctl;
 	if (em28xx_vbi_supported(dev) == 1) {
 		vinctrl |= EM28XX_VINCTRL_VBI_RAW;
 		em28xx_write_reg(dev, EM28XX_R34_VBI_START_H, 0x00);
@@ -2316,9 +2316,9 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/*
 	 * Default format, used for tvp5150 or saa711x output formats
 	 */
-	dev->vinmode = 0x10;
-	dev->vinctl  = EM28XX_VINCTRL_INTERLACED |
-		       EM28XX_VINCTRL_CCIR656_ENABLE;
+	v4l2->vinmode = 0x10;
+	v4l2->vinctl  = EM28XX_VINCTRL_INTERLACED |
+			EM28XX_VINCTRL_CCIR656_ENABLE;
 
 	/* request some modules */
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e029136..7ca0ff98 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -515,6 +515,9 @@ struct em28xx_v4l2 {
 	struct mutex vb_queue_lock;
 	struct mutex vb_vbi_queue_lock;
 
+	u8 vinmode;
+	u8 vinctl;
+
 	/* Frame properties */
 	int width;		/* current frame width */
 	int height;		/* current frame height */
@@ -597,9 +600,6 @@ struct em28xx {
 	/* Progressive (non-interlaced) mode */
 	int progressive;
 
-	/* Vinmode/Vinctl used at the driver */
-	int vinmode, vinctl;
-
 	/* Controls audio streaming */
 	struct work_struct wq_trigger;	/* Trigger to start/stop audio for alsa module */
 	atomic_t       stream_started;	/* stream should be running if true */
-- 
1.8.4.5

