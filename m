Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7297 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608Ab1IBIkM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Sep 2011 04:40:12 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [media-ctl][PATCHv3 1/3] libmediactl: restruct error path
Date: Fri,  2 Sep 2011 11:39:42 +0300
Message-Id: <6075971b959c2e808cd4ceec6540dc09b101346f.1314952687.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <201108302101.58685.laurent.pinchart@ideasonboard.com>
References: <201108302101.58685.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 src/media.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/src/media.c b/src/media.c
index e3cab86..050289e 100644
--- a/src/media.c
+++ b/src/media.c
@@ -255,7 +255,7 @@ static int media_enum_entities(struct media_device *media)
 	char target[1024];
 	char *p;
 	__u32 id;
-	int ret;
+	int ret = 0;
 
 	for (id = 0; ; id = entity->info.id) {
 		size = (media->entities_count + 1) * sizeof(*media->entities);
@@ -268,9 +268,9 @@ static int media_enum_entities(struct media_device *media)
 
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
@@ -281,8 +281,10 @@ static int media_enum_entities(struct media_device *media)
 
 		entity->pads = malloc(entity->info.pads * sizeof(*entity->pads));
 		entity->links = malloc(entity->max_links * sizeof(*entity->links));
-		if (entity->pads == NULL || entity->links == NULL)
-			return -ENOMEM;
+		if (entity->pads == NULL || entity->links == NULL) {
+			ret = -ENOMEM;
+			break;
+		}
 
 		media->entities_count++;
 
@@ -316,7 +318,7 @@ static int media_enum_entities(struct media_device *media)
 			strcpy(entity->devname, devname);
 	}
 
-	return 0;
+	return ret;
 }
 
 struct media_device *media_open(const char *name, int verbose)
-- 
1.7.5.4

