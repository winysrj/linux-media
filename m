Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36545 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbbEHBMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 21:12:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/18] media controller: add macros to check if subdev or A/V DMA
Date: Thu,  7 May 2015 22:12:31 -0300
Message-Id: <1d5d670bfccdd34bfe507d6a9d1627490a803366.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we'll be removing entity subtypes from the Kernel, we need
to provide a way for drivers and core to check if a given
entity is represented by a V4L2 subdev or if it is an A/V
DMA.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0c003d817493..f15b48145711 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -113,6 +113,35 @@ static inline u32 media_entity_subtype(struct media_entity *entity)
 	return entity->type & MEDIA_ENT_SUBTYPE_MASK;
 }
 
+static inline bool is_media_entity_av_dma(struct media_entity *entity)
+{
+	if (!entity)
+		return false;
+
+	if (entity->type == MEDIA_ENT_T_AV_DMA)
+		return true;
+
+	return false;
+}
+
+static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
+{
+	if (!entity)
+		return false;
+
+	switch (entity->type) {
+	case MEDIA_ENT_T_CAM_SENSOR:
+	case MEDIA_ENT_T_CAM_FLASH:
+	case MEDIA_ENT_T_CAM_LENS:
+	case MEDIA_ENT_T_ATV_DECODER:
+	case MEDIA_ENT_T_TUNER:
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
2.1.0

