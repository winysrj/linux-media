Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16905 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab1HOMVH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 08:21:07 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [media-ctl][PATCH] libmediactl: engage udev to get devname
Date: Mon, 15 Aug 2011 15:20:34 +0300
Message-Id: <4a6d0bf1e50189da0c02e2326c3413d9088926c1.1313410776.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 configure.in    |   10 ++++++++
 src/Makefile.am |    2 +
 src/media.c     |   66 ++++++++++++++++++++++++++----------------------------
 3 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/configure.in b/configure.in
index fd4c70c..63432ba 100644
--- a/configure.in
+++ b/configure.in
@@ -12,6 +12,16 @@ AC_PROG_CC
 AC_PROG_LIBTOOL
 
 # Checks for libraries.
+PKG_CHECK_MODULES(libudev, libudev, have_libudev=yes, have_libudev=no)
+
+if test x$have_libudev = xyes; then
+    LIBUDEV_CFLAGS="$lbudev_CFLAGS"
+    LIBUDEV_LIBS="$libudev_LIBS"
+    AC_SUBST(LIBUDEV_CFLAGS)
+    AC_SUBST(LIBUDEV_LIBS)
+else
+    AC_MSG_ERROR([libudev is required])
+fi
 
 # Kernel headers path.
 AC_ARG_WITH(kernel-headers,
diff --git a/src/Makefile.am b/src/Makefile.am
index 267ea83..52628d2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -5,6 +5,8 @@ mediactl_includedir=$(includedir)/mediactl
 mediactl_include_HEADERS = media.h subdev.h
 
 bin_PROGRAMS = media-ctl
+media_ctl_CFLAGS = $(LIBUDEV_CFLAGS)
+media_ctl_LDFLAGS = $(LIBUDEV_LIBS)
 media_ctl_SOURCES = main.c options.c options.h tools.h
 media_ctl_LDADD = libmediactl.la libv4l2subdev.la
 
diff --git a/src/media.c b/src/media.c
index e3cab86..000d750 100644
--- a/src/media.c
+++ b/src/media.c
@@ -31,6 +31,8 @@
 #include <linux/videodev2.h>
 #include <linux/media.h>
 
+#include <libudev.h>
+
 #include "media.h"
 #include "tools.h"
 
@@ -247,15 +249,20 @@ static int media_enum_links(struct media_device *media)
 
 static int media_enum_entities(struct media_device *media)
 {
+	struct udev *udev;
+	dev_t devnum;
+	struct udev_device *device;
 	struct media_entity *entity;
-	struct stat devstat;
 	unsigned int size;
-	char devname[32];
-	char sysname[32];
-	char target[1024];
-	char *p;
+	const char *p;
 	__u32 id;
-	int ret;
+	int ret = 0;
+
+	udev = udev_new();
+	if (udev == NULL) {
+		printf("unable to allocate memory for context\n");
+		return -ENOMEM;
+	}
 
 	for (id = 0; ; id = entity->info.id) {
 		size = (media->entities_count + 1) * sizeof(*media->entities);
@@ -268,9 +275,9 @@ static int media_enum_entities(struct media_device *media)
 
 		ret = ioctl(media->fd, MEDIA_IOC_ENUM_ENTITIES, &entity->info);
 		if (ret < 0) {
-			if (errno == EINVAL)
-				break;
-			return -errno;
+			if (errno != EINVAL)
+				ret = -errno;
+			break;
 		}
 
 		/* Number of links (for outbound links) plus number of pads (for
@@ -281,8 +288,10 @@ static int media_enum_entities(struct media_device *media)
 
 		entity->pads = malloc(entity->info.pads * sizeof(*entity->pads));
 		entity->links = malloc(entity->max_links * sizeof(*entity->links));
-		if (entity->pads == NULL || entity->links == NULL)
-			return -ENOMEM;
+		if (entity->pads == NULL || entity->links == NULL) {
+			ret = -ENOMEM;
+			break;
+		}
 
 		media->entities_count++;
 
@@ -291,32 +300,21 @@ static int media_enum_entities(struct media_device *media)
 		    media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			continue;
 
-		sprintf(sysname, "/sys/dev/char/%u:%u", entity->info.v4l.major,
-			entity->info.v4l.minor);
-		ret = readlink(sysname, target, sizeof(target));
-		if (ret < 0)
-			continue;
-
-		target[ret] = '\0';
-		p = strrchr(target, '/');
-		if (p == NULL)
-			continue;
-
-		sprintf(devname, "/dev/%s", p + 1);
-		ret = stat(devname, &devstat);
-		if (ret < 0)
-			continue;
+		devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
+		printf("looking up device: %u:%u\n", major(devnum), minor(devnum));
+		device = udev_device_new_from_devnum(udev, 'c', devnum);
+		if (device) {
+			p = udev_device_get_devnode(device);
+			if (p)
+				snprintf(entity->devname, sizeof(entity->devname),
+					 "%s", p);
+		}
 
-		/* Sanity check: udev might have reordered the device nodes.
-		 * Make sure the major/minor match. We should really use
-		 * libudev.
-		 */
-		if (major(devstat.st_rdev) == entity->info.v4l.major &&
-		    minor(devstat.st_rdev) == entity->info.v4l.minor)
-			strcpy(entity->devname, devname);
+		udev_device_unref(device);
 	}
 
-	return 0;
+	udev_unref(udev);
+	return ret;
 }
 
 struct media_device *media_open(const char *name, int verbose)
-- 
1.7.5.4

