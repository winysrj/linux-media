Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40731 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471AbcEXQvC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:51:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC v2 11/21] v4l: subdev: Support the request API in format and selection operations
Date: Tue, 24 May 2016 19:47:21 +0300
Message-Id: <1464108451-28142-12-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Store the formats and selection rectangles in per-entity request data.
This minimizes changes to drivers by reusing the v4l2_subdev_pad_config
infrastructure.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Replace three if's for testing the same variable by a switch.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 225 +++++++++++++++++++++++++---------
 include/media/v4l2-subdev.h           |  11 ++
 2 files changed, 180 insertions(+), 56 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 224ea60..b8e91a6 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -128,39 +128,182 @@ static int subdev_close(struct file *file)
 }
 
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
-static int check_format(struct v4l2_subdev *sd,
-			struct v4l2_subdev_format *format)
+static void subdev_request_data_release(struct media_entity_request_data *data)
 {
-	if (format->which != V4L2_SUBDEV_FORMAT_TRY &&
-	    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
-		return -EINVAL;
+	struct v4l2_subdev_request_data *sddata =
+		to_v4l2_subdev_request_data(data);
 
-	if (format->pad >= sd->entity.num_pads)
-		return -EINVAL;
+	kfree(sddata->pad);
+	kfree(sddata);
+}
 
-	return 0;
+static struct v4l2_subdev_pad_config *
+subdev_request_pad_config(struct v4l2_subdev *sd,
+			  struct media_device_request *req)
+{
+	struct media_entity_request_data *data;
+	struct v4l2_subdev_request_data *sddata;
+
+	data = media_device_request_get_entity_data(req, &sd->entity);
+	if (data) {
+		sddata = to_v4l2_subdev_request_data(data);
+		return sddata->pad;
+	}
+
+	sddata = kzalloc(sizeof(*sddata), GFP_KERNEL);
+	if (!sddata)
+		return ERR_PTR(-ENOMEM);
+
+	sddata->data.release = subdev_request_data_release;
+
+	sddata->pad = v4l2_subdev_alloc_pad_config(sd);
+	if (sddata->pad == NULL) {
+		kfree(sddata);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	media_device_request_set_entity_data(req, &sd->entity, &sddata->data);
+
+	return sddata->pad;
 }
 
-static int check_crop(struct v4l2_subdev *sd, struct v4l2_subdev_crop *crop)
+static int subdev_prepare_pad_config(struct v4l2_subdev *sd,
+				     struct v4l2_subdev_fh *fh,
+				     enum v4l2_subdev_format_whence which,
+				     unsigned int pad, unsigned int req_id,
+				     struct media_device_request **_req,
+				     struct v4l2_subdev_pad_config **_cfg)
 {
-	if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
-	    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+	struct v4l2_subdev_pad_config *cfg;
+	struct media_device_request *req;
+
+	if (pad >= sd->entity.num_pads)
 		return -EINVAL;
 
-	if (crop->pad >= sd->entity.num_pads)
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		*_req = NULL;
+		*_cfg = NULL;
+		return 0;
+	case V4L2_SUBDEV_FORMAT_TRY:
+		*_req = NULL;
+		*_cfg = fh->pad;
+		return 0;
+	case V4L2_SUBDEV_FORMAT_REQUEST:
+		if (!sd->v4l2_dev->mdev)
+			return -EINVAL;
+
+		req = media_device_request_find(sd->v4l2_dev->mdev, req_id);
+		if (!req)
+			return -EINVAL;
+
+		cfg = subdev_request_pad_config(sd, req);
+		if (IS_ERR(cfg)) {
+			media_device_request_put(req);
+			return PTR_ERR(cfg);
+		}
+
+		*_req = req;
+		*_cfg = cfg;
+
+		return 0;
+	default:
 		return -EINVAL;
+	}
 
-	return 0;
 }
 
-static int check_selection(struct v4l2_subdev *sd,
-			   struct v4l2_subdev_selection *sel)
+static int subdev_get_format(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_format *format)
+{
+	struct v4l2_subdev_pad_config *cfg;
+	struct media_device_request *req;
+	int ret;
+
+	ret = subdev_prepare_pad_config(sd, fh, format->which, format->pad,
+					format->request, &req, &cfg);
+	if (ret < 0)
+		return ret;
+
+	ret = v4l2_subdev_call(sd, pad, get_fmt, cfg, format);
+
+	if (req)
+		media_device_request_put(req);
+
+	return ret;
+}
+
+static int subdev_set_format(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_format *format)
+{
+	struct v4l2_subdev_pad_config *cfg;
+	struct media_device_request *req;
+	int ret;
+
+	ret = subdev_prepare_pad_config(sd, fh, format->which, format->pad,
+					format->request, &req, &cfg);
+	if (ret < 0)
+		return ret;
+
+	ret = v4l2_subdev_call(sd, pad, set_fmt, cfg, format);
+
+	if (req)
+		media_device_request_put(req);
+
+	return ret;
+}
+
+static int subdev_get_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_selection *sel)
+{
+	struct v4l2_subdev_pad_config *cfg;
+	struct media_device_request *req;
+	int ret;
+
+	ret = subdev_prepare_pad_config(sd, fh, sel->which, sel->pad,
+					sel->request, &req, &cfg);
+	if (ret < 0)
+		return ret;
+
+	ret = v4l2_subdev_call(sd, pad, get_selection, cfg, sel);
+
+	if (req)
+		media_device_request_put(req);
+
+	return ret;
+}
+
+static int subdev_set_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_selection *sel)
+{
+	struct v4l2_subdev_pad_config *cfg;
+	struct media_device_request *req;
+	int ret;
+
+	ret = subdev_prepare_pad_config(sd, fh, sel->which, sel->pad,
+					sel->request, &req, &cfg);
+	if (ret < 0)
+		return ret;
+
+	ret = v4l2_subdev_call(sd, pad, set_selection, cfg, sel);
+
+	if (req)
+		media_device_request_put(req);
+
+	return ret;
+}
+
+static int check_crop(struct v4l2_subdev *sd, struct v4l2_subdev_crop *crop)
 {
-	if (sel->which != V4L2_SUBDEV_FORMAT_TRY &&
-	    sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+	if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
+	    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
 		return -EINVAL;
 
-	if (sel->pad >= sd->entity.num_pads)
+	if (crop->pad >= sd->entity.num_pads)
 		return -EINVAL;
 
 	return 0;
@@ -256,25 +399,11 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	}
 
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
-	case VIDIOC_SUBDEV_G_FMT: {
-		struct v4l2_subdev_format *format = arg;
+	case VIDIOC_SUBDEV_G_FMT:
+		return subdev_get_format(sd, subdev_fh, arg);
 
-		rval = check_format(sd, format);
-		if (rval)
-			return rval;
-
-		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh->pad, format);
-	}
-
-	case VIDIOC_SUBDEV_S_FMT: {
-		struct v4l2_subdev_format *format = arg;
-
-		rval = check_format(sd, format);
-		if (rval)
-			return rval;
-
-		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh->pad, format);
-	}
+	case VIDIOC_SUBDEV_S_FMT:
+		return subdev_set_format(sd, subdev_fh, arg);
 
 	case VIDIOC_SUBDEV_G_CROP: {
 		struct v4l2_subdev_crop *crop = arg;
@@ -379,27 +508,11 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 					fie);
 	}
 
-	case VIDIOC_SUBDEV_G_SELECTION: {
-		struct v4l2_subdev_selection *sel = arg;
-
-		rval = check_selection(sd, sel);
-		if (rval)
-			return rval;
-
-		return v4l2_subdev_call(
-			sd, pad, get_selection, subdev_fh->pad, sel);
-	}
-
-	case VIDIOC_SUBDEV_S_SELECTION: {
-		struct v4l2_subdev_selection *sel = arg;
-
-		rval = check_selection(sd, sel);
-		if (rval)
-			return rval;
+	case VIDIOC_SUBDEV_G_SELECTION:
+		return subdev_get_selection(sd, subdev_fh, arg);
 
-		return v4l2_subdev_call(
-			sd, pad, set_selection, subdev_fh->pad, sel);
-	}
+	case VIDIOC_SUBDEV_S_SELECTION:
+		return subdev_set_selection(sd, subdev_fh, arg);
 
 	case VIDIOC_G_EDID: {
 		struct v4l2_subdev_edid *edid = arg;
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 32fc7a4..ca92e2c 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -808,6 +808,17 @@ int v4l2_subdev_link_validate(struct media_link *link);
 struct v4l2_subdev_pad_config *
 v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd);
 void v4l2_subdev_free_pad_config(struct v4l2_subdev_pad_config *cfg);
+
+struct v4l2_subdev_request_data {
+	struct media_entity_request_data data;
+	struct v4l2_subdev_pad_config *pad;
+};
+
+static inline struct v4l2_subdev_request_data *
+to_v4l2_subdev_request_data(struct media_entity_request_data *data)
+{
+	return container_of(data, struct v4l2_subdev_request_data, data);
+}
 #endif /* CONFIG_MEDIA_CONTROLLER */
 
 void v4l2_subdev_init(struct v4l2_subdev *sd,
-- 
1.9.1

