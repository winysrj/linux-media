Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39775 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752432AbbK2TWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2015 14:22:44 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v2 14/22] media: Keep using the same graph walk object for a given pipeline
Date: Sun, 29 Nov 2015 21:20:15 +0200
Message-Id: <1448824823-10372-15-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
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
index 8122736..85c2656 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -116,9 +116,11 @@ struct media_entity_graph {
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

