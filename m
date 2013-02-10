Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:33612 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab3BJUEl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 15:04:41 -0500
Received: by mail-ee0-f43.google.com with SMTP id c50so2904739eek.2
        for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 12:04:39 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/4] em28xx: rename function get_scale() to size_to_scale()
Date: Sun, 10 Feb 2013 21:05:12 +0100
Message-Id: <1360526714-3216-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360526714-3216-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360526714-3216-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    8 ++++----
 1 Datei geändert, 4 Zeilen hinzugefügt(+), 4 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 9451e1e..197823c 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -799,7 +799,7 @@ const struct v4l2_ctrl_ops em28xx_ctrl_ops = {
 	.s_ctrl = em28xx_s_ctrl,
 };
 
-static void get_scale(struct em28xx *dev,
+static void size_to_scale(struct em28xx *dev,
 			unsigned int width, unsigned int height,
 			unsigned int *hscale, unsigned int *vscale)
 {
@@ -889,7 +889,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				      1, 0);
 	}
 
-	get_scale(dev, width, height, &hscale, &vscale);
+	size_to_scale(dev, width, height, &hscale, &vscale);
 
 	width = (((unsigned long)maxw) << 12) / (hscale + 4096L);
 	height = (((unsigned long)maxh) << 12) / (vscale + 4096L);
@@ -923,7 +923,7 @@ static int em28xx_set_video_format(struct em28xx *dev, unsigned int fourcc,
 	dev->height = height;
 
 	/* set new image size */
-	get_scale(dev, dev->width, dev->height, &dev->hscale, &dev->vscale);
+	size_to_scale(dev, dev->width, dev->height, &dev->hscale, &dev->vscale);
 
 	em28xx_resolution_set(dev);
 
@@ -986,7 +986,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	/* set new image size */
 	dev->width = f.fmt.pix.width;
 	dev->height = f.fmt.pix.height;
-	get_scale(dev, dev->width, dev->height, &dev->hscale, &dev->vscale);
+	size_to_scale(dev, dev->width, dev->height, &dev->hscale, &dev->vscale);
 
 	em28xx_resolution_set(dev);
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
-- 
1.7.10.4

