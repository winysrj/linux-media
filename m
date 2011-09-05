Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:35024 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab1IEPZE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Sep 2011 11:25:04 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [media-ctl][PATCHv5 3/5] libmediactl: get the device name via udev
Date: Mon,  5 Sep 2011 18:24:05 +0300
Message-Id: <8c67a61ca8d7a0560870be91a1c0021ea72b4f6a.1315236211.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
References: <201109051657.21646.laurent.pinchart@ideasonboard.com>
 <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
References: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If configured with --with-libudev, the libmediactl is built with libudev
support. It allows to get the device name in right way in the modern linux
systems.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 configure.in    |   22 +++++++++++
 src/Makefile.am |    2 +
 src/media.c     |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index fd4c70c..983023e 100644
--- a/configure.in
+++ b/configure.in
@@ -13,6 +13,28 @@ AC_PROG_LIBTOOL
 
 # Checks for libraries.
 
+AC_ARG_WITH([libudev],
+    AS_HELP_STRING([--with-libudev],
+        [Enable libudev to detect a device name]))
+
+AS_IF([test "x$with_libudev" = "xyes"],
+    [PKG_CHECK_MODULES(libudev, libudev, have_libudev=yes, have_libudev=no)],
+    [have_libudev=no])
+
+AS_IF([test "x$have_libudev" = "xyes"],
+    [
+        AC_DEFINE([HAVE_LIBUDEV], [], [Use libudev])
+        LIBUDEV_CFLAGS="$libudev_CFLAGS"
+        LIBUDEV_LIBS="$libudev_LIBS"
+        AC_SUBST(LIBUDEV_CFLAGS)
+        AC_SUBST(LIBUDEV_LIBS)
+    ],
+    [AS_IF([test "x$with_libudev" = "xyes"],
+        [AC_MSG_ERROR([libudev requested but not found])
+    ])
+])
+
+
 # Kernel headers path.
 AC_ARG_WITH(kernel-headers,
     [AC_HELP_STRING([--with-kernel-headers=DIR],
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
index 5d3ff7c..657b6c4 100644
--- a/src/media.c
+++ b/src/media.c
@@ -17,6 +17,8 @@
  * with this program; if not, write to the Free Software Foundation, Inc.,
  */
 
+#include "config.h"
+
 #include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -245,6 +247,71 @@ static int media_enum_links(struct media_device *media)
 	return ret;
 }
 
+struct media_private {
+	struct media_device *media;
+	int verbose;
+	void *priv;
+};
+
+#ifdef HAVE_LIBUDEV
+
+#include <libudev.h>
+
+static inline int media_udev_open(struct media_private *priv)
+{
+	priv->priv = udev_new();
+	if (priv->priv == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static inline void media_udev_close(struct media_private *priv)
+{
+	udev_unref(priv->priv);
+}
+
+static int media_get_devname_udev(struct media_private *priv,
+		struct media_entity *entity)
+{
+	struct udev *udev = priv->priv;
+	dev_t devnum;
+	struct udev_device *device;
+	const char *p;
+	int ret = -ENODEV;
+
+	if (udev == NULL)
+		return -EINVAL;
+
+	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
+	if (priv->verbose)
+		printf("looking up device: %u:%u\n", major(devnum), minor(devnum));
+	device = udev_device_new_from_devnum(udev, 'c', devnum);
+	if (device) {
+		p = udev_device_get_devnode(device);
+		if (p)
+			snprintf(entity->devname, sizeof(entity->devname), "%s", p);
+		ret = 0;
+	}
+
+	udev_device_unref(device);
+
+	return ret;
+}
+
+#else	/* HAVE_LIBUDEV */
+
+static inline int media_udev_open(struct media_private *priv) { return 0; }
+
+static inline void media_udev_close(struct media_private *priv) { }
+
+static inline int media_get_devname_udev(struct media_private *priv,
+		struct media_entity *entity)
+{
+	return -ENOTSUP;
+}
+
+#endif	/* HAVE_LIBUDEV */
+
 static int media_get_devname_sysfs(struct media_entity *entity)
 {
 	struct stat devstat;
@@ -281,8 +348,9 @@ static int media_get_devname_sysfs(struct media_entity *entity)
 	return 0;
 }
 
-static int media_enum_entities(struct media_device *media)
+static int media_enum_entities(struct media_private *priv)
 {
+	struct media_device *media = priv->media;
 	struct media_entity *entity;
 	unsigned int size;
 	__u32 id;
@@ -324,6 +392,11 @@ static int media_enum_entities(struct media_device *media)
 		    media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			continue;
 
+		/* Try to get the device name via udev */
+		if (!media_get_devname_udev(priv, entity))
+			continue;
+
+		/* Fall back to get the device name via sysfs */
 		media_get_devname_sysfs(entity);
 	}
 
@@ -333,6 +406,7 @@ static int media_enum_entities(struct media_device *media)
 struct media_device *media_open(const char *name, int verbose)
 {
 	struct media_device *media;
+	struct media_private *priv;
 	int ret;
 
 	media = malloc(sizeof(*media));
@@ -351,13 +425,39 @@ struct media_device *media_open(const char *name, int verbose)
 		return NULL;
 	}
 
+	priv = malloc(sizeof(*priv));
+	if (priv == NULL) {
+		printf("%s: unable to allocate memory\n", __func__);
+		media_close(media);
+		return NULL;
+	}
+	memset(priv, 0, sizeof(*priv));
+
+	/* Fill the private structure */
+	priv->media = media;
+	priv->verbose = verbose;
+
+	ret = media_udev_open(priv);
+	if (ret < 0) {
+		printf("%s: Can't get udev context\n", __func__);
+		free(priv);
+		media_close(media);
+		return NULL;
+	}
+
 	if (verbose)
 		printf("Enumerating entities\n");
 
-	ret = media_enum_entities(media);
+	ret = media_enum_entities(priv);
+
+	/* We should close the udev independently of return value of
+	 * media_enum_entities. */
+	media_udev_close(priv);
+
 	if (ret < 0) {
 		printf("%s: Unable to enumerate entities for device %s (%s)\n",
 			__func__, name, strerror(-ret));
+		free(priv);
 		media_close(media);
 		return NULL;
 	}
@@ -371,6 +471,7 @@ struct media_device *media_open(const char *name, int verbose)
 	if (ret < 0) {
 		printf("%s: Unable to enumerate pads and linksfor device %s\n",
 			__func__, name);
+		free(priv);
 		media_close(media);
 		return NULL;
 	}
-- 
1.7.5.4

