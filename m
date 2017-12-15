Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34379 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754251AbdLOH5G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 02:57:06 -0500
Received: by mail-pg0-f65.google.com with SMTP id j4so5299633pgp.1
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 23:57:06 -0800 (PST)
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
Subject: [RFC PATCH 6/9] media: vb2: add support for requests in QBUF ioctl
Date: Fri, 15 Dec 2017 16:56:22 +0900
Message-Id: <20171215075625.27028-7-acourbot@chromium.org>
In-Reply-To: <20171215075625.27028-1-acourbot@chromium.org>
References: <20171215075625.27028-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support the request argument of the QBUF ioctl.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 93 +++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 8d041247e97f..28f9c368563e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -29,6 +29,7 @@
 #include <media/v4l2-device.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-mc.h>
+#include <media/media-request.h>
 
 #include <trace/events/v4l2.h>
 
@@ -965,6 +966,81 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
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
+ * * Make sure that the entity supports requests,
+ * * Make sure that the entity belongs to the media_device managing the passed
+ *   request,
+ * * Make sure that the entity data (if any) is associated to the current file
+ *   handler.
+ *
+ * This function returns a pointer to the valid request, or and error code in
+ * case of failure. When successful, a reference to the request is acquired and
+ * must be properly released.
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
+	const struct media_entity *ent;
+	struct media_request_entity_data *data;
+	bool found = false;
+
+	if (!entity)
+		return ERR_PTR(-EINVAL);
+
+	/* Check that the entity supports requests */
+	if (!entity->req_ops)
+		return ERR_PTR(-ENOTSUPP);
+
+	req = media_request_get_from_fd(request);
+	if (!req)
+		return ERR_PTR(-EINVAL);
+
+	/* Validate that the entity belongs to the media_device managing
+	 * the request queue */
+	media_device_for_each_entity(ent, req->queue->mdev) {
+		if (entity == ent) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
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
+	return ERR_PTR(-ENOTSUPP);
+}
+
+#endif /* CONFIG_MEDIA_CONTROLLER */
+
 static void v4l_sanitize_format(struct v4l2_format *fmt)
 {
 	unsigned int offset;
@@ -1902,10 +1978,25 @@ static int v4l_querybuf(const struct v4l2_ioctl_ops *ops,
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
+	if (p->request > 0) {
+		req = check_request(p->request, file, fh);
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
2.15.1.504.g5279b80103-goog
