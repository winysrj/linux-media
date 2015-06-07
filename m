Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:54847 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbbFGI6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 04:58:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 07/11] sh-vou: replace g/s_crop/cropcap by g/s_selection
Date: Sun,  7 Jun 2015 10:58:01 +0200
Message-Id: <1433667485-35711-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
References: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Implement g/s_selection. The v4l2 core will emulate g/s_crop and
cropcap on top of g/s_selection.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_vou.c | 71 +++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 46 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 262c244..9479c44 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -949,24 +949,36 @@ static int sh_vou_g_std(struct file *file, void *priv, v4l2_std_id *std)
 	return 0;
 }
 
-static int sh_vou_g_crop(struct file *file, void *fh, struct v4l2_crop *a)
+static int sh_vou_g_selection(struct file *file, void *fh,
+			      struct v4l2_selection *sel)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
 
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	a->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	a->c = vou_dev->rect;
-
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_COMPOSE:
+		sel->r = vou_dev->rect;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = VOU_MAX_IMAGE_WIDTH;
+		sel->r.height = VOU_MAX_IMAGE_HEIGHT;
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
 /* Assume a dull encoder, do all the work ourselves. */
-static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
+static int sh_vou_s_selection(struct file *file, void *fh,
+			      struct v4l2_selection *sel)
 {
-	struct v4l2_crop a_writable = *a;
+	struct v4l2_rect *rect = &sel->r;
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct v4l2_rect *rect = &a_writable.c;
 	struct v4l2_crop sd_crop = {.type = V4L2_BUF_TYPE_VIDEO_OUTPUT};
 	struct v4l2_pix_format *pix = &vou_dev->pix;
 	struct sh_vou_geometry geo;
@@ -980,10 +992,8 @@ static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 	unsigned int img_height_max;
 	int ret;
 
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): %ux%u@%u:%u\n", __func__,
-		rect->width, rect->height, rect->left, rect->top);
-
-	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+	    sel->target != V4L2_SEL_TGT_COMPOSE)
 		return -EINVAL;
 
 	if (vou_dev->std & V4L2_STD_525_60)
@@ -1047,36 +1057,6 @@ static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 	return 0;
 }
 
-/*
- * Total field: NTSC 858 x 2 * 262/263, PAL 864 x 2 * 312/313, default rectangle
- * is the initial register values, height takes the interlaced format into
- * account. The actual image can only go up to 720 x 2 * 240, So, VOUVPR can
- * actually only meaningfully contain values <= 720 and <= 240 respectively, and
- * not <= 864 and <= 312.
- */
-static int sh_vou_cropcap(struct file *file, void *priv,
-			  struct v4l2_cropcap *a)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	a->type				= V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	a->bounds.left			= 0;
-	a->bounds.top			= 0;
-	a->bounds.width			= VOU_MAX_IMAGE_WIDTH;
-	a->bounds.height		= VOU_MAX_IMAGE_HEIGHT;
-	/* Default = max, set VOUDPR = 0, which is not hardware default */
-	a->defrect.left			= 0;
-	a->defrect.top			= 0;
-	a->defrect.width		= VOU_MAX_IMAGE_WIDTH;
-	a->defrect.height		= VOU_MAX_IMAGE_HEIGHT;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
-
-	return 0;
-}
-
 static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 {
 	struct sh_vou_device *vou_dev = dev_id;
@@ -1305,9 +1285,8 @@ static const struct v4l2_ioctl_ops sh_vou_ioctl_ops = {
 	.vidioc_enum_output		= sh_vou_enum_output,
 	.vidioc_s_std			= sh_vou_s_std,
 	.vidioc_g_std			= sh_vou_g_std,
-	.vidioc_cropcap			= sh_vou_cropcap,
-	.vidioc_g_crop			= sh_vou_g_crop,
-	.vidioc_s_crop			= sh_vou_s_crop,
+	.vidioc_g_selection		= sh_vou_g_selection,
+	.vidioc_s_selection		= sh_vou_s_selection,
 };
 
 static const struct v4l2_file_operations sh_vou_fops = {
-- 
2.1.4

