Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54641 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbIFMD6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 51/55] [media] remove interface links at media_entity_unregister()
Date: Sun,  6 Sep 2015 09:03:11 -0300
Message-Id: <ce03152d3a7f156ff3fe9a3ff15a8d9530e0307a.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <36ec2d60b61f769115982c5060d550d35e3ca602.1440902901.git.mchehab@osg.samsung.com>
References: <36ec2d60b61f769115982c5060d550d35e3ca602.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Interface links connected to an entity should be removed
before being able of removing the entity.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 96a476eeb16e..7c37aeab05bb 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -638,14 +638,30 @@ void media_device_unregister_entity(struct media_entity *entity)
 		return;
 
 	spin_lock(&mdev->lock);
+
+	/* Remove interface links with this entity on it */
+	list_for_each_entry_safe(link, tmp, &mdev->links, graph_obj.list) {
+		if (media_type(link->gobj1) == MEDIA_GRAPH_ENTITY
+		    && link->entity == entity) {
+			media_gobj_remove(&link->graph_obj);
+			kfree(link);
+		}
+	}
+
+	/* Remove all data links that belong to this entity */
 	list_for_each_entry_safe(link, tmp, &entity->links, list) {
 		media_gobj_remove(&link->graph_obj);
 		list_del(&link->list);
 		kfree(link);
 	}
+
+	/* Remove all pads that belong to this entity */
 	for (i = 0; i < entity->num_pads; i++)
 		media_gobj_remove(&entity->pads[i].graph_obj);
+
+	/* Remove the entity */
 	media_gobj_remove(&entity->graph_obj);
+
 	spin_unlock(&mdev->lock);
 	entity->graph_obj.mdev = NULL;
 }
-- 
2.4.3


