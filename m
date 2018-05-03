Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:58932 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751511AbeECOx2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 10:53:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv13 21/28] v4l2-mem2mem: add vb2_m2m_request_queue
Date: Thu,  3 May 2018 16:53:11 +0200
Message-Id: <20180503145318.128315-22-hverkuil@xs4all.nl>
In-Reply-To: <20180503145318.128315-1-hverkuil@xs4all.nl>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For mem2mem devices we have to make sure that v4l2_m2m_try_schedule()
is called whenever a request is queued.

We do that by creating a vb2_m2m_request_queue() helper that should
be used instead of the 'normal' vb2_request_queue() helper. The m2m
helper function will call v4l2_m2m_try_schedule() as needed.

In addition we also avoid calling v4l2_m2m_try_schedule() when preparing
or queueing a buffer for a request since that is no longer needed.
Instead this helper function will do that when the request is actually
queued.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 33 ++++++++++++++++++++++++--
 include/media/v4l2-mem2mem.h           |  4 ++++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 438f1b869319..80233bf6523a 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -395,7 +395,7 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = vb2_qbuf(vq, vdev->v4l2_dev->mdev, buf);
-	if (!ret)
+	if (!ret && !(buf->flags & V4L2_BUF_FLAG_IN_REQUEST))
 		v4l2_m2m_try_schedule(m2m_ctx);
 
 	return ret;
@@ -421,7 +421,7 @@ int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = vb2_prepare_buf(vq, vdev->v4l2_dev->mdev, buf);
-	if (!ret)
+	if (!ret && !(buf->flags & V4L2_BUF_FLAG_IN_REQUEST))
 		v4l2_m2m_try_schedule(m2m_ctx);
 
 	return ret;
@@ -701,6 +701,35 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);
 
+void vb2_m2m_request_queue(struct media_request *req)
+{
+	struct media_request_object *obj;
+
+	list_for_each_entry(obj, &req->objects, list) {
+		struct v4l2_m2m_ctx *m2m_ctx;
+		struct vb2_buffer *vb;
+
+		if (!obj->ops->queue)
+			continue;
+
+		obj->ops->queue(obj);
+		if (!vb2_request_object_is_buffer(obj))
+			continue;
+
+		vb = container_of(obj, struct vb2_buffer, req_obj);
+		if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type))
+			m2m_ctx = container_of(vb->vb2_queue,
+					       struct v4l2_m2m_ctx,
+					       out_q_ctx.q);
+		else
+			m2m_ctx = container_of(vb->vb2_queue,
+					       struct v4l2_m2m_ctx,
+					       cap_q_ctx.q);
+		v4l2_m2m_try_schedule(m2m_ctx);
+	}
+}
+EXPORT_SYMBOL_GPL(vb2_m2m_request_queue);
+
 /* Videobuf2 ioctl helpers */
 
 int v4l2_m2m_ioctl_reqbufs(struct file *file, void *priv,
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 3d07ba3a8262..f01b3fc13b0e 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -580,6 +580,10 @@ v4l2_m2m_dst_buf_remove_by_idx(struct v4l2_m2m_ctx *m2m_ctx, unsigned int idx)
 	return v4l2_m2m_buf_remove_by_idx(&m2m_ctx->cap_q_ctx, idx);
 }
 
+/* v4l2 request helper */
+
+void vb2_m2m_request_queue(struct media_request *req);
+
 /* v4l2 ioctl helpers */
 
 int v4l2_m2m_ioctl_reqbufs(struct file *file, void *priv,
-- 
2.17.0
