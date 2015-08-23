Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbbHWUSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:08 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v7 15/44] [media] media: get rid of an unused code
Date: Sun, 23 Aug 2015 17:17:32 -0300
Message-Id: <5ccb3df9166af331070f546a7d3c522d65964919.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code is not used in practice. Get rid of it before
start converting links to lists.

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
-- 
2.4.3

