Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:49011 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728355AbeJEOqt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 10:46:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>, snawrocki@kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/11] s5p-g2d: convert g/s_crop to g/s_selection
Date: Fri,  5 Oct 2018 09:49:09 +0200
Message-Id: <20181005074911.47574-10-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-1-hverkuil@xs4all.nl>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace g/s_crop by g/s_selection and set the V4L2_FL_QUIRK_INVERTED_CROP
flag since this is one of the old drivers that predates the selection
API. Those old drivers allowed g_crop when it really shouldn't have since
g_crop returns a compose rectangle instead of a crop rectangle for the
CAPTURE stream, and vice versa for the OUTPUT stream.

Also drop the now unused vidioc_cropcap.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-g2d/g2d.c | 102 +++++++++++++++++----------
 1 file changed, 64 insertions(+), 38 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index e901201b6fcc..57ab1d1085d1 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -89,7 +89,7 @@ static struct g2d_fmt *find_fmt(struct v4l2_format *f)
 
 
 static struct g2d_frame *get_frame(struct g2d_ctx *ctx,
-							enum v4l2_buf_type type)
+				   enum v4l2_buf_type type)
 {
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
@@ -408,51 +408,76 @@ static int vidioc_s_fmt(struct file *file, void *prv, struct v4l2_format *f)
 	return 0;
 }
 
-static int vidioc_cropcap(struct file *file, void *priv,
-					struct v4l2_cropcap *cr)
-{
-	struct g2d_ctx *ctx = priv;
-	struct g2d_frame *f;
-
-	f = get_frame(ctx, cr->type);
-	if (IS_ERR(f))
-		return PTR_ERR(f);
-
-	cr->bounds.left		= 0;
-	cr->bounds.top		= 0;
-	cr->bounds.width	= f->width;
-	cr->bounds.height	= f->height;
-	cr->defrect		= cr->bounds;
-	return 0;
-}
-
-static int vidioc_g_crop(struct file *file, void *prv, struct v4l2_crop *cr)
+static int vidioc_g_selection(struct file *file, void *prv,
+			      struct v4l2_selection *s)
 {
 	struct g2d_ctx *ctx = prv;
 	struct g2d_frame *f;
 
-	f = get_frame(ctx, cr->type);
+	f = get_frame(ctx, s->type);
 	if (IS_ERR(f))
 		return PTR_ERR(f);
 
-	cr->c.left	= f->o_height;
-	cr->c.top	= f->o_width;
-	cr->c.width	= f->c_width;
-	cr->c.height	= f->c_height;
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			return -EINVAL;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_COMPOSE:
+		s->r.left = f->o_height;
+		s->r.top = f->o_width;
+		s->r.width = f->c_width;
+		s->r.height = f->c_height;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = f->width;
+		s->r.height = f->height;
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
-static int vidioc_try_crop(struct file *file, void *prv, const struct v4l2_crop *cr)
+static int vidioc_try_selection(struct file *file, void *prv,
+				const struct v4l2_selection *s)
 {
 	struct g2d_ctx *ctx = prv;
 	struct g2d_dev *dev = ctx->dev;
 	struct g2d_frame *f;
 
-	f = get_frame(ctx, cr->type);
+	f = get_frame(ctx, s->type);
 	if (IS_ERR(f))
 		return PTR_ERR(f);
 
-	if (cr->c.top < 0 || cr->c.left < 0) {
+	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		if (s->target != V4L2_SEL_TGT_COMPOSE)
+			return -EINVAL;
+	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		if (s->target != V4L2_SEL_TGT_CROP)
+			return -EINVAL;
+	}
+
+	if (s->r.top < 0 || s->r.left < 0) {
 		v4l2_err(&dev->v4l2_dev,
 			"doesn't support negative values for top & left\n");
 		return -EINVAL;
@@ -461,23 +486,24 @@ static int vidioc_try_crop(struct file *file, void *prv, const struct v4l2_crop
 	return 0;
 }
 
-static int vidioc_s_crop(struct file *file, void *prv, const struct v4l2_crop *cr)
+static int vidioc_s_selection(struct file *file, void *prv,
+			      struct v4l2_selection *s)
 {
 	struct g2d_ctx *ctx = prv;
 	struct g2d_frame *f;
 	int ret;
 
-	ret = vidioc_try_crop(file, prv, cr);
+	ret = vidioc_try_selection(file, prv, s);
 	if (ret)
 		return ret;
-	f = get_frame(ctx, cr->type);
+	f = get_frame(ctx, s->type);
 	if (IS_ERR(f))
 		return PTR_ERR(f);
 
-	f->c_width	= cr->c.width;
-	f->c_height	= cr->c.height;
-	f->o_width	= cr->c.left;
-	f->o_height	= cr->c.top;
+	f->c_width	= s->r.width;
+	f->c_height	= s->r.height;
+	f->o_width	= s->r.left;
+	f->o_height	= s->r.top;
 	f->bottom	= f->o_height + f->c_height;
 	f->right	= f->o_width + f->c_width;
 	return 0;
@@ -585,9 +611,8 @@ static const struct v4l2_ioctl_ops g2d_ioctl_ops = {
 	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 
-	.vidioc_g_crop			= vidioc_g_crop,
-	.vidioc_s_crop			= vidioc_s_crop,
-	.vidioc_cropcap			= vidioc_cropcap,
+	.vidioc_g_selection		= vidioc_g_selection,
+	.vidioc_s_selection		= vidioc_s_selection,
 };
 
 static const struct video_device g2d_videodev = {
@@ -680,6 +705,7 @@ static int g2d_probe(struct platform_device *pdev)
 		goto unreg_v4l2_dev;
 	}
 	*vfd = g2d_videodev;
+	set_bit(V4L2_FL_QUIRK_INVERTED_CROP, &vfd->flags);
 	vfd->lock = &dev->mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
-- 
2.18.0
