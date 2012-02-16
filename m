Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28462 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab2BPRWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 12:22:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZH007JDXKZXR80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:11 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZH008JGXKYX9@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:11 +0000 (GMT)
Date: Thu, 16 Feb 2012 18:22:04 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5/6] s5p-fimc: Replace the crop ioctls with VIDIOC_S/G_SELECTION
In-reply-to: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329412925-5872-6-git-send-email-s.nawrocki@samsung.com>
References: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for cropping and composition setup on the video capture
node through VIDIOC_S/G_SELECTION ioctls. S/G_CROP, CROPCAP ioctls
are still  supported for applications since the core will translate
them to *_selection handler calls.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  104 +++++++++++++++++++-------
 1 files changed, 76 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index b2fc0b5..b06efd2 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1035,52 +1035,101 @@ static int fimc_cap_prepare_buf(struct file *file, void *priv,
 	return vb2_prepare_buf(&fimc->vid_cap.vbq, b);
 }
 
-static int fimc_cap_cropcap(struct file *file, void *fh,
-			    struct v4l2_cropcap *cr)
+static int fimc_cap_g_selection(struct file *file, void *fh,
+				struct v4l2_selection *s)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct fimc_frame *f = &fimc->vid_cap.ctx->s_frame;
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct fimc_frame *f = &ctx->s_frame;
 
-	if (cr->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
-	cr->bounds.left		= 0;
-	cr->bounds.top		= 0;
-	cr->bounds.width	= f->o_width;
-	cr->bounds.height	= f->o_height;
-	cr->defrect		= cr->bounds;
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		f = &ctx->d_frame;
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = f->o_width;
+		s->r.height = f->o_height;
+		return 0;
 
-	return 0;
+	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+		f = &ctx->d_frame;
+	case V4L2_SEL_TGT_CROP_ACTIVE:
+		s->r.left = f->offs_h;
+		s->r.top = f->offs_v;
+		s->r.width = f->width;
+		s->r.height = f->height;
+		return 0;
+	}
+
+	return -EINVAL;
 }
 
-static int fimc_cap_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+/* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
+int enclosed_rectangle(struct v4l2_rect *a, struct v4l2_rect *b)
 {
-	struct fimc_dev *fimc = video_drvdata(file);
-	struct fimc_frame *f = &fimc->vid_cap.ctx->s_frame;
-
-	cr->c.left	= f->offs_h;
-	cr->c.top	= f->offs_v;
-	cr->c.width	= f->width;
-	cr->c.height	= f->height;
+	if (a->left < b->left || a->top < b->top)
+		return 0;
+	if (a->left + a->width > b->left + b->width)
+		return 0;
+	if (a->top + a->height > b->top + b->height)
+		return 0;
 
-	return 0;
+	return 1;
 }
 
-static int fimc_cap_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+static int fimc_cap_s_selection(struct file *file, void *fh,
+				struct v4l2_selection *s)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
-	struct fimc_frame *ff;
+	struct v4l2_rect rect = s->r;
+	struct fimc_frame *f;
 	unsigned long flags;
+	unsigned int pad;
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
 
-	fimc_capture_try_crop(ctx, &cr->c, FIMC_SD_PAD_SINK);
-	ff = &ctx->s_frame;
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+		f = &ctx->d_frame;
+		pad = FIMC_SD_PAD_SOURCE;
+		break;
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_ACTIVE:
+		f = &ctx->s_frame;
+		pad = FIMC_SD_PAD_SINK;
+		break;
+	default:
+		return -EINVAL;
+	}
 
+	fimc_capture_try_crop(ctx, &rect, pad);
+
+	if (s->flags & V4L2_SEL_FLAG_LE &&
+	    !enclosed_rectangle(&rect, &s->r))
+		return -ERANGE;
+
+	if (s->flags & V4L2_SEL_FLAG_GE &&
+	    !enclosed_rectangle(&s->r, &rect))
+		return -ERANGE;
+
+	s->r = rect;
 	spin_lock_irqsave(&fimc->slock, flags);
-	set_frame_crop(ff, cr->c.left, cr->c.top, cr->c.width, cr->c.height);
-	set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
+	set_frame_crop(f, s->r.left, s->r.top, s->r.width,
+		       s->r.height);
 	spin_unlock_irqrestore(&fimc->slock, flags);
 
+	set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
 	return 0;
 }
 
@@ -1104,9 +1153,8 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_streamon		= fimc_cap_streamon,
 	.vidioc_streamoff		= fimc_cap_streamoff,
 
-	.vidioc_g_crop			= fimc_cap_g_crop,
-	.vidioc_s_crop			= fimc_cap_s_crop,
-	.vidioc_cropcap			= fimc_cap_cropcap,
+	.vidioc_g_selection		= fimc_cap_g_selection,
+	.vidioc_s_selection		= fimc_cap_s_selection,
 
 	.vidioc_enum_input		= fimc_cap_enum_input,
 	.vidioc_s_input			= fimc_cap_s_input,
-- 
1.7.9

