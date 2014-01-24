Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56146 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaAXNH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 08:07:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, sakari.ailus@iki.fi
Subject: [PATCH/RFC 3/4] Expose default devices
Date: Fri, 24 Jan 2014 14:08:08 +0100
Message-Id: <1390568889-1508-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1390568889-1508-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1390568889-1508-1-git-send-email-laurent.pinchart@ideasonboard.com>
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
index 844acc7..bb9828d 100644
--- a/src/mediactl-priv.h
+++ b/src/mediactl-priv.h
@@ -37,6 +37,13 @@ struct media_device {
 
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
index 2ba0ab8..5e83ad1 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -116,6 +116,21 @@ struct media_entity *media_get_entities(struct media_device *media)
 	return media->entities;
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
@@ -484,6 +499,23 @@ static int media_enum_entities(struct media_device *media)
 
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
index ce5c05a..52612db 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -194,6 +194,25 @@ unsigned int media_get_entities_count(struct media_device *media);
 struct media_entity *media_get_entities(struct media_device *media);
 
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

