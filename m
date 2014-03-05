Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39363 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbaCERbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 12:31:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, sakari.ailus@iki.fi
Subject: [PATCH/RFC v2 4/5] Expose default devices
Date: Wed,  5 Mar 2014 18:32:20 +0100
Message-Id: <1394040741-22503-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394040741-22503-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394040741-22503-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/mediactl-priv.h |  7 +++++++
 src/mediactl.c      | 32 ++++++++++++++++++++++++++++++++
 src/mediactl.h      | 19 +++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/src/mediactl-priv.h b/src/mediactl-priv.h
index 37e60aa..4644165 100644
--- a/src/mediactl-priv.h
+++ b/src/mediactl-priv.h
@@ -49,6 +49,13 @@ struct media_device {
 
 	void (*debug_handler)(void *, ...);
 	void *debug_priv;
+
+	struct {
+		struct media_entity *v4l;
+		struct media_entity *fb;
+		struct media_entity *alsa;
+		struct media_entity *dvb;
+	} def;
 };
 
 #define media_dbg(media, ...) \
diff --git a/src/mediactl.c b/src/mediactl.c
index a48953a..5bf76ea 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -145,6 +145,21 @@ const char *media_entity_get_devname(struct media_entity *entity)
 	return entity->devname[0] ? entity->devname : NULL;
 }
 
+struct media_entity *media_get_default_entity(struct media_device *media,
+					      unsigned int type)
+{
+	switch (type) {
+	case MEDIA_ENT_T_DEVNODE_V4L:
+		return media->def.v4l;
+	case MEDIA_ENT_T_DEVNODE_FB:
+		return media->def.fb;
+	case MEDIA_ENT_T_DEVNODE_ALSA:
+		return media->def.alsa;
+	case MEDIA_ENT_T_DEVNODE_DVB:
+		return media->def.dvb;
+	}
+}
+
 const struct media_device_info *media_get_info(struct media_device *media)
 {
 	return &media->info;
@@ -518,6 +533,23 @@ static int media_enum_entities(struct media_device *media)
 
 		media->entities_count++;
 
+		if (entity->info.flags & MEDIA_ENT_FL_DEFAULT) {
+			switch (entity->info.type) {
+			case MEDIA_ENT_T_DEVNODE_V4L:
+				media->def.v4l = entity;
+				break;
+			case MEDIA_ENT_T_DEVNODE_FB:
+				media->def.fb = entity;
+				break;
+			case MEDIA_ENT_T_DEVNODE_ALSA:
+				media->def.alsa = entity;
+				break;
+			case MEDIA_ENT_T_DEVNODE_DVB:
+				media->def.dvb = entity;
+				break;
+			}
+		}
+
 		/* Find the corresponding device name. */
 		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE &&
 		    media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV)
diff --git a/src/mediactl.h b/src/mediactl.h
index e2c93b8..b74be0b 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -244,6 +244,25 @@ unsigned int media_get_entities_count(struct media_device *media);
 struct media_entity *media_get_entity(struct media_device *media, unsigned int index);
 
 /**
+ * @brief Get the default entity for a given type
+ * @param media - media device.
+ * @param type - entity type.
+ *
+ * This function returns the default entity of the requested type. @a type must
+ * be one of
+ *
+ *	MEDIA_ENT_T_DEVNODE_V4L
+ *	MEDIA_ENT_T_DEVNODE_FB
+ *	MEDIA_ENT_T_DEVNODE_ALSA
+ *	MEDIA_ENT_T_DEVNODE_DVB
+ *
+ * @return A pointer to the default entity for the type if it exists, or NULL
+ * otherwise.
+ */
+struct media_entity *media_get_default_entity(struct media_device *media,
+					      unsigned int type);
+
+/**
  * @brief Get the media device information
  * @param media - media device.
  *
-- 
1.8.3.2

