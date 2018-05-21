Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:57494 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbeEUIzU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v14 27/36] videobuf2-v4l2: add vb2_request_queue/validate helpers
Date: Mon, 21 May 2018 11:54:52 +0300
Message-Id: <20180521085501.16861-28-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
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
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 38 +++++++++++++++++++++++++
 include/media/videobuf2-v4l2.h                  |  4 +++
 2 files changed, 42 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 8b390960ca671..ff228334d4418 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -1079,6 +1079,44 @@ void vb2_ops_wait_finish(struct vb2_queue *vq)
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
index 91a2b3e1a642a..727855463838c 100644
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
2.11.0
