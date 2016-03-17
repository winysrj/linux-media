Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:27995 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030849AbcCQPRB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 11:17:01 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 1/1] libmediactl: Drop length argument from
Date: Thu, 17 Mar 2016 17:14:32 +0200
Message-Id: <1458227672-21232-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recently it was decided that the API dealing with string operations would
be better to just receive a nul-terminated string rather than a string the
length of which is defined. This change was implemented for
v4l2_subdev_string_to_pixelcode() and v4l2_subdev_string_to_field()
functions by patch "v4l: libv4l2subdev: Drop length argument from string
conversion functions" (commit id
341f4343e6190a7ceb546f7c74fa67e1cc9ae79f).

Do the same change for media_get_entity_by_name() in libmediactl. No other
functions using length argument for strings remain in libmediactl.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/libmediactl.c | 19 +++++++++----------
 utils/media-ctl/media-ctl.c   |  3 +--
 utils/media-ctl/mediactl.h    |  3 +--
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 4a82d24..66cdccd 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -66,21 +66,14 @@ struct media_pad *media_entity_remote_source(struct media_pad *pad)
 }
 
 struct media_entity *media_get_entity_by_name(struct media_device *media,
-					      const char *name, size_t length)
+					      const char *name)
 {
 	unsigned int i;
 
-	/* A match is impossible if the entity name is longer than the maximum
-	 * size we can get from the kernel.
-	 */
-	if (length >= FIELD_SIZEOF(struct media_entity_desc, name))
-		return NULL;
-
 	for (i = 0; i < media->entities_count; ++i) {
 		struct media_entity *entity = &media->entities[i];
 
-		if (strncmp(entity->info.name, name, length) == 0 &&
-		    entity->info.name[length] == '\0')
+		if (strcmp(entity->info.name, name) == 0)
 			return entity;
 	}
 
@@ -801,6 +794,8 @@ struct media_pad *media_parse_pad(struct media_device *media,
 	for (; isspace(*p); ++p);
 
 	if (*p == '"' || *p == '\'') {
+		char *name;
+
 		for (end = (char *)p + 1; *end && *end != '"' && *end != '\''; ++end);
 		if (*end != '"' && *end != '\'') {
 			media_dbg(media, "missing matching '\"'\n");
@@ -808,7 +803,11 @@ struct media_pad *media_parse_pad(struct media_device *media,
 			return NULL;
 		}
 
-		entity = media_get_entity_by_name(media, p + 1, end - p - 1);
+		name = strndup(p + 1, end - p - 1);
+		if (!name)
+			return NULL;
+		entity = media_get_entity_by_name(media, name);
+		free(name);
 		if (entity == NULL) {
 			media_dbg(media, "no such entity \"%.*s\"\n", end - p - 1, p + 1);
 			*endp = (char *)p + 1;
diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
index 3002fb7..d20bd1e 100644
--- a/utils/media-ctl/media-ctl.c
+++ b/utils/media-ctl/media-ctl.c
@@ -555,8 +555,7 @@ int main(int argc, char **argv)
 	if (media_opts.entity) {
 		struct media_entity *entity;
 
-		entity = media_get_entity_by_name(media, media_opts.entity,
-						  strlen(media_opts.entity));
+		entity = media_get_entity_by_name(media, media_opts.entity);
 		if (entity == NULL) {
 			printf("Entity '%s' not found\n", media_opts.entity);
 			goto out;
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index 77ac182..b5a92f5 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -245,14 +245,13 @@ static inline unsigned int media_entity_type(struct media_entity *entity)
  * @brief Find an entity by its name.
  * @param media - media device.
  * @param name - entity name.
- * @param length - size of @a name.
  *
  * Search for an entity with a name equal to @a name.
  *
  * @return A pointer to the entity if found, or NULL otherwise.
  */
 struct media_entity *media_get_entity_by_name(struct media_device *media,
-	const char *name, size_t length);
+	const char *name);
 
 /**
  * @brief Find an entity by its ID.
-- 
2.1.0.231.g7484e3b

