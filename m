Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:29995 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab1HPK3L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 06:29:11 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [media-ctl][PATCHv2 4/4] libmediactl: pass verbose to media_get_devname
Date: Tue, 16 Aug 2011 13:28:05 +0300
Message-Id: <28399dc0838ba44bce017e6377504fe06f689f78.1313490446.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1313490446.git.andriy.shevchenko@linux.intel.com>
References: <201108151652.54417.laurent.pinchart@ideasonboard.com>
 <6075971b959c2e808cd4ceec6540dc09b101346f.1313490446.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1313490446.git.andriy.shevchenko@linux.intel.com>
References: <6075971b959c2e808cd4ceec6540dc09b101346f.1313490446.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 src/media.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/src/media.c b/src/media.c
index e159526..e276df5 100644
--- a/src/media.c
+++ b/src/media.c
@@ -255,7 +255,7 @@ static int media_enum_links(struct media_device *media)
 
 static struct udev *udev;
 
-static int media_get_devname(struct media_entity *entity)
+static int media_get_devname(struct media_entity *entity, int verbose)
 {
 	dev_t devnum;
 	struct udev_device *device;
@@ -267,7 +267,8 @@ static int media_get_devname(struct media_entity *entity)
 		return 0;
 
 	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
-	printf("looking up device: %u:%u\n", major(devnum), minor(devnum));
+	if (verbose)
+		printf("looking up device: %u:%u\n", major(devnum), minor(devnum));
 	device = udev_device_new_from_devnum(udev, 'c', devnum);
 	if (device) {
 		p = udev_device_get_devnode(device);
@@ -282,7 +283,7 @@ static int media_get_devname(struct media_entity *entity)
 
 #else	/* HAVE_LIBUDEV */
 
-static int media_get_devname(struct media_entity *entity)
+static int media_get_devname(struct media_entity *entity, int verbose)
 {
 	struct stat devstat;
 	char devname[32];
@@ -323,7 +324,7 @@ static int media_get_devname(struct media_entity *entity)
 }
 #endif	/* HAVE_LIBUDEV */
 
-static int media_enum_entities(struct media_device *media)
+static int media_enum_entities(struct media_device *media, int verbose)
 {
 	struct media_entity *entity;
 	unsigned int size;
@@ -370,7 +371,7 @@ static int media_enum_entities(struct media_device *media)
 		media->entities_count++;
 
 		/* Find the corresponding device name. */
-		media_get_devname(entity);
+		media_get_devname(entity, verbose);
 	}
 
 #ifdef HAVE_LIBUDEV
@@ -404,7 +405,7 @@ struct media_device *media_open(const char *name, int verbose)
 	if (verbose)
 		printf("Enumerating entities\n");
 
-	ret = media_enum_entities(media);
+	ret = media_enum_entities(media, verbose);
 	if (ret < 0) {
 		printf("%s: Unable to enumerate entities for device %s (%s)\n",
 			__func__, name, strerror(-ret));
-- 
1.7.5.4

