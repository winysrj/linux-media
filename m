Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57736 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753834AbcLIOxy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 09:53:54 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Subject: [PATCH v2 3/9] media: Rename graph and pipeline structs and functions
Date: Fri,  9 Dec 2016 16:53:36 +0200
Message-Id: <1481295222-14743-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media_entity_pipeline_start() and media_entity_pipeline_stop()
functions are renamed as media_pipeline_start() and media_pipeline_stop(),
respectively. The reason is two-fold: the pipeline struct is, rightly,
already called media_pipeline (rather than media_entity_pipeline) and what
this really is about is a pipeline. A pipeline consists of entities ---
and, well, other objects embedded in these entities.

As the pipeline object will be in the future moved from entities to pads
in order to support multiple pipelines through a single entity, do the
renaming now.

Similarly, functions operating on struct media_entity_graph as well as the
struct itself are renamed by dropping the "entity_" part from the prefix
of the function family and the data structure. The graph traversal which
is what the functions are about is not specifically about entities only
and will operate on pads for the same reason as the media pipeline.

The patch has been generated using the following command:

git grep -l media_entity |xargs perl -i -pe '
	s/media_entity_pipeline/media_pipeline/g;
	s/media_entity_graph/media_graph/g'

And a few manual edits related to line start alignment and line wrapping.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/media/kapi/mc-core.rst               | 18 ++---
 drivers/media/media-device.c                       |  8 +--
 drivers/media/media-entity.c                       | 77 +++++++++++-----------
 drivers/media/platform/exynos4-is/fimc-capture.c   |  8 +--
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  8 +--
 drivers/media/platform/exynos4-is/fimc-lite.c      |  8 +--
 drivers/media/platform/exynos4-is/media-dev.c      | 16 ++---
 drivers/media/platform/exynos4-is/media-dev.h      |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c         | 16 ++---
 drivers/media/platform/s3c-camif/camif-capture.c   |  6 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |  4 +-
 drivers/media/platform/vsp1/vsp1_video.c           | 16 ++---
 drivers/media/platform/xilinx/xilinx-dma.c         | 16 ++---
 drivers/media/usb/au0828/au0828-core.c             |  4 +-
 drivers/media/v4l2-core/v4l2-mc.c                  | 18 ++---
 drivers/staging/media/davinci_vpfe/vpfe_video.c    | 25 ++++---
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |  2 +-
 drivers/staging/media/omap4iss/iss_video.c         | 32 ++++-----
 include/media/media-device.h                       |  2 +-
 include/media/media-entity.h                       | 65 +++++++++---------
 20 files changed, 174 insertions(+), 177 deletions(-)

diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index 1a738e5..0c05503 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -162,13 +162,13 @@ framework provides a depth-first graph traversal API for that purpose.
    currently defined as 16.
 
 Drivers initiate a graph traversal by calling
-:c:func:`media_entity_graph_walk_start()`
+:c:func:`media_graph_walk_start()`
 
 The graph structure, provided by the caller, is initialized to start graph
 traversal at the given entity.
 
 Drivers can then retrieve the next entity by calling
-:c:func:`media_entity_graph_walk_next()`
+:c:func:`media_graph_walk_next()`
 
 When the graph traversal is complete the function will return ``NULL``.
 
@@ -206,7 +206,7 @@ Pipelines and media streams
 
 When starting streaming, drivers must notify all entities in the pipeline to
 prevent link states from being modified during streaming by calling
-:c:func:`media_entity_pipeline_start()`.
+:c:func:`media_pipeline_start()`.
 
 The function will mark all entities connected to the given entity through
 enabled links, either directly or indirectly, as streaming.
@@ -218,17 +218,17 @@ in higher-level pipeline structures and can then access the
 pipeline through the struct :c:type:`media_entity`
 pipe field.
 
-Calls to :c:func:`media_entity_pipeline_start()` can be nested.
+Calls to :c:func:`media_pipeline_start()` can be nested.
 The pipeline pointer must be identical for all nested calls to the function.
 
-:c:func:`media_entity_pipeline_start()` may return an error. In that case,
+:c:func:`media_pipeline_start()` may return an error. In that case,
 it will clean up any of the changes it did by itself.
 
 When stopping the stream, drivers must notify the entities with
-:c:func:`media_entity_pipeline_stop()`.
+:c:func:`media_pipeline_stop()`.
 
-If multiple calls to :c:func:`media_entity_pipeline_start()` have been
-made the same number of :c:func:`media_entity_pipeline_stop()` calls
+If multiple calls to :c:func:`media_pipeline_start()` have been
+made the same number of :c:func:`media_pipeline_stop()` calls
 are required to stop streaming.
 The :c:type:`media_entity`.\ ``pipe`` field is reset to ``NULL`` on the last
 nested stop call.
@@ -245,7 +245,7 @@ operation must be done with the media_device graph_mutex held.
 Link validation
 ^^^^^^^^^^^^^^^
 
-Link validation is performed by :c:func:`media_entity_pipeline_start()`
+Link validation is performed by :c:func:`media_pipeline_start()`
 for any entity which has sink pads in the pipeline. The
 :c:type:`media_entity`.\ ``link_validate()`` callback is used for that
 purpose. In ``link_validate()`` callback, entity driver should check
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 8756275..8717a0d 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -601,19 +601,19 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 
 	if (mdev->entity_internal_idx_max
 	    >= mdev->pm_count_walk.ent_enum.idx_max) {
-		struct media_entity_graph new = { .top = 0 };
+		struct media_graph new = { .top = 0 };
 
 		/*
 		 * Initialise the new graph walk before cleaning up
 		 * the old one in order not to spoil the graph walk
 		 * object of the media device if graph walk init fails.
 		 */
-		ret = media_entity_graph_walk_init(&new, mdev);
+		ret = media_graph_walk_init(&new, mdev);
 		if (ret) {
 			mutex_unlock(&mdev->graph_mutex);
 			return ret;
 		}
-		media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
+		media_graph_walk_cleanup(&mdev->pm_count_walk);
 		mdev->pm_count_walk = new;
 	}
 	mutex_unlock(&mdev->graph_mutex);
@@ -695,7 +695,7 @@ void media_device_cleanup(struct media_device *mdev)
 {
 	ida_destroy(&mdev->entity_internal_idx);
 	mdev->entity_internal_idx_max = 0;
-	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
+	media_graph_walk_cleanup(&mdev->pm_count_walk);
 	mutex_destroy(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_device_cleanup);
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 3809257..26cea7d 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -258,7 +258,7 @@ media_entity_other(struct media_entity *entity, struct media_link *link)
 }
 
 /* push an entity to traversal stack */
-static void stack_push(struct media_entity_graph *graph,
+static void stack_push(struct media_graph *graph,
 		       struct media_entity *entity)
 {
 	if (graph->top == MEDIA_ENTITY_ENUM_MAX_DEPTH - 1) {
@@ -270,7 +270,7 @@ static void stack_push(struct media_entity_graph *graph,
 	graph->stack[graph->top].entity = entity;
 }
 
-static struct media_entity *stack_pop(struct media_entity_graph *graph)
+static struct media_entity *stack_pop(struct media_graph *graph)
 {
 	struct media_entity *entity;
 
@@ -289,35 +289,35 @@ static struct media_entity *stack_pop(struct media_entity_graph *graph)
 #define MEDIA_ENTITY_MAX_PADS		512
 
 /**
- * media_entity_graph_walk_init - Allocate resources for graph walk
+ * media_graph_walk_init - Allocate resources for graph walk
  * @graph: Media graph structure that will be used to walk the graph
  * @mdev: Media device
  *
  * Reserve resources for graph walk in media device's current
  * state. The memory must be released using
- * media_entity_graph_walk_free().
+ * media_graph_walk_free().
  *
  * Returns error on failure, zero on success.
  */
-__must_check int media_entity_graph_walk_init(
-	struct media_entity_graph *graph, struct media_device *mdev)
+__must_check int media_graph_walk_init(
+	struct media_graph *graph, struct media_device *mdev)
 {
 	return media_entity_enum_init(&graph->ent_enum, mdev);
 }
-EXPORT_SYMBOL_GPL(media_entity_graph_walk_init);
+EXPORT_SYMBOL_GPL(media_graph_walk_init);
 
 /**
- * media_entity_graph_walk_cleanup - Release resources related to graph walking
+ * media_graph_walk_cleanup - Release resources related to graph walking
  * @graph: Media graph structure that was used to walk the graph
  */
-void media_entity_graph_walk_cleanup(struct media_entity_graph *graph)
+void media_graph_walk_cleanup(struct media_graph *graph)
 {
 	media_entity_enum_cleanup(&graph->ent_enum);
 }
-EXPORT_SYMBOL_GPL(media_entity_graph_walk_cleanup);
+EXPORT_SYMBOL_GPL(media_graph_walk_cleanup);
 
-void media_entity_graph_walk_start(struct media_entity_graph *graph,
-				   struct media_entity *entity)
+void media_graph_walk_start(struct media_graph *graph,
+			    struct media_entity *entity)
 {
 	media_entity_enum_zero(&graph->ent_enum);
 	media_entity_enum_set(&graph->ent_enum, entity);
@@ -326,10 +326,9 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 	graph->stack[graph->top].entity = NULL;
 	stack_push(graph, entity);
 }
-EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
+EXPORT_SYMBOL_GPL(media_graph_walk_start);
 
-struct media_entity *
-media_entity_graph_walk_next(struct media_entity_graph *graph)
+struct media_entity *media_graph_walk_next(struct media_graph *graph)
 {
 	if (stack_top(graph) == NULL)
 		return NULL;
@@ -368,30 +367,30 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 
 	return stack_pop(graph);
 }
-EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
+EXPORT_SYMBOL_GPL(media_graph_walk_next);
 
 /* -----------------------------------------------------------------------------
  * Pipeline management
  */
 
-__must_check int __media_entity_pipeline_start(struct media_entity *entity,
-					       struct media_pipeline *pipe)
+__must_check int __media_pipeline_start(struct media_entity *entity,
+					struct media_pipeline *pipe)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
-	struct media_entity_graph *graph = &pipe->graph;
+	struct media_graph *graph = &pipe->graph;
 	struct media_entity *entity_err = entity;
 	struct media_link *link;
 	int ret;
 
 	if (!pipe->streaming_count++) {
-		ret = media_entity_graph_walk_init(&pipe->graph, mdev);
+		ret = media_graph_walk_init(&pipe->graph, mdev);
 		if (ret)
 			goto error_graph_walk_start;
 	}
 
-	media_entity_graph_walk_start(&pipe->graph, entity);
+	media_graph_walk_start(&pipe->graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(graph))) {
+	while ((entity = media_graph_walk_next(graph))) {
 		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
 		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_MAX_PADS);
 
@@ -470,9 +469,9 @@ __must_check int __media_entity_pipeline_start(struct media_entity *entity,
 	 * Link validation on graph failed. We revert what we did and
 	 * return the error.
 	 */
-	media_entity_graph_walk_start(graph, entity_err);
+	media_graph_walk_start(graph, entity_err);
 
-	while ((entity_err = media_entity_graph_walk_next(graph))) {
+	while ((entity_err = media_graph_walk_next(graph))) {
 		/* Sanity check for negative stream_count */
 		if (!WARN_ON_ONCE(entity_err->stream_count <= 0)) {
 			entity_err->stream_count--;
@@ -490,35 +489,35 @@ __must_check int __media_entity_pipeline_start(struct media_entity *entity,
 
 error_graph_walk_start:
 	if (!--pipe->streaming_count)
-		media_entity_graph_walk_cleanup(graph);
+		media_graph_walk_cleanup(graph);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(__media_entity_pipeline_start);
+EXPORT_SYMBOL_GPL(__media_pipeline_start);
 
-__must_check int media_entity_pipeline_start(struct media_entity *entity,
-					     struct media_pipeline *pipe)
+__must_check int media_pipeline_start(struct media_entity *entity,
+				      struct media_pipeline *pipe)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
 	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
-	ret = __media_entity_pipeline_start(entity, pipe);
+	ret = __media_pipeline_start(entity, pipe);
 	mutex_unlock(&mdev->graph_mutex);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
+EXPORT_SYMBOL_GPL(media_pipeline_start);
 
-void __media_entity_pipeline_stop(struct media_entity *entity)
+void __media_pipeline_stop(struct media_entity *entity)
 {
-	struct media_entity_graph *graph = &entity->pipe->graph;
+	struct media_graph *graph = &entity->pipe->graph;
 	struct media_pipeline *pipe = entity->pipe;
 
 
 	WARN_ON(!pipe->streaming_count);
-	media_entity_graph_walk_start(graph, entity);
+	media_graph_walk_start(graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(graph))) {
+	while ((entity = media_graph_walk_next(graph))) {
 		/* Sanity check for negative stream_count */
 		if (!WARN_ON_ONCE(entity->stream_count <= 0)) {
 			entity->stream_count--;
@@ -528,20 +527,20 @@ void __media_entity_pipeline_stop(struct media_entity *entity)
 	}
 
 	if (!--pipe->streaming_count)
-		media_entity_graph_walk_cleanup(graph);
+		media_graph_walk_cleanup(graph);
 
 }
-EXPORT_SYMBOL_GPL(__media_entity_pipeline_stop);
+EXPORT_SYMBOL_GPL(__media_pipeline_stop);
 
-void media_entity_pipeline_stop(struct media_entity *entity)
+void media_pipeline_stop(struct media_entity *entity)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
 
 	mutex_lock(&mdev->graph_mutex);
-	__media_entity_pipeline_stop(entity);
+	__media_pipeline_stop(entity);
 	mutex_unlock(&mdev->graph_mutex);
 }
-EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);
+EXPORT_SYMBOL_GPL(media_pipeline_stop);
 
 /* -----------------------------------------------------------------------------
  * Module use count
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 964f4a6..7bde62f 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -536,7 +536,7 @@ static int fimc_capture_release(struct file *file)
 	mutex_lock(&fimc->lock);
 
 	if (close && vc->streaming) {
-		media_entity_pipeline_stop(&vc->ve.vdev.entity);
+		media_pipeline_stop(&vc->ve.vdev.entity);
 		vc->streaming = false;
 	}
 
@@ -1195,7 +1195,7 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
-	ret = media_entity_pipeline_start(entity, &vc->ve.pipe->mp);
+	ret = media_pipeline_start(entity, &vc->ve.pipe->mp);
 	if (ret < 0)
 		return ret;
 
@@ -1229,7 +1229,7 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	}
 
 err_p_stop:
-	media_entity_pipeline_stop(entity);
+	media_pipeline_stop(entity);
 	return ret;
 }
 
@@ -1244,7 +1244,7 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	media_entity_pipeline_stop(&vc->ve.vdev.entity);
+	media_pipeline_stop(&vc->ve.vdev.entity);
 	vc->streaming = false;
 	return 0;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 400ce0c..55ba696 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -312,7 +312,7 @@ static int isp_video_release(struct file *file)
 	mutex_lock(&isp->video_lock);
 
 	if (v4l2_fh_is_singular_file(file) && ivc->streaming) {
-		media_entity_pipeline_stop(entity);
+		media_pipeline_stop(entity);
 		ivc->streaming = 0;
 	}
 
@@ -489,7 +489,7 @@ static int isp_video_streamon(struct file *file, void *priv,
 	struct media_entity *me = &ve->vdev.entity;
 	int ret;
 
-	ret = media_entity_pipeline_start(me, &ve->pipe->mp);
+	ret = media_pipeline_start(me, &ve->pipe->mp);
 	if (ret < 0)
 		return ret;
 
@@ -504,7 +504,7 @@ static int isp_video_streamon(struct file *file, void *priv,
 	isp->video_capture.streaming = 1;
 	return 0;
 p_stop:
-	media_entity_pipeline_stop(me);
+	media_pipeline_stop(me);
 	return ret;
 }
 
@@ -519,7 +519,7 @@ static int isp_video_streamoff(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	media_entity_pipeline_stop(&video->ve.vdev.entity);
+	media_pipeline_stop(&video->ve.vdev.entity);
 	video->streaming = 0;
 	return 0;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index b91abf1..b4c4a33 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -524,7 +524,7 @@ static int fimc_lite_release(struct file *file)
 	if (v4l2_fh_is_singular_file(file) &&
 	    atomic_read(&fimc->out_path) == FIMC_IO_DMA) {
 		if (fimc->streaming) {
-			media_entity_pipeline_stop(entity);
+			media_pipeline_stop(entity);
 			fimc->streaming = false;
 		}
 		fimc_lite_stop_capture(fimc, false);
@@ -832,7 +832,7 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 	if (fimc_lite_active(fimc))
 		return -EBUSY;
 
-	ret = media_entity_pipeline_start(entity, &fimc->ve.pipe->mp);
+	ret = media_pipeline_start(entity, &fimc->ve.pipe->mp);
 	if (ret < 0)
 		return ret;
 
@@ -849,7 +849,7 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 	}
 
 err_p_stop:
-	media_entity_pipeline_stop(entity);
+	media_pipeline_stop(entity);
 	return 0;
 }
 
@@ -863,7 +863,7 @@ static int fimc_lite_streamoff(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	media_entity_pipeline_stop(&fimc->ve.vdev.entity);
+	media_pipeline_stop(&fimc->ve.vdev.entity);
 	fimc->streaming = false;
 	return 0;
 }
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index e3a8709..735221a 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1117,7 +1117,7 @@ static int __fimc_md_modify_pipeline(struct media_entity *entity, bool enable)
 
 /* Locking: called with entity->graph_obj.mdev->graph_mutex mutex held. */
 static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
-				      struct media_entity_graph *graph)
+				      struct media_graph *graph)
 {
 	struct media_entity *entity_err = entity;
 	int ret;
@@ -1128,9 +1128,9 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
 	 * through active links. This is needed as we cannot power on/off the
 	 * subdevs in random order.
 	 */
-	media_entity_graph_walk_start(graph, entity);
+	media_graph_walk_start(graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(graph))) {
+	while ((entity = media_graph_walk_next(graph))) {
 		if (!is_media_entity_v4l2_video_device(entity))
 			continue;
 
@@ -1143,9 +1143,9 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
 	return 0;
 
 err:
-	media_entity_graph_walk_start(graph, entity_err);
+	media_graph_walk_start(graph, entity_err);
 
-	while ((entity_err = media_entity_graph_walk_next(graph))) {
+	while ((entity_err = media_graph_walk_next(graph))) {
 		if (!is_media_entity_v4l2_video_device(entity_err))
 			continue;
 
@@ -1161,7 +1161,7 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
 static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
 				unsigned int notification)
 {
-	struct media_entity_graph *graph =
+	struct media_graph *graph =
 		&container_of(link->graph_obj.mdev, struct fimc_md,
 			      media_dev)->link_setup_graph;
 	struct media_entity *sink = link->sink->entity;
@@ -1169,7 +1169,7 @@ static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
 
 	/* Before link disconnection */
 	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
-		ret = media_entity_graph_walk_init(graph,
+		ret = media_graph_walk_init(graph,
 						   link->graph_obj.mdev);
 		if (ret)
 			return ret;
@@ -1183,7 +1183,7 @@ static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
 	} else if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH) {
 		if (link->flags & MEDIA_LNK_FL_ENABLED)
 			ret = __fimc_md_modify_pipelines(sink, true, graph);
-		media_entity_graph_walk_cleanup(graph);
+		media_graph_walk_cleanup(graph);
 	}
 
 	return ret ? -EPIPE : 0;
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index ed122cb..957787a 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -154,7 +154,7 @@ struct fimc_md {
 	bool user_subdev_api;
 	spinlock_t slock;
 	struct list_head pipelines;
-	struct media_entity_graph link_setup_graph;
+	struct media_graph link_setup_graph;
 };
 
 static inline
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 7354469..5b0d16e 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -225,22 +225,22 @@ isp_video_remote_subdev(struct isp_video *video, u32 *pad)
 static int isp_video_get_graph_data(struct isp_video *video,
 				    struct isp_pipeline *pipe)
 {
-	struct media_entity_graph graph;
+	struct media_graph graph;
 	struct media_entity *entity = &video->video.entity;
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct isp_video *far_end = NULL;
 	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
-	ret = media_entity_graph_walk_init(&graph, entity->graph_obj.mdev);
+	ret = media_graph_walk_init(&graph, entity->graph_obj.mdev);
 	if (ret) {
 		mutex_unlock(&mdev->graph_mutex);
 		return ret;
 	}
 
-	media_entity_graph_walk_start(&graph, entity);
+	media_graph_walk_start(&graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(&graph))) {
+	while ((entity = media_graph_walk_next(&graph))) {
 		struct isp_video *__video;
 
 		media_entity_enum_set(&pipe->ent_enum, entity);
@@ -261,7 +261,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
 
 	mutex_unlock(&mdev->graph_mutex);
 
-	media_entity_graph_walk_cleanup(&graph);
+	media_graph_walk_cleanup(&graph);
 
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		pipe->input = far_end;
@@ -1112,7 +1112,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
 	pipe->max_rate = pipe->l3_ick;
 
-	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
+	ret = media_pipeline_start(&video->video.entity, &pipe->pipe);
 	if (ret < 0)
 		goto err_pipeline_start;
 
@@ -1169,7 +1169,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	return 0;
 
 err_check_format:
-	media_entity_pipeline_stop(&video->video.entity);
+	media_pipeline_stop(&video->video.entity);
 err_pipeline_start:
 	/* TODO: Implement PM QoS */
 	/* The DMA queue must be emptied here, otherwise CCDC interrupts that
@@ -1236,7 +1236,7 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	video->error = false;
 
 	/* TODO: Implement PM QoS */
-	media_entity_pipeline_stop(&video->video.entity);
+	media_pipeline_stop(&video->video.entity);
 
 	media_entity_enum_cleanup(&pipe->ent_enum);
 
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 0413a86..e01ecca 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -856,13 +856,13 @@ static int s3c_camif_streamon(struct file *file, void *priv,
 	if (s3c_vp_active(vp))
 		return 0;
 
-	ret = media_entity_pipeline_start(sensor, camif->m_pipeline);
+	ret = media_pipeline_start(sensor, camif->m_pipeline);
 	if (ret < 0)
 		return ret;
 
 	ret = camif_pipeline_validate(camif);
 	if (ret < 0) {
-		media_entity_pipeline_stop(sensor);
+		media_pipeline_stop(sensor);
 		return ret;
 	}
 
@@ -886,7 +886,7 @@ static int s3c_camif_streamoff(struct file *file, void *priv,
 
 	ret = vb2_streamoff(&vp->vb_queue, type);
 	if (ret == 0)
-		media_entity_pipeline_stop(&camif->sensor.sd->entity);
+		media_pipeline_stop(&camif->sensor.sd->entity);
 	return ret;
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index cd209dc..b4b583f 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -90,7 +90,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		if (ret == -ETIMEDOUT)
 			dev_err(vsp1->dev, "DRM pipeline stop timeout\n");
 
-		media_entity_pipeline_stop(&pipe->output->entity.subdev.entity);
+		media_pipeline_stop(&pipe->output->entity.subdev.entity);
 
 		for (i = 0; i < bru->entity.source_pad; ++i) {
 			vsp1->drm->inputs[i].enabled = false;
@@ -196,7 +196,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 	if (ret < 0)
 		return ret;
 
-	ret = media_entity_pipeline_start(&pipe->output->entity.subdev.entity,
+	ret = media_pipeline_start(&pipe->output->entity.subdev.entity,
 					  &pipe->pipe);
 	if (ret < 0) {
 		dev_dbg(vsp1->dev, "%s: pipeline start failed\n", __func__);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 41e8b09..e6592b5 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -548,20 +548,20 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 				     struct vsp1_video *video)
 {
-	struct media_entity_graph graph;
+	struct media_graph graph;
 	struct media_entity *entity = &video->video.entity;
 	struct media_device *mdev = entity->graph_obj.mdev;
 	unsigned int i;
 	int ret;
 
 	/* Walk the graph to locate the entities and video nodes. */
-	ret = media_entity_graph_walk_init(&graph, mdev);
+	ret = media_graph_walk_init(&graph, mdev);
 	if (ret)
 		return ret;
 
-	media_entity_graph_walk_start(&graph, entity);
+	media_graph_walk_start(&graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(&graph))) {
+	while ((entity = media_graph_walk_next(&graph))) {
 		struct v4l2_subdev *subdev;
 		struct vsp1_rwpf *rwpf;
 		struct vsp1_entity *e;
@@ -590,7 +590,7 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 		}
 	}
 
-	media_entity_graph_walk_cleanup(&graph);
+	media_graph_walk_cleanup(&graph);
 
 	/* We need one output and at least one input. */
 	if (pipe->num_inputs == 0 || !pipe->output)
@@ -848,7 +848,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	}
 	mutex_unlock(&pipe->lock);
 
-	media_entity_pipeline_stop(&video->video.entity);
+	media_pipeline_stop(&video->video.entity);
 	vsp1_video_pipeline_put(pipe);
 
 	/* Remove all buffers from the IRQ queue. */
@@ -980,7 +980,7 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 		return PTR_ERR(pipe);
 	}
 
-	ret = __media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
+	ret = __media_pipeline_start(&video->video.entity, &pipe->pipe);
 	if (ret < 0) {
 		mutex_unlock(&mdev->graph_mutex);
 		goto err_pipe;
@@ -1003,7 +1003,7 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	return 0;
 
 err_stop:
-	media_entity_pipeline_stop(&video->video.entity);
+	media_pipeline_stop(&video->video.entity);
 err_pipe:
 	vsp1_video_pipeline_put(pipe);
 	return ret;
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 1d5836c..065df82 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -177,7 +177,7 @@ static int xvip_pipeline_set_stream(struct xvip_pipeline *pipe, bool on)
 static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
 				  struct xvip_dma *start)
 {
-	struct media_entity_graph graph;
+	struct media_graph graph;
 	struct media_entity *entity = &start->video.entity;
 	struct media_device *mdev = entity->graph_obj.mdev;
 	unsigned int num_inputs = 0;
@@ -187,15 +187,15 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
 	mutex_lock(&mdev->graph_mutex);
 
 	/* Walk the graph to locate the video nodes. */
-	ret = media_entity_graph_walk_init(&graph, entity->graph_obj.mdev);
+	ret = media_graph_walk_init(&graph, entity->graph_obj.mdev);
 	if (ret) {
 		mutex_unlock(&mdev->graph_mutex);
 		return ret;
 	}
 
-	media_entity_graph_walk_start(&graph, entity);
+	media_graph_walk_start(&graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(&graph))) {
+	while ((entity = media_graph_walk_next(&graph))) {
 		struct xvip_dma *dma;
 
 		if (entity->function != MEDIA_ENT_F_IO_V4L)
@@ -213,7 +213,7 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
 
 	mutex_unlock(&mdev->graph_mutex);
 
-	media_entity_graph_walk_cleanup(&graph);
+	media_graph_walk_cleanup(&graph);
 
 	/* We need exactly one output and zero or one input. */
 	if (num_outputs != 1 || num_inputs > 1)
@@ -409,7 +409,7 @@ static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int count)
 	pipe = dma->video.entity.pipe
 	     ? to_xvip_pipeline(&dma->video.entity) : &dma->pipe;
 
-	ret = media_entity_pipeline_start(&dma->video.entity, &pipe->pipe);
+	ret = media_pipeline_start(&dma->video.entity, &pipe->pipe);
 	if (ret < 0)
 		goto error;
 
@@ -435,7 +435,7 @@ static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return 0;
 
 error_stop:
-	media_entity_pipeline_stop(&dma->video.entity);
+	media_pipeline_stop(&dma->video.entity);
 
 error:
 	/* Give back all queued buffers to videobuf2. */
@@ -463,7 +463,7 @@ static void xvip_dma_stop_streaming(struct vb2_queue *vq)
 
 	/* Cleanup the pipeline and mark it as being stopped. */
 	xvip_pipeline_cleanup(pipe);
-	media_entity_pipeline_stop(&dma->video.entity);
+	media_pipeline_stop(&dma->video.entity);
 
 	/* Give back all queued buffers to videobuf2. */
 	spin_lock_irq(&dma->queued_lock);
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index bf53553..c61f898 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -397,7 +397,7 @@ static int au0828_enable_source(struct media_entity *entity,
 		goto end;
 	}
 
-	ret = __media_entity_pipeline_start(entity, pipe);
+	ret = __media_pipeline_start(entity, pipe);
 	if (ret) {
 		pr_err("Start Pipeline: %s->%s Error %d\n",
 			source->name, entity->name, ret);
@@ -451,7 +451,7 @@ static void au0828_disable_source(struct media_entity *entity)
 		*/
 		if (dev->active_link_owner != entity)
 			goto end;
-		__media_entity_pipeline_stop(entity);
+		__media_pipeline_stop(entity);
 		ret = __media_entity_setup_link(dev->active_link, 0);
 		if (ret)
 			pr_err("Deactivate link Error %d\n", ret);
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 8bef433..fcf614a 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -256,13 +256,13 @@ EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
  * Return the total number of users of all video device nodes in the pipeline.
  */
 static int pipeline_pm_use_count(struct media_entity *entity,
-	struct media_entity_graph *graph)
+	struct media_graph *graph)
 {
 	int use = 0;
 
-	media_entity_graph_walk_start(graph, entity);
+	media_graph_walk_start(graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(graph))) {
+	while ((entity = media_graph_walk_next(graph))) {
 		if (is_media_entity_v4l2_video_device(entity))
 			use += entity->use_count;
 	}
@@ -315,7 +315,7 @@ static int pipeline_pm_power_one(struct media_entity *entity, int change)
  * Return 0 on success or a negative error code on failure.
  */
 static int pipeline_pm_power(struct media_entity *entity, int change,
-	struct media_entity_graph *graph)
+	struct media_graph *graph)
 {
 	struct media_entity *first = entity;
 	int ret = 0;
@@ -323,18 +323,18 @@ static int pipeline_pm_power(struct media_entity *entity, int change,
 	if (!change)
 		return 0;
 
-	media_entity_graph_walk_start(graph, entity);
+	media_graph_walk_start(graph, entity);
 
-	while (!ret && (entity = media_entity_graph_walk_next(graph)))
+	while (!ret && (entity = media_graph_walk_next(graph)))
 		if (is_media_entity_v4l2_subdev(entity))
 			ret = pipeline_pm_power_one(entity, change);
 
 	if (!ret)
 		return ret;
 
-	media_entity_graph_walk_start(graph, first);
+	media_graph_walk_start(graph, first);
 
-	while ((first = media_entity_graph_walk_next(graph))
+	while ((first = media_graph_walk_next(graph))
 	       && first != entity)
 		if (is_media_entity_v4l2_subdev(first))
 			pipeline_pm_power_one(first, -change);
@@ -368,7 +368,7 @@ EXPORT_SYMBOL_GPL(v4l2_pipeline_pm_use);
 int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
 			      unsigned int notification)
 {
-	struct media_entity_graph *graph = &link->graph_obj.mdev->pm_count_walk;
+	struct media_graph *graph = &link->graph_obj.mdev->pm_count_walk;
 	struct media_entity *source = link->source->entity;
 	struct media_entity *sink = link->sink->entity;
 	int source_use;
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index c27d7e9..03269d3 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -129,7 +129,7 @@ __vpfe_video_get_format(struct vpfe_video_device *video,
 /* make a note of pipeline details */
 static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
 {
-	struct media_entity_graph graph;
+	struct media_graph graph;
 	struct media_entity *entity = &video->video_dev.entity;
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct vpfe_pipeline *pipe = &video->pipe;
@@ -145,13 +145,13 @@ static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
 		pipe->outputs[pipe->output_num++] = video;
 
 	mutex_lock(&mdev->graph_mutex);
-	ret = media_entity_graph_walk_init(&graph, entity->graph_obj.mdev);
+	ret = media_graph_walk_init(&graph, entity->graph_obj.mdev);
 	if (ret) {
 		mutex_unlock(&mdev->graph_mutex);
 		return -ENOMEM;
 	}
-	media_entity_graph_walk_start(&graph, entity);
-	while ((entity = media_entity_graph_walk_next(&graph))) {
+	media_graph_walk_start(&graph, entity);
+	while ((entity = media_graph_walk_next(&graph))) {
 		if (entity == &video->video_dev.entity)
 			continue;
 		if (!is_media_entity_v4l2_video_device(entity))
@@ -162,7 +162,7 @@ static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
 		else
 			pipe->outputs[pipe->output_num++] = far_end;
 	}
-	media_entity_graph_walk_cleanup(&graph);
+	media_graph_walk_cleanup(&graph);
 	mutex_unlock(&mdev->graph_mutex);
 
 	return 0;
@@ -300,12 +300,11 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
 
 	mdev = entity->graph_obj.mdev;
 	mutex_lock(&mdev->graph_mutex);
-	ret = media_entity_graph_walk_init(&pipe->graph,
-					   entity->graph_obj.mdev);
+	ret = media_graph_walk_init(&pipe->graph, entity->graph_obj.mdev);
 	if (ret)
 		goto out;
-	media_entity_graph_walk_start(&pipe->graph, entity);
-	while ((entity = media_entity_graph_walk_next(&pipe->graph))) {
+	media_graph_walk_start(&pipe->graph, entity);
+	while ((entity = media_graph_walk_next(&pipe->graph))) {
 
 		if (!is_media_entity_v4l2_subdev(entity))
 			continue;
@@ -316,7 +315,7 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
 	}
 out:
 	if (ret)
-		media_entity_graph_walk_cleanup(&pipe->graph);
+		media_graph_walk_cleanup(&pipe->graph);
 	mutex_unlock(&mdev->graph_mutex);
 	return ret;
 }
@@ -346,9 +345,9 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 
 	mdev = entity->graph_obj.mdev;
 	mutex_lock(&mdev->graph_mutex);
-	media_entity_graph_walk_start(&pipe->graph, entity);
+	media_graph_walk_start(&pipe->graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(&pipe->graph))) {
+	while ((entity = media_graph_walk_next(&pipe->graph))) {
 
 		if (!is_media_entity_v4l2_subdev(entity))
 			continue;
@@ -359,7 +358,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 	}
 	mutex_unlock(&mdev->graph_mutex);
 
-	media_entity_graph_walk_cleanup(&pipe->graph);
+	media_graph_walk_cleanup(&pipe->graph);
 	return ret ? -ETIMEDOUT : 0;
 }
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.h b/drivers/staging/media/davinci_vpfe/vpfe_video.h
index aaec440..22136d3 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.h
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.h
@@ -52,7 +52,7 @@ enum vpfe_video_state {
 struct vpfe_pipeline {
 	/* media pipeline */
 	struct media_pipeline		*pipe;
-	struct media_entity_graph	graph;
+	struct media_graph	graph;
 	/* state of the pipeline, continuous,
 	 * single-shot or stopped
 	 */
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index c16927a..f4b0e66 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -205,21 +205,21 @@ iss_video_remote_subdev(struct iss_video *video, u32 *pad)
 static struct iss_video *
 iss_video_far_end(struct iss_video *video)
 {
-	struct media_entity_graph graph;
+	struct media_graph graph;
 	struct media_entity *entity = &video->video.entity;
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct iss_video *far_end = NULL;
 
 	mutex_lock(&mdev->graph_mutex);
 
-	if (media_entity_graph_walk_init(&graph, mdev)) {
+	if (media_graph_walk_init(&graph, mdev)) {
 		mutex_unlock(&mdev->graph_mutex);
 		return NULL;
 	}
 
-	media_entity_graph_walk_start(&graph, entity);
+	media_graph_walk_start(&graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(&graph))) {
+	while ((entity = media_graph_walk_next(&graph))) {
 		if (entity == &video->video.entity)
 			continue;
 
@@ -235,7 +235,7 @@ iss_video_far_end(struct iss_video *video)
 
 	mutex_unlock(&mdev->graph_mutex);
 
-	media_entity_graph_walk_cleanup(&graph);
+	media_graph_walk_cleanup(&graph);
 
 	return far_end;
 }
@@ -854,7 +854,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 {
 	struct iss_video_fh *vfh = to_iss_video_fh(fh);
 	struct iss_video *video = video_drvdata(file);
-	struct media_entity_graph graph;
+	struct media_graph graph;
 	struct media_entity *entity = &video->video.entity;
 	enum iss_pipeline_state state;
 	struct iss_pipeline *pipe;
@@ -880,19 +880,19 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (ret)
 		goto err_graph_walk_init;
 
-	ret = media_entity_graph_walk_init(&graph, entity->graph_obj.mdev);
+	ret = media_graph_walk_init(&graph, entity->graph_obj.mdev);
 	if (ret)
 		goto err_graph_walk_init;
 
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, true);
 
-	ret = media_entity_pipeline_start(entity, &pipe->pipe);
+	ret = media_pipeline_start(entity, &pipe->pipe);
 	if (ret < 0)
-		goto err_media_entity_pipeline_start;
+		goto err_media_pipeline_start;
 
-	media_entity_graph_walk_start(&graph, entity);
-	while ((entity = media_entity_graph_walk_next(&graph)))
+	media_graph_walk_start(&graph, entity);
+	while ((entity = media_graph_walk_next(&graph)))
 		media_entity_enum_set(&pipe->ent_enum, entity);
 
 	/* Verify that the currently configured format matches the output of
@@ -963,7 +963,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 		spin_unlock_irqrestore(&video->qlock, flags);
 	}
 
-	media_entity_graph_walk_cleanup(&graph);
+	media_graph_walk_cleanup(&graph);
 
 	mutex_unlock(&video->stream_lock);
 
@@ -972,13 +972,13 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 err_omap4iss_set_stream:
 	vb2_streamoff(&vfh->queue, type);
 err_iss_video_check_format:
-	media_entity_pipeline_stop(&video->video.entity);
-err_media_entity_pipeline_start:
+	media_pipeline_stop(&video->video.entity);
+err_media_pipeline_start:
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, false);
 	video->queue = NULL;
 
-	media_entity_graph_walk_cleanup(&graph);
+	media_graph_walk_cleanup(&graph);
 
 err_graph_walk_init:
 	media_entity_enum_cleanup(&pipe->ent_enum);
@@ -1026,7 +1026,7 @@ iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, false);
-	media_entity_pipeline_stop(&video->video.entity);
+	media_pipeline_stop(&video->video.entity);
 
 done:
 	mutex_unlock(&video->stream_lock);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index c21b4c5..6c0fdf8 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -154,7 +154,7 @@ struct media_device {
 
 	/* Serializes graph operations. */
 	struct mutex graph_mutex;
-	struct media_entity_graph pm_count_walk;
+	struct media_graph pm_count_walk;
 
 	void *source_priv;
 	int (*enable_source)(struct media_entity *entity,
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index b2203ee..1a978d4 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -86,7 +86,7 @@ struct media_entity_enum {
 };
 
 /**
- * struct media_entity_graph - Media graph traversal state
+ * struct media_graph - Media graph traversal state
  *
  * @stack:		Graph traversal stack; the stack contains information
  *			on the path the media entities to be walked and the
@@ -94,7 +94,7 @@ struct media_entity_enum {
  * @ent_enum:		Visited entities
  * @top:		The top of the stack
  */
-struct media_entity_graph {
+struct media_graph {
 	struct {
 		struct media_entity *entity;
 		struct list_head *link;
@@ -112,7 +112,7 @@ struct media_entity_graph {
  */
 struct media_pipeline {
 	int streaming_count;
-	struct media_entity_graph graph;
+	struct media_graph graph;
 };
 
 /**
@@ -179,7 +179,7 @@ struct media_pad {
  *			return an error, in which case link setup will be
  *			cancelled. Optional.
  * @link_validate:	Return whether a link is valid from the entity point of
- *			view. The media_entity_pipeline_start() function
+ *			view. The media_pipeline_start() function
  *			validates all links by calling this operation. Optional.
  *
  * .. note::
@@ -820,20 +820,20 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad);
 struct media_entity *media_entity_get(struct media_entity *entity);
 
 /**
- * media_entity_graph_walk_init - Allocate resources used by graph walk.
+ * media_graph_walk_init - Allocate resources used by graph walk.
  *
  * @graph: Media graph structure that will be used to walk the graph
  * @mdev: Pointer to the &media_device that contains the object
  */
-__must_check int media_entity_graph_walk_init(
-	struct media_entity_graph *graph, struct media_device *mdev);
+__must_check int media_graph_walk_init(
+	struct media_graph *graph, struct media_device *mdev);
 
 /**
- * media_entity_graph_walk_cleanup - Release resources used by graph walk.
+ * media_graph_walk_cleanup - Release resources used by graph walk.
  *
  * @graph: Media graph structure that will be used to walk the graph
  */
-void media_entity_graph_walk_cleanup(struct media_entity_graph *graph);
+void media_graph_walk_cleanup(struct media_graph *graph);
 
 /**
  * media_entity_put - Release the reference to the parent module
@@ -847,40 +847,39 @@ void media_entity_graph_walk_cleanup(struct media_entity_graph *graph);
 void media_entity_put(struct media_entity *entity);
 
 /**
- * media_entity_graph_walk_start - Start walking the media graph at a
+ * media_graph_walk_start - Start walking the media graph at a
  *	given entity
  *
  * @graph: Media graph structure that will be used to walk the graph
  * @entity: Starting entity
  *
- * Before using this function, media_entity_graph_walk_init() must be
+ * Before using this function, media_graph_walk_init() must be
  * used to allocate resources used for walking the graph. This
  * function initializes the graph traversal structure to walk the
  * entities graph starting at the given entity. The traversal
  * structure must not be modified by the caller during graph
  * traversal. After the graph walk, the resources must be released
- * using media_entity_graph_walk_cleanup().
+ * using media_graph_walk_cleanup().
  */
-void media_entity_graph_walk_start(struct media_entity_graph *graph,
-				   struct media_entity *entity);
+void media_graph_walk_start(struct media_graph *graph,
+			    struct media_entity *entity);
 
 /**
- * media_entity_graph_walk_next - Get the next entity in the graph
+ * media_graph_walk_next - Get the next entity in the graph
  * @graph: Media graph structure
  *
  * Perform a depth-first traversal of the given media entities graph.
  *
  * The graph structure must have been previously initialized with a call to
- * media_entity_graph_walk_start().
+ * media_graph_walk_start().
  *
  * Return: returns the next entity in the graph or %NULL if the whole graph
  * have been traversed.
  */
-struct media_entity *
-media_entity_graph_walk_next(struct media_entity_graph *graph);
+struct media_entity *media_graph_walk_next(struct media_graph *graph);
 
 /**
- * media_entity_pipeline_start - Mark a pipeline as streaming
+ * media_pipeline_start - Mark a pipeline as streaming
  * @entity: Starting entity
  * @pipe: Media pipeline to be assigned to all entities in the pipeline.
  *
@@ -889,45 +888,45 @@ media_entity_graph_walk_next(struct media_entity_graph *graph);
  * to every entity in the pipeline and stored in the media_entity pipe field.
  *
  * Calls to this function can be nested, in which case the same number of
- * media_entity_pipeline_stop() calls will be required to stop streaming. The
+ * media_pipeline_stop() calls will be required to stop streaming. The
  * pipeline pointer must be identical for all nested calls to
- * media_entity_pipeline_start().
+ * media_pipeline_start().
  */
-__must_check int media_entity_pipeline_start(struct media_entity *entity,
-					     struct media_pipeline *pipe);
+__must_check int media_pipeline_start(struct media_entity *entity,
+				      struct media_pipeline *pipe);
 /**
- * __media_entity_pipeline_start - Mark a pipeline as streaming
+ * __media_pipeline_start - Mark a pipeline as streaming
  *
  * @entity: Starting entity
  * @pipe: Media pipeline to be assigned to all entities in the pipeline.
  *
- * ..note:: This is the non-locking version of media_entity_pipeline_start()
+ * ..note:: This is the non-locking version of media_pipeline_start()
  */
-__must_check int __media_entity_pipeline_start(struct media_entity *entity,
-					       struct media_pipeline *pipe);
+__must_check int __media_pipeline_start(struct media_entity *entity,
+					struct media_pipeline *pipe);
 
 /**
- * media_entity_pipeline_stop - Mark a pipeline as not streaming
+ * media_pipeline_stop - Mark a pipeline as not streaming
  * @entity: Starting entity
  *
  * Mark all entities connected to a given entity through enabled links, either
  * directly or indirectly, as not streaming. The media_entity pipe field is
  * reset to %NULL.
  *
- * If multiple calls to media_entity_pipeline_start() have been made, the same
+ * If multiple calls to media_pipeline_start() have been made, the same
  * number of calls to this function are required to mark the pipeline as not
  * streaming.
  */
-void media_entity_pipeline_stop(struct media_entity *entity);
+void media_pipeline_stop(struct media_entity *entity);
 
 /**
- * __media_entity_pipeline_stop - Mark a pipeline as not streaming
+ * __media_pipeline_stop - Mark a pipeline as not streaming
  *
  * @entity: Starting entity
  *
- * .. note:: This is the non-locking version of media_entity_pipeline_stop()
+ * .. note:: This is the non-locking version of media_pipeline_stop()
  */
-void __media_entity_pipeline_stop(struct media_entity *entity);
+void __media_pipeline_stop(struct media_entity *entity);
 
 /**
  * media_devnode_create() - creates and initializes a device node interface
-- 
2.1.4

