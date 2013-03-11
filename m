Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3981 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3CKVBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 08/15] au0828: add try_fmt_vbi support, zero vbi.reserved, pix.priv.
Date: Mon, 11 Mar 2013 22:00:39 +0100
Message-Id: <209b478e8739d7f0afdfe8826bad9d241af87f59.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Also get rid of unnecessary format type check.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 07287ef..3c3e4d6 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1182,9 +1182,6 @@ static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
 	int width = format->fmt.pix.width;
 	int height = format->fmt.pix.height;
 
-	if (format->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
 	/* If they are demanding a format other than the one we support,
 	   bail out (tvtime asks for UYVY and then retries with YUYV) */
 	if (format->fmt.pix.pixelformat != V4L2_PIX_FMT_UYVY)
@@ -1203,6 +1200,7 @@ static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
 	format->fmt.pix.sizeimage = width * height * 2;
 	format->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	format->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	format->fmt.pix.priv = 0;
 
 	if (cmd == VIDIOC_TRY_FMT)
 		return 0;
@@ -1289,6 +1287,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.sizeimage = dev->frame_size;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M; /* NTSC/PAL */
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.priv = 0;
 	return 0;
 }
 
@@ -1595,6 +1594,7 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 	format->fmt.vbi.count[1] = dev->vbi_height;
 	format->fmt.vbi.start[0] = 21;
 	format->fmt.vbi.start[1] = 284;
+	memset(format->fmt.vbi.reserved, 0, sizeof(format->fmt.vbi.reserved));
 
 	return 0;
 }
@@ -1878,6 +1878,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap     = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap       = vidioc_s_fmt_vid_cap,
 	.vidioc_g_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
+	.vidioc_try_fmt_vbi_cap     = vidioc_g_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
 	.vidioc_enumaudio           = vidioc_enumaudio,
 	.vidioc_g_audio             = vidioc_g_audio,
-- 
1.7.10.4

