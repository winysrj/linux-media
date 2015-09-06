Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbbIFMDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 24/55] [media] media-entity: add a helper function to create interface
Date: Sun,  6 Sep 2015 09:02:53 -0300
Message-Id: <f1b8a889741ebc6ae26088584b4f4884ad523767.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <c3fa23e94c4530c0130f6f763c59c1bee4c49c37.1440902901.git.mchehab@osg.samsung.com>
References: <c3fa23e94c4530c0130f6f763c59c1bee4c49c37.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we'll be adding other interface types in the future, put the
common interface create code on a separate function.

Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 8e17272936c9..74aaa5a5d5bc 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -851,6 +851,18 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad)
 EXPORT_SYMBOL_GPL(media_entity_remote_pad);
 
 
+static void media_interface_init(struct media_device *mdev,
+				 struct media_interface *intf,
+				 u32 gobj_type,
+				 u32 intf_type, u32 flags)
+{
+	intf->type = intf_type;
+	intf->flags = flags;
+	INIT_LIST_HEAD(&intf->links);
+
+	media_gobj_init(mdev, gobj_type, &intf->graph_obj);
+}
+
 /* Functions related to the media interface via device nodes */
 
 struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
@@ -859,23 +871,16 @@ struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
 						gfp_t gfp_flags)
 {
 	struct media_intf_devnode *devnode;
-	struct media_interface *intf;
 
 	devnode = kzalloc(sizeof(*devnode), gfp_flags);
 	if (!devnode)
 		return NULL;
 
-	intf = &devnode->intf;
-
-	intf->type = type;
-	intf->flags = flags;
-	INIT_LIST_HEAD(&intf->links);
-
 	devnode->major = major;
 	devnode->minor = minor;
 
-	media_gobj_init(mdev, MEDIA_GRAPH_INTF_DEVNODE,
-		       &devnode->intf.graph_obj);
+	media_interface_init(mdev, &devnode->intf, MEDIA_GRAPH_INTF_DEVNODE,
+			     type, flags);
 
 	return devnode;
 }
-- 
2.4.3


