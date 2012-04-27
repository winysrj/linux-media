Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14705 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034Ab2D0JxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:22 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M34009Q9U4QCI@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:14 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3400J03U4QNO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:20 +0100 (BST)
Date: Fri, 27 Apr 2012 11:53:00 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 07/13] s5p-fimc: Rework the video pipeline control functions
In-reply-to: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-8-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is getting more entities to manage within single video pipeline
in newer SoCs. To simplify code put subdevs' pointer into an array
rather than adding new member in struct fimc_pipeline for each subdev.
This allows to easier handle subdev operations in proper order.

Additionally walk graph in one direction only in fimc_pipeline_prepare()
function to make sure we properly gather only media entities that below
to single data pipeline. This avoids wrong initialization in case where,
for example there are multiple active links from s5p-mipi-csis subdev
output pad.

struct fimc_pipeline declaration is moved to the driver's public header
to allow other drivers to reuse the fimc-lite driver added in subsequent
patches.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   34 +++---
 drivers/media/video/s5p-fimc/fimc-core.h    |    5 -
 drivers/media/video/s5p-fimc/fimc-mdevice.c |  164 +++++++++++++++++----------
 drivers/media/video/s5p-fimc/fimc-mdevice.h |   10 +-
 include/media/s5p_fimc.h                    |   16 +++
 5 files changed, 140 insertions(+), 89 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index fca8c4b..e6e5496 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -34,16 +34,17 @@
 static int fimc_init_capture(struct fimc_dev *fimc)
 {
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct fimc_pipeline *p = &fimc->pipeline;
 	struct fimc_sensor_info *sensor;
 	unsigned long flags;
 	int ret = 0;
 
-	if (fimc->pipeline.sensor == NULL || ctx == NULL)
+	if (p->subdevs[IDX_SENSOR] == NULL || ctx == NULL)
 		return -ENXIO;
 	if (ctx->s_frame.fmt == NULL)
 		return -EINVAL;
 
-	sensor = v4l2_get_subdev_hostdata(fimc->pipeline.sensor);
+	sensor = v4l2_get_subdev_hostdata(p->subdevs[IDX_SENSOR]);
 
 	spin_lock_irqsave(&fimc->slock, flags);
 	fimc_prepare_dma_offset(ctx, &ctx->d_frame);
@@ -109,7 +110,7 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 	spin_unlock_irqrestore(&fimc->slock, flags);
 
 	if (streaming)
-		return fimc_pipeline_s_stream(fimc, 0);
+		return fimc_pipeline_s_stream(&fimc->pipeline, 0);
 	else
 		return 0;
 }
@@ -130,7 +131,7 @@ static int fimc_stop_capture(struct fimc_dev *fimc, bool suspend)
 			   !test_bit(ST_CAPT_SHUT, &fimc->state),
 			   (2*HZ/10)); /* 200 ms */
 
-	return fimc_capture_state_cleanup(fimc, suspend);
+	return fimc_capture_reinit(fimc, suspend);
 }
 
 /**
@@ -258,7 +259,7 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 		fimc_activate_capture(ctx);
 
 		if (!test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
-			fimc_pipeline_s_stream(fimc, 1);
+			fimc_pipeline_s_stream(&fimc->pipeline, 1);
 	}
 
 	return 0;
@@ -285,7 +286,7 @@ int fimc_capture_suspend(struct fimc_dev *fimc)
 	int ret = fimc_stop_capture(fimc, suspend);
 	if (ret)
 		return ret;
-	return fimc_pipeline_shutdown(fimc);
+	return fimc_pipeline_shutdown(&fimc->pipeline);
 }
 
 static void buffer_queue(struct vb2_buffer *vb);
@@ -301,7 +302,7 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
 	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
 	vid_cap->buf_index = 0;
-	fimc_pipeline_initialize(fimc, &fimc->vid_cap.vfd->entity,
+	fimc_pipeline_initialize(&fimc->pipeline, &vid_cap->vfd->entity,
 				 false);
 	fimc_init_capture(fimc);
 
@@ -409,7 +410,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		spin_unlock_irqrestore(&fimc->slock, flags);
 
 		if (!test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
-			fimc_pipeline_s_stream(fimc, 1);
+			fimc_pipeline_s_stream(&fimc->pipeline, 1);
 		return;
 	}
 	spin_unlock_irqrestore(&fimc->slock, flags);
@@ -459,7 +460,7 @@ int fimc_capture_ctrls_create(struct fimc_dev *fimc)
 		return ret;
 
 	return v4l2_ctrl_add_handler(&vid_cap->ctx->ctrl_handler,
-				    fimc->pipeline.sensor->ctrl_handler);
+		    fimc->pipeline.subdevs[IDX_SENSOR]->ctrl_handler);
 }
 
 static int fimc_capture_set_default_format(struct fimc_dev *fimc);
@@ -482,7 +483,7 @@ static int fimc_capture_open(struct file *file)
 	pm_runtime_get_sync(&fimc->pdev->dev);
 
 	if (++fimc->vid_cap.refcnt == 1) {
-		ret = fimc_pipeline_initialize(fimc,
+		ret = fimc_pipeline_initialize(&fimc->pipeline,
 			       &fimc->vid_cap.vfd->entity, true);
 		if (ret < 0) {
 			dev_err(&fimc->pdev->dev,
@@ -510,7 +511,7 @@ static int fimc_capture_close(struct file *file)
 	if (--fimc->vid_cap.refcnt == 0) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
 		fimc_stop_capture(fimc, false);
-		fimc_pipeline_shutdown(fimc);
+		fimc_pipeline_shutdown(&fimc->pipeline);
 		clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
 	}
 
@@ -731,8 +732,8 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 				    bool set)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct v4l2_subdev *sd = fimc->pipeline.sensor;
-	struct v4l2_subdev *csis = fimc->pipeline.csis;
+	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct v4l2_subdev *csis = fimc->pipeline.subdevs[IDX_CSIS];
 	struct v4l2_subdev_format sfmt;
 	struct v4l2_mbus_framefmt *mf = &sfmt.format;
 	struct fimc_fmt *ffmt = NULL;
@@ -940,7 +941,7 @@ static int fimc_cap_enum_input(struct file *file, void *priv,
 			       struct v4l2_input *i)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct v4l2_subdev *sd = fimc->pipeline.sensor;
+	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
 
 	if (i->index != 0)
 		return -EINVAL;
@@ -1032,7 +1033,8 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
-	media_entity_pipeline_start(&p->sensor->entity, p->pipe);
+	media_entity_pipeline_start(&p->subdevs[IDX_SENSOR]->entity,
+				    p->m_pipeline);
 
 	if (fimc->vid_cap.user_subdev_api) {
 		ret = fimc_pipeline_validate(fimc);
@@ -1046,7 +1048,7 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct v4l2_subdev *sd = fimc->pipeline.sensor;
+	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
 	int ret;
 
 	ret = vb2_streamoff(&fimc->vid_cap.vbq, type);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index b3f0a98..25a3917 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -396,11 +396,6 @@ struct fimc_drvdata {
 	unsigned long lclk_frequency;
 };
 
-struct fimc_pipeline {
-	struct media_pipeline *pipe;
-	struct v4l2_subdev *sensor;
-	struct v4l2_subdev *csis;
-};
 
 struct fimc_ctx;
 
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index c73b714..d6b26b1 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -25,6 +25,7 @@
 #include <media/media-device.h>
 
 #include "fimc-core.h"
+#include "fimc-lite.h"
 #include "fimc-mdevice.h"
 #include "mipi-csis.h"
 
@@ -37,22 +38,43 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
  *
  * Caller holds the graph mutex.
  */
-void fimc_pipeline_prepare(struct fimc_dev *fimc, struct media_entity *me)
+void fimc_pipeline_prepare(struct fimc_pipeline *p, struct media_entity *me)
 {
-	struct media_entity_graph graph;
+	struct media_pad *pad = &me->pads[0];
 	struct v4l2_subdev *sd;
+	int i;
 
-	media_entity_graph_walk_start(&graph, me);
+	for (i = 0; i < IDX_MAX; i++)
+		p->subdevs[i] = NULL;
 
-	while ((me = media_entity_graph_walk_next(&graph))) {
-		if (media_entity_type(me) != MEDIA_ENT_T_V4L2_SUBDEV)
-			continue;
-		sd = media_entity_to_v4l2_subdev(me);
+	while (1) {
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+
+		/* source pad */
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
 
-		if (sd->grp_id == SENSOR_GROUP_ID)
-			fimc->pipeline.sensor = sd;
-		else if (sd->grp_id == CSIS_GROUP_ID)
-			fimc->pipeline.csis = sd;
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+
+		switch (sd->grp_id) {
+		case SENSOR_GROUP_ID:
+			p->subdevs[IDX_SENSOR] = sd;
+			break;
+		case CSIS_GROUP_ID:
+			p->subdevs[IDX_CSIS] = sd;
+			break;
+		case FIMC_GROUP_ID:
+			/* No need to control FIMC subdev through subdev ops */
+			break;
+		default:
+			pr_warn("%s: Unknown subdev grp_id: %#x\n",
+				__func__, sd->grp_id);
+		}
+		/* sink pad */
+		pad = &sd->entity.pads[0];
 	}
 }
 
@@ -85,30 +107,27 @@ static int __subdev_set_power(struct v4l2_subdev *sd, int on)
 /**
  * fimc_pipeline_s_power - change power state of all pipeline subdevs
  * @fimc: fimc device terminating the pipeline
- * @state: 1 to enable power or 0 for power down
+ * @state: true to power on, false to power off
  *
- * Need to be called with the graph mutex held.
+ * Needs to be called with the graph mutex held.
  */
-int fimc_pipeline_s_power(struct fimc_dev *fimc, int state)
+int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
 {
-	int ret = 0;
+	unsigned int i;
+	int ret;
 
-	if (fimc->pipeline.sensor == NULL)
+	if (p->subdevs[IDX_SENSOR] == NULL)
 		return -ENXIO;
 
-	if (state) {
-		ret = __subdev_set_power(fimc->pipeline.csis, 1);
-		if (ret && ret != -ENXIO)
+	for (i = 0; i < IDX_MAX; i++) {
+		unsigned int idx = state ? (IDX_MAX - 1) - i : i;
+
+		ret = __subdev_set_power(p->subdevs[idx], state);
+		if (ret < 0 && ret != -ENXIO)
 			return ret;
-		return __subdev_set_power(fimc->pipeline.sensor, 1);
 	}
 
-	ret = __subdev_set_power(fimc->pipeline.sensor, 0);
-	if (ret)
-		return ret;
-	ret = __subdev_set_power(fimc->pipeline.csis, 0);
-
-	return ret == -ENXIO ? 0 : ret;
+	return 0;
 }
 
 /**
@@ -119,32 +138,36 @@ int fimc_pipeline_s_power(struct fimc_dev *fimc, int state)
  *
  * This function must be called with the graph mutex held.
  */
-static int __fimc_pipeline_initialize(struct fimc_dev *fimc,
+static int __fimc_pipeline_initialize(struct fimc_pipeline *p,
 				      struct media_entity *me, bool prep)
 {
 	int ret;
 
 	if (prep)
-		fimc_pipeline_prepare(fimc, me);
-	if (fimc->pipeline.sensor == NULL)
+		fimc_pipeline_prepare(p, me);
+
+	if (p->subdevs[IDX_SENSOR] == NULL)
 		return -EINVAL;
-	ret = fimc_md_set_camclk(fimc->pipeline.sensor, true);
+
+	ret = fimc_md_set_camclk(p->subdevs[IDX_SENSOR], true);
 	if (ret)
 		return ret;
-	return fimc_pipeline_s_power(fimc, 1);
+
+	return fimc_pipeline_s_power(p, 1);
 }
 
-int fimc_pipeline_initialize(struct fimc_dev *fimc, struct media_entity *me,
+int fimc_pipeline_initialize(struct fimc_pipeline *p, struct media_entity *me,
 			     bool prep)
 {
 	int ret;
 
 	mutex_lock(&me->parent->graph_mutex);
-	ret =  __fimc_pipeline_initialize(fimc, me, prep);
+	ret =  __fimc_pipeline_initialize(p, me, prep);
 	mutex_unlock(&me->parent->graph_mutex);
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(fimc_pipeline_initialize);
 
 /**
  * __fimc_pipeline_shutdown - disable the sensor clock and pipeline power
@@ -154,52 +177,55 @@ int fimc_pipeline_initialize(struct fimc_dev *fimc, struct media_entity *me,
  * sensor clock.
  * Called with the graph mutex held.
  */
-int __fimc_pipeline_shutdown(struct fimc_dev *fimc)
+int __fimc_pipeline_shutdown(struct fimc_pipeline *p)
 {
 	int ret = 0;
 
-	if (fimc->pipeline.sensor) {
-		ret = fimc_pipeline_s_power(fimc, 0);
-		fimc_md_set_camclk(fimc->pipeline.sensor, false);
+	if (p->subdevs[IDX_SENSOR]) {
+		ret = fimc_pipeline_s_power(p, 0);
+		fimc_md_set_camclk(p->subdevs[IDX_SENSOR], false);
 	}
 	return ret == -ENXIO ? 0 : ret;
 }
 
-int fimc_pipeline_shutdown(struct fimc_dev *fimc)
+int fimc_pipeline_shutdown(struct fimc_pipeline *p)
 {
-	struct media_entity *me = &fimc->vid_cap.vfd->entity;
+	struct media_entity *me = &p->subdevs[IDX_SENSOR]->entity;
 	int ret;
 
 	mutex_lock(&me->parent->graph_mutex);
-	ret = __fimc_pipeline_shutdown(fimc);
+	ret = __fimc_pipeline_shutdown(p);
 	mutex_unlock(&me->parent->graph_mutex);
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(fimc_pipeline_shutdown);
 
 /**
  * fimc_pipeline_s_stream - invoke s_stream on pipeline subdevs
- * @fimc: fimc device terminating the pipeline
+ * @pipeline: video pipeline structure
  * @on: passed as the s_stream call argument
  */
-int fimc_pipeline_s_stream(struct fimc_dev *fimc, int on)
+int fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
 {
-	struct fimc_pipeline *p = &fimc->pipeline;
-	int ret = 0;
+	int i, ret;
 
-	if (p->sensor == NULL)
+	if (p->subdevs[IDX_SENSOR] == NULL)
 		return -ENODEV;
 
-	if ((on && p->csis) || !on)
-		ret = v4l2_subdev_call(on ? p->csis : p->sensor,
-				       video, s_stream, on);
-	if (ret < 0 && ret != -ENOIOCTLCMD)
-		return ret;
-	if ((!on && p->csis) || on)
-		ret = v4l2_subdev_call(on ? p->sensor : p->csis,
-				       video, s_stream, on);
-	return ret == -ENOIOCTLCMD ? 0 : ret;
+	for (i = 0; i < IDX_MAX; i++) {
+		unsigned int idx = on ? (IDX_MAX - 1) - i : i;
+
+		ret = v4l2_subdev_call(p->subdevs[idx], video, s_stream, on);
+
+		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+			return ret;
+	}
+
+	return 0;
+
 }
+EXPORT_SYMBOL_GPL(fimc_pipeline_s_stream);
 
 /*
  * Sensor subdevice helper functions
@@ -675,6 +701,7 @@ int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
 static int fimc_md_link_notify(struct media_pad *source,
 			       struct media_pad *sink, u32 flags)
 {
+	struct fimc_pipeline *pipeline;
 	struct v4l2_subdev *sd;
 	struct fimc_dev *fimc;
 	int ret = 0;
@@ -683,16 +710,26 @@ static int fimc_md_link_notify(struct media_pad *source,
 		return 0;
 
 	sd = media_entity_to_v4l2_subdev(sink->entity);
-	fimc = v4l2_get_subdevdata(sd);
 
-	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
-		ret = __fimc_pipeline_shutdown(fimc);
-		fimc->pipeline.sensor = NULL;
-		fimc->pipeline.csis = NULL;
+	switch (sd->grp_id) {
+	case FIMC_GROUP_ID:
+		fimc = v4l2_get_subdevdata(sd);
+		pipeline = &fimc->pipeline;
+		break;
+	default:
+		return 0;
+	}
 
-		mutex_lock(&fimc->lock);
-		fimc_ctrls_delete(fimc->vid_cap.ctx);
-		mutex_unlock(&fimc->lock);
+	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+		ret = __fimc_pipeline_shutdown(pipeline);
+		pipeline->subdevs[IDX_SENSOR] = NULL;
+		pipeline->subdevs[IDX_CSIS] = NULL;
+
+		if (fimc) {
+			mutex_lock(&fimc->lock);
+			fimc_ctrls_delete(fimc->vid_cap.ctx);
+			mutex_unlock(&fimc->lock);
+		}
 		return ret;
 	}
 	/*
@@ -702,7 +739,8 @@ static int fimc_md_link_notify(struct media_pad *source,
 	 */
 	mutex_lock(&fimc->lock);
 	if (fimc->vid_cap.refcnt > 0) {
-		ret = __fimc_pipeline_initialize(fimc, source->entity, true);
+			ret = __fimc_pipeline_initialize(pipeline,
+							 source->entity, true);
 		if (!ret)
 			ret = fimc_capture_ctrls_create(fimc);
 	}
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.h b/drivers/media/video/s5p-fimc/fimc-mdevice.h
index 4f3b69c..c5ac3e6 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.h
@@ -109,11 +109,11 @@ static inline void fimc_md_graph_unlock(struct fimc_dev *fimc)
 }
 
 int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
-void fimc_pipeline_prepare(struct fimc_dev *fimc, struct media_entity *me);
-int fimc_pipeline_initialize(struct fimc_dev *fimc, struct media_entity *me,
+void fimc_pipeline_prepare(struct fimc_pipeline *p, struct media_entity *me);
+int fimc_pipeline_initialize(struct fimc_pipeline *p, struct media_entity *me,
 			     bool resume);
-int fimc_pipeline_shutdown(struct fimc_dev *fimc);
-int fimc_pipeline_s_power(struct fimc_dev *fimc, int state);
-int fimc_pipeline_s_stream(struct fimc_dev *fimc, int state);
+int fimc_pipeline_shutdown(struct fimc_pipeline *p);
+int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state);
+int fimc_pipeline_s_stream(struct fimc_pipeline *p, bool state);
 
 #endif
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index 688fb3f..8587aaf 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -64,4 +64,20 @@ struct s5p_platform_fimc {
  */
 #define S5P_FIMC_TX_END_NOTIFY _IO('e', 0)
 
+enum fimc_subdev_index {
+	IDX_SENSOR,
+	IDX_CSIS,
+	IDX_FLITE,
+	IDX_FIMC,
+	IDX_MAX,
+};
+
+struct media_pipeline;
+struct v4l2_subdev;
+
+struct fimc_pipeline {
+	struct v4l2_subdev *subdevs[IDX_MAX];
+	struct media_pipeline *m_pipeline;
+};
+
 #endif /* S5P_FIMC_H_ */
-- 
1.7.10

