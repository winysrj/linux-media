Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51016 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2HWIis (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 04:38:48 -0400
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9700E5S9BO1I90@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 17:38:46 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M9700DML9C43WA0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 17:38:43 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] s5p-fimc: Add pipeline ops to separate FIMC-LITE module
Date: Thu, 23 Aug 2012 10:38:19 +0200
Message-id: <1345711099-17565-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1345113242-12992-1-git-send-email-s.nawrocki@samsung.com>
References: <1345113242-12992-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to reuse the FIMC-LITE module on Exynos4 and Exynos5
SoC introduce a set of callbacks for the media pipeline control
from within FIMC/FIMC-LITE video node. It lets us avoid symbol
dependencies between FIMC-LITE and the whole media device driver,
which simplifies the initialization sequences and doesn't
introduce issues preventing common kernel image for exynos4 and
exynos5 SoCs.

This patch also corrects following build errors:

drivers/built-in.o: In function `buffer_queue':
drivers/media/video/s5p-fimc/fimc-lite.c:414: undefined reference
to `fimc_pipeline_s_stream'
drivers/built-in.o: In function `fimc_lite_resume':
drivers/media/video/s5p-fimc/fimc-lite.c:1518: undefined reference
to `fimc_pipeline_initialize'
drivers/built-in.o: In function `fimc_lite_suspend':
drivers/media/video/s5p-fimc/fimc-lite.c:1544: undefined reference
to `fimc_pipeline_shutdown'

when only CONFIG_VIDEO_EXYNOS_FIMC_LITE is selected, without
CONFIG_VIDEO_S5P_FIMC.

Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - ops rename: initialize/open, shutdown/close

 drivers/media/platform/s5p-fimc/fimc-capture.c | 21 ++++++-----
 drivers/media/platform/s5p-fimc/fimc-core.h    |  1 +
 drivers/media/platform/s5p-fimc/fimc-lite.c    | 22 +++++++----
 drivers/media/platform/s5p-fimc/fimc-lite.h    |  2 +
 drivers/media/platform/s5p-fimc/fimc-mdevice.c | 52 +++++++++++++++-----------
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |  6 ---
 include/media/s5p_fimc.h                       | 18 +++++++++
 7 files changed, 78 insertions(+), 44 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 4092388..749b015 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -118,7 +118,8 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 	spin_unlock_irqrestore(&fimc->slock, flags);

 	if (streaming)
-		return fimc_pipeline_s_stream(&fimc->pipeline, 0);
+		return fimc_pipeline_call(fimc, set_stream,
+					  &fimc->pipeline, 0);
 	else
 		return 0;
 }
@@ -264,7 +265,8 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 		fimc_activate_capture(ctx);

 		if (!test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
-			fimc_pipeline_s_stream(&fimc->pipeline, 1);
+			fimc_pipeline_call(fimc, set_stream,
+					   &fimc->pipeline, 1);
 	}

 	return 0;
@@ -288,7 +290,7 @@ int fimc_capture_suspend(struct fimc_dev *fimc)
 	int ret = fimc_stop_capture(fimc, suspend);
 	if (ret)
 		return ret;
-	return fimc_pipeline_shutdown(&fimc->pipeline);
+	return fimc_pipeline_call(fimc, close, &fimc->pipeline);
 }

 static void buffer_queue(struct vb2_buffer *vb);
@@ -304,8 +306,8 @@ int fimc_capture_resume(struct fimc_dev *fimc)

 	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
 	vid_cap->buf_index = 0;
-	fimc_pipeline_initialize(&fimc->pipeline, &vid_cap->vfd.entity,
-				 false);
+	fimc_pipeline_call(fimc, open, &fimc->pipeline,
+			   &vid_cap->vfd.entity, false);
 	fimc_capture_hw_init(fimc);

 	clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
@@ -422,7 +424,8 @@ static void buffer_queue(struct vb2_buffer *vb)
 		spin_unlock_irqrestore(&fimc->slock, flags);

 		if (!test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
-			fimc_pipeline_s_stream(&fimc->pipeline, 1);
+			fimc_pipeline_call(fimc, set_stream,
+					   &fimc->pipeline, 1);
 		return;
 	}
 	spin_unlock_irqrestore(&fimc->slock, flags);
@@ -502,8 +505,8 @@ static int fimc_capture_open(struct file *file)
 	}

 	if (++fimc->vid_cap.refcnt == 1) {
-		ret = fimc_pipeline_initialize(&fimc->pipeline,
-				       &fimc->vid_cap.vfd.entity, true);
+		ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
+					 &fimc->vid_cap.vfd.entity, true);

 		if (!ret && !fimc->vid_cap.user_subdev_api)
 			ret = fimc_capture_set_default_format(fimc);
@@ -536,7 +539,7 @@ static int fimc_capture_close(struct file *file)
 	if (--fimc->vid_cap.refcnt == 0) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
 		fimc_stop_capture(fimc, false);
-		fimc_pipeline_shutdown(&fimc->pipeline);
+		fimc_pipeline_call(fimc, close, &fimc->pipeline);
 		clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
 	}

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index d3a3a00..6180546 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -440,6 +440,7 @@ struct fimc_dev {
 	unsigned long			state;
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct fimc_pipeline		pipeline;
+	const struct fimc_pipeline_ops	*pipeline_ops;
 };

 /**
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 9289008..2f63830 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -28,11 +28,14 @@
 #include <media/v4l2-mem2mem.h>
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
+#include <media/s5p_fimc.h>

 #include "fimc-mdevice.h"
 #include "fimc-core.h"
+#include "fimc-lite.h"
 #include "fimc-lite-reg.h"

+
 static int debug;
 module_param(debug, int, 0644);

@@ -193,7 +196,7 @@ static int fimc_lite_reinit(struct fimc_lite *fimc, bool suspend)
 	if (!streaming)
 		return 0;

-	return fimc_pipeline_s_stream(&fimc->pipeline, 0);
+	return fimc_pipeline_call(fimc, set_stream, &fimc->pipeline, 0);
 }

 static int fimc_lite_stop_capture(struct fimc_lite *fimc, bool suspend)
@@ -307,7 +310,8 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 		flite_hw_capture_start(fimc);

 		if (!test_and_set_bit(ST_SENSOR_STREAM, &fimc->state))
-			fimc_pipeline_s_stream(&fimc->pipeline, 1);
+			fimc_pipeline_call(fimc, set_stream,
+					   &fimc->pipeline, 1);
 	}
 	if (debug > 0)
 		flite_hw_dump_regs(fimc, __func__);
@@ -411,7 +415,8 @@ static void buffer_queue(struct vb2_buffer *vb)
 		spin_unlock_irqrestore(&fimc->slock, flags);

 		if (!test_and_set_bit(ST_SENSOR_STREAM, &fimc->state))
-			fimc_pipeline_s_stream(&fimc->pipeline, 1);
+			fimc_pipeline_call(fimc, set_stream,
+					   &fimc->pipeline, 1);
 		return;
 	}
 	spin_unlock_irqrestore(&fimc->slock, flags);
@@ -466,8 +471,8 @@ static int fimc_lite_open(struct file *file)
 		goto done;

 	if (++fimc->ref_count == 1 && fimc->out_path == FIMC_IO_DMA) {
-		ret = fimc_pipeline_initialize(&fimc->pipeline,
-					       &fimc->vfd.entity, true);
+		ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
+					 &fimc->vfd.entity, true);
 		if (ret < 0) {
 			pm_runtime_put_sync(&fimc->pdev->dev);
 			fimc->ref_count--;
@@ -493,7 +498,7 @@ static int fimc_lite_close(struct file *file)
 	if (--fimc->ref_count == 0 && fimc->out_path == FIMC_IO_DMA) {
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
 		fimc_lite_stop_capture(fimc, false);
-		fimc_pipeline_shutdown(&fimc->pipeline);
+		fimc_pipeline_call(fimc, close, &fimc->pipeline);
 		clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
 	}

@@ -1505,7 +1510,8 @@ static int fimc_lite_resume(struct device *dev)
 		return 0;

 	INIT_LIST_HEAD(&fimc->active_buf_q);
-	fimc_pipeline_initialize(&fimc->pipeline, &fimc->vfd.entity, false);
+	fimc_pipeline_call(fimc, open, &fimc->pipeline,
+			   &fimc->vfd.entity, false);
 	fimc_lite_hw_init(fimc);
 	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);

@@ -1531,7 +1537,7 @@ static int fimc_lite_suspend(struct device *dev)
 	if (ret < 0 || !fimc_lite_active(fimc))
 		return ret;

-	return fimc_pipeline_shutdown(&fimc->pipeline);
+	return fimc_pipeline_call(fimc, close, &fimc->pipeline);
 }
 #endif /* CONFIG_PM_SLEEP */

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.h b/drivers/media/platform/s5p-fimc/fimc-lite.h
index 9944dd3..b04bf3b 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.h
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.h
@@ -108,6 +108,7 @@ struct flite_buffer {
  * @test_pattern: test pattern controls
  * @index: FIMC-LITE platform device index
  * @pipeline: video capture pipeline data structure
+ * @pipeline_ops: media pipeline ops for the video node driver
  * @slock: spinlock protecting this data structure and the hw registers
  * @lock: mutex serializing video device and the subdev operations
  * @clock: FIMC-LITE gate clock
@@ -142,6 +143,7 @@ struct fimc_lite {
 	struct v4l2_ctrl	*test_pattern;
 	u32			index;
 	struct fimc_pipeline	pipeline;
+	const struct fimc_pipeline_ops *pipeline_ops;

 	struct mutex		lock;
 	spinlock_t		slock;
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 3c76bd9..cb3dd4f 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-ctrls.h>
 #include <media/media-device.h>
+#include <media/s5p_fimc.h>

 #include "fimc-core.h"
 #include "fimc-lite.h"
@@ -38,7 +39,8 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
  *
  * Caller holds the graph mutex.
  */
-void fimc_pipeline_prepare(struct fimc_pipeline *p, struct media_entity *me)
+static void fimc_pipeline_prepare(struct fimc_pipeline *p,
+				  struct media_entity *me)
 {
 	struct media_pad *pad = &me->pads[0];
 	struct v4l2_subdev *sd;
@@ -114,7 +116,7 @@ static int __subdev_set_power(struct v4l2_subdev *sd, int on)
  *
  * Needs to be called with the graph mutex held.
  */
-int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
+static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
 {
 	unsigned int i;
 	int ret;
@@ -134,15 +136,15 @@ int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
 }

 /**
- * __fimc_pipeline_initialize - update the pipeline information, enable power
- *                              of all pipeline subdevs and the sensor clock
+ * __fimc_pipeline_open - update the pipeline information, enable power
+ *                        of all pipeline subdevs and the sensor clock
  * @me: media entity to start graph walk with
  * @prep: true to acquire sensor (and csis) subdevs
  *
  * This function must be called with the graph mutex held.
  */
-static int __fimc_pipeline_initialize(struct fimc_pipeline *p,
-				      struct media_entity *me, bool prep)
+static int __fimc_pipeline_open(struct fimc_pipeline *p,
+				struct media_entity *me, bool prep)
 {
 	int ret;

@@ -159,28 +161,27 @@ static int __fimc_pipeline_initialize(struct fimc_pipeline *p,
 	return fimc_pipeline_s_power(p, 1);
 }

-int fimc_pipeline_initialize(struct fimc_pipeline *p, struct media_entity *me,
-			     bool prep)
+static int fimc_pipeline_open(struct fimc_pipeline *p,
+			      struct media_entity *me, bool prep)
 {
 	int ret;

 	mutex_lock(&me->parent->graph_mutex);
-	ret =  __fimc_pipeline_initialize(p, me, prep);
+	ret =  __fimc_pipeline_open(p, me, prep);
 	mutex_unlock(&me->parent->graph_mutex);

 	return ret;
 }
-EXPORT_SYMBOL_GPL(fimc_pipeline_initialize);

 /**
- * __fimc_pipeline_shutdown - disable the sensor clock and pipeline power
+ * __fimc_pipeline_close - disable the sensor clock and pipeline power
  * @fimc: fimc device terminating the pipeline
  *
  * Disable power of all subdevs in the pipeline and turn off the external
  * sensor clock.
  * Called with the graph mutex held.
  */
-static int __fimc_pipeline_shutdown(struct fimc_pipeline *p)
+static int __fimc_pipeline_close(struct fimc_pipeline *p)
 {
 	int ret = 0;

@@ -191,7 +192,7 @@ static int __fimc_pipeline_shutdown(struct fimc_pipeline *p)
 	return ret == -ENXIO ? 0 : ret;
 }

-int fimc_pipeline_shutdown(struct fimc_pipeline *p)
+static int fimc_pipeline_close(struct fimc_pipeline *p)
 {
 	struct media_entity *me;
 	int ret;
@@ -201,12 +202,11 @@ int fimc_pipeline_shutdown(struct fimc_pipeline *p)

 	me = &p->subdevs[IDX_SENSOR]->entity;
 	mutex_lock(&me->parent->graph_mutex);
-	ret = __fimc_pipeline_shutdown(p);
+	ret = __fimc_pipeline_close(p);
 	mutex_unlock(&me->parent->graph_mutex);

 	return ret;
 }
-EXPORT_SYMBOL_GPL(fimc_pipeline_shutdown);

 /**
  * fimc_pipeline_s_stream - invoke s_stream on pipeline subdevs
@@ -232,7 +232,13 @@ int fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
 	return 0;

 }
-EXPORT_SYMBOL_GPL(fimc_pipeline_s_stream);
+
+/* Media pipeline operations for the FIMC/FIMC-LITE video device driver */
+static const struct fimc_pipeline_ops fimc_pipeline_ops = {
+	.open		= fimc_pipeline_open,
+	.close		= fimc_pipeline_close,
+	.set_stream	= fimc_pipeline_s_stream,
+};

 /*
  * Sensor subdevice helper functions
@@ -347,6 +353,7 @@ static int fimc_register_callback(struct device *dev, void *p)
 	if (fimc->pdev->id < 0 || fimc->pdev->id >= FIMC_MAX_DEVS)
 		return 0;

+	fimc->pipeline_ops = &fimc_pipeline_ops;
 	fmd->fimc[fimc->pdev->id] = fimc;
 	sd->grp_id = FIMC_GROUP_ID;

@@ -372,6 +379,7 @@ static int fimc_lite_register_callback(struct device *dev, void *p)
 	if (fimc->index >= FIMC_LITE_MAX_DEVS)
 		return 0;

+	fimc->pipeline_ops = &fimc_pipeline_ops;
 	fmd->fimc_lite[fimc->index] = fimc;
 	sd->grp_id = FLITE_GROUP_ID;

@@ -473,12 +481,14 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 		if (fmd->fimc[i] == NULL)
 			continue;
 		v4l2_device_unregister_subdev(&fmd->fimc[i]->vid_cap.subdev);
+		fmd->fimc[i]->pipeline_ops = NULL;
 		fmd->fimc[i] = NULL;
 	}
 	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
 		if (fmd->fimc_lite[i] == NULL)
 			continue;
 		v4l2_device_unregister_subdev(&fmd->fimc_lite[i]->subdev);
+		fmd->fimc[i]->pipeline_ops = NULL;
 		fmd->fimc_lite[i] = NULL;
 	}
 	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
@@ -829,7 +839,7 @@ static int fimc_md_link_notify(struct media_pad *source,
 	}

 	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
-		ret = __fimc_pipeline_shutdown(pipeline);
+		ret = __fimc_pipeline_close(pipeline);
 		pipeline->subdevs[IDX_SENSOR] = NULL;
 		pipeline->subdevs[IDX_CSIS] = NULL;

@@ -848,8 +858,8 @@ static int fimc_md_link_notify(struct media_pad *source,
 	if (fimc) {
 		mutex_lock(&fimc->lock);
 		if (fimc->vid_cap.refcnt > 0) {
-			ret = __fimc_pipeline_initialize(pipeline,
-							 source->entity, true);
+			ret = __fimc_pipeline_open(pipeline,
+						   source->entity, true);
 		if (!ret)
 			ret = fimc_capture_ctrls_create(fimc);
 		}
@@ -857,8 +867,8 @@ static int fimc_md_link_notify(struct media_pad *source,
 	} else {
 		mutex_lock(&fimc_lite->lock);
 		if (fimc_lite->ref_count > 0) {
-			ret = __fimc_pipeline_initialize(pipeline,
-							 source->entity, true);
+			ret = __fimc_pipeline_open(pipeline,
+						   source->entity, true);
 		}
 		mutex_unlock(&fimc_lite->lock);
 	}
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index d310d9c..0135386 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -108,11 +108,5 @@ static inline void fimc_md_graph_unlock(struct fimc_dev *fimc)
 }

 int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
-void fimc_pipeline_prepare(struct fimc_pipeline *p, struct media_entity *me);
-int fimc_pipeline_initialize(struct fimc_pipeline *p, struct media_entity *me,
-			     bool resume);
-int fimc_pipeline_shutdown(struct fimc_pipeline *p);
-int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state);
-int fimc_pipeline_s_stream(struct fimc_pipeline *p, bool state);

 #endif
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index 8587aaf..09421a61 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -12,6 +12,8 @@
 #ifndef S5P_FIMC_H_
 #define S5P_FIMC_H_

+#include <media/media-entity.h>
+
 enum cam_bus_type {
 	FIMC_ITU_601 = 1,
 	FIMC_ITU_656,
@@ -80,4 +82,20 @@ struct fimc_pipeline {
 	struct media_pipeline *m_pipeline;
 };

+/*
+ * Media pipeline operations to be called from within the fimc(-lite)
+ * video node when it is the last entity of the pipeline. Implemented
+ * by corresponding media device driver.
+ */
+struct fimc_pipeline_ops {
+	int (*open)(struct fimc_pipeline *p, struct media_entity *me,
+			  bool resume);
+	int (*close)(struct fimc_pipeline *p);
+	int (*set_stream)(struct fimc_pipeline *p, bool state);
+};
+
+#define fimc_pipeline_call(f, op, p, args...)				\
+	(!(f) ? -ENODEV : (((f)->pipeline_ops && (f)->pipeline_ops->op) ? \
+			    (f)->pipeline_ops->op((p), ##args) : -ENOIOCTLCMD))
+
 #endif /* S5P_FIMC_H_ */
--
1.7.11.3

