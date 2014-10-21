Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbaJUKl2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 06:41:28 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: j.anaszewski@samsung.com
Subject: [v4l-utils RFC 1/2] mediactl: Separate entity and pad parsing
Date: Tue, 21 Oct 2014 13:40:14 +0300
Message-Id: <1413888015-26649-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1413888015-26649-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1413888015-26649-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes it's useful to be able to parse the entity independent of the pad.
Separate entity parsing into media_parse_entity().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/libmediactl.c | 28 ++++++++++++++++++++++++----
 utils/media-ctl/mediactl.h    | 14 ++++++++++++++
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index ec360bd..e17d86e 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -770,10 +770,10 @@ int media_device_add_entity(struct media_device *media,
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
 
@@ -810,7 +810,27 @@ struct media_pad *media_parse_pad(struct media_device *media,
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
+	if (!entity)
+		return NULL;
+	*endp = end;
 
 	if (*end != ':') {
 		media_dbg(media, "Expected ':'\n", *end);
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index 77ac182..3faee71 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -368,6 +368,20 @@ int media_setup_link(struct media_device *media,
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
2.1.0.231.g7484e3b

