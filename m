Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9509 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbcEXU7y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 16:59:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org
Subject: [v4l-utils PATCH v1.1 2/2] mediactl: Separate entity and pad parsing
Date: Tue, 24 May 2016 23:56:33 +0300
Message-Id: <1464123393-14336-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <3496464.NH5W0U7aUq@avalon>
References: <3496464.NH5W0U7aUq@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes it's useful to be able to parse the entity independent of the pad.
Separate entity parsing into media_parse_entity().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/libmediactl.c | 29 +++++++++++++++++++++++++----
 utils/media-ctl/mediactl.h    | 14 ++++++++++++++
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 78caa7c..498dfd1 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -781,10 +781,10 @@ int media_device_add_entity(struct media_device *media,
 	return 0;
 }
 
-struct media_pad *media_parse_pad(struct media_device *media,
-				  const char *p, char **endp)
+struct media_entity *media_parse_entity(struct media_device *media,
+					const char *p, char **endp)
 {
-	unsigned int entity_id, pad;
+	unsigned int entity_id;
 	struct media_entity *entity;
 	char *end;
 
@@ -827,7 +827,28 @@ struct media_pad *media_parse_pad(struct media_device *media,
 			return NULL;
 		}
 	}
-	for (; isspace(*end); ++end);
+	for (p = end; isspace(*p); ++p);
+
+	*endp = (char *)p;
+
+	return entity;
+}
+
+struct media_pad *media_parse_pad(struct media_device *media,
+				  const char *p, char **endp)
+{
+	unsigned int pad;
+	struct media_entity *entity;
+	char *end;
+
+	if (endp == NULL)
+		endp = &end;
+
+	entity = media_parse_entity(media, p, &end);
+	if (!entity) {
+		*endp = end;
+		return NULL;
+	}
 
 	if (*end != ':') {
 		media_dbg(media, "Expected ':'\n", *end);
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index b5a92f5..af36051 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -367,6 +367,20 @@ int media_setup_link(struct media_device *media,
 int media_reset_links(struct media_device *media);
 
 /**
+ * @brief Parse string to an entity on the media device.
+ * @param media - media device.
+ * @param p - input string
+ * @param endp - pointer to string where parsing ended
+ *
+ * Parse NULL terminated string describing an entity and return its
+ * struct media_entity instance.
+ *
+ * @return Pointer to struct media_entity on success, NULL on failure.
+ */
+struct media_entity *media_parse_entity(struct media_device *media,
+					const char *p, char **endp);
+
+/**
  * @brief Parse string to a pad on the media device.
  * @param media - media device.
  * @param p - input string
-- 
1.9.1

