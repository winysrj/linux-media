Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:59052 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753695AbbGJI3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 04:29:34 -0400
From: Fabien Dessenne <fabien.dessenne@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	<hugues.fruchet@st.com>, <kernel@stlinux.com>
Subject: [PATCH 1/2] [media] bdisp: composing support
Date: Fri, 10 Jul 2015 10:29:22 +0200
Message-ID: <1436516962-28099-1-git-send-email-fabien.dessenne@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support the composing (at VIDEO_CAPTURE) with the _selection API.
v4l2-compliance successfully run ("test Composing: OK")

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 drivers/media/platform/sti/bdisp/bdisp-hw.c   |  8 +--
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 76 ++++++++++++++++++---------
 2 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
index 465828e..c83f9c2 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
@@ -336,8 +336,8 @@ static int bdisp_hw_get_hv_inc(struct bdisp_ctx *ctx, u16 *h_inc, u16 *v_inc)
 
 	src_w = ctx->src.crop.width;
 	src_h = ctx->src.crop.height;
-	dst_w = ctx->dst.width;
-	dst_h = ctx->dst.height;
+	dst_w = ctx->dst.crop.width;
+	dst_h = ctx->dst.crop.height;
 
 	if (bdisp_hw_get_inc(src_w, dst_w, h_inc) ||
 	    bdisp_hw_get_inc(src_h, dst_h, v_inc)) {
@@ -483,9 +483,9 @@ static void bdisp_hw_build_node(struct bdisp_ctx *ctx,
 	src_rect.width -= src_x_offset;
 	src_rect.width = min_t(__s32, MAX_SRC_WIDTH, src_rect.width);
 
-	dst_x_offset = (src_x_offset * dst->width) / ctx->src.crop.width;
+	dst_x_offset = (src_x_offset * dst_width) / ctx->src.crop.width;
 	dst_rect.left += dst_x_offset;
-	dst_rect.width = (src_rect.width * dst->width) / ctx->src.crop.width;
+	dst_rect.width = (src_rect.width * dst_width) / ctx->src.crop.width;
 
 	/* General */
 	src_fmt = src->fmt->pixelformat;
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 9e782eb..df61355 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -851,33 +851,56 @@ static int bdisp_g_selection(struct file *file, void *fh,
 	struct bdisp_frame *frame;
 	struct bdisp_ctx *ctx = fh_to_ctx(fh);
 
-	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		/* Composing  / capture is not supported */
-		dev_dbg(ctx->bdisp_dev->dev, "Not supported for capture\n");
-		return -EINVAL;
-	}
-
 	frame = ctx_get_frame(ctx, s->type);
 	if (IS_ERR(frame)) {
 		dev_err(ctx->bdisp_dev->dev, "Invalid frame (%p)\n", frame);
 		return PTR_ERR(frame);
 	}
 
-	switch (s->target) {
-	case V4L2_SEL_TGT_CROP:
-		/* cropped frame */
-		s->r = frame->crop;
+	switch (s->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		switch (s->target) {
+		case V4L2_SEL_TGT_CROP:
+			/* cropped frame */
+			s->r = frame->crop;
+			break;
+		case V4L2_SEL_TGT_CROP_DEFAULT:
+		case V4L2_SEL_TGT_CROP_BOUNDS:
+			/* complete frame */
+			s->r.left = 0;
+			s->r.top = 0;
+			s->r.width = frame->width;
+			s->r.height = frame->height;
+			break;
+		default:
+			dev_err(ctx->bdisp_dev->dev, "Invalid target\n");
+			return -EINVAL;
+		}
 		break;
-	case V4L2_SEL_TGT_CROP_DEFAULT:
-	case V4L2_SEL_TGT_CROP_BOUNDS:
-		/* complete frame */
-		s->r.left = 0;
-		s->r.top = 0;
-		s->r.width = frame->width;
-		s->r.height = frame->height;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		switch (s->target) {
+		case V4L2_SEL_TGT_COMPOSE:
+		case V4L2_SEL_TGT_COMPOSE_PADDED:
+			/* composed (cropped) frame */
+			s->r = frame->crop;
+			break;
+		case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+			/* complete frame */
+			s->r.left = 0;
+			s->r.top = 0;
+			s->r.width = frame->width;
+			s->r.height = frame->height;
+			break;
+		default:
+			dev_err(ctx->bdisp_dev->dev, "Invalid target\n");
+			return -EINVAL;
+		}
 		break;
+
 	default:
-		dev_dbg(ctx->bdisp_dev->dev, "Invalid target\n");
+		dev_err(ctx->bdisp_dev->dev, "Invalid type\n");
 		return -EINVAL;
 	}
 
@@ -906,15 +929,18 @@ static int bdisp_s_selection(struct file *file, void *fh,
 	struct bdisp_frame *frame;
 	struct bdisp_ctx *ctx = fh_to_ctx(fh);
 	struct v4l2_rect *in, out;
+	bool valid = false;
 
-	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		/* Composing  / capture is not supported */
-		dev_dbg(ctx->bdisp_dev->dev, "Not supported for capture\n");
-		return -EINVAL;
-	}
+	if ((s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) &&
+	    (s->target == V4L2_SEL_TGT_CROP))
+		valid = true;
+
+	if ((s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
+	    (s->target == V4L2_SEL_TGT_COMPOSE))
+		valid = true;
 
-	if (s->target != V4L2_SEL_TGT_CROP) {
-		dev_dbg(ctx->bdisp_dev->dev, "Invalid target\n");
+	if (!valid) {
+		dev_err(ctx->bdisp_dev->dev, "Invalid type / target\n");
 		return -EINVAL;
 	}
 
-- 
1.9.1

