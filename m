Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49671 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3EaOlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 10:41:22 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO000MJ3GRJPW0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 23:41:21 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hj210.choi@samsung.com,
	arun.kk@samsung.com, shaik.ameer@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH v2 11/11] exynos4-is: Extend link_notify handler to
 support fimc-is/lite pipelines
Date: Fri, 31 May 2013 16:37:27 +0200
Message-id: <1370011047-11488-12-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
References: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch corrects the link_notify handler to support more complex
pipelines, including fimc-lite and fimc-is entities.

After the FIMC-IS driver addition the assumptions made in the link_notify
callback are no longer valid, e.g. the link between fimc-lite subdev and
its video node is not immutable any more and there is more subdevs than
just sensor, MIPI-CSIS and FIMC(-LITE).

The graph is now walked and for each video node found a media pipeline
which ends at this node is disabled/enabled (the subdevs are powered
on/off).

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |  103 +++++++++++++++++++------
 1 file changed, 81 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 04abf6f..f8ada95 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1289,39 +1289,98 @@ int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
 	return __fimc_md_set_camclk(fmd, si, on);
 }
 
-static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
-						unsigned int notification)
+static int __fimc_md_modify_pipeline(struct media_entity *entity, bool enable)
 {
-	struct media_entity *sink = link->sink->entity;
 	struct exynos_video_entity *ve;
+	struct fimc_pipeline *p;
 	struct video_device *vdev;
-	struct fimc_pipeline *pipeline;
-	int i, ret = 0;
+	int ret;
 
-	if (media_entity_type(sink) != MEDIA_ENT_T_DEVNODE_V4L ||
-	    notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH)
+	vdev = media_entity_to_video_device(entity);
+	if (vdev->entity.use_count == 0)
 		return 0;
 
-	vdev = media_entity_to_video_device(sink);
 	ve = vdev_to_exynos_video_entity(vdev);
-	pipeline = to_fimc_pipeline(ve->pipe);
+	p = to_fimc_pipeline(ve->pipe);
+	/*
+	 * Nothing to do if we are disabling the pipeline, some link
+	 * has been disconnected and p->subdevs array is cleared now.
+	 */
+	if (!enable && p->subdevs[IDX_SENSOR] == NULL)
+		return 0;
 
-	if (!(flags & MEDIA_LNK_FL_ENABLED) && pipeline->subdevs[IDX_SENSOR]) {
-		if (sink->use_count > 0)
-			ret = __fimc_pipeline_close(ve->pipe);
+	if (enable)
+		ret = __fimc_pipeline_open(ve->pipe, entity, true);
+	else
+		ret = __fimc_pipeline_close(ve->pipe);
 
-		for (i = 0; i < IDX_MAX; i++)
-			pipeline->subdevs[i] = NULL;
-	} else if (sink->use_count > 0) {
-		/*
-		 * Link activation. Enable power of pipeline elements only if
-		 * the pipeline is already in use, i.e. its video node is open.
-		 * Recreate the controls destroyed during the link deactivation.
-		 */
-		ret = __fimc_pipeline_open(ve->pipe, sink, true);
+	if (ret == 0 && !enable)
+		memset(p->subdevs, 0, sizeof(p->subdevs));
+
+	return ret;
+}
+
+/* Locking: called with entity->parent->graph_mutex mutex held. */
+static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
+{
+	struct media_entity *entity_err = entity;
+	struct media_entity_graph graph;
+	int ret;
+
+	/*
+	 * Walk current graph and call the pipeline open/close routine for each
+	 * opened video node that belongs to the graph of entities connected
+	 * through active links. This is needed as we cannot power on/off the
+	 * subdevs in random order.
+	 */
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
+			continue;
+
+		ret  = __fimc_md_modify_pipeline(entity, enable);
+
+		if (ret < 0)
+			goto err;
+	}
+
+	return 0;
+ err:
+	media_entity_graph_walk_start(&graph, entity_err);
+
+	while ((entity_err = media_entity_graph_walk_next(&graph))) {
+		if (media_entity_type(entity_err) != MEDIA_ENT_T_DEVNODE)
+			continue;
+
+		__fimc_md_modify_pipeline(entity_err, !enable);
+
+		if (entity_err == entity)
+			break;
+	}
+
+	return ret;
+}
+
+static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
+				unsigned int notification)
+{
+	struct media_entity *sink = link->sink->entity;
+	int ret = 0;
+
+	/* Before link disconnection */
+	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
+		if (!(flags & MEDIA_LNK_FL_ENABLED))
+			ret = __fimc_md_modify_pipelines(sink, false);
+		else
+			; /* TODO: Link state change validation */
+	/* After link activation */
+	} else if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
+		   (flags & MEDIA_LNK_FL_ENABLED)) {
+		ret = __fimc_md_modify_pipelines(sink, true);
 	}
 
-	return ret ? -EPIPE : ret;
+	return ret ? -EPIPE : 0;
 }
 
 static ssize_t fimc_md_sysfs_show(struct device *dev,
-- 
1.7.9.5

