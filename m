Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:20623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbaFDLWI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jun 2014 07:22:08 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 1/1] v4l: subdev: Unify argument validation across IOCTLs
Date: Wed,  4 Jun 2014 14:22:03 +0300
Message-Id: <1401880923-31660-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Separate validation of different argument types. There's no reason to do
this separately for every IOCTL.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
since v1:
- Declare rval in the beginning of subdev_do_ioctl().

 drivers/media/v4l2-core/v4l2-subdev.c | 120 +++++++++++++++++++++-------------
 1 file changed, 74 insertions(+), 46 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 058c1a6..d096ef0 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -126,6 +126,55 @@ static int subdev_close(struct file *file)
 	return 0;
 }
 
+static int check_format(struct v4l2_subdev *sd,
+			struct v4l2_subdev_format *format)
+{
+	if (format->which != V4L2_SUBDEV_FORMAT_TRY &&
+	    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
+
+	if (format->pad >= sd->entity.num_pads)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int check_crop(struct v4l2_subdev *sd, struct v4l2_subdev_crop *crop)
+{
+	if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
+	    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
+
+	if (crop->pad >= sd->entity.num_pads)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int check_selection(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_selection *sel)
+{
+	if (sel->which != V4L2_SUBDEV_FORMAT_TRY &&
+	    sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
+
+	if (sel->pad >= sd->entity.num_pads)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int check_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid)
+{
+	if (edid->pad >= sd->entity.num_pads)
+		return -EINVAL;
+
+	if (edid->blocks && edid->edid == NULL)
+		return -EINVAL;
+
+	return 0;
+}
+
 static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
 	struct video_device *vdev = video_devdata(file);
@@ -134,6 +183,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
 #endif
+	int rval;
 
 	switch (cmd) {
 	case VIDIOC_QUERYCTRL:
@@ -203,12 +253,9 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_SUBDEV_G_FMT: {
 		struct v4l2_subdev_format *format = arg;
 
-		if (format->which != V4L2_SUBDEV_FORMAT_TRY &&
-		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
-			return -EINVAL;
-
-		if (format->pad >= sd->entity.num_pads)
-			return -EINVAL;
+		rval = check_format(sd, format);
+		if (rval)
+			return rval;
 
 		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh, format);
 	}
@@ -216,12 +263,9 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_SUBDEV_S_FMT: {
 		struct v4l2_subdev_format *format = arg;
 
-		if (format->which != V4L2_SUBDEV_FORMAT_TRY &&
-		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
-			return -EINVAL;
-
-		if (format->pad >= sd->entity.num_pads)
-			return -EINVAL;
+		rval = check_format(sd, format);
+		if (rval)
+			return rval;
 
 		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh, format);
 	}
@@ -229,14 +273,10 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_SUBDEV_G_CROP: {
 		struct v4l2_subdev_crop *crop = arg;
 		struct v4l2_subdev_selection sel;
-		int rval;
-
-		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
-		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
-			return -EINVAL;
 
-		if (crop->pad >= sd->entity.num_pads)
-			return -EINVAL;
+		rval = check_crop(sd, crop);
+		if (rval)
+			return rval;
 
 		rval = v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
 		if (rval != -ENOIOCTLCMD)
@@ -258,14 +298,10 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_SUBDEV_S_CROP: {
 		struct v4l2_subdev_crop *crop = arg;
 		struct v4l2_subdev_selection sel;
-		int rval;
-
-		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
-		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
-			return -EINVAL;
 
-		if (crop->pad >= sd->entity.num_pads)
-			return -EINVAL;
+		rval = check_crop(sd, crop);
+		if (rval)
+			return rval;
 
 		rval = v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
 		if (rval != -ENOIOCTLCMD)
@@ -336,12 +372,9 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_SUBDEV_G_SELECTION: {
 		struct v4l2_subdev_selection *sel = arg;
 
-		if (sel->which != V4L2_SUBDEV_FORMAT_TRY &&
-		    sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
-			return -EINVAL;
-
-		if (sel->pad >= sd->entity.num_pads)
-			return -EINVAL;
+		rval = check_selection(sd, sel);
+		if (rval)
+			return rval;
 
 		return v4l2_subdev_call(
 			sd, pad, get_selection, subdev_fh, sel);
@@ -350,12 +383,9 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_SUBDEV_S_SELECTION: {
 		struct v4l2_subdev_selection *sel = arg;
 
-		if (sel->which != V4L2_SUBDEV_FORMAT_TRY &&
-		    sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
-			return -EINVAL;
-
-		if (sel->pad >= sd->entity.num_pads)
-			return -EINVAL;
+		rval = check_selection(sd, sel);
+		if (rval)
+			return rval;
 
 		return v4l2_subdev_call(
 			sd, pad, set_selection, subdev_fh, sel);
@@ -364,10 +394,9 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_G_EDID: {
 		struct v4l2_subdev_edid *edid = arg;
 
-		if (edid->pad >= sd->entity.num_pads)
-			return -EINVAL;
-		if (edid->blocks && edid->edid == NULL)
-			return -EINVAL;
+		rval = check_edid(sd, edid);
+		if (rval)
+			return rval;
 
 		return v4l2_subdev_call(sd, pad, get_edid, edid);
 	}
@@ -375,10 +404,9 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_S_EDID: {
 		struct v4l2_subdev_edid *edid = arg;
 
-		if (edid->pad >= sd->entity.num_pads)
-			return -EINVAL;
-		if (edid->blocks && edid->edid == NULL)
-			return -EINVAL;
+		rval = check_edid(sd, edid);
+		if (rval)
+			return rval;
 
 		return v4l2_subdev_call(sd, pad, set_edid, edid);
 	}
-- 
1.8.3.2

