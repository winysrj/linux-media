Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46475 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753674Ab3HaQVl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 12:21:41 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v1.1 3/5] media: Pads that are not connected by even a disabled link are fine
Date: Sat, 31 Aug 2013 19:28:06 +0300
Message-Id: <1377966487-22565-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1611138.kmhZXgyzhc@avalon>
References: <1611138.kmhZXgyzhc@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not require a connected link to a pad if a pad has no links connected to
it.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
Hi Laurent,

This goes on top of patch 2/4. I can combine the two in the end but I think
this is cleaner as a separate change.

 drivers/media/media-entity.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index a99396b..2ad291f 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -236,6 +236,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 		DECLARE_BITMAP(active, entity->num_pads);
+		DECLARE_BITMAP(has_no_links, entity->num_pads);
 		unsigned int i;
 
 		entity->stream_count++;
@@ -250,6 +251,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 			continue;
 
 		bitmap_zero(active, entity->num_pads);
+		bitmap_fill(has_no_links, entity->num_pads);
 
 		for (i = 0; i < entity->num_links; i++) {
 			struct media_link *link = &entity->links[i];
@@ -257,6 +259,11 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 				? link->sink : link->source;
 
 			/*
+			 * Mark that a pad is connected by a link.
+			 */
+			bitmap_clear(has_no_links, pad->index, 1);
+
+			/*
 			 * Pads that either do not need to connect or
 			 * are connected through an enabled link are
 			 * fine.
@@ -278,6 +285,9 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 				goto error;
 		}
 
+		/* Either no links or validated links are fine. */
+		bitmap_or(active, active, has_no_links, entity->num_pads);
+
 		if (!bitmap_full(active, entity->num_pads)) {
 			ret = -EPIPE;
 			goto error;
-- 
1.7.10.4

