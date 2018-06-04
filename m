Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:49731 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752607AbeFDLrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 23/35] videobuf2-core: add request helper functions
Date: Mon,  4 Jun 2018 13:46:36 +0200
Message-Id: <20180604114648.26159-24-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new helper function to tell if a request object is a buffer.

Add a new helper function that returns true if a media_request
contains at least one buffer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 17 +++++++++++++++++
 include/media/videobuf2-core.h                  | 15 +++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 049822bcdd02..697765e70fbe 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1362,6 +1362,23 @@ static const struct media_request_object_ops vb2_core_req_ops = {
 	.release = vb2_req_release,
 };
 
+bool vb2_request_object_is_buffer(struct media_request_object *obj)
+{
+	return obj->ops == &vb2_core_req_ops;
+}
+EXPORT_SYMBOL_GPL(vb2_request_object_is_buffer);
+
+bool vb2_request_has_buffers(struct media_request *req)
+{
+	struct media_request_object *obj;
+
+	list_for_each_entry(obj, &req->objects, list)
+		if (vb2_request_object_is_buffer(obj))
+			return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(vb2_request_has_buffers);
+
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 8a8d7732d182..cad712403d14 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -1168,4 +1168,19 @@ bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
  */
 int vb2_verify_memory_type(struct vb2_queue *q,
 		enum vb2_memory memory, unsigned int type);
+
+/**
+ * vb2_request_object_is_buffer() - return true if the object is a buffer
+ *
+ * @obj:	the request object.
+ */
+bool vb2_request_object_is_buffer(struct media_request_object *obj);
+
+/**
+ * vb2_request_has_buffers() - return true if the request contains buffers
+ *
+ * @req:	the request.
+ */
+bool vb2_request_has_buffers(struct media_request *req);
+
 #endif /* _MEDIA_VIDEOBUF2_CORE_H */
-- 
2.17.0
