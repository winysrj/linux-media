Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15153 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbbIKKLa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 06:11:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [RFC 7/9] omap3isp: Use media entity enumeration API
Date: Fri, 11 Sep 2015 13:09:10 +0300
Message-Id: <1441966152-28444-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c      | 15 +++++++--------
 drivers/media/platform/omap3isp/isp.h      |  5 +++--
 drivers/media/platform/omap3isp/ispccdc.c  |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c | 11 +++++------
 drivers/media/platform/omap3isp/ispvideo.h |  4 ++--
 5 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index cb8ac90..c1ee2e3 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -881,7 +881,7 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 	 * starting entities if the pipeline won't start anyway (those entities
 	 * would then likely fail to stop, making the problem worse).
 	 */
-	if (pipe->entities & isp->crashed)
+	if (media_entity_enum_intersects(pipe->entities, isp->crashed))
 		return -EIO;
 
 	spin_lock_irqsave(&pipe->lock, flags);
@@ -974,7 +974,6 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 	struct v4l2_subdev *subdev;
 	int failure = 0;
 	int ret;
-	u32 id;
 
 	/*
 	 * We need to stop all the modules after CCDC first or they'll
@@ -1026,10 +1025,9 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 		if (ret) {
 			dev_info(isp->dev, "Unable to stop %s\n", subdev->name);
 			isp->stop_failure = true;
-			if (subdev == &isp->isp_prev.subdev) {
-				id = media_entity_id(&subdev->entity);
-				isp->crashed |= 1U << id;
-			}
+			if (subdev == &isp->isp_prev.subdev)
+				media_entity_enum_set(isp->crashed,
+						      &subdev->entity);
 			failure = -ETIMEDOUT;
 		}
 	}
@@ -1235,7 +1233,7 @@ static int isp_reset(struct isp_device *isp)
 	}
 
 	isp->stop_failure = false;
-	isp->crashed = 0;
+	media_entity_enum_init(isp->crashed);
 	return 0;
 }
 
@@ -1646,7 +1644,8 @@ static void __omap3isp_put(struct isp_device *isp, bool save_ctx)
 		/* Reset the ISP if an entity has failed to stop. This is the
 		 * only way to recover from such conditions.
 		 */
-		if (isp->crashed || isp->stop_failure)
+		if (!media_entity_enum_empty(isp->crashed) ||
+		    isp->stop_failure)
 			isp_reset(isp);
 		isp_disable_clocks(isp);
 	}
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 5acc2e6..7006c94 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -17,6 +17,7 @@
 #ifndef OMAP3_ISP_CORE_H
 #define OMAP3_ISP_CORE_H
 
+#include <media/media-entity.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <linux/clk-provider.h>
@@ -152,7 +153,7 @@ struct isp_xclk {
  * @stat_lock: Spinlock for handling statistics
  * @isp_mutex: Mutex for serializing requests to ISP.
  * @stop_failure: Indicates that an entity failed to stop.
- * @crashed: Bitmask of crashed entities (indexed by entity ID)
+ * @crashed: Crashed entities
  * @has_context: Context has been saved at least once and can be restored.
  * @ref_count: Reference count for handling multiple ISP requests.
  * @cam_ick: Pointer to camera interface clock structure.
@@ -194,7 +195,7 @@ struct isp_device {
 	spinlock_t stat_lock;	/* common lock for statistic drivers */
 	struct mutex isp_mutex;	/* For handling ref_count field */
 	bool stop_failure;
-	u32 crashed;
+	DECLARE_MEDIA_ENTITY_ENUM(crashed);
 	int has_context;
 	int ref_count;
 	unsigned int autoidle;
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index f0e530c..6cde922 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1608,7 +1608,7 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 	/* Wait for the CCDC to become idle. */
 	if (ccdc_sbl_wait_idle(ccdc, 1000)) {
 		dev_info(isp->dev, "CCDC won't become idle!\n");
-		isp->crashed |= 1U << media_entity_id(&ccdc->subdev.entity);
+		media_entity_enum_set(isp->crashed, &ccdc->subdev.entity);
 		omap3isp_pipeline_cancel_stream(pipe);
 		return 0;
 	}
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 52843ac..5937ada 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -234,7 +234,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 		struct isp_video *__video;
 
-		pipe->entities |= 1 << media_entity_id(entity);
+		media_entity_enum_set(pipe->entities, entity);
 
 		if (far_end != NULL)
 			continue;
@@ -890,7 +890,6 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 	struct v4l2_ext_control ctrl;
 	unsigned int i;
 	int ret;
-	u32 id;
 
 	/* Memory-to-memory pipelines have no external subdev. */
 	if (pipe->input != NULL)
@@ -898,7 +897,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 
 	for (i = 0; i < ARRAY_SIZE(ents); i++) {
 		/* Is the entity part of the pipeline? */
-		if (!(pipe->entities & (1 << media_entity_id(ents[i]))))
+		if (!media_entity_enum_test(pipe->entities, ents[i]))
 			continue;
 
 		/* ISP entities have always sink pad == 0. Find source. */
@@ -950,8 +949,8 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 
 	pipe->external_rate = ctrl.value64;
 
-	id = media_entity_id(&isp->isp_ccdc.subdev.entity);
-	if (pipe->entities & (1 << id)) {
+	if (media_entity_enum_test(pipe->entities,
+				   &isp->isp_ccdc.subdev.entity)) {
 		unsigned int rate = UINT_MAX;
 		/*
 		 * Check that maximum allowed CCDC pixel rate isn't
@@ -1017,7 +1016,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe = video->video.entity.pipe
 	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
 
-	pipe->entities = 0;
+	media_entity_enum_init(pipe->entities);
 
 	/* TODO: Implement PM QoS */
 	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 4071dd7..7f88765 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -80,7 +80,7 @@ enum isp_pipeline_state {
  * struct isp_pipeline - An ISP hardware pipeline
  * @field: The field being processed by the pipeline
  * @error: A hardware error occurred during capture
- * @entities: Bitmask of entities in the pipeline (indexed by entity ID)
+ * @entities: Entities in the pipeline
  */
 struct isp_pipeline {
 	struct media_pipeline pipe;
@@ -89,7 +89,7 @@ struct isp_pipeline {
 	enum isp_pipeline_stream_state stream_state;
 	struct isp_video *input;
 	struct isp_video *output;
-	u32 entities;
+	DECLARE_MEDIA_ENTITY_ENUM(entities);
 	unsigned long l3_ick;
 	unsigned int max_rate;
 	enum v4l2_field field;
-- 
2.1.0.231.g7484e3b

