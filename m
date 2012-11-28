Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:47164 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab2K1TSf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:18:35 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700HVEPMTEYB0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:18:34 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME700C69PML0A30@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:18:34 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 12/12] fimc-lite: Add ISP FIFO output support
Date: Wed, 28 Nov 2012 20:18:18 +0100
Message-id: <1354130298-3071-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1354130298-3071-1-git-send-email-s.nawrocki@samsung.com>
References: <1354130298-3071-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add second source media pad for the FIFO data output to FIMC-IS
and implement subdev s_stream op for configurations where FIMC-LITE
is used as a glue logic between FIMC-IS and MIPI-CSIS or an image
sensor. The second source media pad will be linked to the FIMC-LITE
video node.
For proper configuration the attached image sensor/video encoder
properties are needed, like video bus type, signal polarities, etc.
For this purpose there is a small routine added that walks the
pipeline and return the sensor subdev.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-lite.c    |  147 ++++++++++++++++++------
 drivers/media/platform/s5p-fimc/fimc-lite.h    |    7 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
 3 files changed, 119 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index d9e7d6f..4df4afd 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -120,25 +120,29 @@ static const struct fimc_fmt *fimc_lite_find_format(const u32 *pixelformat,
 	return def_fmt;
 }
 
-static int fimc_lite_hw_init(struct fimc_lite *fimc)
+static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
 {
 	struct fimc_pipeline *pipeline = &fimc->pipeline;
-	struct fimc_sensor_info *sensor;
+	struct v4l2_subdev *sensor;
+	struct fimc_sensor_info *si;
 	unsigned long flags;
 
-	if (pipeline->subdevs[IDX_SENSOR] == NULL)
+	sensor = isp_output ? fimc->sensor : pipeline->subdevs[IDX_SENSOR];
+
+	if (sensor == NULL)
 		return -ENXIO;
 
 	if (fimc->fmt == NULL)
 		return -EINVAL;
 
-	sensor = v4l2_get_subdev_hostdata(pipeline->subdevs[IDX_SENSOR]);
+	/* Get sensor configuration data from the sensor subdev */
+	si = v4l2_get_subdev_hostdata(sensor);
 	spin_lock_irqsave(&fimc->slock, flags);
 
-	flite_hw_set_camera_bus(fimc, &sensor->pdata);
+	flite_hw_set_camera_bus(fimc, &si->pdata);
 	flite_hw_set_source_format(fimc, &fimc->inp_frame);
 	flite_hw_set_window_offset(fimc, &fimc->inp_frame);
-	flite_hw_set_output_dma(fimc, &fimc->out_frame, true);
+	flite_hw_set_output_dma(fimc, &fimc->out_frame, !isp_output);
 	flite_hw_set_interrupt_mask(fimc);
 	flite_hw_set_test_pattern(fimc, fimc->test_pattern->val);
 
@@ -296,7 +300,7 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 
 	fimc->frame_count = 0;
 
-	ret = fimc_lite_hw_init(fimc);
+	ret = fimc_lite_hw_init(fimc, false);
 	if (ret) {
 		fimc_lite_reinit(fimc, false);
 		return ret;
@@ -460,6 +464,11 @@ static int fimc_lite_open(struct file *file)
 	if (mutex_lock_interruptible(&fimc->lock))
 		return -ERESTARTSYS;
 
+	if (fimc->out_path != FIMC_IO_DMA) {
+		ret = -EBUSY;
+		goto done;
+	}
+
 	set_bit(ST_FLITE_IN_USE, &fimc->state);
 	ret = pm_runtime_get_sync(&fimc->pdev->dev);
 	if (ret < 0)
@@ -962,6 +971,29 @@ static const struct v4l2_ioctl_ops fimc_lite_ioctl_ops = {
 	.vidioc_streamoff		= fimc_lite_streamoff,
 };
 
+/* Called with the media graph mutex held */
+static struct v4l2_subdev *__find_remote_sensor(struct media_entity *me)
+{
+	struct media_pad *pad = &me->pads[0];
+	struct v4l2_subdev *sd;
+
+	while (pad->flags & MEDIA_PAD_FL_SINK) {
+		/* source pad */
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+
+		if (sd->grp_id == GRP_ID_FIMC_IS_SENSOR)
+			return sd;
+		/* sink pad */
+		pad = &sd->entity.pads[0];
+	}
+	return NULL;
+}
+
 /* Capture subdev media entity operations */
 static int fimc_lite_link_setup(struct media_entity *entity,
 				const struct media_pad *local,
@@ -970,46 +1002,60 @@ static int fimc_lite_link_setup(struct media_entity *entity,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
 	unsigned int remote_ent_type = media_entity_type(remote->entity);
+	int ret = 0;
 
 	if (WARN_ON(fimc == NULL))
 		return 0;
 
 	v4l2_dbg(1, debug, sd, "%s: %s --> %s, flags: 0x%x. source_id: 0x%x",
-		 __func__, local->entity->name, remote->entity->name,
+		 __func__, remote->entity->name, local->entity->name,
 		 flags, fimc->source_subdev_grp_id);
 
-	switch (local->index) {
-	case FIMC_SD_PAD_SINK:
-		if (remote_ent_type != MEDIA_ENT_T_V4L2_SUBDEV)
-			return -EINVAL;
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
 
+	switch (local->index) {
+	case FLITE_SD_PAD_SINK:
+		if (remote_ent_type != MEDIA_ENT_T_V4L2_SUBDEV) {
+			ret = -EINVAL;
+			break;
+		}
 		if (flags & MEDIA_LNK_FL_ENABLED) {
-			if (fimc->source_subdev_grp_id != 0)
-				return -EBUSY;
-			fimc->source_subdev_grp_id = sd->grp_id;
-			return 0;
+			if (fimc->source_subdev_grp_id == 0)
+				fimc->source_subdev_grp_id = sd->grp_id;
+			else
+				ret = -EBUSY;
+		} else {
+			fimc->source_subdev_grp_id = 0;
+			fimc->sensor = NULL;
 		}
+		break;
 
-		fimc->source_subdev_grp_id = 0;
+	case FLITE_SD_PAD_SOURCE_DMA:
+		if (!(flags & MEDIA_LNK_FL_ENABLED))
+			fimc->out_path = FIMC_IO_NONE;
+		else if (remote_ent_type == MEDIA_ENT_T_DEVNODE_V4L)
+			fimc->out_path = FIMC_IO_DMA;
+		else
+			ret = -EINVAL;
 		break;
 
-	case FIMC_SD_PAD_SOURCE:
-		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+	case FLITE_SD_PAD_SOURCE_ISP:
+		if (!(flags & MEDIA_LNK_FL_ENABLED))
 			fimc->out_path = FIMC_IO_NONE;
-			return 0;
-		}
-		if (remote_ent_type == MEDIA_ENT_T_V4L2_SUBDEV)
+		else if (remote_ent_type == MEDIA_ENT_T_V4L2_SUBDEV)
 			fimc->out_path = FIMC_IO_ISP;
 		else
-			fimc->out_path = FIMC_IO_DMA;
+			ret = -EINVAL;
 		break;
 
 	default:
 		v4l2_err(sd, "Invalid pad index\n");
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	return 0;
+	mutex_unlock(&fimc->lock);
+	return ret;
 }
 
 static const struct media_entity_operations fimc_lite_subdev_media_ops = {
@@ -1188,17 +1234,49 @@ static int fimc_lite_subdev_set_selection(struct v4l2_subdev *sd,
 static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+	unsigned long flags;
+	int ret;
 
-	if (fimc->out_path == FIMC_IO_DMA)
-		return -ENOIOCTLCMD;
-
-	/* TODO: */
+	/*
+	 * Find sensor subdev linked to FIMC-LITE directly or through
+	 * MIPI-CSIS. This is required for configuration where FIMC-LITE
+	 * is used as a subdev only and feeds data internally to FIMC-IS.
+	 * The pipeline links are protected through entity.stream_count
+	 * so there is no need to take the media graph mutex here.
+	 */
+	fimc->sensor = __find_remote_sensor(&sd->entity);
 
-	return 0;
+	mutex_lock(&fimc->lock);
+	if (fimc->out_path != FIMC_IO_ISP) {
+		mutex_unlock(&fimc->lock);
+		return -ENOIOCTLCMD;
+	}
 
+	if (on) {
+		flite_hw_reset(fimc);
+		ret = fimc_lite_hw_init(fimc, true);
+		if (!ret) {
+			spin_lock_irqsave(&fimc->slock, flags);
+			flite_hw_capture_start(fimc);
+			spin_unlock_irqrestore(&fimc->slock, flags);
+		}
+	} else {
+		set_bit(ST_FLITE_OFF, &fimc->state);
 
+		spin_lock_irqsave(&fimc->slock, flags);
+		flite_hw_capture_stop(fimc);
+		spin_unlock_irqrestore(&fimc->slock, flags);
 
+		ret = wait_event_timeout(fimc->irq_queue,
+				!test_bit(ST_FLITE_OFF, &fimc->state),
+				msecs_to_jiffies(200));
+		if (ret == 0)
+			v4l2_err(sd, "s_stream(0) timeout\n");
+		clear_bit(ST_FLITE_RUN, &fimc->state);
+	}
 
+	mutex_unlock(&fimc->lock);
+	return ret;
 }
 
 static int fimc_lite_log_status(struct v4l2_subdev *sd)
@@ -1338,9 +1416,10 @@ static int fimc_lite_create_capture_subdev(struct fimc_lite *fimc)
 	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
 	snprintf(sd->name, sizeof(sd->name), "FIMC-LITE.%d", fimc->index);
 
-	fimc->subdev_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
-	fimc->subdev_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&sd->entity, FIMC_SD_PADS_NUM,
+	fimc->subdev_pads[FLITE_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	fimc->subdev_pads[FLITE_SD_PAD_SOURCE_DMA].flags = MEDIA_PAD_FL_SOURCE;
+	fimc->subdev_pads[FLITE_SD_PAD_SOURCE_ISP].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, FLITE_SD_PADS_NUM,
 				fimc->subdev_pads, 0);
 	if (ret)
 		return ret;
@@ -1509,7 +1588,7 @@ static int fimc_lite_resume(struct device *dev)
 	INIT_LIST_HEAD(&fimc->active_buf_q);
 	fimc_pipeline_call(fimc, open, &fimc->pipeline,
 			   &fimc->vfd.entity, false);
-	fimc_lite_hw_init(fimc);
+	fimc_lite_hw_init(fimc, fimc->out_path == FIMC_IO_ISP);
 	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
 
 	for (i = 0; i < fimc->reqbufs_count; i++) {
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.h b/drivers/media/platform/s5p-fimc/fimc-lite.h
index 3081db3..4576922 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.h
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.h
@@ -45,8 +45,9 @@ enum {
 };
 
 #define FLITE_SD_PAD_SINK	0
-#define FLITE_SD_PAD_SOURCE	1
-#define FLITE_SD_PADS_NUM	2
+#define FLITE_SD_PAD_SOURCE_DMA	1
+#define FLITE_SD_PAD_SOURCE_ISP	2
+#define FLITE_SD_PADS_NUM	3
 
 struct flite_variant {
 	unsigned short max_width;
@@ -104,6 +105,7 @@ struct flite_buffer {
  * @subdev: FIMC-LITE subdev
  * @vd_pad: media (sink) pad for the capture video node
  * @subdev_pads: the subdev media pads
+ * @sensor: sensor subdev attached to FIMC-LITE directly or through MIPI-CSIS
  * @ctrl_handler: v4l2 control handler
  * @test_pattern: test pattern controls
  * @index: FIMC-LITE platform device index
@@ -139,6 +141,7 @@ struct fimc_lite {
 	struct v4l2_subdev	subdev;
 	struct media_pad	vd_pad;
 	struct media_pad	subdev_pads[FLITE_SD_PADS_NUM];
+	struct v4l2_subdev	*sensor;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_ctrl	*test_pattern;
 	u32			index;
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 2c2d5f3..3219e48 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -603,7 +603,7 @@ static int __fimc_md_create_flite_source_links(struct fimc_md *fmd)
 		source = &fimc->subdev.entity;
 		sink = &fimc->vfd.entity;
 		/* FIMC-LITE's subdev and video node */
-		ret = media_entity_create_link(source, FIMC_SD_PAD_SOURCE,
+		ret = media_entity_create_link(source, FLITE_SD_PAD_SOURCE_DMA,
 					       sink, 0, flags);
 		if (ret)
 			break;
-- 
1.7.9.5

