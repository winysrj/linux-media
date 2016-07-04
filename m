Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37051 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbcGDIch (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:32:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/9] saa7134: convert g/s_crop to g/s_selection.
Date: Mon,  4 Jul 2016 10:32:17 +0200
Message-Id: <1467621142-8064-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is part of a final push to convert all drivers to g/s_selection.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-video.c | 39 +++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index ffa3954..db14740 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1660,8 +1660,6 @@ static int saa7134_cropcap(struct file *file, void *priv,
 	if (cap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	    cap->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
 		return -EINVAL;
-	cap->bounds  = dev->crop_bounds;
-	cap->defrect = dev->crop_defrect;
 	cap->pixelaspect.numerator   = 1;
 	cap->pixelaspect.denominator = 1;
 	if (dev->tvnorm->id & V4L2_STD_525_60) {
@@ -1675,25 +1673,41 @@ static int saa7134_cropcap(struct file *file, void *priv,
 	return 0;
 }
 
-static int saa7134_g_crop(struct file *file, void *f, struct v4l2_crop *crop)
+static int saa7134_g_selection(struct file *file, void *f, struct v4l2_selection *sel)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
 
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-	    crop->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    sel->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
 		return -EINVAL;
-	crop->c = dev->crop_current;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		sel->r = dev->crop_current;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r = dev->crop_defrect;
+		break;
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		sel->r  = dev->crop_bounds;
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
-static int saa7134_s_crop(struct file *file, void *f, const struct v4l2_crop *crop)
+static int saa7134_s_selection(struct file *file, void *f, struct v4l2_selection *sel)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct v4l2_rect *b = &dev->crop_bounds;
 	struct v4l2_rect *c = &dev->crop_current;
 
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-	    crop->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    sel->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
+		return -EINVAL;
+
+	if (sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
 	if (dev->overlay_owner)
@@ -1701,7 +1715,7 @@ static int saa7134_s_crop(struct file *file, void *f, const struct v4l2_crop *cr
 	if (vb2_is_streaming(&dev->video_vbq))
 		return -EBUSY;
 
-	*c = crop->c;
+	*c = sel->r;
 	if (c->top < b->top)
 		c->top = b->top;
 	if (c->top > b->top + b->height)
@@ -1715,6 +1729,7 @@ static int saa7134_s_crop(struct file *file, void *f, const struct v4l2_crop *cr
 		c->left = b->left + b->width;
 	if (c->width > b->left - c->left + b->width)
 		c->width = b->left - c->left + b->width;
+	sel->r = *c;
 	return 0;
 }
 
@@ -1990,8 +2005,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 	.vidioc_g_tuner			= saa7134_g_tuner,
 	.vidioc_s_tuner			= saa7134_s_tuner,
-	.vidioc_g_crop			= saa7134_g_crop,
-	.vidioc_s_crop			= saa7134_s_crop,
+	.vidioc_g_selection		= saa7134_g_selection,
+	.vidioc_s_selection		= saa7134_s_selection,
 	.vidioc_g_fbuf			= saa7134_g_fbuf,
 	.vidioc_s_fbuf			= saa7134_s_fbuf,
 	.vidioc_overlay			= saa7134_overlay,
-- 
2.8.1

