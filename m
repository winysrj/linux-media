Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:37408 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab2DMUaU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 16:30:20 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v2 1/3] Support integer menus.
Date: Fri, 13 Apr 2012 23:34:19 +0300
Message-Id: <1334349261-11580-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/yavta.c b/yavta.c
index 541aa1c..e649ac5 100644
--- a/yavta.c
+++ b/yavta.c
@@ -567,19 +567,22 @@ static int video_enable(struct device *dev, int enable)
 	return 0;
 }
 
-static void video_query_menu(struct device *dev, unsigned int id,
-			     unsigned int min, unsigned int max)
+static void video_query_menu(struct device *dev, struct v4l2_queryctrl *query)
 {
 	struct v4l2_querymenu menu;
 	int ret;
 
-	for (menu.index = min; menu.index <= max; menu.index++) {
-		menu.id = id;
+	for (menu.index = query->minimum;
+	     menu.index <= (unsigned)query->maximum; menu.index++) {
+		menu.id = query->id;
 		ret = ioctl(dev->fd, VIDIOC_QUERYMENU, &menu);
 		if (ret < 0)
 			continue;
 
-		printf("  %u: %.32s\n", menu.index, menu.name);
+		if (query->type == V4L2_CTRL_TYPE_MENU)
+			printf("  %u: %.32s\n", menu.index, menu.name);
+		else
+			printf("  %u: %lld\n", menu.index, menu.value);
 	};
 }
 
@@ -624,8 +627,9 @@ static void video_list_controls(struct device *dev)
 			query.id, query.name, query.minimum, query.maximum,
 			query.step, query.default_value, value);
 
-		if (query.type == V4L2_CTRL_TYPE_MENU)
-			video_query_menu(dev, query.id, query.minimum, query.maximum);
+		if (query.type == V4L2_CTRL_TYPE_MENU ||
+		    query.type == V4L2_CTRL_TYPE_INTEGER_MENU)
+			video_query_menu(dev, &query);
 
 		nctrls++;
 	}
-- 
1.7.2.5

