Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:57440 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752314AbeDIOUg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Apr 2018 10:20:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv11 PATCH 22/29] videobuf2-v4l2: add vb2_request_queue helper
Date: Mon,  9 Apr 2018 16:20:19 +0200
Message-Id: <20180409142026.19369-23-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-1-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Generic helper function that checks if there are buffers in
the request and if so, prepares and queues all objects in the
request.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 39 +++++++++++++++++++++++++
 include/media/videobuf2-v4l2.h                  |  3 ++
 2 files changed, 42 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 73c1fd4da58a..3d0c74bb4220 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -1061,6 +1061,45 @@ void vb2_ops_wait_finish(struct vb2_queue *vq)
 }
 EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
 
+int vb2_request_queue(struct media_request *req)
+{
+	struct media_request_object *obj;
+	struct media_request_object *failed_obj = NULL;
+	int ret = 0;
+
+	if (!vb2_core_request_has_buffers(req))
+		return -ENOENT;
+
+	list_for_each_entry(obj, &req->objects, list) {
+		if (!obj->ops->prepare)
+			continue;
+
+		ret = obj->ops->prepare(obj);
+
+		if (ret) {
+			failed_obj = obj;
+			break;
+		}
+	}
+
+	if (ret) {
+		list_for_each_entry(obj, &req->objects, list) {
+			if (obj == failed_obj)
+				break;
+			if (obj->ops->unprepare)
+				obj->ops->unprepare(obj);
+		}
+		return ret;
+	}
+
+	list_for_each_entry(obj, &req->objects, list) {
+		if (obj->ops->queue)
+			obj->ops->queue(obj);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_request_queue);
+
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
 MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index cf312ab4e7e8..0baa3023d7ad 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -301,4 +301,7 @@ void vb2_ops_wait_prepare(struct vb2_queue *vq);
  */
 void vb2_ops_wait_finish(struct vb2_queue *vq);
 
+struct media_request;
+int vb2_request_queue(struct media_request *req);
+
 #endif /* _MEDIA_VIDEOBUF2_V4L2_H */
-- 
2.16.3
