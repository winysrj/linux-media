Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbIFMD4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:56 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v8 39/55] [media] media controller: get rid of entity subtype on Kernel
Date: Sun,  6 Sep 2015 09:02:59 -0300
Message-Id: <728826957177ee11793b6b28b4e61e94b2d3068c.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <8154aa42b993840dfde2d794e7e9e1f0c57c1e82.1440902901.git.mchehab@osg.samsung.com>
References: <8154aa42b993840dfde2d794e7e9e1f0c57c1e82.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't use anymore the type/subtype entity data/macros
inside the Kernel.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 220864319d21..7320cdc45833 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -185,16 +185,6 @@ struct media_intf_devnode {
 	u32				minor;
 };
 
-static inline u32 media_entity_type(struct media_entity *entity)
-{
-	return entity->type & MEDIA_ENT_TYPE_MASK;
-}
-
-static inline u32 media_entity_subtype(struct media_entity *entity)
-{
-	return entity->type & MEDIA_ENT_SUBTYPE_MASK;
-}
-
 static inline u32 media_entity_id(struct media_entity *entity)
 {
 	return entity->graph_obj.id;
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 3d6210095336..f90147cb9b57 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -42,8 +42,6 @@ struct media_device_info {
 
 #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
 
-/* Used values for media_entity_desc::type */
-
 /*
  * Initial value to be used when a new entity is created
  * Drivers should change it to something useful
-- 
2.4.3


