Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54635 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbIFMD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 31/55] [media] media: add macros to check if subdev or V4L2 DMA
Date: Sun,  6 Sep 2015 09:02:57 -0300
Message-Id: <a811ed07aab2bf1410ffe4c438fcbd4149581290.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <eeff62ccee9a5f9ad0c92e6da2953900ad7f7c03.1440902901.git.mchehab@osg.samsung.com>
References: <eeff62ccee9a5f9ad0c92e6da2953900ad7f7c03.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we'll be removing entity subtypes from the Kernel, we need
to provide a way for drivers and core to check if a given
entity is represented by a V4L2 subdev or if it is an V4L2
I/O entity (typically with DMA).

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 4e36b1f2b2d7..220864319d21 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -220,6 +220,39 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u32 local_id)
 	return id;
 }
 
+static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
+{
+	if (!entity)
+		return false;
+
+	switch (entity->type) {
+	case MEDIA_ENT_T_V4L2_VIDEO:
+	case MEDIA_ENT_T_V4L2_VBI:
+	case MEDIA_ENT_T_V4L2_SWRADIO:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
+{
+	if (!entity)
+		return false;
+
+	switch (entity->type) {
+	case MEDIA_ENT_T_V4L2_SUBDEV_SENSOR:
+	case MEDIA_ENT_T_V4L2_SUBDEV_FLASH:
+	case MEDIA_ENT_T_V4L2_SUBDEV_LENS:
+	case MEDIA_ENT_T_V4L2_SUBDEV_DECODER:
+	case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
+		return true;
+
+	default:
+		return false;
+	}
+}
+
 #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
 #define MEDIA_ENTITY_ENUM_MAX_ID	64
 
-- 
2.4.3


