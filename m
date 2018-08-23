Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:12132 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730648AbeHWQ5r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 12:57:47 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 05/30] media: entity: Move the pipeline from entity to pads
Date: Thu, 23 Aug 2018 15:25:19 +0200
Message-Id: <20180823132544.521-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

This moves the pipe and stream_count fields from struct media_entity to
struct media_pad. Effectively streams become pad-specific rather than
being stream specific, allowing several independent streams to traverse a
single entity.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c                  | 61 ++++++++++++-------
 drivers/media/platform/exynos4-is/fimc-isp.c  |  2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c |  2 +-
 drivers/media/platform/omap3isp/isp.c         |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c    |  2 +-
 drivers/media/platform/omap3isp/ispvideo.h    |  2 +-
 drivers/media/platform/rcar-vin/rcar-dma.c    |  2 +-
 drivers/media/platform/xilinx/xilinx-dma.c    |  2 +-
 drivers/media/platform/xilinx/xilinx-dma.h    |  2 +-
 drivers/staging/media/imx/imx-media-utils.c   |  2 +-
 drivers/staging/media/omap4iss/iss.c          |  2 +-
 drivers/staging/media/omap4iss/iss_video.c    |  2 +-
 drivers/staging/media/omap4iss/iss_video.h    |  2 +-
 include/media/media-entity.h                  | 17 ++++--
 14 files changed, 61 insertions(+), 41 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index ec7c61dff6ae879d..239036a7582cbc95 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -419,7 +419,7 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
 	struct media_pad *pad = entity->pads;
 	struct media_pad *pad_err = pad;
 	struct media_link *link;
-	int ret;
+	int ret = 0;
 
 	if (!pipe->streaming_count++) {
 		ret = media_graph_walk_init(&pipe->graph, mdev);
@@ -431,21 +431,27 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
 
 	while ((pad = media_graph_walk_next(graph))) {
 		struct media_entity *entity = pad->entity;
+		unsigned int i;
+		bool skip_validation = pad->pipe;
 
 		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
 		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_MAX_PADS);
 
-		entity->stream_count++;
+		for (i = 0; i < entity->num_pads; i++) {
+			struct media_pad *iter = &entity->pads[i];
 
-		if (WARN_ON(entity->pipe && entity->pipe != pipe)) {
-			ret = -EBUSY;
-			goto error;
+			if (iter->pipe && WARN_ON(iter->pipe != pipe))
+				ret = -EBUSY;
+			else
+				iter->pipe = pipe;
+			iter->stream_count++;
 		}
 
-		entity->pipe = pipe;
+		if (ret)
+			goto error;
 
 		/* Already streaming --- no need to check. */
-		if (entity->stream_count > 1)
+		if (skip_validation)
 			continue;
 
 		if (!entity->ops || !entity->ops->link_validate)
@@ -514,19 +520,24 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
 
 	while ((pad_err = media_graph_walk_next(graph))) {
 		struct media_entity *entity_err = pad_err->entity;
+		unsigned int i;
+
+		for (i = 0; i < entity_err->num_pads; i++) {
+			struct media_pad *iter = &entity_err->pads[i];
 
-		/* Sanity check for negative stream_count */
-		if (!WARN_ON_ONCE(entity_err->stream_count <= 0)) {
-			entity_err->stream_count--;
-			if (entity_err->stream_count == 0)
-				entity_err->pipe = NULL;
+			/* Sanity check for negative stream_count */
+			if (!WARN_ON_ONCE(iter->stream_count <= 0)) {
+				--iter->stream_count;
+				if (iter->stream_count == 0)
+					iter->pipe = NULL;
+			}
 		}
 
 		/*
 		 * We haven't increased stream_count further than this
 		 * so we quit here.
 		 */
-		if (pad_err == pad)
+		if (pad_err->entity == pad->entity)
 			break;
 	}
 
@@ -553,7 +564,7 @@ EXPORT_SYMBOL_GPL(media_pipeline_start);
 
 void __media_pipeline_stop(struct media_entity *entity)
 {
-	struct media_pipeline *pipe = entity->pipe;
+	struct media_pipeline *pipe = entity->pads->pipe;
 	struct media_graph *graph = &pipe->graph;
 	struct media_pad *pad;
 
@@ -567,13 +578,17 @@ void __media_pipeline_stop(struct media_entity *entity)
 	media_graph_walk_start(graph, entity->pads);
 
 	while ((pad = media_graph_walk_next(graph))) {
-		struct media_entity *entity = pad->entity;
+		unsigned int i;
 
-		/* Sanity check for negative stream_count */
-		if (!WARN_ON_ONCE(entity->stream_count <= 0)) {
-			entity->stream_count--;
-			if (entity->stream_count == 0)
-				entity->pipe = NULL;
+		for (i = 0; i < entity->num_pads; i++) {
+			struct media_pad *iter = &entity->pads[i];
+
+			/* Sanity check for negative stream_count */
+			if (!WARN_ON_ONCE(iter->stream_count <= 0)) {
+				iter->stream_count--;
+				if (iter->stream_count == 0)
+					iter->pipe = NULL;
+			}
 		}
 	}
 
@@ -839,7 +854,7 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 {
 	const u32 mask = MEDIA_LNK_FL_ENABLED;
 	struct media_device *mdev;
-	struct media_entity *source, *sink;
+	struct media_pad *source, *sink;
 	int ret = -EBUSY;
 
 	if (link == NULL)
@@ -855,8 +870,8 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 	if (link->flags == flags)
 		return 0;
 
-	source = link->source->entity;
-	sink = link->sink->entity;
+	source = link->source;
+	sink = link->sink;
 
 	if (!(link->flags & MEDIA_LNK_FL_DYNAMIC) &&
 	    (source->stream_count || sink->stream_count))
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index 9a48c0f69320ba35..79d128a57e87fd58 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -229,7 +229,7 @@ static int fimc_isp_subdev_set_fmt(struct v4l2_subdev *sd,
 			}
 		}
 	} else {
-		if (sd->entity.stream_count == 0) {
+		if (sd->entity.pads->stream_count == 0) {
 			if (fmt->pad == FIMC_ISP_SD_PAD_SINK) {
 				struct v4l2_subdev_format format = *fmt;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 70d5f5586a5d5ca6..f486eeed805b0bbc 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1096,7 +1096,7 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 	mutex_lock(&fimc->lock);
 
 	if ((atomic_read(&fimc->out_path) == FIMC_IO_ISP &&
-	    sd->entity.stream_count > 0) ||
+	    sd->entity.pads->stream_count > 0) ||
 	    (atomic_read(&fimc->out_path) == FIMC_IO_DMA &&
 	    vb2_is_busy(&fimc->vb_queue))) {
 		mutex_unlock(&fimc->lock);
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 842e2235047d9c63..c487efe8c153942b 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -927,7 +927,7 @@ static int isp_pipeline_is_last(struct media_entity *me)
 	struct isp_pipeline *pipe;
 	struct media_pad *pad;
 
-	if (!me->pipe)
+	if (!me->pads->pipe)
 		return 0;
 	pipe = to_isp_pipeline(me);
 	if (pipe->stream_state == ISP_PIPELINE_STREAM_STOPPED)
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 1f52779249cfaf60..5ac7ac8c98d52ac8 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1102,7 +1102,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	/* Start streaming on the pipeline. No link touching an entity in the
 	 * pipeline can be activated or deactivated once streaming is started.
 	 */
-	pipe = video->video.entity.pipe
+	pipe = video->video.entity.pads->pipe
 	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
 
 	ret = media_entity_enum_init(&pipe->ent_enum, &video->isp->media_dev);
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index f6a2082b4a0a7708..8f4146c25a1b1293 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -103,7 +103,7 @@ struct isp_pipeline {
 };
 
 #define to_isp_pipeline(__e) \
-	container_of((__e)->pipe, struct isp_pipeline, pipe)
+	container_of((__e)->pads->pipe, struct isp_pipeline, pipe)
 
 static inline int isp_pipeline_ready(struct isp_pipeline *pipe)
 {
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 92323310f7352147..e749096926f34d4a 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1128,7 +1128,7 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
 	 */
 	mdev = vin->vdev.entity.graph_obj.mdev;
 	mutex_lock(&mdev->graph_mutex);
-	pipe = sd->entity.pipe ? sd->entity.pipe : &vin->vdev.pipe;
+	pipe = sd->entity.pads->pipe ? sd->entity.pads->pipe : &vin->vdev.pipe;
 	ret = __media_pipeline_start(&vin->vdev.entity, pipe);
 	mutex_unlock(&mdev->graph_mutex);
 	if (ret)
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 9f0a53238d510fce..9ea9a58eec632b7b 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -406,7 +406,7 @@ static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int count)
 	 * Use the pipeline object embedded in the first DMA object that starts
 	 * streaming.
 	 */
-	pipe = dma->video.entity.pipe
+	pipe = dma->video.entity.pads->pipe
 	     ? to_xvip_pipeline(&dma->video.entity) : &dma->pipe;
 
 	ret = media_pipeline_start(&dma->video.entity, &pipe->pipe);
diff --git a/drivers/media/platform/xilinx/xilinx-dma.h b/drivers/media/platform/xilinx/xilinx-dma.h
index e95d136c153a8f5f..c12e053ff41eed1c 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.h
+++ b/drivers/media/platform/xilinx/xilinx-dma.h
@@ -50,7 +50,7 @@ struct xvip_pipeline {
 
 static inline struct xvip_pipeline *to_xvip_pipeline(struct media_entity *e)
 {
-	return container_of(e->pipe, struct xvip_pipeline, pipe);
+	return container_of(e->pads->pipe, struct xvip_pipeline, pipe);
 }
 
 /**
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 8aa13403b09d15f6..1cfa77a96e610f6c 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -917,7 +917,7 @@ int imx_media_pipeline_set_stream(struct imx_media_dev *imxmd,
 			__media_pipeline_stop(entity);
 	} else {
 		v4l2_subdev_call(sd, video, s_stream, 0);
-		if (entity->pipe)
+		if (entity->pads->pipe)
 			__media_pipeline_stop(entity);
 	}
 
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index b1036baebb0357e7..6785363c09e9ba43 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -547,7 +547,7 @@ static int iss_pipeline_is_last(struct media_entity *me)
 	struct iss_pipeline *pipe;
 	struct media_pad *pad;
 
-	if (!me->pipe)
+	if (!me->pads->pipe)
 		return 0;
 	pipe = to_iss_pipeline(me);
 	if (pipe->stream_state == ISS_PIPELINE_STREAM_STOPPED)
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 28efafa0621ef010..d1d91a79992a61bc 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -880,7 +880,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	 * Start streaming on the pipeline. No link touching an entity in the
 	 * pipeline can be activated or deactivated once streaming is started.
 	 */
-	pipe = pad->entity->pipe
+	pipe = pad->pipe
 	     ? to_iss_pipeline(pad->entity) : &video->pipe;
 	pipe->external = NULL;
 	pipe->external_rate = 0;
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index d7e05d04512c5176..8e57a92a622c4145 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -98,7 +98,7 @@ struct iss_pipeline {
 };
 
 #define to_iss_pipeline(__e) \
-	container_of((__e)->pipe, struct iss_pipeline, pipe)
+	container_of((__e)->pads->pipe, struct iss_pipeline, pipe)
 
 static inline int iss_pipeline_ready(struct iss_pipeline *pipe)
 {
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index fad1776cbaadbbab..4f68638153679a36 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -160,14 +160,24 @@ struct media_link {
  *
  * @graph_obj:	Embedded structure containing the media object common data
  * @entity:	Entity this pad belongs to
+ * @pipe:	Pipeline this entity belongs to.
+ * @stream_count: Stream count for the entity.
  * @index:	Pad index in the entity pads array, numbered from 0 to n
  * @flags:	Pad flags, as defined in
  *		:ref:`include/uapi/linux/media.h <media_header>`
  *		(seek for ``MEDIA_PAD_FL_*``)
+ * .. note::
+ *
+ *    @stream_count reference counts must never be negative, but are
+ *    signed integers on purpose: a simple ``WARN_ON(<0)`` check can
+ *    be used to detect reference count bugs that would make them
+ *    negative.
  */
 struct media_pad {
 	struct media_gobj graph_obj;	/* must be first field in struct */
 	struct media_entity *entity;
+	struct media_pipeline *pipe;
+	int stream_count;
 	u16 index;
 	unsigned long flags;
 };
@@ -244,9 +254,7 @@ enum media_entity_type {
  * @pads:	Pads array with the size defined by @num_pads.
  * @links:	List of data links.
  * @ops:	Entity operations.
- * @stream_count: Stream count for the entity.
  * @use_count:	Use count for the entity.
- * @pipe:	Pipeline this entity belongs to.
  * @info:	Union with devnode information.  Kept just for backward
  *		compatibility.
  * @info.dev:	Contains device major and minor info.
@@ -259,7 +267,7 @@ enum media_entity_type {
  *
  * .. note::
  *
- *    @stream_count and @use_count reference counts must never be
+ *    @use_count reference counts must never be
  *    negative, but are signed integers on purpose: a simple ``WARN_ON(<0)``
  *    check can be used to detect reference count bugs that would make them
  *    negative.
@@ -281,11 +289,8 @@ struct media_entity {
 
 	const struct media_entity_operations *ops;
 
-	int stream_count;
 	int use_count;
 
-	struct media_pipeline *pipe;
-
 	union {
 		struct {
 			u32 major;
-- 
2.18.0
