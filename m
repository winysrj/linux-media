Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47463 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaLOUaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 15:30:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/3] Implement compound control get support
Date: Mon, 15 Dec 2014 22:29:55 +0200
Message-Id: <1418675396-12485-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1418675396-12485-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1418675396-12485-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 158 +++++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 116 insertions(+), 42 deletions(-)

diff --git a/yavta.c b/yavta.c
index b9b8bb8..006bab6 100644
--- a/yavta.c
+++ b/yavta.c
@@ -416,12 +416,14 @@ static int query_control(struct device *dev, unsigned int id,
 	query->id = id;
 
 	ret = ioctl(dev->fd, VIDIOC_QUERY_EXT_CTRL, query);
-	if (ret < 0 && errno != EINVAL)
+	if (!ret || errno == EINVAL)
+		return ret;
+
+	if (errno != ENOTTY) {
 		printf("unable to query control 0x%8.8x: %s (%d).\n",
 		       id, strerror(errno), errno);
-
-	if (!ret || errno != ENOTTY)
 		return ret;
+	}
 
 	/*
 	 * If VIDIOC_QUERY_EXT_CTRL isn't available emulate it using
@@ -456,6 +458,7 @@ static int get_control(struct device *dev,
 		       struct v4l2_ext_control *ctrl)
 {
 	struct v4l2_ext_controls ctrls;
+	struct v4l2_control old;
 	int ret;
 
 	memset(&ctrls, 0, sizeof(ctrls));
@@ -467,34 +470,28 @@ static int get_control(struct device *dev,
 
 	ctrl->id = query->id;
 
-	if (query->type == V4L2_CTRL_TYPE_STRING) {
-		ctrl->string = malloc(query->maximum + 1);
-		if (ctrl->string == NULL)
+	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD) {
+		ctrl->size = query->elems * query->elem_size;
+		ctrl->ptr = malloc(ctrl->size);
+		if (ctrl->ptr == NULL)
 			return -ENOMEM;
-
-		ctrl->size = query->maximum + 1;
 	}
 
 	ret = ioctl(dev->fd, VIDIOC_G_EXT_CTRLS, &ctrls);
 	if (ret != -1)
 		return 0;
 
-	if (query->type != V4L2_CTRL_TYPE_INTEGER64 &&
-	    query->type != V4L2_CTRL_TYPE_STRING &&
-	    (errno == EINVAL || errno == ENOTTY)) {
-		struct v4l2_control old;
+	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD ||
+	    query->type == V4L2_CTRL_TYPE_INTEGER64 ||
+	    (errno != EINVAL && errno != ENOTTY))
+		return -1;
 
-		old.id = query->id;
-		ret = ioctl(dev->fd, VIDIOC_G_CTRL, &old);
-		if (ret != -1) {
-			ctrl->value = old.value;
-			return 0;
-		}
-	}
+	old.id = query->id;
+	ret = ioctl(dev->fd, VIDIOC_G_CTRL, &old);
+	if (ret != -1)
+		ctrl->value = old.value;
 
-	printf("unable to get control 0x%8.8x: %s (%d).\n",
-		query->id, strerror(errno), errno);
-	return -1;
+	return ret;
 }
 
 static void set_control(struct device *dev, unsigned int id,
@@ -1087,12 +1084,75 @@ static void video_query_menu(struct device *dev,
 	};
 }
 
+static void video_print_control_array(const struct v4l2_query_ext_ctrl *query,
+				      struct v4l2_ext_control *ctrl)
+{
+	unsigned int i;
+
+	printf("{");
+
+	for (i = 0; i < query->elems; ++i) {
+		switch (query->type) {
+		case V4L2_CTRL_TYPE_U8:
+			printf("%u", ctrl->p_u8[i]);
+			break;
+		case V4L2_CTRL_TYPE_U16:
+			printf("%u", ctrl->p_u16[i]);
+			break;
+		case V4L2_CTRL_TYPE_U32:
+			printf("%u", ctrl->p_u32[i]);
+			break;
+		}
+
+		if (i != query->elems - 1)
+			printf(", ");
+	}
+
+	printf("}");
+}
+
+static void video_print_control_value(const struct v4l2_query_ext_ctrl *query,
+				      struct v4l2_ext_control *ctrl)
+{
+	if (query->nr_of_dims == 0) {
+		switch (query->type) {
+		case V4L2_CTRL_TYPE_INTEGER:
+		case V4L2_CTRL_TYPE_BOOLEAN:
+		case V4L2_CTRL_TYPE_MENU:
+		case V4L2_CTRL_TYPE_INTEGER_MENU:
+			printf("%d", ctrl->value);
+			break;
+		case V4L2_CTRL_TYPE_BITMASK:
+			printf("0x%08x", ctrl->value);
+			break;
+		case V4L2_CTRL_TYPE_INTEGER64:
+			printf("%lld", ctrl->value64);
+			break;
+		case V4L2_CTRL_TYPE_STRING:
+			printf("%s", ctrl->string);
+			break;
+		}
+
+		return;
+	}
+
+	switch (query->type) {
+	case V4L2_CTRL_TYPE_U8:
+	case V4L2_CTRL_TYPE_U16:
+	case V4L2_CTRL_TYPE_U32:
+		video_print_control_array(query, ctrl);
+		break;
+	default:
+		printf("unsupported");
+		break;
+	}
+}
+
 static int video_print_control(struct device *dev, unsigned int id, bool full)
 {
 	struct v4l2_ext_control ctrl;
 	struct v4l2_query_ext_ctrl query;
-	char sval[24];
-	char *current = sval;
+	unsigned int i;
 	int ret;
 
 	ret = query_control(dev, id, &query);
@@ -1107,25 +1167,39 @@ static int video_print_control(struct device *dev, unsigned int id, bool full)
 		return query.id;
 	}
 
-	ret = get_control(dev, &query, &ctrl);
-	if (ret < 0)
-		strcpy(sval, "n/a");
-	else if (query.type == V4L2_CTRL_TYPE_INTEGER64)
-		sprintf(sval, "%lld", ctrl.value64);
-	else if (query.type == V4L2_CTRL_TYPE_STRING)
-		current = ctrl.string;
-	else
-		sprintf(sval, "%d", ctrl.value);
-
-	if (full)
-		printf("control 0x%08x `%s' min %lld max %lld step %lld default %lld current %s.\n",
+	if (full) {
+		printf("control 0x%08x `%s' min %lld max %lld step %lld default %lld ",
 			query.id, query.name, query.minimum, query.maximum,
-			query.step, query.default_value, current);
-	else
-		printf("control 0x%08x current %s.\n", query.id, current);
+			query.step, query.default_value);
+		if (query.nr_of_dims) {
+			for (i = 0; i < query.nr_of_dims; ++i)
+				printf("[%u]", query.dims[i]);
+			printf(" ");
+		}
+	} else {
+		printf("control 0x%08x ", query.id);
+	}
+
+	if (query.type == V4L2_CTRL_TYPE_BUTTON) {
+		/* Button controls have no current value. */
+		printf("\n");
+		return query.id;
+	}
+
+	printf("current ");
+
+	ret = get_control(dev, &query, &ctrl);
+	if (ret < 0) {
+		printf("n/a\n");
+		printf("unable to get control 0x%8.8x: %s (%d).\n",
+			query.id, strerror(errno), errno);
+	} else {
+		video_print_control_value(&query, &ctrl);
+		printf("\n");
+	}
 
-	if (query.type == V4L2_CTRL_TYPE_STRING)
-		free(ctrl.string);
+	if ((query.flags & V4L2_CTRL_FLAG_HAS_PAYLOAD) && ctrl.ptr)
+		free(ctrl.ptr);
 
 	if (!full)
 		return query.id;
@@ -1151,7 +1225,7 @@ static void video_list_controls(struct device *dev)
 #else
 	id = 0;
 	while (1) {
-		id |= V4L2_CTRL_FLAG_NEXT_CTRL;
+		id |= V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND;
 #endif
 
 		ret = video_print_control(dev, id, true);
-- 
2.0.4

