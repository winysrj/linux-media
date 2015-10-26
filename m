Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45015 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751877AbbJZXDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 19:03:51 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 07/19] media: Use the new media_entity_graph_walk_start()
Date: Tue, 27 Oct 2015 01:01:38 +0200
Message-Id: <1445900510-1398-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index bf3c31f..4161dc7 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -492,7 +492,13 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 
 	mutex_lock(&mdev->graph_mutex);
 
-	media_entity_graph_walk_start(graph, entity);
+	ret = media_entity_graph_walk_init(&pipe->graph, mdev);
+	if (ret) {
+		mutex_unlock(&mdev->graph_mutex);
+		return ret;
+	}
+
+	media_entity_graph_walk_start(&pipe->graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(graph))) {
 		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
@@ -590,6 +596,8 @@ error:
 			break;
 	}
 
+	media_entity_graph_walk_cleanup(graph);
+
 	mutex_unlock(&mdev->graph_mutex);
 
 	return ret;
@@ -623,6 +631,8 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 			entity->pipe = NULL;
 	}
 
+	media_entity_graph_walk_cleanup(graph);
+
 	mutex_unlock(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);
-- 
2.1.4

