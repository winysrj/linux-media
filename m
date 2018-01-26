Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:41290 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751812AbeAZGCx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 01:02:53 -0500
Received: by mail-pf0-f196.google.com with SMTP id c6so7588431pfi.8
        for <linux-media@vger.kernel.org>; Thu, 25 Jan 2018 22:02:53 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 4/8] media: vb2: add support for requests in QBUF ioctl
Date: Fri, 26 Jan 2018 15:02:12 +0900
Message-Id: <20180126060216.147918-5-acourbot@chromium.org>
In-Reply-To: <20180126060216.147918-1-acourbot@chromium.org>
References: <20180126060216.147918-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support the request argument of the QBUF ioctl.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 79 +++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index fdd2f784c264..66f2bda4a279 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -29,6 +29,7 @@
 #include <media/v4l2-device.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-mc.h>
+#include <media/media-request.h>
 
 #include <trace/events/v4l2.h>
 
@@ -965,6 +966,67 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 	return -EINVAL;
 }
 
+/*
+ * Validate that a given request can be used during an ioctl.
+ *
+ * When using the request API, request file descriptors must be matched against
+ * the actual request object. User-space can pass any file descriptor, so we
+ * need to make sure the call is valid before going further.
+ *
+ * This function looks up the request and associated data and performs the
+ * following sanity checks:
+ *
+ * * Make sure that the entity belongs to the media_device managing the passed
+ *   request,
+ * * Make sure that the entity data (if any) is associated to the current file
+ *   handler.
+ *
+ * This function returns a pointer to the valid request, or and error code in
+ * case of failure. When successful, a reference to the request is acquired and
+ * must be properly released by the caller.
+ */
+#ifdef CONFIG_MEDIA_CONTROLLER
+static struct media_request *
+check_request(int request, struct file *file, void *fh)
+{
+	struct media_request *req = NULL;
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_fh *vfh =
+		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
+	struct media_entity *entity = &vfd->entity;
+	struct media_request_entity_data *data;
+
+	if (!entity)
+		return ERR_PTR(-EINVAL);
+
+	req = media_request_get_from_fd(request);
+	if (!req)
+		return ERR_PTR(-EINVAL);
+
+	/* Validate that the entity belongs to the correct media_device */
+	if (vfd->v4l2_dev->mdev->req_mgr != req->mgr) {
+		media_request_put(req);
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* Validate that the entity's data belongs to the correct fh */
+	data = media_request_get_entity_data(req, entity, vfh);
+	if (IS_ERR(data)) {
+		media_request_put(req);
+		return ERR_PTR(PTR_ERR(data));
+	}
+
+	return req;
+}
+#else /* CONFIG_MEDIA_CONTROLLER */
+static struct media_request *
+check_request(int request, struct file *file, void *fh)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+#endif /* CONFIG_MEDIA_CONTROLLER */
+
 static void v4l_sanitize_format(struct v4l2_format *fmt)
 {
 	unsigned int offset;
@@ -1902,10 +1964,25 @@ static int v4l_querybuf(const struct v4l2_ioctl_ops *ops,
 static int v4l_qbuf(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct media_request *req = NULL;
 	struct v4l2_buffer *p = arg;
 	int ret = check_fmt(file, p->type);
 
-	return ret ? ret : ops->vidioc_qbuf(file, fh, p);
+	if (ret)
+		return ret;
+
+	if (p->request_fd > 0) {
+		req = check_request(p->request_fd, file, fh);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+	}
+
+	ret = ops->vidioc_qbuf(file, fh, p);
+
+	if (req)
+		media_request_put(req);
+
+	return ret;
 }
 
 static int v4l_dqbuf(const struct v4l2_ioctl_ops *ops,
-- 
2.16.0.rc1.238.g530d649a79-goog
