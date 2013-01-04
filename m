Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:58276 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3ADVAG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 16:00:06 -0500
Received: by mail-vc0-f175.google.com with SMTP id fy7so16720771vcb.6
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 13:00:06 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 14/15] em28xx: zero vbi_format reserved array and add try_vbi_fmt.
Date: Fri,  4 Jan 2013 15:59:44 -0500
Message-Id: <1357333186-8466-15-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 1514b27..3adaa7b 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1521,6 +1521,7 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 	format->fmt.vbi.sampling_rate = 6750000 * 4 / 2;
 	format->fmt.vbi.count[0] = dev->vbi_height;
 	format->fmt.vbi.count[1] = dev->vbi_height;
+	memset(format->fmt.vbi.reserved, 0, sizeof(format->fmt.vbi.reserved));
 
 	/* Varies by video standard (NTSC, PAL, etc.) */
 	if (dev->norm & V4L2_STD_525_60) {
@@ -1549,6 +1550,7 @@ static int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
 	format->fmt.vbi.sampling_rate = 6750000 * 4 / 2;
 	format->fmt.vbi.count[0] = dev->vbi_height;
 	format->fmt.vbi.count[1] = dev->vbi_height;
+	memset(format->fmt.vbi.reserved, 0, sizeof(format->fmt.vbi.reserved));
 
 	/* Varies by video standard (NTSC, PAL, etc.) */
 	if (dev->norm & V4L2_STD_525_60) {
@@ -1991,6 +1993,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap     = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap       = vidioc_s_fmt_vid_cap,
 	.vidioc_g_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
+	.vidioc_try_fmt_vbi_cap     = vidioc_g_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap       = vidioc_s_fmt_vbi_cap,
 	.vidioc_enum_framesizes     = vidioc_enum_framesizes,
 	.vidioc_g_audio             = vidioc_g_audio,
-- 
1.7.9.5

