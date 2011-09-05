Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1712 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab1IEPYu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Sep 2011 11:24:50 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [media-ctl][PATCHv5 2/5] libmediactl: split media_get_devname_sysfs from media_enum_entities
Date: Mon,  5 Sep 2011 18:24:04 +0300
Message-Id: <05824e3de1c4470932403064c64a7746b39e025c.1315236211.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
References: <201109051657.21646.laurent.pinchart@ideasonboard.com>
 <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
References: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 src/media.c |   61 +++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/src/media.c b/src/media.c
index 050289e..5d3ff7c 100644
--- a/src/media.c
+++ b/src/media.c
@@ -245,15 +245,46 @@ static int media_enum_links(struct media_device *media)
 	return ret;
 }
 
-static int media_enum_entities(struct media_device *media)
+static int media_get_devname_sysfs(struct media_entity *entity)
 {
-	struct media_entity *entity;
 	struct stat devstat;
-	unsigned int size;
 	char devname[32];
 	char sysname[32];
 	char target[1024];
 	char *p;
+	int ret;
+
+	sprintf(sysname, "/sys/dev/char/%u:%u", entity->info.v4l.major,
+		entity->info.v4l.minor);
+	ret = readlink(sysname, target, sizeof(target));
+	if (ret < 0)
+		return -errno;
+
+	target[ret] = '\0';
+	p = strrchr(target, '/');
+	if (p == NULL)
+		return -EINVAL;
+
+	sprintf(devname, "/dev/%s", p + 1);
+	ret = stat(devname, &devstat);
+	if (ret < 0)
+		return -errno;
+
+	/* Sanity check: udev might have reordered the device nodes.
+	 * Make sure the major/minor match. We should really use
+	 * libudev.
+	 */
+	if (major(devstat.st_rdev) == entity->info.v4l.major &&
+	    minor(devstat.st_rdev) == entity->info.v4l.minor)
+		strcpy(entity->devname, devname);
+
+	return 0;
+}
+
+static int media_enum_entities(struct media_device *media)
+{
+	struct media_entity *entity;
+	unsigned int size;
 	__u32 id;
 	int ret = 0;
 
@@ -293,29 +324,7 @@ static int media_enum_entities(struct media_device *media)
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
-
-		/* Sanity check: udev might have reordered the device nodes.
-		 * Make sure the major/minor match. We should really use
-		 * libudev.
-		 */
-		if (major(devstat.st_rdev) == entity->info.v4l.major &&
-		    minor(devstat.st_rdev) == entity->info.v4l.minor)
-			strcpy(entity->devname, devname);
+		media_get_devname_sysfs(entity);
 	}
 
 	return ret;
-- 
1.7.5.4

