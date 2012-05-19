Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:40827 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757564Ab2ESTH3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 15:07:29 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH v2 4/4] Replace V4L2 subdev selection targets with the V4L2 ones
Date: Sat, 19 May 2012 22:11:31 +0300
Message-Id: <1337454691-28698-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120519190627.GR3373@valkosipuli.retiisi.org.uk>
References: <20120519190627.GR3373@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 selection targets will replace V4L2 subdev selection targets in the
near future. As the targets are guaranteed to be the same and the chance is
anticipated very soon, replace the subdev targets with more future-proof
V4L2 targets.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c       |    8 ++++----
 src/v4l2subdev.c |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/main.c b/src/main.c
index 703f034..69c5a7f 100644
--- a/src/main.c
+++ b/src/main.c
@@ -64,28 +64,28 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
  	       format.width, format.height);
 
 	ret = v4l2_subdev_get_selection(entity, &rect, pad,
-					V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS,
+					V4L2_SEL_TGT_CROP_BOUNDS,
 					which);
 	if (ret == 0)
 		printf("\n\t\t crop.bounds:%u,%u/%ux%u", rect.left, rect.top,
 		       rect.width, rect.height);
 
 	ret = v4l2_subdev_get_selection(entity, &rect, pad,
-					V4L2_SUBDEV_SEL_TGT_CROP,
+					V4L2_SEL_TGT_CROP,
 					which);
 	if (ret == 0)
 		printf("\n\t\t crop:%u,%u/%ux%u", rect.left, rect.top,
 		       rect.width, rect.height);
 
 	ret = v4l2_subdev_get_selection(entity, &rect, pad,
-					V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS,
+					V4L2_SEL_TGT_COMPOSE_BOUNDS,
 					which);
 	if (ret == 0)
 		printf("\n\t\t compose.bounds:%u,%u/%ux%u",
 		       rect.left, rect.top, rect.width, rect.height);
 
 	ret = v4l2_subdev_get_selection(entity, &rect, pad,
-					V4L2_SUBDEV_SEL_TGT_COMPOSE,
+					V4L2_SEL_TGT_COMPOSE,
 					which);
 	if (ret == 0)
 		printf("\n\t\t compose:%u,%u/%ux%u",
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index 48b7acb..46869d9 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -128,7 +128,7 @@ int v4l2_subdev_get_selection(struct media_entity *entity,
 		*rect = u.sel.r;
 		return 0;
 	}
-	if (errno != ENOTTY || target != V4L2_SUBDEV_SEL_TGT_CROP)
+	if (errno != ENOTTY || target != V4L2_SEL_TGT_CROP)
 		return -errno;
 
 	memset(&u.crop, 0, sizeof(u.crop));
@@ -168,7 +168,7 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
 		*rect = u.sel.r;
 		return 0;
 	}
-	if (errno != ENOTTY || target != V4L2_SUBDEV_SEL_TGT_CROP)
+	if (errno != ENOTTY || target != V4L2_SEL_TGT_CROP)
 		return -errno;
 
 	memset(&u.crop, 0, sizeof(u.crop));
@@ -514,11 +514,11 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
 			return ret;
 	}
 
-	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_CROP, &crop);
+	ret = set_selection(pad, V4L2_SEL_TGT_CROP, &crop);
 	if (ret < 0)
 		return ret;
 
-	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_COMPOSE, &compose);
+	ret = set_selection(pad, V4L2_SEL_TGT_COMPOSE, &compose);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.2.5

