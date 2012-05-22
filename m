Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:48220 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab2EVWbN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 18:31:13 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH v3 3/4] Drop _ACTUAL from selection target names
Date: Wed, 23 May 2012 01:30:59 +0300
Message-Id: <1337725860-11048-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4FBC1396.9090109@iki.fi>
References: <4FBC1396.9090109@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c       |    4 ++--
 src/v4l2subdev.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/main.c b/src/main.c
index 0b94f2a..c279dea 100644
--- a/src/main.c
+++ b/src/main.c
@@ -71,7 +71,7 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 		       rect.width, rect.height);
 
 	ret = v4l2_subdev_get_selection(entity, &rect, pad,
-					V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL,
+					V4L2_SUBDEV_SEL_TGT_CROP,
 					which);
 	if (ret == 0)
 		printf("\n\t\t crop:(%u,%u)/%ux%u", rect.left, rect.top,
@@ -85,7 +85,7 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 		       rect.left, rect.top, rect.width, rect.height);
 
 	ret = v4l2_subdev_get_selection(entity, &rect, pad,
-					V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL,
+					V4L2_SUBDEV_SEL_TGT_COMPOSE,
 					which);
 	if (ret == 0)
 		printf("\n\t\t compose:%u,%u/%ux%u",
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index 297e9d5..3914bd7 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -128,7 +128,7 @@ int v4l2_subdev_get_selection(struct media_entity *entity,
 		*rect = u.sel.r;
 		return 0;
 	}
-	if (errno != ENOTTY || target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL)
+	if (errno != ENOTTY || target != V4L2_SUBDEV_SEL_TGT_CROP)
 		return -errno;
 
 	memset(&u.crop, 0, sizeof(u.crop));
@@ -168,7 +168,7 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
 		*rect = u.sel.r;
 		return 0;
 	}
-	if (errno != ENOTTY || target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL)
+	if (errno != ENOTTY || target != V4L2_SUBDEV_SEL_TGT_CROP)
 		return -errno;
 
 	memset(&u.crop, 0, sizeof(u.crop));
@@ -514,11 +514,11 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
 			return ret;
 	}
 
-	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL, &crop);
+	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_CROP, &crop);
 	if (ret < 0)
 		return ret;
 
-	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL, &compose);
+	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_COMPOSE, &compose);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.2.5

