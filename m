Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:16441 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759882Ab2DLIhg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Apr 2012 04:37:36 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH 2/3] Support extended controls, including 64-bit integers.
Date: Thu, 12 Apr 2012 11:41:34 +0300
Message-Id: <1334220095-1698-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1334220095-1698-1-git-send-email-sakari.ailus@iki.fi>
References: <1334220095-1698-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fall back to regular S_CTRL / G_CTRL if extended controls aren't available.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |  129 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 100 insertions(+), 29 deletions(-)

diff --git a/yavta.c b/yavta.c
index 8db6e1e..532fb1f 100644
--- a/yavta.c
+++ b/yavta.c
@@ -249,40 +249,104 @@ static void video_close(struct device *dev)
 	close(dev->fd);
 }
 
-static void uvc_get_control(struct device *dev, unsigned int id)
+static unsigned int get_control_type(struct device *dev, unsigned int id)
 {
-	struct v4l2_control ctrl;
+	struct v4l2_queryctrl query;
+	int ret;
+
+	memset(&query, 0, sizeof(query));
+
+	query.id = id;
+	ret = ioctl(dev->fd, VIDIOC_QUERYCTRL, &query);
+	if (ret == -1)
+		return V4L2_CTRL_TYPE_INTEGER;
+
+	return query.type;
+}
+
+static int get_control(struct device *dev, unsigned int id, int type,
+		       int64_t *val)
+{
+	struct v4l2_ext_controls ctrls;
+	struct v4l2_ext_control ctrl;
 	int ret;
+	
+	memset(&ctrls, 0, sizeof(ctrls));
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(id);
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
 
 	ctrl.id = id;
 
-	ret = ioctl(dev->fd, VIDIOC_G_CTRL, &ctrl);
-	if (ret < 0) {
-		printf("unable to get control: %s (%d).\n",
-			strerror(errno), errno);
-		return;
+	ret = ioctl(dev->fd, VIDIOC_G_EXT_CTRLS, &ctrls);
+	if (ret != -1) {
+		if (type == V4L2_CTRL_TYPE_INTEGER64)
+			*val = ctrl.value64;
+		else
+			*val = ctrl.value;
+		return 0;
+	}
+	if (errno == EINVAL || errno == ENOTTY) {
+		struct v4l2_control old;
+
+		old.id = id;
+		ret = ioctl(dev->fd, VIDIOC_G_CTRL, &old);
+		if (ret != -1) {
+			*val = old.value;
+			return 0;
+		}
 	}
 
-	printf("Control 0x%08x value %u\n", id, ctrl.value);
+	printf("unable to get control 0x%8.8x: %s (%d).\n",
+		id, strerror(errno), errno);
+	return -1;
 }
 
-static void uvc_set_control(struct device *dev, unsigned int id, int value)
+static void set_control(struct device *dev, unsigned int id, int type,
+		        int64_t val)
 {
-	struct v4l2_control ctrl;
+	struct v4l2_ext_controls ctrls;
+	struct v4l2_ext_control ctrl;
+	int is_64 = type == V4L2_CTRL_TYPE_INTEGER64;
+	int64_t old_val = val;
 	int ret;
+	
+	memset(&ctrls, 0, sizeof(ctrls));
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(id);
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
 
 	ctrl.id = id;
-	ctrl.value = value;
+	if (is_64)
+		ctrl.value64 = val;
+	else
+		ctrl.value = val;
 
-	ret = ioctl(dev->fd, VIDIOC_S_CTRL, &ctrl);
-	if (ret < 0) {
-		printf("unable to set control: %s (%d).\n",
-			strerror(errno), errno);
+	ret = ioctl(dev->fd, VIDIOC_S_EXT_CTRLS, &ctrls);
+	if (ret != -1) {
+		if (is_64)
+			val = ctrl.value64;
+		else
+			val = ctrl.value;
+	} else if (errno == EINVAL || errno == ENOTTY) {
+		struct v4l2_control old;
+
+		old.id = id;
+		ret = ioctl(dev->fd, VIDIOC_S_CTRL, &old);
+		if (ret != -1)
+			val = old.value;
+	}
+	if (ret == -1) {
+		printf("unable to set control 0x%8.8x: %s (%d).\n",
+			id, strerror(errno), errno);
 		return;
 	}
-
-	printf("Control 0x%08x set to %u, is %u\n", id, value,
-		ctrl.value);
+	
+	printf("Control 0x%08x set to %lld, is %lld\n", id, old_val, val);
 }
 
 static int video_get_format(struct device *dev)
@@ -588,7 +652,8 @@ static void video_list_controls(struct device *dev)
 	struct v4l2_queryctrl query;
 	struct v4l2_control ctrl;
 	unsigned int nctrls = 0;
-	char value[12];
+	char value[24];
+	int64_t val64;
 	int ret;
 
 #ifndef V4L2_CTRL_FLAG_NEXT_CTRL
@@ -608,18 +673,17 @@ static void video_list_controls(struct device *dev)
 		if (query.flags & V4L2_CTRL_FLAG_DISABLED)
 			continue;
 
-		ctrl.id = query.id;
-		ret = ioctl(dev->fd, VIDIOC_G_CTRL, &ctrl);
-		if (ret < 0)
-			strcpy(value, "n/a");
-		else
-			sprintf(value, "%d", ctrl.value);
-
 		if (query.type == V4L2_CTRL_TYPE_CTRL_CLASS) {
 			printf("--- %s (class 0x%08x) ---\n", query.name, query.id);
 			continue;
 		}
 
+		ret = get_control(dev, query.id, query.type, &val64);
+		if (ret < 0)
+			strcpy(value, "n/a");
+		else
+			sprintf(value, "%d", val64);
+
 		printf("control 0x%08x `%s' min %d max %d step %d default %d current %s.\n",
 			query.id, query.name, query.minimum, query.maximum,
 			query.step, query.default_value, value);
@@ -1420,10 +1484,17 @@ int main(int argc, char *argv[])
 
 	dev.memtype = memtype;
 
-	if (do_get_control)
-		uvc_get_control(&dev, ctrl_name);
+	if (do_get_control) {
+		int64_t val;
+		ret = get_control(&dev, ctrl_name, 
+				  get_control_type(&dev, ctrl_name), &val);
+		if (ret >= 0)
+			printf("Control 0x%08x value %lld\n", ctrl_name, val);
+	}
+		
 	if (do_set_control)
-		uvc_set_control(&dev, ctrl_name, ctrl_value);
+		set_control(&dev, ctrl_name, get_control_type(&dev, ctrl_name),
+			    ctrl_value);
 
 	if (do_list_controls)
 		video_list_controls(&dev);
-- 
1.7.2.5

