Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46545 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab3EIMb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 08:31:28 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ00IH86S0DD90@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 May 2013 21:31:27 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, hj210.choi@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 1/2] media: Add function removing all media entity links
Date: Thu, 09 May 2013 14:29:32 +0200
Message-id: <1368102573-16183-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1368102573-16183-1-git-send-email-s.nawrocki@samsung.com>
References: <1368102573-16183-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function allows to remove all media entity's links to other
entities, leaving no references to a media entity's links array
at its remote entities.

Currently when a driver of some entity is removed it will free its
media entities links[] array, leaving dangling pointers at other
entities that are part of same media graph. This is troublesome when
drivers of a media device entities are in separate kernel modules,
removing only some modules will leave others in incorrect state.

This function is intended to be used when an entity is being
unregistered from a media device.

With an assumption that media links should be created only after
they are registered to a media device and with the graph mutex held.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/media-entity.c |   51 ++++++++++++++++++++++++++++++++++++++++++
 include/media/media-entity.h |    3 +++
 2 files changed, 54 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e1cd132..7c2b51c 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -429,6 +429,57 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 }
 EXPORT_SYMBOL_GPL(media_entity_create_link);
 
+void __media_entity_remove_links(struct media_entity *entity)
+{
+	int i, r;
+
+	for (i = 0; i < entity->num_links; i++) {
+		struct media_link *link = &entity->links[i];
+		struct media_entity *remote;
+		int num_links;
+
+		if (link->source->entity == entity)
+			remote = link->sink->entity;
+		else
+			remote = link->source->entity;
+
+		num_links = remote->num_links;
+
+		for (r = 0; r < num_links; r++) {
+			struct media_link *rlink = &remote->links[r];
+
+			if (rlink != link->reverse)
+				continue;
+
+			if (link->source->entity == entity)
+				remote->num_backlinks--;
+
+			remote->num_links--;
+
+			if (remote->num_links < 1)
+				break;
+
+			/* Insert last entry in place of the dropped link. */
+			remote->links[r--] = remote->links[remote->num_links];
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
+	if (WARN_ON_ONCE(entity->parent == NULL))
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
index 0c16f51..0d941d2 100644
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

