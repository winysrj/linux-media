Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:43877 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753100AbeC1OBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 10:01:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 22/29] videobuf2-core: add vb2_core_request_has_buffers
Date: Wed, 28 Mar 2018 16:01:33 +0200
Message-Id: <20180328140140.42096-6-hverkuil@xs4all.nl>
In-Reply-To: <20180328140140.42096-1-hverkuil@xs4all.nl>
References: <20180328140140.42096-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new helper function that returns true if a media_request
contains buffers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 12 ++++++++++++
 include/media/videobuf2-core.h                  |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 7499221da1c5..b9d898b116c4 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1333,6 +1333,18 @@ static const struct media_request_object_ops vb2_core_req_ops = {
 	.release = vb2_req_release,
 };
 
+bool vb2_core_request_has_buffers(struct media_request *req)
+{
+	struct media_request_object *obj;
+
+	list_for_each_entry(obj, &req->objects, list) {
+		if (obj->ops == &vb2_core_req_ops)
+			return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(vb2_core_request_has_buffers);
+
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb,
 			 struct media_request *req)
 {
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 72663c2a3ba3..e23dc028aee7 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -1158,4 +1158,6 @@ bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
  */
 int vb2_verify_memory_type(struct vb2_queue *q,
 		enum vb2_memory memory, unsigned int type);
+
+bool vb2_core_request_has_buffers(struct media_request *req);
 #endif /* _MEDIA_VIDEOBUF2_CORE_H */
-- 
2.15.1
