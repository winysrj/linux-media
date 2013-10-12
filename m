Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:51971 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3JLMc1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 08:32:27 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	p.zabel@pengutronix.de, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 08/10] exynos-gsc: Remove GSC_{SRC, DST}_FMT flags
Date: Sat, 12 Oct 2013 14:31:58 +0200
Message-Id: <1381581120-26883-9-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
References: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The GSC_SRC_FMT, GSC_DST_FMT flags are currently set in VIDIOC_S_FMT ioctl
and cleared in VIDIOC_REQBUFS(0). In between the flags are used to figure out
if scaling ratio check need to be performed. This an incorrect behaviour as
it should be assumed there is always a valid configuration on a video device.
Fix this by removing those flags and also remove an unused 'frame' local
variable.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |   10 ++----
 drivers/media/platform/exynos-gsc/gsc-core.h |    2 -
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |   46 +++++++++-----------------
 3 files changed, 19 insertions(+), 39 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 9d0cc04..d0bba73 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -698,7 +698,6 @@ static int __gsc_s_ctrl(struct gsc_ctx *ctx, struct v4l2_ctrl *ctrl)
 {
 	struct gsc_dev *gsc = ctx->gsc_dev;
 	struct gsc_variant *variant = gsc->variant;
-	unsigned int flags = GSC_DST_FMT | GSC_SRC_FMT;
 	int ret = 0;
 
 	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
@@ -714,18 +713,15 @@ static int __gsc_s_ctrl(struct gsc_ctx *ctx, struct v4l2_ctrl *ctrl)
 		break;
 
 	case V4L2_CID_ROTATE:
-		if ((ctx->state & flags) == flags) {
-			ret = gsc_check_scaler_ratio(variant,
+		ret = gsc_check_scaler_ratio(variant,
 					ctx->s_frame.crop.width,
 					ctx->s_frame.crop.height,
 					ctx->d_frame.crop.width,
 					ctx->d_frame.crop.height,
 					ctx->gsc_ctrls.rotate->val,
 					ctx->out_path);
-
-			if (ret)
-				return -EINVAL;
-		}
+		if (ret < 0)
+			return ret;
 
 		ctx->rotation = ctrl->val;
 		break;
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 76435d3..c79b3cb 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -41,8 +41,6 @@
 #define DEFAULT_CSC_RANGE		1
 
 #define GSC_PARAMS			(1 << 0)
-#define GSC_SRC_FMT			(1 << 1)
-#define GSC_DST_FMT			(1 << 2)
 #define GSC_CTX_M2M			(1 << 3)
 #define GSC_CTX_STOP_REQ		(1 << 6)
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 48e1c34..78bcb92 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -341,11 +341,7 @@ static int gsc_m2m_s_fmt_mplane(struct file *file, void *fh,
 		frame->payload[i] = pix->plane_fmt[i].sizeimage;
 
 	gsc_set_frame_size(frame, pix->width, pix->height);
-
-	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		gsc_ctx_state_lock_set(GSC_PARAMS | GSC_DST_FMT, ctx);
-	else
-		gsc_ctx_state_lock_set(GSC_PARAMS | GSC_SRC_FMT, ctx);
+	gsc_ctx_state_lock_set(GSC_PARAMS, ctx);
 
 	pr_debug("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
 
@@ -357,22 +353,14 @@ static int gsc_m2m_reqbufs(struct file *file, void *fh,
 {
 	struct gsc_ctx *ctx = fh_to_ctx(fh);
 	struct gsc_dev *gsc = ctx->gsc_dev;
-	struct gsc_frame *frame;
 	u32 max_cnt;
 
 	max_cnt = (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
 		gsc->variant->in_buf_cnt : gsc->variant->out_buf_cnt;
 	if (reqbufs->count > max_cnt) {
 		return -EINVAL;
-	} else if (reqbufs->count == 0) {
-		if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-			gsc_ctx_state_lock_clear(GSC_SRC_FMT, ctx);
-		else
-			gsc_ctx_state_lock_clear(GSC_DST_FMT, ctx);
 	}
 
-	frame = ctx_get_frame(ctx, reqbufs->type);
-
 	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
 }
 
@@ -527,24 +515,22 @@ static int gsc_m2m_s_selection(struct file *file, void *fh,
 	}
 
 	/* Check to see if scaling ratio is within supported range */
-	if (gsc_ctx_state_is_set(GSC_DST_FMT | GSC_SRC_FMT, ctx)) {
-		if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-			ret = gsc_check_scaler_ratio(variant, cr.c.width,
-				cr.c.height, ctx->d_frame.crop.width,
-				ctx->d_frame.crop.height,
-				ctx->gsc_ctrls.rotate->val, ctx->out_path);
-		} else {
-			ret = gsc_check_scaler_ratio(variant,
-				ctx->s_frame.crop.width,
-				ctx->s_frame.crop.height, cr.c.width,
-				cr.c.height, ctx->gsc_ctrls.rotate->val,
-				ctx->out_path);
-		}
+	if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = gsc_check_scaler_ratio(variant, cr.c.width,
+			cr.c.height, ctx->d_frame.crop.width,
+			ctx->d_frame.crop.height,
+			ctx->gsc_ctrls.rotate->val, ctx->out_path);
+	} else {
+		ret = gsc_check_scaler_ratio(variant,
+			ctx->s_frame.crop.width,
+			ctx->s_frame.crop.height, cr.c.width,
+			cr.c.height, ctx->gsc_ctrls.rotate->val,
+			ctx->out_path);
+	}
 
-		if (ret) {
-			pr_err("Out of scaler range");
-			return -EINVAL;
-		}
+	if (ret < 0) {
+		pr_err("Out of scaler range");
+		return ret;
 	}
 
 	frame->crop = cr.c;
-- 
1.7.4.1

