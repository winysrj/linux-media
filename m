Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:62240 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab3ADVAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 16:00:05 -0500
Received: by mail-vb0-f52.google.com with SMTP id ez10so16623467vbb.25
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 13:00:04 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 13/15] em28xx: remove sliced VBI support.
Date: Fri,  4 Jan 2013 15:59:43 -0500
Message-Id: <1357333186-8466-14-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sliced VBI support in the tvp5150 is completely broken. And there is no
support for the saa7115 sliced VBI implementation in the em28xx driver. So
we remove the sliced VBI support completely.

It should be possible to get it to work with the tvp5150, but that will
require someone to really dig into that driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   49 ++-----------------------------
 1 file changed, 2 insertions(+), 47 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index ae713a0..1514b27 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1438,8 +1438,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	else if (vdev->vfl_type == VFL_TYPE_RADIO)
 		cap->device_caps = V4L2_CAP_RADIO;
 	else
-		cap->device_caps = V4L2_CAP_READWRITE |
-			V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE;
+		cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;
 
 	if (dev->audio_mode.has_audio)
 		cap->device_caps |= V4L2_CAP_AUDIO;
@@ -1450,8 +1449,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
 		V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	if (dev->vbi_dev)
-		cap->capabilities |=
-			V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE;
+		cap->capabilities |= V4L2_CAP_VBI_CAPTURE;
 	if (dev->radio_dev)
 		cap->capabilities |= V4L2_CAP_RADIO;
 	return 0;
@@ -1508,46 +1506,6 @@ static int vidioc_enum_framesizes(struct file *file, void *priv,
 	return 0;
 }
 
-/* Sliced VBI ioctls */
-static int vidioc_g_fmt_sliced_vbi_cap(struct file *file, void *priv,
-					struct v4l2_format *f)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	f->fmt.sliced.service_set = 0;
-	v4l2_device_call_all(&dev->v4l2_dev, 0, vbi, g_sliced_fmt, &f->fmt.sliced);
-
-	if (f->fmt.sliced.service_set == 0)
-		rc = -EINVAL;
-
-	return rc;
-}
-
-static int vidioc_try_set_sliced_vbi_cap(struct file *file, void *priv,
-			struct v4l2_format *f)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	v4l2_device_call_all(&dev->v4l2_dev, 0, vbi, g_sliced_fmt, &f->fmt.sliced);
-
-	if (f->fmt.sliced.service_set == 0)
-		return -EINVAL;
-
-	return 0;
-}
-
 /* RAW VBI ioctls */
 
 static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
@@ -2038,9 +1996,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_audio             = vidioc_g_audio,
 	.vidioc_s_audio             = vidioc_s_audio,
 	.vidioc_cropcap             = vidioc_cropcap,
-	.vidioc_g_fmt_sliced_vbi_cap   = vidioc_g_fmt_sliced_vbi_cap,
-	.vidioc_try_fmt_sliced_vbi_cap = vidioc_try_set_sliced_vbi_cap,
-	.vidioc_s_fmt_sliced_vbi_cap   = vidioc_try_set_sliced_vbi_cap,
 
 	.vidioc_reqbufs             = vidioc_reqbufs,
 	.vidioc_querybuf            = vidioc_querybuf,
-- 
1.7.9.5

