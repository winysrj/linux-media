Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:48574 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729508AbeHDOqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Aug 2018 10:46:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv17 26/34] videobuf2-v4l2: add vb2_request_queue/validate helpers
Date: Sat,  4 Aug 2018 14:45:18 +0200
Message-Id: <20180804124526.46206-27-hverkuil@xs4all.nl>
In-Reply-To: <20180804124526.46206-1-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The generic vb2_request_validate helper function checks if
there are buffers in the request and if so, prepares (validates)
all objects in the request.

The generic vb2_request_queue helper function queues all buffer
objects in the validated request.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/common/videobuf2/videobuf2-v4l2.c   | 44 +++++++++++++++++++
 include/media/videobuf2-v4l2.h                |  4 ++
 2 files changed, 48 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 9c652afa62ab..88d8f60c742b 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -1100,6 +1100,50 @@ void vb2_ops_wait_finish(struct vb2_queue *vq)
 }
 EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
 
+int vb2_request_validate(struct media_request *req)
+{
+	struct media_request_object *obj;
+	int ret = 0;
+
+	if (!vb2_request_has_buffers(req))
+		return -ENOENT;
+
+	list_for_each_entry(obj, &req->objects, list) {
+		if (!obj->ops->prepare)
+			continue;
+
+		ret = obj->ops->prepare(obj);
+		if (ret)
+			break;
+	}
+
+	if (ret) {
+		list_for_each_entry_continue_reverse(obj, &req->objects, list)
+			if (obj->ops->unprepare)
+				obj->ops->unprepare(obj);
+		return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_request_validate);
+
+void vb2_request_queue(struct media_request *req)
+{
+	struct media_request_object *obj, *obj_safe;
+
+	/* Queue all non-buffer objects */
+	list_for_each_entry_safe(obj, obj_safe, &req->objects, list)
+		if (obj->ops->queue && !vb2_request_object_is_buffer(obj))
+			obj->ops->queue(obj);
+
+	/* Queue all buffer objects */
+	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
+		if (obj->ops->queue && vb2_request_object_is_buffer(obj))
+			obj->ops->queue(obj);
+	}
+}
+EXPORT_SYMBOL_GPL(vb2_request_queue);
+
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
 MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 91a2b3e1a642..727855463838 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -303,4 +303,8 @@ void vb2_ops_wait_prepare(struct vb2_queue *vq);
  */
 void vb2_ops_wait_finish(struct vb2_queue *vq);
 
+struct media_request;
+int vb2_request_validate(struct media_request *req);
+void vb2_request_queue(struct media_request *req);
+
 #endif /* _MEDIA_VIDEOBUF2_V4L2_H */
-- 
2.18.0
