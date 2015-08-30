Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbbH3DHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v8 16/55] [media] media: Don't accept early-created links
Date: Sun, 30 Aug 2015 00:06:27 -0300
Message-Id: <31329e1be748d26ce5a90fe050ba15b8d1e5aff1.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Links are graph objects that represent the links of two already
existing objects in the graph.

While with the current implementation, it is possible to create
the links earlier, It doesn't make any sense to allow linking
two objects when they are not both created.

So, remove the code that would be handling those early-created
links and add a BUG_ON() to ensure that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 138b18416460..0d85c6c28004 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -443,13 +443,6 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
 	list_add_tail(&entity->list, &mdev->entities);
 
-	/*
-	 * Initialize objects at the links
-	 * in the case where links got created before entity register
-	 */
-	for (i = 0; i < entity->num_links; i++)
-		media_gobj_init(mdev, MEDIA_GRAPH_LINK,
-				&entity->links[i].graph_obj);
 	/* Initialize objects at the pads */
 	for (i = 0; i < entity->num_pads; i++)
 		media_gobj_init(mdev, MEDIA_GRAPH_PAD,
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 01946baa32d5..9f8e0145db7a 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -161,6 +161,8 @@ void media_gobj_init(struct media_device *mdev,
 			   enum media_gobj_type type,
 			   struct media_gobj *gobj)
 {
+	BUG_ON(!mdev);
+
 	gobj->mdev = mdev;
 
 	/* Create a per-type unique object ID */
-- 
2.4.3

