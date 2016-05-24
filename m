Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:37054 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbcEXMvX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 08:51:23 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 3C97C2056C
	for <linux-media@vger.kernel.org>; Tue, 24 May 2016 15:51:21 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [v4l-utils PATCH 2/2] mediactl: Separate entity and pad parsing
Date: Tue, 24 May 2016 15:48:03 +0300
Message-Id: <1464094083-3637-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464094083-3637-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464094083-3637-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 78caa7c..14b17e6 100644
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
 
@@ -827,7 +827,27 @@ struct media_pad *media_parse_pad(struct media_device *media,
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

