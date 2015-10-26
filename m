Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45007 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751761AbbJZXDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 19:03:51 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 05/19] media: Move media graph state for streamon/off to the pipeline
Date: Tue, 27 Oct 2015 01:01:36 +0200
Message-Id: <1445900510-1398-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct media_entity_graph was allocated in the stack, limiting the
number of entities that could be reasonably allocated. Instead, move the
struct to struct media_pipeline which is typically allocated using
kmalloc() instead.

The intent is to keep the enumeration around for later use for the
duration of the streaming. As streaming is eventually stopped, an
unfortunate memory allocation failure would prevent stopping the
streaming. As no memory will need to be allocated, the problem is avoided
altogether.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 16 ++++++++--------
 include/media/media-entity.h |  2 ++
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index fceaf44..667ab32 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -456,16 +456,16 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 					     struct media_pipeline *pipe)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
-	struct media_entity_graph graph;
+	struct media_entity_graph *graph = &pipe->graph;
 	struct media_entity *entity_err = entity;
 	struct media_link *link;
 	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
 
-	media_entity_graph_walk_start(&graph, entity);
+	media_entity_graph_walk_start(graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(&graph))) {
+	while ((entity = media_entity_graph_walk_next(graph))) {
 		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
 		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_MAX_PADS);
 
@@ -546,9 +546,9 @@ error:
 	 * Link validation on graph failed. We revert what we did and
 	 * return the error.
 	 */
-	media_entity_graph_walk_start(&graph, entity_err);
+	media_entity_graph_walk_start(graph, entity_err);
 
-	while ((entity_err = media_entity_graph_walk_next(&graph))) {
+	while ((entity_err = media_entity_graph_walk_next(graph))) {
 		entity_err->stream_count--;
 		if (entity_err->stream_count == 0)
 			entity_err->pipe = NULL;
@@ -582,13 +582,13 @@ EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
 void media_entity_pipeline_stop(struct media_entity *entity)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
-	struct media_entity_graph graph;
+	struct media_entity_graph *graph = &entity->pipe->graph;
 
 	mutex_lock(&mdev->graph_mutex);
 
-	media_entity_graph_walk_start(&graph, entity);
+	media_entity_graph_walk_start(graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(&graph))) {
+	while ((entity = media_entity_graph_walk_next(graph))) {
 		entity->stream_count--;
 		if (entity->stream_count == 0)
 			entity->pipe = NULL;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index dde9a5f..b2864cb 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -98,6 +98,8 @@ struct media_entity_graph {
 };
 
 struct media_pipeline {
+	/* For walking the graph in pipeline start / stop */
+	struct media_entity_graph graph;
 };
 
 /**
-- 
2.1.4

