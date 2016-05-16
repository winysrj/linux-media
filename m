Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52755 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbcEPKCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 06:02:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: sakari.ailus@iki.fi
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/4] Implement VIDIOC_QUERY_EXT_CTRL support
Date: Mon, 16 May 2016 13:02:09 +0300
Message-Id: <1463392932-28307-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1463392932-28307-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1463392932-28307-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new extended control query ioctl when available with an
automatic fall back to VIDIOC_QUERYCTRL.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 47 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/yavta.c b/yavta.c
index 9b8b8998e0dc..af565245f87b 100644
--- a/yavta.c
+++ b/yavta.c
@@ -429,22 +429,52 @@ static void video_log_status(struct device *dev)
 }
 
 static int query_control(struct device *dev, unsigned int id,
-			 struct v4l2_queryctrl *query)
+			 struct v4l2_query_ext_ctrl *query)
 {
+	struct v4l2_queryctrl q;
 	int ret;
 
 	memset(query, 0, sizeof(*query));
 	query->id = id;
 
-	ret = ioctl(dev->fd, VIDIOC_QUERYCTRL, query);
+	ret = ioctl(dev->fd, VIDIOC_QUERY_EXT_CTRL, query);
 	if (ret < 0 && errno != EINVAL)
 		printf("unable to query control 0x%8.8x: %s (%d).\n",
 		       id, strerror(errno), errno);
 
-	return ret;
+	if (!ret || errno != ENOTTY)
+		return ret;
+
+	/*
+	 * If VIDIOC_QUERY_EXT_CTRL isn't available emulate it using
+	 * VIDIOC_QUERYCTRL.
+	 */
+	memset(&q, 0, sizeof(q));
+	q.id = id;
+
+	ret = ioctl(dev->fd, VIDIOC_QUERYCTRL, &q);
+	if (ret < 0) {
+		if (errno != EINVAL)
+			printf("unable to query control 0x%8.8x: %s (%d).\n",
+			       id, strerror(errno), errno);
+		return ret;
+	}
+
+	memset(query, 0, sizeof(*query));
+	query->id = q.id;
+	query->type = q.type;
+	memcpy(query->name, q.name, sizeof(query->name));
+	query->minimum = q.minimum;
+	query->maximum = q.maximum;
+	query->step = q.step;
+	query->default_value = q.default_value;
+	query->flags = q.flags;
+
+	return 0;
 }
 
-static int get_control(struct device *dev, const struct v4l2_queryctrl *query,
+static int get_control(struct device *dev,
+		       const struct v4l2_query_ext_ctrl *query,
 		       struct v4l2_ext_control *ctrl)
 {
 	struct v4l2_ext_controls ctrls;
@@ -494,7 +524,7 @@ static void set_control(struct device *dev, unsigned int id,
 {
 	struct v4l2_ext_controls ctrls;
 	struct v4l2_ext_control ctrl;
-	struct v4l2_queryctrl query;
+	struct v4l2_query_ext_ctrl query;
 	int64_t old_val = val;
 	int is_64;
 	int ret;
@@ -1058,7 +1088,8 @@ static int video_enable(struct device *dev, int enable)
 	return 0;
 }
 
-static void video_query_menu(struct device *dev, struct v4l2_queryctrl *query,
+static void video_query_menu(struct device *dev,
+			     struct v4l2_query_ext_ctrl *query,
 			     unsigned int value)
 {
 	struct v4l2_querymenu menu;
@@ -1083,7 +1114,7 @@ static void video_query_menu(struct device *dev, struct v4l2_queryctrl *query,
 static int video_print_control(struct device *dev, unsigned int id, bool full)
 {
 	struct v4l2_ext_control ctrl;
-	struct v4l2_queryctrl query;
+	struct v4l2_query_ext_ctrl query;
 	char sval[24];
 	char *current = sval;
 	int ret;
@@ -1111,7 +1142,7 @@ static int video_print_control(struct device *dev, unsigned int id, bool full)
 		sprintf(sval, "%d", ctrl.value);
 
 	if (full)
-		printf("control 0x%08x `%s' min %d max %d step %d default %d current %s.\n",
+		printf("control 0x%08x `%s' min %lld max %lld step %lld default %lld current %s.\n",
 			query.id, query.name, query.minimum, query.maximum,
 			query.step, query.default_value, current);
 	else
-- 
2.7.3

