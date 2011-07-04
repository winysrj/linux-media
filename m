Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58946 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180Ab1GDRzq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 13:55:46 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 04 Jul 2011 19:55:05 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 14/19] s5p-fimc: Convert to use media pipeline operations
In-reply-to: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1309802110-16682-15-git-send-email-s.nawrocki@samsung.com>
References: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add format negotiation routine for sensor subdevs not exposing
a device node.
TRY_FMT ioctl is completed by a subsequent patch adding the
capture subdev. This way the try_fmt routines can be common
for the subdev and the video node.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  109 +++++++++--------------
 drivers/media/video/s5p-fimc/fimc-core.c    |  125 +++++++++++++++------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   14 ++-
 drivers/media/video/s5p-fimc/fimc-reg.c     |    8 +-
 4 files changed, 125 insertions(+), 131 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index fb0d89a..ecb0246 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -74,11 +74,9 @@ static int fimc_start_capture(struct fimc_dev *fimc)
 
 static int fimc_stop_capture(struct fimc_dev *fimc)
 {
-	unsigned long flags;
-	struct fimc_vid_cap *cap;
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_vid_buffer *buf;
-
-	cap = &fimc->vid_cap;
+	unsigned long flags;
 
 	if (!fimc_capture_active(fimc))
 		return 0;
@@ -92,11 +90,10 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 			   !test_bit(ST_CAPT_SHUT, &fimc->state),
 			   FIMC_SHUTDOWN_TIMEOUT);
 
-	v4l2_subdev_call(cap->sd, video, s_stream, 0);
-
 	spin_lock_irqsave(&fimc->slock, flags);
 	fimc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_PEND |
-			 1 << ST_CAPT_SHUT | 1 << ST_CAPT_STREAM);
+			 1 << ST_CAPT_SHUT | 1 << ST_CAPT_STREAM |
+			 1 << ST_CAPT_ISP_STREAM);
 
 	fimc->vid_cap.active_buf_cnt = 0;
 
@@ -112,9 +109,9 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 	}
 
 	spin_unlock_irqrestore(&fimc->slock, flags);
-
 	dbg("state: 0x%lx", fimc->state);
-	return 0;
+
+	return fimc_pipeline_s_stream(fimc, 0);
 }
 
 int fimc_capture_suspend(struct fimc_dev *fimc)
@@ -197,15 +194,13 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 
 	for (i = 0; i < ctx->d_frame.fmt->memplanes; i++) {
-		unsigned long size = get_plane_size(&ctx->d_frame, i);
-
+		unsigned long size = ctx->d_frame.payload[i];
 		if (vb2_plane_size(vb, i) < size) {
 			v4l2_err(ctx->fimc_dev->vid_cap.vfd,
 				 "User buffer too small (%ld < %ld)\n",
 				 vb2_plane_size(vb, i), size);
 			return -EINVAL;
 		}
-
 		vb2_set_plane_payload(vb, i, size);
 	}
 
@@ -214,10 +209,10 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_vid_buffer *buf
 		= container_of(vb, struct fimc_vid_buffer, vb);
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
 	unsigned long flags;
 	int min_bufs;
@@ -244,9 +239,14 @@ static void buffer_queue(struct vb2_buffer *vb)
 	min_bufs = vid_cap->reqbufs_count > 1 ? 2 : 1;
 
 	if (vid_cap->active_buf_cnt >= min_bufs &&
-	    !test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
+	    !test_and_set_bit(ST_CAPT_STREAM, &fimc->state)) {
 		fimc_activate_capture(ctx);
+		spin_unlock_irqrestore(&fimc->slock, flags);
 
+		if (!test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
+			fimc_pipeline_s_stream(fimc, 1);
+		return;
+	}
 	spin_unlock_irqrestore(&fimc->slock, flags);
 }
 
@@ -309,15 +309,21 @@ static int fimc_capture_open(struct file *file)
 	if (fimc_m2m_active(fimc))
 		return -EBUSY;
 
-	ret = pm_runtime_get_sync(&fimc->pdev->dev);
-	if (ret < 0) {
-		v4l2_fh_release(file);
-		return ret;
-	}
-
-	if (++fimc->vid_cap.refcnt == 1)
+	pm_runtime_get_sync(&fimc->pdev->dev);
+
+	if (++fimc->vid_cap.refcnt == 1) {
+		ret = fimc_pipeline_initialize(fimc,
+			       &fimc->vid_cap.vfd->entity, true);
+		if (ret < 0) {
+			dev_err(&fimc->pdev->dev,
+				"Video pipeline initialization failed\n");
+			pm_runtime_put_sync(&fimc->pdev->dev);
+			fimc->vid_cap.refcnt--;
+			v4l2_fh_release(file);
+			return ret;
+		}
 		ret = fimc_capture_ctrls_create(fimc);
-
+	}
 	return ret;
 }
 
@@ -329,10 +335,10 @@ static int fimc_capture_close(struct file *file)
 
 	if (--fimc->vid_cap.refcnt == 0) {
 		fimc_stop_capture(fimc);
+		fimc_pipeline_shutdown(fimc);
 		fimc_ctrls_delete(fimc->vid_cap.ctx);
 		vb2_queue_release(&fimc->vid_cap.vbq);
 	}
-
 	pm_runtime_put_sync(&fimc->pdev->dev);
 	return v4l2_fh_release(file);
 }
@@ -392,41 +398,11 @@ static int fimc_cap_enum_fmt_mplane(struct file *file, void *priv,
 	return 0;
 }
 
-/* Synchronize formats of the camera interface input and attached  sensor. */
-static int sync_capture_fmt(struct fimc_ctx *ctx)
-{
-	struct fimc_frame *frame = &ctx->s_frame;
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct v4l2_mbus_framefmt *fmt = &fimc->vid_cap.fmt;
-	int ret;
 
-	fmt->width  = ctx->d_frame.o_width;
-	fmt->height = ctx->d_frame.o_height;
 
-	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_mbus_fmt, fmt);
-	if (ret == -ENOIOCTLCMD) {
-		err("s_mbus_fmt failed");
-		return ret;
-	}
-	dbg("w: %d, h: %d, code= %d", fmt->width, fmt->height, fmt->code);
 
-	frame->fmt = fimc_find_format(NULL, &fmt->code, FMT_FLAGS_CAM, -1);
-	if (!frame->fmt) {
-		err("fimc source format not found\n");
-		return -EINVAL;
-	}
 
-	frame->f_width	= fmt->width;
-	frame->f_height = fmt->height;
-	frame->width	= fmt->width;
-	frame->height	= fmt->height;
-	frame->o_width	= fmt->width;
-	frame->o_height = fmt->height;
-	frame->offs_h	= 0;
-	frame->offs_v	= 0;
 
-	return 0;
-}
 
 static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
 				 struct v4l2_format *f)
@@ -446,7 +422,7 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 
-	return fimc_try_fmt_mplane(ctx, f);
+	return 0;
 }
 
 static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
@@ -462,10 +438,6 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
-	ret = fimc_try_fmt_mplane(ctx, f);
-	if (ret)
-		return ret;
-
 	if (vb2_is_busy(&fimc->vid_cap.vbq) || fimc_capture_active(fimc))
 		return -EBUSY;
 
@@ -495,7 +467,6 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 
 	ctx->state |= (FIMC_PARAMS | FIMC_DST_FMT);
 
-	ret = sync_capture_fmt(ctx);
 	return ret;
 }
 
@@ -503,12 +474,14 @@ static int fimc_cap_enum_input(struct file *file, void *priv,
 			       struct v4l2_input *i)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	struct v4l2_subdev *sd = fimc->pipeline.sensor;
 
 	if (i->index != 0)
 		return -EINVAL;
 
-
 	i->type = V4L2_INPUT_TYPE_CAMERA;
+	if (sd)
+		strlcpy(i->name, sd->name, sizeof(i->name));
 	return 0;
 }
 
@@ -528,14 +501,16 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct fimc_pipeline *p = &fimc->pipeline;
 
-	if (fimc_capture_active(fimc) || !fimc->vid_cap.sd)
+	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
 	if (!(ctx->state & FIMC_DST_FMT)) {
 		v4l2_err(fimc->vid_cap.vfd, "Format is not set\n");
 		return -EINVAL;
 	}
+	media_entity_pipeline_start(&p->sensor->entity, p->pipe);
 
 	return vb2_streamon(&fimc->vid_cap.vbq, type);
 }
@@ -544,8 +519,13 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	struct v4l2_subdev *sd = fimc->pipeline.sensor;
+	int ret;
 
-	return vb2_streamoff(&fimc->vid_cap.vbq, type);
+	ret = vb2_streamoff(&fimc->vid_cap.vbq, type);
+	if (ret == 0)
+		media_entity_pipeline_stop(&sd->entity);
+	return ret;
 }
 
 static int fimc_cap_reqbufs(struct file *file, void *priv,
@@ -651,7 +631,6 @@ static int fimc_cap_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	return 0;
 }
 
-
 static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_querycap		= fimc_vidioc_querycap_capture,
 
@@ -757,8 +736,6 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	vid_cap->active_buf_cnt = 0;
 	vid_cap->reqbufs_count  = 0;
 	vid_cap->refcnt = 0;
-	/* Default color format for image sensor */
-	vid_cap->fmt.code = V4L2_MBUS_FMT_YUYV8_2X8;
 
 	INIT_LIST_HEAD(&vid_cap->pending_buf_q);
 	INIT_LIST_HEAD(&vid_cap->active_buf_q);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 8bd8d30..7a10fea 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -903,6 +903,60 @@ int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f)
 	return 0;
 }
 
+void fimc_fill_frame(struct fimc_frame *frame, struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
+
+	frame->f_width  = pixm->plane_fmt[0].bytesperline;
+	if (frame->fmt->colplanes == 1)
+		frame->f_width = (frame->f_width * 8) / frame->fmt->depth[0];
+	frame->f_height	= pixm->height;
+	frame->width    = pixm->width;
+	frame->height   = pixm->height;
+	frame->o_width  = pixm->width;
+	frame->o_height = pixm->height;
+	frame->offs_h   = 0;
+	frame->offs_v   = 0;
+}
+
+/**
+ * fimc_adjust_mplane_desc - adjust bytesperline/sizeimage for each plane
+ * @fmt: fimc pixel format description (input)
+ * @width: requested pixel width
+ * @height: requested pixel height
+ * @pix: multi-plane format to adjust
+ */
+void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
+			       struct v4l2_pix_format_mplane *pix)
+{
+	u32 bytesperline = 0;
+	int i;
+
+	pix->colorspace	= V4L2_COLORSPACE_JPEG;
+	pix->field = V4L2_FIELD_NONE;
+	pix->num_planes = fmt->memplanes;
+	pix->height = height;
+	pix->width = width;
+
+	for (i = 0; i < pix->num_planes; ++i) {
+		u32 bpl = pix->plane_fmt[i].bytesperline;
+		u32 *sizeimage = &pix->plane_fmt[i].sizeimage;
+
+		if (fmt->colplanes > 1 && (bpl == 0 || bpl < pix->width))
+			bpl = pix->width; /* Planar */
+
+		if (fmt->colplanes == 1 && /* Packed */
+		    (bpl == 0 || ((bpl * 8) / fmt->depth[i]) < pix->width))
+			bpl = (pix->width * fmt->depth[0]) / 8;
+
+		if (i == 0) /* Same bytesperline for each plane. */
+			bytesperline = bpl;
+
+		pix->plane_fmt[i].bytesperline = bytesperline;
+		*sizeimage = (pix->width * pix->height * fmt->depth[i]) / 8;
+	}
+}
+
 static int fimc_m2m_g_fmt_mplane(struct file *file, void *fh,
 				 struct v4l2_format *f)
 {
@@ -944,43 +998,33 @@ struct fimc_fmt *fimc_find_format(u32 *pixelformat, u32 *mbus_code,
 	return def_fmt;
 }
 
-int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
+static int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct samsung_fimc_variant *variant = fimc->variant;
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct fimc_fmt *fmt;
-	u32 max_width, mod_x, mod_y, mask;
-	int i, is_output = 0;
+	u32 max_w, mod_x, mod_y;
 
-	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		if (fimc_ctx_state_is_set(FIMC_CTX_CAP, ctx))
-			return -EINVAL;
-		is_output = 1;
-	} else if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+	if (!IS_M2M(f->type))
 		return -EINVAL;
-	}
 
 	dbg("w: %d, h: %d", pix->width, pix->height);
 
-	mask = is_output ? FMT_FLAGS_M2M : FMT_FLAGS_M2M | FMT_FLAGS_CAM;
-	fmt = fimc_find_format(&pix->pixelformat, NULL, mask, -1);
-	if (!fmt) {
-		v4l2_err(fimc->v4l2_dev, "Fourcc format (0x%X) invalid.\n",
-			 pix->pixelformat);
+	fmt = fimc_find_format(&pix->pixelformat, NULL, FMT_FLAGS_M2M, 0);
+	if (WARN(fmt == NULL, "Pixel format lookup failed"))
 		return -EINVAL;
-	}
 
 	if (pix->field == V4L2_FIELD_ANY)
 		pix->field = V4L2_FIELD_NONE;
-	else if (V4L2_FIELD_NONE != pix->field)
+	else if (pix->field != V4L2_FIELD_NONE)
 		return -EINVAL;
 
-	if (is_output) {
-		max_width = variant->pix_limit->scaler_dis_w;
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		max_w = variant->pix_limit->scaler_dis_w;
 		mod_x = ffs(variant->min_inp_pixsize) - 1;
 	} else {
-		max_width = variant->pix_limit->out_rot_dis_w;
+		max_w = variant->pix_limit->out_rot_dis_w;
 		mod_x = ffs(variant->min_out_pixsize) - 1;
 	}
 
@@ -993,34 +1037,12 @@ int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
 		else
 			mod_y = mod_x;
 	}
+	dbg("mod_x: %d, mod_y: %d, max_w: %d", mod_x, mod_y, max_w);
 
-	dbg("mod_x: %d, mod_y: %d, max_w: %d", mod_x, mod_y, max_width);
-
-	v4l_bound_align_image(&pix->width, 16, max_width, mod_x,
+	v4l_bound_align_image(&pix->width, 16, max_w, mod_x,
 		&pix->height, 8, variant->pix_limit->scaler_dis_w, mod_y, 0);
 
-	pix->num_planes = fmt->memplanes;
-	pix->colorspace	= V4L2_COLORSPACE_JPEG;
-
-
-	for (i = 0; i < pix->num_planes; ++i) {
-		u32 bpl = pix->plane_fmt[i].bytesperline;
-		u32 *sizeimage = &pix->plane_fmt[i].sizeimage;
-
-		if (fmt->colplanes > 1 && (bpl == 0 || bpl < pix->width))
-			bpl = pix->width; /* Planar */
-
-		if (fmt->colplanes == 1 && /* Packed */
-		    (bpl == 0 || ((bpl * 8) / fmt->depth[i]) < pix->width))
-			bpl = (pix->width * fmt->depth[0]) / 8;
-
-		if (i == 0) /* Same bytesperline for each plane. */
-			mod_x = bpl;
-
-		pix->plane_fmt[i].bytesperline = mod_x;
-		*sizeimage = (pix->width * pix->height * fmt->depth[i]) / 8;
-	}
-
+	fimc_adjust_mplane_format(fmt, pix->width, pix->height, &f->fmt.pix_mp);
 	return 0;
 }
 
@@ -1069,15 +1091,7 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 			(pix->width * pix->height * frame->fmt->depth[i]) / 8;
 	}
 
-	frame->f_width	= pix->plane_fmt[0].bytesperline * 8 /
-		frame->fmt->depth[0];
-	frame->f_height	= pix->height;
-	frame->width	= pix->width;
-	frame->height	= pix->height;
-	frame->o_width	= pix->width;
-	frame->o_height = pix->height;
-	frame->offs_h	= 0;
-	frame->offs_v	= 0;
+	fimc_fill_frame(frame, f);
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		fimc_ctx_state_lock_set(FIMC_PARAMS | FIMC_DST_FMT, ctx);
@@ -1157,8 +1171,8 @@ static int fimc_m2m_cropcap(struct file *file, void *fh,
 
 	cr->bounds.left		= 0;
 	cr->bounds.top		= 0;
-	cr->bounds.width	= frame->f_width;
-	cr->bounds.height	= frame->f_height;
+	cr->bounds.width	= frame->o_width;
+	cr->bounds.height	= frame->o_height;
 	cr->defrect		= cr->bounds;
 
 	return 0;
@@ -1622,7 +1636,6 @@ static int fimc_probe(struct platform_device *pdev)
 
 	init_waitqueue_head(&fimc->irq_queue);
 	spin_lock_init(&fimc->slock);
-
 	mutex_init(&fimc->lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 18e8c02..36752f7 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -43,6 +43,7 @@
 #define SCALER_MAX_HRATIO	64
 #define SCALER_MAX_VRATIO	64
 #define DMA_MIN_SIZE		8
+#define FIMC_CAMIF_MAX_HEIGHT	0x2000
 
 /* indices to the clocks array */
 enum {
@@ -61,6 +62,7 @@ enum fimc_dev_flags {
 	ST_CAPT_PEND,
 	ST_CAPT_RUN,
 	ST_CAPT_STREAM,
+	ST_CAPT_ISP_STREAM,
 	ST_CAPT_SHUT,
 	ST_CAPT_INUSE,
 	ST_CAPT_APPLY_CFG,
@@ -95,6 +97,9 @@ enum fimc_color_fmt {
 
 #define fimc_fmt_is_rgb(x) ((x) & 0x10)
 
+#define IS_M2M(__strt) ((__strt) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE || \
+			__strt == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+
 /* Cb/Cr chrominance components order for 2 plane Y/CbCr 4:2:2 formats. */
 #define	S5P_FIMC_LSB_CRCB	S5P_CIOCTRL_ORDER422_2P_LSB_CRCB
 
@@ -293,7 +298,6 @@ struct fimc_m2m_device {
  * struct fimc_vid_cap - camera capture device information
  * @ctx: hardware context data
  * @vfd: video device node for camera capture mode
- * @sd: pointer to camera sensor subdevice currently in use
  * @vd_pad: fimc video capture node pad
  * @fmt: Media Bus format configured at selected image sensor
  * @pending_buf_q: the pending buffer queue head
@@ -312,9 +316,8 @@ struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		*vfd;
-	struct v4l2_subdev		*sd;;
 	struct media_pad		vd_pad;
-	struct v4l2_mbus_framefmt	fmt;
+	struct v4l2_mbus_framefmt	mf;
 	struct list_head		pending_buf_q;
 	struct list_head		active_buf_q;
 	struct vb2_queue		vbq;
@@ -647,13 +650,13 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 /* fimc-core.c */
 int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
 				struct v4l2_fmtdesc *f);
-int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f);
 int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr);
 int fimc_ctrls_create(struct fimc_ctx *ctx);
 void fimc_ctrls_delete(struct fimc_ctx *ctx);
 void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active);
 int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f);
-
+void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
+			       struct v4l2_pix_format_mplane *pix);
 struct fimc_fmt *fimc_find_format(u32 *pixelformat, u32 *mbus_code,
 				  unsigned int mask, int index);
 
@@ -664,6 +667,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr);
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f);
 void fimc_set_yuv_order(struct fimc_ctx *ctx);
+void fimc_fill_frame(struct fimc_frame *frame, struct v4l2_format *f);
 
 int fimc_register_m2m_device(struct fimc_dev *fimc,
 			     struct v4l2_device *v4l2_dev);
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 50937b4..a1fff02 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -572,7 +572,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 
 	if (cam->bus_type == FIMC_ITU_601 || cam->bus_type == FIMC_ITU_656) {
 		for (i = 0; i < ARRAY_SIZE(pix_desc); i++) {
-			if (fimc->vid_cap.fmt.code == pix_desc[i].pixelcode) {
+			if (fimc->vid_cap.mf.code == pix_desc[i].pixelcode) {
 				cfg = pix_desc[i].cisrcfmt;
 				bus_width = pix_desc[i].bus_width;
 				break;
@@ -582,7 +582,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 		if (i == ARRAY_SIZE(pix_desc)) {
 			v4l2_err(fimc->vid_cap.vfd,
 				 "Camera color format not supported: %d\n",
-				 fimc->vid_cap.fmt.code);
+				 fimc->vid_cap.mf.code);
 			return -EINVAL;
 		}
 
@@ -642,12 +642,12 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			cfg |= S5P_CIGCTRL_SELCAM_MIPI_A;
 
 		/* TODO: add remaining supported formats. */
-		if (vid_cap->fmt.code == V4L2_MBUS_FMT_VYUY8_2X8) {
+		if (vid_cap->mf.code == V4L2_MBUS_FMT_VYUY8_2X8) {
 			tmp = S5P_CSIIMGFMT_YCBCR422_8BIT;
 		} else {
 			v4l2_err(fimc->vid_cap.vfd,
 				 "Not supported camera pixel format: %d",
-				 vid_cap->fmt.code);
+				 vid_cap->mf.code);
 			return -EINVAL;
 		}
 		tmp |= (cam->csi_data_align == 32) << 8;
-- 
1.7.5.4

