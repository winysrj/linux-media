Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53820 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbbIFRbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 09/18] [media] media-entity: enforce check of interface and links creation
Date: Sun,  6 Sep 2015 14:30:52 -0300
Message-Id: <e434a5b64b652589c99f421f6b18ea7ff445158c.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers should check if interfaces and interface links were
created. Add a must_check for them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 3d389f142a1d..62f882d872b1 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -370,14 +370,16 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 					     struct media_pipeline *pipe);
 void media_entity_pipeline_stop(struct media_entity *entity);
 
-struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
-						u32 type, u32 flags,
-						u32 major, u32 minor,
-						gfp_t gfp_flags);
+struct media_intf_devnode *
+__must_check media_devnode_create(struct media_device *mdev,
+				  u32 type, u32 flags,
+				  u32 major, u32 minor,
+				  gfp_t gfp_flags);
 void media_devnode_remove(struct media_intf_devnode *devnode);
-struct media_link *media_create_intf_link(struct media_entity *entity,
-					    struct media_interface *intf,
-					    u32 flags);
+struct media_link *
+__must_check media_create_intf_link(struct media_entity *entity,
+				    struct media_interface *intf,
+				    u32 flags);
 void media_remove_intf_link(struct media_link *link);
 void __media_remove_intf_links(struct media_interface *intf);
 void media_remove_intf_links(struct media_interface *intf);
-- 
2.4.3


