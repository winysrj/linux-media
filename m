Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45024 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752080AbbJZXDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 19:03:52 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 13/19] media: Keep using the same graph walk object for a given pipeline
Date: Tue, 27 Oct 2015 01:01:44 +0200
Message-Id: <1445900510-1398-14-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialise a given graph walk object once, and then keep using it whilst
the same pipeline is running. Once the pipeline is stopped, release the
graph walk object.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 17 +++++++++++------
 include/media/media-entity.h |  1 +
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 7429c03..137aa09d 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -488,10 +488,10 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 
 	mutex_lock(&mdev->graph_mutex);
 
-	ret = media_entity_graph_walk_init(&pipe->graph, mdev);
-	if (ret) {
-		mutex_unlock(&mdev->graph_mutex);
-		return ret;
+	if (!pipe->streaming_count++) {
+		ret = media_entity_graph_walk_init(&pipe->graph, mdev);
+		if (ret)
+			goto error_graph_walk_start;
 	}
 
 	media_entity_graph_walk_start(&pipe->graph, entity);
@@ -592,7 +592,9 @@ error:
 			break;
 	}
 
-	media_entity_graph_walk_cleanup(graph);
+error_graph_walk_start:
+	if (!--pipe->streaming_count)
+		media_entity_graph_walk_cleanup(graph);
 
 	mutex_unlock(&mdev->graph_mutex);
 
@@ -616,9 +618,11 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_entity_graph *graph = &entity->pipe->graph;
+	struct media_pipeline *pipe = entity->pipe;
 
 	mutex_lock(&mdev->graph_mutex);
 
+	BUG_ON(!pipe->streaming_count);
 	media_entity_graph_walk_start(graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(graph))) {
@@ -627,7 +631,8 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 			entity->pipe = NULL;
 	}
 
-	media_entity_graph_walk_cleanup(graph);
+	if (!--pipe->streaming_count)
+		media_entity_graph_walk_cleanup(graph);
 
 	mutex_unlock(&mdev->graph_mutex);
 }
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 21fd07b..cc01e08 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -98,6 +98,7 @@ struct media_entity_graph {
 };
 
 struct media_pipeline {
+	int streaming_count;
 	/* For walking the graph in pipeline start / stop */
 	struct media_entity_graph graph;
 };
-- 
2.1.4

