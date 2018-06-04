Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:46092 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752832AbeFDLrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 24/35] videobuf2-v4l2: add vb2_request_queue/validate helpers
Date: Mon,  4 Jun 2018 13:46:37 +0200
Message-Id: <20180604114648.26159-25-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
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
 .../media/common/videobuf2/videobuf2-v4l2.c   | 38 +++++++++++++++++++
 include/media/videobuf2-v4l2.h                |  4 ++
 2 files changed, 42 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 9c652afa62ab..499b2ab3d1fa 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -1100,6 +1100,44 @@ void vb2_ops_wait_finish(struct vb2_queue *vq)
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
+	struct media_request_object *obj;
+
+	list_for_each_entry(obj, &req->objects, list) {
+		if (obj->ops->queue)
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
2.17.0
