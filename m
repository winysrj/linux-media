Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:61073 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab1JGPfQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Oct 2011 11:35:16 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 7/7] Remove extra verbosity
Date: Fri,  7 Oct 2011 18:38:08 +0300
Message-Id: <1318001888-18689-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111007153443.GC8908@valkosipuli.localdomain>
References: <20111007153443.GC8908@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove extra verbosity by default; "-v" option brings back what used to be
there. The error messages are now being printed by main.c with the possibly
helpful error code attached.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c     |   48 ++++++++++++++++++++++++++++++++++++++----------
 src/mediactl.c |   21 ++++++++++-----------
 src/mediactl.h |    6 ++----
 3 files changed, 50 insertions(+), 25 deletions(-)

diff --git a/src/main.c b/src/main.c
index 40ab13e..57bbc16 100644
--- a/src/main.c
+++ b/src/main.c
@@ -288,10 +288,16 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 
 	/* Open the media device and enumerate entities, pads and links. */
-	media = media_open_debug(media_opts.devname, media_opts.verbose,
-				 (void (*)(void *, ...))fprintf, stdout);
-	if (media == NULL)
+	if (media_opts.verbose)
+		media = media_open_debug(
+			media_opts.devname,
+			(void (*)(void *, ...))fprintf, stdout);
+	else
+		media = media_open(media_opts.devname);
+	if (media == NULL) {
+		printf("Failed to open %s\n", media_opts.devname);
 		goto out;
+	}
 
 	if (media_opts.entity) {
 		struct media_entity *entity;
@@ -326,15 +332,34 @@ int main(int argc, char **argv)
 	}
 
 	if (media_opts.reset) {
-		printf("Resetting all links to inactive\n");
-		media_reset_links(media);
+		if (media_opts.verbose)
+			printf("Resetting all links to inactive\n");
+		ret = media_reset_links(media);
+		if (ret) {
+			printf("Unable to reset links: %s (%d)\n",
+			       strerror(-ret), -ret);
+			goto out;
+		}
 	}
 
-	if (media_opts.links)
-		media_parse_setup_links(media, media_opts.links);
+	if (media_opts.links) {
+		ret = media_parse_setup_links(media, media_opts.links);
+		if (ret) {
+			printf("Unable to parse link: %s (%d)\n",
+			       strerror(-ret), -ret);
+			goto out;
+		}
+	}
 
-	if (media_opts.formats)
-		v4l2_subdev_parse_setup_formats(media, media_opts.formats);
+	if (media_opts.formats) {
+		ret = v4l2_subdev_parse_setup_formats(media,
+						      media_opts.formats);
+		if (ret) {
+			printf("Unable to parse format: %s (%d)\n",
+			       strerror(-ret), -ret);
+			goto out;
+		}
+	}
 
 	if (media_opts.interactive) {
 		while (1) {
@@ -348,7 +373,10 @@ int main(int argc, char **argv)
 			if (buffer[0] == '\n')
 				break;
 
-			media_parse_setup_link(media, buffer, &end);
+			ret = media_parse_setup_link(media, buffer, &end);
+			if (ret)
+				printf("Unable to parse link: %s (%d)\n",
+				       strerror(-ret), -ret);
 		}
 	}
 
diff --git a/src/mediactl.c b/src/mediactl.c
index 43d1b6a..b9c2a10 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -270,7 +270,7 @@ static inline void media_udev_close(struct udev *udev)
 }
 
 static int media_get_devname_udev(struct udev *udev,
-		struct media_entity *entity, int verbose)
+		struct media_entity *entity)
 {
 	struct udev_device *device;
 	dev_t devnum;
@@ -281,9 +281,8 @@ static int media_get_devname_udev(struct udev *udev,
 		return -EINVAL;
 
 	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
-	if (verbose)
-		media_dbg(entity->media, "looking up device: %u:%u\n",
-			  major(devnum), minor(devnum));
+	media_dbg(entity->media, "looking up device: %u:%u\n",
+		  major(devnum), minor(devnum));
 	device = udev_device_new_from_devnum(udev, 'c', devnum);
 	if (device) {
 		p = udev_device_get_devnode(device);
@@ -308,7 +307,7 @@ static inline int media_udev_open(struct udev **udev) { return 0; }
 static inline void media_udev_close(struct udev *udev) { }
 
 static inline int media_get_devname_udev(struct udev *udev,
-		struct media_entity *entity, int verbose)
+		struct media_entity *entity)
 {
 	return -ENOTSUP;
 }
@@ -351,7 +350,7 @@ static int media_get_devname_sysfs(struct media_entity *entity)
 	return 0;
 }
 
-static int media_enum_entities(struct media_device *media, int verbose)
+static int media_enum_entities(struct media_device *media)
 {
 	struct media_entity *entity;
 	struct udev *udev;
@@ -400,7 +399,7 @@ static int media_enum_entities(struct media_device *media, int verbose)
 			continue;
 
 		/* Try to get the device name via udev */
-		if (!media_get_devname_udev(udev, entity, verbose))
+		if (!media_get_devname_udev(udev, entity))
 			continue;
 
 		/* Fall back to get the device name via sysfs */
@@ -429,7 +428,7 @@ void media_debug_set_handler(struct media_device *media,
 }
 
 struct media_device *media_open_debug(
-	const char *name, int verbose, void (*debug_handler)(void *, ...),
+	const char *name, void (*debug_handler)(void *, ...),
 	void *debug_priv)
 {
 	struct media_device *media;
@@ -453,7 +452,7 @@ struct media_device *media_open_debug(
 
 	media_dbg(media, "Enumerating entities\n");
 
-	ret = media_enum_entities(media, verbose);
+	ret = media_enum_entities(media);
 
 	if (ret < 0) {
 		media_dbg(media,
@@ -478,9 +477,9 @@ struct media_device *media_open_debug(
 	return media;
 }
 
-struct media_device *media_open(const char *name, int verbose)
+struct media_device *media_open(const char *name)
 {
-	return media_open_debug(name, verbose, NULL, NULL);
+	return media_open_debug(name, NULL, NULL);
 }
 
 void media_close(struct media_device *media)
diff --git a/src/mediactl.h b/src/mediactl.h
index c6bf723..5fdd078 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -79,7 +79,6 @@ void media_debug_set_handler(
 /**
  * @brief Open a media device with debugging enabled.
  * @param name - name (including path) of the device node.
- * @param verbose - whether to print verbose information on the standard output.
  * @param debug_handler - debug message handler
  * @param debug_priv - first argument to debug message handler
  *
@@ -95,13 +94,12 @@ void media_debug_set_handler(
  * media_close when the device isn't needed anymore.
  */
 struct media_device *media_open_debug(
-	const char *name, int verbose, void (*debug_handler)(void *, ...),
+	const char *name, void (*debug_handler)(void *, ...),
 	void *debug_priv);
 
 /**
  * @brief Open a media device.
  * @param name - name (including path) of the device node.
- * @param verbose - whether to print verbose information on the standard output.
  *
  * Open the media device referenced by @a name and enumerate entities, pads and
  * links.
@@ -110,7 +108,7 @@ struct media_device *media_open_debug(
  * success and NULL on failure. The returned pointer must be freed with
  * media_close when the device isn't needed anymore.
  */
-struct media_device *media_open(const char *name, int verbose);
+struct media_device *media_open(const char *name);
 
 /**
  * @brief Close a media device.
-- 
1.7.2.5

