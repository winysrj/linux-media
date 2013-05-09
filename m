Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14386 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3EIMyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 08:54:20 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ00D3A7UFRF00@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 May 2013 13:54:17 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC 1/3] media: added managed media entity initialization
Date: Thu, 09 May 2013 14:52:42 +0200
Message-id: <1368103965-15232-2-git-send-email-a.hajda@samsung.com>
In-reply-to: <1368103965-15232-1-git-send-email-a.hajda@samsung.com>
References: <1368103965-15232-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds managed versions of initialization
and cleanup functions for media entity.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/media-entity.c |   70 ++++++++++++++++++++++++++++++++++++++++++
 include/media/media-entity.h |    4 +++
 2 files changed, 74 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e1cd132..696de35 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -82,9 +82,79 @@ void
 media_entity_cleanup(struct media_entity *entity)
 {
 	kfree(entity->links);
+	entity->links = NULL;
 }
 EXPORT_SYMBOL_GPL(media_entity_cleanup);
 
+static void devm_media_entity_release(struct device *dev, void *res)
+{
+	struct media_entity **entity = res;
+
+	media_entity_cleanup(*entity);
+}
+
+/**
+ * devm_media_entity_init - managed media entity initialization
+ *
+ * @dev: Device for which @entity belongs to.
+ * @entity: Entity to be initialized.
+ * @num_pads: Total number of sink and source pads.
+ * @pads: Array of 'num_pads' pads.
+ * @extra_links: Initial estimate of the number of extra links.
+ *
+ * This is a managed version of media_entity_init. Entity initialized with
+ * this function will be automatically cleaned up on driver detach.
+ *
+ * If an entity initialized with this function needs to be cleaned up
+ * separately, devm_media_entity_cleanup() must be used.
+ */
+int
+devm_media_entity_init(struct device *dev, struct media_entity *entity,
+		       u16 num_pads, struct media_pad *pads, u16 extra_links)
+{
+	struct media_entity **dr;
+	int rc;
+
+	dr = devres_alloc(devm_media_entity_release, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	rc = media_entity_init(entity, num_pads, pads, extra_links);
+	if (rc) {
+		devres_free(dr);
+		return rc;
+	}
+
+	*dr = entity;
+	devres_add(dev, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_media_entity_init);
+
+static int devm_media_entity_match(struct device *dev, void *res, void *data)
+{
+	struct media_entity **this = res, **entity = data;
+
+	return *this == *entity;
+}
+
+/**
+ * devm_media_entity_cleanup - managed media entity cleanup
+ *
+ * @dev: Device for which @entity belongs to.
+ * @entity: Entity to be cleaned up.
+ *
+ * This function should be used to manual cleanup of an media entity
+ * initialized with devm_media_entity_init().
+ */
+void devm_media_entity_cleanup(struct device *dev, struct media_entity *entity)
+{
+	WARN_ON(devres_release(dev, devm_media_entity_release,
+			       devm_media_entity_match, &entity));
+}
+EXPORT_SYMBOL_GPL(devm_media_entity_cleanup);
+
 /* -----------------------------------------------------------------------------
  * Graph traversal
  */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0c16f51..af732ca 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -126,6 +126,10 @@ int media_entity_init(struct media_entity *entity, u16 num_pads,
 		struct media_pad *pads, u16 extra_links);
 void media_entity_cleanup(struct media_entity *entity);
 
+int devm_media_entity_init(struct device *dev, struct media_entity *entity,
+		u16 num_pads, struct media_pad *pads, u16 extra_links);
+void devm_media_entity_cleanup(struct device *dev, struct media_entity *entity);
+
 int media_entity_create_link(struct media_entity *source, u16 source_pad,
 		struct media_entity *sink, u16 sink_pad, u32 flags);
 int __media_entity_setup_link(struct media_link *link, u32 flags);
-- 
1.7.10.4

