Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35099 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbcGDIce (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:32:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/9] bttv: convert g/s_crop to g/s_selection.
Date: Mon,  4 Jul 2016 10:32:15 +0200
Message-Id: <1467621142-8064-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is part of a final push to convert all drivers to g/s_selection.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 59 +++++++++++++++++++++++------------
 drivers/media/pci/bt8xx/bttvp.h       |  2 +-
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index df54e17..97b91a9 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2804,30 +2804,44 @@ static int bttv_cropcap(struct file *file, void *priv,
 	    cap->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
 		return -EINVAL;
 
-	*cap = bttv_tvnorms[btv->tvnorm].cropcap;
+	/* defrect and bounds are set via g_selection */
+	cap->pixelaspect = bttv_tvnorms[btv->tvnorm].cropcap.pixelaspect;
 
 	return 0;
 }
 
-static int bttv_g_crop(struct file *file, void *f, struct v4l2_crop *crop)
+static int bttv_g_selection(struct file *file, void *f, struct v4l2_selection *sel)
 {
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-	    crop->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    sel->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
 		return -EINVAL;
 
-	/* No fh->do_crop = 1; because btv->crop[1] may be
-	   inconsistent with fh->width or fh->height and apps
-	   do not expect a change here. */
-
-	crop->c = btv->crop[!!fh->do_crop].rect;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		/*
+		 * No fh->do_crop = 1; because btv->crop[1] may be
+		 * inconsistent with fh->width or fh->height and apps
+		 * do not expect a change here.
+		 */
+		sel->r = btv->crop[!!fh->do_crop].rect;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r = bttv_tvnorms[btv->tvnorm].cropcap.defrect;
+		break;
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		sel->r = bttv_tvnorms[btv->tvnorm].cropcap.bounds;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	return 0;
 }
 
-static int bttv_s_crop(struct file *file, void *f, const struct v4l2_crop *crop)
+static int bttv_s_selection(struct file *file, void *f, struct v4l2_selection *sel)
 {
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
@@ -2839,8 +2853,11 @@ static int bttv_s_crop(struct file *file, void *f, const struct v4l2_crop *crop)
 	__s32 b_right;
 	__s32 b_bottom;
 
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-	    crop->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    sel->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
+		return -EINVAL;
+
+	if (sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
 	/* Make sure tvnorm, vbi_end and the current cropping
@@ -2864,22 +2881,24 @@ static int bttv_s_crop(struct file *file, void *f, const struct v4l2_crop *crop)
 	}
 
 	/* Min. scaled size 48 x 32. */
-	c.rect.left = clamp_t(s32, crop->c.left, b_left, b_right - 48);
+	c.rect.left = clamp_t(s32, sel->r.left, b_left, b_right - 48);
 	c.rect.left = min(c.rect.left, (__s32) MAX_HDELAY);
 
-	c.rect.width = clamp_t(s32, crop->c.width,
+	c.rect.width = clamp_t(s32, sel->r.width,
 			     48, b_right - c.rect.left);
 
-	c.rect.top = clamp_t(s32, crop->c.top, b_top, b_bottom - 32);
+	c.rect.top = clamp_t(s32, sel->r.top, b_top, b_bottom - 32);
 	/* Top and height must be a multiple of two. */
 	c.rect.top = (c.rect.top + 1) & ~1;
 
-	c.rect.height = clamp_t(s32, crop->c.height,
+	c.rect.height = clamp_t(s32, sel->r.height,
 			      32, b_bottom - c.rect.top);
 	c.rect.height = (c.rect.height + 1) & ~1;
 
 	bttv_crop_calc_limits(&c);
 
+	sel->r = c.rect;
+
 	btv->crop[1] = c;
 
 	fh->do_crop = 1;
@@ -3047,10 +3066,10 @@ static int bttv_open(struct file *file)
 	   which only change on request. These are stored in btv->crop[1].
 	   However for compatibility with V4L apps and cropping unaware
 	   V4L2 apps we now reset the cropping parameters as seen through
-	   this fh, which is to say VIDIOC_G_CROP and scaling limit checks
+	   this fh, which is to say VIDIOC_G_SELECTION and scaling limit checks
 	   will use btv->crop[0], the default cropping parameters for the
 	   current video standard, and VIDIOC_S_FMT will not implicitely
-	   change the cropping parameters until VIDIOC_S_CROP has been
+	   change the cropping parameters until VIDIOC_S_SELECTION has been
 	   called. */
 	fh->do_crop = !reset_crop; /* module parameter */
 
@@ -3159,8 +3178,8 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
 	.vidioc_streamoff               = bttv_streamoff,
 	.vidioc_g_tuner                 = bttv_g_tuner,
 	.vidioc_s_tuner                 = bttv_s_tuner,
-	.vidioc_g_crop                  = bttv_g_crop,
-	.vidioc_s_crop                  = bttv_s_crop,
+	.vidioc_g_selection             = bttv_g_selection,
+	.vidioc_s_selection             = bttv_s_selection,
 	.vidioc_g_fbuf                  = bttv_g_fbuf,
 	.vidioc_s_fbuf                  = bttv_s_fbuf,
 	.vidioc_overlay                 = bttv_overlay,
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index b1e0023..9efc455 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -232,7 +232,7 @@ struct bttv_fh {
 	const struct bttv_format *ovfmt;
 	struct bttv_overlay      ov;
 
-	/* Application called VIDIOC_S_CROP. */
+	/* Application called VIDIOC_S_SELECTION. */
 	int                      do_crop;
 
 	/* vbi capture */
-- 
2.8.1

