Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:34362 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652Ab3AYR06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:26:58 -0500
Received: by mail-ea0-f175.google.com with SMTP id d1so261178eab.6
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:26:57 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 08/12] em28xx: get rid of duplicate function vidioc_s_fmt_vbi_cap()
Date: Fri, 25 Jan 2013 18:26:58 +0100
Message-Id: <1359134822-4585-9-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vidioc_s_fmt_vbi_cap() is a 100% duplicate of vidioc_g_fmt_vbi_cap() and
therefore can be removed.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   31 +------------------------------
 1 Datei geändert, 1 Zeile hinzugefügt(+), 30 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index edd29ae..af3e70a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1480,35 +1480,6 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
-				struct v4l2_format *format)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-
-	format->fmt.vbi.samples_per_line = dev->vbi_width;
-	format->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
-	format->fmt.vbi.offset = 0;
-	format->fmt.vbi.flags = 0;
-	format->fmt.vbi.sampling_rate = 6750000 * 4 / 2;
-	format->fmt.vbi.count[0] = dev->vbi_height;
-	format->fmt.vbi.count[1] = dev->vbi_height;
-	memset(format->fmt.vbi.reserved, 0, sizeof(format->fmt.vbi.reserved));
-
-	/* Varies by video standard (NTSC, PAL, etc.) */
-	if (dev->norm & V4L2_STD_525_60) {
-		/* NTSC */
-		format->fmt.vbi.start[0] = 10;
-		format->fmt.vbi.start[1] = 273;
-	} else if (dev->norm & V4L2_STD_625_50) {
-		/* PAL */
-		format->fmt.vbi.start[0] = 6;
-		format->fmt.vbi.start[1] = 318;
-	}
-
-	return 0;
-}
-
 /* ----------------------------------------------------------- */
 /* RADIO ESPECIFIC IOCTLS                                      */
 /* ----------------------------------------------------------- */
@@ -1707,7 +1678,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap       = vidioc_s_fmt_vid_cap,
 	.vidioc_g_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
 	.vidioc_try_fmt_vbi_cap     = vidioc_g_fmt_vbi_cap,
-	.vidioc_s_fmt_vbi_cap       = vidioc_s_fmt_vbi_cap,
+	.vidioc_s_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
 	.vidioc_enum_framesizes     = vidioc_enum_framesizes,
 	.vidioc_g_audio             = vidioc_g_audio,
 	.vidioc_s_audio             = vidioc_s_audio,
-- 
1.7.10.4

