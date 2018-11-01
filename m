Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:40535 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbeKBIiA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 04:38:00 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 05/30] media: entity: Move the pipeline from entity to pads
Date: Fri,  2 Nov 2018 00:31:19 +0100
Message-Id: <20181101233144.31507-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

This moves the pipe and stream_count fields from struct media_entity to
struct media_pad. Effectively streams become pad-specific rather than
being stream specific, allowing several independent streams to traverse a
single entity.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
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
index 70db03fa33a21db1..13260149c4dfc90c 100644
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
 
@@ -865,7 +880,7 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 {
 	const u32 mask = MEDIA_LNK_FL_ENABLED;
 	struct media_device *mdev;
-	struct media_entity *source, *sink;
+	struct media_pad *source, *sink;
 	int ret = -EBUSY;
 
 	if (link == NULL)
@@ -881,8 +896,8 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
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
index 96f0a8a0dcae591f..dbadcba6739a286b 100644
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
index 77fb7987b42f33cd..3663dfd00cadc2f0 100644
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
index dc11b732dc05b00b..f354cd7ceb8ffce5 100644
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
index a2a329336243bdc7..f27a7be5f5d0f0b5 100644
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
index 0eaa353d5cb39768..ba9d9a8337cb159e 100644
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
index c8be1db532ab2555..030808b222cf3ae5 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -543,7 +543,7 @@ static int iss_pipeline_is_last(struct media_entity *me)
 	struct iss_pipeline *pipe;
 	struct media_pad *pad;
 
-	if (!me->pipe)
+	if (!me->pads->pipe)
 		return 0;
 	pipe = to_iss_pipeline(me);
 	if (pipe->stream_state == ISS_PIPELINE_STREAM_STOPPED)
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 1271bbacf9e7bdeb..65f1e358271b3743 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -877,7 +877,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	 * Start streaming on the pipeline. No link touching an entity in the
 	 * pipeline can be activated or deactivated once streaming is started.
 	 */
-	pipe = pad->entity->pipe
+	pipe = pad->pipe
 	     ? to_iss_pipeline(pad->entity) : &video->pipe;
 	pipe->external = NULL;
 	pipe->external_rate = 0;
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index f22489edb5624af2..cdea8543b3f93ecf 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -94,7 +94,7 @@ struct iss_pipeline {
 };
 
 #define to_iss_pipeline(__e) \
-	container_of((__e)->pipe, struct iss_pipeline, pipe)
+	container_of((__e)->pads->pipe, struct iss_pipeline, pipe)
 
 static inline int iss_pipeline_ready(struct iss_pipeline *pipe)
 {
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index cde6350d752bb0ae..ca0b79288ea7fd11 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -188,15 +188,25 @@ enum media_pad_signal_type {
  *
  * @graph_obj:	Embedded structure containing the media object common data
  * @entity:	Entity this pad belongs to
+ * @pipe:	Pipeline this entity belongs to.
+ * @stream_count: Stream count for the entity.
  * @index:	Pad index in the entity pads array, numbered from 0 to n
  * @sig_type:	Type of the signal inside a media pad
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
 	enum media_pad_signal_type sig_type;
 	unsigned long flags;
@@ -274,9 +284,7 @@ enum media_entity_type {
  * @pads:	Pads array with the size defined by @num_pads.
  * @links:	List of data links.
  * @ops:	Entity operations.
- * @stream_count: Stream count for the entity.
  * @use_count:	Use count for the entity.
- * @pipe:	Pipeline this entity belongs to.
  * @info:	Union with devnode information.  Kept just for backward
  *		compatibility.
  * @info.dev:	Contains device major and minor info.
@@ -289,7 +297,7 @@ enum media_entity_type {
  *
  * .. note::
  *
- *    @stream_count and @use_count reference counts must never be
+ *    @use_count reference counts must never be
  *    negative, but are signed integers on purpose: a simple ``WARN_ON(<0)``
  *    check can be used to detect reference count bugs that would make them
  *    negative.
@@ -311,11 +319,8 @@ struct media_entity {
 
 	const struct media_entity_operations *ops;
 
-	int stream_count;
 	int use_count;
 
-	struct media_pipeline *pipe;
-
 	union {
 		struct {
 			u32 major;
-- 
2.19.1
