Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab1JSJXJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 05:23:09 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p9J9N9w3030369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 19 Oct 2011 05:23:09 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] em28xx: implement VIDIOC_ENUM_FRAMESIZES
Date: Wed, 19 Oct 2011 02:06:23 -0200
Message-Id: <1318997183-4370-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pidgin uses gstreamer (and libv4l) to work. Without implementing this ioctl,
it won't detect properly the size range, and driver will fail.

So, this patch is required, in order to use an em27xx webcam, like
Silvercrest.

The pigdin/gstreamer/libv4l needs to be fixed, as it shouldn't assume
that all drivers will implement this optional ioctl, but, at least now,
devices with em28xx have a better chance of working with pidgin.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/em28xx/em28xx-video.c |   41 ++++++++++++++++++++++++++++-
 1 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 62182e3..9b4557a 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1802,6 +1802,45 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	return 0;
 }
 
+static int vidioc_enum_framesizes(struct file *file, void *priv,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	struct em28xx_fh      *fh  = priv;
+	struct em28xx         *dev = fh->dev;
+	struct em28xx_fmt     *fmt;
+	unsigned int	      maxw = norm_maxw(dev);
+	unsigned int	      maxh = norm_maxh(dev);
+
+	fmt = format_by_fourcc(fsize->pixel_format);
+	if (!fmt) {
+		em28xx_videodbg("Fourcc format (%08x) invalid.\n",
+				fsize->pixel_format);
+		return -EINVAL;
+	}
+
+	if (dev->board.is_em2800) {
+		if (fsize->index > 1)
+			return -EINVAL;
+		fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+		fsize->discrete.width = maxw / (1 + fsize->index);
+		fsize->discrete.height = maxh / (1 + fsize->index);
+		return 0;
+	}
+
+	if (fsize->index != 0)
+		return -EINVAL;
+
+	/* Report a continuous range */
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+	fsize->stepwise.min_width = 48;
+	fsize->stepwise.min_height = 32;
+	fsize->stepwise.max_width = maxw;
+	fsize->stepwise.max_height = maxh;
+	fsize->stepwise.step_width = 1;
+	fsize->stepwise.step_height = 1;
+	return 0;
+}
+
 /* Sliced VBI ioctls */
 static int vidioc_g_fmt_sliced_vbi_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
@@ -2356,10 +2395,10 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap       = vidioc_s_fmt_vid_cap,
 	.vidioc_g_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap       = vidioc_s_fmt_vbi_cap,
+	.vidioc_enum_framesizes     = vidioc_enum_framesizes,
 	.vidioc_g_audio             = vidioc_g_audio,
 	.vidioc_s_audio             = vidioc_s_audio,
 	.vidioc_cropcap             = vidioc_cropcap,
-
 	.vidioc_g_fmt_sliced_vbi_cap   = vidioc_g_fmt_sliced_vbi_cap,
 	.vidioc_try_fmt_sliced_vbi_cap = vidioc_try_set_sliced_vbi_cap,
 	.vidioc_s_fmt_sliced_vbi_cap   = vidioc_try_set_sliced_vbi_cap,
-- 
1.7.6.4

