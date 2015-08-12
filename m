Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbbHLUPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 16:15:09 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v3 06/16] media: initialize the graph object inside the media links
Date: Wed, 12 Aug 2015 17:14:50 -0300
Message-Id: <7656123ff16ffb0820f997f0c30ee139ce6d2605.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a new link is created, we need to initialize the object
inside it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 56724f7853bf..9fb3f8958265 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -479,6 +479,8 @@ void media_device_unregister_entity(struct media_entity *entity)
 	graph_obj_remove(&entity->graph_obj);
 	for (i = 0; entity->num_pads; i++)
 		graph_obj_remove(&entity->pads[i].graph_obj);
+	for (i = 0; entity->num_links; i++)
+		graph_obj_remove(&entity->links[i].graph_obj);
 	list_del(&entity->list);
 	spin_unlock(&mdev->lock);
 	entity->parent = NULL;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 19ad316f2f33..6985d5c53632 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -469,6 +469,10 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
 		entity->links = links;
 	}
 
+	/* Initialize graph object embedded at the new link */
+	graph_obj_init(entity->parent, MEDIA_GRAPH_LINK,
+			&entity->links[entity->num_links].graph_obj);
+
 	return &entity->links[entity->num_links++];
 }
 
-- 
2.4.3

