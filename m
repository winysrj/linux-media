Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbbIFMD6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 50/55] [media] media-entity: unregister entity links
Date: Sun,  6 Sep 2015 09:03:10 -0300
Message-Id: <43cafe9354b359f2827ff37d574681b94fe1e2cb.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <a8a7c85fad0ca6f9661fb9dd4e30623428959b35.1440902901.git.mchehab@osg.samsung.com>
References: <a8a7c85fad0ca6f9661fb9dd4e30623428959b35.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add functions to explicitly unregister all entity links.
This function is called automatically when an entity
link is destroyed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 064515f2ba9b..a37ccd2edfd5 100644
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
index bc7eb6240795..ca4a4f23362f 100644
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


