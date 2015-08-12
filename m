Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbHLUPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 16:15:12 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH RFC v3 15/16] media: rename media_entity_remove_foo functions
Date: Wed, 12 Aug 2015 17:14:59 -0300
Message-Id: <80fd5ced9d58ce3c648e733f01dca3fbc25401bf.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As entities will also have links to interfaces, we need to
rename the existing functions that remove links, to avoid
namespace collision and confusion.

No functional changes.

The rename was made by this script:
	for i in $(find drivers/media -name '*.[ch]' -type f) $(find drivers/staging/media -name '*.[ch]' -type f) $(find include/ -name '*.h' -type f) ; do sed s,media_entity_remove,media_remove_pad,g <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index f43af2fda306..c3bc8a6f660b 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -490,7 +490,7 @@ static void __media_remove_link(struct media_link *link)
 	kfree(link);
 }
 
-static void __media_entity_remove_link(struct media_entity *entity,
+static void __media_remove_pad_link(struct media_entity *entity,
 				       struct media_link *link)
 {
 	struct media_link *rlink, *tmp;
@@ -548,7 +548,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 				      &sink->pads[sink_pad].graph_obj,
 				      flags, &sink->links);
 	if (backlink == NULL) {
-		__media_entity_remove_link(source, link);
+		__media_remove_pad_link(source, link);
 		return -ENOMEM;
 	}
 
@@ -561,29 +561,29 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 }
 EXPORT_SYMBOL_GPL(media_create_pad_link);
 
-void __media_entity_remove_links(struct media_entity *entity)
+void __media_remove_pad_links(struct media_entity *entity)
 {
 	struct media_link *link, *tmp;
 
 	list_for_each_entry_safe(link, tmp, &entity->links, list)
-		__media_entity_remove_link(entity, link);
+		__media_remove_pad_link(entity, link);
 
 	entity->num_links = 0;
 	entity->num_backlinks = 0;
 }
-EXPORT_SYMBOL_GPL(__media_entity_remove_links);
+EXPORT_SYMBOL_GPL(__media_remove_pad_links);
 
-void media_entity_remove_links(struct media_entity *entity)
+void media_remove_pad_links(struct media_entity *entity)
 {
 	/* Do nothing if the entity is not registered. */
 	if (entity->parent == NULL)
 		return;
 
 	mutex_lock(&entity->parent->graph_mutex);
-	__media_entity_remove_links(entity);
+	__media_remove_pad_links(entity);
 	mutex_unlock(&entity->parent->graph_mutex);
 }
-EXPORT_SYMBOL_GPL(media_entity_remove_links);
+EXPORT_SYMBOL_GPL(media_remove_pad_links);
 
 static int __media_entity_setup_link_notify(struct media_link *link, u32 flags)
 {
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 5b0a30b9252b..bbec6d87f5f8 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -285,7 +285,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	if (v4l2_dev->mdev) {
-		media_entity_remove_links(&sd->entity);
+		media_remove_pad_links(&sd->entity);
 		media_device_unregister_entity(&sd->entity);
 	}
 #endif
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 8400c517ff1f..e63e402ca6d1 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -213,8 +213,8 @@ void media_entity_cleanup(struct media_entity *entity);
 
 int media_create_pad_link(struct media_entity *source, u16 source_pad,
 		struct media_entity *sink, u16 sink_pad, u32 flags);
-void __media_entity_remove_links(struct media_entity *entity);
-void media_entity_remove_links(struct media_entity *entity);
+void __media_remove_pad_links(struct media_entity *entity);
+void media_remove_pad_links(struct media_entity *entity);
 
 int __media_entity_setup_link(struct media_link *link, u32 flags);
 int media_entity_setup_link(struct media_link *link, u32 flags);
-- 
2.4.3

