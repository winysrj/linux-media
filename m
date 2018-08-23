Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:12076 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730609AbeHWQ5q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 12:57:46 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 03/30] media: entity: Walk the graph based on pads
Date: Thu, 23 Aug 2018 15:25:17 +0200
Message-Id: <20180823132544.521-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Instead of iterating over graph entities during the walk, iterate the pads
through which the entity was first reached. This is required in order to
make the entity pipeline pad-based rather than entity based.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/kapi/mc-core.rst          |  7 ++-
 drivers/media/media-entity.c                  | 46 ++++++++++--------
 drivers/media/platform/exynos4-is/media-dev.c | 20 ++++----
 drivers/media/platform/omap3isp/ispvideo.c    | 17 +++----
 drivers/media/platform/vsp1/vsp1_video.c      | 12 ++---
 drivers/media/platform/xilinx/xilinx-dma.c    | 12 ++---
 drivers/media/v4l2-core/v4l2-mc.c             | 25 +++++-----
 .../staging/media/davinci_vpfe/vpfe_video.c   | 47 ++++++++++---------
 drivers/staging/media/omap4iss/iss_video.c    | 34 +++++++-------
 include/media/media-entity.h                  |  7 +--
 10 files changed, 122 insertions(+), 105 deletions(-)

diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index 27aefb9a778b2ad6..849b87439b7a9772 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -167,8 +167,11 @@ Drivers initiate a graph traversal by calling
 The graph structure, provided by the caller, is initialized to start graph
 traversal at the given pad in an entity.
 
-Drivers can then retrieve the next entity by calling
-:c:func:`media_graph_walk_next()`
+Drivers can then retrieve the next pad by calling
+:c:func:`media_graph_walk_next()`. Only the pad through which the entity
+is first reached is returned. If the caller is interested in knowing which
+further pads would be connected, the :c:func:`media_entity_has_route()`
+function can be used for that.
 
 When the graph traversal is complete the function will return ``NULL``.
 
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c5dcae6d0caf92ec..ec7c61dff6ae879d 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -349,9 +349,9 @@ static void media_graph_walk_iter(struct media_graph *graph)
 		next->entity->name, next->index);
 }
 
-struct media_entity *media_graph_walk_next(struct media_graph *graph)
+struct media_pad *media_graph_walk_next(struct media_graph *graph)
 {
-	struct media_entity *entity;
+	struct media_pad *pad;
 
 	if (stack_top(graph) == NULL)
 		return NULL;
@@ -364,11 +364,11 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
 	while (link_top(graph) != &stack_top(graph)->entity->links)
 		media_graph_walk_iter(graph);
 
-	entity = stack_pop(graph)->entity;
-	dev_dbg(entity->graph_obj.mdev->dev,
-		"walk: returning entity '%s'\n", entity->name);
+	pad = stack_pop(graph);
+	dev_dbg(pad->graph_obj.mdev->dev,
+		"walk: returning pad '%s':%u\n", pad->entity->name, pad->index);
 
-	return entity;
+	return pad;
 }
 EXPORT_SYMBOL_GPL(media_graph_walk_next);
 
@@ -416,7 +416,8 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_graph *graph = &pipe->graph;
-	struct media_entity *entity_err = entity;
+	struct media_pad *pad = entity->pads;
+	struct media_pad *pad_err = pad;
 	struct media_link *link;
 	int ret;
 
@@ -426,9 +427,11 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
 			goto error_graph_walk_start;
 	}
 
-	media_graph_walk_start(&pipe->graph, entity->pads);
+	media_graph_walk_start(&pipe->graph, pad);
+
+	while ((pad = media_graph_walk_next(graph))) {
+		struct media_entity *entity = pad->entity;
 
-	while ((entity = media_graph_walk_next(graph))) {
 		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
 		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_MAX_PADS);
 
@@ -452,11 +455,11 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
 		bitmap_fill(has_no_links, entity->num_pads);
 
 		list_for_each_entry(link, &entity->links, list) {
-			struct media_pad *pad = link->sink->entity == entity
-						? link->sink : link->source;
+			struct media_pad *other_pad = link->sink->entity == entity
+				? link->sink : link->source;
 
 			/* Mark that a pad is connected by a link. */
-			bitmap_clear(has_no_links, pad->index, 1);
+			bitmap_clear(has_no_links, other_pad->index, 1);
 
 			/*
 			 * Pads that either do not need to connect or
@@ -465,13 +468,13 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
 			 */
 			if (!(pad->flags & MEDIA_PAD_FL_MUST_CONNECT) ||
 			    link->flags & MEDIA_LNK_FL_ENABLED)
-				bitmap_set(active, pad->index, 1);
+				bitmap_set(active, other_pad->index, 1);
 
 			/*
 			 * Link validation will only take place for
 			 * sink ends of the link that are enabled.
 			 */
-			if (link->sink != pad ||
+			if (link->sink != other_pad ||
 			    !(link->flags & MEDIA_LNK_FL_ENABLED))
 				continue;
 
@@ -507,9 +510,11 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
 	 * Link validation on graph failed. We revert what we did and
 	 * return the error.
 	 */
-	media_graph_walk_start(graph, entity_err->pads);
+	media_graph_walk_start(graph, pad_err);
+
+	while ((pad_err = media_graph_walk_next(graph))) {
+		struct media_entity *entity_err = pad_err->entity;
 
-	while ((entity_err = media_graph_walk_next(graph))) {
 		/* Sanity check for negative stream_count */
 		if (!WARN_ON_ONCE(entity_err->stream_count <= 0)) {
 			entity_err->stream_count--;
@@ -521,7 +526,7 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
 		 * We haven't increased stream_count further than this
 		 * so we quit here.
 		 */
-		if (entity_err == entity)
+		if (pad_err == pad)
 			break;
 	}
 
@@ -548,8 +553,9 @@ EXPORT_SYMBOL_GPL(media_pipeline_start);
 
 void __media_pipeline_stop(struct media_entity *entity)
 {
-	struct media_graph *graph = &entity->pipe->graph;
 	struct media_pipeline *pipe = entity->pipe;
+	struct media_graph *graph = &pipe->graph;
+	struct media_pad *pad;
 
 	/*
 	 * If the following check fails, the driver has performed an
@@ -560,7 +566,9 @@ void __media_pipeline_stop(struct media_entity *entity)
 
 	media_graph_walk_start(graph, entity->pads);
 
-	while ((entity = media_graph_walk_next(graph))) {
+	while ((pad = media_graph_walk_next(graph))) {
+		struct media_entity *entity = pad->entity;
+
 		/* Sanity check for negative stream_count */
 		if (!WARN_ON_ONCE(entity->stream_count <= 0)) {
 			entity->stream_count--;
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4e7aa9a37f22b904..0f71b56f02ceb8ab 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1124,7 +1124,7 @@ static int __fimc_md_modify_pipeline(struct media_entity *entity, bool enable)
 static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
 				      struct media_graph *graph)
 {
-	struct media_entity *entity_err = entity;
+	struct media_pad *pad, *pad_err = entity->pads;
 	int ret;
 
 	/*
@@ -1133,13 +1133,13 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
 	 * through active links. This is needed as we cannot power on/off the
 	 * subdevs in random order.
 	 */
-	media_graph_walk_start(graph, entity->pads);
+	media_graph_walk_start(graph, pad_err);
 
-	while ((entity = media_graph_walk_next(graph))) {
-		if (!is_media_entity_v4l2_video_device(entity))
+	while ((pad = media_graph_walk_next(graph))) {
+		if (!is_media_entity_v4l2_video_device(pad->entity))
 			continue;
 
-		ret  = __fimc_md_modify_pipeline(entity, enable);
+		ret  = __fimc_md_modify_pipeline(pad->entity, enable);
 
 		if (ret < 0)
 			goto err;
@@ -1148,15 +1148,15 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
 	return 0;
 
 err:
-	media_graph_walk_start(graph, entity_err->pads);
+	media_graph_walk_start(graph, pad_err);
 
-	while ((entity_err = media_graph_walk_next(graph))) {
-		if (!is_media_entity_v4l2_video_device(entity_err))
+	while ((pad_err = media_graph_walk_next(graph))) {
+		if (!is_media_entity_v4l2_video_device(pad_err->entity))
 			continue;
 
-		__fimc_md_modify_pipeline(entity_err, !enable);
+		__fimc_md_modify_pipeline(pad_err->entity, !enable);
 
-		if (entity_err == entity)
+		if (pad_err == pad)
 			break;
 	}
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 218220b0a3ebb781..1f52779249cfaf60 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -226,8 +226,8 @@ static int isp_video_get_graph_data(struct isp_video *video,
 				    struct isp_pipeline *pipe)
 {
 	struct media_graph graph;
-	struct media_entity *entity = &video->video.entity;
-	struct media_device *mdev = entity->graph_obj.mdev;
+	struct media_pad *pad = video->video.entity.pads;
+	struct media_device *mdev = pad->entity->graph_obj.mdev;
 	struct isp_video *far_end = NULL;
 	int ret;
 
@@ -238,23 +238,24 @@ static int isp_video_get_graph_data(struct isp_video *video,
 		return ret;
 	}
 
-	media_graph_walk_start(&graph, entity->pads);
+	media_graph_walk_start(&graph, pad);
 
-	while ((entity = media_graph_walk_next(&graph))) {
+	while ((pad = media_graph_walk_next(&graph))) {
 		struct isp_video *__video;
 
-		media_entity_enum_set(&pipe->ent_enum, entity);
+		media_entity_enum_set(&pipe->ent_enum, pad->entity);
 
 		if (far_end != NULL)
 			continue;
 
-		if (entity == &video->video.entity)
+		if (pad == video->video.entity.pads)
 			continue;
 
-		if (!is_media_entity_v4l2_video_device(entity))
+		if (!is_media_entity_v4l2_video_device(pad->entity))
 			continue;
 
-		__video = to_isp_video(media_entity_to_video_device(entity));
+		__video = to_isp_video(media_entity_to_video_device(
+					       pad->entity));
 		if (__video->type != video->type)
 			far_end = __video;
 	}
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index da75847a61f3be63..f3e7f239e90c5f7d 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -573,8 +573,8 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 				     struct vsp1_video *video)
 {
 	struct media_graph graph;
-	struct media_entity *entity = &video->video.entity;
-	struct media_device *mdev = entity->graph_obj.mdev;
+	struct media_pad *pad = video->video.entity.pads;
+	struct media_device *mdev = pad->entity->graph_obj.mdev;
 	unsigned int i;
 	int ret;
 
@@ -583,17 +583,17 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 	if (ret)
 		return ret;
 
-	media_graph_walk_start(&graph, entity->pads);
+	media_graph_walk_start(&graph, pad);
 
-	while ((entity = media_graph_walk_next(&graph))) {
+	while ((pad = media_graph_walk_next(&graph))) {
 		struct v4l2_subdev *subdev;
 		struct vsp1_rwpf *rwpf;
 		struct vsp1_entity *e;
 
-		if (!is_media_entity_v4l2_subdev(entity))
+		if (!is_media_entity_v4l2_subdev(pad->entity))
 			continue;
 
-		subdev = media_entity_to_v4l2_subdev(entity);
+		subdev = media_entity_to_v4l2_subdev(pad->entity);
 		e = to_vsp1_entity(subdev);
 		list_add_tail(&e->list_pipe, &pipe->entities);
 		e->pipe = pipe;
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index ba767fa707e39dc4..9f0a53238d510fce 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -178,8 +178,8 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
 				  struct xvip_dma *start)
 {
 	struct media_graph graph;
-	struct media_entity *entity = &start->video.entity;
-	struct media_device *mdev = entity->graph_obj.mdev;
+	struct media_pad *pad = start->video.entity.pads;
+	struct media_device *mdev = pad->entity->graph_obj.mdev;
 	unsigned int num_inputs = 0;
 	unsigned int num_outputs = 0;
 	int ret;
@@ -193,15 +193,15 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
 		return ret;
 	}
 
-	media_graph_walk_start(&graph, entity->pads);
+	media_graph_walk_start(&graph, pad);
 
-	while ((entity = media_graph_walk_next(&graph))) {
+	while ((pad = media_graph_walk_next(&graph))) {
 		struct xvip_dma *dma;
 
-		if (entity->function != MEDIA_ENT_F_IO_V4L)
+		if (pad->entity->function != MEDIA_ENT_F_IO_V4L)
 			continue;
 
-		dma = to_xvip_dma(media_entity_to_video_device(entity));
+		dma = to_xvip_dma(media_entity_to_video_device(pad->entity));
 
 		if (dma->pad.flags & MEDIA_PAD_FL_SINK) {
 			pipe->output = dma;
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index c8adddb878cbd3b5..d923bb344b6aeb97 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -258,13 +258,14 @@ EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
 static int pipeline_pm_use_count(struct media_entity *entity,
 	struct media_graph *graph)
 {
+	struct media_pad *pad;
 	int use = 0;
 
 	media_graph_walk_start(graph, entity->pads);
 
-	while ((entity = media_graph_walk_next(graph))) {
-		if (is_media_entity_v4l2_video_device(entity))
-			use += entity->use_count;
+	while ((pad = media_graph_walk_next(graph))) {
+		if (is_media_entity_v4l2_video_device(pad->entity))
+			use += pad->entity->use_count;
 	}
 
 	return use;
@@ -317,7 +318,7 @@ static int pipeline_pm_power_one(struct media_entity *entity, int change)
 static int pipeline_pm_power(struct media_entity *entity, int change,
 	struct media_graph *graph)
 {
-	struct media_entity *first = entity;
+	struct media_pad *tmp_pad, *pad;
 	int ret = 0;
 
 	if (!change)
@@ -325,19 +326,19 @@ static int pipeline_pm_power(struct media_entity *entity, int change,
 
 	media_graph_walk_start(graph, entity->pads);
 
-	while (!ret && (entity = media_graph_walk_next(graph)))
-		if (is_media_entity_v4l2_subdev(entity))
-			ret = pipeline_pm_power_one(entity, change);
+	while (!ret && (pad = media_graph_walk_next(graph)))
+		if (is_media_entity_v4l2_subdev(pad->entity))
+			ret = pipeline_pm_power_one(pad->entity, change);
 
 	if (!ret)
 		return ret;
 
-	media_graph_walk_start(graph, first->pads);
+	media_graph_walk_start(graph, entity->pads);
 
-	while ((first = media_graph_walk_next(graph))
-	       && first != entity)
-		if (is_media_entity_v4l2_subdev(first))
-			pipeline_pm_power_one(first, -change);
+	while ((tmp_pad = media_graph_walk_next(graph))
+	       && tmp_pad != pad)
+		if (is_media_entity_v4l2_subdev(tmp_pad->entity))
+			pipeline_pm_power_one(tmp_pad->entity, -change);
 
 	return ret;
 }
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index af0d9e81b8de1cad..34f3754a9dea9a45 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -130,8 +130,8 @@ __vpfe_video_get_format(struct vpfe_video_device *video,
 static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
 {
 	struct media_graph graph;
-	struct media_entity *entity = &video->video_dev.entity;
-	struct media_device *mdev = entity->graph_obj.mdev;
+	struct media_pad *pad = video->video_dev.entity.pads;
+	struct media_device *mdev = pad->entity->graph_obj.mdev;
 	struct vpfe_pipeline *pipe = &video->pipe;
 	struct vpfe_video_device *far_end = NULL;
 	int ret;
@@ -150,13 +150,14 @@ static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
 		mutex_unlock(&mdev->graph_mutex);
 		return -ENOMEM;
 	}
-	media_graph_walk_start(&graph, entity->pads);
-	while ((entity = media_graph_walk_next(&graph))) {
-		if (entity == &video->video_dev.entity)
+	media_graph_walk_start(&graph, pad);
+	while ((pad = media_graph_walk_next(&graph))) {
+		if (pad->entity == &video->video_dev.entity)
 			continue;
-		if (!is_media_entity_v4l2_video_device(entity))
+		if (!is_media_entity_v4l2_video_device(pad->entity))
 			continue;
-		far_end = to_vpfe_video(media_entity_to_video_device(entity));
+		far_end = to_vpfe_video(media_entity_to_video_device(
+						pad->entity));
 		if (far_end->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 			pipe->inputs[pipe->input_num++] = far_end;
 		else
@@ -288,27 +289,27 @@ static int vpfe_video_validate_pipeline(struct vpfe_pipeline *pipe)
  */
 static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
 {
-	struct media_entity *entity;
+	struct media_pad *pad;
 	struct v4l2_subdev *subdev;
 	struct media_device *mdev;
 	int ret;
 
 	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS)
-		entity = vpfe_get_input_entity(pipe->outputs[0]);
+		pad = vpfe_get_input_entity(pipe->outputs[0])->pads;
 	else
-		entity = &pipe->inputs[0]->video_dev.entity;
+		pad = pipe->inputs[0]->video_dev.entity.pads;
 
-	mdev = entity->graph_obj.mdev;
+	mdev = pad->graph_obj.mdev;
 	mutex_lock(&mdev->graph_mutex);
 	ret = media_graph_walk_init(&pipe->graph, mdev);
 	if (ret)
 		goto out;
-	media_graph_walk_start(&pipe->graph, entity->pads);
-	while ((entity = media_graph_walk_next(&pipe->graph))) {
+	media_graph_walk_start(&pipe->graph, pad);
+	while ((pad = media_graph_walk_next(&pipe->graph))) {
 
-		if (!is_media_entity_v4l2_subdev(entity))
+		if (!is_media_entity_v4l2_subdev(pad->entity))
 			continue;
-		subdev = media_entity_to_v4l2_subdev(entity);
+		subdev = media_entity_to_v4l2_subdev(pad->entity);
 		ret = v4l2_subdev_call(subdev, video, s_stream, 1);
 		if (ret < 0 && ret != -ENOIOCTLCMD)
 			break;
@@ -333,25 +334,25 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
  */
 static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 {
-	struct media_entity *entity;
+	struct media_pad *pad;
 	struct v4l2_subdev *subdev;
 	struct media_device *mdev;
 	int ret = 0;
 
 	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS)
-		entity = vpfe_get_input_entity(pipe->outputs[0]);
+		pad = vpfe_get_input_entity(pipe->outputs[0])->pads;
 	else
-		entity = &pipe->inputs[0]->video_dev.entity;
+		pad = pipe->inputs[0]->video_dev.entity.pads;
 
-	mdev = entity->graph_obj.mdev;
+	mdev = pad->graph_obj.mdev;
 	mutex_lock(&mdev->graph_mutex);
-	media_graph_walk_start(&pipe->graph, entity->pads);
+	media_graph_walk_start(&pipe->graph, pad);
 
-	while ((entity = media_graph_walk_next(&pipe->graph))) {
+	while ((pad = media_graph_walk_next(&pipe->graph))) {
 
-		if (!is_media_entity_v4l2_subdev(entity))
+		if (!is_media_entity_v4l2_subdev(pad->entity))
 			continue;
-		subdev = media_entity_to_v4l2_subdev(entity);
+		subdev = media_entity_to_v4l2_subdev(pad->entity);
 		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
 		if (ret < 0 && ret != -ENOIOCTLCMD)
 			break;
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index b646fe909bad64d4..28efafa0621ef010 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -209,8 +209,8 @@ static struct iss_video *
 iss_video_far_end(struct iss_video *video)
 {
 	struct media_graph graph;
-	struct media_entity *entity = &video->video.entity;
-	struct media_device *mdev = entity->graph_obj.mdev;
+	struct media_pad *pad = video->video.entity.pads;
+	struct media_device *mdev = pad->entity->graph_obj.mdev;
 	struct iss_video *far_end = NULL;
 
 	mutex_lock(&mdev->graph_mutex);
@@ -220,16 +220,17 @@ iss_video_far_end(struct iss_video *video)
 		return NULL;
 	}
 
-	media_graph_walk_start(&graph, entity->pads);
+	media_graph_walk_start(&graph, pad);
 
-	while ((entity = media_graph_walk_next(&graph))) {
-		if (entity == &video->video.entity)
+	while ((pad = media_graph_walk_next(&graph))) {
+		if (pad->entity == &video->video.entity)
 			continue;
 
-		if (!is_media_entity_v4l2_video_device(entity))
+		if (!is_media_entity_v4l2_video_device(pad->entity))
 			continue;
 
-		far_end = to_iss_video(media_entity_to_video_device(entity));
+		far_end = to_iss_video(media_entity_to_video_device(
+						pad->entity));
 		if (far_end->type != video->type)
 			break;
 
@@ -863,7 +864,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	struct iss_video_fh *vfh = to_iss_video_fh(fh);
 	struct iss_video *video = video_drvdata(file);
 	struct media_graph graph;
-	struct media_entity *entity = &video->video.entity;
+	struct media_pad *pad = video->video.entity.pads;
 	enum iss_pipeline_state state;
 	struct iss_pipeline *pipe;
 	struct iss_video *far_end;
@@ -879,30 +880,31 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	 * Start streaming on the pipeline. No link touching an entity in the
 	 * pipeline can be activated or deactivated once streaming is started.
 	 */
-	pipe = entity->pipe
-	     ? to_iss_pipeline(entity) : &video->pipe;
+	pipe = pad->entity->pipe
+	     ? to_iss_pipeline(pad->entity) : &video->pipe;
 	pipe->external = NULL;
 	pipe->external_rate = 0;
 	pipe->external_bpp = 0;
 
-	ret = media_entity_enum_init(&pipe->ent_enum, entity->graph_obj.mdev);
+	ret = media_entity_enum_init(&pipe->ent_enum,
+				     pad->entity->graph_obj.mdev);
 	if (ret)
 		goto err_graph_walk_init;
 
-	ret = media_graph_walk_init(&graph, entity->graph_obj.mdev);
+	ret = media_graph_walk_init(&graph, pad->entity->graph_obj.mdev);
 	if (ret)
 		goto err_graph_walk_init;
 
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, true);
 
-	ret = media_pipeline_start(entity, &pipe->pipe);
+	ret = media_pipeline_start(pad->entity, &pipe->pipe);
 	if (ret < 0)
 		goto err_media_pipeline_start;
 
-	media_graph_walk_start(&graph, entity->pads);
-	while ((entity = media_graph_walk_next(&graph)))
-		media_entity_enum_set(&pipe->ent_enum, entity);
+	media_graph_walk_start(&graph, pad);
+	while ((pad = media_graph_walk_next(&graph)))
+		media_entity_enum_set(&pipe->ent_enum, pad->entity);
 
 	/*
 	 * Verify that the currently configured format matches the output of
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index c844a677a1cfbb0d..fad1776cbaadbbab 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -904,10 +904,11 @@ void media_graph_walk_start(struct media_graph *graph, struct media_pad *pad);
  * The graph structure must have been previously initialized with a call to
  * media_graph_walk_start().
  *
- * Return: returns the next entity in the graph or %NULL if the whole graph
- * have been traversed.
+ * Return: returns the next pad in the graph or %NULL if the whole
+ * graph have been traversed. The pad which is returned is the pad
+ * through which a new entity is reached when parsing the graph.
  */
-struct media_entity *media_graph_walk_next(struct media_graph *graph);
+struct media_pad *media_graph_walk_next(struct media_graph *graph);
 
 /**
  * media_pipeline_start - Mark a pipeline as streaming
-- 
2.18.0
