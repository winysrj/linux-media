Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59462 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966153Ab2JZTqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Oct 2012 15:46:22 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] media: Entities with sink pads must have at least one enabled link
Date: Fri, 26 Oct 2012 22:46:17 +0300
Message-Id: <1351280777-4936-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If an entity has sink pads, at least one of them must be connected to
another pad with an enabled link. If a driver with multiple sink pads has
more strict requirements the check should be done in the driver itself.

Just requiring one sink pad is connected with an enabled link is enough
API-wise: entities with sink pads with only disabled links should not be
allowed to stream in the first place, but also in a different operation mode
a device might require only one of its pads connected with an active link.

If an entity has an ability to function as a source entity another logical
entity connected to the aforementioned one should be used for the purpose.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/media-entity.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e1cd132..8846ea7 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -227,6 +227,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
+		bool has_sink = false, active_sink = false;
 		unsigned int i;
 
 		entity->stream_count++;
@@ -243,18 +244,27 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		for (i = 0; i < entity->num_links; i++) {
 			struct media_link *link = &entity->links[i];
 
+			/* Are we the sink or not? */
+			if (link->sink->entity != entity)
+				continue;
+
+			has_sink = true;
+
 			/* Is this pad part of an enabled link? */
 			if (!(link->flags & MEDIA_LNK_FL_ENABLED))
 				continue;
 
-			/* Are we the sink or not? */
-			if (link->sink->entity != entity)
-				continue;
+			active_sink = true;
 
 			ret = entity->ops->link_validate(link);
 			if (ret < 0 && ret != -ENOIOCTLCMD)
 				goto error;
 		}
+
+		if (has_sink && !active_sink) {
+			ret = -EPIPE;
+			goto error;
+		}
 	}
 
 	mutex_unlock(&mdev->graph_mutex);
-- 
1.7.2.5

