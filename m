Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55896 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753696Ab3IDAJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Sep 2013 20:09:46 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [RFC v1.2 2/4] media: Check for active links on pads with MEDIA_PAD_FL_MUST_CONNECT flag
Date: Wed,  4 Sep 2013 03:09:42 +0300
Message-Id: <1378253382-23174-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1806796.1hWpdenVOE@avalon>
References: <1806796.1hWpdenVOE@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not allow streaming if a pad with MEDIA_PAD_FL_MUST_CONNECT flag is
connected by links that are all inactive.

This patch makes it possible to avoid drivers having to check for the most
common case of link state validation: a sink pad that must be connected.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/media-entity.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 2c286c3..567a171 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -235,6 +235,8 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
+		DECLARE_BITMAP(active, entity->num_pads);
+		DECLARE_BITMAP(has_no_links, entity->num_pads);
 		unsigned int i;
 
 		entity->stream_count++;
@@ -248,21 +250,46 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		if (!entity->ops || !entity->ops->link_validate)
 			continue;
 
+		bitmap_zero(active, entity->num_pads);
+		bitmap_fill(has_no_links, entity->num_pads);
+
 		for (i = 0; i < entity->num_links; i++) {
 			struct media_link *link = &entity->links[i];
-
-			/* Is this pad part of an enabled link? */
-			if (!(link->flags & MEDIA_LNK_FL_ENABLED))
-				continue;
-
-			/* Are we the sink or not? */
-			if (link->sink->entity != entity)
+			struct media_pad *pad = link->sink->entity == entity
+				? link->sink : link->source;
+
+			/* Mark that a pad is connected by a link. */
+			bitmap_clear(has_no_links, pad->index, 1);
+
+			/*
+			 * Pads that either do not need to connect or
+			 * are connected through an enabled link are
+			 * fine.
+			 */
+			if (!(pad->flags & MEDIA_PAD_FL_MUST_CONNECT)
+			    || link->flags & MEDIA_LNK_FL_ENABLED)
+				bitmap_set(active, pad->index, 1);
+
+			/*
+			 * Link validation will only take place for
+			 * sink ends of the link that are enabled.
+			 */
+			if (link->sink != pad
+			    || !(link->flags & MEDIA_LNK_FL_ENABLED))
 				continue;
 
 			ret = entity->ops->link_validate(link);
 			if (ret < 0 && ret != -ENOIOCTLCMD)
 				goto error;
 		}
+
+		/* Either no links or validated links are fine. */
+		bitmap_or(active, active, has_no_links, entity->num_pads);
+
+		if (!bitmap_full(active, entity->num_pads)) {
+			ret = -EPIPE;
+			goto error;
+		}
 	}
 
 	mutex_unlock(&mdev->graph_mutex);
-- 
1.7.10.4

