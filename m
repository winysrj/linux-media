Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbbHLUPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 16:15:09 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v3 05/16] media: initialize PAD objects
Date: Wed, 12 Aug 2015 17:14:49 -0300
Message-Id: <a15077ffbaf8b388298d835dd8a674b4554875d4.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PAD embedded objects also need to be initialized. Those are
currently created via media_entity_init() and, once created,
never change.

While this will likely change in the future, for now we can
just initialize those objects once, when registering the
entity.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 960a4e30c68d..56724f7853bf 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -430,6 +430,8 @@ EXPORT_SYMBOL_GPL(media_device_unregister);
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity)
 {
+	int i;
+
 	/* Warn if we apparently re-register an entity */
 	WARN_ON(entity->parent != NULL);
 	entity->parent = mdev;
@@ -438,6 +440,11 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	/* Initialize media_graph_obj embedded at the entity */
 	graph_obj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
 
+	/* Initialize objects at the pads */
+	for (i = 0; entity->num_pads; i++)
+		graph_obj_init(mdev, MEDIA_GRAPH_PAD,
+			       &entity->pads[i].graph_obj);
+
 	/*
 	 * FIXME: should it use the unique object ID or would it
 	 * break support on the legacy MC API?
@@ -462,6 +469,7 @@ EXPORT_SYMBOL_GPL(media_device_register_entity);
  */
 void media_device_unregister_entity(struct media_entity *entity)
 {
+	int i;
 	struct media_device *mdev = entity->parent;
 
 	if (mdev == NULL)
@@ -469,6 +477,8 @@ void media_device_unregister_entity(struct media_entity *entity)
 
 	spin_lock(&mdev->lock);
 	graph_obj_remove(&entity->graph_obj);
+	for (i = 0; entity->num_pads; i++)
+		graph_obj_remove(&entity->pads[i].graph_obj);
 	list_del(&entity->list);
 	spin_unlock(&mdev->lock);
 	entity->parent = NULL;
-- 
2.4.3

