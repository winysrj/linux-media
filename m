Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43592 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030227Ab3BGRjs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:39:48 -0500
Received: by mail-ee0-f46.google.com with SMTP id e49so1568320eek.33
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 09:39:47 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 11/13] em28xx: make ioctl VIDIOC_DBG_G_CHIP_IDENT available without CONFIG_VIDEO_ADV_DEBUG selected
Date: Thu,  7 Feb 2013 18:39:19 +0100
Message-Id: <1360258761-2959-12-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_DBG_G_CHIP_IDENT is a "normal" and not an "advanced" debug functionality.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   27 +++++++++++++--------------
 1 Datei geändert, 13 Zeilen hinzugefügt(+), 14 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index dd05cfb..2020faa 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1204,19 +1204,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int em28xx_reg_len(int reg)
-{
-	switch (reg) {
-	case EM28XX_R40_AC97LSB:
-	case EM28XX_R30_HSCALELOW:
-	case EM28XX_R32_VSCALELOW:
-		return 2;
-	default:
-		return 1;
-	}
-}
-
 static int vidioc_g_chip_ident(struct file *file, void *priv,
 	       struct v4l2_dbg_chip_ident *chip)
 {
@@ -1239,6 +1226,18 @@ static int vidioc_g_chip_ident(struct file *file, void *priv,
 	return 0;
 }
 
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int em28xx_reg_len(int reg)
+{
+	switch (reg) {
+	case EM28XX_R40_AC97LSB:
+	case EM28XX_R30_HSCALELOW:
+	case EM28XX_R32_VSCALELOW:
+		return 2;
+	default:
+		return 1;
+	}
+}
 
 static int vidioc_g_register(struct file *file, void *priv,
 			     struct v4l2_dbg_register *reg)
@@ -1662,10 +1661,10 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_frequency         = vidioc_s_frequency,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+	.vidioc_g_chip_ident        = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register          = vidioc_g_register,
 	.vidioc_s_register          = vidioc_s_register,
-	.vidioc_g_chip_ident        = vidioc_g_chip_ident,
 #endif
 };
 
-- 
1.7.10.4

