Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36417 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753234AbeC1OBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 10:01:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 23/29] videobuf2-v4l2: add vb2_request_queue helper
Date: Wed, 28 Mar 2018 16:01:34 +0200
Message-Id: <20180328140140.42096-7-hverkuil@xs4all.nl>
In-Reply-To: <20180328140140.42096-1-hverkuil@xs4all.nl>
References: <20180328140140.42096-1-hverkuil@xs4all.nl>
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
index d3ea5ec697a6..ebb951db7a8f 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -1054,6 +1054,45 @@ void vb2_ops_wait_finish(struct vb2_queue *vq)
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
2.15.1
