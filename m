Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53510 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab2CWV7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 17:59:17 -0400
Received: by gghe5 with SMTP id e5so3155652ggh.19
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2012 14:59:17 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, gennarone@gmail.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] em28xx: Remove redundant dev->ctl_input set
Date: Fri, 23 Mar 2012 19:09:34 -0300
Message-Id: <1332540574-30050-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dev->ctl_input() is always set before a call to video_mux(),
but then video_mux() sets it again with the same value.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-video.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 324b695..bcc4160 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1305,9 +1305,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	if (0 == INPUT(i)->type)
 		return -EINVAL;
 
-	dev->ctl_input = i;
-
-	video_mux(dev, dev->ctl_input);
+	video_mux(dev, i);
 	return 0;
 }
 
@@ -2518,7 +2516,6 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 	dev->norm = em28xx_video_template.current_norm;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
 	dev->interlaced = EM28XX_INTERLACED_DEFAULT;
-	dev->ctl_input = 0;
 
 	/* Analog specific initialization */
 	dev->format = &format[0];
@@ -2532,7 +2529,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 	em28xx_set_video_format(dev, format[0].fourcc,
 				maxw, norm_maxh(dev));
 
-	video_mux(dev, dev->ctl_input);
+	video_mux(dev, 0);
 
 	/* Audio defaults */
 	dev->mute = 1;
-- 
1.7.3.4

