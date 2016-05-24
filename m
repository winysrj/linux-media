Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:40517 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461AbcEXQvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:51:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC v2 10/21] v4l: Support the request API in format operations
Date: Tue, 24 May 2016 19:47:20 +0300
Message-Id: <1464108451-28142-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Store the formats in per-entity request data. The get and set format
operations are completely handled by the V4L2 core with help of the try
format driver operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 121 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-dev.h             |  13 ++++
 2 files changed, 134 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index bf15580..533fac6 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1355,6 +1355,119 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 	return ret;
 }
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+static void vdev_request_data_release(struct media_entity_request_data *data)
+{
+	struct video_device_request_data *vdata =
+		to_video_device_request_data(data);
+
+	kfree(vdata);
+}
+
+static int vdev_request_format(struct video_device *vdev, unsigned int req_id,
+			       struct media_device_request **_req,
+			       struct v4l2_pix_format_mplane **_fmt)
+{
+	struct media_entity_request_data *data;
+	struct video_device_request_data *vdata;
+	struct media_device_request *req;
+
+	if (!vdev->v4l2_dev || !vdev->v4l2_dev->mdev)
+		return -EINVAL;
+
+	req = media_device_request_find(vdev->v4l2_dev->mdev, req_id);
+	if (!req)
+		return -EINVAL;
+
+	*_req = req;
+
+	data = media_device_request_get_entity_data(req, &vdev->entity);
+	if (data) {
+		vdata = to_video_device_request_data(data);
+		*_fmt = &vdata->format;
+		return 0;
+	}
+
+	vdata = kzalloc(sizeof(*vdata), GFP_KERNEL);
+	if (!vdata) {
+		media_device_request_put(req);
+		return -ENOMEM;
+	}
+
+	vdata->data.release = vdev_request_data_release;
+
+	media_device_request_set_entity_data(req, &vdev->entity, &vdata->data);
+
+	*_fmt = &vdata->format;
+	return 0;
+}
+
+static int v4l_g_req_mplane_fmt(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh,
+				struct v4l2_format *fmt)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_pix_format_mplane *format;
+	struct media_device_request *req;
+	int ret;
+
+	ret = vdev_request_format(vdev, fmt->fmt.pix_mp.request,
+				  &req, &format);
+	if (ret < 0)
+		return ret;
+
+	fmt->fmt.pix_mp = *format;
+	media_device_request_put(req);
+	return 0;
+}
+
+static int v4l_s_req_mplane_fmt(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh,
+				struct v4l2_format *fmt)
+{
+	int (*try_op)(struct file *file, void *fh, struct v4l2_format *fmt);
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_pix_format_mplane *format;
+	struct media_device_request *req;
+	int ret;
+
+	if (fmt->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		try_op = ops->vidioc_try_fmt_vid_cap_mplane;
+	else
+		try_op = ops->vidioc_try_fmt_vid_out_mplane;
+
+	if (unlikely(!try_op))
+		return -ENOSYS;
+
+	ret = try_op(file, fh, fmt);
+	if (ret < 0)
+		return ret;
+
+	ret = vdev_request_format(vdev, fmt->fmt.pix_mp.request,
+				  &req, &format);
+	if (ret < 0)
+		return ret;
+
+	*format = fmt->fmt.pix_mp;
+	media_device_request_put(req);
+	return 0;
+}
+#else
+static int v4l_g_req_mplane_fmt(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh,
+				struct v4l2_format *fmt)
+{
+	return -ENOSYS;
+}
+
+static int v4l_s_req_mplane_fmt(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh,
+				struct v4l2_format *fmt)
+{
+	return -ENOSYS;
+}
+#endif
+
 static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -1402,6 +1515,8 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap_mplane))
 			break;
+		if (p->fmt.pix_mp.request)
+			return v4l_g_req_mplane_fmt(ops, file, fh, p);
 		return ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_overlay))
@@ -1426,6 +1541,8 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_mplane))
 			break;
+		if (p->fmt.pix_mp.request)
+			return v4l_g_req_mplane_fmt(ops, file, fh, p);
 		return ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_overlay))
@@ -1480,6 +1597,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		if (p->fmt.pix_mp.request)
+			return v4l_s_req_mplane_fmt(ops, file, fh, p);
 		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_overlay))
@@ -1508,6 +1627,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		if (p->fmt.pix_mp.request)
+			return v4l_s_req_mplane_fmt(ops, file, fh, p);
 		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_overlay))
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 25a3190..19c7702 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -238,4 +238,17 @@ static inline int video_is_registered(struct video_device *vdev)
 	return test_bit(V4L2_FL_REGISTERED, &vdev->flags);
 }
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+struct video_device_request_data {
+	struct media_entity_request_data data;
+	struct v4l2_pix_format_mplane format;
+};
+
+static inline struct video_device_request_data *
+to_video_device_request_data(struct media_entity_request_data *data)
+{
+	return container_of(data, struct video_device_request_data, data);
+}
+#endif
+
 #endif /* _V4L2_DEV_H */
-- 
1.9.1

