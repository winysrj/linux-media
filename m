Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:29125 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3FJO4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 10:56:09 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO6007Y0MTK9YR0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 23:56:08 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, a.hajda@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH v3 1/2] media: Add a function removing all links of a media
 entity
Date: Mon, 10 Jun 2013 16:54:29 +0200
Message-id: <1370876070-23699-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370876070-23699-1-git-send-email-s.nawrocki@samsung.com>
References: <1370876070-23699-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function allows to remove all media entity's links to other
entities, leaving no references to a media entity's links array
at its remote entities.

Currently, when a driver of some entity is removed it will free its
media entities links[] array, leaving dangling pointers at other
entities that are part of same media graph. This is troublesome when
drivers of a media device entities are in separate kernel modules,
removing only some modules will leave others in an incorrect state.

This function is intended to be used when an entity is being
unregistered from a media device.

With an assumption that normally the media links should be created
between media entities registered to a media device, with the graph
mutex held.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v2:
 - removed caching of remote->num_links, re-added rlink local variable,
 - refactored the loop iterating the remote entity links array.

Changes since v1:
 - couple code improvements like variable localization, type change, etc.
 - removed WARN_ON_ONCE() to avoid warnings when the media_entity_remove_links()
   function is called from within remove() callback of a driver of subdev
   which has not yet been registered to the media device, e.g. due to
   deferred probing, with a call stack like
      -> remove()
         -> v4l2_device_unregister_subdev()
            -> media_entity_remove_links()
---
 drivers/media/media-entity.c |   50 ++++++++++++++++++++++++++++++++++++++++++
 include/media/media-entity.h |    3 +++
 2 files changed, 53 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 0438209..4f436f1 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -429,6 +429,56 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 }
 EXPORT_SYMBOL_GPL(media_entity_create_link);
 
+void __media_entity_remove_links(struct media_entity *entity)
+{
+	unsigned int i;
+
+	for (i = 0; i < entity->num_links; i++) {
+		struct media_link *link = &entity->links[i];
+		struct media_entity *remote;
+		unsigned int r = 0;
+
+		if (link->source->entity == entity)
+			remote = link->sink->entity;
+		else
+			remote = link->source->entity;
+
+		while (r < remote->num_links) {
+			struct media_link *rlink = &remote->links[r];
+
+			if (rlink != link->reverse) {
+				r++;
+				continue;
+			}
+
+			if (link->source->entity == entity)
+				remote->num_backlinks--;
+
+			if (--remote->num_links == 0)
+				break;
+
+			/* Insert last entry in place of the dropped link. */
+			*rlink = remote->links[remote->num_links];
+		}
+	}
+
+	entity->num_links = 0;
+	entity->num_backlinks = 0;
+}
+EXPORT_SYMBOL_GPL(__media_entity_remove_links);
+
+void media_entity_remove_links(struct media_entity *entity)
+{
+	/* Do nothing if the entity is not registered. */
+	if (entity->parent == NULL)
+		return;
+
+	mutex_lock(&entity->parent->graph_mutex);
+	__media_entity_remove_links(entity);
+	mutex_lock(&entity->parent->graph_mutex);
+}
+EXPORT_SYMBOL_GPL(media_entity_remove_links);
+
 static int __media_entity_setup_link_notify(struct media_link *link, u32 flags)
 {
 	int ret;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 4eefedc..06bacf9 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -128,6 +128,9 @@ void media_entity_cleanup(struct media_entity *entity);
 
 int media_entity_create_link(struct media_entity *source, u16 source_pad,
 		struct media_entity *sink, u16 sink_pad, u32 flags);
+void __media_entity_remove_links(struct media_entity *entity);
+void media_entity_remove_links(struct media_entity *entity);
+
 int __media_entity_setup_link(struct media_link *link, u32 flags);
 int media_entity_setup_link(struct media_link *link, u32 flags);
 struct media_link *media_entity_find_link(struct media_pad *source,
-- 
1.7.9.5

