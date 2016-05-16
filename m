Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52757 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbcEPKC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 06:02:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: sakari.ailus@iki.fi
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/4] Implement compound control set support
Date: Mon, 16 May 2016 13:02:11 +0300
Message-Id: <1463392932-28307-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1463392932-28307-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1463392932-28307-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 217 ++++++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 165 insertions(+), 52 deletions(-)

diff --git a/yavta.c b/yavta.c
index 360c53fc77c5..4b531a0360fe 100644
--- a/yavta.c
+++ b/yavta.c
@@ -19,6 +19,7 @@
 
 #define __STDC_FORMAT_MACROS
 
+#include <ctype.h>
 #include <stdio.h>
 #include <string.h>
 #include <fcntl.h>
@@ -516,59 +517,38 @@ static int get_control(struct device *dev,
 	return ret;
 }
 
-static void set_control(struct device *dev, unsigned int id,
-		        int64_t val)
+static int set_control(struct device *dev,
+		       const struct v4l2_query_ext_ctrl *query,
+		       struct v4l2_ext_control *ctrl)
 {
 	struct v4l2_ext_controls ctrls;
-	struct v4l2_ext_control ctrl;
-	struct v4l2_query_ext_ctrl query;
-	int64_t old_val = val;
-	int is_64;
+	struct v4l2_control old;
 	int ret;
 
-	ret = query_control(dev, id, &query);
-	if (ret < 0)
-		return;
-
-	is_64 = query.type == V4L2_CTRL_TYPE_INTEGER64;
-
 	memset(&ctrls, 0, sizeof(ctrls));
-	memset(&ctrl, 0, sizeof(ctrl));
 
-	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(id);
+	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl->id);
 	ctrls.count = 1;
-	ctrls.controls = &ctrl;
+	ctrls.controls = ctrl;
 
-	ctrl.id = id;
-	if (is_64)
-		ctrl.value64 = val;
-	else
-		ctrl.value = val;
+	ctrl->id = query->id;
 
 	ret = ioctl(dev->fd, VIDIOC_S_EXT_CTRLS, &ctrls);
-	if (ret != -1) {
-		if (is_64)
-			val = ctrl.value64;
-		else
-			val = ctrl.value;
-	} else if (!is_64 && query.type != V4L2_CTRL_TYPE_STRING &&
-		   (errno == EINVAL || errno == ENOTTY)) {
-		struct v4l2_control old;
-
-		old.id = id;
-		old.value = val;
-		ret = ioctl(dev->fd, VIDIOC_S_CTRL, &old);
-		if (ret != -1)
-			val = old.value;
-	}
-	if (ret == -1) {
-		printf("unable to set control 0x%8.8x: %s (%d).\n",
-			id, strerror(errno), errno);
-		return;
-	}
+	if (ret != -1)
+		return 0;
 
-	printf("Control 0x%08x set to %" PRId64 ", is %" PRId64 "\n",
-	       id, old_val, val);
+	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD ||
+	    query->type == V4L2_CTRL_TYPE_INTEGER64 ||
+	    (errno != EINVAL && errno != ENOTTY))
+		return -1;
+
+	old.id = ctrl->id;
+	old.value = ctrl->value;
+	ret = ioctl(dev->fd, VIDIOC_S_CTRL, &old);
+	if (ret != -1)
+		ctrl->value = old.value;
+
+	return ret;
 }
 
 static int video_get_format(struct device *dev)
@@ -1172,7 +1152,7 @@ static void video_print_control_value(const struct v4l2_query_ext_ctrl *query,
 	}
 }
 
-static int video_print_control(struct device *dev, unsigned int id, bool full)
+static int video_get_control(struct device *dev, unsigned int id, bool full)
 {
 	struct v4l2_ext_control ctrl;
 	struct v4l2_query_ext_ctrl query;
@@ -1235,6 +1215,143 @@ static int video_print_control(struct device *dev, unsigned int id, bool full)
 	return query.id;
 }
 
+static int video_parse_control_array(const struct v4l2_query_ext_ctrl *query,
+				     struct v4l2_ext_control *ctrl,
+				     const char *val)
+{
+	unsigned int i;
+	char *endptr;
+	__u32 value;
+
+	for ( ; isspace(*val); ++val) { };
+
+	if (*val++ != '{')
+		return -EINVAL;
+
+	for (i = 0; i < query->elems; ++i) {
+		for ( ; isspace(*val); ++val) { };
+
+		switch (query->type) {
+		case V4L2_CTRL_TYPE_U8:
+		case V4L2_CTRL_TYPE_U16:
+		case V4L2_CTRL_TYPE_U32:
+		default:
+			value = strtoul(val, &endptr, 0);
+			break;
+		}
+
+		if (endptr == NULL)
+			return -EINVAL;
+
+		switch (query->type) {
+		case V4L2_CTRL_TYPE_U8:
+			ctrl->p_u8[i] = value;
+			break;
+		case V4L2_CTRL_TYPE_U16:
+			ctrl->p_u16[i] = value;
+			break;
+		case V4L2_CTRL_TYPE_U32:
+			ctrl->p_u32[i] = value;
+			break;
+		}
+
+		val = endptr;
+		for ( ; isspace(*val); ++val) { };
+
+		if (i != query->elems - 1) {
+			if (*val++ != ',')
+				return -EINVAL;
+			for ( ; isspace(*val); ++val) { };
+		}
+	}
+
+	if (*val++ != '}')
+		return -EINVAL;
+
+	return 0;
+}
+
+static void video_set_control(struct device *dev, unsigned int id,
+			      const char *val)
+{
+	struct v4l2_query_ext_ctrl query;
+	struct v4l2_ext_control ctrl;
+	char *endptr;
+	int ret;
+
+	ret = query_control(dev, id, &query);
+	if (ret < 0)
+		return;
+
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	if (query.nr_of_dims == 0) {
+		switch (query.type) {
+		case V4L2_CTRL_TYPE_INTEGER:
+		case V4L2_CTRL_TYPE_BOOLEAN:
+		case V4L2_CTRL_TYPE_MENU:
+		case V4L2_CTRL_TYPE_INTEGER_MENU:
+		case V4L2_CTRL_TYPE_BITMASK:
+			ctrl.value = strtol(val, &endptr, 0);
+			if (*endptr != 0) {
+				printf("Invalid control value '%s'\n", val);
+				return;
+			}
+			break;
+		case V4L2_CTRL_TYPE_INTEGER64:
+			ctrl.value64 = strtoll(val, &endptr, 0);
+			if (*endptr != 0) {
+				printf("Invalid control value '%s'\n", val);
+				return;
+			}
+			break;
+		case V4L2_CTRL_TYPE_STRING:
+			ctrl.size = query.elem_size;
+			ctrl.ptr = malloc(ctrl.size);
+			if (ctrl.ptr == NULL)
+				return;
+			strncpy(ctrl.string, val, ctrl.size);
+			break;
+		default:
+			printf("Unsupported control type\n");
+			return;
+		}
+	} else {
+		switch (query.type) {
+		case V4L2_CTRL_TYPE_U8:
+		case V4L2_CTRL_TYPE_U16:
+		case V4L2_CTRL_TYPE_U32:
+			ctrl.size = query.elem_size * query.elems;
+			ctrl.ptr = malloc(ctrl.size);
+			if (ctrl.ptr == NULL)
+				return;
+			ret = video_parse_control_array(&query, &ctrl, val);
+			if (ret < 0) {
+				printf("Invalid compound control value '%s'\n", val);
+				return;
+			}
+			break;
+		default:
+			printf("Unsupported control type\n");
+			break;
+		}
+	}
+
+	ret = set_control(dev, &query, &ctrl);
+	if (ret < 0) {
+		printf("unable to set control 0x%8.8x: %s (%d).\n",
+			id, strerror(errno), errno);
+	} else {
+		printf("Control 0x%08x set to %s, is ", id, val);
+
+		video_print_control_value(&query, &ctrl);
+		printf("\n");
+	}
+
+	if ((query.flags & V4L2_CTRL_FLAG_HAS_PAYLOAD) && ctrl.ptr)
+		free(ctrl.ptr);
+}
+
 static void video_list_controls(struct device *dev)
 {
 	unsigned int nctrls = 0;
@@ -1252,7 +1369,7 @@ static void video_list_controls(struct device *dev)
 		id |= V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND;
 #endif
 
-		ret = video_print_control(dev, id, true);
+		ret = video_get_control(dev, id, true);
 		if (ret < 0)
 			break;
 
@@ -1972,7 +2089,7 @@ int main(int argc, char *argv[])
 
 	/* Controls */
 	int ctrl_name = 0;
-	int ctrl_value = 0;
+	const char *ctrl_value = NULL;
 
 	/* Video buffers */
 	enum v4l2_memory memtype = V4L2_MEMORY_MMAP;
@@ -2112,11 +2229,7 @@ int main(int argc, char *argv[])
 				printf("Invalid control name '%s'\n", optarg);
 				return 1;
 			}
-			ctrl_value = strtol(endptr + 1, &endptr, 0);
-			if (*endptr != 0) {
-				printf("Invalid control value '%s'\n", optarg);
-				return 1;
-			}
+			ctrl_value = endptr + 1;
 			do_set_control = 1;
 			break;
 		case OPT_BUFFER_SIZE:
@@ -2228,10 +2341,10 @@ int main(int argc, char *argv[])
 		video_log_status(&dev);
 
 	if (do_get_control)
-		video_print_control(&dev, ctrl_name, false);
+		video_get_control(&dev, ctrl_name, false);
 
 	if (do_set_control)
-		set_control(&dev, ctrl_name, ctrl_value);
+		video_set_control(&dev, ctrl_name, ctrl_value);
 
 	if (do_list_controls)
 		video_list_controls(&dev);
-- 
2.7.3

