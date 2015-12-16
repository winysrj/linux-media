Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60619 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932562AbbLPNeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 08:34:50 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v3 14/23] media: Keep using the same graph walk object for a given pipeline
Date: Wed, 16 Dec 2015 15:32:29 +0200
Message-Id: <1450272758-29446-15-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialise a given graph walk object once, and then keep using it whilst
the same pipeline is running. Once the pipeline is stopped, release the
graph walk object.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 17 +++++++++++------
 include/media/media-entity.h |  4 +++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 2dd60d75..ddf3c23 100644
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
 
+	WARN_ON(!pipe->streaming_count);
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
index c29ddc2..251eddf 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -119,9 +119,11 @@ struct media_entity_graph {
 /*
  * struct media_pipeline - Media pipeline related information
  *
- * @graph:	Media graph walk during pipeline start / stop
+ * @streaming_count:	Streaming start count - streaming stop count
+ * @graph:		Media graph walk during pipeline start / stop
  */
 struct media_pipeline {
+	int streaming_count;
 	struct media_entity_graph graph;
 };
 
-- 
2.1.4

