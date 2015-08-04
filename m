Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52342 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096AbbHDLlT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 07:41:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: media-workshop@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH_RFC_v1 4/4] dvbdev: Use functions to create/remove media_entity struct
Date: Tue,  4 Aug 2015 08:41:09 -0300
Message-Id: <b60643d0009ebd74710e6cfe0579e76309301026.1438687440.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438687440.git.mchehab@osg.samsung.com>
References: <cover.1438687440.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438687440.git.mchehab@osg.samsung.com>
References: <cover.1438687440.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using kalloc()/kfree(), use the new functions
media_entity_create()/media_entity_remove(), in order to
have the proper kref counts for the usage of the entity
objects at the media graph.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 13bb57f0457f..9e0704118ffc 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -189,13 +189,14 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 	if (!dvbdev->adapter->mdev)
 		return;
 
-	dvbdev->entity = kzalloc(sizeof(*dvbdev->entity), GFP_KERNEL);
+	dvbdev->entity = media_entity_create(dvbdev->adapter->mdev,
+					     dvbdev->name, 0, NULL,
+					     GFP_KERNEL);
 	if (!dvbdev->entity)
 		return;
 
 	dvbdev->entity->info.dev.major = DVB_MAJOR;
 	dvbdev->entity->info.dev.minor = minor;
-	dvbdev->entity->name = dvbdev->name;
 
 	switch (type) {
 	case DVB_DEVICE_CA:
@@ -214,7 +215,7 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 		dvbdev->pads = kcalloc(npads, sizeof(*dvbdev->pads),
 				       GFP_KERNEL);
 		if (!dvbdev->pads) {
-			kfree(dvbdev->entity);
+			media_entity_remove(dvbdev->entity);
 			return;
 		}
 	}
@@ -243,7 +244,7 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_NET;
 		break;
 	default:
-		kfree(dvbdev->entity);
+		media_entity_remove(dvbdev->entity);
 		dvbdev->entity = NULL;
 		return;
 	}
@@ -258,7 +259,7 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 			"%s: media_device_register_entity failed for %s\n",
 			__func__, dvbdev->entity->name);
 		kfree(dvbdev->pads);
-		kfree(dvbdev->entity);
+		media_entity_remove(dvbdev->entity);
 		dvbdev->entity = NULL;
 		return;
 	}
@@ -369,7 +370,7 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 	if (dvbdev->entity) {
 		media_device_unregister_entity(dvbdev->entity);
-		kfree(dvbdev->entity);
+		media_entity_remove(dvbdev->entity);
 		kfree(dvbdev->pads);
 	}
 #endif
-- 
2.4.3

