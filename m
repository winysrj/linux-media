Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54280 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751233Ab2G3JIv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 05:08:51 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com
Subject: [PATCH 1/1] v4l: Add missing compatibility definitions for bounds rectangles
Date: Mon, 30 Jul 2012 12:08:47 +0300
Message-Id: <1343639327-31329-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compatibility defines for ACTUAL subdev selection rectangles were added and
also the name of the BOUNDS rectangles was changed in the process, which,
alas, went unnoticed until now. Add compatibility definitions for these
rectangles.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/linux/v4l2-common.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/v4l2-common.h b/include/linux/v4l2-common.h
index 0fa8b64..4f0667e 100644
--- a/include/linux/v4l2-common.h
+++ b/include/linux/v4l2-common.h
@@ -53,10 +53,10 @@
 /* Backward compatibility target definitions --- to be removed. */
 #define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
 #define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE
-#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL \
-	V4L2_SEL_TGT_CROP
-#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL \
-	V4L2_SEL_TGT_COMPOSE
+#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL	V4L2_SEL_TGT_CROP
+#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL V4L2_SEL_TGT_COMPOSE
+#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS	V4L2_SEL_TGT_CROP_BOUNDS
+#define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS V4L2_SEL_TGT_COMPOSE_BOUNDS
 
 /* Selection flags */
 #define V4L2_SEL_FLAG_GE		(1 << 0)
-- 
1.7.2.5

