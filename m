Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37965 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab1IAPaj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:30:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 01 Sep 2011 17:30:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 08/19 v4] s5p-fimc: Convert to the new control framework
In-reply-to: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1314891023-14227-9-git-send-email-s.nawrocki@samsung.com>
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the v4l controls code to use the new control framework.

fimc_ctrls_activate/deactivate functions are introduced for the
transparent DMA transfer mode (JPEG), where the rotation and flipping
controls are not supported.

The capture video node does not inherit sensors' controls when the
subdevs are configured by the user space (user_subdev_api == true).
However by default after the driver's initialization
the 'user-subdev_api' flag is false and any sensor controls will
also be available at the video node.

When the pipeline links are disconnected through the media device
the FIMC and any sensor inherited controls are destroyed and then
again created when the pipeline connection completes.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   61 +++---
 drivers/media/video/s5p-fimc/fimc-core.c    |  291 +++++++++++----------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   34 ++--
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   11 +-
 drivers/media/video/s5p-fimc/fimc-reg.c     |   32 +---
 5 files changed, 188 insertions(+), 241 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 562b23c..0c237a7 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -27,6 +27,7 @@
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
 
+#include "fimc-mdevice.h"
 #include "fimc-core.h"
 
 static void fimc_capture_state_cleanup(struct fimc_dev *fimc)
@@ -273,6 +274,31 @@ static struct vb2_ops fimc_capture_qops = {
 	.stop_streaming		= stop_streaming,
 };
 
+/**
+ * fimc_capture_ctrls_create - initialize the control handler
+ * Initialize the capture video node control handler and fill it
+ * with the FIMC controls. Inherit any sensor's controls if the
+ * 'user_subdev_api' flag is false (default behaviour).
+ * This function need to be called with the graph mutex held.
+ */
+int fimc_capture_ctrls_create(struct fimc_dev *fimc)
+{
+	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+	int ret;
+
+	if (WARN_ON(vid_cap->ctx == NULL))
+		return -ENXIO;
+	if (vid_cap->ctx->ctrls_rdy)
+		return 0;
+
+	ret = fimc_ctrls_create(vid_cap->ctx);
+	if (ret || vid_cap->user_subdev_api)
+		return ret;
+
+	return v4l2_ctrl_add_handler(&vid_cap->ctx->ctrl_handler,
+				    fimc->pipeline.sensor->ctrl_handler);
+}
+
 static int fimc_capture_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
@@ -293,9 +319,10 @@ static int fimc_capture_open(struct file *file)
 		return ret;
 	}
 
-	++fimc->vid_cap.refcnt;
+	if (++fimc->vid_cap.refcnt == 1)
+		ret = fimc_capture_ctrls_create(fimc);
 
-	return 0;
+	return ret;
 }
 
 static int fimc_capture_close(struct file *file)
@@ -306,6 +333,7 @@ static int fimc_capture_close(struct file *file)
 
 	if (--fimc->vid_cap.refcnt == 0) {
 		fimc_stop_capture(fimc);
+		fimc_ctrls_delete(fimc->vid_cap.ctx);
 		vb2_queue_release(&fimc->vid_cap.vbq);
 	}
 
@@ -546,30 +574,6 @@ static int fimc_cap_dqbuf(struct file *file, void *priv,
 	return vb2_dqbuf(&fimc->vid_cap.vbq, buf, file->f_flags & O_NONBLOCK);
 }
 
-static int fimc_cap_s_ctrl(struct file *file, void *priv,
-			   struct v4l2_control *ctrl)
-{
-	struct fimc_dev *fimc = video_drvdata(file);
-	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
-	int ret = -EINVAL;
-
-	/* Allow any controls but 90/270 rotation while streaming */
-	if (!fimc_capture_active(ctx->fimc_dev) ||
-	    ctrl->id != V4L2_CID_ROTATE ||
-	    (ctrl->value != 90 && ctrl->value != 270)) {
-		ret = check_ctrl_val(ctx, ctrl);
-		if (!ret) {
-			ret = fimc_s_ctrl(ctx, ctrl);
-			if (!ret)
-				ctx->state |= FIMC_PARAMS;
-		}
-	}
-	if (ret == -EINVAL)
-		ret = v4l2_subdev_call(ctx->fimc_dev->vid_cap.sd,
-				       core, s_ctrl, ctrl);
-	return ret;
-}
-
 static int fimc_cap_cropcap(struct file *file, void *fh,
 			    struct v4l2_cropcap *cr)
 {
@@ -656,10 +660,6 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_streamon		= fimc_cap_streamon,
 	.vidioc_streamoff		= fimc_cap_streamoff,
 
-	.vidioc_queryctrl		= fimc_vidioc_queryctrl,
-	.vidioc_g_ctrl			= fimc_vidioc_g_ctrl,
-	.vidioc_s_ctrl			= fimc_cap_s_ctrl,
-
 	.vidioc_g_crop			= fimc_cap_g_crop,
 	.vidioc_s_crop			= fimc_cap_s_crop,
 	.vidioc_cropcap			= fimc_cap_cropcap,
@@ -743,6 +743,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	if (ret)
 		goto err_ent;
 
+	vfd->ctrl_handler = &ctx->ctrl_handler;
 	return 0;
 
 err_ent:
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 8c2d0f4..69ba2cc 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -162,43 +162,6 @@ static struct fimc_fmt fimc_formats[] = {
 	},
 };
 
-static struct v4l2_queryctrl fimc_ctrls[] = {
-	{
-		.id		= V4L2_CID_HFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Horizontal flip",
-		.minimum	= 0,
-		.maximum	= 1,
-		.default_value	= 0,
-	}, {
-		.id		= V4L2_CID_VFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Vertical flip",
-		.minimum	= 0,
-		.maximum	= 1,
-		.default_value	= 0,
-	}, {
-		.id		= V4L2_CID_ROTATE,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Rotation (CCW)",
-		.minimum	= 0,
-		.maximum	= 270,
-		.step		= 90,
-		.default_value	= 0,
-	},
-};
-
-
-static struct v4l2_queryctrl *get_ctrl(int id)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(fimc_ctrls); ++i)
-		if (id == fimc_ctrls[i].id)
-			return &fimc_ctrls[i];
-	return NULL;
-}
-
 int fimc_check_scaler_ratio(int sw, int sh, int dw, int dh, int rot)
 {
 	int tx, ty;
@@ -777,6 +740,116 @@ static struct vb2_ops fimc_qops = {
 	.start_streaming = start_streaming,
 };
 
+/*
+ * V4L2 controls handling
+ */
+#define ctrl_to_ctx(__ctrl) \
+	container_of((__ctrl)->handler, struct fimc_ctx, ctrl_handler)
+
+static int fimc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct fimc_ctx *ctx = ctrl_to_ctx(ctrl);
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct samsung_fimc_variant *variant = fimc->variant;
+	unsigned long flags;
+	int ret = 0;
+
+	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		spin_lock_irqsave(&ctx->slock, flags);
+		ctx->hflip = ctrl->val;
+		break;
+
+	case V4L2_CID_VFLIP:
+		spin_lock_irqsave(&ctx->slock, flags);
+		ctx->vflip = ctrl->val;
+		break;
+
+	case V4L2_CID_ROTATE:
+		if (fimc_capture_pending(fimc) ||
+		    fimc_ctx_state_is_set(FIMC_DST_FMT | FIMC_SRC_FMT, ctx)) {
+			ret = fimc_check_scaler_ratio(ctx->s_frame.width,
+					ctx->s_frame.height, ctx->d_frame.width,
+					ctx->d_frame.height, ctrl->val);
+		}
+		if (ret) {
+			v4l2_err(fimc->m2m.vfd, "Out of scaler range\n");
+			return -EINVAL;
+		}
+		if ((ctrl->val == 90 || ctrl->val == 270) &&
+		    !variant->has_out_rot)
+			return -EINVAL;
+		spin_lock_irqsave(&ctx->slock, flags);
+		ctx->rotation = ctrl->val;
+		break;
+
+	default:
+		v4l2_err(fimc->v4l2_dev, "Invalid control: 0x%X\n", ctrl->id);
+		return -EINVAL;
+	}
+	ctx->state |= FIMC_PARAMS;
+	set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
+	spin_unlock_irqrestore(&ctx->slock, flags);
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops fimc_ctrl_ops = {
+	.s_ctrl = fimc_s_ctrl,
+};
+
+int fimc_ctrls_create(struct fimc_ctx *ctx)
+{
+	if (ctx->ctrls_rdy)
+		return 0;
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
+
+	ctx->ctrl_rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
+				     V4L2_CID_HFLIP, 0, 1, 1, 0);
+	ctx->ctrl_hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
+				    V4L2_CID_VFLIP, 0, 1, 1, 0);
+	ctx->ctrl_vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
+				    V4L2_CID_ROTATE, 0, 270, 90, 0);
+	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
+
+	return ctx->ctrl_handler.error;
+}
+
+void fimc_ctrls_delete(struct fimc_ctx *ctx)
+{
+	if (ctx->ctrls_rdy) {
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		ctx->ctrls_rdy = false;
+	}
+}
+
+void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active)
+{
+	if (!ctx->ctrls_rdy)
+		return;
+
+	mutex_lock(&ctx->ctrl_handler.lock);
+	v4l2_ctrl_activate(ctx->ctrl_rotate, active);
+	v4l2_ctrl_activate(ctx->ctrl_hflip, active);
+	v4l2_ctrl_activate(ctx->ctrl_vflip, active);
+
+	if (active) {
+		ctx->rotation = ctx->ctrl_rotate->val;
+		ctx->hflip    = ctx->ctrl_hflip->val;
+		ctx->vflip    = ctx->ctrl_vflip->val;
+	} else {
+		ctx->rotation = 0;
+		ctx->hflip    = 0;
+		ctx->vflip    = 0;
+	}
+	mutex_unlock(&ctx->ctrl_handler.lock);
+}
+
+/*
+ * V4L2 ioctl handlers
+ */
 static int fimc_m2m_querycap(struct file *file, void *fh,
 			     struct v4l2_capability *cap)
 {
@@ -1073,136 +1146,6 @@ static int fimc_m2m_streamoff(struct file *file, void *fh,
 	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
 }
 
-int fimc_vidioc_queryctrl(struct file *file, void *fh,
-			  struct v4l2_queryctrl *qc)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct v4l2_queryctrl *c;
-	int ret = -EINVAL;
-
-	c = get_ctrl(qc->id);
-	if (c) {
-		*qc = *c;
-		return 0;
-	}
-
-	if (fimc_ctx_state_is_set(FIMC_CTX_CAP, ctx)) {
-		return v4l2_subdev_call(ctx->fimc_dev->vid_cap.sd,
-					core, queryctrl, qc);
-	}
-	return ret;
-}
-
-int fimc_vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *ctrl)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	struct fimc_dev *fimc = ctx->fimc_dev;
-
-	switch (ctrl->id) {
-	case V4L2_CID_HFLIP:
-		ctrl->value = (FLIP_X_AXIS & ctx->flip) ? 1 : 0;
-		break;
-	case V4L2_CID_VFLIP:
-		ctrl->value = (FLIP_Y_AXIS & ctx->flip) ? 1 : 0;
-		break;
-	case V4L2_CID_ROTATE:
-		ctrl->value = ctx->rotation;
-		break;
-	default:
-		if (fimc_ctx_state_is_set(FIMC_CTX_CAP, ctx)) {
-			return v4l2_subdev_call(fimc->vid_cap.sd, core,
-						g_ctrl, ctrl);
-		} else {
-			v4l2_err(fimc->m2m.vfd, "Invalid control\n");
-			return -EINVAL;
-		}
-	}
-	dbg("ctrl->value= %d", ctrl->value);
-
-	return 0;
-}
-
-int check_ctrl_val(struct fimc_ctx *ctx,  struct v4l2_control *ctrl)
-{
-	struct v4l2_queryctrl *c;
-	c = get_ctrl(ctrl->id);
-	if (!c)
-		return -EINVAL;
-
-	if (ctrl->value < c->minimum || ctrl->value > c->maximum
-		|| (c->step != 0 && ctrl->value % c->step != 0)) {
-		v4l2_err(ctx->fimc_dev->m2m.vfd, "Invalid control value\n");
-		return -ERANGE;
-	}
-
-	return 0;
-}
-
-int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
-{
-	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	int ret = 0;
-
-	switch (ctrl->id) {
-	case V4L2_CID_HFLIP:
-		if (ctrl->value)
-			ctx->flip |= FLIP_X_AXIS;
-		else
-			ctx->flip &= ~FLIP_X_AXIS;
-		break;
-
-	case V4L2_CID_VFLIP:
-		if (ctrl->value)
-			ctx->flip |= FLIP_Y_AXIS;
-		else
-			ctx->flip &= ~FLIP_Y_AXIS;
-		break;
-
-	case V4L2_CID_ROTATE:
-		if (fimc_ctx_state_is_set(FIMC_DST_FMT | FIMC_SRC_FMT, ctx)) {
-			ret = fimc_check_scaler_ratio(ctx->s_frame.width,
-					ctx->s_frame.height, ctx->d_frame.width,
-					ctx->d_frame.height, ctrl->value);
-		}
-
-		if (ret) {
-			v4l2_err(fimc->m2m.vfd, "Out of scaler range\n");
-			return -EINVAL;
-		}
-
-		/* Check for the output rotator availability */
-		if ((ctrl->value == 90 || ctrl->value == 270) &&
-		    (ctx->in_path == FIMC_DMA && !variant->has_out_rot))
-			return -EINVAL;
-		ctx->rotation = ctrl->value;
-		break;
-
-	default:
-		v4l2_err(fimc->v4l2_dev, "Invalid control\n");
-		return -EINVAL;
-	}
-
-	fimc_ctx_state_lock_set(FIMC_PARAMS, ctx);
-
-	return 0;
-}
-
-static int fimc_m2m_s_ctrl(struct file *file, void *fh,
-			   struct v4l2_control *ctrl)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	int ret = 0;
-
-	ret = check_ctrl_val(ctx, ctrl);
-	if (ret)
-		return ret;
-
-	ret = fimc_s_ctrl(ctx, ctrl);
-	return 0;
-}
-
 static int fimc_m2m_cropcap(struct file *file, void *fh,
 			    struct v4l2_cropcap *cr)
 {
@@ -1368,10 +1311,6 @@ static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
 	.vidioc_streamon		= fimc_m2m_streamon,
 	.vidioc_streamoff		= fimc_m2m_streamoff,
 
-	.vidioc_queryctrl		= fimc_vidioc_queryctrl,
-	.vidioc_g_ctrl			= fimc_vidioc_g_ctrl,
-	.vidioc_s_ctrl			= fimc_m2m_s_ctrl,
-
 	.vidioc_g_crop			= fimc_m2m_g_crop,
 	.vidioc_s_crop			= fimc_m2m_s_crop,
 	.vidioc_cropcap			= fimc_m2m_cropcap
@@ -1427,7 +1366,12 @@ static int fimc_m2m_open(struct file *file)
 	if (!ctx)
 		return -ENOMEM;
 	v4l2_fh_init(&ctx->fh, fimc->m2m.vfd);
+	ret = fimc_ctrls_create(ctx);
+	if (ret)
+		goto error_fh;
 
+	/* Use separate control handler per file handle */
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
 
@@ -1445,13 +1389,15 @@ static int fimc_m2m_open(struct file *file)
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(fimc->m2m.m2m_dev, ctx, queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
 		ret = PTR_ERR(ctx->m2m_ctx);
-		goto error_fh;
+		goto error_c;
 	}
 
 	if (fimc->m2m.refcnt++ == 0)
 		set_bit(ST_M2M_RUN, &fimc->state);
 	return 0;
 
+error_c:
+	fimc_ctrls_delete(ctx);
 error_fh:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
@@ -1468,6 +1414,7 @@ static int fimc_m2m_release(struct file *file)
 		task_pid_nr(current), fimc->state, fimc->m2m.refcnt);
 
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	fimc_ctrls_delete(ctx);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 22009fe..1825e33 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -20,6 +20,7 @@
 
 #include <media/media-entity.h>
 #include <media/videobuf2-core.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-mediabus.h>
@@ -62,6 +63,7 @@ enum fimc_dev_flags {
 	ST_CAPT_STREAM,
 	ST_CAPT_SHUT,
 	ST_CAPT_BUSY,
+	ST_CAPT_APPLY_CFG,
 };
 
 #define fimc_m2m_active(dev) test_bit(ST_M2M_RUN, &(dev)->state)
@@ -128,11 +130,6 @@ enum fimc_color_fmt {
 /* Y (16 ~ 235), Cb/Cr (16 ~ 240) */
 #define	FIMC_COLOR_RANGE_NARROW		(1 << 3)
 
-#define	FLIP_NONE			0
-#define	FLIP_X_AXIS			1
-#define	FLIP_Y_AXIS			2
-#define	FLIP_XY_AXIS			(FLIP_X_AXIS | FLIP_Y_AXIS)
-
 /**
  * struct fimc_fmt - the driver's internal color format data
  * @mbus_code: Media Bus pixel code, -1 if not applicable
@@ -455,12 +452,18 @@ struct fimc_dev {
  * @scaler:		image scaler properties
  * @effect:		image effect
  * @rotation:		image clockwise rotation in degrees
- * @flip:		image flip mode
+ * @hflip:		indicates image horizontal flip if set
+ * @vflip:		indicates image vertical flip if set
  * @flags:		additional flags for image conversion
  * @state:		flags to keep track of user configuration
  * @fimc_dev:		the FIMC device this context applies to
  * @m2m_ctx:		memory-to-memory device context
  * @fh:			v4l2 file handle
+ * @ctrl_handler:	v4l2 controls handler
+ * @ctrl_rotate		image rotation control
+ * @ctrl_hflip		horizontal flip control
+ * @ctrl_vflip		vartical flip control
+ * @ctrls_rdy:		true if the control handler is initialized
  */
 struct fimc_ctx {
 	spinlock_t		slock;
@@ -475,12 +478,18 @@ struct fimc_ctx {
 	struct fimc_scaler	scaler;
 	struct fimc_effect	effect;
 	int			rotation;
-	u32			flip;
+	unsigned int		hflip:1;
+	unsigned int		vflip:1;
 	u32			flags;
 	u32			state;
 	struct fimc_dev		*fimc_dev;
 	struct v4l2_m2m_ctx	*m2m_ctx;
 	struct v4l2_fh		fh;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl	*ctrl_rotate;
+	struct v4l2_ctrl	*ctrl_hflip;
+	struct v4l2_ctrl	*ctrl_vflip;
+	bool			ctrls_rdy;
 };
 
 #define fh_to_ctx(__fh) container_of(__fh, struct fimc_ctx, fh)
@@ -636,15 +645,11 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 /* fimc-core.c */
 int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
 				struct v4l2_fmtdesc *f);
-int fimc_vidioc_queryctrl(struct file *file, void *priv,
-			  struct v4l2_queryctrl *qc);
-int fimc_vidioc_g_ctrl(struct file *file, void *priv,
-		       struct v4l2_control *ctrl);
-
 int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f);
 int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr);
-int check_ctrl_val(struct fimc_ctx *ctx,  struct v4l2_control *ctrl);
-int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl);
+int fimc_ctrls_create(struct fimc_ctx *ctx);
+void fimc_ctrls_delete(struct fimc_ctx *ctx);
+void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active);
 int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f);
 
 struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask);
@@ -667,6 +672,7 @@ void fimc_unregister_driver(void);
 int fimc_register_capture_device(struct fimc_dev *fimc,
 				 struct v4l2_device *v4l2_dev);
 void fimc_unregister_capture_device(struct fimc_dev *fimc);
+int fimc_capture_ctrls_create(struct fimc_dev *fimc);
 int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
 			     struct fimc_vid_buffer *fimc_vb);
 int fimc_capture_suspend(struct fimc_dev *fimc);
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 50f3fca..13ce2a4 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/version.h>
+#include <media/v4l2-ctrls.h>
 #include <media/media-device.h>
 
 #include "fimc-core.h"
@@ -649,15 +650,23 @@ static int fimc_md_link_notify(struct media_pad *source,
 		ret = __fimc_pipeline_shutdown(fimc);
 		fimc->pipeline.sensor = NULL;
 		fimc->pipeline.csis = NULL;
+
+		mutex_lock(&fimc->lock);
+		fimc_ctrls_delete(fimc->vid_cap.ctx);
+		mutex_unlock(&fimc->lock);
 		return ret;
 	}
 	/*
 	 * Link activation. Enable power of pipeline elements only if the
 	 * pipeline is already in use, i.e. its video node is opened.
+	 * Recreate the controls destroyed during the link deactivation.
 	 */
 	mutex_lock(&fimc->lock);
-	if (fimc->vid_cap.refcnt > 0)
+	if (fimc->vid_cap.refcnt > 0) {
 		ret = __fimc_pipeline_initialize(fimc, source->entity, true);
+		if (!ret)
+			ret = fimc_capture_ctrls_create(fimc);
+	}
 	mutex_unlock(&fimc->lock);
 
 	return ret ? -EPIPE : ret;
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index c688263..50937b4 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -41,19 +41,11 @@ static u32 fimc_hw_get_in_flip(struct fimc_ctx *ctx)
 {
 	u32 flip = S5P_MSCTRL_FLIP_NORMAL;
 
-	switch (ctx->flip) {
-	case FLIP_X_AXIS:
+	if (ctx->hflip)
 		flip = S5P_MSCTRL_FLIP_X_MIRROR;
-		break;
-	case FLIP_Y_AXIS:
+	if (ctx->vflip)
 		flip = S5P_MSCTRL_FLIP_Y_MIRROR;
-		break;
-	case FLIP_XY_AXIS:
-		flip = S5P_MSCTRL_FLIP_180;
-		break;
-	default:
-		break;
-	}
+
 	if (ctx->rotation <= 90)
 		return flip;
 
@@ -64,19 +56,11 @@ static u32 fimc_hw_get_target_flip(struct fimc_ctx *ctx)
 {
 	u32 flip = S5P_CITRGFMT_FLIP_NORMAL;
 
-	switch (ctx->flip) {
-	case FLIP_X_AXIS:
-		flip = S5P_CITRGFMT_FLIP_X_MIRROR;
-		break;
-	case FLIP_Y_AXIS:
-		flip = S5P_CITRGFMT_FLIP_Y_MIRROR;
-		break;
-	case FLIP_XY_AXIS:
-		flip = S5P_CITRGFMT_FLIP_180;
-		break;
-	default:
-		break;
-	}
+	if (ctx->hflip)
+		flip |= S5P_CITRGFMT_FLIP_X_MIRROR;
+	if (ctx->vflip)
+		flip |= S5P_CITRGFMT_FLIP_Y_MIRROR;
+
 	if (ctx->rotation <= 90)
 		return flip;
 
-- 
1.7.6

