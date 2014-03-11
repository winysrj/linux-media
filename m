Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45753 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbaCKIfH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 04:35:07 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 07/14] v4l: ti-vpe: Add selection API in VPE driver
Date: Tue, 11 Mar 2014 14:03:46 +0530
Message-ID: <1394526833-24805-8-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-1-git-send-email-archit@ti.com>
References: <1393922965-15967-1-git-send-email-archit@ti.com>
 <1394526833-24805-1-git-send-email-archit@ti.com>
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
 drivers/media/platform/ti-vpe/vpe.c | 141 ++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index ece9b96..4abb85c 100644
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
@@ -1587,6 +1589,142 @@ static int vpe_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
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
+		 * COMPOSE target is only valid for capture buffer type, for
+		 * output buffer type, assign existing crop parameters to the
+		 * selection rectangle
+		 */
+		if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			break;
+
+		s->r = q_data->c_rect;
+		return 0;
+
+	case V4L2_SEL_TGT_CROP:
+		/*
+		 * CROP target is only valid for output buffer type, for capture
+		 * buffer type, assign existing compose parameters to the
+		 * selection rectangle
+		 */
+		if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			break;
+
+		s->r = q_data->c_rect;
+		return 0;
+
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
+	/* return width and height from S_FMT of the respective buffer type */
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = q_data->width;
+		s->r.height = q_data->height;
+		return 0;
+
+	/*
+	 * CROP target holds for the output buffer type, and COMPOSE target
+	 * holds for the capture buffer type. We still return the c_rect params
+	 * for both the target types.
+	 */
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_CROP:
+		s->r.left = q_data->c_rect.left;
+		s->r.top = q_data->c_rect.top;
+		s->r.width = q_data->c_rect.width;
+		s->r.height = q_data->c_rect.height;
+		return 0;
+	}
+
+	return -EINVAL;
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
@@ -1674,6 +1812,9 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
 	.vidioc_try_fmt_vid_out_mplane	= vpe_try_fmt,
 	.vidioc_s_fmt_vid_out_mplane	= vpe_s_fmt,
 
+	.vidioc_g_selection		= vpe_g_selection,
+	.vidioc_s_selection		= vpe_s_selection,
+
 	.vidioc_reqbufs		= vpe_reqbufs,
 	.vidioc_querybuf	= vpe_querybuf,
 
-- 
1.8.3.2

