Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:40304 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaKFKMG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 05:12:06 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEM00G404BYWSC0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Nov 2014 19:11:58 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	sakari.ailus@linux.intel.com, kyungmin.park@samsung.com
Subject: [v4l-utils RFC v3 02/11] mediactl: Separate entity and pad parsing
Date: Thu, 06 Nov 2014 11:11:33 +0100
Message-id: <1415268702-23685-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
References: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Sometimes it's useful to be able to parse the entity independent of the pad.
Separate entity parsing into media_parse_entity().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/libmediactl.c |   28 ++++++++++++++++++++++++----
 utils/media-ctl/mediactl.h    |   14 ++++++++++++++
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 795aaad..b549a90 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -779,10 +779,10 @@ int media_device_add_entity(struct media_device *media,
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
 
@@ -819,7 +819,27 @@ struct media_pad *media_parse_pad(struct media_device *media,
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
index e358242..5246978 100644
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
1.7.9.5

