Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:34894 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab2EZQjO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 12:39:14 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 1/1] media-ctl: Compose print fixes
Date: Sat, 26 May 2012 19:43:16 +0300
Message-Id: <1338050597-19251-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The compose rectangles were printed incorrectly in my recent patch "Compose
rectangle support for libv4l2subdev" without parenthesis. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
Hi Laurent,

Could you apply this simple fix to your tree? Currently the compose
rectangles are printed differently than the crop rectangles which certainly
isn't the intention.

 src/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/main.c b/src/main.c
index af16818..d10094b 100644
--- a/src/main.c
+++ b/src/main.c
@@ -81,14 +81,14 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 					V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS,
 					which);
 	if (ret == 0)
-		printf("\n\t\t compose.bounds:%u,%u/%ux%u",
+		printf("\n\t\t compose.bounds:(%u,%u)/%ux%u",
 		       rect.left, rect.top, rect.width, rect.height);
 
 	ret = v4l2_subdev_get_selection(entity, &rect, pad,
 					V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL,
 					which);
 	if (ret == 0)
-		printf("\n\t\t compose:%u,%u/%ux%u",
+		printf("\n\t\t compose:(%u,%u)/%ux%u",
 		       rect.left, rect.top, rect.width, rect.height);
 
 	printf("]\n");
-- 
1.7.2.5

