Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:34392 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab1JGPfM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Oct 2011 11:35:12 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 6/7] Add debugging handler
Date: Fri,  7 Oct 2011 18:38:07 +0300
Message-Id: <1318001888-18689-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111007153443.GC8908@valkosipuli.localdomain>
References: <20111007153443.GC8908@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add debugging handler to media_device that may be used to redirect all debug
formatting to user-supplied function. fprintf will do, and that's what
media-ctl test program will use.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c       |    3 +-
 src/mediactl.c   |  105 +++++++++++++++++++++++++++++++++---------------------
 src/mediactl.h   |   41 +++++++++++++++++++++
 src/v4l2subdev.c |   57 ++++++++++++++++++-----------
 4 files changed, 142 insertions(+), 64 deletions(-)

diff --git a/src/main.c b/src/main.c
index 0d68ff6..40ab13e 100644
--- a/src/main.c
+++ b/src/main.c
@@ -288,7 +288,8 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 
 	/* Open the media device and enumerate entities, pads and links. */
-	media = media_open(media_opts.devname, media_opts.verbose);
+	media = media_open_debug(media_opts.devname, media_opts.verbose,
+				 (void (*)(void *, ...))fprintf, stdout);
 	if (media == NULL)
 		goto out;
 
diff --git a/src/mediactl.c b/src/mediactl.c
index 8cc338d..43d1b6a 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -36,12 +36,6 @@
 #include "mediactl.h"
 #include "tools.h"
 
-#ifdef DEBUG
-#define dprintf(...) printf(__VA_ARGS__)
-#else
-#define dprintf(...)
-#endif
-
 struct media_pad *media_entity_remote_source(struct media_pad *pad)
 {
 	unsigned int i;
@@ -113,7 +107,7 @@ int media_setup_link(struct media_device *media,
 	}
 
 	if (i == source->entity->num_links) {
-		dprintf("%s: Link not found\n", __func__);
+		media_dbg(media, "%s: Link not found\n", __func__);
 		return -ENOENT;
 	}
 
@@ -131,8 +125,8 @@ int media_setup_link(struct media_device *media,
 
 	ret = ioctl(media->fd, MEDIA_IOC_SETUP_LINK, &ulink);
 	if (ret == -1) {
-		dprintf("%s: Unable to setup link (%s)\n", __func__,
-			strerror(errno));
+		media_dbg(media, "%s: Unable to setup link (%s)\n",
+			  __func__, strerror(errno));
 		return -errno;
 	}
 
@@ -202,8 +196,9 @@ static int media_enum_links(struct media_device *media)
 		links.links = malloc(entity->info.links * sizeof(struct media_link_desc));
 
 		if (ioctl(media->fd, MEDIA_IOC_ENUM_LINKS, &links) < 0) {
-			dprintf("%s: Unable to enumerate pads and links (%s).\n",
-				__func__, strerror(errno));
+			media_dbg(media,
+				  "%s: Unable to enumerate pads and links (%s).\n",
+				  __func__, strerror(errno));
 			free(links.pads);
 			free(links.links);
 			return -errno;
@@ -226,9 +221,12 @@ static int media_enum_links(struct media_device *media)
 			sink = media_get_entity_by_id(media, link->sink.entity);
 
 			if (source == NULL || sink == NULL) {
-				dprintf("WARNING entity %u link %u from %u/%u to %u/%u is invalid!\n",
-					id, i, link->source.entity, link->source.index,
-					link->sink.entity, link->sink.index);
+				media_dbg(media,
+					  "WARNING entity %u link %u from %u/%u to %u/%u is invalid!\n",
+					  id, i, link->source.entity,
+					  link->source.index,
+					  link->sink.entity,
+					  link->sink.index);
 				ret = -EINVAL;
 			} else {
 				fwdlink = media_entity_add_link(source);
@@ -284,7 +282,8 @@ static int media_get_devname_udev(struct udev *udev,
 
 	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
 	if (verbose)
-		printf("looking up device: %u:%u\n", major(devnum), minor(devnum));
+		media_dbg(entity->media, "looking up device: %u:%u\n",
+			  major(devnum), minor(devnum));
 	device = udev_device_new_from_devnum(udev, 'c', devnum);
 	if (device) {
 		p = udev_device_get_devnode(device);
@@ -362,7 +361,7 @@ static int media_enum_entities(struct media_device *media, int verbose)
 
 	ret = media_udev_open(&udev);
 	if (ret < 0)
-		printf("%s: Can't get udev context\n", __func__);
+		media_dbg(media, "Can't get udev context\n");
 
 	for (id = 0, ret = 0; ; id = entity->info.id) {
 		size = (media->entities_count + 1) * sizeof(*media->entities);
@@ -412,48 +411,66 @@ static int media_enum_entities(struct media_device *media, int verbose)
 	return ret;
 }
 
-struct media_device *media_open(const char *name, int verbose)
+static void media_debug_default(void *ptr, ...)
+{
+}
+
+void media_debug_set_handler(struct media_device *media,
+			     void (*debug_handler)(void *, ...),
+			     void *debug_priv)
+{
+	if (debug_handler) {
+		media->debug_handler = debug_handler;
+		media->debug_priv = debug_priv;
+	} else {
+		media->debug_handler = media_debug_default;
+		media->debug_priv = NULL;
+	}
+}
+
+struct media_device *media_open_debug(
+	const char *name, int verbose, void (*debug_handler)(void *, ...),
+	void *debug_priv)
 {
 	struct media_device *media;
 	int ret;
 
 	media = calloc(1, sizeof(*media));
-	if (media == NULL) {
-		dprintf("%s: unable to allocate memory\n", __func__);
+	if (media == NULL)
 		return NULL;
-	}
 
-	if (verbose)
-		dprintf("Opening media device %s\n", name);
+	media_debug_set_handler(media, debug_handler, debug_priv);
+
+	media_dbg(media, "Opening media device %s\n", name);
 
 	media->fd = open(name, O_RDWR);
 	if (media->fd < 0) {
 		media_close(media);
-		dprintf("%s: Can't open media device %s\n", __func__, name);
+		media_dbg(media, "%s: Can't open media device %s\n",
+			  __func__, name);
 		return NULL;
 	}
 
-	if (verbose)
-		dprintf("Enumerating entities\n");
+	media_dbg(media, "Enumerating entities\n");
 
 	ret = media_enum_entities(media, verbose);
 
 	if (ret < 0) {
-		dprintf("%s: Unable to enumerate entities for device %s (%s)\n",
-			__func__, name, strerror(-ret));
+		media_dbg(media,
+			  "%s: Unable to enumerate entities for device %s (%s)\n",
+			  __func__, name, strerror(-ret));
 		media_close(media);
 		return NULL;
 	}
 
-	if (verbose) {
-		dprintf("Found %u entities\n", media->entities_count);
-		dprintf("Enumerating pads and links\n");
-	}
+	media_dbg(media, "Found %u entities\n", media->entities_count);
+	media_dbg(media, "Enumerating pads and links\n");
 
 	ret = media_enum_links(media);
 	if (ret < 0) {
-		dprintf("%s: Unable to enumerate pads and linksfor device %s\n",
-			__func__, name);
+		media_dbg(media,
+			  "%s: Unable to enumerate pads and linksfor device %s\n",
+			  __func__, name);
 		media_close(media);
 		return NULL;
 	}
@@ -461,6 +478,11 @@ struct media_device *media_open(const char *name, int verbose)
 	return media;
 }
 
+struct media_device *media_open(const char *name, int verbose)
+{
+	return media_open_debug(name, verbose, NULL, NULL);
+}
+
 void media_close(struct media_device *media)
 {
 	unsigned int i;
@@ -567,30 +589,32 @@ int media_parse_setup_link(struct media_device *media,
 
 	link = media_parse_link(media, p, &end);
 	if (link == NULL) {
-		dprintf("Unable to parse link\n");
+		media_dbg(media,
+			  "%s: Unable to parse link\n", __func__);
 		return -EINVAL;
 	}
 
 	p = end;
 	if (*p++ != '[') {
-		dprintf("Unable to parse link flags\n");
+		media_dbg(media, "Unable to parse link flags\n");
 		return -EINVAL;
 	}
 
 	flags = strtoul(p, &end, 10);
 	for (p = end; isspace(*p); p++);
 	if (*p++ != ']') {
-		dprintf("Unable to parse link flags\n");
+		media_dbg(media, "Unable to parse link flags\n");
 		return -EINVAL;
 	}
 
 	for (; isspace(*p); p++);
 	*endp = (char *)p;
 
-	dprintf("Setting up link %u:%u -> %u:%u [%u]\n",
-		link->source->entity->info.id, link->source->index,
-		link->sink->entity->info.id, link->sink->index,
-		flags);
+	media_dbg(media,
+		  "Setting up link %u:%u -> %u:%u [%u]\n",
+		  link->source->entity->info.id, link->source->index,
+		  link->sink->entity->info.id, link->sink->index,
+		  flags);
 
 	return media_setup_link(media, link->source, link->sink, flags);
 }
@@ -610,4 +634,3 @@ int media_parse_setup_links(struct media_device *media, const char *p)
 
 	return *end ? -EINVAL : 0;
 }
-
diff --git a/src/mediactl.h b/src/mediactl.h
index 98b47fd..c6bf723 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -54,9 +54,50 @@ struct media_device {
 	int fd;
 	struct media_entity *entities;
 	unsigned int entities_count;
+	void (*debug_handler)(void *, ...);
+	void *debug_priv;
 	__u32 padding[6];
 };
 
+#define media_dbg(media, ...) \
+	(media)->debug_handler((media)->debug_priv, __VA_ARGS__)
+
+/**
+ * @brief Set a handler for debug messages.
+ * @param media - device instance.
+ * @param debug_handler - debug message handler
+ * @param debug_priv - first argument to debug message handler
+ *
+ * Set a handler for debug messages that will be called whenever
+ * debugging information is to be printed. The handler expects an
+ * fprintf-like function.
+ */
+void media_debug_set_handler(
+	struct media_device *media, void (*debug_handler)(void *, ...),
+	void *debug_priv);
+
+/**
+ * @brief Open a media device with debugging enabled.
+ * @param name - name (including path) of the device node.
+ * @param verbose - whether to print verbose information on the standard output.
+ * @param debug_handler - debug message handler
+ * @param debug_priv - first argument to debug message handler
+ *
+ * Open the media device referenced by @a name and enumerate entities, pads and
+ * links.
+ *
+ * Calling media_open_debug() instead of media_open() is equivalent to
+ * media_open() and media_debug_set_handler() except that debugging is
+ * also enabled during media_open().
+ *
+ * @return A pointer to a newly allocated media_device structure instance on
+ * success and NULL on failure. The returned pointer must be freed with
+ * media_close when the device isn't needed anymore.
+ */
+struct media_device *media_open_debug(
+	const char *name, int verbose, void (*debug_handler)(void *, ...),
+	void *debug_priv);
+
 /**
  * @brief Open a media device.
  * @param name - name (including path) of the device node.
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index 80365e6..5759948 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -40,8 +40,9 @@ int v4l2_subdev_open(struct media_entity *entity)
 
 	entity->fd = open(entity->devname, O_RDWR);
 	if (entity->fd == -1) {
-		printf("%s: Failed to open subdev device node %s\n", __func__,
-			entity->devname);
+		media_dbg(entity->media,
+			  "%s: Failed to open subdev device node %s\n", __func__,
+			  entity->devname);
 		return -errno;
 	}
 
@@ -329,21 +330,25 @@ static int set_format(struct media_pad *pad,
 	if (format->width == 0 || format->height == 0)
 		return 0;
 
-	printf("Setting up format %s %ux%u on pad %s/%u\n",
-	       v4l2_subdev_pixelcode_to_string(format->code),
-	       format->width, format->height,
-	       pad->entity->info.name, pad->index);
+	media_dbg(pad->entity->media,
+		  "Setting up format %s %ux%u on pad %s/%u\n",
+		  v4l2_subdev_pixelcode_to_string(format->code),
+		  format->width, format->height,
+		  pad->entity->info.name, pad->index);
 
 	ret = v4l2_subdev_set_format(pad->entity, format, pad->index,
 				     V4L2_SUBDEV_FORMAT_ACTIVE);
 	if (ret < 0) {
-		printf("Unable to set format: %s (%d)\n", strerror(-ret), ret);
+		media_dbg(pad->entity->media,
+			  "Unable to set format: %s (%d)\n",
+			  strerror(-ret), ret);
 		return ret;
 	}
 
-	printf("Format set: %s %ux%u\n",
-	       v4l2_subdev_pixelcode_to_string(format->code),
-	       format->width, format->height);
+	media_dbg(pad->entity->media,
+		  "Format set: %s %ux%u\n",
+		  v4l2_subdev_pixelcode_to_string(format->code),
+		  format->width, format->height);
 
 	return 0;
 }
@@ -355,19 +360,23 @@ static int set_crop(struct media_pad *pad, struct v4l2_rect *crop)
 	if (crop->left == -1 || crop->top == -1)
 		return 0;
 
-	printf("Setting up crop rectangle (%u,%u)/%ux%u on pad %s/%u\n",
-		crop->left, crop->top, crop->width, crop->height,
-		pad->entity->info.name, pad->index);
+	media_dbg(pad->entity->media,
+		  "Setting up crop rectangle (%u,%u)/%ux%u on pad %s/%u\n",
+		  crop->left, crop->top, crop->width, crop->height,
+		  pad->entity->info.name, pad->index);
 
 	ret = v4l2_subdev_set_crop(pad->entity, crop, pad->index,
 				   V4L2_SUBDEV_FORMAT_ACTIVE);
 	if (ret < 0) {
-		printf("Unable to set crop rectangle: %s (%d)\n", strerror(-ret), ret);
+		media_dbg(pad->entity->media,
+			  "Unable to set crop rectangle: %s (%d)\n",
+			  strerror(-ret), ret);
 		return ret;
 	}
 
-	printf("Crop rectangle set: (%u,%u)/%ux%u\n",
-		crop->left, crop->top, crop->width, crop->height);
+	media_dbg(pad->entity->media,
+		  "Crop rectangle set: (%u,%u)/%ux%u\n",
+		  crop->left, crop->top, crop->width, crop->height);
 
 	return 0;
 }
@@ -380,17 +389,21 @@ static int set_frame_interval(struct media_entity *entity,
 	if (interval->numerator == 0)
 		return 0;
 
-	printf("Setting up frame interval %u/%u on entity %s\n",
-		interval->numerator, interval->denominator, entity->info.name);
+	media_dbg(entity->media,
+		  "Setting up frame interval %u/%u on entity %s\n",
+		  interval->numerator, interval->denominator,
+		  entity->info.name);
 
 	ret = v4l2_subdev_set_frame_interval(entity, interval);
 	if (ret < 0) {
-		printf("Unable to set frame interval: %s (%d)", strerror(-ret), ret);
+		media_dbg(entity->media,
+			  "Unable to set frame interval: %s (%d)",
+			  strerror(-ret), ret);
 		return ret;
 	}
 
-	printf("Frame interval set: %u/%u\n",
-		interval->numerator, interval->denominator);
+	media_dbg(entity->media, "Frame interval set: %u/%u\n",
+		  interval->numerator, interval->denominator);
 
 	return 0;
 }
@@ -410,7 +423,7 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
 	pad = v4l2_subdev_parse_pad_format(media, &format, &crop, &interval,
 					   p, &end);
 	if (pad == NULL) {
-		printf("Unable to parse format\n");
+		media_dbg(media, "Unable to parse format\n");
 		return -EINVAL;
 	}
 
-- 
1.7.2.5

