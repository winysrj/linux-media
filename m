Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:57889 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab3ADU7z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 15:59:55 -0500
Received: by mail-vc0-f176.google.com with SMTP id fo13so16703096vcb.7
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 12:59:54 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/15] em28xx: remove bogus input/audio ioctls for the radio device.
Date: Fri,  4 Jan 2013 15:59:32 -0500
Message-Id: <1357333186-8466-3-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Radio devices should not implement those ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   35 -------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index fb9ee46..f025440 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1856,26 +1856,6 @@ static int radio_g_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_enum_input(struct file *file, void *priv,
-			    struct v4l2_input *i)
-{
-	if (i->index != 0)
-		return -EINVAL;
-	strcpy(i->name, "Radio");
-	i->type = V4L2_INPUT_TYPE_TUNER;
-
-	return 0;
-}
-
-static int radio_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
-{
-	if (unlikely(a->index))
-		return -EINVAL;
-
-	strcpy(a->name, "Radio");
-	return 0;
-}
-
 static int radio_s_tuner(struct file *file, void *priv,
 			 struct v4l2_tuner *t)
 {
@@ -1889,17 +1869,6 @@ static int radio_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_s_audio(struct file *file, void *fh,
-			 const struct v4l2_audio *a)
-{
-	return 0;
-}
-
-static int radio_s_input(struct file *file, void *fh, unsigned int i)
-{
-	return 0;
-}
-
 static int radio_queryctrl(struct file *file, void *priv,
 			   struct v4l2_queryctrl *qc)
 {
@@ -2279,11 +2248,7 @@ static const struct v4l2_file_operations radio_fops = {
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_querycap      = vidioc_querycap,
 	.vidioc_g_tuner       = radio_g_tuner,
-	.vidioc_enum_input    = radio_enum_input,
-	.vidioc_g_audio       = radio_g_audio,
 	.vidioc_s_tuner       = radio_s_tuner,
-	.vidioc_s_audio       = radio_s_audio,
-	.vidioc_s_input       = radio_s_input,
 	.vidioc_queryctrl     = radio_queryctrl,
 	.vidioc_g_ctrl        = vidioc_g_ctrl,
 	.vidioc_s_ctrl        = vidioc_s_ctrl,
-- 
1.7.9.5

