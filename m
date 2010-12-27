Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:43796 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab0L0Jin (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 04:38:43 -0500
From: Hyunwoong Kim <khw0178.kim@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, Hyunwoong Kim <khw0178.kim@samsung.com>
Subject: [PATCH] [media] s5p-fimc: update checking scaling ratio range
Date: Mon, 27 Dec 2010 18:17:51 +0900
Message-Id: <1293441471-23257-1-git-send-email-khw0178.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Horizontal and vertical scaling range are according to the following equations.
If (SRC_Width >= 64 x DST_Width) { Exit(-1);  /* Out of Horizontal scale range}
If (SRC_Height >= 64 x DST_Height) { Exit(-1);  /* Out of Vertical scale range}

fimc_check_scaler_ratio() is used to check if horizontal and vertical
scale range are valid or not. To use fimc_check_scaler_ratio,
source and destination format should be set by VIDIOC_S_FMT.
And in case of scaling up, it doesn't have to check the scale range.

Reviewed-by: Jonghun Han <jonghun.han@samsung.com>
Signed-off-by: Hyunwoong Kim <khw0178.kim@samsung.com>
---
This patch is depended on Hyunwoong Kim's last patch.
- [PATCH v2] [media] s5p-fimc: Configure scaler registers depending on FIMC version

 drivers/media/video/s5p-fimc/fimc-capture.c |    5 ++-
 drivers/media/video/s5p-fimc/fimc-core.c    |   66 +++++++++++++++++++--------
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +-
 3 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index b1cb937..078e5ab 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -744,6 +744,7 @@ static int fimc_cap_s_crop(struct file *file, void *fh,
 	struct fimc_frame *f;
 	struct fimc_ctx *ctx = file->private_data;
 	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct v4l2_rect r;
 	int ret = -EINVAL;
 
 	if (fimc_capture_active(fimc))
@@ -761,7 +762,9 @@ static int fimc_cap_s_crop(struct file *file, void *fh,
 
 	f = &ctx->s_frame;
 	/* Check for the pixel scaling ratio when cropping input image. */
-	ret = fimc_check_scaler_ratio(&cr->c, &ctx->d_frame);
+	r.width = ctx->d_frame.width;
+	r.height = ctx->d_frame.height;
+	ret = fimc_check_scaler_ratio(&cr->c, &r,  ctx->rotation);
 	if (ret) {
 		v4l2_err(&fimc->vid_cap.v4l2_dev, "Out of the scaler range");
 		return ret;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 2b65961..cc5c28f 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -198,24 +198,24 @@ static struct v4l2_queryctrl *get_ctrl(int id)
 	return NULL;
 }
 
-int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f)
+int fimc_check_scaler_ratio(struct v4l2_rect *s, struct v4l2_rect *d, int rot)
 {
-	if (r->width > f->width) {
-		if (f->width > (r->width * SCALER_MAX_HRATIO))
-			return -EINVAL;
-	} else {
-		if ((f->width * SCALER_MAX_HRATIO) < r->width)
-			return -EINVAL;
-	}
+	int tx, ty, sx, sy;
 
-	if (r->height > f->height) {
-		if (f->height > (r->height * SCALER_MAX_VRATIO))
-			return -EINVAL;
+	sx = s->width;
+	sy = s->height;
+
+	if (rot == 90 || rot == 270) {
+		ty = d->width;
+		tx = d->height;
 	} else {
-		if ((f->height * SCALER_MAX_VRATIO) < r->height)
-			return -EINVAL;
+		tx = d->width;
+		ty = d->height;
 	}
 
+	if ((sx >= SCALER_MAX_HRATIO * tx) || (sy >= SCALER_MAX_VRATIO * ty))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -1062,7 +1062,9 @@ int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
 {
 	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
 	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct v4l2_rect s, d;
 	unsigned long flags;
+	int ret = 0;
 
 	if (ctx->rotation != 0 &&
 	    (ctrl->id == V4L2_CID_HFLIP || ctrl->id == V4L2_CID_VFLIP)) {
@@ -1089,6 +1091,21 @@ int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
 		break;
 
 	case V4L2_CID_ROTATE:
+		if (!(~ctx->state & (FIMC_DST_FMT | FIMC_SRC_FMT))) {
+			s.width = ctx->s_frame.width;
+			s.height = ctx->s_frame.height;
+
+			d.width = ctx->d_frame.width;
+			d.height = ctx->d_frame.height;
+
+			ret = fimc_check_scaler_ratio(&s, &d, ctrl->value);
+			if (ret) {
+				v4l2_err(&fimc->m2m.v4l2_dev, "Out of scaler range");
+				spin_unlock_irqrestore(&ctx->slock, flags);
+				return -EINVAL;
+			}
+		}
+
 		/* Check for the output rotator availability */
 		if ((ctrl->value == 90 || ctrl->value == 270) &&
 		    (ctx->in_path == FIMC_DMA && !variant->has_out_rot)) {
@@ -1227,6 +1244,7 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	unsigned long flags;
 	struct fimc_frame *f;
+	struct v4l2_rect s, d;
 	int ret;
 
 	ret = fimc_try_crop(ctx, cr);
@@ -1237,18 +1255,28 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 		&ctx->s_frame : &ctx->d_frame;
 
 	spin_lock_irqsave(&ctx->slock, flags);
-	if (~ctx->state & (FIMC_SRC_FMT | FIMC_DST_FMT)) {
-		/* Check to see if scaling ratio is within supported range */
-		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-			ret = fimc_check_scaler_ratio(&cr->c, &ctx->d_frame);
-		else
-			ret = fimc_check_scaler_ratio(&cr->c, &ctx->s_frame);
+	/* Check to see if scaling ratio is within supported range */
+	if (!(~ctx->state & (FIMC_DST_FMT | FIMC_SRC_FMT))) {
+		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+			s.width = cr->c.width;
+			s.height = cr->c.height;
+			d.width = ctx->d_frame.width;
+			d.height = ctx->d_frame.height;
+		} else {
+			s.width = ctx->s_frame.width;
+			s.height = ctx->s_frame.height;
+			d.width = cr->c.width;
+			d.height = cr->c.height;
+		}
+
+		ret = fimc_check_scaler_ratio(&s, &d, ctx->rotation);
 		if (ret) {
 			v4l2_err(&fimc->m2m.v4l2_dev, "Out of scaler range");
 			spin_unlock_irqrestore(&ctx->slock, flags);
 			return -EINVAL;
 		}
 	}
+
 	ctx->state |= FIMC_PARAMS;
 
 	f->offs_h = cr->c.left;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index d690398..f7a72a3 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -605,7 +605,7 @@ struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask);
 struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
 				  unsigned int mask);
 
-int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f);
+int fimc_check_scaler_ratio(struct v4l2_rect *s, struct v4l2_rect *d, int rot);
 int fimc_set_scaler_info(struct fimc_ctx *ctx);
 int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
 int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
-- 
1.6.2.5

