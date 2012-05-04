Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:32517 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab2EDIUl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 May 2012 04:20:41 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 1/3] Support selections API for crop
Date: Fri,  4 May 2012 11:24:41 +0300
Message-Id: <1336119883-14978-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support the new selections API for crop. Fall back to use the old crop API
in case the selection API isn't available.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/main.c       |    4 ++-
 src/v4l2subdev.c |  100 +++++++++++++++++++++++++++++++++++++-----------------
 src/v4l2subdev.h |   37 +++++++++++---------
 3 files changed, 93 insertions(+), 48 deletions(-)

diff --git a/src/main.c b/src/main.c
index 4f3271c..53964e4 100644
--- a/src/main.c
+++ b/src/main.c
@@ -62,7 +62,9 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 	printf("[%s %ux%u", v4l2_subdev_pixelcode_to_string(format.code),
 	       format.width, format.height);
 
-	ret = v4l2_subdev_get_crop(entity, &rect, pad, which);
+	ret = v4l2_subdev_get_selection(entity, &rect, pad,
+					V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL,
+					which);
 	if (ret == 0)
 		printf(" (%u,%u)/%ux%u", rect.left, rect.top,
 		       rect.width, rect.height);
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index b886b72..92360bb 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -104,48 +104,85 @@ int v4l2_subdev_set_format(struct media_entity *entity,
 	return 0;
 }
 
-int v4l2_subdev_get_crop(struct media_entity *entity, struct v4l2_rect *rect,
-			 unsigned int pad, enum v4l2_subdev_format_whence which)
+int v4l2_subdev_get_selection(
+	struct media_entity *entity, struct v4l2_rect *r,
+	unsigned int pad, int target, enum v4l2_subdev_format_whence which)
 {
-	struct v4l2_subdev_crop crop;
+	union {
+		struct v4l2_subdev_selection sel;
+		struct v4l2_subdev_crop crop;
+	} u;
 	int ret;
 
 	ret = v4l2_subdev_open(entity);
 	if (ret < 0)
 		return ret;
 
-	memset(&crop, 0, sizeof(crop));
-	crop.pad = pad;
-	crop.which = which;
+	memset(&u.sel, 0, sizeof(u.sel));
+	u.sel.pad = pad;
+	u.sel.target = target;
+	u.sel.which = which;
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_CROP, &crop);
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_SELECTION, &u.sel);
+ 	if (ret >= 0) {
+		*r = u.sel.r;
+		return 0;
+	}
+	if (errno != ENOTTY
+	    || target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL)
+ 		return -errno;
+
+	memset(&u.crop, 0, sizeof(u.crop));
+	u.crop.pad = pad;
+	u.crop.which = which;
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_CROP, &u.crop);
 	if (ret < 0)
 		return -errno;
 
-	*rect = crop.rect;
+	*r = u.crop.rect;
 	return 0;
 }
 
-int v4l2_subdev_set_crop(struct media_entity *entity, struct v4l2_rect *rect,
-			 unsigned int pad, enum v4l2_subdev_format_whence which)
+int v4l2_subdev_set_selection(
+	struct media_entity *entity, struct v4l2_rect *r,
+	unsigned int pad, int target, enum v4l2_subdev_format_whence which)
 {
-	struct v4l2_subdev_crop crop;
+	union {
+		struct v4l2_subdev_selection sel;
+		struct v4l2_subdev_crop crop;
+	} u;
 	int ret;
 
 	ret = v4l2_subdev_open(entity);
 	if (ret < 0)
 		return ret;
 
-	memset(&crop, 0, sizeof(crop));
-	crop.pad = pad;
-	crop.which = which;
-	crop.rect = *rect;
+	memset(&u.sel, 0, sizeof(u.sel));
+	u.sel.pad = pad;
+	u.sel.target = target;
+	u.sel.which = which;
+	u.sel.r = *r;
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_SELECTION, &u.sel);
+ 	if (ret >= 0) {
+		*r = u.sel.r;
+		return 0;
+	}
+	if (errno != ENOTTY
+	    || target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL)
+ 		return -errno;
+
+	memset(&u.crop, 0, sizeof(u.crop));
+	u.crop.pad = pad;
+	u.crop.which = which;
+	u.crop.rect = *r;
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_CROP, &crop);
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_CROP, &u.crop);
 	if (ret < 0)
 		return -errno;
 
-	*rect = crop.rect;
+	*r = u.crop.rect;
 	return 0;
 }
 
@@ -355,30 +392,31 @@ static int set_format(struct media_pad *pad,
 	return 0;
 }
 
-static int set_crop(struct media_pad *pad, struct v4l2_rect *crop)
+static int set_selection(struct media_pad *pad, int tgt,
+			 struct v4l2_rect *rect)
 {
 	int ret;
 
-	if (crop->left == -1 || crop->top == -1)
+	if (rect->left == -1 || rect->top == -1)
 		return 0;
 
 	media_dbg(pad->entity->media,
-		  "Setting up crop rectangle (%u,%u)/%ux%u on pad %s/%u\n",
-		  crop->left, crop->top, crop->width, crop->height,
+		  "Setting up selection target %d rectangle (%u,%u)/%ux%u on pad %s/%u\n",
+		  tgt, rect->left, rect->top, rect->width, rect->height,
 		  pad->entity->info.name, pad->index);
 
-	ret = v4l2_subdev_set_crop(pad->entity, crop, pad->index,
-				   V4L2_SUBDEV_FORMAT_ACTIVE);
+	ret = v4l2_subdev_set_selection(pad->entity, rect, pad->index,
+					tgt, V4L2_SUBDEV_FORMAT_ACTIVE);
 	if (ret < 0) {
 		media_dbg(pad->entity->media,
-			  "Unable to set crop rectangle: %s (%d)\n",
+			  "Unable to set selection rectangle: %s (%d)\n",
 			  strerror(-ret), ret);
 		return ret;
 	}
 
 	media_dbg(pad->entity->media,
-		  "Crop rectangle set: (%u,%u)/%ux%u\n",
-		  crop->left, crop->top, crop->width, crop->height);
+		  "Selection rectangle set: (%u,%u)/%ux%u\n",
+		  rect->left, rect->top, rect->width, rect->height);
 
 	return 0;
 }
@@ -429,18 +467,18 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
 		return -EINVAL;
 	}
 
-	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
-		ret = set_crop(pad, &crop);
+	if (pad->flags & MEDIA_PAD_FL_SINK) {
+		ret = set_format(pad, &format);
 		if (ret < 0)
 			return ret;
 	}
 
-	ret = set_format(pad, &format);
+	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL, &crop);
 	if (ret < 0)
 		return ret;
 
-	if (pad->flags & MEDIA_PAD_FL_SINK) {
-		ret = set_crop(pad, &crop);
+	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
+		ret = set_format(pad, &format);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/src/v4l2subdev.h b/src/v4l2subdev.h
index 1e75f94..1020747 100644
--- a/src/v4l2subdev.h
+++ b/src/v4l2subdev.h
@@ -88,34 +88,38 @@ int v4l2_subdev_set_format(struct media_entity *entity,
 	enum v4l2_subdev_format_whence which);
 
 /**
- * @brief Retrieve the crop rectangle on a pad.
+ * @brief Retrieve a selection rectangle on a pad.
  * @param entity - subdev-device media entity.
- * @param rect - crop rectangle to be filled.
+ * @param r - rectangle to be filled.
  * @param pad - pad number.
+ * @param target - selection target
  * @param which - identifier of the format to get.
  *
- * Retrieve the current crop rectangleon the @a entity @a pad and store it in
- * the @a rect structure.
+ * Retrieve the @a target selection rectangle on the @a entity @a pad
+ * and store it in the @a rect structure.
  *
- * @a which is set to V4L2_SUBDEV_FORMAT_TRY to retrieve the try crop rectangle
- * stored in the file handle, of V4L2_SUBDEV_FORMAT_ACTIVE to retrieve the
- * current active crop rectangle.
+ * @a which is set to V4L2_SUBDEV_FORMAT_TRY to retrieve the try
+ * selection rectangle stored in the file handle, of
+ * V4L2_SUBDEV_FORMAT_ACTIVE to retrieve the current active selection
+ * rectangle.
  *
  * @return 0 on success, or a negative error code on failure.
  */
-int v4l2_subdev_get_crop(struct media_entity *entity, struct v4l2_rect *rect,
-	unsigned int pad, enum v4l2_subdev_format_whence which);
+int v4l2_subdev_get_selection(
+	struct media_entity *entity, struct v4l2_rect *r,
+	unsigned int pad, int target, enum v4l2_subdev_format_whence which);
 
 /**
- * @brief Set the crop rectangle on a pad.
+ * @brief Set a selection rectangle on a pad.
  * @param entity - subdev-device media entity.
- * @param rect - crop rectangle.
+ * @param r - crop rectangle.
  * @param pad - pad number.
+ * @param target - selection target
  * @param which - identifier of the format to set.
  *
- * Set the crop rectangle on the @a entity @a pad to @a rect. The driver is
- * allowed to modify the requested rectangle, in which case @a rect is updated
- * with the modifications.
+ * Set the @a target selection rectangle on the @a entity @a pad to @a
+ * rect. The driver is allowed to modify the requested rectangle, in
+ * which case @a rect is updated with the modifications.
  *
  * @a which is set to V4L2_SUBDEV_FORMAT_TRY to set the try crop rectangle
  * stored in the file handle, of V4L2_SUBDEV_FORMAT_ACTIVE to configure the
@@ -123,8 +127,9 @@ int v4l2_subdev_get_crop(struct media_entity *entity, struct v4l2_rect *rect,
  *
  * @return 0 on success, or a negative error code on failure.
  */
-int v4l2_subdev_set_crop(struct media_entity *entity, struct v4l2_rect *rect,
-	unsigned int pad, enum v4l2_subdev_format_whence which);
+int v4l2_subdev_set_selection(
+	struct media_entity *entity, struct v4l2_rect *r,
+	unsigned int pad, int target, enum v4l2_subdev_format_whence which);
 
 /**
  * @brief Retrieve the frame interval on a sub-device.
-- 
1.7.2.5

