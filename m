Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:61074 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab1JGPfQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Oct 2011 11:35:16 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 2/7] Move link parsing from main.c to media.c, making it part of libmediactl
Date: Fri,  7 Oct 2011 18:38:03 +0300
Message-Id: <1318001888-18689-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111007153443.GC8908@valkosipuli.localdomain>
References: <20111007153443.GC8908@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes it possible to benefit from the link parsing code anywhere the
library is being used.

dprintf macro will later be replaced with proper debug support.

Also fix a case where -1 was returned on error and the user was expected to
check the value of errno. Negative error codes are now returned
consistently.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c     |  139 +---------------------------------------------
 src/mediactl.c |  167 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 src/mediactl.h |   57 +++++++++++++++++++-
 3 files changed, 212 insertions(+), 151 deletions(-)

diff --git a/src/main.c b/src/main.c
index 55a6e2d..02cdecd 100644
--- a/src/main.c
+++ b/src/main.c
@@ -335,137 +335,6 @@ void media_print_topology(struct media_device *media, int dot)
 }
 
 /* -----------------------------------------------------------------------------
- * Links setup
- */
-
-static struct media_pad *parse_pad(struct media_device *media, const char *p, char **endp)
-{
-	unsigned int entity_id, pad;
-	struct media_entity *entity;
-	char *end;
-
-	for (; isspace(*p); ++p);
-
-	if (*p == '"') {
-		for (end = (char *)p + 1; *end && *end != '"'; ++end);
-		if (*end != '"')
-			return NULL;
-
-		entity = media_get_entity_by_name(media, p + 1, end - p - 1);
-		if (entity == NULL)
-			return NULL;
-
-		++end;
-	} else {
-		entity_id = strtoul(p, &end, 10);
-		entity = media_get_entity_by_id(media, entity_id);
-		if (entity == NULL)
-			return NULL;
-	}
-	for (; isspace(*end); ++end);
-
-	if (*end != ':')
-		return NULL;
-	for (p = end + 1; isspace(*p); ++p);
-
-	pad = strtoul(p, &end, 10);
-	for (p = end; isspace(*p); ++p);
-
-	if (pad >= entity->info.pads)
-		return NULL;
-
-	for (p = end; isspace(*p); ++p);
-	if (endp)
-		*endp = (char *)p;
-
-	return &entity->pads[pad];
-}
-
-static struct media_link *parse_link(struct media_device *media, const char *p, char **endp)
-{
-	struct media_link *link;
-	struct media_pad *source;
-	struct media_pad *sink;
-	unsigned int i;
-	char *end;
-
-	source = parse_pad(media, p, &end);
-	if (source == NULL)
-		return NULL;
-
-	if (end[0] != '-' || end[1] != '>')
-		return NULL;
-	p = end + 2;
-
-	sink = parse_pad(media, p, &end);
-	if (sink == NULL)
-		return NULL;
-
-	*endp = end;
-
-	for (i = 0; i < source->entity->num_links; i++) {
-		link = &source->entity->links[i];
-
-		if (link->source == source && link->sink == sink)
-			return link;
-	}
-
-	return NULL;
-}
-
-static int setup_link(struct media_device *media, const char *p, char **endp)
-{
-	struct media_link *link;
-	__u32 flags;
-	char *end;
-
-	link = parse_link(media, p, &end);
-	if (link == NULL) {
-		printf("Unable to parse link\n");
-		return -EINVAL;
-	}
-
-	p = end;
-	if (*p++ != '[') {
-		printf("Unable to parse link flags\n");
-		return -EINVAL;
-	}
-
-	flags = strtoul(p, &end, 10);
-	for (p = end; isspace(*p); p++);
-	if (*p++ != ']') {
-		printf("Unable to parse link flags\n");
-		return -EINVAL;
-	}
-
-	for (; isspace(*p); p++);
-	*endp = (char *)p;
-
-	printf("Setting up link %u:%u -> %u:%u [%u]\n",
-		link->source->entity->info.id, link->source->index,
-		link->sink->entity->info.id, link->sink->index,
-		flags);
-
-	return media_setup_link(media, link->source, link->sink, flags);
-}
-
-static int setup_links(struct media_device *media, const char *p)
-{
-	char *end;
-	int ret;
-
-	do {
-		ret = setup_link(media, p, &end);
-		if (ret < 0)
-			return ret;
-
-		p = end + 1;
-	} while (*end == ',');
-
-	return *end ? -EINVAL : 0;
-}
-
-/* -----------------------------------------------------------------------------
  * Formats setup
  */
 
@@ -558,7 +427,7 @@ static struct media_pad *parse_pad_format(struct media_device *media,
 
 	for (; isspace(*p); ++p);
 
-	pad = parse_pad(media, p, &end);
+	pad = media_parse_pad(media, p, &end);
 	if (pad == NULL)
 		return NULL;
 
@@ -775,7 +644,7 @@ int main(int argc, char **argv)
 	if (media_opts.pad) {
 		struct media_pad *pad;
 
-		pad = parse_pad(media, media_opts.pad, NULL);
+		pad = media_parse_pad(media, media_opts.pad, NULL);
 		if (pad == NULL) {
 			printf("Pad '%s' not found\n", media_opts.pad);
 			goto out;
@@ -797,7 +666,7 @@ int main(int argc, char **argv)
 	}
 
 	if (media_opts.links)
-		setup_links(media, media_opts.links);
+		media_parse_setup_links(media, media_opts.links);
 
 	if (media_opts.formats)
 		setup_formats(media, media_opts.formats);
@@ -814,7 +683,7 @@ int main(int argc, char **argv)
 			if (buffer[0] == '\n')
 				break;
 
-			setup_link(media, buffer, &end);
+			media_parse_setup_link(media, buffer, &end);
 		}
 	}
 
diff --git a/src/mediactl.c b/src/mediactl.c
index 5c710c9..dc5b022 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -36,6 +36,12 @@
 #include "mediactl.h"
 #include "tools.h"
 
+#ifdef DEBUG
+#define dprintf(...) printf(__VA_ARGS__)
+#else
+#define dprintf(...)
+#endif
+
 struct media_pad *media_entity_remote_source(struct media_pad *pad)
 {
 	unsigned int i;
@@ -107,8 +113,8 @@ int media_setup_link(struct media_device *media,
 	}
 
 	if (i == source->entity->num_links) {
-		printf("%s: Link not found\n", __func__);
-		return -EINVAL;
+		dprintf("%s: Link not found\n", __func__);
+		return -ENOENT;
 	}
 
 	/* source pad */
@@ -124,10 +130,10 @@ int media_setup_link(struct media_device *media,
 	ulink.flags = flags | (link->flags & MEDIA_LNK_FL_IMMUTABLE);
 
 	ret = ioctl(media->fd, MEDIA_IOC_SETUP_LINK, &ulink);
-	if (ret < 0) {
-		printf("%s: Unable to setup link (%s)\n", __func__,
+	if (ret == -1) {
+		dprintf("%s: Unable to setup link (%s)\n", __func__,
 			strerror(errno));
-		return ret;
+		return -errno;
 	}
 
 	link->flags = ulink.flags;
@@ -196,7 +202,7 @@ static int media_enum_links(struct media_device *media)
 		links.links = malloc(entity->info.links * sizeof(struct media_link_desc));
 
 		if (ioctl(media->fd, MEDIA_IOC_ENUM_LINKS, &links) < 0) {
-			printf("%s: Unable to enumerate pads and links (%s).\n",
+			dprintf("%s: Unable to enumerate pads and links (%s).\n",
 				__func__, strerror(errno));
 			free(links.pads);
 			free(links.links);
@@ -220,7 +226,7 @@ static int media_enum_links(struct media_device *media)
 			sink = media_get_entity_by_id(media, link->sink.entity);
 
 			if (source == NULL || sink == NULL) {
-				printf("WARNING entity %u link %u from %u/%u to %u/%u is invalid!\n",
+				dprintf("WARNING entity %u link %u from %u/%u to %u/%u is invalid!\n",
 					id, i, link->source.entity, link->source.index,
 					link->sink.entity, link->sink.index);
 				ret = -EINVAL;
@@ -412,39 +418,40 @@ struct media_device *media_open(const char *name, int verbose)
 
 	media = calloc(1, sizeof(*media));
 	if (media == NULL) {
-		printf("%s: unable to allocate memory\n", __func__);
+		dprintf("%s: unable to allocate memory\n", __func__);
 		return NULL;
 	}
 
 	if (verbose)
-		printf("Opening media device %s\n", name);
+		dprintf("Opening media device %s\n", name);
+
 	media->fd = open(name, O_RDWR);
 	if (media->fd < 0) {
 		media_close(media);
-		printf("%s: Can't open media device %s\n", __func__, name);
+		dprintf("%s: Can't open media device %s\n", __func__, name);
 		return NULL;
 	}
 
 	if (verbose)
-		printf("Enumerating entities\n");
+		dprintf("Enumerating entities\n");
 
 	ret = media_enum_entities(media, verbose);
 
 	if (ret < 0) {
-		printf("%s: Unable to enumerate entities for device %s (%s)\n",
+		dprintf("%s: Unable to enumerate entities for device %s (%s)\n",
 			__func__, name, strerror(-ret));
 		media_close(media);
 		return NULL;
 	}
 
 	if (verbose) {
-		printf("Found %u entities\n", media->entities_count);
-		printf("Enumerating pads and links\n");
+		dprintf("Found %u entities\n", media->entities_count);
+		dprintf("Enumerating pads and links\n");
 	}
 
 	ret = media_enum_links(media);
 	if (ret < 0) {
-		printf("%s: Unable to enumerate pads and linksfor device %s\n",
+		dprintf("%s: Unable to enumerate pads and linksfor device %s\n",
 			__func__, name);
 		media_close(media);
 		return NULL;
@@ -473,3 +480,133 @@ void media_close(struct media_device *media)
 	free(media);
 }
 
+struct media_pad *media_parse_pad(struct media_device *media,
+				  const char *p, char **endp)
+{
+	unsigned int entity_id, pad;
+	struct media_entity *entity;
+	char *end;
+
+	for (; isspace(*p); ++p);
+
+	if (*p == '"') {
+		for (end = (char *)p + 1; *end && *end != '"'; ++end);
+		if (*end != '"')
+			return NULL;
+
+		entity = media_get_entity_by_name(media, p + 1, end - p - 1);
+		if (entity == NULL)
+			return NULL;
+
+		++end;
+	} else {
+		entity_id = strtoul(p, &end, 10);
+		entity = media_get_entity_by_id(media, entity_id);
+		if (entity == NULL)
+			return NULL;
+	}
+	for (; isspace(*end); ++end);
+
+	if (*end != ':')
+		return NULL;
+	for (p = end + 1; isspace(*p); ++p);
+
+	pad = strtoul(p, &end, 10);
+	for (p = end; isspace(*p); ++p);
+
+	if (pad >= entity->info.pads)
+		return NULL;
+
+	for (p = end; isspace(*p); ++p);
+	if (endp)
+		*endp = (char *)p;
+
+	return &entity->pads[pad];
+}
+
+struct media_link *media_parse_link(struct media_device *media,
+				    const char *p, char **endp)
+{
+	struct media_link *link;
+	struct media_pad *source;
+	struct media_pad *sink;
+	unsigned int i;
+	char *end;
+
+	source = media_parse_pad(media, p, &end);
+	if (source == NULL)
+		return NULL;
+
+	if (end[0] != '-' || end[1] != '>')
+		return NULL;
+	p = end + 2;
+
+	sink = media_parse_pad(media, p, &end);
+	if (sink == NULL)
+		return NULL;
+
+	*endp = end;
+
+	for (i = 0; i < source->entity->num_links; i++) {
+		link = &source->entity->links[i];
+
+		if (link->source == source && link->sink == sink)
+			return link;
+	}
+
+	return NULL;
+}
+
+int media_parse_setup_link(struct media_device *media,
+			   const char *p, char **endp)
+{
+	struct media_link *link;
+	__u32 flags;
+	char *end;
+
+	link = media_parse_link(media, p, &end);
+	if (link == NULL) {
+		dprintf("Unable to parse link\n");
+		return -EINVAL;
+	}
+
+	p = end;
+	if (*p++ != '[') {
+		dprintf("Unable to parse link flags\n");
+		return -EINVAL;
+	}
+
+	flags = strtoul(p, &end, 10);
+	for (p = end; isspace(*p); p++);
+	if (*p++ != ']') {
+		dprintf("Unable to parse link flags\n");
+		return -EINVAL;
+	}
+
+	for (; isspace(*p); p++);
+	*endp = (char *)p;
+
+	dprintf("Setting up link %u:%u -> %u:%u [%u]\n",
+		link->source->entity->info.id, link->source->index,
+		link->sink->entity->info.id, link->sink->index,
+		flags);
+
+	return media_setup_link(media, link->source, link->sink, flags);
+}
+
+int media_parse_setup_links(struct media_device *media, const char *p)
+{
+	char *end;
+	int ret;
+
+	do {
+		ret = media_parse_setup_link(media, p, &end);
+		if (ret < 0)
+			return ret;
+
+		p = end + 1;
+	} while (*end == ',');
+
+	return *end ? -EINVAL : 0;
+}
+
diff --git a/src/mediactl.h b/src/mediactl.h
index b91a2ac..5627cd7 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -140,7 +140,9 @@ struct media_entity *media_get_entity_by_id(struct media_device *media,
  *
  * Only the MEDIA_LINK_FLAG_ENABLED flag is writable.
  *
- * @return 0 on success, or a negative error code on failure.
+ * @return 0 on success, -1 on failure:
+ *	   -ENOENT: link not found
+ *	   - other error codes returned by MEDIA_IOC_SETUP_LINK
  */
 int media_setup_link(struct media_device *media,
 	struct media_pad *source, struct media_pad *sink,
@@ -157,5 +159,58 @@ int media_setup_link(struct media_device *media,
  */
 int media_reset_links(struct media_device *media);
 
+/**
+ * @brief Parse string to a pad on the media device.
+ * @param media - media device.
+ * @param p - input string
+ * @param endp - pointer to string where parsing ended
+ *
+ * Parse NULL terminated string describing a pad and return its struct
+ * media_pad instance.
+ *
+ * @return Pointer to struct media_pad on success, NULL on failure.
+ */
+struct media_pad *media_parse_pad(struct media_device *media,
+				  const char *p, char **endp);
+
+/**
+ * @brief Parse string to a link on the media device.
+ * @param media - media device.
+ * @param p - input string
+ * @param endp - pointer to p where parsing ended
+ *
+ * Parse NULL terminated string p describing a link and return its struct
+ * media_link instance.
+ *
+ * @return Pointer to struct media_link on success, NULL on failure.
+ */
+struct media_link *media_parse_link(struct media_device *media,
+				    const char *p, char **endp);
+
+/**
+ * @brief Parse string to a link on the media device and set it up.
+ * @param media - media device.
+ * @param p - input string
+ *
+ * Parse NULL terminated string p describing a link and its configuration
+ * and configure the link.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_parse_setup_link(struct media_device *media,
+			   const char *p, char **endp);
+
+/**
+ * @brief Parse string to link(s) on the media device and set it up.
+ * @param media - media device.
+ * @param p - input string
+ *
+ * Parse NULL terminated string p describing link(s) separated by
+ * commas (,) and configure the link(s).
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_parse_setup_links(struct media_device *media, const char *p);
+
 #endif
 
-- 
1.7.2.5

