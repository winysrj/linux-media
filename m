Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64737 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab3CFLy0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 06:54:26 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [RFC 01/12] media: s5p-fimc: modify existing mdev to use common pipeline
Date: Wed,  6 Mar 2013 17:23:47 +0530
Message-Id: <1362570838-4737-2-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch modifies the current fimc_pipeline to exynos_pipeline,
which can be used across multiple media device drivers.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |   96 +++++++-----
 drivers/media/platform/s5p-fimc/fimc-core.h    |    4 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c    |   73 ++++------
 drivers/media/platform/s5p-fimc/fimc-lite.h    |    4 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |  186 ++++++++++++++++++++++--
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |   41 +++---
 include/media/s5p_fimc.h                       |   66 ++++++---
 7 files changed, 326 insertions(+), 144 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 4cbaf46..106466e 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -27,24 +27,26 @@
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
 
-#include "fimc-mdevice.h"
 #include "fimc-core.h"
 #include "fimc-reg.h"
 
 static int fimc_capture_hw_init(struct fimc_dev *fimc)
 {
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
-	struct fimc_pipeline *p = &fimc->pipeline;
+	struct exynos_pipeline *p = &fimc->pipeline;
 	struct fimc_sensor_info *sensor;
 	unsigned long flags;
+	struct v4l2_subdev *sd;
 	int ret = 0;
 
-	if (p->subdevs[IDX_SENSOR] == NULL || ctx == NULL)
+	sd = exynos_pipeline_get_subdev(fimc->pipeline_ops,
+					get_subdev_sensor, p);
+	if (sd == NULL || ctx == NULL)
 		return -ENXIO;
 	if (ctx->s_frame.fmt == NULL)
 		return -EINVAL;
 
-	sensor = v4l2_get_subdev_hostdata(p->subdevs[IDX_SENSOR]);
+	sensor = v4l2_get_subdev_hostdata(sd);
 
 	spin_lock_irqsave(&fimc->slock, flags);
 	fimc_prepare_dma_offset(ctx, &ctx->d_frame);
@@ -118,7 +120,7 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 	spin_unlock_irqrestore(&fimc->slock, flags);
 
 	if (streaming)
-		return fimc_pipeline_call(fimc, set_stream,
+		return exynos_pipeline_call(fimc, set_stream,
 					  &fimc->pipeline, 0);
 	else
 		return 0;
@@ -177,13 +179,16 @@ static int fimc_capture_config_update(struct fimc_ctx *ctx)
 
 void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 {
-	struct v4l2_subdev *csis = fimc->pipeline.subdevs[IDX_CSIS];
+	struct v4l2_subdev *csis;
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_frame *f = &cap->ctx->d_frame;
 	struct fimc_vid_buffer *v_buf;
 	struct timeval *tv;
 	struct timespec ts;
 
+	csis = exynos_pipeline_get_subdev(fimc->pipeline_ops,
+					get_subdev_csis, &fimc->pipeline);
+
 	if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
 		wake_up(&fimc->irq_queue);
 		goto done;
@@ -286,7 +291,7 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 		fimc_activate_capture(ctx);
 
 		if (!test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
-			fimc_pipeline_call(fimc, set_stream,
+			exynos_pipeline_call(fimc, set_stream,
 					   &fimc->pipeline, 1);
 	}
 
@@ -311,7 +316,7 @@ int fimc_capture_suspend(struct fimc_dev *fimc)
 	int ret = fimc_stop_capture(fimc, suspend);
 	if (ret)
 		return ret;
-	return fimc_pipeline_call(fimc, close, &fimc->pipeline);
+	return exynos_pipeline_call(fimc, close, &fimc->pipeline);
 }
 
 static void buffer_queue(struct vb2_buffer *vb);
@@ -327,7 +332,7 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
 	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
 	vid_cap->buf_index = 0;
-	fimc_pipeline_call(fimc, open, &fimc->pipeline,
+	exynos_pipeline_call(fimc, open, &fimc->pipeline,
 			   &vid_cap->vfd.entity, false);
 	fimc_capture_hw_init(fimc);
 
@@ -447,7 +452,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		spin_unlock_irqrestore(&fimc->slock, flags);
 
 		if (!test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
-			fimc_pipeline_call(fimc, set_stream,
+			exynos_pipeline_call(fimc, set_stream,
 					   &fimc->pipeline, 1);
 		return;
 	}
@@ -486,9 +491,12 @@ static struct vb2_ops fimc_capture_qops = {
 int fimc_capture_ctrls_create(struct fimc_dev *fimc)
 {
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
-	struct v4l2_subdev *sensor = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct v4l2_subdev *sensor;
 	int ret;
 
+	sensor = exynos_pipeline_get_subdev(fimc->pipeline_ops,
+					get_subdev_sensor, &fimc->pipeline);
+
 	if (WARN_ON(vid_cap->ctx == NULL))
 		return -ENXIO;
 	if (vid_cap->ctx->ctrls.ready)
@@ -513,7 +521,7 @@ static int fimc_capture_open(struct file *file)
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
-	fimc_md_graph_lock(fimc);
+	exynos_pipeline_graph_lock(fimc->pipeline_ops, &fimc->pipeline);
 	mutex_lock(&fimc->lock);
 
 	if (fimc_m2m_active(fimc))
@@ -531,7 +539,7 @@ static int fimc_capture_open(struct file *file)
 	}
 
 	if (++fimc->vid_cap.refcnt == 1) {
-		ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
+		ret = exynos_pipeline_call(fimc, open, &fimc->pipeline,
 					 &fimc->vid_cap.vfd.entity, true);
 
 		if (!ret && !fimc->vid_cap.user_subdev_api)
@@ -549,7 +557,7 @@ static int fimc_capture_open(struct file *file)
 	}
 unlock:
 	mutex_unlock(&fimc->lock);
-	fimc_md_graph_unlock(fimc);
+	exynos_pipeline_graph_unlock(fimc->pipeline_ops, &fimc->pipeline);
 	return ret;
 }
 
@@ -565,7 +573,7 @@ static int fimc_capture_close(struct file *file)
 	if (--fimc->vid_cap.refcnt == 0) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
 		fimc_stop_capture(fimc, false);
-		fimc_pipeline_call(fimc, close, &fimc->pipeline);
+		exynos_pipeline_call(fimc, close, &fimc->pipeline);
 		clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
 	}
 
@@ -826,7 +834,7 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 				    bool set)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct v4l2_subdev *sd;
 	struct v4l2_subdev_format sfmt;
 	struct v4l2_mbus_framefmt *mf = &sfmt.format;
 	struct media_entity *me;
@@ -835,6 +843,9 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 	int ret, i = 1;
 	u32 fcc;
 
+	sd = exynos_pipeline_get_subdev(fimc->pipeline_ops,
+					get_subdev_sensor, &fimc->pipeline);
+
 	if (WARN_ON(!sd || !tfmt))
 		return -EINVAL;
 
@@ -968,7 +979,7 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	struct fimc_fmt *ffmt = NULL;
 	int ret = 0;
 
-	fimc_md_graph_lock(fimc);
+	exynos_pipeline_graph_lock(fimc->pipeline_ops, &fimc->pipeline);
 	mutex_lock(&fimc->lock);
 
 	if (fimc_jpeg_fourcc(pix->pixelformat)) {
@@ -1000,11 +1011,13 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	fimc_adjust_mplane_format(ffmt, pix->width, pix->height, pix);
 
 	if (ffmt->flags & FMT_FLAGS_COMPRESSED)
-		fimc_get_sensor_frame_desc(fimc->pipeline.subdevs[IDX_SENSOR],
-					pix->plane_fmt, ffmt->memplanes, true);
+		fimc_get_sensor_frame_desc(
+			exynos_pipeline_get_subdev(fimc->pipeline_ops,
+				get_subdev_sensor, &fimc->pipeline),
+			pix->plane_fmt, ffmt->memplanes, true);
 unlock:
 	mutex_unlock(&fimc->lock);
-	fimc_md_graph_unlock(fimc);
+	exynos_pipeline_graph_unlock(fimc->pipeline_ops, &fimc->pipeline);
 
 	return ret;
 }
@@ -1070,9 +1083,10 @@ static int __fimc_capture_set_format(struct fimc_dev *fimc,
 	fimc_adjust_mplane_format(ff->fmt, pix->width, pix->height, pix);
 
 	if (ff->fmt->flags & FMT_FLAGS_COMPRESSED) {
-		ret = fimc_get_sensor_frame_desc(fimc->pipeline.subdevs[IDX_SENSOR],
-					pix->plane_fmt, ff->fmt->memplanes,
-					true);
+		ret = fimc_get_sensor_frame_desc(
+			exynos_pipeline_get_subdev(fimc->pipeline_ops,
+				get_subdev_sensor, &fimc->pipeline),
+			pix->plane_fmt, ff->fmt->memplanes, true);
 		if (ret < 0)
 			return ret;
 	}
@@ -1105,7 +1119,7 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	struct fimc_dev *fimc = video_drvdata(file);
 	int ret;
 
-	fimc_md_graph_lock(fimc);
+	exynos_pipeline_graph_lock(fimc->pipeline_ops, &fimc->pipeline);
 	mutex_lock(&fimc->lock);
 	/*
 	 * The graph is walked within __fimc_capture_set_format() to set
@@ -1118,7 +1132,7 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	ret = __fimc_capture_set_format(fimc, f);
 
 	mutex_unlock(&fimc->lock);
-	fimc_md_graph_unlock(fimc);
+	exynos_pipeline_graph_unlock(fimc->pipeline_ops, &fimc->pipeline);
 	return ret;
 }
 
@@ -1126,7 +1140,10 @@ static int fimc_cap_enum_input(struct file *file, void *priv,
 			       struct v4l2_input *i)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct v4l2_subdev *sd;
+
+	sd = exynos_pipeline_get_subdev(fimc->pipeline_ops, get_subdev_sensor,
+							&fimc->pipeline);
 
 	if (i->index != 0)
 		return -EINVAL;
@@ -1205,8 +1222,9 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 		    src_fmt.format.code != sink_fmt.format.code)
 			return -EPIPE;
 
-		if (sd == fimc->pipeline.subdevs[IDX_SENSOR] &&
-		    fimc_user_defined_mbus_fmt(src_fmt.format.code)) {
+		if (sd == exynos_pipeline_get_subdev(fimc->pipeline_ops,
+					get_subdev_sensor, &fimc->pipeline) &&
+			  fimc_user_defined_mbus_fmt(src_fmt.format.code)) {
 			struct v4l2_plane_pix_format plane_fmt[FIMC_MAX_PLANES];
 			struct fimc_frame *frame = &vid_cap->ctx->d_frame;
 			unsigned int i;
@@ -1229,14 +1247,17 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 			     enum v4l2_buf_type type)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct fimc_pipeline *p = &fimc->pipeline;
-	struct v4l2_subdev *sd = p->subdevs[IDX_SENSOR];
+	struct exynos_pipeline *p = &fimc->pipeline;
+	struct v4l2_subdev *sd;
 	int ret;
 
+	sd = exynos_pipeline_get_subdev(fimc->pipeline_ops,
+						get_subdev_sensor, p);
+
 	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
-	ret = media_entity_pipeline_start(&sd->entity, p->m_pipeline);
+	ret = media_entity_pipeline_start(&sd->entity, &p->m_pipeline);
 	if (ret < 0)
 		return ret;
 
@@ -1254,9 +1275,12 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct v4l2_subdev *sd;
 	int ret;
 
+	sd = exynos_pipeline_get_subdev(fimc->pipeline_ops, get_subdev_sensor,
+							&fimc->pipeline);
+
 	ret = vb2_streamoff(&fimc->vid_cap.vbq, type);
 	if (ret == 0)
 		media_entity_pipeline_stop(&sd->entity);
@@ -1489,18 +1513,13 @@ void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 {
 	struct fimc_sensor_info	*sensor;
 	struct fimc_vid_buffer *buf;
-	struct fimc_md *fmd;
 	struct fimc_dev *fimc;
-	unsigned long flags;
 
 	if (sd == NULL)
 		return;
 
 	sensor = v4l2_get_subdev_hostdata(sd);
-	fmd = entity_to_fimc_mdev(&sd->entity);
-
-	spin_lock_irqsave(&fmd->slock, flags);
-	fimc = sensor ? sensor->host : NULL;
+	fimc = sensor ? (struct fimc_dev *)sensor->host : NULL;
 
 	if (fimc && arg && notification == S5P_FIMC_TX_END_NOTIFY &&
 	    test_bit(ST_CAPT_PEND, &fimc->state)) {
@@ -1515,7 +1534,6 @@ void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 		fimc_deactivate_capture(fimc);
 		spin_unlock_irqrestore(&fimc->slock, irq_flags);
 	}
-	spin_unlock_irqrestore(&fmd->slock, flags);
 }
 
 static int fimc_subdev_enum_mbus_code(struct v4l2_subdev *sd,
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index 412d507..57bf708 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -447,8 +447,8 @@ struct fimc_dev {
 	struct fimc_vid_cap		vid_cap;
 	unsigned long			state;
 	struct vb2_alloc_ctx		*alloc_ctx;
-	struct fimc_pipeline		pipeline;
-	const struct fimc_pipeline_ops	*pipeline_ops;
+	struct exynos_pipeline		pipeline;
+	const struct exynos_pipeline_ops	*pipeline_ops;
 };
 
 /**
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 3266c3f..122cf95 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
 
 #include <linux/bug.h>
+#include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
@@ -31,8 +32,6 @@
 #include <media/videobuf2-dma-contig.h>
 #include <media/s5p_fimc.h>
 
-#include "fimc-mdevice.h"
-#include "fimc-core.h"
 #include "fimc-lite.h"
 #include "fimc-lite-reg.h"
 
@@ -123,12 +122,13 @@ static const struct fimc_fmt *fimc_lite_find_format(const u32 *pixelformat,
 
 static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
 {
-	struct fimc_pipeline *pipeline = &fimc->pipeline;
 	struct v4l2_subdev *sensor;
-	struct fimc_sensor_info *si;
+	struct fimc_source_info *src_info;
 	unsigned long flags;
 
-	sensor = isp_output ? fimc->sensor : pipeline->subdevs[IDX_SENSOR];
+	sensor = isp_output ? fimc->sensor :
+				exynos_pipeline_get_subdev(fimc->pipeline_ops,
+					get_subdev_sensor, &fimc->pipeline);
 
 	if (sensor == NULL)
 		return -ENXIO;
@@ -137,10 +137,10 @@ static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
 		return -EINVAL;
 
 	/* Get sensor configuration data from the sensor subdev */
-	si = v4l2_get_subdev_hostdata(sensor);
+	src_info = v4l2_get_subdev_hostdata(sensor);
 	spin_lock_irqsave(&fimc->slock, flags);
 
-	flite_hw_set_camera_bus(fimc, &si->pdata);
+	flite_hw_set_camera_bus(fimc, src_info);
 	flite_hw_set_source_format(fimc, &fimc->inp_frame);
 	flite_hw_set_window_offset(fimc, &fimc->inp_frame);
 	flite_hw_set_output_dma(fimc, &fimc->out_frame, !isp_output);
@@ -200,7 +200,7 @@ static int fimc_lite_reinit(struct fimc_lite *fimc, bool suspend)
 	if (!streaming)
 		return 0;
 
-	return fimc_pipeline_call(fimc, set_stream, &fimc->pipeline, 0);
+	return exynos_pipeline_call(fimc, set_stream, &fimc->pipeline, 0);
 }
 
 static int fimc_lite_stop_capture(struct fimc_lite *fimc, bool suspend)
@@ -314,7 +314,7 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 		flite_hw_capture_start(fimc);
 
 		if (!test_and_set_bit(ST_SENSOR_STREAM, &fimc->state))
-			fimc_pipeline_call(fimc, set_stream,
+			exynos_pipeline_call(fimc, set_stream,
 					   &fimc->pipeline, 1);
 	}
 	if (debug > 0)
@@ -419,7 +419,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		spin_unlock_irqrestore(&fimc->slock, flags);
 
 		if (!test_and_set_bit(ST_SENSOR_STREAM, &fimc->state))
-			fimc_pipeline_call(fimc, set_stream,
+			exynos_pipeline_call(fimc, set_stream,
 					   &fimc->pipeline, 1);
 		return;
 	}
@@ -482,7 +482,7 @@ static int fimc_lite_open(struct file *file)
 
 	if (++fimc->ref_count == 1 &&
 	    atomic_read(&fimc->out_path) == FIMC_IO_DMA) {
-		ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
+		ret = exynos_pipeline_call(fimc, open, &fimc->pipeline,
 					 &fimc->vfd.entity, true);
 		if (ret < 0) {
 			pm_runtime_put_sync(&fimc->pdev->dev);
@@ -510,7 +510,7 @@ static int fimc_lite_close(struct file *file)
 	    atomic_read(&fimc->out_path) == FIMC_IO_DMA) {
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
 		fimc_lite_stop_capture(fimc, false);
-		fimc_pipeline_call(fimc, close, &fimc->pipeline);
+		exynos_pipeline_call(fimc, close, &fimc->pipeline);
 		clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
 	}
 
@@ -801,14 +801,17 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 			      enum v4l2_buf_type type)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
-	struct v4l2_subdev *sensor = fimc->pipeline.subdevs[IDX_SENSOR];
-	struct fimc_pipeline *p = &fimc->pipeline;
+	struct v4l2_subdev *sensor;
+	struct exynos_pipeline *p = &fimc->pipeline;
 	int ret;
 
+	sensor = exynos_pipeline_get_subdev(fimc->pipeline_ops,
+			get_subdev_sensor, &fimc->pipeline);
+
 	if (fimc_lite_active(fimc))
 		return -EBUSY;
 
-	ret = media_entity_pipeline_start(&sensor->entity, p->m_pipeline);
+	ret = media_entity_pipeline_start(&sensor->entity, &p->m_pipeline);
 	if (ret < 0)
 		return ret;
 
@@ -825,9 +828,12 @@ static int fimc_lite_streamoff(struct file *file, void *priv,
 			       enum v4l2_buf_type type)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
-	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct v4l2_subdev *sd;
 	int ret;
 
+	sd = exynos_pipeline_get_subdev(fimc->pipeline_ops,
+			get_subdev_sensor, &fimc->pipeline);
+
 	ret = vb2_streamoff(&fimc->vb_queue, type);
 	if (ret == 0)
 		media_entity_pipeline_stop(&sd->entity);
@@ -976,29 +982,6 @@ static const struct v4l2_ioctl_ops fimc_lite_ioctl_ops = {
 	.vidioc_streamoff		= fimc_lite_streamoff,
 };
 
-/* Called with the media graph mutex held */
-static struct v4l2_subdev *__find_remote_sensor(struct media_entity *me)
-{
-	struct media_pad *pad = &me->pads[0];
-	struct v4l2_subdev *sd;
-
-	while (pad->flags & MEDIA_PAD_FL_SINK) {
-		/* source pad */
-		pad = media_entity_remote_source(pad);
-		if (pad == NULL ||
-		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
-			break;
-
-		sd = media_entity_to_v4l2_subdev(pad->entity);
-
-		if (sd->grp_id == GRP_ID_FIMC_IS_SENSOR)
-			return sd;
-		/* sink pad */
-		pad = &sd->entity.pads[0];
-	}
-	return NULL;
-}
-
 /* Capture subdev media entity operations */
 static int fimc_lite_link_setup(struct media_entity *entity,
 				const struct media_pad *local,
@@ -1241,6 +1224,8 @@ static int fimc_lite_subdev_set_selection(struct v4l2_subdev *sd,
 static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+	struct exynos_pipeline *ep;
+	struct exynos_pipeline_ops *ep_ops;
 	unsigned long flags;
 	int ret;
 
@@ -1251,7 +1236,10 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
 	 * The pipeline links are protected through entity.stream_count
 	 * so there is no need to take the media graph mutex here.
 	 */
-	fimc->sensor = __find_remote_sensor(&sd->entity);
+	ep_ops = v4l2_get_subdev_hostdata(sd);
+	ep = media_pipe_to_exynos_pipeline(sd->entity.pipe);
+	fimc->sensor = exynos_pipeline_get_subdev(fimc->pipeline_ops,
+							get_subdev_sensor, ep);
 
 	if (atomic_read(&fimc->out_path) != FIMC_IO_ISP)
 		return -ENOIOCTLCMD;
@@ -1338,6 +1326,7 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 
 	video_set_drvdata(vfd, fimc);
 	fimc->pipeline_ops = v4l2_get_subdev_hostdata(sd);
+	fimc->pipeline_ops->init(&fimc->pipeline);
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
@@ -1606,7 +1595,7 @@ static int fimc_lite_resume(struct device *dev)
 		return 0;
 
 	INIT_LIST_HEAD(&fimc->active_buf_q);
-	fimc_pipeline_call(fimc, open, &fimc->pipeline,
+	exynos_pipeline_call(fimc, open, &fimc->pipeline,
 			   &fimc->vfd.entity, false);
 	fimc_lite_hw_init(fimc, atomic_read(&fimc->out_path) == FIMC_IO_ISP);
 	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
@@ -1633,7 +1622,7 @@ static int fimc_lite_suspend(struct device *dev)
 	if (ret < 0 || !fimc_lite_active(fimc))
 		return ret;
 
-	return fimc_pipeline_call(fimc, close, &fimc->pipeline);
+	return exynos_pipeline_call(fimc, close, &fimc->pipeline);
 }
 #endif /* CONFIG_PM_SLEEP */
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.h b/drivers/media/platform/s5p-fimc/fimc-lite.h
index 7085761..66d6eeb 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.h
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.h
@@ -145,8 +145,8 @@ struct fimc_lite {
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_ctrl	*test_pattern;
 	u32			index;
-	struct fimc_pipeline	pipeline;
-	const struct fimc_pipeline_ops *pipeline_ops;
+	struct exynos_pipeline	pipeline;
+	const struct exynos_pipeline_ops *pipeline_ops;
 
 	struct mutex		lock;
 	spinlock_t		slock;
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index fc93fad..938cc56 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -36,6 +36,8 @@
 #include "fimc-mdevice.h"
 #include "mipi-csis.h"
 
+static struct fimc_md *g_fimc_mdev;
+
 static int __fimc_md_set_camclk(struct fimc_md *fmd,
 				struct fimc_sensor_info *s_info,
 				bool on);
@@ -143,6 +145,73 @@ static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
 }
 
 /**
+ * __fimc_pipeline_init
+ *      allocate the fimc_pipeline structure and do the basic initialization
+ */
+static int __fimc_pipeline_init(struct exynos_pipeline *ep)
+{
+	struct fimc_pipeline *p;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	p->is_init = true;
+	p->fmd = g_fimc_mdev;
+	ep->priv = (void *)p;
+	return 0;
+}
+
+/**
+ * __fimc_pipeline_deinit
+ *      free the allocated resources for fimc_pipeline
+ */
+static int __fimc_pipeline_deinit(struct exynos_pipeline *ep)
+{
+	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
+
+	if (!p || !p->is_init)
+		return -EINVAL;
+
+	p->is_init = false;
+	kfree(p);
+
+	return 0;
+}
+
+/**
+ * __fimc_pipeline_get_subdev_sensor
+ *      if valid pipeline, returns the sensor subdev pointer
+ *      else returns NULL
+ */
+static struct v4l2_subdev *__fimc_pipeline_get_subdev_sensor(
+					struct exynos_pipeline *ep)
+{
+	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
+
+	if (!p || !p->is_init)
+		return NULL;
+
+	return p->subdevs[IDX_SENSOR];
+}
+
+/**
+ * __fimc_pipeline_get_subdev_csis
+ *      if valid pipeline, returns the csis subdev pointer
+ *      else returns NULL
+ */
+static struct v4l2_subdev *__fimc_pipeline_get_subdev_csis(
+					struct exynos_pipeline *ep)
+{
+	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
+
+	if (!p || !p->is_init)
+		return NULL;
+
+	return p->subdevs[IDX_CSIS];
+}
+
+/**
  * __fimc_pipeline_open - update the pipeline information, enable power
  *                        of all pipeline subdevs and the sensor clock
  * @me: media entity to start graph walk with
@@ -150,11 +219,15 @@ static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
  *
  * Called with the graph mutex held.
  */
-static int __fimc_pipeline_open(struct fimc_pipeline *p,
+static int __fimc_pipeline_open(struct exynos_pipeline *ep,
 				struct media_entity *me, bool prep)
 {
+	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
 	int ret;
 
+	if (!p || !p->is_init)
+		return -EINVAL;
+
 	if (prep)
 		fimc_pipeline_prepare(p, me);
 
@@ -174,17 +247,20 @@ static int __fimc_pipeline_open(struct fimc_pipeline *p,
  *
  * Disable power of all subdevs and turn the external sensor clock off.
  */
-static int __fimc_pipeline_close(struct fimc_pipeline *p)
+static int __fimc_pipeline_close(struct exynos_pipeline *ep)
 {
+	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
 	int ret = 0;
 
-	if (!p || !p->subdevs[IDX_SENSOR])
+	if (!p || !p->is_init)
 		return -EINVAL;
 
-	if (p->subdevs[IDX_SENSOR]) {
-		ret = fimc_pipeline_s_power(p, 0);
-		fimc_md_set_camclk(p->subdevs[IDX_SENSOR], false);
-	}
+	if (!p->subdevs[IDX_SENSOR])
+		return -EINVAL;
+
+	ret = fimc_pipeline_s_power(p, 0);
+	fimc_md_set_camclk(p->subdevs[IDX_SENSOR], false);
+
 	return ret == -ENXIO ? 0 : ret;
 }
 
@@ -193,10 +269,14 @@ static int __fimc_pipeline_close(struct fimc_pipeline *p)
  * @pipeline: video pipeline structure
  * @on: passed as the s_stream call argument
  */
-static int __fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
+static int __fimc_pipeline_s_stream(struct exynos_pipeline *ep, bool on)
 {
+	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
 	int i, ret;
 
+	if (!p || !p->is_init)
+		return -EINVAL;
+
 	if (p->subdevs[IDX_SENSOR] == NULL)
 		return -ENODEV;
 
@@ -213,11 +293,47 @@ static int __fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
 
 }
 
+static void __fimc_pipeline_graph_lock(struct exynos_pipeline *ep)
+{
+	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
+	struct fimc_md *fmd = p->fmd;
+
+	mutex_lock(&fmd->media_dev.graph_mutex);
+}
+
+static void __fimc_pipeline_graph_unlock(struct exynos_pipeline *ep)
+{
+	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
+	struct fimc_md *fmd = p->fmd;
+
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+}
+
+static void __fimc_pipeline_register_notify_callback(
+		struct exynos_pipeline *ep,
+		void (*notify_cb)(struct v4l2_subdev *sd,
+				unsigned int notification, void *arg))
+{
+	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
+
+	if (!notify_cb)
+		return;
+
+	p->sensor_notify = notify_cb;
+}
+
 /* Media pipeline operations for the FIMC/FIMC-LITE video device driver */
-static const struct fimc_pipeline_ops fimc_pipeline_ops = {
-	.open		= __fimc_pipeline_open,
-	.close		= __fimc_pipeline_close,
-	.set_stream	= __fimc_pipeline_s_stream,
+static const struct exynos_pipeline_ops fimc_pipeline_ops = {
+	.init			= __fimc_pipeline_init,
+	.deinit			= __fimc_pipeline_deinit,
+	.open			= __fimc_pipeline_open,
+	.close			= __fimc_pipeline_close,
+	.set_stream		= __fimc_pipeline_s_stream,
+	.get_subdev_sensor	= __fimc_pipeline_get_subdev_sensor,
+	.get_subdev_csis	= __fimc_pipeline_get_subdev_csis,
+	.graph_lock		= __fimc_pipeline_graph_lock,
+	.graph_unlock		= __fimc_pipeline_graph_unlock,
+	.register_notify_cb	= __fimc_pipeline_register_notify_callback,
 };
 
 /*
@@ -769,7 +885,7 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 		if (!WARN_ON(s_info == NULL)) {
 			unsigned long irq_flags;
 			spin_lock_irqsave(&fmd->slock, irq_flags);
-			s_info->host = fmd->fimc[i];
+			s_info->host = (void *)fmd->fimc[i];
 			spin_unlock_irqrestore(&fmd->slock, irq_flags);
 		}
 	}
@@ -1051,7 +1167,8 @@ static int fimc_md_link_notify(struct media_pad *source,
 {
 	struct fimc_lite *fimc_lite = NULL;
 	struct fimc_dev *fimc = NULL;
-	struct fimc_pipeline *pipeline;
+	struct exynos_pipeline *pipeline;
+	struct fimc_pipeline *p;
 	struct v4l2_subdev *sd;
 	struct mutex *lock;
 	int ret = 0;
@@ -1081,12 +1198,16 @@ static int fimc_md_link_notify(struct media_pad *source,
 		return 0;
 	}
 
+	p = (struct fimc_pipeline *)pipeline->priv;
+	if (!p || !p->is_init)
+		return -EINVAL;
+
 	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 		int i;
 		mutex_lock(lock);
 		ret = __fimc_pipeline_close(pipeline);
 		for (i = 0; i < IDX_MAX; i++)
-			pipeline->subdevs[i] = NULL;
+			p->subdevs[i] = NULL;
 		if (fimc)
 			fimc_ctrls_delete(fimc->vid_cap.ctx);
 		mutex_unlock(lock);
@@ -1154,6 +1275,37 @@ static ssize_t fimc_md_sysfs_store(struct device *dev,
 static DEVICE_ATTR(subdev_conf_mode, S_IWUSR | S_IRUGO,
 		   fimc_md_sysfs_show, fimc_md_sysfs_store);
 
+/**
+ * fimc_md_sensor_notify - v4l2_device notification from a sensor subdev
+ * @sd: pointer to a subdev generating the notification
+ * @notification: the notification type, must be S5P_FIMC_TX_END_NOTIFY
+ * @arg: pointer to an u32 type integer that stores the frame payload value
+ *
+ * Passes the sensor notification to the capture device
+ */
+void fimc_md_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
+			void *arg)
+{
+	struct fimc_md *fmd;
+	struct exynos_pipeline *ep;
+	struct fimc_pipeline *p;
+	unsigned long flags;
+
+	if (sd == NULL)
+		return;
+
+	ep = media_pipe_to_exynos_pipeline(sd->entity.pipe);
+	p = (struct fimc_pipeline *)ep->priv;
+
+	spin_lock_irqsave(&fmd->slock, flags);
+
+	if (p->sensor_notify)
+		p->sensor_notify(sd, notification, arg);
+
+	spin_unlock_irqrestore(&fmd->slock, flags);
+}
+
+
 static int fimc_md_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1175,7 +1327,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 
 	v4l2_dev = &fmd->v4l2_dev;
 	v4l2_dev->mdev = &fmd->media_dev;
-	v4l2_dev->notify = fimc_sensor_notify;
+	v4l2_dev->notify = fimc_md_sensor_notify;
 	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
 
 
@@ -1194,6 +1346,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 		goto err_clk;
 
 	fmd->user_subdev_api = (dev->of_node != NULL);
+	g_fimc_mdev = fmd;
 
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
@@ -1252,6 +1405,7 @@ static int fimc_md_remove(struct platform_device *pdev)
 
 	if (!fmd)
 		return 0;
+	g_fimc_mdev = NULL;
 	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 	fimc_md_unregister_entities(fmd);
 	media_device_unregister(&fmd->media_dev);
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index f3e0251..1ea7acf 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -37,6 +37,15 @@
 #define FIMC_MAX_SENSORS	8
 #define FIMC_MAX_CAMCLKS	2
 
+enum fimc_subdev_index {
+	IDX_SENSOR,
+	IDX_CSIS,
+	IDX_FLITE,
+	IDX_IS_ISP,
+	IDX_FIMC,
+	IDX_MAX,
+};
+
 struct fimc_csis_info {
 	struct v4l2_subdev *sd;
 	int id;
@@ -49,20 +58,6 @@ struct fimc_camclk_info {
 };
 
 /**
- * struct fimc_sensor_info - image data source subdev information
- * @pdata: sensor's atrributes passed as media device's platform data
- * @subdev: image sensor v4l2 subdev
- * @host: fimc device the sensor is currently linked to
- *
- * This data structure applies to image sensor and the writeback subdevs.
- */
-struct fimc_sensor_info {
-	struct fimc_source_info pdata;
-	struct v4l2_subdev *subdev;
-	struct fimc_dev *host;
-};
-
-/**
  * struct fimc_md - fimc media device information
  * @csis: MIPI CSIS subdevs data
  * @sensor: array of registered sensor subdevs
@@ -89,6 +84,14 @@ struct fimc_md {
 	spinlock_t slock;
 };
 
+struct fimc_pipeline {
+	int is_init;
+	struct fimc_md *fmd;
+	struct v4l2_subdev *subdevs[IDX_MAX];
+	void (*sensor_notify)(struct v4l2_subdev *sd,
+			unsigned int notification, void *arg);
+};
+
 #define is_subdev_pad(pad) (pad == NULL || \
 	media_entity_type(pad->entity) == MEDIA_ENT_T_V4L2_SUBDEV)
 
@@ -103,16 +106,6 @@ static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
 		container_of(me->parent, struct fimc_md, media_dev);
 }
 
-static inline void fimc_md_graph_lock(struct fimc_dev *fimc)
-{
-	mutex_lock(&fimc->vid_cap.vfd.entity.parent->graph_mutex);
-}
-
-static inline void fimc_md_graph_unlock(struct fimc_dev *fimc)
-{
-	mutex_unlock(&fimc->vid_cap.vfd.entity.parent->graph_mutex);
-}
-
 int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
 
 #endif
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index e2434bb..007e998 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -13,6 +13,7 @@
 #define S5P_FIMC_H_
 
 #include <media/media-entity.h>
+#include <media/v4l2-subdev.h>
 
 /*
  * Enumeration of data inputs to the camera subsystem.
@@ -75,6 +76,20 @@ struct fimc_source_info {
 };
 
 /**
+ * struct fimc_sensor_info - image data source subdev information
+ * @pdata: sensor's atrributes passed as media device's platform data
+ * @subdev: image sensor v4l2 subdev
+ * @host: capture device the sensor is currently linked to
+ *
+ * This data structure applies to image sensor and the writeback subdevs.
+ */
+struct fimc_sensor_info {
+	struct fimc_source_info pdata;
+	struct v4l2_subdev *subdev;
+	void *host;
+};
+
+/**
  * struct s5p_platform_fimc - camera host interface platform data
  *
  * @source_info: properties of an image source for the host interface setup
@@ -93,21 +108,10 @@ struct s5p_platform_fimc {
  */
 #define S5P_FIMC_TX_END_NOTIFY _IO('e', 0)
 
-enum fimc_subdev_index {
-	IDX_SENSOR,
-	IDX_CSIS,
-	IDX_FLITE,
-	IDX_IS_ISP,
-	IDX_FIMC,
-	IDX_MAX,
-};
-
-struct media_pipeline;
-struct v4l2_subdev;
 
-struct fimc_pipeline {
-	struct v4l2_subdev *subdevs[IDX_MAX];
-	struct media_pipeline *m_pipeline;
+struct exynos_pipeline {
+	struct media_pipeline m_pipeline;
+	void *priv;
 };
 
 /*
@@ -115,15 +119,39 @@ struct fimc_pipeline {
  * video node when it is the last entity of the pipeline. Implemented
  * by corresponding media device driver.
  */
-struct fimc_pipeline_ops {
-	int (*open)(struct fimc_pipeline *p, struct media_entity *me,
+struct exynos_pipeline_ops {
+	int (*init) (struct exynos_pipeline *p);
+	int (*deinit) (struct exynos_pipeline *p);
+	int (*open)(struct exynos_pipeline *p, struct media_entity *me,
 			  bool resume);
-	int (*close)(struct fimc_pipeline *p);
-	int (*set_stream)(struct fimc_pipeline *p, bool state);
+	int (*close)(struct exynos_pipeline *p);
+	int (*set_stream)(struct exynos_pipeline *p, bool state);
+	void (*graph_lock)(struct exynos_pipeline *p);
+	void (*graph_unlock)(struct exynos_pipeline *p);
+	struct v4l2_subdev *(*get_subdev_sensor)(struct exynos_pipeline *p);
+	struct v4l2_subdev *(*get_subdev_csis)(struct exynos_pipeline *p);
+	void (*register_notify_cb)(struct exynos_pipeline *p,
+		void (*cb)(struct v4l2_subdev *sd,
+				unsigned int notification, void *arg));
+
 };
 
-#define fimc_pipeline_call(f, op, p, args...)				\
+#define exynos_pipeline_call(f, op, p, args...)				\
 	(!(f) ? -ENODEV : (((f)->pipeline_ops && (f)->pipeline_ops->op) ? \
 			    (f)->pipeline_ops->op((p), ##args) : -ENOIOCTLCMD))
 
+#define exynos_pipeline_get_subdev(ops, op, p)				\
+	((ops && ops->op) ? ops->op(p) : NULL)
+
+#define exynos_pipeline_graph_lock(ops, p)				\
+	((ops && ops->graph_lock) ?					\
+		   ops->graph_lock(p) : -ENOIOCTLCMD)
+
+#define exynos_pipeline_graph_unlock(ops, p)				\
+	((ops && ops->graph_unlock) ?					\
+		   ops->graph_unlock(p) : -ENOIOCTLCMD)
+
+#define media_pipe_to_exynos_pipeline(mp) \
+	container_of(mp, struct exynos_pipeline, m_pipeline)
+
 #endif /* S5P_FIMC_H_ */
-- 
1.7.9.5

