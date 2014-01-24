Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56143 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaAXNHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 08:07:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, sakari.ailus@iki.fi
Subject: [PATCH/RFC 1/4] Split media_device creation and opening
Date: Fri, 24 Jan 2014 14:08:06 +0100
Message-Id: <1390568889-1508-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1390568889-1508-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1390568889-1508-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the media_device refcounted to manage its life time.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 src/main.c     |  21 ++++---
 src/mediactl.c | 172 ++++++++++++++++++++++++++++++++++++++++-----------------
 src/mediactl.h |  84 +++++++++++++++-------------
 3 files changed, 180 insertions(+), 97 deletions(-)

diff --git a/src/main.c b/src/main.c
index 4a27c8c..8b48fde 100644
--- a/src/main.c
+++ b/src/main.c
@@ -329,15 +329,20 @@ int main(int argc, char **argv)
 	if (parse_cmdline(argc, argv))
 		return EXIT_FAILURE;
 
-	/* Open the media device and enumerate entities, pads and links. */
+	media = media_device_new(media_opts.devname);
+	if (media == NULL) {
+		printf("Failed to create media device\n");
+		goto out;
+	}
+
 	if (media_opts.verbose)
-		media = media_open_debug(
-			media_opts.devname,
+		media_debug_set_handler(media,
 			(void (*)(void *, ...))fprintf, stdout);
-	else
-		media = media_open(media_opts.devname);
-	if (media == NULL) {
-		printf("Failed to open %s\n", media_opts.devname);
+
+	/* Enumerate entities, pads and links. */
+	ret = media_device_enumerate(media);
+	if (ret < 0) {
+		printf("Failed to enumerate %s (%d)\n", media_opts.devname, ret);
 		goto out;
 	}
 
@@ -446,7 +451,7 @@ int main(int argc, char **argv)
 
 out:
 	if (media)
-		media_close(media);
+		media_device_unref(media);
 
 	return ret ? EXIT_FAILURE : EXIT_SUCCESS;
 }
diff --git a/src/mediactl.c b/src/mediactl.c
index 57cf86b..c71d4e1 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -101,6 +101,42 @@ struct media_entity *media_get_entity_by_id(struct media_device *media,
 	return NULL;
 }
 
+/* -----------------------------------------------------------------------------
+ * Open/close
+ */
+
+static int media_device_open(struct media_device *media)
+{
+	int ret;
+
+	if (media->fd != -1)
+		return 0;
+
+	media_dbg(media, "Opening media device %s\n", media->devnode);
+
+	media->fd = open(media->devnode, O_RDWR);
+	if (media->fd < 0) {
+		ret = -errno;
+		media_dbg(media, "%s: Can't open media device %s\n",
+			  __func__, media->devnode);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void media_device_close(struct media_device *media)
+{
+	if (media->fd != -1) {
+		close(media->fd);
+		media->fd = -1;
+	}
+}
+
+/* -----------------------------------------------------------------------------
+ * Link setup
+ */
+
 int media_setup_link(struct media_device *media,
 		     struct media_pad *source,
 		     struct media_pad *sink,
@@ -111,6 +147,10 @@ int media_setup_link(struct media_device *media,
 	unsigned int i;
 	int ret;
 
+	ret = media_device_open(media);
+	if (ret < 0)
+		goto done;
+
 	for (i = 0; i < source->entity->num_links; i++) {
 		link = &source->entity->links[i];
 
@@ -123,7 +163,8 @@ int media_setup_link(struct media_device *media,
 
 	if (i == source->entity->num_links) {
 		media_dbg(media, "%s: Link not found\n", __func__);
-		return -ENOENT;
+		ret = -ENOENT;
+		goto done;
 	}
 
 	/* source pad */
@@ -142,12 +183,18 @@ int media_setup_link(struct media_device *media,
 	if (ret == -1) {
 		media_dbg(media, "%s: Unable to setup link (%s)\n",
 			  __func__, strerror(errno));
-		return -errno;
+		ret = -errno;
+		goto done;
 	}
 
 	link->flags = ulink.flags;
 	link->twin->flags = ulink.flags;
-	return 0;
+
+	ret = 0;
+
+done:
+	media_device_close(media);
+	return ret;
 }
 
 int media_reset_links(struct media_device *media)
@@ -425,6 +472,58 @@ static int media_enum_entities(struct media_device *media)
 	return ret;
 }
 
+int media_device_enumerate(struct media_device *media)
+{
+	int ret;
+
+	if (media->entities)
+		return 0;
+
+	ret = media_device_open(media);
+	if (ret < 0)
+		return ret;
+
+	ret = ioctl(media->fd, MEDIA_IOC_DEVICE_INFO, &media->info);
+	if (ret < 0) {
+		media_dbg(media, "%s: Unable to retrieve media device "
+			  "information for device %s (%s)\n", __func__,
+			  media->devnode, strerror(errno));
+		ret = -errno;
+		goto done;
+	}
+
+	media_dbg(media, "Enumerating entities\n");
+
+	ret = media_enum_entities(media);
+	if (ret < 0) {
+		media_dbg(media,
+			  "%s: Unable to enumerate entities for device %s (%s)\n",
+			  __func__, media->devnode, strerror(-ret));
+		goto done;
+	}
+
+	media_dbg(media, "Found %u entities\n", media->entities_count);
+	media_dbg(media, "Enumerating pads and links\n");
+
+	ret = media_enum_links(media);
+	if (ret < 0) {
+		media_dbg(media,
+			  "%s: Unable to enumerate pads and linksfor device %s\n",
+			  __func__, media->devnode);
+		goto done;
+	}
+
+	ret = 0;
+
+done:
+	media_device_close(media);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * Create/destroy
+ */
+
 static void media_debug_default(void *ptr, ...)
 {
 }
@@ -442,9 +541,7 @@ void media_debug_set_handler(struct media_device *media,
 	}
 }
 
-struct media_device *media_open_debug(
-	const char *name, void (*debug_handler)(void *, ...),
-	void *debug_priv)
+struct media_device *media_device_new(const char *devnode)
 {
 	struct media_device *media;
 	int ret;
@@ -453,65 +550,33 @@ struct media_device *media_open_debug(
 	if (media == NULL)
 		return NULL;
 
-	media_debug_set_handler(media, debug_handler, debug_priv);
-
-	media_dbg(media, "Opening media device %s\n", name);
+	media->fd = -1;
+	media->refcount = 1;
 
-	media->fd = open(name, O_RDWR);
-	if (media->fd < 0) {
-		media_close(media);
-		media_dbg(media, "%s: Can't open media device %s\n",
-			  __func__, name);
-		return NULL;
-	}
+	media_debug_set_handler(media, NULL, NULL);
 
-	ret = ioctl(media->fd, MEDIA_IOC_DEVICE_INFO, &media->info);
-	if (ret < 0) {
-		media_dbg(media, "%s: Unable to retrieve media device "
-			  "information for device %s (%s)\n", __func__,
-			  name, strerror(errno));
-		media_close(media);
-		return NULL;
-	}
-
-	media_dbg(media, "Enumerating entities\n");
-
-	ret = media_enum_entities(media);
-
-	if (ret < 0) {
-		media_dbg(media,
-			  "%s: Unable to enumerate entities for device %s (%s)\n",
-			  __func__, name, strerror(-ret));
-		media_close(media);
-		return NULL;
-	}
-
-	media_dbg(media, "Found %u entities\n", media->entities_count);
-	media_dbg(media, "Enumerating pads and links\n");
-
-	ret = media_enum_links(media);
-	if (ret < 0) {
-		media_dbg(media,
-			  "%s: Unable to enumerate pads and linksfor device %s\n",
-			  __func__, name);
-		media_close(media);
+	media->devnode = strdup(devnode);
+	if (media->devnode == NULL) {
+		media_device_unref(media);
 		return NULL;
 	}
 
 	return media;
 }
 
-struct media_device *media_open(const char *name)
+struct media_device *media_device_ref(struct media_device *media)
 {
-	return media_open_debug(name, NULL, NULL);
+	media->refcount++;
+	return media;
 }
 
-void media_close(struct media_device *media)
+void media_device_unref(struct media_device *media)
 {
 	unsigned int i;
 
-	if (media->fd != -1)
-		close(media->fd);
+	media->refcount--;
+	if (media->refcount > 0)
+		return;
 
 	for (i = 0; i < media->entities_count; ++i) {
 		struct media_entity *entity = &media->entities[i];
@@ -523,9 +588,14 @@ void media_close(struct media_device *media)
 	}
 
 	free(media->entities);
+	free(media->devnode);
 	free(media);
 }
 
+/* -----------------------------------------------------------------------------
+ * Parsing
+ */
+
 struct media_pad *media_parse_pad(struct media_device *media,
 				  const char *p, char **endp)
 {
diff --git a/src/mediactl.h b/src/mediactl.h
index 2296fe2..34e7487 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -54,6 +54,8 @@ struct media_entity {
 
 struct media_device {
 	int fd;
+	int refcount;
+	char *devnode;
 	struct media_device_info info;
 	struct media_entity *entities;
 	unsigned int entities_count;
@@ -66,61 +68,67 @@ struct media_device {
 	(media)->debug_handler((media)->debug_priv, __VA_ARGS__)
 
 /**
- * @brief Set a handler for debug messages.
- * @param media - device instance.
- * @param debug_handler - debug message handler
- * @param debug_priv - first argument to debug message handler
+ * @brief Create a new media device.
+ * @param devnode - device node path.
  *
- * Set a handler for debug messages that will be called whenever
- * debugging information is to be printed. The handler expects an
- * fprintf-like function.
+ * Create a media device instance for the given device node and return it. The
+ * device node is not accessed by this function, device node access errors will
+ * not be caught and reported here. The media device needs to be enumerated
+ * before it can be accessed, see media_device_enumerate().
+ *
+ * Media devices are reference-counted, see media_device_ref() and
+ * media_device_unref() for more information.
+ *
+ * @return A pointer to the new media device or NULL if memory cannot be
+ * allocated.
  */
-void media_debug_set_handler(
-	struct media_device *media, void (*debug_handler)(void *, ...),
-	void *debug_priv);
+struct media_device *media_device_new(const char *devnode);
 
 /**
- * @brief Open a media device with debugging enabled.
- * @param name - name (including path) of the device node.
- * @param debug_handler - debug message handler
- * @param debug_priv - first argument to debug message handler
- *
- * Open the media device referenced by @a name and enumerate entities, pads and
- * links.
+ * @brief Take a reference to the device.
+ * @param media - device instance.
  *
- * Calling media_open_debug() instead of media_open() is equivalent to
- * media_open() and media_debug_set_handler() except that debugging is
- * also enabled during media_open().
+ * Media devices are reference-counted. Taking a reference to a device prevents
+ * it from being freed until all references are released. The reference count is
+ * initialized to 1 when the device is created.
  *
- * @return A pointer to a newly allocated media_device structure instance on
- * success and NULL on failure. The returned pointer must be freed with
- * media_close when the device isn't needed anymore.
+ * @return A pointer to @a media.
  */
-struct media_device *media_open_debug(
-	const char *name, void (*debug_handler)(void *, ...),
-	void *debug_priv);
+struct media_device *media_device_ref(struct media_device *media);
 
 /**
- * @brief Open a media device.
- * @param name - name (including path) of the device node.
+ * @brief Release a reference to the device.
+ * @param media - device instance.
  *
- * Open the media device referenced by @a name and enumerate entities, pads and
- * links.
+ * Release a reference to the media device. When the reference count reaches 0
+ * this function frees the device.
+ */
+void media_device_unref(struct media_device *media);
+
+/**
+ * @brief Set a handler for debug messages.
+ * @param media - device instance.
+ * @param debug_handler - debug message handler
+ * @param debug_priv - first argument to debug message handler
  *
- * @return A pointer to a newly allocated media_device structure instance on
- * success and NULL on failure. The returned pointer must be freed with
- * media_close when the device isn't needed anymore.
+ * Set a handler for debug messages that will be called whenever
+ * debugging information is to be printed. The handler expects an
+ * fprintf-like function.
  */
-struct media_device *media_open(const char *name);
+void media_debug_set_handler(
+	struct media_device *media, void (*debug_handler)(void *, ...),
+	void *debug_priv);
 
 /**
- * @brief Close a media device.
+ * @brief Enumerate the device topology
  * @param media - device instance.
  *
- * Close the @a media device instance and free allocated resources. Access to the
- * device instance is forbidden after this function returns.
+ * Enumerate the media device entities, pads and links. Calling this function is
+ * mandatory before accessing the media device contents.
+ *
+ * @return Zero on success or a negative error code on failure.
  */
-void media_close(struct media_device *media);
+int media_device_enumerate(struct media_device *media);
 
 /**
  * @brief Locate the pad at the other end of a link.
-- 
1.8.3.2

