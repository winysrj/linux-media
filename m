Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60476 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbaCMLp2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 07:45:28 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v4 07/14] v4l: ti-vpe: Add selection API in VPE driver
Date: Thu, 13 Mar 2014 17:14:09 +0530
Message-ID: <1394711056-10878-8-git-send-email-archit@ti.com>
In-Reply-To: <1394711056-10878-1-git-send-email-archit@ti.com>
References: <1394526833-24805-1-git-send-email-archit@ti.com>
 <1394711056-10878-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add selection ioctl ops. For VPE, cropping makes sense only for the input to
VPE(or V4L2_BUF_TYPE_VIDEO_OUTPUT/MPLANE buffers) and composing makes sense
only for the output of VPE(or V4L2_BUF_TYPE_VIDEO_CAPTURE/MPLANE buffers).

For the CAPTURE type, V4L2_SEL_TGT_COMPOSE results in VPE writing the output
in a rectangle within the capture buffer. For the OUTPUT type, V4L2_SEL_TGT_CROP
results in selecting a rectangle region within the source buffer.

Setting the crop/compose rectangles should successfully result in
re-configuration of registers which are affected when either source or
destination dimensions change, set_srcdst_params() is called for this purpose.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 150 ++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index ece9b96..f3f1c10 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -410,8 +410,10 @@ static struct vpe_q_data *get_q_data(struct vpe_ctx *ctx,
 {
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		return &ctx->q_data[Q_DATA_SRC];
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		return &ctx->q_data[Q_DATA_DST];
 	default:
 		BUG();
@@ -1587,6 +1589,151 @@ static int vpe_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	return set_srcdst_params(ctx);
 }
 
+static int __vpe_try_selection(struct vpe_ctx *ctx, struct v4l2_selection *s)
+{
+	struct vpe_q_data *q_data;
+
+	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
+	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
+		return -EINVAL;
+
+	q_data = get_q_data(ctx, s->type);
+	if (!q_data)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE:
+		/*
+		 * COMPOSE target is only valid for capture buffer type, return
+		 * error for output buffer type
+		 */
+		if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			return -EINVAL;
+		break;
+	case V4L2_SEL_TGT_CROP:
+		/*
+		 * CROP target is only valid for output buffer type, return
+		 * error for capture buffer type
+		 */
+		if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+		break;
+	/*
+	 * bound and default crop/compose targets are invalid targets to
+	 * try/set
+	 */
+	default:
+		return -EINVAL;
+	}
+
+	if (s->r.top < 0 || s->r.left < 0) {
+		vpe_err(ctx->dev, "negative values for top and left\n");
+		s->r.top = s->r.left = 0;
+	}
+
+	v4l_bound_align_image(&s->r.width, MIN_W, q_data->width, 1,
+		&s->r.height, MIN_H, q_data->height, H_ALIGN, S_ALIGN);
+
+	/* adjust left/top if cropping rectangle is out of bounds */
+	if (s->r.left + s->r.width > q_data->width)
+		s->r.left = q_data->width - s->r.width;
+	if (s->r.top + s->r.height > q_data->height)
+		s->r.top = q_data->height - s->r.height;
+
+	return 0;
+}
+
+static int vpe_g_selection(struct file *file, void *fh,
+		struct v4l2_selection *s)
+{
+	struct vpe_ctx *ctx = file2ctx(file);
+	struct vpe_q_data *q_data;
+	bool use_c_rect = false;
+
+	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
+	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
+		return -EINVAL;
+
+	q_data = get_q_data(ctx, s->type);
+	if (!q_data)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			return -EINVAL;
+		break;
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			return -EINVAL;
+		use_c_rect = true;
+		break;
+	case V4L2_SEL_TGT_CROP:
+		if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+		use_c_rect = true;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (use_c_rect) {
+		/*
+		 * for CROP/COMPOSE target type, return c_rect params from the
+		 * respective buffer type
+		 */
+		s->r = q_data->c_rect;
+	} else {
+		/*
+		 * for DEFAULT/BOUNDS target type, return width and height from
+		 * S_FMT of the respective buffer type
+		 */
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = q_data->width;
+		s->r.height = q_data->height;
+	}
+
+	return 0;
+}
+
+
+static int vpe_s_selection(struct file *file, void *fh,
+		struct v4l2_selection *s)
+{
+	struct vpe_ctx *ctx = file2ctx(file);
+	struct vpe_q_data *q_data;
+	struct v4l2_selection sel = *s;
+	int ret;
+
+	ret = __vpe_try_selection(ctx, &sel);
+	if (ret)
+		return ret;
+
+	q_data = get_q_data(ctx, sel.type);
+	if (!q_data)
+		return -EINVAL;
+
+	if ((q_data->c_rect.left == sel.r.left) &&
+			(q_data->c_rect.top == sel.r.top) &&
+			(q_data->c_rect.width == sel.r.width) &&
+			(q_data->c_rect.height == sel.r.height)) {
+		vpe_dbg(ctx->dev,
+			"requested crop/compose values are already set\n");
+		return 0;
+	}
+
+	q_data->c_rect = sel.r;
+
+	return set_srcdst_params(ctx);
+}
+
 static int vpe_reqbufs(struct file *file, void *priv,
 		       struct v4l2_requestbuffers *reqbufs)
 {
@@ -1674,6 +1821,9 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
 	.vidioc_try_fmt_vid_out_mplane	= vpe_try_fmt,
 	.vidioc_s_fmt_vid_out_mplane	= vpe_s_fmt,
 
+	.vidioc_g_selection		= vpe_g_selection,
+	.vidioc_s_selection		= vpe_s_selection,
+
 	.vidioc_reqbufs		= vpe_reqbufs,
 	.vidioc_querybuf	= vpe_querybuf,
 
-- 
1.8.3.2

