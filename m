Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbbHLUPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 16:15:09 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v3 04/16] media: ensure that entities will have an object ID
Date: Wed, 12 Aug 2015 17:14:48 -0300
Message-Id: <c65da4024cbf92a2a87be387b86a456688ed7380.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All objects need an object ID. However, as v4l2 subdevs embeed
entities internally, the code needs to manually check if the
entity objects were not properly initialized and do it at
entity register time.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e627b0b905ad..960a4e30c68d 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -435,6 +435,13 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	entity->parent = mdev;
 
 	spin_lock(&mdev->lock);
+	/* Initialize media_graph_obj embedded at the entity */
+	graph_obj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
+
+	/*
+	 * FIXME: should it use the unique object ID or would it
+	 * break support on the legacy MC API?
+	 */
 	if (entity->id == 0)
 		entity->id = mdev->entity_id++;
 	else
@@ -461,6 +468,7 @@ void media_device_unregister_entity(struct media_entity *entity)
 		return;
 
 	spin_lock(&mdev->lock);
+	graph_obj_remove(&entity->graph_obj);
 	list_del(&entity->list);
 	spin_unlock(&mdev->lock);
 	entity->parent = NULL;
-- 
2.4.3

