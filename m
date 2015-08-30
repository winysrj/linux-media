Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48367 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbH3DHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:46 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v8 50/55] [media] media-entity: unregister entity links
Date: Sun, 30 Aug 2015 00:07:01 -0300
Message-Id: <a8a7c85fad0ca6f9661fb9dd4e30623428959b35.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add functions to explicitly unregister all entity links.
This function is called automatically when an entity
link is destroyed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c18f4af52771..96303a0ade59 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -903,6 +903,7 @@ EXPORT_SYMBOL_GPL(media_devnode_create);
 
 void media_devnode_remove(struct media_intf_devnode *devnode)
 {
+	media_remove_intf_links(&devnode->intf);
 	media_gobj_remove(&devnode->intf.graph_obj);
 	kfree(devnode);
 }
@@ -944,3 +945,25 @@ void media_remove_intf_link(struct media_link *link)
 	mutex_unlock(&link->graph_obj.mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_remove_intf_link);
+
+void __media_remove_intf_links(struct media_interface *intf)
+{
+	struct media_link *link, *tmp;
+
+	list_for_each_entry_safe(link, tmp, &intf->links, list)
+		__media_remove_intf_link(link);
+
+}
+EXPORT_SYMBOL_GPL(__media_remove_intf_links);
+
+void media_remove_intf_links(struct media_interface *intf)
+{
+	/* Do nothing if the intf is not registered. */
+	if (intf->graph_obj.mdev == NULL)
+		return;
+
+	mutex_lock(&intf->graph_obj.mdev->graph_mutex);
+	__media_remove_intf_links(intf);
+	mutex_unlock(&intf->graph_obj.mdev->graph_mutex);
+}
+EXPORT_SYMBOL_GPL(media_remove_intf_links);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 8c344a07636c..0e7e193a6736 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -318,6 +318,9 @@ struct media_link *media_create_intf_link(struct media_entity *entity,
 					    struct media_interface *intf,
 					    u32 flags);
 void media_remove_intf_link(struct media_link *link);
+void __media_remove_intf_links(struct media_interface *intf);
+void media_remove_intf_links(struct media_interface *intf);
+
 
 #define media_entity_call(entity, operation, args...)			\
 	(((entity)->ops && (entity)->ops->operation) ?			\
-- 
2.4.3

