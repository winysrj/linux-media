Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47286 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932683Ab1IBIks (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Sep 2011 04:40:48 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [media-ctl][PATCHv3 3/3] libmediactl: get the device name via udev
Date: Fri,  2 Sep 2011 11:39:44 +0300
Message-Id: <fa50aa5ff03919bf88cb60043de4c2fe4c9f2a58.1314952687.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1314952687.git.andriy.shevchenko@linux.intel.com>
References: <201108302101.58685.laurent.pinchart@ideasonboard.com>
 <6075971b959c2e808cd4ceec6540dc09b101346f.1314952687.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1314952687.git.andriy.shevchenko@linux.intel.com>
References: <6075971b959c2e808cd4ceec6540dc09b101346f.1314952687.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If configured with --with-libudev, the libmediactl is built with libudev
support. It allows to get the device name in right way in the modern linux
systems.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 configure.in    |   22 ++++++++++++++++
 src/Makefile.am |    2 +
 src/media.c     |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/media.h     |    1 +
 4 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index fd4c70c..2f31831 100644
--- a/configure.in
+++ b/configure.in
@@ -13,6 +13,28 @@ AC_PROG_LIBTOOL
 
 # Checks for libraries.
 
+AC_ARG_WITH([libudev],
+    AS_HELP_STRING([--without-libudev],
+        [Ignore presence of libudev and disable it]))
+
+AS_IF([test "x$with_libudev" != "xno"],
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
index 5d3ff7c..dae649a 100644
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
@@ -245,6 +247,64 @@ static int media_enum_links(struct media_device *media)
 	return ret;
 }
 
+#ifdef HAVE_LIBUDEV
+
+#include <libudev.h>
+
+static inline int media_udev_open(struct media_device *media)
+{
+	media->priv = udev_new();
+	if (media->priv == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static inline void media_udev_close(struct media_device *media)
+{
+	udev_unref(media->priv);
+}
+
+static int media_get_devname_udev(struct media_device *media,
+		struct media_entity *entity)
+{
+	int ret = -ENODEV;
+	struct udev *udev = media->priv;
+	dev_t devnum;
+	struct udev_device *device;
+	const char *p;
+
+	if (udev == NULL)
+		return -EINVAL;
+
+	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
+	printf("looking up device: %u:%u\n", major(devnum), minor(devnum));
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
+static inline int media_udev_open(struct media_device *media) { return 0; }
+
+static inline void media_udev_close(struct media_device *media) { }
+
+static inline int media_get_devname_udev(struct media_device *media,
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
@@ -324,6 +384,11 @@ static int media_enum_entities(struct media_device *media)
 		    media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			continue;
 
+		/* Try to get the device name via udev */
+		if (!media_get_devname_udev(media, entity))
+			continue;
+
+		/* Fall back to get the device name via sysfs */
 		media_get_devname_sysfs(entity);
 	}
 
@@ -351,6 +416,13 @@ struct media_device *media_open(const char *name, int verbose)
 		return NULL;
 	}
 
+	ret = media_udev_open(media);
+	if (ret < 0) {
+		printf("%s: Can't get udev context\n", __func__);
+		media_close(media);
+		return NULL;
+	}
+
 	if (verbose)
 		printf("Enumerating entities\n");
 
@@ -395,6 +467,7 @@ void media_close(struct media_device *media)
 	}
 
 	free(media->entities);
+	media_udev_close(media);
 	free(media);
 }
 
diff --git a/src/media.h b/src/media.h
index b91a2ac..4201451 100644
--- a/src/media.h
+++ b/src/media.h
@@ -54,6 +54,7 @@ struct media_device {
 	struct media_entity *entities;
 	unsigned int entities_count;
 	__u32 padding[6];
+	void *priv;
 };
 
 /**
-- 
1.7.5.4

