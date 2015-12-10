Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:39156 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750902AbbLJKlt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 05:41:49 -0500
To: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] libmediactl.c: add poor man's udev support
Message-ID: <5669579B.8050706@xs4all.nl>
Date: Thu, 10 Dec 2015 11:44:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If libudev is not available (android!), then just try to find the device in /dev.
It's a poor man's solution, but it is better than nothing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 4a82d24..1577783 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -441,7 +441,10 @@ static int media_get_devname_udev(struct udev *udev,
 	return ret;
 }

-#else	/* HAVE_LIBUDEV */
+#else
+
+#include <dirent.h>
+#include <sys/stat.h>

 struct udev;

@@ -449,10 +452,36 @@ static inline int media_udev_open(struct udev **udev) { return 0; }

 static inline void media_udev_close(struct udev *udev) { }

-static inline int media_get_devname_udev(struct udev *udev,
-		struct media_entity *entity)
+static int media_get_devname_udev(struct udev *udev,
+				  struct media_entity *entity)
 {
-	return -ENOTSUP;
+	DIR *dp;
+	struct dirent *ep;
+	dev_t devnum;
+
+	dp = opendir("/dev");
+	if (dp == NULL) {
+		media_dbg(entity->media, "couldn't open /dev\n");
+		return -ENODEV;
+	}
+	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
+	while ((ep = readdir(dp))) {
+		struct stat st;
+		char fname[256];
+
+		snprintf(fname, sizeof(fname) - 1, "/dev/%s", ep->d_name);
+		fname[sizeof(fname) - 1] = 0;
+		stat(fname, &st);
+		if ((st.st_mode & S_IFMT) != S_IFCHR)
+			continue;
+		if (st.st_rdev == devnum) {
+			strncpy(entity->devname, fname, sizeof(entity->devname));
+                        entity->devname[sizeof(entity->devname) - 1] = '\0';
+			return 0;
+		}
+	}
+	closedir(dp);
+	return -ENODEV;
 }

 #endif	/* HAVE_LIBUDEV */
