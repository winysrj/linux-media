Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390AbbLQIlI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:08 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 28/48] v4l: Support the request API in format operations
Date: Thu, 17 Dec 2015 10:40:06 +0200
Message-Id: <1450341626-6695-29-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Store the formats in per-entity request data. The get and set format
operations are completely handled by the V4L2 core with help of the try
format driver operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 121 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-dev.h             |  13 ++++
 2 files changed, 134 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 67a4aa760aa3..1143d70d578a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1341,6 +1341,119 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
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
@@ -1388,6 +1501,8 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap_mplane))
 			break;
+		if (p->fmt.pix_mp.request)
+			return v4l_g_req_mplane_fmt(ops, file, fh, p);
 		return ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_overlay))
@@ -1412,6 +1527,8 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_mplane))
 			break;
+		if (p->fmt.pix_mp.request)
+			return v4l_g_req_mplane_fmt(ops, file, fh, p);
 		return ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_overlay))
@@ -1463,6 +1580,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		if (p->fmt.pix_mp.request)
+			return v4l_s_req_mplane_fmt(ops, file, fh, p);
 		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_overlay))
@@ -1491,6 +1610,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		if (p->fmt.pix_mp.request)
+			return v4l_s_req_mplane_fmt(ops, file, fh, p);
 		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_overlay))
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index acbcd2f5fe7f..9fb386a6e505 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -233,4 +233,17 @@ static inline int video_is_registered(struct video_device *vdev)
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
2.4.10

