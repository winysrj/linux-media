Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58270 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754232Ab3JMLBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 07:01:01 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sylwester.nawrocki@gmail.com,
	a.hajda@samsung.com
Subject: [PATCH v2.1 2/4] media: Check for active links on pads with MEDIA_PAD_FL_MUST_CONNECT flag
Date: Sun, 13 Oct 2013 14:00:26 +0300
Message-Id: <1381662027-26406-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <524DEC22.5090107@gmail.com>
References: <524DEC22.5090107@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not allow streaming if a pad with MEDIA_PAD_FL_MUST_CONNECT flag is not
connected by an active link.

This patch makes it possible to avoid drivers having to check for the most
common case of link state validation: a sink pad that must be connected.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
Since v2:

- Change Sylwester's e-mail address

 .../DocBook/media/v4l/media-ioc-enum-links.xml     |    3 +-
 drivers/media/media-entity.c                       |   41 ++++++++++++++++----
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
index e357dc9..cf85485 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
@@ -141,8 +141,7 @@
 	    entity to be able to stream. There could be temporary reasons
 	    (e.g. device configuration dependent) for the pad to need
 	    enabled links even when this flag isn't set; the absence of the
-	    flag doesn't imply there is none. The flag has no effect on pads
-	    without connected links.</entry>
+	    flag doesn't imply there is none.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 2c286c3..37c334e 100644
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
+						? link->sink : link->source;
+
+			/* Mark that a pad is connected by a link. */
+			bitmap_clear(has_no_links, pad->index, 1);
+
+			/*
+			 * Pads that either do not need to connect or
+			 * are connected through an enabled link are
+			 * fine.
+			 */
+			if (!(pad->flags & MEDIA_PAD_FL_MUST_CONNECT) ||
+			    link->flags & MEDIA_LNK_FL_ENABLED)
+				bitmap_set(active, pad->index, 1);
+
+			/*
+			 * Link validation will only take place for
+			 * sink ends of the link that are enabled.
+			 */
+			if (link->sink != pad ||
+			    !(link->flags & MEDIA_LNK_FL_ENABLED))
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

