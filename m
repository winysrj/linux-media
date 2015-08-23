Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbbHWUSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v7 27/44] [media] media: add macros to check if subdev or V4L2 DMA
Date: Sun, 23 Aug 2015 17:17:44 -0300
Message-Id: <a994037ed190bc31d75b0bcfbb675bfa6c538711.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we'll be removing entity subtypes from the Kernel, we need
to provide a way for drivers and core to check if a given
entity is represented by a V4L2 subdev or if it is an V4L2
I/O entity (typically with DMA).

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 35d97017dd19..952867571429 100644
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

