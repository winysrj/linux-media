Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47460 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaLOU36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 15:29:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/3] Implement VIDIOC_QUERY_EXT_CTRL support
Date: Mon, 15 Dec 2014 22:29:54 +0200
Message-Id: <1418675396-12485-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1418675396-12485-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1418675396-12485-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new extended control query ioctl when available with an
automatic fall back to VIDIOC_QUERYCTRL.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 47 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/yavta.c b/yavta.c
index 8e8ec19..b9b8bb8 100644
--- a/yavta.c
+++ b/yavta.c
@@ -407,22 +407,52 @@ static void video_log_status(struct device *dev)
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
@@ -472,7 +502,7 @@ static void set_control(struct device *dev, unsigned int id,
 {
 	struct v4l2_ext_controls ctrls;
 	struct v4l2_ext_control ctrl;
-	struct v4l2_queryctrl query;
+	struct v4l2_query_ext_ctrl query;
 	int64_t old_val = val;
 	int is_64;
 	int ret;
@@ -1034,7 +1064,8 @@ static int video_enable(struct device *dev, int enable)
 	return 0;
 }
 
-static void video_query_menu(struct device *dev, struct v4l2_queryctrl *query,
+static void video_query_menu(struct device *dev,
+			     struct v4l2_query_ext_ctrl *query,
 			     unsigned int value)
 {
 	struct v4l2_querymenu menu;
@@ -1059,7 +1090,7 @@ static void video_query_menu(struct device *dev, struct v4l2_queryctrl *query,
 static int video_print_control(struct device *dev, unsigned int id, bool full)
 {
 	struct v4l2_ext_control ctrl;
-	struct v4l2_queryctrl query;
+	struct v4l2_query_ext_ctrl query;
 	char sval[24];
 	char *current = sval;
 	int ret;
@@ -1087,7 +1118,7 @@ static int video_print_control(struct device *dev, unsigned int id, bool full)
 		sprintf(sval, "%d", ctrl.value);
 
 	if (full)
-		printf("control 0x%08x `%s' min %d max %d step %d default %d current %s.\n",
+		printf("control 0x%08x `%s' min %lld max %lld step %lld default %lld current %s.\n",
 			query.id, query.name, query.minimum, query.maximum,
 			query.step, query.default_value, current);
 	else
-- 
2.0.4

