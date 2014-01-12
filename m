Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:63930 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaALQXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 11:23:44 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so2868569eaj.15
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 08:23:43 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFT/RFC PATCH 1/8] em28xx-v4l: fix device initialization in em28xx_v4l2_open() for radio and VBI mode
Date: Sun, 12 Jan 2014 17:24:18 +0100
Message-Id: <1389543865-2534-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- bail out on unsupported VFL_TYPE
- em28xx_set_mode() needs to be called for VBI and radio mode, too
- em28xx_wake_i2c() needs to be called for VBI and radio mode, too
- em28xx_resolution_set() also needs to be called for VBI

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   16 +++++++++++-----
 1 Datei geändert, 11 Zeilen hinzugefügt(+), 5 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index b65d13a..83c99e6 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1826,6 +1826,10 @@ static int em28xx_v4l2_open(struct file *filp)
 	case VFL_TYPE_VBI:
 		fh_type = V4L2_BUF_TYPE_VBI_CAPTURE;
 		break;
+	case VFL_TYPE_RADIO:
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	em28xx_videodbg("open dev=%s type=%s users=%d\n",
@@ -1846,15 +1850,17 @@ static int em28xx_v4l2_open(struct file *filp)
 	fh->type = fh_type;
 	filp->private_data = fh;
 
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && dev->users == 0) {
+	if (dev->users == 0) {
 		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
-		em28xx_resolution_set(dev);
 
-		/* Needed, since GPIO might have disabled power of
-		   some i2c device
+		if (vdev->vfl_type != VFL_TYPE_RADIO)
+			em28xx_resolution_set(dev);
+
+		/*
+		 * Needed, since GPIO might have disabled power
+		 * of some i2c devices
 		 */
 		em28xx_wake_i2c(dev);
-
 	}
 
 	if (vdev->vfl_type == VFL_TYPE_RADIO) {
-- 
1.7.10.4

