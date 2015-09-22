Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58165 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933787AbbIVXUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 19:20:00 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH] [media] media-entity: Don't use var length arrays
Date: Tue, 22 Sep 2015 20:19:03 -0300
Message-Id: <60c3f149566de02ae1d2b857d4b6115ec7a9107e.1442963941.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The graph traversal algorithm currently uses two variable-length
arrays that are dynamically allocated at the stack:

	drivers/media/media-entity.c:238:17: warning: Variable length array is used.
	drivers/media/media-entity.c:239:17: warning: Variable length array is used.

Those are bad, specially if the number of pads for some entity would
be bigger than a certain amount, as it would cause a Linux stack
overflow.

We could just replace entity->num_pads by a define in order to solve
the above sparse warnings, but that would still prevent having entities
with a big number of pads. So, let's do the right thing and use a
kalloced var to store those ancillary bitmaps, e. g. put them at
struct media_device, and use an arbitrary big number that will work
for all currently known usecases.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 153a46469814..02842d875809 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -235,8 +235,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
-		DECLARE_BITMAP(active, entity->num_pads);
-		DECLARE_BITMAP(has_no_links, entity->num_pads);
 		unsigned int i;
 
 		entity->stream_count++;
@@ -250,8 +248,8 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		if (!entity->ops || !entity->ops->link_validate)
 			continue;
 
-		bitmap_zero(active, entity->num_pads);
-		bitmap_fill(has_no_links, entity->num_pads);
+		bitmap_zero(mdev->active, entity->num_pads);
+		bitmap_fill(mdev->has_no_links, entity->num_pads);
 
 		for (i = 0; i < entity->num_links; i++) {
 			struct media_link *link = &entity->links[i];
@@ -259,7 +257,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 						? link->sink : link->source;
 
 			/* Mark that a pad is connected by a link. */
-			bitmap_clear(has_no_links, pad->index, 1);
+			bitmap_clear(mdev->has_no_links, pad->index, 1);
 
 			/*
 			 * Pads that either do not need to connect or
@@ -268,7 +266,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 			 */
 			if (!(pad->flags & MEDIA_PAD_FL_MUST_CONNECT) ||
 			    link->flags & MEDIA_LNK_FL_ENABLED)
-				bitmap_set(active, pad->index, 1);
+				bitmap_set(mdev->active, pad->index, 1);
 
 			/*
 			 * Link validation will only take place for
@@ -290,15 +288,16 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		}
 
 		/* Either no links or validated links are fine. */
-		bitmap_or(active, active, has_no_links, entity->num_pads);
+		bitmap_or(mdev->active, mdev->active, mdev->has_no_links,
+			  entity->num_pads);
 
-		if (!bitmap_full(active, entity->num_pads)) {
+		if (!bitmap_full(mdev->active, entity->num_pads)) {
 			ret = -EPIPE;
 			dev_dbg(entity->parent->dev,
 				"\"%s\":%u must be connected by an enabled link\n",
 				entity->name,
 				(unsigned)find_first_zero_bit(
-					active, entity->num_pads));
+					mdev->active, entity->num_pads));
 			goto error;
 		}
 	}
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 6e6db78f1ee2..1ac132af031b 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -32,6 +32,10 @@
 
 struct device;
 
+/* Maximum number of pads per entity */
+
+#define	MEDIA_MAX_PADS	512
+
 /**
  * struct media_device - Media device
  * @dev:	Parent device
@@ -78,6 +82,11 @@ struct media_device {
 
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
+
+	/* private: ancillary bitmaps used by graph traversal algo */
+
+	DECLARE_BITMAP(active, MEDIA_MAX_PADS);
+	DECLARE_BITMAP(has_no_links, MEDIA_MAX_PADS);
 };
 
 /* Supported link_notify @notification values. */
-- 
2.4.3

