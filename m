Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46933 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbbHNO6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 10:58:31 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-sh@vger.kernel.org
Subject: [PATCH v4 2/6] media: create a macro to get entity ID
Date: Fri, 14 Aug 2015 11:56:39 -0300
Message-Id: <89205b71de7a6edc3638eb14df8d0b0e4df32bc2.1439563682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439563682.git.mchehab@osg.samsung.com>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439563682.git.mchehab@osg.samsung.com>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of accessing direcly entity.id, let's create a macro,
as this field will be moved into a common struct later on.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7b39440192d6..b9382f06044a 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -75,8 +75,8 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
 	spin_lock(&mdev->lock);
 
 	media_device_for_each_entity(entity, mdev) {
-		if ((entity->id == id && !next) ||
-		    (entity->id > id && next)) {
+		if (((entity_id(entity) == id) && !next) ||
+		    ((entity_id(entity) > id) && next)) {
 			spin_unlock(&mdev->lock);
 			return entity;
 		}
@@ -102,7 +102,7 @@ static long media_device_enum_entities(struct media_device *mdev,
 	if (ent == NULL)
 		return -EINVAL;
 
-	u_ent.id = ent->id;
+	u_ent.id = entity_id(ent);
 	if (ent->name)
 		strlcpy(u_ent.name, ent->name, sizeof(u_ent.name));
 	u_ent.type = ent->type;
@@ -120,7 +120,7 @@ static long media_device_enum_entities(struct media_device *mdev,
 static void media_device_kpad_to_upad(const struct media_pad *kpad,
 				      struct media_pad_desc *upad)
 {
-	upad->entity = kpad->entity->id;
+	upad->entity = entity_id(kpad->entity);
 	upad->index = kpad->index;
 	upad->flags = kpad->flags;
 }
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 78440c7aad94..b8102bda664d 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -141,10 +141,10 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 	graph->stack[graph->top].entity = NULL;
 	bitmap_zero(graph->entities, MEDIA_ENTITY_ENUM_MAX_ID);
 
-	if (WARN_ON(entity->id >= MEDIA_ENTITY_ENUM_MAX_ID))
+	if (WARN_ON(entity_id(entity) >= MEDIA_ENTITY_ENUM_MAX_ID))
 		return;
 
-	__set_bit(entity->id, graph->entities);
+	__set_bit(entity_id(entity), graph->entities);
 	stack_push(graph, entity);
 }
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
@@ -185,11 +185,11 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 
 		/* Get the entity in the other end of the link . */
 		next = media_entity_other(entity, link);
-		if (WARN_ON(next->id >= MEDIA_ENTITY_ENUM_MAX_ID))
+		if (WARN_ON(entity_id(next) >= MEDIA_ENTITY_ENUM_MAX_ID))
 			return NULL;
 
 		/* Has the entity already been visited? */
-		if (__test_and_set_bit(next->id, graph->entities)) {
+		if (__test_and_set_bit(entity_id(next), graph->entities)) {
 			link_top(graph)++;
 			continue;
 		}
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 17f08973f835..01bc3c48a2b4 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -352,10 +352,10 @@ static int vsp1_pipeline_validate_branch(struct vsp1_pipeline *pipe,
 			break;
 
 		/* Ensure the branch has no loop. */
-		if (entities & (1 << entity->subdev.entity.id))
+		if (entities & (1 << entity_id(&entity->subdev.entity)))
 			return -EPIPE;
 
-		entities |= 1 << entity->subdev.entity.id;
+		entities |= 1 << entity_id(&entity->subdev.entity);
 
 		/* UDS can't be chained. */
 		if (entity->type == VSP1_ENTITY_UDS) {
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 8b21a4d920d9..478d5cd56be9 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -126,6 +126,8 @@ struct media_entity_graph {
 	int top;
 };
 
+#define entity_id(entity) ((entity)->id)
+
 int media_entity_init(struct media_entity *entity, u16 num_pads,
 		struct media_pad *pads);
 void media_entity_cleanup(struct media_entity *entity);
-- 
2.4.3

