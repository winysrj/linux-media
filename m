Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:47773 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab3JJTUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 15:20:15 -0400
Received: by mail-ea0-f171.google.com with SMTP id n15so1399412ead.30
        for <linux-media@vger.kernel.org>; Thu, 10 Oct 2013 12:20:13 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com, hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH] em28xx: fix device initialization in em28xx_v4l2_open() for radio and VBI mode
Date: Thu, 10 Oct 2013 21:20:24 +0200
Message-Id: <1381432824-7395-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- bail out on unsupported VFL_TYPE
- em28xx_set_mode() needs to be called for VBI and radio mode, too
- em28xx_wake_i2c() needs to be called for VBI and radio mode, too
- em28xx_resolution_set() also needs to be called for VBI

Compilation tested only and should be reviewed thoroughly !

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   17 +++++++++++------
 1 Datei geändert, 11 Zeilen hinzugefügt(+), 6 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index fc5d60e..962f4b2 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1570,13 +1570,16 @@ static int em28xx_v4l2_open(struct file *filp)
 	case VFL_TYPE_VBI:
 		fh_type = V4L2_BUF_TYPE_VBI_CAPTURE;
 		break;
+	case VFL_TYPE_RADIO:
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	em28xx_videodbg("open dev=%s type=%s users=%d\n",
 			video_device_node_name(vdev), v4l2_type_names[fh_type],
 			dev->users);
 
-
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
 	fh = kzalloc(sizeof(struct em28xx_fh), GFP_KERNEL);
@@ -1590,15 +1593,17 @@ static int em28xx_v4l2_open(struct file *filp)
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
+		 * Needed, since GPIO might have disabled power of
+		 * some i2c devices
 		 */
 		em28xx_wake_i2c(dev);
-
 	}
 
 	if (vdev->vfl_type == VFL_TYPE_RADIO) {
-- 
1.7.10.4

