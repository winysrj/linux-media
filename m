Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:35544 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab3AYR04 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:26:56 -0500
Received: by mail-ea0-f179.google.com with SMTP id d12so260899eaa.24
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:26:55 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 07/12] em28xx: remove ioctl VIDIOC_CROPCAP
Date: Fri, 25 Jan 2013 18:26:57 +0100
Message-Id: <1359134822-4585-8-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em28xx driver doesn't support the VIDIOC_G_CROP and VIDIOC_S_CROP ioctls,
so VIDIOC_CROPCAP is useless and has the potential to confuse applications,
because it can be interpreted as indicator for cropping support.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   21 ---------------------
 1 Datei geändert, 21 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 6172d59..edd29ae 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1364,26 +1364,6 @@ static int vidioc_s_register(struct file *file, void *priv,
 #endif
 
 
-static int vidioc_cropcap(struct file *file, void *priv,
-					struct v4l2_cropcap *cc)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-
-	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	cc->bounds.left = 0;
-	cc->bounds.top = 0;
-	cc->bounds.width = dev->width;
-	cc->bounds.height = dev->height;
-	cc->defrect = cc->bounds;
-	cc->pixelaspect.numerator = 54;	/* 4:3 FIXME: remove magic numbers */
-	cc->pixelaspect.denominator = 59;
-
-	return 0;
-}
-
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
@@ -1731,7 +1711,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_framesizes     = vidioc_enum_framesizes,
 	.vidioc_g_audio             = vidioc_g_audio,
 	.vidioc_s_audio             = vidioc_s_audio,
-	.vidioc_cropcap             = vidioc_cropcap,
 
 	.vidioc_reqbufs             = vb2_ioctl_reqbufs,
 	.vidioc_create_bufs         = vb2_ioctl_create_bufs,
-- 
1.7.10.4

